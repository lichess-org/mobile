import 'package:async/async.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';
import 'package:lichess_mobile/src/model/user/leaderboard.dart';
import 'user_repository.dart';
import 'user.dart';
import 'streamer.dart';

part 'user_repository_providers.g.dart';

@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserRepository(logger: Logger('UserRepository'), apiClient: apiClient);
}

@riverpod
Future<User> user(UserRef ref, {required UserId id}) {
  ref.cacheFor(const Duration(minutes: 5));
  final repo = ref.watch(userRepositoryProvider);
  return Result.release(repo.getUser(id));
}

@riverpod
Future<UserPerfStats> userPerfStats(
  UserPerfStatsRef ref, {
  required UserId id,
  required Perf perf,
}) {
  ref.cacheFor(const Duration(minutes: 5));
  final repo = ref.watch(userRepositoryProvider);
  return Result.release(repo.getUserPerfStats(id, perf));
}

@riverpod
Future<IList<UserStatus>> userStatuses(
  UserStatusesRef ref, {
  required ISet<UserId> ids,
}) {
  ref.cacheFor(const Duration(seconds: 30));
  final repo = ref.watch(userRepositoryProvider);
  return Result.release(repo.getUsersStatuses(ids));
}

@riverpod
Future<IList<Streamer>> liveStreamers(LiveStreamersRef ref) {
  final repo = ref.watch(userRepositoryProvider);
  return Result.release(repo.getLiveStreamers());
}

@riverpod
Future<IMap<Perf, LeaderboardUser>> top1(Top1Ref ref) {
  ref.cacheFor(const Duration(minutes: 10));
  final repo = ref.watch(userRepositoryProvider);
  return Result.release(repo.getTop1());
}

@riverpod
Future<Leaderboard> leaderboard(LeaderboardRef ref) {
  ref.cacheFor(const Duration(minutes: 5));
  final repo = ref.watch(userRepositoryProvider);
  return Result.release(repo.getLeaderboard());
}
