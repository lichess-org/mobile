import 'package:async/async.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    hide Tuple2;

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/user_session.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_batch_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';

part 'puzzle_providers.g.dart';

@riverpod
Future<PuzzleContext?> nextPuzzle(
  NextPuzzleRef ref,
  PuzzleTheme theme,
) async {
  final session = ref.watch(userSessionStateProvider);
  final puzzleService = ref.watch(defaultPuzzleServiceProvider);
  final accountRepo = ref.watch(accountRepositoryProvider);
  final userId = session?.user.id;
  final account =
      session != null ? await accountRepo.getProfile() : Result.value(null);
  final nextContext = await puzzleService.nextPuzzle(
    userId: userId,
    angle: theme,
  );
  return account.fold(
    (a) {
      final perf = a?.perfs.get(Perf.puzzle);
      if (perf != null) {
        return nextContext?.copyWith(
          glicko: PuzzleGlicko(
            rating: perf.rating.toDouble(),
            deviation: perf.ratingDeviation.toDouble(),
          ),
        );
      } else {
        return nextContext;
      }
    },
    (_, __) => nextContext,
  );
}

@riverpod
Future<Puzzle> dailyPuzzle(DailyPuzzleRef ref) {
  final repo = ref.watch(puzzleRepositoryProvider);
  return Result.release(repo.daily());
}

@riverpod
Future<ISet<PuzzleTheme>> savedThemes(SavedThemesRef ref) {
  final session = ref.watch(userSessionStateProvider);
  final storage = ref.watch(puzzleBatchStorageProvider);
  return storage.fetchSavedThemes(userId: session?.user.id);
}
