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
import 'package:lichess_mobile/src/tab_scaffold.dart' show currentNavigatorKeyProvider;
import 'package:lichess_mobile/src/widgets/feedback.dart';

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
      await storage.save(puzzle: puzzle);
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
    const prefetchCount = 30;
    const batchSize = 5;

    final endIndex = (startIndex + prefetchCount).clamp(0, streak.length);
    if (startIndex >= endIndex) return;
    final idsToFetch = streak.sublist(startIndex, endIndex);

    final repository = ref.read(puzzleRepositoryProvider);
    final storage = await ref.read(puzzleStorageProvider.future);

    for (var i = 0; i < idsToFetch.length; i += batchSize) {
      final batchEnd = (i + batchSize).clamp(0, idsToFetch.length);
      final batchIds = idsToFetch.sublist(i, batchEnd);

      await Future.wait(
        batchIds.map((id) async {
          try {
            if (await storage.fetch(puzzleId: id) != null) return;
          } catch (_) {
            // Corrupt row: fall through to re-fetch.
          }
          try {
            final puzzle = await repository.fetch(id);
            await storage.save(puzzle: puzzle);
          } catch (_) {
            // Best-effort: ignore failures.
          }
        }),
      );
    }
  }

  /// Shows a snackbar via the root navigator, if one is available.
  void _showStreakSnackBar(String message, {SnackBarType type = SnackBarType.info}) {
    try {
      final context = ref.read(currentNavigatorKeyProvider).currentContext;
      if (context != null && context.mounted) {
        showSnackBar(context, message, type: type);
      }
    } catch (_) {
      // No navigator/binding available (e.g. in tests); nothing to show.
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

  @override
  Future<StreakState> build() async {
    final authUser = ref.watch(authControllerProvider);
    final streakStorage = ref.watch(streakStorageProvider(authUser?.user.id));

    // Flush any score that couldn't be posted while offline (logged-in only).
    if (authUser != null) {
      _flushPendingScore(streakStorage).ignore();

      // Retry on reconnect while the game-over screen is still open.
      ref.listen(connectivityChangesProvider, (previous, current) {
        final wasOffline = previous?.value?.isOnline == false;
        final isNowOnline = current.value?.isOnline == true;
        if (wasOffline && isNowOnline) {
          _flushPendingScore(streakStorage).ignore();
        }
      });
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
  Future<void> next() async {
    if (!state.hasValue) return;

    final currentState = state.requireValue;

    // The next puzzle is normally prefetched; if not (offline buffer exhausted),
    // fetch it inline so a reconnected player resumes automatically. If that
    // fails too, stay put and tell the player.
    var advanceTo = currentState.nextPuzzle;
    if (advanceTo == null) {
      final advanceId = currentState.streak.nextId;
      if (advanceId == null) return;
      advanceTo = await _fetchPuzzle(advanceId);
      if (!ref.mounted) return;
      if (advanceTo == null) {
        _showStreakSnackBar("You're offline — reconnect to continue your streak.");
        return;
      }
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
    streakStorage.clearActiveStreak();

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
