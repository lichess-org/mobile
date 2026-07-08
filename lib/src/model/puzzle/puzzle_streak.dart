import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/streak_storage.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';

part 'puzzle_streak.freezed.dart';
part 'puzzle_streak.g.dart';

typedef Streak = IList<PuzzleId>;

@Freezed(fromJson: true, toJson: true)
sealed class PuzzleStreak with _$PuzzleStreak {
  const PuzzleStreak._();

  const factory PuzzleStreak({
    required Streak streak,
    required int index,
    required bool hasSkipped,
    required bool finished,
    required DateTime timestamp,
  }) = _PuzzleStreak;

  PuzzleId? get nextId => streak.getOrNull(index + 1);

  factory PuzzleStreak.fromJson(Map<String, dynamic> json) => _$PuzzleStreakFromJson(json);
}

/// [PuzzleStreak] with its current [Puzzle].
typedef StreakState = ({PuzzleStreak streak, Puzzle puzzle, Puzzle? nextPuzzle});

/// Outcome of [PuzzleStreakController.next].
enum StreakAdvance {
  /// Advanced to the next puzzle.
  advanced,

  /// The next puzzle could not be loaded — typically offline with no cached
  /// successor. The streak stays on the solved puzzle; the advance is retried
  /// automatically when connectivity returns (see [PuzzleStreakController.build]).
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
  /// Set when a win could not advance the streak because the next puzzle wasn't
  /// available offline. The streak is paused on the solved puzzle; reconnecting
  /// retries the advance (see [build]).
  bool _advancePending = false;

  /// Loads the puzzle from the local cache, falling back to the network on a
  /// miss (caching the result). Returns null if both fail, e.g. offline.
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
      // Caching is best-effort: a save failure must NOT discard the puzzle we
      // successfully fetched, or build()/next() would spuriously report the
      // puzzle as unavailable on a transient DB write error while actually
      // online.
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

  @override
  Future<StreakState> build() async {
    final authUser = ref.watch(authControllerProvider);
    final streakStorage = ref.watch(streakStorageProvider(authUser?.user.id));

    // build() starts a fresh streak session (first load, sign-in change or new
    // streak after game over), so reset the per-session bookkeeping.
    _advancePending = false;

    // On reconnect (the screen may still be open): resume a streak that is
    // paused on a solved puzzle whose successor couldn't be fetched offline
    // (see [next]).
    ref.listen(connectivityChangesProvider, (previous, current) {
      final wasOffline = previous?.value?.isOnline == false;
      final isNowOnline = current.value?.isOnline == true;
      if (!wasOffline || !isNowOnline) return;
      if (_advancePending) {
        next().ignore();
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

    // Index 0 arrives embedded in /api/streak: cache it (best-effort) before
    // saving the active-streak pointer, so that a saved pointer always has its
    // current puzzle available locally. Fetching index 1 is independent and
    // runs in parallel.
    final storage = await ref.read(puzzleStorageProvider.future);
    final (_, nextPuzzle) = await (
      storage.save(puzzle: newStreak.puzzle).onError((_, _) {}),
      newStreak.streak.length > 1 ? fetchPuzzle(newStreak.streak[1]) : Future<Puzzle?>.value(),
    ).wait;

    // Save the pointer right away so the streak can be resumed offline even
    // before the first puzzle is solved.
    await streakStorage.saveActiveStreak(streak);

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
  /// Returns [StreakAdvance.advanced] on success and [StreakAdvance.endOfStreak]
  /// when there is no further puzzle. Returns [StreakAdvance.unavailable] when
  /// the next puzzle can't be loaded (offline with no cached successor): the
  /// streak stays on the solved puzzle and the advance is retried automatically
  /// once connectivity returns.
  Future<StreakAdvance> next() async {
    var solvedState = state.value;
    if (solvedState == null) return .endOfStreak;

    // The next puzzle is normally already prefetched into [nextPuzzle]. If it
    // isn't, try one local-first fetch; if that also misses there is no way to
    // advance right now. The reconnect listener set up in [build] retries the
    // advance when back online.
    var advanceTo = solvedState.nextPuzzle;
    if (advanceTo == null) {
      final advanceId = solvedState.streak.nextId;
      if (advanceId == null) return .endOfStreak;
      advanceTo = await fetchPuzzle(advanceId);
      if (!ref.mounted) return .aborted;
      // Re-read the state: it may have changed (e.g. a skip) while fetching.
      solvedState = state.value;
      if (solvedState == null) return .aborted;
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

    ref
        .read(streakStorageProvider(ref.read(authControllerProvider)?.user.id))
        .saveActiveStreak(state.requireValue.streak);

    return .advanced;
  }

  Future<void> gameOver() async {
    if (!state.hasValue) return;

    state = AsyncData((
      streak: state.requireValue.streak.copyWith(finished: true),
      puzzle: state.requireValue.puzzle,
      nextPuzzle: state.requireValue.nextPuzzle,
    ));

    final userId = ref.read(authControllerProvider)?.user.id;
    ref.read(streakStorageProvider(userId)).clearActiveStreak();

    if (userId != null) {
      final streak = state.requireValue.streak.index;
      if (streak > 0) {
        await ref.read(puzzleRepositoryProvider).postStreakRun(streak);
      }
    }
  }
}
