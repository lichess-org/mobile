import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lichess_mobile/src/model/common/id.dart';
import 'user.dart';

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
}

@freezed
class LeaderboardUser with _$LeaderboardUser {
  const LeaderboardUser._();

  const factory LeaderboardUser({
    required UserId id,
    required String username,
    bool? patron,
    String? title,
    String? flair,
    bool? online,
    required int rating,
    required int progress,
  }) = _LeaderboardUser;

  LightUser get lightUser =>
      LightUser(id: id, name: username, title: title, flair: flair, isPatron: patron);
}
