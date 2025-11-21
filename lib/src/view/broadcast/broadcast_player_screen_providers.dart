import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/common/id.dart';

final broadcastTournamentIdProvider = FutureProvider.autoDispose
    .family<BroadcastTournamentId, BroadcastRoundId>((Ref ref, BroadcastRoundId roundId) {
      return ref.watch(broadcastRoundProvider(roundId).selectAsync((round) => round.tournament.id));
    });
