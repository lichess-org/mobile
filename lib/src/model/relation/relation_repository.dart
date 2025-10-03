import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';

class RelationRepository {
  const RelationRepository(this.client);

  final LichessClient client;

  Future<IList<User>> getFollowing() {
    return client.readNdJsonList(
      Uri(path: '/api/rel/following'),
      headers: {'Accept': 'application/x-ndjson'},
      mapper: User.fromServerJson,
    );
  }

  Future<void> follow(UserId userId) async {
    final uri = Uri(path: '/api/rel/follow/$userId');
    await client.postRead(uri);
  }

  Future<void> unfollow(UserId userId) async {
    final uri = Uri(path: '/api/rel/unfollow/$userId');
    await client.postRead(uri);
  }

  Future<void> block(UserId userId) async {
    final uri = Uri(path: '/api/rel/block/$userId');
    await client.postRead(uri);
  }

  Future<void> unblock(UserId userId) async {
    final uri = Uri(path: '/api/rel/unblock/$userId');
    await client.postRead(uri);
  }
}
