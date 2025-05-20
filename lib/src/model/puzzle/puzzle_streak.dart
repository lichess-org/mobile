import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/model/puzzle/streak_storage.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart' show currentNavigatorKeyProvider;
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

@riverpod
class PuzzleStreakController extends _$PuzzleStreakController {
  @override
  Future<StreakState> build() async {
    final session = ref.watch(authSessionProvider);
    final streakStorage = ref.watch(streakStorageProvider(session?.user.id));
    final activeStreak = await streakStorage.loadActiveStreak();
    if (activeStreak != null) {
      final puzzle = await ref.read(puzzleProvider(activeStreak.streak[activeStreak.index]).future);
      final nextPuzzle =
          activeStreak.nextId != null
              ? await ref.read(puzzleProvider(activeStreak.nextId!).future)
              : null;

      return (streak: activeStreak, puzzle: puzzle, nextPuzzle: nextPuzzle);
    }

    final newStreak = await ref.withClient((client) => PuzzleRepository(client).streak());
    final nextPuzzle = await ref.withClient(
      (client) => PuzzleRepository(client).fetch(newStreak.streak[1]),
    );

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
      ref
          .withClient(
            (client) => PuzzleRepository(client).fetch(nextId).then((puzzle) {
              state = AsyncData((
                streak: state.requireValue.streak,
                puzzle: state.requireValue.puzzle,
                nextPuzzle: puzzle,
              ));
            }),
          )
          .catchError((_) {
            // ignore: avoid_manual_providers_as_generated_provider_dependency
            final currentContext = ref.read(currentNavigatorKeyProvider).currentContext;
            if (currentContext != null && currentContext.mounted) {
              showSnackBar(currentContext, 'Error loading next puzzle', type: SnackBarType.error);
            }
          });
    }

    ref
        .read(streakStorageProvider(ref.read(authSessionProvider)?.user.id))
        .saveActiveStreak(state.requireValue.streak);
  }

  Future<void> gameOver() async {
    if (!state.hasValue) return;

    state = AsyncData((
      streak: state.requireValue.streak.copyWith(finished: true),
      puzzle: state.requireValue.puzzle,
      nextPuzzle: state.requireValue.nextPuzzle,
    ));

    final userId = ref.read(authSessionProvider)?.user.id;
    ref.read(streakStorageProvider(userId)).clearActiveStreak();

    if (userId != null) {
      final streak = state.requireValue.streak.index;
      if (streak > 0) {
        await ref.withClient((client) => PuzzleRepository(client).postStreakRun(streak));
      }
    }
  }
}
