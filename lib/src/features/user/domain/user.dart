import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lichess_mobile/src/common/lichess_icons.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      title: json['title'],
      patron: json['patron'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      seenAt: DateTime.fromMillisecondsSinceEpoch(json['seenAt']),
      profile: Profile.fromJson(json['profile']),
      perfs: Map.unmodifiable({
        for (final entry in json['perfs'].entries)
          if (entry.key != 'storm')
            Perf.values.byName(entry.key): UserPerf.fromJson(entry.value)
      }),
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

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}

@freezed
class UserPerf with _$UserPerf {
  const factory UserPerf({
    required int rating,
    @JsonKey(name: 'rd') required int ratingDeviation,
    @JsonKey(name: 'prog') required int progression,
    @JsonKey(name: 'games') required int numberOfGames,
    bool? provisional,
  }) = _UserPerf;

  factory UserPerf.fromJson(Map<String, dynamic> json) =>
      _$UserPerfFromJson(json);
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
