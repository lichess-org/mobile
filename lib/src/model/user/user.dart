import 'package:deep_pick/deep_pick.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/utils/json.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@Freezed(fromJson: true, toJson: true)
class LightUser with _$LightUser {
  const factory LightUser({
    required UserId id,
    required String name,
    String? title,
    bool? isPatron,
  }) = _LightUser;

  factory LightUser.fromJson(Map<String, dynamic> json) =>
      _$LightUserFromJson(json);
}

extension LightUserExtension on Pick {
  LightUser asLightUserOrThrow() {
    final requiredPick = this.required();
    final value = requiredPick.value;
    if (value is LightUser) {
      return value;
    }
    if (value is Map<String, dynamic>) {
      return LightUser(
        id: requiredPick('id').asUserIdOrThrow(),
        name: requiredPick('name').asStringOrThrow(),
        title: requiredPick('title').asStringOrNull(),
        isPatron: requiredPick('patron').asBoolOrNull(),
      );
    }
    throw PickException(
      "value $value at $debugParsingExit can't be casted to LightUser",
    );
  }

  LightUser? asLightUserOrNull() {
    if (value == null) return null;
    try {
      return asLightUserOrThrow();
    } catch (_) {
      return null;
    }
  }
}

@freezed
class User with _$User {
  const User._();

  const factory User({
    required UserId id,
    required String username,
    String? title,
    bool? isPatron,
    required DateTime createdAt,
    required DateTime seenAt,
    required IMap<Perf, UserPerf> perfs,
    PlayTime? playTime,
    Profile? profile,
  }) = _User;

  LightUser get lightUser =>
      LightUser(id: id, name: username, title: title, isPatron: isPatron);

  factory User.fromJson(Map<String, dynamic> json) =>
      User.fromPick(pick(json).required());

  factory User.fromPick(RequiredPick pick) {
    final receivedPerfsMap =
        pick('perfs').asMapOrEmpty<String, Map<String, dynamic>>();
    return User(
      id: pick('id').asUserIdOrThrow(),
      username: pick('username').asStringOrThrow(),
      title: pick('title').asStringOrNull(),
      isPatron: pick('patron').asBoolOrNull(),
      createdAt: pick('createdAt').asDateTimeFromMillisecondsOrThrow(),
      seenAt: pick('seenAt').asDateTimeFromMillisecondsOrThrow(),
      playTime: pick('playTime').letOrNull(PlayTime.fromPick),
      profile: pick('profile').letOrNull(Profile.fromPick),
      perfs: IMap({
        for (final entry in receivedPerfsMap.entries)
          if (perfNameMap.containsKey(entry.key) && entry.key != 'storm')
            perfNameMap.get(entry.key)!: UserPerf.fromJson(entry.value),
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
      tv: pick('tv').asDurationFromSecondsOrThrow(),
    );
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
    required UserId id,
    required String name,
    bool? online,
    bool? playing,
  }) = _UserStatus;

  factory UserStatus.fromJson(Map<String, dynamic> json) =>
      UserStatus.fromPick(pick(json).required());

  factory UserStatus.fromPick(RequiredPick pick) => UserStatus(
        id: pick('id').asUserIdOrThrow(),
        name: pick('name').asStringOrThrow(),
        online: pick('online').asBoolOrNull(),
        playing: pick('playing').asBoolOrNull(),
      );
}

@freezed
class UserActivityTournament with _$UserActivityTournament {
  const factory UserActivityTournament({
    required String id,
    required String name,
    required int nbGames,
    required int score,
    required int rank,
    required int rankPercent,
  }) = _UserActivityTournament;

  factory UserActivityTournament.fromJson(Map<String, dynamic> json) =>
      UserActivityTournament.fromPick(pick(json).required());

