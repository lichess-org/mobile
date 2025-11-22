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
    .family<BroadcastGame, BroadcastRoundGameParam>((
      Ref ref,
      BroadcastRoundGameParam params,
    ) async {
      final round = await ref.watch(broadcastRoundControllerProvider(params.roundId).future);
      return round.games[params.gameId]!;
    }, name: 'BroadcastRoundGameProvider');

/// A provider that exposes the current [ClientEval] for the given [BroadcastRoundGameParam].
final broadcastGameEvalProvider = FutureProvider.autoDispose
    .family<ClientEval?, BroadcastRoundGameParam>((Ref ref, BroadcastRoundGameParam params) async {
      final state = await ref.watch(
        broadcastAnalysisControllerProvider((
          roundId: params.roundId,
          gameId: params.gameId,
        )).future,
      );
      return state.currentNode.eval;
    }, name: 'BroadcastGameEvalProvider');

/// A provider that indicates whether engine analysis is available for the given
final isBroadcastEngineAvailableProvider = FutureProvider.autoDispose
    .family<bool, BroadcastRoundGameParam>((Ref ref, BroadcastRoundGameParam params) async {
      final enginePrefs = ref.watch(engineEvaluationPreferencesProvider);
      final state = await ref.watch(
        broadcastAnalysisControllerProvider((
          roundId: params.roundId,
          gameId: params.gameId,
        )).future,
      );
      return state.isEngineAvailable(enginePrefs);
    }, name: 'IsBroadcastEngineAvailableProvider');

final broadcastGameScreenTitleProvider = FutureProvider.autoDispose
    .family<String, BroadcastRoundId>((Ref ref, BroadcastRoundId roundId) async {
      final round = await ref.watch(broadcastRoundControllerProvider(roundId).future);
      return round.round.name;
    }, name: 'BroadcastGameScreenTitleProvider');
