import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:deep_pick/deep_pick.dart';

part 'leaderboard.freezed.dart';

@freezed
class Leaderboard with _$Leaderboard {
  const factory Leaderboard(
      {required List<LightUser> bullet,
      required List<LightUser> blitz,
      required List<LightUser> rapid,
      required List<LightUser> classical,
      required List<LightUser> ultrabullet,
      required List<LightUser> crazyhouse,
      required List<LightUser> chess960,
      required List<LightUser> kingOfThehill,
      required List<LightUser> threeCheck,
      required List<LightUser> antichess,
      required List<LightUser> atomic,
      required List<LightUser> horde,
      required List<LightUser> racingKings}) = _Leaderboard;

  factory Leaderboard.fromJson(Map<String, dynamic> json) =>
      Leaderboard.fromPick(pick(json).required());

  factory Leaderboard.fromPick(RequiredPick pick) {
    return Leaderboard(
        bullet: pick('bullet').asListOrEmpty(LightUser.fromPick),
        blitz: pick('blitz').asListOrEmpty(LightUser.fromPick),
        rapid: pick('rapid').asListOrEmpty(LightUser.fromPick),
        classical: pick('classical').asListOrEmpty(LightUser.fromPick),
        ultrabullet: pick('ultrabullet').asListOrEmpty(LightUser.fromPick),
        crazyhouse: pick('crazyhouse').asListOrEmpty(LightUser.fromPick),
        chess960: pick('chess960').asListOrEmpty(LightUser.fromPick),
        kingOfThehill: pick('kingOfTheHill').asListOrEmpty(LightUser.fromPick),
        threeCheck: pick('threeCheck').asListOrEmpty(LightUser.fromPick),
        antichess: pick('antichess').asListOrEmpty(LightUser.fromPick),
        atomic: pick('atomic').asListOrEmpty(LightUser.fromPick),
        horde: pick('horde').asListOrEmpty(LightUser.fromPick),
        racingKings: pick('rackingKings').asListOrEmpty(LightUser.fromPick));
  }
}

@freezed
class LightUser with _$LightUser {
  const factory LightUser(
      {required String id,
      required String username,
      bool? patron,
      String? title,
      required int rating,
      required int progress}) = _LightUser;

  factory LightUser.fromJson(Map<String, dynamic> json) =>
      LightUser.fromPick(pick(json).required());

  factory LightUser.fromPick(RequiredPick pick) {
    final prefMap = pick('perfs').asMapOrThrow<String, Map<String, int>>()[
        0]; // find a better way for this
    return LightUser(
      id: pick('id').asStringOrThrow(),
      username: pick('username').asStringOrThrow(),
      title: pick('title').asStringOrNull(),
      patron: pick('patron').asBoolOrNull(),
      rating: prefMap!['rating']!,
      progress: prefMap['progress']!,
    );
  }
}
