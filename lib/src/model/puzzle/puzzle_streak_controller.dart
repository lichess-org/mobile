import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_streak.dart';
import 'package:lichess_mobile/src/model/puzzle/streak_storage.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';

/// [PuzzleStreak] with its current [Puzzle].
typedef StreakState = ({PuzzleStreak streak, Puzzle puzzle, Puzzle? nextPuzzle});

/// Outcome of [PuzzleStreakController.next].
enum StreakAdvance {
  /// Advanced to the next puzzle.
  advanced,

  /// The next puzzle could not be loaded — typically offline with no cached successor. The streak
  /// stays on the solved puzzle; the advance is retried automatically when connectivity returns
  /// (see [PuzzleStreakController.build]).
  unavailable,

  /// The streak has no further puzzle to advance to (end reached).
  endOfStreak,

  /// The controller was disposed while loading the next puzzle; nothing happened.
  aborted,
}

final puzzleStreakControllerProvider =
    AsyncNotifierProvider.autoDispose<PuzzleStreakController, StreakState>(
      PuzzleStreakController.new,
      name: 'PuzzleStreakControllerProvider',
    );

class PuzzleStreakController extends AsyncNotifier<StreakState> {
  /// How many puzzles ahead of the current one to keep in the local cache.
  ///
  /// Stays under [maxPuzzlesPerFetch] so a refill is always a single batch request.
  static const _prefetchWindow = 30;

  /// Refill the look-ahead buffer when fewer than this many warmed puzzles remain.
  static const _prefetchMargin = 10;

  /// Set when a win could not advance the streak because the next puzzle wasn't available offline.
  /// The streak is paused on the solved puzzle; reconnecting retries the advance (see [build]).
  bool _advancePending = false;

  /// Exclusive end of the streak window that [_prefetchUpcoming] has warmed.
  int _warmedUpTo = 0;

  /// Set when a look-ahead refill failed outright (offline, rate limited, or a server error).
  ///
  /// Without it a refill would be retried on *every* advance for the rest of the run, because a
  /// failure deliberately leaves [_warmedUpTo] where it was, which keeps the margin check in
  /// [_advance] true forever — one full window request per solved puzzle, with no back-off.
  /// Cleared when connectivity returns or a new streak starts, the only signals that the cause may
  /// have gone away. Play is unaffected in the meantime: [_advance] still falls back to a single
  /// `/api/puzzle/{id}` fetch, which is not rate limited.
  bool _prefetchStalled = false;

  /// Streak index of the first id a refill asked for and did not get back, or null.
  ///
  /// A refill whose window starts at or before it would just re-request an id the server has
  /// already declined to serve, so those are skipped; once the streak has moved past the hole the
  /// look-ahead resumes normally for the window beyond it.
  int? _prefetchHoleAt;

  bool _flushing = false;

  /// User whose pending score is being posted right now, if any.
  ///
  /// The guard is per user rather than global: two flushes for the *same* user would post the same
  /// pending run twice, which the server counts as two runs in the activity feed, while a flush for
  /// a different user (a sign-in change while one is in flight) must not be blocked by it.
  UserId? _flushingFor;

  /// Identifies the current streak session. [build] bumps it on every new streak so a refill
  /// still in flight for the previous one cannot publish its window over the new [_warmedUpTo],
  /// nor block the new streak's own refill.
  int _session = 0;

  /// The session a look-ahead refill is in flight for, or null when idle.
  ///
  /// [build], [next] and the reconnect listener can all ask for a refill, and two concurrent runs
  /// within one streak would read the same cache state and request the same missing ids twice —
  /// wasted rate limit budget for an anonymous session. Overlapping asks are therefore dropped;
  /// the margin check in [_advance] asks again as the streak progresses. A refill for a *new*
  /// streak is never dropped, because a run left over from the previous streak warms the wrong
  /// ids and would leave the new streak unplayable offline.
  int? _prefetchingSession;

  /// Guards [next] against re-entrancy. Connectivity can flap while an advance is awaiting its
  /// fetch, and the reconnect listener would then start a second advance for the same puzzle:
  /// both would land, moving the streak index twice for a single solve.
  bool _advancing = false;

