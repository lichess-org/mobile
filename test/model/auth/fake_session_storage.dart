import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/model/auth/user_session.dart';
import 'package:lichess_mobile/src/model/auth/session_storage.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

class FakeSessionStorage implements SessionStorage {
  FakeSessionStorage([UserSession? initial]) : _session = initial;

  UserSession? _session;

  @override
  Future<UserSession?> read() async {
    await Future<void>.delayed(const Duration(milliseconds: 2));
    return _session;
  }

  @override
  Future<void> write(UserSession session) async {
    await Future<void>.delayed(const Duration(milliseconds: 2));
    _session = session;
  }

  @override
  Future<void> delete() async {
    await Future<void>.delayed(const Duration(milliseconds: 2));
    _session = null;
  }
}

const fakeSession = UserSession(
  token: 'testToken',
  user: LightUser(id: UserId('testuser'), name: 'testUser'),
);
