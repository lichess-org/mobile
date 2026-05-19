import 'package:deep_pick/deep_pick.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'following_user.freezed.dart';

@freezed
sealed class FollowingUser with _$FollowingUser {
  const factory FollowingUser({
    required LightUser user,
    DateTime? seenAt,
    bool? online,
    bool? playing,
  }) = _FollowingUser;

  factory FollowingUser.fromJson(Map<String, dynamic> json) =>
      _$FollowingUserFromPick(pick(json).required());
}

FollowingUser _$FollowingUserFromPick(RequiredPick pick) {
  final name = pick('name').asStringOrThrow();
  final id = name.toLowerCase();

  return FollowingUser(
    user: LightUser(
      id: UserId(id),
      name: name,
      title: pick('title').asStringOrNull(),
      flair: pick('flair').asStringOrNull(),
      patronColor: pick('patronColor').asIntOrNull(),
      isOnline: pick('online').asBoolOrFalse(),
    ),
    seenAt: pick('seenAt').letOrNull((p) => p.asDateTimeOrNull()),
    playing: pick('playing').asBoolOrFalse(),
  );
}
