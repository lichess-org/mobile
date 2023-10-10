import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:logging/logging.dart';
import 'package:result_extensions/result_extensions.dart';

import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'broadcast_repository.g.dart';

@Riverpod(keepAlive: true)
BroadcastRepository broadcastRepository(BroadcastRepositoryRef ref) {
  final apiClient = ref.watch(authClientProvider);
  return BroadcastRepository(
    Logger('BroadcastRepository'),
    apiClient: apiClient,
  );
}

class BroadcastRepository {
  const BroadcastRepository(
    Logger log, {
    required this.apiClient,
  }) : _log = log;

  final AuthClient apiClient;
  final Logger _log;

  FutureResult<IList<Broadcast>> getBroadcasts() {
    return apiClient.get(
      Uri.parse('$kLichessHost/api/broadcast'),
      headers: {'Accept': 'application/x-ndjson'},
    ).flatMap(
      (response) => readNdJsonList(
        response,
        mapper: _makeBroadcastFromJson,
        logger: _log,
      ),
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
