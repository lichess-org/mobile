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
import 'package:material_ui/material_ui.dart';

import '../../model/auth/fake_auth_storage.dart';
import '../../network/fake_http_client_factory.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

const _bobby = AuthUser(
  token: 'bobbyToken',
  user: LightUser(id: UserId('bobby'), name: 'Bobby'),
);

Future<Widget> _makeApp(WidgetTester tester) async {
  final app = await makeTestProviderScopeApp(
    tester,
    home: Scaffold(appBar: AppBar(actions: const [AccountMenuButton()])),
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
  return app;
}

void main() {
  testWidgets('tapping the avatar opens the account menu with the account tile collapsed', (
    tester,
  ) async {
    await tester.pumpWidget(await _makeApp(tester));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(AccountMenuButton));
    await tester.pumpAndSettle();

    expect(find.byType(AccountMenuScreen), findsOneWidget);
    expect(find.text('Bobby'), findsNothing);
  });

  testWidgets('a long press on the avatar opens the account menu with the account tile expanded', (
    tester,
  ) async {
    await tester.pumpWidget(await _makeApp(tester));
    await tester.pumpAndSettle();

    // A tooltip would take the long press.
    expect(
      find.descendant(of: find.byType(AccountMenuButton), matching: find.byType(Tooltip)),
      findsNothing,
    );

    await tester.longPress(find.byType(AccountMenuButton));
    await tester.pumpAndSettle();

    expect(find.byType(AccountMenuScreen), findsOneWidget);
    expect(find.text('Switch account'), findsOneWidget);
    expect(find.text('Bobby'), findsOneWidget);
  });
}
