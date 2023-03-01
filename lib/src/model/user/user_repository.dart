import 'package:logging/logging.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'user.dart';

class UserRepository {
  const UserRepository({required this.apiClient, required Logger logger})
      : _log = logger;

  final ApiClient apiClient;
  final Logger _log;

  FutureResult<User> getUser(UserId id) {
    return apiClient.get(Uri.parse('$kLichessHost/api/user/$id')).then(
          (result) => result.flatMap(
            (response) => readJsonObject(
              response.body,
              mapper: User.fromJson,
              logger: _log,
            ),
          ),
        );
  }

  FutureResult<UserPerfStats> getUserPerfStats(UserId id, Perf perf) {
    return apiClient
        .get(Uri.parse('$kLichessHost/api/user/$id/perf/${perf.name}'))
        .then(
          (result) => result.flatMap(
            (response) => readJsonObject(
              response.body,
              mapper: _userPerfStatsFromJson,
              logger: _log,
            ),
          ),
        );
  }

  FutureResult<IList<UserStatus>> getUsersStatuses(ISet<UserId> ids) {
    return apiClient
        .get(Uri.parse('$kLichessHost/api/users/status?ids=${ids.join(',')}'))
        .then(
          (result) => result.flatMap(
            (response) => readJsonListOfObjects(
              response.body,
              mapper: UserStatus.fromJson,
              logger: _log,
            ),
          ),
        );
  }

  FutureResult<IList<UserActitity>> getUserActivity(UserId id) {
    return apiClient.get(Uri.parse('$kLichessHost/api/user/$id/activity')).then(
          (result) => result.flatMap(
            (response) => readJsonListOfObjects(
              response.body,
              mapper: _userActitityFromJson,
              logger: _log,
            ),
          ),
        );
  }
}

// --
UserActitity _userActitityFromJson(Map<String, dynamic> json) =>
    _userActitityFromPick(pick(json).required());

UserActitity _userActitityFromPick(RequiredPick pick) {
  final receivedGamesMap =
      pick('games').asMapOrEmpty<String, Map<String, dynamic>>();

  return UserActitity(
    startTime: pick('interval', 'start').asDateTimeFromMillisecondsOrThrow(),
    endTime: pick('interval', 'end').asDateTimeFromMillisecondsOrThrow(),
    games: IMap({
      for (final entry in receivedGamesMap.entries)
        perfNameMap.get(entry.key)!: UserActitityGameScore.fromJson(entry.value)
    }),
    followIn: IList(
      pick('follows', 'in', 'ids')
          .asListOrNull((p0) => pick(p0).asStringOrNull()),
    ),
    followOut: IList(
      pick('follows', 'out', 'ids')
          .asListOrNull((p0) => pick(p0).asStringOrNull()),
    ),
    tournament: IList(
      pick('tournaments', 'best')
          .asListOrNull((p0) => UserActivityTournament.fromPick(p0)),
    ),
    tournamentNb: pick('tournaments', 'nb').asIntOrNull(),
  );
}

// --
UserPerfStats _userPerfStatsFromJson(Map<String, dynamic> json) =>
    _userPerfStatsFromPick(pick(json).required());

UserPerfStats _userPerfStatsFromPick(RequiredPick pick) {
  final perf = pick('perf');
  final stat = pick('stat');

  final lowest = stat('lowest');
  final highest = stat('highest');
  final count = stat('count');
  final resultStreak = stat('resultStreak');
  final playStreak = stat('playStreak');

  return UserPerfStats(
    rating: perf('glicko', 'rating').asDoubleOrThrow(),
    deviation: perf('glicko', 'deviation').asDoubleOrThrow(),
    provisional: perf('glicko', 'provisional').asBoolOrNull(),
    progress: perf('progress').asIntOrThrow(),
    rank: pick('rank').asIntOrNull(),
    percentile: pick('percentile').asDoubleOrNull(),
    totalGames: count('all').asIntOrThrow(),
    berserkGames: count('berserk').asIntOrThrow(),
    tournamentGames: count('tour').asIntOrThrow(),
    ratedGames: count('rated').asIntOrThrow(),
    wonGames: count('win').asIntOrThrow(),
    lostGames: count('loss').asIntOrThrow(),
    drawnGames: count('draw').asIntOrThrow(),
    disconnections: count('disconnects').asIntOrThrow(),
    avgOpponent: count('opAvg').asDoubleOrNull(),
    timePlayed: count('seconds').asDurationFromSecondsOrThrow(),
    lowestRating: lowest('int').asIntOrNull(),
    lowestRatingGame: lowest.letOrNull(_userPerfGameFromPick),
    highestRating: highest('int').asIntOrNull(),
    highestRatingGame: highest.letOrNull(_userPerfGameFromPick),
    curWinStreak: resultStreak('win', 'cur').letOrNull(_userStreakFromPick),
    maxWinStreak: resultStreak('win', 'max').letOrNull(_userStreakFromPick),
    curLossStreak: resultStreak('loss', 'cur').letOrNull(_userStreakFromPick),
    maxLossStreak: resultStreak('loss', 'max').letOrNull(_userStreakFromPick),
    curPlayStreak: playStreak('nb', 'cur').letOrNull(_userStreakFromPick),
    maxPlayStreak: playStreak('nb', 'max').letOrNull(_userStreakFromPick),
    curTimeStreak: playStreak('time', 'cur').letOrNull(_userStreakFromPick),
    maxTimeStreak: playStreak('time', 'max').letOrNull(_userStreakFromPick),
    worstLosses: IList(
      stat('worstLosses', 'results').asListOrNull(_userPerfGameFromPick),
    ),
    bestWins:
        IList(stat('bestWins', 'results').asListOrNull(_userPerfGameFromPick)),
  );
}

UserStreak _userStreakFromPick(RequiredPick pick) {
  final path = pick.path;
  if (path.length <= 1) {
    throw PickException("cannot decode $pick as 'UserStreak'");
  }

  // Since we are passing 'cur' or 'max' as the last pick,
  // we check the previous value in the path (the parent).
  final type = path.reversed.elementAt(1);

  final value = pick('v');
  final isValueEmpty = value.asIntOrThrow() == 0;
  final startGame = pick('from').letOrNull(_userPerfGameFromPick);
  final endGame = pick('to').letOrNull(_userPerfGameFromPick);

  switch (type) {
    case 'time':
      return UserStreak.timeStreak(
        timePlayed: value.asDurationFromSecondsOrThrow(),
        isValueEmpty: isValueEmpty,
        startGame: startGame,
        endGame: endGame,
      );
    case 'win':
    case 'loss':
    case 'nb':
      return UserStreak.gameStreak(
        gamesPlayed: value.asIntOrThrow(),
        isValueEmpty: isValueEmpty,
        startGame: startGame,
        endGame: endGame,
      );
    default:
      throw PickException("cannot decode $pick as 'UserStreak'");
  }
}

UserPerfGame _userPerfGameFromPick(RequiredPick pick) {
  final opId = pick('opId');

  return UserPerfGame(
    finishedAt: pick('at').asDateTimeOrThrow(),
    gameId: pick('gameId').asGameIdOrThrow(),
    opponentRating: pick('opRating').asIntOrNull(),
    opponentId: opId('id').asStringOrNull(),
    opponentName: opId('name').asStringOrNull(),
    opponentTitle: opId('title').asStringOrNull(),
  );
}
