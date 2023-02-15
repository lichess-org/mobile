import 'package:async/async.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';
import 'user_repository.dart';
import 'user.dart';

part 'user_repository_providers.g.dart';

@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  final repo =
      UserRepository(logger: Logger('UserRepository'), apiClient: apiClient);
  return repo;
}

@riverpod
Future<User> user(UserRef ref, {required UserId id}) {
  ref.cacheFor(RequestCacheDuration.standard);
  final repo = ref.watch(userRepositoryProvider);
  return Result.release(repo.getUser(id));
}

@riverpod
Future<UserPerfStats> userPerfStats(
  UserPerfStatsRef ref, {
  required UserId id,
  required Perf perf,
}) {
  ref.cacheFor(RequestCacheDuration.standard);
  final repo = ref.watch(userRepositoryProvider);
  return Result.release(repo.getUserPerfStats(id, perf));
}

@riverpod
Future<IList<UserStatus>> userStatuses(
  UserStatusesRef ref, {
  required ISet<UserId> ids,
}) {
  ref.cacheFor(RequestCacheDuration.short);
  final repo = ref.watch(userRepositoryProvider);
  return Result.release(repo.getUsersStatuses(ids));
}
