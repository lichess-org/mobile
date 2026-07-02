import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_round_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';

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

final broadcastGameScreenTitleProvider = FutureProvider.autoDispose
    .family<String, BroadcastRoundId>((Ref ref, BroadcastRoundId roundId) async {
      final round = await ref.watch(broadcastRoundControllerProvider(roundId).future);
      return round.round.name;
    }, name: 'BroadcastGameScreenTitleProvider');

final broadcastRoundCustomScoringProvider = FutureProvider.autoDispose
    .family<BroadcastCustomScoring?, BroadcastRoundId>((Ref ref, BroadcastRoundId roundId) async {
      final round = await ref.watch(broadcastRoundControllerProvider(roundId).future);
      return round.round.customScoring;
    }, name: 'BroadcastRoundCustomScoringProvider');
