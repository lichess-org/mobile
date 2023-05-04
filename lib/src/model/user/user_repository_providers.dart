import 'package:async/async.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/leaderboard.dart';
import 'user_repository.dart';
import 'user.dart';
import 'streamer.dart';

part 'user_repository_providers.g.dart';

@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) {
  final apiClient = ref.watch(authClientProvider);
  return UserRepository(logger: Logger('UserRepository'), apiClient: apiClient);
}

@riverpod
Future<User> user(UserRef ref, {required UserId id}) {
  final repo = ref.watch(userRepositoryProvider);
  final result = repo.getUser(id);
  result.match(
    onSuccess: (_) => ref.cacheFor(const Duration(minutes: 5)),
  );
  return Result.release(result);
}

@riverpod
Future<UserPerfStats> userPerfStats(
  UserPerfStatsRef ref, {
  required UserId id,
  required Perf perf,
}) {
  final repo = ref.watch(userRepositoryProvider);
  final result = repo.getUserPerfStats(id, perf);
  result.match(
    onSuccess: (_) => ref.cacheFor(const Duration(minutes: 5)),
  );
  return Result.release(result);
}

@riverpod
Future<IList<UserActivity>> userActivity(
  UserActivityRef ref, {
  required UserId id,
}) {
  final repo = ref.watch(userRepositoryProvider);
  final result = repo.getUserActivity(id);
  result.match(
    onSuccess: (_) => ref.cacheFor(const Duration(minutes: 5)),
  );
  return Result.release(result);
}

@riverpod
Future<IList<UserStatus>> userStatuses(
  UserStatusesRef ref, {
  required ISet<UserId> ids,
}) {
  final repo = ref.watch(userRepositoryProvider);
  final result = repo.getUsersStatuses(ids);
  result.match(
    onSuccess: (_) => ref.cacheFor(const Duration(seconds: 30)),
  );
  return Result.release(result);
}

@riverpod
Future<IList<Streamer>> liveStreamers(LiveStreamersRef ref) {
  final repo = ref.watch(userRepositoryProvider);
  final result = repo.getLiveStreamers();
  result.match(
    onSuccess: (_) => ref.cacheFor(const Duration(minutes: 5)),
  );
  return Result.release(result);
}

@riverpod
Future<IMap<Perf, LeaderboardUser>> top1(Top1Ref ref) {
  final repo = ref.watch(userRepositoryProvider);
  final result = repo.getTop1();
  result.match(
    onSuccess: (_) => ref.cacheFor(const Duration(minutes: 10)),
  );
  return Result.release(result);
}

@riverpod
Future<Leaderboard> leaderboard(LeaderboardRef ref) {
  final repo = ref.watch(userRepositoryProvider);
  final result = repo.getLeaderboard();
  result.match(
    onSuccess: (_) => ref.cacheFor(const Duration(minutes: 5)),
  );
  return Result.release(result);
}
