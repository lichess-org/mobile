import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

const _mary = AuthUser(
  token: 'maryToken',
  user: LightUser(id: UserId('mary'), name: 'Mary'),
);

final _accounts = {
  for (final a in [fakeAuthUser, _bobby, _mary]) a.token: a.user,
};

/// Answers each request as the account owning the token it is signed with.
Future<Widget> _makeApp(
  WidgetTester tester, {
  IList<AuthUser> others = const IListConst([]),
}) async {
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
            switch (request.url.path) {
              case '/api/account':
                final authorization = request.headers['Authorization'] ?? '';
                final user = _accounts.entries
                    .firstWhere((e) => authorization.contains(e.key))
                    .value;
                return mockResponse(
                  '{"id":"${user.id}","username":"${user.name}","createdAt":1290415680000,'
                  '"seenAt":1290415680000,"perfs":{}}',
                  200,
                );
              case '/api/token/test':
                final token = request.body;
                return mockResponse('{"$token":{"userId":"x"}}', 200);
              default:
                return mockResponse('', 404);
            }
          }),
        );
      }),
    },
  );
  await const AuthStorage().writeOthers(others);
  return app;
}

UserId? _activeUserId(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(AccountMenuButton)))
        .read(authControllerProvider)
        ?.user
        .id;

Future<void> _swipeDown(WidgetTester tester) async {
  await tester.fling(find.byType(AccountMenuButton), const Offset(0, 80), 1000);
  await tester.pumpAndSettle();
}

Future<void> _swipeUp(WidgetTester tester) async {
  await tester.fling(find.byType(AccountMenuButton), const Offset(0, -80), 1000);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('swiping down on the avatar switches to the other account', (tester) async {
    await tester.pumpWidget(await _makeApp(tester, others: IList(const [_bobby])));
    await tester.pumpAndSettle();

    await _swipeDown(tester);

    expect(_activeUserId(tester), const UserId('bobby'));
    expect(find.text('Switched to Bobby'), findsOneWidget);
    expect(await const AuthStorage().readOthers(), IList(const [fakeAuthUser]));
  });

  testWidgets('swiping down again and again goes through all the accounts, by name', (
    tester,
  ) async {
    // Most recently used first, which must not change the order of the accounts.
    await tester.pumpWidget(await _makeApp(tester, others: IList(const [_mary, _bobby])));
    await tester.pumpAndSettle();

    // Bobby, Mary, testUser: from testUser, the next account is the first one.
    await _swipeDown(tester);
    expect(_activeUserId(tester), const UserId('bobby'));

    await _swipeDown(tester);
    expect(_activeUserId(tester), const UserId('mary'));

    await _swipeDown(tester);
    expect(_activeUserId(tester), fakeAuthUser.user.id);
  });

  testWidgets('swiping up goes through the accounts the other way round', (tester) async {
    await tester.pumpWidget(await _makeApp(tester, others: IList(const [_bobby, _mary])));
    await tester.pumpAndSettle();

    await _swipeUp(tester);
    expect(_activeUserId(tester), const UserId('mary'));

    await _swipeUp(tester);
    expect(_activeUserId(tester), const UserId('bobby'));

    await _swipeUp(tester);
    expect(_activeUserId(tester), fakeAuthUser.user.id);
  });

  testWidgets('swiping down then up goes back to the first account', (tester) async {
    await tester.pumpWidget(await _makeApp(tester, others: IList(const [_bobby, _mary])));
    await tester.pumpAndSettle();

    await _swipeDown(tester);
    expect(_activeUserId(tester), const UserId('bobby'));

    await _swipeUp(tester);
    expect(_activeUserId(tester), fakeAuthUser.user.id);
  });

  testWidgets('a drag that stops before the finger is lifted still switches', (tester) async {
    await tester.pumpWidget(await _makeApp(tester, others: IList(const [_bobby])));
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(tester.getCenter(find.byType(AccountMenuButton)));
    await gesture.moveBy(const Offset(0, 40));
    await gesture.moveBy(const Offset(0, 40));
    // Holding the finger still makes the drag end with no velocity.
    await tester.pump(const Duration(seconds: 1));
    await gesture.up();
    await tester.pumpAndSettle();

    expect(_activeUserId(tester), const UserId('bobby'));
  });

  testWidgets('a short drag does not switch', (tester) async {
    await tester.pumpWidget(await _makeApp(tester, others: IList(const [_bobby])));
    await tester.pumpAndSettle();

    await tester.timedDrag(
      find.byType(AccountMenuButton),
      const Offset(0, 30),
      const Duration(milliseconds: 300),
    );
    await tester.pumpAndSettle();

    expect(_activeUserId(tester), fakeAuthUser.user.id);
  });

  testWidgets('swiping down does nothing without other accounts', (tester) async {
    await tester.pumpWidget(await _makeApp(tester));
    await tester.pumpAndSettle();

    await _swipeDown(tester);

    expect(_activeUserId(tester), fakeAuthUser.user.id);
    expect(find.textContaining('Switched to'), findsNothing);
  });
}
