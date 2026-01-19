import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/db/secure_storage.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';

const kAuthStorageKey = '$kLichessHost.userSession';

/// A provider for [AuthStorage].
final authStorageProvider = Provider<AuthStorage>((Ref ref) {
  return const AuthStorage();
}, name: 'AuthStorageProvider');

class AuthStorage {
  const AuthStorage();

  Future<AuthUser?> read() async {
    final string = await SecureStorage.instance.read(key: kAuthStorageKey);
    if (string != null) {
      return AuthUser.fromJson(jsonDecode(string) as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> write(AuthUser authUser) async {
    await SecureStorage.instance.write(key: kAuthStorageKey, value: jsonEncode(authUser.toJson()));
  }

  Future<void> delete() async {
    await SecureStorage.instance.delete(key: kAuthStorageKey);
  }
}