  factory UserActivityTournament.fromPick(RequiredPick pick) =>
      UserActivityTournament(
        id: pick('tournament', 'id').asStringOrThrow(),
        name: pick('tournament', 'name').asStringOrThrow(),
        nbGames: pick('nbGames').asIntOrThrow(),
        score: pick('score').asIntOrThrow(),
        rank: pick('rank').asIntOrThrow(),
        rankPercent: pick('rankPercent').asIntOrThrow(),
      );
}

@freezed
class UserActivityStreak with _$UserActivityStreak {
  const factory UserActivityStreak({
    required int runs,
    required int score,
  }) = _UserActivityStreak;

  factory UserActivityStreak.fromJson(Map<String, dynamic> json) =>
      UserActivityStreak.fromPick(pick(json).required());

  factory UserActivityStreak.fromPick(RequiredPick pick) => UserActivityStreak(
        runs: pick('runs').asIntOrThrow(),
        score: pick('score').asIntOrThrow(),
      );
}

@freezed
class UserActivityScore with _$UserActivityScore {
  const factory UserActivityScore({
    required int win,
    required int loss,
    required int draw,
    required int ratingBefore,
    required int ratingAfter,
  }) = _UserActivityScore;

  factory UserActivityScore.fromJson(Map<String, dynamic> json) =>
      UserActivityScore.fromPick(pick(json).required());

  factory UserActivityScore.fromPick(RequiredPick pick) => UserActivityScore(
        win: pick('win').asIntOrThrow(),
        loss: pick('loss').asIntOrThrow(),
        draw: pick('draw').asIntOrThrow(),
        ratingBefore: pick('rp', 'before').asIntOrThrow(),
        ratingAfter: pick('rp', 'after').asIntOrThrow(),
      );
}

@freezed
class UserActivity with _$UserActivity {
  const UserActivity._();

  const factory UserActivity({
    required DateTime startTime,
    required DateTime endTime,
    IMap<Perf, UserActivityScore>? games,
    int? followInNb,
    int? followOutNb,
    UserActivityTournament? bestTournament,
    int? tournamentNb,
    UserActivityScore? puzzles,
    UserActivityStreak? streak,
    UserActivityStreak? storm,
    UserActivityScore? correspondenceEnds,
    int? correspondenceMovesNb,
    int? correspondenceGamesNb,
  }) = _UserActivity;

  bool get isEmpty =>
      games == null &&
      followInNb == null &&
      followOutNb == null &&
      tournamentNb == null &&
      bestTournament == null &&
      puzzles == null &&
      streak == null &&
      correspondenceEnds == null &&
      correspondenceMovesNb == null &&
      correspondenceGamesNb == null;

  bool get isNotEmpty => !isEmpty;
}

@freezed
class UserPerfStats with _$UserPerfStats {
  const factory UserPerfStats({
    required double rating,
    required double deviation,
    bool? provisional,
    required int totalGames,
    required int progress,
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
    UserPerfGame? lowestRatingGame,
    int? highestRating,
    UserPerfGame? highestRatingGame,
    UserStreak? curWinStreak,
    UserStreak? maxWinStreak,
    UserStreak? curLossStreak,
    UserStreak? maxLossStreak,
    UserStreak? curPlayStreak,
    UserStreak? maxPlayStreak,
    UserStreak? curTimeStreak,
    UserStreak? maxTimeStreak,
    IList<UserPerfGame>? worstLosses,
    IList<UserPerfGame>? bestWins,
  }) = _UserPerfStats;
}

@freezed
class UserStreak with _$UserStreak {
  const factory UserStreak.gameStreak({
    required int gamesPlayed,
    required bool isValueEmpty,
    required UserPerfGame? startGame,
    required UserPerfGame? endGame,
  }) = UserGameStreak;

  const factory UserStreak.timeStreak({
    required Duration timePlayed,
    required bool isValueEmpty,
    required UserPerfGame? startGame,
    required UserPerfGame? endGame,
  }) = UserTimeStreak;
}

@freezed
class UserPerfGame with _$UserPerfGame {
  const factory UserPerfGame({
    required DateTime finishedAt,
    required GameId gameId,
    int? opponentRating,
    String? opponentId,
    String? opponentName,
    String? opponentTitle,
  }) = _UserPerfGame;
}
