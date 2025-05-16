import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/user/profile.dart';
import 'package:lichess_mobile/src/utils/json.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@Freezed(fromJson: true, toJson: true)
sealed class LightUser with _$LightUser {
  const factory LightUser({
    required UserId id,
    required String name,
    String? title,
    String? flair,
    bool? isPatron,
    bool? isOnline,
  }) = _LightUser;

  factory LightUser.fromJson(Map<String, dynamic> json) => _$LightUserFromJson(json);
}

extension LightUserExtension on Pick {
  LightUser asLightUserOrThrow() {
    final requiredPick = this.required();
    final value = requiredPick.value;
    if (value is LightUser) {
      return value;
    }
    if (value is Map<String, dynamic>) {
      final name =
          requiredPick('username').asStringOrNull() ?? requiredPick('name').asStringOrThrow();

      return LightUser(
        id: requiredPick('id').asUserIdOrThrow(),
        name: name,
        title: requiredPick('title').asStringOrNull(),
        flair: requiredPick('flair').asStringOrNull(),
        isPatron: requiredPick('patron').asBoolOrNull(),
        isOnline: requiredPick('online').asBoolOrNull(),
      );
    }
    throw PickException("value $value at $debugParsingExit can't be casted to LightUser");
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
sealed class TemporaryBan with _$TemporaryBan {
  const factory TemporaryBan({required DateTime date, required Duration duration}) = _TemporaryBan;
}

@freezed
sealed class User with _$User {
  const User._();

  const factory User({
    required UserId id,
    required String username,
    String? title,
    String? flair,
    bool? isPatron,
    bool? disabled,
    bool? tosViolation,

    /// If true it means a BOT account is verified and can be featured
    bool? verified,
    DateTime? createdAt,
    DateTime? seenAt,
    required IMap<Perf, UserPerf> perfs,
    PlayTime? playTime,
    Profile? profile,
    UserGameCount? count,
    bool? followable,
    bool? following,
    bool? blocking,
    bool? canChallenge,
    bool? kid,
    TemporaryBan? playban,
  }) = _User;

  LightUser get lightUser =>
      LightUser(id: id, name: username, title: title, isPatron: isPatron, flair: flair);

  factory User.fromServerJson(Map<String, dynamic> json) => User.fromPick(pick(json).required());

  factory User.fromPick(RequiredPick pick) {
    final receivedPerfsMap = pick('perfs').asMapOrEmpty<String, Map<String, dynamic>>();
    return User(
      id: pick('id').asUserIdOrThrow(),
      username: pick('username').asStringOrThrow(),
      title: pick('title').asStringOrNull(),
      flair: pick('flair').asStringOrNull(),
      isPatron: pick('patron').asBoolOrNull(),
      disabled: pick('disabled').asBoolOrNull(),
      tosViolation: pick('tosViolation').asBoolOrNull(),
      verified: pick('verified').asBoolOrNull(),
      createdAt: pick('createdAt').asDateTimeFromMillisecondsOrNull(),
      seenAt: pick('seenAt').asDateTimeFromMillisecondsOrNull(),
      playTime: pick('playTime').letOrNull(PlayTime.fromPick),
      profile: pick('profile').letOrNull(Profile.fromPick),
      count: pick('count').letOrNull(UserGameCount.fromPick),
      perfs: IMap({
        for (final entry in receivedPerfsMap.entries)
          if (Perf.nameMap.containsKey(entry.key))
            Perf.nameMap.get(entry.key)!:
                (['storm', 'streak'].contains(entry.key))
                    ? UserPerf.fromJsonStreak(entry.value)
                    : UserPerf.fromJson(entry.value),
      }),
      followable: pick('followable').asBoolOrNull(),
      following: pick('following').asBoolOrNull(),
      blocking: pick('blocking').asBoolOrNull(),
      canChallenge: pick('canChallenge').asBoolOrNull(),
      kid: pick('kid').asBoolOrNull(),
      playban: pick('playban').letOrNull((p) {
        return TemporaryBan(
          date: p('date').asDateTimeFromMillisecondsOrThrow(),
          duration: p('mins').asDurationFromMinutesOrThrow(),
        );
      }),
    );
  }

  String get initials =>
      profile?.realName?.split(' ').take(2).map((e) => e[0]).join().toUpperCase() ??
      username[0].toUpperCase();
}

@freezed
sealed class UserGameCount with _$UserGameCount {
  const factory UserGameCount({
    required int all,
    // TODO(#454): enable rest of fields when needed for filtering
    // required int rated,
    // required int ai,
    // required int draw,
    // required int drawH,
    // required int win,
    // required int winH,
    // required int loss,
    // required int lossH,
    required int bookmark,
    // required int playing,
    // required int imported,
    // required int me,
  }) = _UserGameCount;

  factory UserGameCount.fromJson(Map<String, dynamic> json) =>
      UserGameCount.fromPick(pick(json).required());

  factory UserGameCount.fromPick(RequiredPick pick) => UserGameCount(
    all: pick('all').asIntOrThrow(),
    // TODO(#454): enable rest of fields when needed for filtering
    // rated: pick('rated').asIntOrThrow(),
    // ai: pick('ai').asIntOrThrow(),
    // draw: pick('draw').asIntOrThrow(),
    // drawH: pick('drawH').asIntOrThrow(),
    // win: pick('win').asIntOrThrow(),
    // winH: pick('winH').asIntOrThrow(),
    // loss: pick('loss').asIntOrThrow(),
    // lossH: pick('lossH').asIntOrThrow(),
    bookmark: pick('bookmark').asIntOrThrow(),
    // playing: pick('playing').asIntOrThrow(),
    // imported: pick('import').asIntOrThrow(),
    // me: pick('me').asIntOrThrow(),
  );
}

@freezed
sealed class PlayTime with _$PlayTime {
  const factory PlayTime({required Duration total, required Duration tv}) = _PlayTime;

  factory PlayTime.fromJson(Map<String, dynamic> json) => PlayTime.fromPick(pick(json).required());

  factory PlayTime.fromPick(RequiredPick pick) {
    return PlayTime(
      total: pick('total').asDurationFromSecondsOrThrow(),
      tv: pick('tv').asDurationFromSecondsOrThrow(),
    );
  }
}

@freezed
sealed class UserPerf with _$UserPerf {
  const UserPerf._();

  const factory UserPerf({
    required int rating,
    required int ratingDeviation,
    required int progression,
    int? games,
    int? runs,
    bool? provisional,
  }) = _UserPerf;

  factory UserPerf.fromJson(Map<String, dynamic> json) => UserPerf.fromPick(pick(json).required());

  factory UserPerf.fromPick(RequiredPick pick) => UserPerf(
    rating: pick('rating').asIntOrThrow(),
    ratingDeviation: pick('rd').asIntOrThrow(),
    progression: pick('prog').asIntOrThrow(),
    games: pick('games').asIntOrNull(),
    runs: pick('runs').asIntOrNull(),
    provisional: pick('prov').asBoolOrNull(),
  );

  factory UserPerf.fromJsonStreak(Map<String, dynamic> json) => UserPerf(
    rating: UserActivityStreak.fromJson(json).score,
    ratingDeviation: 0,
    progression: 0,
    runs: UserActivityStreak.fromJson(json).runs,
    provisional: null,
  );

  int get numberOfGamesOrRuns => games ?? runs ?? 0;
}

@freezed
sealed class UserStatus with _$UserStatus {
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
sealed class UserActivityTournament with _$UserActivityTournament {
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

  factory UserActivityTournament.fromPick(RequiredPick pick) => UserActivityTournament(
    id: pick('tournament', 'id').asStringOrThrow(),
    name: pick('tournament', 'name').asStringOrThrow(),
    nbGames: pick('nbGames').asIntOrThrow(),
    score: pick('score').asIntOrThrow(),
    rank: pick('rank').asIntOrThrow(),
    rankPercent: pick('rankPercent').asIntOrThrow(),
  );
}

@freezed
sealed class UserActivityStreak with _$UserActivityStreak {
  const factory UserActivityStreak({required int runs, required int score}) = _UserActivityStreak;

  factory UserActivityStreak.fromJson(Map<String, dynamic> json) =>
      UserActivityStreak.fromPick(pick(json).required());

  factory UserActivityStreak.fromPick(RequiredPick pick) =>
      UserActivityStreak(runs: pick('runs').asIntOrThrow(), score: pick('score').asIntOrThrow());
}

@freezed
sealed class UserActivityScore with _$UserActivityScore {
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
sealed class UserActivity with _$UserActivity {
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
sealed class UserPerfStats with _$UserPerfStats {
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
sealed class UserStreak with _$UserStreak {
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
sealed class UserPerfGame with _$UserPerfGame {
  const UserPerfGame._();

  const factory UserPerfGame({
    required DateTime finishedAt,
    required GameId gameId,
    int? opponentRating,
    String? opponentId,
    String? opponentName,
    String? opponentTitle,
  }) = _UserPerfGame;

  LightUser? get opponent =>
      opponentId != null && opponentName != null
          ? LightUser(id: UserId(opponentId!), name: opponentName!, title: opponentTitle)
          : null;
}

@immutable
class UserRatingHistoryPerf {
  final Perf perf;
  final IList<UserRatingHistoryPoint> points;

  const UserRatingHistoryPerf({required this.perf, required this.points});
}

@immutable
class UserRatingHistoryPoint {
  final DateTime date;
  final int elo;

  const UserRatingHistoryPoint({required this.date, required this.elo});
}
