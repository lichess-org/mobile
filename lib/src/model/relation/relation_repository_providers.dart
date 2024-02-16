import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'relation_repository.dart';

part 'relation_repository_providers.g.dart';

@riverpod
Future<IList<User>> following(FollowingRef ref) async {
  return ref.withAuthClientCacheFor(
    (client) => RelationRepository(client).getFollowing(),
    const Duration(hours: 1),
  );
}
