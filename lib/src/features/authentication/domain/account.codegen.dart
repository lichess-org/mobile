import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.codegen.freezed.dart';
part 'account.codegen.g.dart';

@Freezed(toJson: false)
class Account with _$Account {
  factory Account({
    required String id,
    required String username,
    String? title,
    required bool patron,
    @JsonKey(fromJson: DateTime.fromMillisecondsSinceEpoch)
        required DateTime createdAt,
    @JsonKey(fromJson: DateTime.fromMillisecondsSinceEpoch)
        required DateTime seenAt,
    required Profile profile,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
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
