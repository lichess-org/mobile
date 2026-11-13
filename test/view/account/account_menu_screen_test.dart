import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_storage.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/account/account_menu.dart';

import '../../model/auth/fake_auth_storage.dart';
import '../../network/fake_http_client_factory.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

const _bobby = AuthUser(
  token: 'bobbyToken',
  user: LightUser(id: UserId('bobby'), name: 'Bobby'),
);

void main() {
  testWidgets('the account tile expands to show account switching and sign out', (tester) async {
    final app = await makeTestProviderScopeApp(
      tester,
      home: const AccountMenuScreen(),
      authUser: fakeAuthUser,
      overrides: {
        httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
          return FakeHttpClientFactory(
            () => MockClient((request) {
              if (internetCheckUris.contains(request.url)) {
                return mockResponse('', 200);
              }
              if (request.url.path == '/api/account') {
                return mockResponse(
                  '{"id":"testuser","username":"testUser","createdAt":1290415680000,'
                  '"seenAt":1290415680000,"perfs":{}}',
                  200,
                );
              }
              return mockResponse('', 404);
            }),
          );
        }),
      },
    );
    await const AuthStorage().writeOthers(IList(const [_bobby]));
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.text('testUser'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    for (final label in ['Bobby', 'Add account', 'Sign out']) {
      expect(find.text(label), findsNothing, reason: label);
    }

    await tester.tap(find.text('testUser'));
    await tester.pumpAndSettle();

    for (final label in ['Bobby', 'Add account', 'Sign out']) {
      expect(find.text(label), findsOneWidget, reason: label);
    }

    await tester.tap(find.text('testUser'));
    await tester.pumpAndSettle();

    expect(find.text('Sign out'), findsNothing);
  });
}
