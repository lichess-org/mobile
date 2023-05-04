import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/leaderboard.dart';
import 'user.dart';
import 'streamer.dart';

class UserRepository {
  const UserRepository({required this.apiClient, required Logger logger})
      : _log = logger;

  final AuthClient apiClient;
  final Logger _log;

  FutureResult<User> getUser(UserId id) {
    return apiClient.get(Uri.parse('$kLichessHost/api/user/$id')).then(
          (result) => result.flatMap(
            (response) => readJsonObject(
              response,
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
              response,
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
              response,
              mapper: UserStatus.fromJson,
              logger: _log,
            ),
          ),
        );
  }

  FutureResult<IList<UserActivity>> getUserActivity(UserId id) {
    return apiClient.get(Uri.parse('$kLichessHost/api/user/$id/activity')).then(
          (result) => result.flatMap(
            (response) => readJsonListOfObjects(
              response,
              mapper: _userActivityFromJson,
              logger: _log,
            ),
          ),
        );
  }

  FutureResult<IList<Streamer>> getLiveStreamers() {
    return apiClient
        .get(Uri.parse('$kLichessHost/api/streamer/live'))
        .flatMap((response) {
      return readJsonListOfObjects(
        response,
        mapper: _streamersFromJson,
        logger: _log,
      );
    });
  }

  FutureResult<IMap<Perf, LeaderboardUser>> getTop1() {
    return apiClient
        .get(Uri.parse('$kLichessHost/api/player/top/1/standard'))
        .flatMap((response) {
      return readJsonObject(
        response,
        mapper: _top1FromJson,
        logger: _log,
      );
    });
  }

  FutureResult<Leaderboard> getLeaderboard() {
    return apiClient
        .get(Uri.parse('$kLichessHost/api/player'))
        .flatMap((response) {
      return readJsonObject(
        response,
        mapper: _leaderboardFromJson,
        logger: _log,
      );
    });
  }
}

// --

UserActivity _userActivityFromJson(Map<String, dynamic> json) =>
    _userActivityFromPick(pick(json).required());

