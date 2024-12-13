import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_round_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'broadcast_game_screen_providers.g.dart';

@riverpod
Future<BroadcastGame> broadcastGame(
  Ref ref,
  BroadcastRoundId roundId,
  BroadcastGameId gameId,
) {
  return ref.watch(
    broadcastRoundControllerProvider(roundId)
        .selectAsync((round) => round.games[gameId]!),
  );
}

@riverpod
Future<String> broadcastGameScreenTitle(
  Ref ref,
  BroadcastRoundId roundId,
) {
  return ref.watch(
    broadcastRoundControllerProvider(roundId)
        .selectAsync((round) => round.round.name),
  );
}
