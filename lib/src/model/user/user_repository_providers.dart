import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
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
Future<User> user(UserRef ref, {required UserId id}) async {
  final link = ref.cacheFor(const Duration(minutes: 5));
  final repo = ref.watch(userRepositoryProvider);
  final result = await repo.getUser(id);
  if (result.isError) {
    link.close();
  }
  return result.asFuture;
}

@riverpod
Future<UserPerfStats> userPerfStats(
  UserPerfStatsRef ref, {
  required UserId id,
  required Perf perf,
}) async {
  final link = ref.cacheFor(const Duration(minutes: 5));
  final repo = ref.watch(userRepositoryProvider);
  final result = await repo.getUserPerfStats(id, perf);
  if (result.isError) {
    link.close();
  }
  return result.asFuture;
}

@riverpod
Future<IList<UserActivity>> userActivity(
  UserActivityRef ref, {
  required UserId id,
}) async {
  final link = ref.cacheFor(const Duration(minutes: 5));
  final repo = ref.watch(userRepositoryProvider);
  final result = await repo.getUserActivity(id);
  if (result.isError) {
    link.close();
  }
  return result.asFuture;
}

@riverpod
Future<IList<UserStatus>> userStatuses(
  UserStatusesRef ref, {
  required ISet<UserId> ids,
}) async {
  final link = ref.cacheFor(const Duration(seconds: 30));
  final repo = ref.watch(userRepositoryProvider);
  final result = await repo.getUsersStatuses(ids);
  if (result.isError) {
    link.close();
  }
  return result.asFuture;
}

@riverpod
Future<IList<Streamer>> liveStreamers(LiveStreamersRef ref) async {
  final link = ref.cacheFor(const Duration(minutes: 5));
  final repo = ref.watch(userRepositoryProvider);
  final result = await repo.getLiveStreamers();
  if (result.isError) {
    link.close();
  }
  return result.asFuture;
}

@riverpod
Future<IMap<Perf, LeaderboardUser>> top1(Top1Ref ref) async {
  final link = ref.cacheFor(const Duration(minutes: 10));
  final repo = ref.watch(userRepositoryProvider);
  final result = await repo.getTop1();
  if (result.isError) {
    link.close();
  }
  return result.asFuture;
}

@riverpod
Future<Leaderboard> leaderboard(LeaderboardRef ref) async {
  final link = ref.cacheFor(const Duration(minutes: 5));
  final repo = ref.watch(userRepositoryProvider);
  final result = await repo.getLeaderboard();
  if (result.isError) {
    link.close();
  }
  return result.asFuture;
}
