import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

class RelationRepository {
  const RelationRepository(this.client);

  final LichessClient client;

  Future<IList<User>> getFollowing() async {
    return client.readNdJsonList(
      Uri(path: '/api/rel/following'),
      headers: {'Accept': 'application/x-ndjson'},
      mapper: User.fromServerJson,
    );
  }

  Future<void> follow(String username) async {
    final uri = Uri(path: '/api/rel/follow/$username');
    final response = await client.post(uri);

    if (response.statusCode >= 400) {
      throw http.ClientException(
        'Failed to follow user: ${response.statusCode}',
        uri,
      );
    }
  }

  Future<void> unfollow(String username) async {
    final uri = Uri(path: '/api/rel/unfollow/$username');
    final response = await client.post(uri);

    if (response.statusCode >= 400) {
      throw http.ClientException(
        'Failed to unfollow user: ${response.statusCode}',
        uri,
      );
    }
  }
}
