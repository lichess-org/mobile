import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/user/leaderboard.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'streamer.dart';
import 'user.dart';
import 'user_repository.dart';

part 'user_repository_providers.g.dart';

const _kAutoCompleteDebounceTimer = Duration(milliseconds: 300);

@riverpod
Future<User> user(UserRef ref, {required UserId id}) async {
  return ref.withClient(
    (client) => UserRepository(client).getUser(id),
  );
}

@riverpod
Future<(User, UserStatus)> userAndStatus(
  UserAndStatusRef ref, {
  required UserId id,
}) async {
  return ref.withClient(
    (client) async {
      final repo = UserRepository(client);
      return Future.wait(
        [
          repo.getUser(id),
          repo.getUsersStatuses({id}.lock),
        ],
        eagerError: true,
      ).then(
        (value) => (value[0] as User, (value[1] as IList<UserStatus>).first),
      );
    },
  );
}

@riverpod
Future<UserPerfStats> userPerfStats(
  UserPerfStatsRef ref, {
  required UserId id,
  required Perf perf,
}) async {
  return ref.withClient(
    (client) => UserRepository(client).getPerfStats(id, perf),
  );
}

@riverpod
Future<IList<UserStatus>> userStatuses(
  UserStatusesRef ref, {
  required ISet<UserId> ids,
}) async {
  return ref.withClient(
    (client) => UserRepository(client).getUsersStatuses(ids),
  );
}

@riverpod
Future<IList<Streamer>> liveStreamers(LiveStreamersRef ref) async {
  return ref.withClientCacheFor(
    (client) => UserRepository(client).getLiveStreamers(),
    const Duration(minutes: 1),
  );
}

@riverpod
Future<IMap<Perf, LeaderboardUser>> top1(Top1Ref ref) async {
  return ref.withClientCacheFor(
    (client) => UserRepository(client).getTop1(),
    const Duration(hours: 12),
  );
}

@riverpod
Future<Leaderboard> leaderboard(LeaderboardRef ref) async {
  return ref.withClientCacheFor(
    (client) => UserRepository(client).getLeaderboard(),
    const Duration(hours: 2),
  );
}

@riverpod
Future<IList<LightUser>> autoCompleteUser(
  AutoCompleteUserRef ref,
  String term,
) async {
  // debounce calls as user might be typing
  var didDispose = false;
  ref.onDispose(() => didDispose = true);
  await Future<void>.delayed(_kAutoCompleteDebounceTimer);
  if (didDispose) {
    throw Exception('Cancelled');
  }

  return ref.withClient(
    (client) => UserRepository(client).autocompleteUser(term),
  );
}

@riverpod
Future<IList<UserRatingHistoryPerf>> userRatingHistory(
  UserRatingHistoryRef ref, {
  required UserId id,
}) async {
  return ref.withClient(
    (client) => UserRepository(client).getRatingHistory(id),
  );
}
