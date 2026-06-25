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

  /// Could not load the next puzzle (offline with no cached successor). The
  /// streak stays on the solved puzzle and resumes once back online.
  offline,

  /// The streak has no further puzzle to advance to (end reached).
  endOfStreak,
}

final puzzleStreakControllerProvider =
    AsyncNotifierProvider.autoDispose<PuzzleStreakController, StreakState>(
      PuzzleStreakController.new,
      name: 'PuzzleStreakControllerProvider',
    );

class PuzzleStreakController extends AsyncNotifier<StreakState> {
  /// Reads the puzzle from the SQLite cache, falling back to the network on a
  /// miss (caching the result). Returns null if both miss, e.g. offline.
  Future<Puzzle?> _fetchPuzzle(PuzzleId id) async {
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
      // successfully fetched, or build()/next() would spuriously report
      // "offline" on a transient DB write error while actually online.
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

  /// Caches the upcoming puzzles so the streak can be played offline.
  ///
  /// Fire-and-forget on an autoDispose notifier, so [ref] is captured before the
  /// async loop and never touched again: the notifier may be disposed mid-flight
  /// but writes through the captured storage stay valid.
  Future<void> _prefetchUpcoming(Streak streak, int startIndex) async {
    // `/api/puzzle/many` caps each request at 50 ids server-side, so a single
    // windowed request warms the whole look-ahead buffer.
    const prefetchCount = 30;

    final endIndex = (startIndex + prefetchCount).clamp(0, streak.length);
    if (startIndex >= endIndex) return;

    final repository = ref.read(puzzleRepositoryProvider);
    final storage = await ref.read(puzzleStorageProvider.future);

    // Request only the ids that aren't cached yet.
    final missing = <PuzzleId>[];
    for (final id in streak.sublist(startIndex, endIndex)) {
      try {
        if (await storage.fetch(puzzleId: id) != null) continue;
      } catch (_) {
        // Corrupt row: fall through to re-fetch and overwrite it.
      }
      missing.add(id);
    }
    if (missing.isEmpty) return;

    try {
      final puzzles = await repository.fetchMany(missing.toIList());
      for (final puzzle in puzzles) {
        try {
          await storage.save(puzzle: puzzle);
        } catch (_) {
          // Best-effort: ignore individual save failures.
        }
      }
    } catch (_) {
      // Best-effort: ignore fetch failures (e.g. offline).
    }
  }

  bool _flushing = false;

  /// Posts a streak run that was saved while offline (see [gameOver]) and clears
  /// it on success. A failure leaves the score in place to retry later.
  Future<void> _flushPendingScore(StreakStorage storage) async {
    if (_flushing) return;
    _flushing = true;
    try {
      final pending = await storage.loadPendingScore();
      if (pending == null) return;
      await ref.read(puzzleRepositoryProvider).postStreakRun(pending);
      await storage.clearPendingScore();
    } catch (_) {
      // Still offline; keep the pending score for the next attempt.
    } finally {
      _flushing = false;
    }
  }

  /// Local-first fetch of an already-solved puzzle, for history review.
  Future<Puzzle?> fetchPuzzleForReview(PuzzleId id) => _fetchPuzzle(id);

  @override
  Future<StreakState> build() async {
    final authUser = ref.watch(authControllerProvider);
    final streakStorage = ref.watch(streakStorageProvider(authUser?.user.id));

    // Best-effort: post any streak score that couldn't be sent while offline.
    // Like the tactics queue, this syncs opportunistically whenever the
    // controller (re)builds; a failure leaves the score saved to retry later.
    if (authUser != null) {
      _flushPendingScore(streakStorage).ignore();
    }

    final activeStreak = await streakStorage.loadActiveStreak();

    if (activeStreak != null) {
      final [puzzle, nextPuzzle] = await Future.wait([
        _fetchPuzzle(activeStreak.streak[activeStreak.index]),
        if (activeStreak.nextId != null) _fetchPuzzle(activeStreak.nextId!) else Future.value(null),
      ]);

      if (puzzle == null) {
        throw Exception('Could not load puzzle for active streak');
      }

      _prefetchUpcoming(activeStreak.streak, activeStreak.index + 2).ignore();

      return (streak: activeStreak, puzzle: puzzle, nextPuzzle: nextPuzzle);
    }

    final repository = ref.read(puzzleRepositoryProvider);
    final newStreak = await repository.streak();

    // Index 0 arrives embedded in /api/streak, so save it explicitly to allow
    // resuming offline at index 0.
    final storage = await ref.read(puzzleStorageProvider.future);
    await storage.save(puzzle: newStreak.puzzle);

    final nextPuzzle = newStreak.streak.length > 1 ? await _fetchPuzzle(newStreak.streak[1]) : null;

    _prefetchUpcoming(newStreak.streak, 2).ignore();

    return (
      streak: PuzzleStreak(
        streak: newStreak.streak,
        index: 0,
        hasSkipped: false,
        finished: false,
        timestamp: newStreak.timestamp,
      ),
      puzzle: newStreak.puzzle,
      nextPuzzle: nextPuzzle,
    );
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

  /// Advance the streak to the next puzzle.
  ///
  /// Returns [StreakAdvance.advanced] on success. Returns [StreakAdvance.offline]
  /// when the next puzzle can't be loaded (offline with no cached successor) so
  /// the caller can tell the user, and [StreakAdvance.endOfStreak] when there is
  /// no further puzzle.
  Future<StreakAdvance> next() async {
    if (!state.hasValue) return StreakAdvance.endOfStreak;

    final currentState = state.requireValue;

    // The next puzzle is normally already prefetched into [nextPuzzle]. If it
    // isn't (the offline prefetch buffer ran dry), try one local-first fetch.
    // If that also misses we're genuinely offline with no cached successor, so
    // we simply can't advance: stay on the solved puzzle. The active streak is
    // saved, so it resumes the next time the buffer refills online — mirroring
    // how the tactics queue degrades when it empties offline.
    var advanceTo = currentState.nextPuzzle;
    if (advanceTo == null) {
      final advanceId = currentState.streak.nextId;
      if (advanceId == null) return StreakAdvance.endOfStreak;
      advanceTo = await _fetchPuzzle(advanceId);
      if (!ref.mounted) return StreakAdvance.offline;
      if (advanceTo == null) return StreakAdvance.offline;
    }

    ref.read(soundServiceProvider).play(Sound.confirmation);

    state = AsyncData((
      streak: currentState.streak.copyWith(index: currentState.streak.index + 1),
      puzzle: advanceTo,
      nextPuzzle: null,
    ));

    final nextId = state.requireValue.streak.nextId;
    if (nextId != null) {
      final expectedIndex = state.requireValue.streak.index;
      _fetchPuzzle(nextId).then((puzzle) {
        if (!ref.mounted) return;
        if (!state.hasValue || state.requireValue.streak.index != expectedIndex) return;
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

    return StreakAdvance.advanced;
  }

  Future<void> gameOver() async {
    if (!state.hasValue) return;

    state = AsyncData((
      streak: state.requireValue.streak.copyWith(finished: true),
      puzzle: state.requireValue.puzzle,
      nextPuzzle: state.requireValue.nextPuzzle,
    ));

    final userId = ref.read(authControllerProvider)?.user.id;
    final streakStorage = ref.read(streakStorageProvider(userId));
    await streakStorage.clearActiveStreak();

    if (userId != null) {
      final streak = state.requireValue.streak.index;
      if (streak > 0) {
        try {
          await ref.read(puzzleRepositoryProvider).postStreakRun(streak);
          // A lower-or-equal pending run from a past offline session is now
          // redundant (the server keeps the best); a higher one is still owed.
          final pending = await streakStorage.loadPendingScore();
          if (pending != null && pending <= streak) {
            await streakStorage.clearPendingScore();
          }
        } catch (_) {
          // Offline: persist the score so it is posted on reconnect, not lost.
          await streakStorage.savePendingScore(streak);
        }
      }
    }
  }
}
