import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_storage.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

class FakeAuthStorage implements AuthStorage {
  FakeAuthStorage([AuthUser? initial]) : _authUser = initial;

  AuthUser? _authUser;

  @override
  Future<AuthUser?> read() async {
    await Future<void>.delayed(const Duration(milliseconds: 2));
    return _authUser;
  }

  @override
  Future<void> write(AuthUser authUser) async {
    await Future<void>.delayed(const Duration(milliseconds: 2));
    _authUser = authUser;
  }

  @override
  Future<void> delete() async {
    await Future<void>.delayed(const Duration(milliseconds: 2));
    _authUser = null;
  }
}

const fakeAuthUser = AuthUser(
  token: 'testToken',
  user: LightUser(id: UserId('testuser'), name: 'testUser'),
);
