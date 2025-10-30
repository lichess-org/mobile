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
Future<User> user(Ref ref, {required UserId id}) {
  return ref.read(userRepositoryProvider).getUser(id, withCanChallenge: true);
}

@riverpod
Future<(User, UserStatus)> userAndStatus(Ref ref, {required UserId id}) {
  final repo = ref.read(userRepositoryProvider);
  return Future.wait(
    [
      repo.getUser(id, withCanChallenge: true),
      repo.getUsersStatuses({id}.lock),
    ],
    eagerError: true,
  ).then((value) => (value[0] as User, (value[1] as IList<UserStatus>).first));
}

@riverpod
Future<UserPerfStats> userPerfStats(
  Ref ref, {
  required UserId id,
  required Perf perf,
}) {
  return ref.read(userRepositoryProvider).getPerfStats(id, perf);
}

@riverpod
Future<IList<UserStatus>> userStatuses(Ref ref, {required ISet<UserId> ids}) {
  return ref.read(userRepositoryProvider).getUsersStatuses(ids);
}

@riverpod
Future<IList<Streamer>> liveStreamers(Ref ref) {
  return ref.withAggregatorCacheFor(
    (client, aggregator) =>
        UserRepository(client, aggregator).getLiveStreamers(),
    const Duration(minutes: 1),
  );
}

@riverpod
Future<Top1Leaderboard> top1(Ref ref) {
  return ref.withAggregatorCacheFor(
    (client, aggregator) => UserRepository(client, aggregator).getTop1(),
    const Duration(hours: 12),
  );
}

@riverpod
Future<Leaderboard> leaderboard(Ref ref) {
  return ref.withAggregatorCacheFor(
    (client, aggregator) => UserRepository(client, aggregator).getLeaderboard(),
    const Duration(hours: 2),
  );
}

@riverpod
Future<IList<User>> onlineBots(Ref ref) {
  return ref.withAggregatorCacheFor(
    (client, aggregator) => UserRepository(
      client,
      aggregator,
    ).getOnlineBots().then((bots) => bots.toIList()),
    const Duration(hours: 5),
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

  return ref.read(userRepositoryProvider).autocompleteUser(term);
}

@riverpod
Future<IList<UserRatingHistoryPerf>> userRatingHistory(
  Ref ref, {
  required UserId id,
}) {
  return ref.withAggregatorCacheFor(
    (client, aggregator) =>
        UserRepository(client, aggregator).getRatingHistory(id),
    const Duration(minutes: 1),
  );
}

@riverpod
Future<Crosstable> crosstable(
  Ref ref,
  UserId userId1,
  UserId userId2, {
  bool matchup = true,
}) {
  return ref
      .read(userRepositoryProvider)
      .getCrosstable(userId1, userId2, matchup: matchup);
}
