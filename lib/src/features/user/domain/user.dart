import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lichess_mobile/src/common/lichess_icons.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@Freezed(toJson: false)
class User with _$User {
  factory User({
    required String id,
    required String username,
    String? title,
    bool? patron,
    @JsonKey(fromJson: DateTime.fromMillisecondsSinceEpoch)
        required DateTime createdAt,
    @JsonKey(fromJson: DateTime.fromMillisecondsSinceEpoch)
        required DateTime seenAt,
    required Map<Perf, UserPerf> perfs,
    Profile? profile,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@Freezed(toJson: false)
class Profile with _$Profile {
  factory Profile({
    String? country,
    String? location,
    String? bio,
    String? firstName,
    String? lastName,
    int? fideRating,
    String? links,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}

@Freezed(toJson: false)
class UserPerf with _$UserPerf {
  factory UserPerf({
    required int rating,
    @JsonKey(name: 'rd') required int ratingDeviation,
    @JsonKey(name: 'prog') required int progression,
    @JsonKey(name: 'games') required int numberOfGames,
    bool? provisional,
  }) = _UserPerf;

  factory UserPerf.fromJson(Map<String, dynamic> json) =>
      _$UserPerfFromJson(json);
}

@Freezed(toJson: false)
class UserStatus with _$UserStatus {
  factory UserStatus({
    required String id,
    required String name,
    bool? online,
    bool? playing,
  }) = _UserStatus;

  factory UserStatus.fromJson(Map<String, dynamic> json) =>
      _$UserStatusFromJson(json);
}

enum Perf {
  ultraBullet,
  bullet,
  blitz,
  rapid,
  classical,
  correspondence,
  chess960,
  antichess,
  kingOfTheHill,
  threeCheck,
  atomic,
  horde,
  racingKings,
  crazyhouse,
  puzzle,
  storm;

  IconData get icon {
    switch (this) {
      case blitz:
        return LichessIcons.blitz;
      case rapid:
        return LichessIcons.rapid;
      case classical:
        return LichessIcons.classical;
      default:
        throw UnimplementedError('Icon is not yet added!');
    }
  }
}
