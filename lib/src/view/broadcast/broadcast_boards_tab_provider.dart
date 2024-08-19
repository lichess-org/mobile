import 'package:dartchess/dartchess.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_game_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'broadcast_boards_tab_provider.g.dart';

@riverpod
Future<OptionsAndPgn> broadcastGameAnalysis(
  BroadcastGameAnalysisRef ref, {
  required BroadcastRoundId roundId,
  required BroadcastGameId gameId,
}) async {
  final pgn = await ref.watch(
    broadcastGameControllerProvider(
      broadcastRoundId: roundId,
      broadcastGameId: gameId,
    ).future,
  );

  return (
    options: const AnalysisOptions(
      id: StringId('standalone_analysis'),
      isLocalEvaluationAllowed: true,
      orientation: Side.white,
      variant: Variant.standard,
    ),
    pgn: pgn,
  );
}
