import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:deep_pick/deep_pick.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/utils/json.dart';

part 'leaderboard.freezed.dart';

@freezed
class Leaderboard with _$Leaderboard {
  const factory Leaderboard({
    required List<LeaderboardUser> bullet,
    required List<LeaderboardUser> blitz,
    required List<LeaderboardUser> rapid,
    required List<LeaderboardUser> classical,
    required List<LeaderboardUser> ultrabullet,
    required List<LeaderboardUser> crazyhouse,
    required List<LeaderboardUser> chess960,
    required List<LeaderboardUser> kingOfThehill,
    required List<LeaderboardUser> threeCheck,
    required List<LeaderboardUser> antichess,
    required List<LeaderboardUser> atomic,
    required List<LeaderboardUser> horde,
    required List<LeaderboardUser> racingKings,
  }) = _Leaderboard;

  factory Leaderboard.fromJson(Map<String, dynamic> json) =>
      Leaderboard.fromPick(pick(json).required());

  factory Leaderboard.fromPick(RequiredPick pick) {
    return Leaderboard(
      bullet: pick('bullet').asListOrEmpty(LeaderboardUser.fromPick),
      blitz: pick('blitz').asListOrEmpty(LeaderboardUser.fromPick),
      rapid: pick('rapid').asListOrEmpty(LeaderboardUser.fromPick),
      classical: pick('classical').asListOrEmpty(LeaderboardUser.fromPick),
      ultrabullet: pick('ultraBullet').asListOrEmpty(LeaderboardUser.fromPick),
      crazyhouse: pick('crazyhouse').asListOrEmpty(LeaderboardUser.fromPick),
      chess960: pick('chess960').asListOrEmpty(LeaderboardUser.fromPick),
      kingOfThehill:
          pick('kingOfTheHill').asListOrEmpty(LeaderboardUser.fromPick),
      threeCheck: pick('threeCheck').asListOrEmpty(LeaderboardUser.fromPick),
      antichess: pick('antichess').asListOrEmpty(LeaderboardUser.fromPick),
      atomic: pick('atomic').asListOrEmpty(LeaderboardUser.fromPick),
      horde: pick('horde').asListOrEmpty(LeaderboardUser.fromPick),
      racingKings: pick('racingKings').asListOrEmpty(LeaderboardUser.fromPick),
    );
  }
}

@freezed
class LeaderboardUser with _$LeaderboardUser {
  const factory LeaderboardUser({
    required UserId id,
    required String username,
    bool? patron,
    String? title,
    bool? online,
    required int rating,
    required int progress,
  }) = _LeaderboardUser;

  factory LeaderboardUser.fromJson(Map<String, dynamic> json) =>
      LeaderboardUser.fromPick(pick(json).required());

  factory LeaderboardUser.fromPick(RequiredPick pick) {
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
}
