import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

@Freezed(fromJson: true, toJson: true)
sealed class AuthUser with _$AuthUser {
  const factory AuthUser({required LightUser user, required String token}) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) => _$AuthUserFromJson(json);
}

class AuthLifecycle {
  AuthLifecycle({required this.onSignIn, required this.onSignOut});
  final Future<void> Function() onSignIn;
  final Future<void> Function() onSignOut;
}

final authLifecycleProvider = StateProvider<AuthLifecycle?>(
  (Ref ref) => null,
  name: 'AuthLifecycleProvider',
);