  /// Loads the puzzle from the local cache, falling back to the network on a miss (caching the
  /// result). Returns null if both fail, e.g. offline.
  ///
  /// Also used by the streak screen to review already-solved puzzles.
  Future<Puzzle?> fetchPuzzle(PuzzleId id) async {
    try {
      final storage = await ref.read(puzzleStorageProvider.future);

      Puzzle? cached;
      try {
        cached = await storage.fetch(puzzleId: id);
      } catch (_) {
        // Corrupt row: ignore and re-fetch, overwriting it below.
        cached = null;
      }
      if (cached != null) {
        return cached;
      }

      final puzzle = await ref.read(puzzleRepositoryProvider).fetch(id);
      // Caching is best-effort: a save failure must NOT discard the puzzle we successfully
      // fetched, or build()/next() would spuriously report the puzzle as unavailable on a
      // transient DB write error while actually online.
      try {
        await storage.save(puzzle: puzzle);
      } catch (_) {
        // Ignore: the puzzle is returned uncached.
      }
      return puzzle;
    } catch (_) {
      return null;
    }
  }

  /// Warms the local cache with the next [_prefetchWindow] puzzles from [startIndex] so the streak
  /// can continue offline, fetching the ones that are not cached yet in a single
  /// `/api/puzzle/many` request.
  ///
  /// Best-effort and fire-and-forget: failures (offline, or an anonymous session hitting the
  /// endpoint's rate limit) are swallowed and the fetch is retried on the next advance or on
  /// reconnect (see [next] and [build]). The single-puzzle look-ahead that [build] and [next] keep
  /// cached still rides out a brief drop if the buffer could not be warmed.
  Future<void> _prefetchUpcoming(Streak streak, int startIndex) async {
    final session = _session;
    final endIndex = min(startIndex + _prefetchWindow, streak.length);
    if (startIndex >= endIndex) return;
    if (_prefetchStalled) return;
    if (_prefetchHoleAt case final hole? when startIndex <= hole) return;
    if (_prefetchingSession == session) return;
    _prefetchingSession = session;

    try {
      final repository = ref.read(puzzleRepositoryProvider);
      final storage = await ref.read(puzzleStorageProvider.future);

      final window = streak.sublist(startIndex, endIndex);
      final cached = await storage.cachedPuzzleIds(ids: window);
      var warmed = cached;

      final missing = window.where((id) => !cached.contains(id)).toIList();
      if (missing.isNotEmpty) {
        final fetched = await repository.fetchMany(missing);
        await storage.saveAll(puzzles: fetched);
        warmed = warmed.addAll(fetched.map((puzzle) => puzzle.puzzle.id));
      }
      // A new streak started while this refill was in flight: [_warmedUpTo] now counts against
      // that streak's indices, so this window must not advance it.
      if (session != _session) return;

      // `/api/puzzle/many` silently drops ids it cannot serve, so a 200 can come back short — not
      // only for an unknown id, but for a valid one whose game the server failed to read. Marking
      // the whole window warmed would promise an offline run that then stalls dead in the middle
      // of it, and the hole would never be re-requested because windows only ever move forward.
      // So only warm up to the first id we do not actually hold.
      final gap = window.indexWhere((id) => !warmed.contains(id));
      _warmedUpTo = max(_warmedUpTo, gap == -1 ? endIndex : startIndex + gap);
      _prefetchHoleAt = gap == -1 ? null : startIndex + gap;
    } catch (_) {
      // Best-effort: e.g. offline. [_warmedUpTo] is left as is so the window is requested again
      // once the stall is lifted.
      if (session == _session) _prefetchStalled = true;
    } finally {
      // Only release the slot if a newer streak has not already claimed it.
      if (_prefetchingSession == session) _prefetchingSession = null;
    }
  }

  /// Posts a streak run that was saved while offline (see [gameOver]) and clears it on success. A
  /// failure leaves the score in place to retry later.
  Future<void> _flushPendingScore(StreakStorage storage, UserId? userId) async {
    if (_flushing && _flushingFor == userId) return;
    _flushing = true;
    _flushingFor = userId;
    try {
      final pending = await storage.loadPendingScore();
      if (pending == null) return;
      await ref.read(puzzleRepositoryProvider).postStreakRun(pending);
      await storage.clearPendingScore();
    } catch (_) {
      // Still offline; keep the pending score for the next attempt.
    } finally {
      // Only release the slot if a flush for another user has not already claimed it.
      if (_flushingFor == userId) {
        _flushing = false;
        _flushingFor = null;
      }
    }
  }

