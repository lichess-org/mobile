import 'package:dartchess/dartchess.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_list_tile_providers.g.dart';

@riverpod
Future<OptionsAndPgn> archivedGameAnalysis(
  ArchivedGameAnalysisRef ref, {
  required GameId id,
  required Side orientation,
}) async {
  final game = await ref.watch(archivedGameProvider(id: id).future);
  final serverAnalysis =
      game.white.analysis != null && game.black.analysis != null
          ? (white: game.white.analysis!, black: game.black.analysis!)
          : null;

  return (
    options: AnalysisOptions(
      id: game.id,
      isLocalEvaluationAllowed: true,
      orientation: orientation,
      variant: game.meta.variant,
      opening: game.meta.opening,
      division: game.meta.division,
      serverAnalysis: serverAnalysis,
    ),
    pgn: game.makePgn(),
  );
}
