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

  @override
  Future<StreakState> build() async {
    final authUser = ref.watch(authControllerProvider);
    final streakStorage = ref.watch(streakStorageProvider(authUser?.user.id));
    final activeStreak = await streakStorage.loadActiveStreak();

    if (activeStreak != null) {
      final [puzzle, nextPuzzle] = await Future.wait([
        _fetchPuzzle(activeStreak.streak[activeStreak.index]),
        if (activeStreak.nextId != null) _fetchPuzzle(activeStreak.nextId!) else Future.value(null),
      ]);

      if (puzzle == null) {
        throw Exception('Could not load puzzle for active streak');
      }

      return (streak: activeStreak, puzzle: puzzle, nextPuzzle: nextPuzzle);
    }

    final repository = ref.read(puzzleRepositoryProvider);
    final newStreak = await repository.streak();

    // Index 0 arrives embedded in /api/streak, so save it explicitly to allow
    // resuming offline at index 0.
    final storage = await ref.read(puzzleStorageProvider.future);
    await storage.save(puzzle: newStreak.puzzle);

    final nextPuzzle = newStreak.streak.length > 1 ? await _fetchPuzzle(newStreak.streak[1]) : null;

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
    if (!state.hasValue || state.requireValue.nextPuzzle == null) {
      return;
    }
    ref.read(soundServiceProvider).play(Sound.confirmation);

    state = AsyncData((
      streak: state.requireValue.streak.copyWith(index: state.requireValue.streak.index + 1),
      puzzle: state.requireValue.nextPuzzle!,
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
    ref.read(streakStorageProvider(userId)).clearActiveStreak();

    if (userId != null) {
      final streak = state.requireValue.streak.index;
      if (streak > 0) {
        await ref.read(puzzleRepositoryProvider).postStreakRun(streak);
      }
    }
  }
}
