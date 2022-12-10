import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:deep_pick/deep_pick.dart';

import 'package:lichess_mobile/src/common/lichess_icons.dart';
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
      createdAt: pick('createdAt').asDateTimeFromIntOrThrow(),
      seenAt: pick('seenAt').asDateTimeFromIntOrThrow(),
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