  @override
  Future<StreakState> build() async {
    final authUser = ref.watch(authControllerProvider);
    final streakStorage = ref.watch(streakStorageProvider(authUser?.user.id));

    // build() starts a fresh streak session (first load, sign-in change or new streak after game
    // over), so reset the per-session bookkeeping.
    _session++;
    _advancePending = false;
    _warmedUpTo = 0;
    _prefetchStalled = false;
    _prefetchHoleAt = null;

    // Best-effort: post any streak score that couldn't be sent while offline.
    if (authUser != null) {
      _flushPendingScore(streakStorage, authUser.user.id).ignore();
    }

    // On reconnect (the game-over or live screen may still be open): post any pending score,
    // resume a streak that is paused on a solved puzzle whose successor couldn't be fetched
    // offline (see [next]), and top up the look-ahead buffer. The resume path is not gated on
    // auth — anonymous streaks get stuck the same way.
    ref.listen(connectivityChangesProvider, (previous, current) {
      final wasOffline = previous?.value?.isOnline == false;
      final isNowOnline = current.value?.isOnline == true;
      if (!wasOffline || !isNowOnline) return;
      // Connectivity returning is the signal that a blocked look-ahead refill is worth another
      // try — including the ids the server dropped, which may have been a transient read failure.
      _prefetchStalled = false;
      _prefetchHoleAt = null;
      if (authUser != null) {
        _flushPendingScore(streakStorage, authUser.user.id).ignore();
      }
      if (_advancePending) {
        // next() refills the look-ahead buffer once it has advanced.
        next().ignore();
      } else if (state.value case final current?) {
        _prefetchUpcoming(current.streak.streak, current.streak.index + 2).ignore();
      }
    });

    final activeStreak = await streakStorage.loadActiveStreak();

    if (activeStreak != null) {
      final [puzzle, nextPuzzle] = await Future.wait([
        fetchPuzzle(activeStreak.streak[activeStreak.index]),
        if (activeStreak.nextId != null) fetchPuzzle(activeStreak.nextId!) else Future.value(null),
      ]);

      if (puzzle == null) {
        throw Exception('Could not load puzzle for active streak');
      }

      _prefetchUpcoming(activeStreak.streak, activeStreak.index + 2).ignore();

      return (streak: activeStreak, puzzle: puzzle, nextPuzzle: nextPuzzle);
    }

    final repository = ref.read(puzzleRepositoryProvider);
    final newStreak = await repository.streak();

    final streak = PuzzleStreak(
      streak: newStreak.streak,
      index: 0,
      hasSkipped: false,
      finished: false,
      timestamp: newStreak.timestamp,
    );

    // Index 0 arrives embedded in /api/streak: cache it (best-effort) before saving the
    // active-streak pointer, so that a saved pointer always has its current puzzle available
    // locally. Fetching index 1 is independent and runs in parallel.
    final storage = await ref.read(puzzleStorageProvider.future);
    final (_, nextPuzzle) = await (
      storage.save(puzzle: newStreak.puzzle).onError((_, _) {}),
      newStreak.streak.length > 1 ? fetchPuzzle(newStreak.streak[1]) : Future<Puzzle?>.value(),
    ).wait;

    // Save the pointer right away so the streak can be resumed offline even before the first
    // puzzle is solved.
    await streakStorage.saveActiveStreak(streak);

    _prefetchUpcoming(newStreak.streak, 2).ignore();

    return (streak: streak, puzzle: newStreak.puzzle, nextPuzzle: nextPuzzle);
  }

  void skipMove() {
    if (!state.hasValue) return;

    state = AsyncData((
      streak: state.requireValue.streak.copyWith(hasSkipped: true),
      puzzle: state.requireValue.puzzle,
      nextPuzzle: state.requireValue.nextPuzzle,
    ));

    ref
        .read(streakStorageProvider(ref.read(authControllerProvider)?.user.id))
        .saveActiveStreak(state.requireValue.streak);
  }

  /// Advances the streak to the next puzzle.
  ///
  /// Returns [StreakAdvance.advanced] on success and [StreakAdvance.endOfStreak] when there is no
  /// further puzzle. Returns [StreakAdvance.unavailable] when the next puzzle can't be loaded
  /// (offline with no cached successor): the streak stays on the solved puzzle and the advance is
  /// retried automatically once connectivity returns. Returns [StreakAdvance.aborted] when there
  /// is nothing to advance from, or when another advance is already in flight.
  Future<StreakAdvance> next() async {
    if (_advancing) return .aborted;
    _advancing = true;
    try {
      return await _advance();
    } finally {
      _advancing = false;
    }
  }

