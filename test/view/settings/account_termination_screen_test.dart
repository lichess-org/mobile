import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_storage.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/settings/account_termination_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../network/fake_http_client_factory.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

const _authUser = AuthUser(
  user: LightUser(id: UserId('test'), name: 'test'),
  token: 'test-token',
);

Future<ProviderContainer> pumpTermination(
  WidgetTester tester,
  MockClientHandler handler, {
  AccountTermination termination = .close,
  bool kidMode = false,
}) async {
  final app = await makeTestProviderScopeApp(
    tester,
    home: const Scaffold(body: Text('Root')),
    authUser: _authUser,
    overrides: {
      httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
        return FakeHttpClientFactory(
          () => MockClient((request) {
            if (internetCheckUris.contains(request.url)) {
              return mockResponse('', 200);
            }
            if (request.url.path == '/api/account') {
              return mockResponse(
                jsonEncode({
                  'id': 'test',
                  'username': 'test',
                  'createdAt': 1290415680000,
                  'seenAt': 1290415680000,
                  'perfs': <String, dynamic>{},
                  'kid': kidMode,
                }),
                200,
              );
            }
            return handler(request);
          }),
        );
      }),
    },
  );
  await tester.pumpWidget(app);
  await tester.pumpAndSettle();
  final navigator = tester.state<NavigatorState>(find.byType(Navigator));
  navigator.push<void>(
    MaterialPageRoute<void>(builder: (_) => const Scaffold(body: Text('Settings'))),
  );
  await tester.pumpAndSettle();
  navigator.push<void>(AccountTerminationScreen.buildRoute(termination));
  await tester.pumpAndSettle();
  return ProviderScope.containerOf(
    tester.element(find.byType(AccountTerminationScreen)),
    listen: false,
  );
}

Future<void> enterCredentials(WidgetTester tester) async {
  await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'test');
  await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'secret');
  await tester.pump();
}

Future<void> confirmClose(WidgetTester tester) async {
  final button = find.widgetWithText(FilledButton, 'Close account');
  await tester.ensureVisible(button);
  await tester.tap(button);
  await tester.pumpAndSettle();
  expect(find.text('Yes'), findsOneWidget);
  await tester.tap(find.text('Yes'));
  await tester.pump();
}

