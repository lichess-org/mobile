import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_repository.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'broadcast_providers.g.dart';

@riverpod
Future<BroadcastResponse> broadcasts(BroadcastsRef ref) async {
  return ref
      .withClient((client) => BroadcastRepository(client).getBroadcasts());
}

@riverpod
Future<IList<BroadcastGameSnapshot>> round(
  RoundRef ref,
  String broadcastRoundId,
) async {
  return ref.withClient(
    (client) => BroadcastRepository(client).getRound(broadcastRoundId),
  );
}
