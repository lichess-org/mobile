import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:deep_pick/deep_pick.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/utils/json.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String username,
    String? title,
    bool? patron,
    required DateTime createdAt,
    required DateTime seenAt,
    required Map<Perf, UserPerf> perfs,
    PlayTime? playTime,
    Profile? profile,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) =>
      User.fromPick(pick(json).required());

  factory User.fromPick(RequiredPick pick) {
    final perfsMap = pick('perfs').asMapOrThrow<String, Map<String, dynamic>>();
    return User(
      id: pick('id').asStringOrThrow(),
      username: pick('username').asStringOrThrow(),
      title: pick('title').asStringOrNull(),
      patron: pick('patron').asBoolOrNull(),
      createdAt: pick('createdAt').asDateTimeFromMillisecondsOrThrow(),
      seenAt: pick('seenAt').asDateTimeFromMillisecondsOrThrow(),
      playTime: pick('playTime').letOrNull(PlayTime.fromPick),
      profile: pick('profile').letOrNull(Profile.fromPick),
      perfs: Map.unmodifiable({
        for (final entry in perfsMap.entries)
          if (entry.key != 'storm')
            Perf.values.byName(entry.key): UserPerf.fromJson(entry.value)
      }),
    );
  }
}

@freezed
class PlayTime with _$PlayTime {
  const factory PlayTime({
    required Duration total,
    required Duration tv,
  }) = _PlayTime;

  factory PlayTime.fromJson(Map<String, dynamic> json) =>
      PlayTime.fromPick(pick(json).required());

  factory PlayTime.fromPick(RequiredPick pick) {
    return PlayTime(
        total: pick('total').asDurationFromSecondsOrThrow(),
        tv: pick('tv').asDurationFromSecondsOrThrow());
  }
}

@freezed
class Profile with _$Profile {
  const factory Profile({
    String? country,
    String? location,
    String? bio,
    String? firstName,
    String? lastName,
    int? fideRating,
    String? links,
  }) = _Profile;

  const Profile._();

  String? get fullName => firstName != null && lastName != null
      ? '$firstName $lastName'
      : firstName ?? lastName;

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile.fromPick(pick(json).required());
  }

  factory Profile.fromPick(RequiredPick pick) => Profile(
        country: pick('country').asStringOrNull(),
        location: pick('location').asStringOrNull(),
        bio: pick('bio').asStringOrNull(),
        firstName: pick('firstName').asStringOrNull(),
        lastName: pick('lastName').asStringOrNull(),
        fideRating: pick('fideRating').asIntOrNull(),
        links: pick('links').asStringOrNull(),
      );
}

@freezed
class UserPerf with _$UserPerf {
  const factory UserPerf({
    required int rating,
    required int ratingDeviation,
    required int progression,
    required int numberOfGames,
    bool? provisional,
  }) = _UserPerf;

  factory UserPerf.fromJson(Map<String, dynamic> json) =>
      UserPerf.fromPick(pick(json).required());

  factory UserPerf.fromPick(RequiredPick pick) => UserPerf(
        rating: pick('rating').asIntOrThrow(),
        ratingDeviation: pick('rd').asIntOrThrow(),
        progression: pick('prog').asIntOrThrow(),
        numberOfGames: pick('games').asIntOrThrow(),
        provisional: pick('prov').asBoolOrNull(),
      );
}

@freezed
class UserStatus with _$UserStatus {
  const factory UserStatus({
    required String id,
    required String name,
    bool? online,
    bool? playing,
  }) = _UserStatus;

  factory UserStatus.fromJson(Map<String, dynamic> json) =>
      UserStatus.fromPick(pick(json).required());

  factory UserStatus.fromPick(RequiredPick pick) => UserStatus(
        id: pick('id').asStringOrThrow(),
        name: pick('name').asStringOrThrow(),
        online: pick('online').asBoolOrNull(),
        playing: pick('playing').asBoolOrNull(),
      );
}

@freezed
class UserPerfStatsParameters with _$UserPerfStatsParameters {
  factory UserPerfStatsParameters({
    required String username,
    required Perf perf,
  }) = _UserPerfStatsParameters;
}

