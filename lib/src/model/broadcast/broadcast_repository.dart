import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/common/http.dart';

class BroadcastRepository {
  BroadcastRepository(this.client);

  final http.Client client;

  Future<IList<Broadcast>> getBroadcasts() {
    return client.readNdJsonList(
      Uri(path: '/api/broadcast'),
      headers: {'Accept': 'application/x-ndjson'},
      mapper: _makeBroadcastFromJson,
    );
  }
}

Broadcast _makeBroadcastFromJson(Map<String, dynamic> json) =>
    _broadcastFromPick(pick(json).required());

Broadcast _broadcastFromPick(RequiredPick pick) {
  return Broadcast(
    tour: Tour(
      name: pick('tour', 'name').asStringOrThrow(),
      description: pick('tour', 'description').asStringOrThrow(),
    ),
  );
}
