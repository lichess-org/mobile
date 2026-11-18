import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_storage.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/team/team_providers.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../network/fake_http_client_factory.dart';
import '../../test_container.dart';
import '../../test_helpers.dart';
import '../auth/fake_auth_storage.dart';

const _otherAuthUser = AuthUser(
  token: 'otherToken',
  user: LightUser(id: UserId('otheruser'), name: 'otherUser'),
);

String _teamUpdatesJson(int unread) =>
    '{"byTeam":[{"last":1785681992878,"team":{"id":"coders","name":"Coders"},"unread":$unread}]}';

void main() {
  test('unreadTeamUpdatesCountProvider follows the active account', () async {
    final container = await makeContainer(
      authUser: fakeAuthUser,
      overrides: {
        httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
          return FakeHttpClientFactory(
            () => MockClient((request) {
              final authorization = request.headers['Authorization'] ?? '';
              switch (request.url.path) {
                case '/team/updates':
                  return mockResponse(
                    _teamUpdatesJson(authorization.contains(_otherAuthUser.token) ? 41 : 18),
                    200,
                  );
                case '/api/token/test':
                  return mockResponse('{"${_otherAuthUser.token}":{"userId":"otheruser"}}', 200);
                default:
                  return mockResponse('', 404);
              }
            }),
          );
        }),
      },
    );
    const storage = AuthStorage();
    await storage.write(fakeAuthUser);
    await storage.writeOthers(IList(const [_otherAuthUser]));
    container.listen(unreadTeamUpdatesCountProvider, (_, _) {});

    expect(await container.read(unreadTeamUpdatesCountProvider.future), 18);

    await container.read(authControllerProvider.notifier).switchAccount(_otherAuthUser);

    expect(await container.read(unreadTeamUpdatesCountProvider.future), 41);
  });
}
