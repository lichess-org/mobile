import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/relation/relation_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relation_repository_providers.g.dart';

@riverpod
Future<IList<User>> following(Ref ref) {
  return ref.withClientCacheFor(
    (client) => RelationRepository(client).getFollowing(),
    const Duration(hours: 1),
  );
}
