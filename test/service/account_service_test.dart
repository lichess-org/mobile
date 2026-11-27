import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/service/account_service.dart';

import '../mock_server_responses.dart';
import '../model/auth/fake_auth_storage.dart';
import '../network/fake_http_client_factory.dart';
import '../test_container.dart';
import '../test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('refreshes the account bookmark count only after successful changes', () async {
    var nbBookmarks = 0;
    var nbAccountRequests = 0;
    var failBookmark = false;
    final mockClient = MockClient((request) {
      if (request.url.path == '/api/account') {
        nbAccountRequests++;
        return mockResponse(
          mockApiAccountResponse('testUser').replaceFirst(
            '"perfs": {',
            '"count": {"all": 20, "win": 10, "draw": 2, "loss": 8, '
                '"bookmark": $nbBookmarks}, "perfs": {',
          ),
          200,
        );
      }
      if (request.method == 'POST' && request.url.path == '/bookmark/abcdefgh') {
        if (failBookmark) return mockResponse('', 400);
        nbBookmarks = request.url.queryParameters['v'] == '1' ? 1 : 0;
        return mockResponse('', 200);
      }
      return mockResponse('', 404);
    });
    final container = await makeContainer(
      authUser: fakeAuthUser,
      overrides: {
        httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
          (ref) => FakeHttpClientFactory(() => mockClient),
        ),
      },
    );
    container.listen(accountProvider, (_, _) {});
    final service = container.read(accountServiceProvider);

    expect((await container.read(accountProvider.future))?.count?.bookmark, 0);

    await service.setGameBookmark(const GameId('abcdefgh'), bookmark: true);
    expect((await container.read(accountProvider.future))?.count?.bookmark, 1);

    await service.setGameBookmark(const GameId('abcdefgh'), bookmark: false);
    expect((await container.read(accountProvider.future))?.count?.bookmark, 0);
    expect(nbAccountRequests, 3);

    failBookmark = true;
    await expectLater(
      service.setGameBookmark(const GameId('abcdefgh'), bookmark: true),
      throwsA(isA<ServerException>()),
    );
    expect((await container.read(accountProvider.future))?.count?.bookmark, 0);
    expect(nbAccountRequests, 3);
  });
}