@freezed
class UserPerfStats with _$UserPerfStats {
  const factory UserPerfStats({
    required double rating,          // <- These five parameters could be represented as a
    required double deviation,       // <- UserPerf, but doing so would require either to
    bool? provisional,            // <- create a subclass and overriding a method, or adding
    required int totalGames,   // <- a new fromJson() method to UserPerf, because the JSON value
    required int progress,        // <- the API returns are different for each case, as seen below.

    int? rank,
    double? percentile,

    required int berserkGames,
    required int tournamentGames,
    required int ratedGames,
    required int wonGames,
    required int lostGames,
    required int drawnGames,
    required int disconnections,

    double? avgOpponent,
    required Duration timePlayed,

    int? lowestRating,
    UserGame? lowestRatingGame,
    int? highestRating,
    UserGame? highestRatingGame,

    UserStreak? curWinStreak, 
    UserStreak? maxWinStreak,
    UserStreak? curLossStreak,
    UserStreak? maxLossStreak,
    UserStreak? curPlayStreak,
    UserStreak? maxPlayStreak,
    UserStreak? curTimeStreak,
    UserStreak? maxTimeStreak,

    List<UserGame>? worstLosses,
    List<UserGame>? bestWins
  }) = _UserPerfStats;

  factory UserPerfStats.fromJson(Map<String, dynamic> json) =>
    UserPerfStats.fromPick(pick(json).required());

  factory UserPerfStats.fromPick(RequiredPick pick) {
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
        lowestRatingGame: lowest.letOrNull(UserGame.fromPick),

        highestRating: highest('int').asIntOrNull(),
        highestRatingGame: highest.letOrNull(UserGame.fromPick),

        curWinStreak: resultStreak('win', 'cur').letOrNull(UserStreak.fromPick),
        maxWinStreak: resultStreak('win', 'max').letOrNull(UserStreak.fromPick),
        curLossStreak: resultStreak('loss', 'cur').letOrNull(UserStreak.fromPick),
        maxLossStreak: resultStreak('loss', 'max').letOrNull(UserStreak.fromPick),
        curPlayStreak: playStreak('nb', 'cur').letOrNull(UserStreak.fromPick),
        maxPlayStreak: playStreak('nb', 'max').letOrNull(UserStreak.fromPick),
        curTimeStreak: playStreak('time', 'cur').letOrNull(UserStreak.fromPick),
        maxTimeStreak: playStreak('time', 'max').letOrNull(UserStreak.fromPick),

        worstLosses: stat('worstLosses', 'results')
          .asListOrNull((pick) => UserGame.fromPick(pick)),
        bestWins: stat('bestWins', 'results')
          .asListOrNull((pick) => UserGame.fromPick(pick))
      );
  }
}

@freezed
class UserStreak with _$UserStreak {
  const factory UserStreak({
    // This value often represents number of games, but when dealing with
    // time streaks, it represents numberf of seconds playing (consider creating a subclass
    // or something similar?)
    required int value,
    UserGame? startGame,
    UserGame? endGame,
  }) = _UserStreak;

  factory UserStreak.fromJson(Map<String, dynamic> json) =>
    UserStreak.fromPick(pick(json).required());

  factory UserStreak.fromPick(RequiredPick pick) {
      return UserStreak(
        value: pick('v').asIntOrThrow(),
        startGame: pick('from').letOrNull(UserGame.fromPick),
        endGame: pick('to').letOrNull(UserGame.fromPick),
      );
  }
}

@freezed
class UserGame with _$UserGame {
  const factory UserGame({
    required DateTime finishedAt,
    required GameId gameId,
    int? opponentRating,
    String? opponentId,
    String? opponentName,
    String? opponentTitle
  }) = _UserGame;

  factory UserGame.fromJson(Map<String, Object?> json) =>
    UserGame.fromPick(pick(json).required());

  factory UserGame.fromPick(RequiredPick pick) {
    final opId = pick('opId');

    return UserGame(
      finishedAt: pick('at').asDateTimeOrThrow(),
      gameId: pick('gameId').asGameIdOrThrow(),
      opponentRating: pick('opRating').asIntOrNull(),
      opponentId: opId('id').asStringOrNull(),
      opponentName: opId('name').asStringOrNull(),
      opponentTitle: opId('title').asStringOrNull(),
    );
  }
}
