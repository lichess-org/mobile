import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/db/secure_storage.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_storage.dart';
import 'package:lichess_mobile/src/model/auth/parental_pin.dart';
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

final _accounts = {
  for (final a in [fakeAuthUser, _bobby]) a.token: a.user,
};

/// Answers each request as the account owning the token it is signed with.
///
/// The accounts of the [kidTokens] are in kid mode. With a [parentalPin], it is set.
Future<Widget> _makeApp(
  WidgetTester tester, {
  Set<String> kidTokens = const {},
  String? parentalPin,
}) async {
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
            switch (request.url.path) {
              case '/api/account':
                final authorization = request.headers['Authorization'] ?? '';
                final account = _accounts.entries.firstWhere((e) => authorization.contains(e.key));
                final user = account.value;
                return mockResponse(
                  '{"id":"${user.id}","username":"${user.name}","createdAt":1290415680000,'
                  '"seenAt":1290415680000,"perfs":{},"kid":${kidTokens.contains(account.key)}}',
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
  await const AuthStorage().writeOthers(IList(const [_bobby]));
  if (parentalPin != null) {
    await SecureStorage.instance.write(
      key: kParentalPinStorageKey,
      value: jsonEncode(StoredParentalPin.create(parentalPin).toJson()),
    );
  }
  return app;
}

UserId? _activeUserId(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(AccountMenuScreen)))
        .read(authControllerProvider)
        ?.user
        .id;

Future<void> _switchToBobby(WidgetTester tester) async {
  await tester.tap(find.text('testUser'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Bobby'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the account tile expands to show account switching and sign out', (tester) async {
    await tester.pumpWidget(await _makeApp(tester));
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

  testWidgets('tapping another account switches to it', (tester) async {
    await tester.pumpWidget(await _makeApp(tester));
    await tester.pumpAndSettle();

    await _switchToBobby(tester);

    expect(_activeUserId(tester), const UserId('bobby'));
  });

  group('parental PIN', () {
    testWidgets('is asked before switching away from a kid account', (tester) async {
      await tester.pumpWidget(
        await _makeApp(tester, kidTokens: {fakeAuthUser.token}, parentalPin: '1234'),
      );
      await tester.pumpAndSettle();

      await _switchToBobby(tester);
      expect(find.text('Enter the parental PIN'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '0000');
      await tester.pumpAndSettle();
      expect(find.text('Wrong PIN.'), findsOneWidget);
      expect(_activeUserId(tester), fakeAuthUser.user.id);

      await tester.enterText(find.byType(TextField), '1234');
      await tester.pumpAndSettle();
      expect(find.text('Enter the parental PIN'), findsNothing);
      expect(_activeUserId(tester), const UserId('bobby'));
    });

    testWidgets('cancelling the PIN does not switch', (tester) async {
      await tester.pumpWidget(
        await _makeApp(tester, kidTokens: {fakeAuthUser.token}, parentalPin: '1234'),
      );
      await tester.pumpAndSettle();

      await _switchToBobby(tester);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(_activeUserId(tester), fakeAuthUser.user.id);
    });

    testWidgets('is not asked when the active account is not in kid mode', (tester) async {
      await tester.pumpWidget(await _makeApp(tester, parentalPin: '1234'));
      await tester.pumpAndSettle();

      await _switchToBobby(tester);

      expect(find.text('Enter the parental PIN'), findsNothing);
      expect(_activeUserId(tester), const UserId('bobby'));
    });

    testWidgets('is not asked without a PIN, even in kid mode', (tester) async {
      await tester.pumpWidget(await _makeApp(tester, kidTokens: {fakeAuthUser.token}));
      await tester.pumpAndSettle();

      await _switchToBobby(tester);

      expect(find.text('Enter the parental PIN'), findsNothing);
      expect(_activeUserId(tester), const UserId('bobby'));
    });
  });
}
