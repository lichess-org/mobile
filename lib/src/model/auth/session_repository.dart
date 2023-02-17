import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'user_session.dart';

part 'session_repository.g.dart';

@Riverpod(keepAlive: true)
SessionRepository sessionRepository(SessionRepositoryRef ref) {
  return const SessionRepository(FlutterSecureStorage());
}

class SessionRepository {
  const SessionRepository(FlutterSecureStorage storage) : _storage = storage;

  final FlutterSecureStorage _storage;

  Future<UserSession?> read() async {
    final string = await _storage.read(key: _kSessionStorageKey);
    if (string != null) {
      return UserSession.fromJson(jsonDecode(string) as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> write(UserSession session) async {
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
