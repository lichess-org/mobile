import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_analysis_controller.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_round_controller.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'broadcast_game_screen_providers.g.dart';

@riverpod
Future<BroadcastGame> broadcastRoundGame(
  Ref ref,
  BroadcastRoundId roundId,
  BroadcastGameId gameId,
) {
  return ref.watch(
    broadcastRoundControllerProvider(roundId).selectAsync((round) => round.games[gameId]!),
  );
}

@riverpod
Future<ClientEval?> broadcastGameEval(Ref ref, BroadcastRoundId roundId, BroadcastGameId gameId) {
  return ref.watch(
    broadcastAnalysisControllerProvider(
      roundId,
      gameId,
    ).selectAsync((state) => state.currentNode.eval),
  );
}

@riverpod
Future<bool> isBroadcastEngineAvailable(Ref ref, BroadcastRoundId roundId, BroadcastGameId gameId) {
  final enginePrefs = ref.watch(engineEvaluationPreferencesProvider);
  return ref.watch(
    broadcastAnalysisControllerProvider(
      roundId,
      gameId,
    ).selectAsync((round) => round.isEngineAvailable(enginePrefs)),
  );
}

@riverpod
Future<String> broadcastGameScreenTitle(Ref ref, BroadcastRoundId roundId) {
  return ref.watch(
    broadcastRoundControllerProvider(roundId).selectAsync((round) => round.round.name),
  );
}