  Future<StreakAdvance> _advance() async {
    var solvedState = state.value;
    if (solvedState == null) return .aborted;

    // The next puzzle is normally already prefetched into [nextPuzzle]. If it isn't (the offline
    // look-ahead buffer ran dry), try one local-first fetch; if that also misses there is no way
    // to advance right now. The reconnect listener set up in [build] retries the advance when back
    // online.
    var advanceTo = solvedState.nextPuzzle;
    if (advanceTo == null) {
      final solvedIndex = solvedState.streak.index;
      final advanceId = solvedState.streak.nextId;
      if (advanceId == null) return .endOfStreak;
      advanceTo = await fetchPuzzle(advanceId);
      if (!ref.mounted) return .aborted;
      // Re-read the state: it may have changed (e.g. a skip) while fetching.
      solvedState = state.value;
      if (solvedState == null) return .aborted;
      // The streak moved on underneath us (a rebuild started a new run, say), so the puzzle we
      // just fetched is no longer the successor of the current index. Advancing on it would
      // count a puzzle that was never played.
      if (solvedState.streak.index != solvedIndex) return .aborted;
      if (advanceTo == null) {
        _advancePending = true;
        return .unavailable;
      }
    }
    _advancePending = false;

    ref.read(soundServiceProvider).play(Sound.confirmation);

    final advanced = solvedState.streak.copyWith(index: solvedState.streak.index + 1);
    state = AsyncData((streak: advanced, puzzle: advanceTo, nextPuzzle: null));

    final nextId = advanced.nextId;
    if (nextId != null) {
      fetchPuzzle(nextId).then((puzzle) {
        if (puzzle == null || !ref.mounted) return;
        // Don't clobber a state that has moved on while we were fetching.
        if (state.value?.streak.index != advanced.index) return;
        state = AsyncData((
          streak: state.requireValue.streak,
          puzzle: state.requireValue.puzzle,
          nextPuzzle: puzzle,
        ));
      });
    }

    // Keep the offline look-ahead buffer topped up as the streak progresses.
    if (advanced.index + _prefetchMargin >= _warmedUpTo) {
      _prefetchUpcoming(advanced.streak, advanced.index + 2).ignore();
    }

    ref
        .read(streakStorageProvider(ref.read(authControllerProvider)?.user.id))
        .saveActiveStreak(state.requireValue.streak);

    return .advanced;
  }

  Future<void> gameOver() async {
    if (!state.hasValue) return;
    // Finalise once. The screen only calls this on a transition into [PuzzleResult.lose], but it
    // does not await the call, so two rapid transitions would otherwise both post the run.
    if (state.requireValue.streak.finished) return;

    state = AsyncData((
      streak: state.requireValue.streak.copyWith(finished: true),
      puzzle: state.requireValue.puzzle,
      nextPuzzle: state.requireValue.nextPuzzle,
    ));

    final userId = ref.read(authControllerProvider)?.user.id;
    final streakStorage = ref.read(streakStorageProvider(userId));
    await streakStorage.clearActiveStreak();

    if (userId == null) return;

    // The streak index doubles as the run's score: it counts the puzzles already solved.
    final score = state.requireValue.streak.index;
    if (score <= 0) return;

    try {
      await ref.read(puzzleRepositoryProvider).postStreakRun(score);
    } catch (_) {
      // Offline: persist the score so it is posted on reconnect, not lost.
      await streakStorage.savePendingScore(score);
      return;
    }

    // The post landed. A lower-or-equal pending run from a past offline session is now redundant
    // (the server keeps the best score), so drop it; a higher one is still owed.
    //
    // Deliberately outside the try above: those two storage calls run *after* the post has already
    // succeeded, so treating a failure in them as a failed post would persist a score the server
    // has accepted and post it a second time on the next reconnect.
    try {
      final pending = await streakStorage.loadPendingScore();
      if (pending != null && pending <= score) {
        await streakStorage.clearPendingScore();
      }
    } catch (_) {
      // Leave the pending score in place: the next flush re-posts it, which the server folds into
      // the same best score.
    }
  }
}
