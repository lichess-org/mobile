import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';

part 'session_storage.g.dart';

@Riverpod(keepAlive: true)
SessionStorage sessionStorage(SessionStorageRef ref) {
  return const SessionStorage(FlutterSecureStorage());
}

class SessionStorage {
  const SessionStorage(FlutterSecureStorage storage) : _storage = storage;

  final FlutterSecureStorage _storage;

  Future<AuthSessionState?> read() async {
    final string = await _storage.read(key: _kSessionStorageKey);
    if (string != null) {
      return AuthSessionState.fromJson(
        jsonDecode(string) as Map<String, dynamic>,
      );
    }
    return null;
  }

  Future<void> write(AuthSessionState session) async {
    await _storage.write(
      key: _kSessionStorageKey,
      value: jsonEncode(session.toJson()),
    );
  }

  Future<void> delete() async {
    await _storage.delete(key: _kSessionStorageKey);
  }
}

const _kSessionStorageKey = '$kLichessHost.userSession';
