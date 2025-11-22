import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_analysis_controller.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_round_controller.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';

typedef BroadcastRoundGameParam = ({BroadcastRoundId roundId, BroadcastGameId gameId});

/// A provider that exposes the [BroadcastGame] for the given [BroadcastRoundGameParam].
final broadcastRoundGameProvider = FutureProvider.autoDispose
    .family<BroadcastGame, BroadcastRoundGameParam>((Ref ref, BroadcastRoundGameParam params) {
      return ref.watch(
        broadcastRoundControllerProvider(
          params.roundId,
        ).selectAsync((round) => round.games[params.gameId]!),
      );
    }, name: 'BroadcastRoundGameProvider');

/// A provider that exposes the current [ClientEval] for the given [BroadcastRoundGameParam].
final broadcastGameEvalProvider = FutureProvider.autoDispose
    .family<ClientEval?, BroadcastRoundGameParam>((Ref ref, BroadcastRoundGameParam params) {
      return ref.watch(
        broadcastAnalysisControllerProvider((
          roundId: params.roundId,
          gameId: params.gameId,
        )).selectAsync((state) => state.currentNode.eval),
      );
    }, name: 'BroadcastGameEvalProvider');

/// A provider that indicates whether engine analysis is available for the given
final isBroadcastEngineAvailableProvider = FutureProvider.autoDispose
    .family<bool, BroadcastRoundGameParam>((Ref ref, BroadcastRoundGameParam params) {
      final enginePrefs = ref.watch(engineEvaluationPreferencesProvider);
      return ref.watch(
        broadcastAnalysisControllerProvider((
          roundId: params.roundId,
          gameId: params.gameId,
        )).selectAsync((round) => round.isEngineAvailable(enginePrefs)),
      );
    }, name: 'IsBroadcastEngineAvailableProvider');

final broadcastGameScreenTitleProvider = FutureProvider.autoDispose
    .family<String, BroadcastRoundId>((Ref ref, BroadcastRoundId roundId) {
      return ref.watch(
        broadcastRoundControllerProvider(roundId).selectAsync((round) => round.round.name),
      );
    }, name: 'BroadcastGameScreenTitleProvider');
