import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/db/secure_storage.dart';
import 'package:lichess_mobile/src/model/auth/auth_user.dart';
import 'package:logging/logging.dart';

const kAuthStorageKey = '$kLichessHost.userSession';
const kAuthOtherSessionsStorageKey = '$kLichessHost.otherUserSessions';

final _logger = Logger('AuthStorage');

/// A provider for [AuthStorage].
final authStorageProvider = Provider<AuthStorage>((Ref ref) {
  return const AuthStorage();
}, name: 'AuthStorageProvider');

class const AuthStorage() {
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

  Future<IList<AuthUser>> readOthers() async {
    final string = await SecureStorage.instance.read(key: kAuthOtherSessionsStorageKey);
    if (string == null) {
      return const IListConst([]);
    }
    try {
      return (jsonDecode(string) as List<dynamic>)
          .map((json) => AuthUser.fromJson(json as Map<String, dynamic>))
          .toIList();
    } catch (e, st) {
      // An unreadable value must not block signing in, switching accounts or signing out, which
      // all read it: the other sessions it held are lost, and the user has to sign in to them again.
      _logger.severe('Could not read the other sessions, forgetting them:', e, st);
      await SecureStorage.instance.delete(key: kAuthOtherSessionsStorageKey);
      return const IListConst([]);
    }
  }

  Future<void> writeOthers(IList<AuthUser> others) async {
    if (others.isEmpty) {
      await SecureStorage.instance.delete(key: kAuthOtherSessionsStorageKey);
    } else {
      await SecureStorage.instance.write(
        key: kAuthOtherSessionsStorageKey,
        value: jsonEncode(others.map((authUser) => authUser.toJson()).toList()),
      );
    }
  }
}
