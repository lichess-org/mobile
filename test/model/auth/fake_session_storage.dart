import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/auth/session_storage.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

class FakeSessionStorage implements SessionStorage {
  FakeSessionStorage([AuthSessionState? initial]) : _session = initial;

  AuthSessionState? _session;

  @override
  Future<AuthSessionState?> read() async {
    await Future<void>.delayed(const Duration(milliseconds: 2));
    return _session;
  }

  @override
  Future<void> write(AuthSessionState session) async {
    await Future<void>.delayed(const Duration(milliseconds: 2));
    _session = session;
  }

  @override
  Future<void> delete() async {
    await Future<void>.delayed(const Duration(milliseconds: 2));
    _session = null;
  }
}

const fakeSession = AuthSessionState(
  token: 'testToken',
  user: LightUser(id: UserId('testuser'), name: 'testUser'),
);
