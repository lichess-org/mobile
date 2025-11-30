import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/common/id.dart';

final broadcastTournamentIdProvider = FutureProvider.autoDispose
    .family<BroadcastTournamentId, BroadcastRoundId>((Ref ref, BroadcastRoundId roundId) async {
      return (await ref.watch(broadcastRoundProvider(roundId).future)).tournament.id;
    }, name: 'BroadcastTournamentIdProvider');
