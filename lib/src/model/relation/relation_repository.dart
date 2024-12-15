import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';

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

  Future<void> follow(UserId userId) async {
    final uri = Uri(path: '/api/rel/follow/$userId');
    final response = await client.post(uri);

    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to follow user: ${response.statusCode}', uri);
    }
  }

  Future<void> unfollow(UserId userId) async {
    final uri = Uri(path: '/api/rel/unfollow/$userId');
    final response = await client.post(uri);

    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to unfollow user: ${response.statusCode}', uri);
    }
  }

  Future<void> block(UserId userId) async {
    final uri = Uri(path: '/api/rel/block/$userId');
    final response = await client.post(uri);

    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to block user: ${response.statusCode}', uri);
    }
  }

  Future<void> unblock(UserId userId) async {
    final uri = Uri(path: '/api/rel/unblock/$userId');
    final response = await client.post(uri);

    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to unblock user: ${response.statusCode}', uri);
    }
  }
}