UserActivity _userActivityFromPick(RequiredPick pick) {
  final receivedGamesMap =
      pick('games').asMapOrEmpty<String, Map<String, dynamic>>();

  final games = IMap({
    for (final entry in receivedGamesMap.entries)
      if (perfNameMap.containsKey(entry.key))
        perfNameMap.get(entry.key)!: UserActivityScore.fromJson(entry.value)
  });

  final bestTour = pick('tournaments', 'best')
      .asListOrNull((p0) => UserActivityTournament.fromPick(p0));

  return UserActivity(
    startTime: pick('interval', 'start').asDateTimeFromMillisecondsOrThrow(),
    endTime: pick('interval', 'end').asDateTimeFromMillisecondsOrThrow(),
    games: games.isEmpty ? null : games,
    followInNb: pick('follows', 'in', 'nb').asIntOrNull(),
    followOutNb: pick('follows', 'in', 'nb').asIntOrNull(),
    tournamentNb: pick('tournaments', 'nb').asIntOrNull(),
    bestTournament: bestTour?.firstOrNull,
    puzzles: pick('puzzles', 'score').letOrNull(UserActivityScore.fromPick),
    streak: pick('streak').letOrNull(UserActivityStreak.fromPick),
    correspondenceEnds: pick('correspondenceEnds', 'score')
        .letOrNull(UserActivityScore.fromPick),
    correspondenceMovesNb: pick('correspondenceMoves', 'nb').asIntOrNull(),
    correspondenceGamesNb: pick('correspondenceMoves', 'games')
        .asListOrNull((p) => p('id').asStringOrThrow())
        ?.length,
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

Streamer _streamersFromJson(Map<String, dynamic> json) =>
    _streamersFromPick(pick(json).required());

Streamer _streamersFromPick(RequiredPick pick) {
  final stream = pick('stream');
  final streamer = pick('streamer');
  return Streamer(
    username: pick('name').asStringOrThrow(),
    id: pick('id').asUserIdOrThrow(),
    patron: pick('patron').asBoolOrNull(),
    platform: stream('service').asStringOrThrow(),
    status: stream('status').asStringOrThrow(),
    lang: stream('lang').asStringOrThrow(),
    streamerName: streamer('name').asStringOrThrow(),
    headline: streamer('headline').asStringOrNull(),
    title: pick('title').asStringOrNull(),
    image: streamer('image').asStringOrThrow(),
    twitch: streamer('twitch').asStringOrNull(),
    youTube: streamer('youTube').asStringOrNull(),
  );
}

Leaderboard _leaderboardFromJson(Map<String, dynamic> json) =>
    _leaderBoardFromPick(pick(json).required());

Leaderboard _leaderBoardFromPick(RequiredPick pick) {
  return Leaderboard(
    bullet: pick('bullet').asListOrEmpty(_leaderboardUserFromPick),
    blitz: pick('blitz').asListOrEmpty(_leaderboardUserFromPick),
    rapid: pick('rapid').asListOrEmpty(_leaderboardUserFromPick),
    classical: pick('classical').asListOrEmpty(_leaderboardUserFromPick),
    ultrabullet: pick('ultraBullet').asListOrEmpty(_leaderboardUserFromPick),
    crazyhouse: pick('crazyhouse').asListOrEmpty(_leaderboardUserFromPick),
    chess960: pick('chess960').asListOrEmpty(_leaderboardUserFromPick),
    kingOfThehill:
        pick('kingOfTheHill').asListOrEmpty(_leaderboardUserFromPick),
    threeCheck: pick('threeCheck').asListOrEmpty(_leaderboardUserFromPick),
    antichess: pick('antichess').asListOrEmpty(_leaderboardUserFromPick),
    atomic: pick('atomic').asListOrEmpty(_leaderboardUserFromPick),
    horde: pick('horde').asListOrEmpty(_leaderboardUserFromPick),
    racingKings: pick('racingKings').asListOrEmpty(_leaderboardUserFromPick),
  );
}

LeaderboardUser _leaderboardUserFromPick(RequiredPick pick) {
  final prefMap = pick('perfs').asMapOrThrow<String, Map<String, dynamic>>();

  return LeaderboardUser(
    id: pick('id').asUserIdOrThrow(),
    username: pick('username').asStringOrThrow(),
    title: pick('title').asStringOrNull(),
    patron: pick('patron').asBoolOrNull(),
    online: pick('online').asBoolOrNull(),
    rating: pick('perfs')
        .letOrThrow((perfsPick) => perfsPick(prefMap.keys.first, 'rating'))
        .asIntOrThrow(),
    progress: pick('perfs')
        .letOrThrow(
          (prefsPick) => prefsPick(prefMap.keys.first, 'progress'),
        )
        .asIntOrThrow(),
  );
}

IMap<Perf, LeaderboardUser> _top1FromJson(Map<String, dynamic> json) {
  final map = pick(json).asMapOrEmpty<String, Map<String, dynamic>>();
  return IMap({
    for (final entry in map.entries)
      if (perfNameMap.containsKey(entry.key))
        perfNameMap.get(entry.key)!: _top1userFromPick(
          pick(map[entry.key]).required(),
          perfNameMap.get(entry.key)!,
        ),
  });
}

LeaderboardUser _top1userFromPick(RequiredPick pick, Perf perf) {
  return LeaderboardUser(
    id: pick('id').asUserIdOrThrow(),
    username: pick('username').asStringOrThrow(),
    title: pick('title').asStringOrNull(),
    patron: pick('patron').asBoolOrNull(),
    rating: pick('perfs', perf.name, 'rating').asIntOrThrow(),
    progress: pick('perfs', perf.name, 'progress').asIntOrThrow(),
  );
}