Future<void> submitFromKeyboard(WidgetTester tester, String label) async {
  final field = find.widgetWithText(TextFormField, label);
  await tester.ensureVisible(field);
  await tester.showKeyboard(field);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  group('close', () {
    for (final (field, label, message) in const [
      ('username', 'Username', 'Invalid username or password'),
      ('passwd', 'Password', 'Incorrect password'),
      ('token', 'Authentication code', 'Invalid authentication code'),
    ]) {
      testWidgets('maps the $field error to the $label field', (tester) async {
        final container = await pumpTermination(tester, (request) {
          if (request.url.path == '/account/close') {
            return mockResponse(
              jsonEncode({
                field: ['Invalid value'],
              }),
              400,
            );
          }
          return mockResponse('', 404);
        });
        await enterCredentials(tester);

        await confirmClose(tester);
        await tester.pumpAndSettle();

        final input = find.descendant(
          of: find.widgetWithText(TextFormField, label),
          matching: find.byType(TextField),
        );
        expect(tester.widget<TextField>(input).decoration?.errorText, message);
        expect(container.read(authControllerProvider), _authUser);
        expect(find.byType(AccountTerminationScreen), findsOneWidget);
      });
    }

    for (final (status, body, message) in const [
      (429, '', 'Too many attempts. Please try again later.'),
      (500, 'Internal server error', 'Something went wrong.'),
      (400, '{"other":["Unknown error"]}', 'Something went wrong.'),
    ]) {
      testWidgets('shows feedback for HTTP $status with body "$body"', (tester) async {
        await pumpTermination(tester, (request) {
          if (request.url.path == '/account/close') {
            return mockResponse(body, status);
          }
          return mockResponse('', 404);
        });
        await enterCredentials(tester);

        await confirmClose(tester);
        await tester.pumpAndSettle();

        expect(find.text(message), findsOneWidget);
        expect(find.byType(AccountTerminationScreen), findsOneWidget);
      });
    }

    testWidgets('reveals the token field and sends the entered authentication code', (
      tester,
    ) async {
      final requests = <http.Request>[];
      await pumpTermination(tester, (request) {
        if (request.url.path == '/account/close') {
          requests.add(request);
          return mockResponse('{"token":["Invalid code"]}', 400);
        }
        return mockResponse('', 404);
      });
      expect(find.widgetWithText(TextFormField, 'Authentication code'), findsNothing);
      await enterCredentials(tester);
      await confirmClose(tester);
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextFormField, 'Authentication code'), '123456');
      await tester.pump();
      await confirmClose(tester);
      await tester.pumpAndSettle();

      expect(requests, hasLength(2));
      expect(requests.first.bodyFields['token'], '');
      expect(requests.last.method, 'POST');
      expect(requests.last.bodyFields, {
        'username': 'test',
        'passwd': 'secret',
        'token': '123456',
        'forever': 'false',
      });
    });

    testWidgets(
      'successful close clears auth and storage and pops to root without revoking token',
      (tester) async {
        final requests = <http.Request>[];
        final container = await pumpTermination(tester, (request) {
          requests.add(request);
          if (request.url.path == '/account/close') {
            return mockResponse('', 200);
          }
          if (request.method == 'DELETE' && request.url.path == '/api/token') {
            // Closing the account has already invalidated its token.
            return mockResponse('', 401);
          }
          return mockResponse('', 404);
        });
        final authSubscription = container.listen(authControllerProvider, (_, _) {});
        addTearDown(authSubscription.close);
        final signOutSessions = <AuthUser?>[];
        final eventSubscription = authEventsStream.listen((event) {
          if (event == .signOut) signOutSessions.add(container.read(authControllerProvider));
        });
        addTearDown(eventSubscription.cancel);
        expect(container.read(authControllerProvider), _authUser);
        await tester.runAsync(() async {
          expect(await container.read(authStorageProvider).read(), _authUser);
        });
        await enterCredentials(tester);

        await confirmClose(tester);
        await tester.pump(const Duration(seconds: 1));
        await tester.pumpAndSettle();

        expect(container.read(authControllerProvider), isNull);
        expect(signOutSessions, [null]);
        await tester.runAsync(() async {
          expect(await container.read(authStorageProvider).read(), isNull);
        });
        expect(find.text('Root'), findsOneWidget);
        expect(find.text('Settings'), findsNothing);
        expect(find.text('This account is closed.'), findsOneWidget);
        expect(find.byType(AccountTerminationScreen), findsNothing);
        expect(requests.where((r) => r.url.path == '/account/close'), hasLength(1));
        expect(requests.where((r) => r.method == 'DELETE' && r.url.path == '/api/token'), isEmpty);
      },
    );

    testWidgets('leaving the screen while the close is pending still signs out', (tester) async {
      final response = Completer<http.Response>();
      final container = await pumpTermination(tester, (request) {
        if (request.url.path == '/account/close') return response.future;
        return mockResponse('', 404);
      });
      final authSubscription = container.listen(authControllerProvider, (_, _) {});
      addTearDown(authSubscription.close);
      await enterCredentials(tester);
      await confirmClose(tester);

      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await tester.pumpAndSettle();
      expect(find.byType(AccountTerminationScreen), findsNothing);

      response.complete(http.Response('', 204));
      await tester.pumpAndSettle();

      expect(container.read(authControllerProvider), isNull);
      await tester.runAsync(() async {
        expect(await container.read(authStorageProvider).read(), isNull);
      });
    });

    testWidgets('cancelling the confirmation keeps the field errors', (tester) async {
      await pumpTermination(tester, (request) {
        if (request.url.path == '/account/close') {
          return mockResponse('{"passwd":["Incorrect"]}', 400);
        }
        return mockResponse('', 404);
      });
      await enterCredentials(tester);
      await confirmClose(tester);
      await tester.pumpAndSettle();

      final button = find.widgetWithText(FilledButton, 'Close account');
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();
      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();

      final input = find.descendant(
        of: find.widgetWithText(TextFormField, 'Password'),
        matching: find.byType(TextField),
      );
      expect(tester.widget<TextField>(input).decoration?.errorText, 'Incorrect password');
    });

    testWidgets('kid mode does not hide the close account form', (tester) async {
      await pumpTermination(tester, (_) => mockResponse('', 404), kidMode: true);

      expect(find.widgetWithText(TextFormField, 'Username'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
      expect(find.text('Your account is managed and cannot be closed.'), findsNothing);
    });

    testWidgets('a managed-account 404 shows the managed-account message', (tester) async {
      final container = await pumpTermination(tester, (request) {
        if (request.url.path == '/account/close') {
          return mockResponse('', 404);
        }
        return mockResponse('', 404);
      });
      await enterCredentials(tester);

      await confirmClose(tester);
      await tester.pumpAndSettle();

      expect(find.text('Your account is managed and cannot be closed.'), findsOneWidget);
      expect(container.read(authControllerProvider), _authUser);
      expect(find.byType(AccountTerminationScreen), findsOneWidget);
    });

    testWidgets('password keyboard submission cannot confirm an incomplete form', (tester) async {
      var requests = 0;
      await pumpTermination(tester, (request) {
        if (request.url.path == '/account/close') requests++;
        return mockResponse('', 400);
      });

      await submitFromKeyboard(tester, 'Password');
      expect(find.text('Yes'), findsNothing);
      expect(requests, 0);

      await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'secret');
      await submitFromKeyboard(tester, 'Password');
      expect(find.text('Yes'), findsNothing);
      expect(requests, 0);

      await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'test');
      await tester.enterText(find.widgetWithText(TextFormField, 'Password'), '');
      await submitFromKeyboard(tester, 'Password');
      expect(find.text('Yes'), findsNothing);
      expect(requests, 0);
    });

    for (final tokenRequired in [false, true]) {
      final label = tokenRequired ? 'Authentication code' : 'Password';
      testWidgets('$label keyboard submission cannot duplicate a pending close', (tester) async {
        final response = Completer<http.Response>();
        var requests = 0;
        await pumpTermination(tester, (request) {
          if (request.url.path == '/account/close') {
            requests++;
            if (tokenRequired && requests == 1) {
              return mockResponse('{"token":["Required"]}', 400);
            }
            return response.future;
          }
          return mockResponse('', 404);
        });
        await enterCredentials(tester);
        if (tokenRequired) {
          await confirmClose(tester);
          await tester.pumpAndSettle();
          await submitFromKeyboard(tester, label);
          expect(find.text('Yes'), findsNothing);
          expect(requests, 1);
          await tester.enterText(find.widgetWithText(TextFormField, label), '123456');
          await tester.pump();
        }
        await confirmClose(tester);
        await tester.pump(const Duration(milliseconds: 300));
        final expectedRequests = tokenRequired ? 2 : 1;
        expect(requests, expectedRequests);

        await submitFromKeyboard(tester, label);
        final dialog = find.text('Yes');
        final openedDialog = dialog.evaluate().isNotEmpty;
        if (openedDialog) {
          await tester.tap(dialog);
          await tester.pump();
        }
        final pendingRequests = requests;
        response.complete(http.Response('{"passwd":["Incorrect"]}', 400));
        await tester.pumpAndSettle();

        expect(openedDialog, isFalse, reason: 'A pending close must not open another confirmation');
        expect(pendingRequests, expectedRequests);
      });
    }
  });

  group('delete', () {
    Future<void> tickUnderstand(WidgetTester tester) async {
      final checkbox = find.byType(CheckboxListTile);
      await tester.ensureVisible(checkbox);
      await tester.tap(checkbox);
      await tester.pump();
    }

    FilledButton deleteButton(WidgetTester tester) =>
        tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Delete your account'));

    testWidgets('requires the acknowledgement and a confirmation', (tester) async {
      final requests = <http.Request>[];
      final container = await pumpTermination(tester, (request) {
        requests.add(request);
        if (request.url.path == '/account/delete') return mockResponse('', 204);
        return mockResponse('', 404);
      }, termination: .delete);
      final authSubscription = container.listen(authControllerProvider, (_, _) {});
      addTearDown(authSubscription.close);
      await enterCredentials(tester);
      expect(deleteButton(tester).onPressed, isNull);

      await tickUnderstand(tester);
      expect(deleteButton(tester).onPressed, isNotNull);
      final button = find.widgetWithText(FilledButton, 'Delete your account');
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.text('Are you sure you want to delete your account?'), findsOneWidget);
      expect(requests.where((r) => r.url.path == '/account/delete'), isEmpty);
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();

      final deletes = requests.where((r) => r.url.path == '/account/delete');
      expect(deletes, hasLength(1));
      expect(deletes.single.bodyFields, {
        'username': 'test',
        'passwd': 'secret',
        'understand': 'true',
      });
      expect(container.read(authControllerProvider), isNull);
      await tester.runAsync(() async {
        expect(await container.read(authStorageProvider).read(), isNull);
      });
      expect(find.text('Root'), findsOneWidget);
      expect(find.byType(AccountTerminationScreen), findsNothing);
      expect(find.text('Account deletion is pending'), findsOneWidget);
      expect(
        find.textContaining('scheduled for complete deletion in 7 days from now'),
        findsOneWidget,
      );
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.text('Account deletion is pending'), findsNothing);
    });

    testWidgets('maps an incorrect password to the password field', (tester) async {
      final container = await pumpTermination(tester, (request) {
        if (request.url.path == '/account/delete') {
          return mockResponse('{"passwd":["incorrectPassword"]}', 400);
        }
        return mockResponse('', 404);
      }, termination: .delete);
      await enterCredentials(tester);
      await tickUnderstand(tester);
      final button = find.widgetWithText(FilledButton, 'Delete your account');
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();

      final input = find.descendant(
        of: find.widgetWithText(TextFormField, 'Password'),
        matching: find.byType(TextField),
      );
      expect(tester.widget<TextField>(input).decoration?.errorText, 'Incorrect password');
      expect(container.read(authControllerProvider), _authUser);
    });

    testWidgets('offers to close the account instead', (tester) async {
      await pumpTermination(tester, (_) => mockResponse('', 404), termination: .delete);

      await tester.tapOnText(find.textRange.ofSubstring('close your account'));
      await tester.pumpAndSettle();

      final screen = tester.widget<AccountTerminationScreen>(find.byType(AccountTerminationScreen));
      expect(screen.termination, AccountTermination.close);
      expect(find.text('Close account'), findsWidgets);
    });
  });
}
