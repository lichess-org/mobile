import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/user/leaderboard.dart';
import 'package:lichess_mobile/src/model/user/streamer.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_repository_providers.g.dart';

const _kAutoCompleteDebounceTimer = Duration(milliseconds: 300);

@riverpod
Future<User> user(Ref ref, {required UserId id}) async {
  return ref.withClient((client) => UserRepository(client).getUser(id));
}

@riverpod
Future<IList<UserActivity>> userActivity(Ref ref, {required UserId id}) async {
  return ref.withClientCacheFor(
    (client) => UserRepository(client).getActivity(id),
    // cache is important because the associated widget is in a [ListView] and
    // the provider may be instanciated multiple times in a short period of time
    // (e.g. when scrolling)
    // TODO: consider debouncing the request instead of caching it, or make the
    // request in the parent widget and pass the result to the child
    const Duration(minutes: 1),
  );
}

@riverpod
Future<(User, UserStatus)> userAndStatus(Ref ref, {required UserId id}) async {
  return ref.withClient((client) async {
    final repo = UserRepository(client);
    return Future.wait([
      repo.getUser(id, withCanChallenge: true),
      repo.getUsersStatuses({id}.lock),
    ], eagerError: true).then((value) => (value[0] as User, (value[1] as IList<UserStatus>).first));
  });
}

@riverpod
Future<UserPerfStats> userPerfStats(Ref ref, {required UserId id, required Perf perf}) async {
  return ref.withClient((client) => UserRepository(client).getPerfStats(id, perf));
}

@riverpod
Future<IList<UserStatus>> userStatuses(Ref ref, {required ISet<UserId> ids}) async {
  return ref.withClient((client) => UserRepository(client).getUsersStatuses(ids));
}

@riverpod
Future<IList<Streamer>> liveStreamers(Ref ref) async {
  return ref.withClientCacheFor(
    (client) => UserRepository(client).getLiveStreamers(),
    const Duration(minutes: 1),
  );
}

@riverpod
Future<IMap<Perf, LeaderboardUser>> top1(Ref ref) async {
  return ref.withClientCacheFor(
    (client) => UserRepository(client).getTop1(),
    const Duration(hours: 12),
  );
}

@riverpod
Future<Leaderboard> leaderboard(Ref ref) async {
  return ref.withClientCacheFor(
    (client) => UserRepository(client).getLeaderboard(),
    const Duration(hours: 2),
  );
}

@riverpod
Future<IList<LightUser>> autoCompleteUser(Ref ref, String term) async {
  // debounce calls as user might be typing
  var didDispose = false;
  ref.onDispose(() => didDispose = true);
  await Future<void>.delayed(_kAutoCompleteDebounceTimer);
  if (didDispose) {
    throw Exception('Cancelled');
  }

  return ref.withClient((client) => UserRepository(client).autocompleteUser(term));
}

@riverpod
Future<IList<UserRatingHistoryPerf>> userRatingHistory(Ref ref, {required UserId id}) async {
  return ref.withClientCacheFor(
    (client) => UserRepository(client).getRatingHistory(id),
    const Duration(minutes: 1),
  );
}
