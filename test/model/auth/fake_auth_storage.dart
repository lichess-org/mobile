import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

const fakeAuthUser = AuthUser(
  token: 'testToken',
  user: LightUser(id: UserId('testuser'), name: 'testUser'),
);
