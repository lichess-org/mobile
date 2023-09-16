import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'relation_repository.dart';

part 'relation_repository_providers.g.dart';

@Riverpod(keepAlive: true)
RelationRepository relationRepository(RelationRepositoryRef ref) {
  final apiClient = ref.watch(authClientProvider);
  return RelationRepository(
    logger: Logger('RelationRepository'),
    apiClient: apiClient,
  );
}

@riverpod
Future<IList<User>> following(FollowingRef ref) async {
  final link = ref.cacheFor(const Duration(minutes: 5));
  final repo = ref.watch(relationRepositoryProvider);
  final result = await repo.getFollowing();
  if (result.isError) {
    link.close();
  }
  return result.asFuture;
}
