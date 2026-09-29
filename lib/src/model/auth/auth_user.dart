import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

@Freezed(fromJson: true, toJson: true)
sealed class AuthUser with _$AuthUser {
  const factory({required LightUser user, required String token}) = _AuthUser;

  factory fromJson(Map<String, dynamic> json) => _$AuthUserFromJson(json);
}
