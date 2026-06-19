import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/relation/following_user.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/aggregator.dart';
import 'package:lichess_mobile/src/network/http.dart';

/// A provider for [RelationRepository].
final relationRepositoryProvider = Provider<RelationRepository>((ref) {
  return RelationRepository(ref.watch(lichessClientProvider));
}, name: 'RelationRepositoryProvider');

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

  Future<void> deleteThread(UserId userId) async {
    final uri = Uri(path: '/inbox/$userId/delete');
    await client.postRead(uri);
  }
}

final followingCarouselProvider = FutureProvider.autoDispose<IList<FollowingUser>>((ref) {
  return ref.watch(followingRepositoryProvider).getFollowing();
}, name: 'FollowingCarouselProvider');

final followingRepositoryProvider = Provider<FollowingRepository>((ref) {
  final client = ref.watch(lichessClientProvider);
  final aggregator = ref.watch(aggregatorProvider);
  return FollowingRepository(client, aggregator);
}, name: 'FollowingRepositoryProvider');

class FollowingRepository {
  FollowingRepository(this.client, this.aggregator);

  final LichessClient client;
  final Aggregator aggregator;

  Future<IList<FollowingUser>> getFollowing() {
    return aggregator.readNdJsonList(
      Uri(path: '/api/mobile/following'),
      mapper: FollowingUser.fromJson,
    );
  }
}
