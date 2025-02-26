import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'broadcast_player_screen_providers.g.dart';

@riverpod
Future<BroadcastTournamentId> broadcastTournamentId(Ref ref, BroadcastRoundId roundId) {
  return ref.watch(broadcastRoundProvider(roundId).selectAsync((round) => round.tournament.id));
}
