import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/lobby/correspondence_seek.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/network/http.dart';

final correspondenceSeeksProvider = FutureProvider.autoDispose<IList<CorrespondenceSeek>>((
  Ref ref,
) {
  return ref.withClient((client) => LobbyRepository(client).getCorrespondenceSeeks());
}, name: 'CorrespondenceSeeksProvider');

class LobbyRepository {
  LobbyRepository(this.client);

  final LichessClient client;

  Future<void> createSeek(GameSeek seek, {required String sri}) async {
    final uri = Uri(path: '/api/board/seek', queryParameters: {'sri': sri});
    await client.postRead(uri, body: seek.requestBody);
  }

  Future<void> cancelSeek({required String sri}) async {
    final uri = Uri(path: '/api/board/seek', queryParameters: {'sri': sri});
    await client.deleteRead(uri);
  }

  Future<IList<CorrespondenceSeek>> getCorrespondenceSeeks() {
    return client.readJsonList(
      Uri(path: '/lobby/seeks'),
      headers: {'Accept': 'application/vnd.lichess.v5+json'},
      mapper: CorrespondenceSeek.fromServerJson,
    );
  }
}
