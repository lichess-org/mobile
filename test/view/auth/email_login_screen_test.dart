import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/auth/email_login_screen.dart';

import '../../network/fake_http_client_factory.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

const _accountResponse =
    '{"id":"test","username":"test","createdAt":1290415680000,"seenAt":1290415680000,"perfs":{}}';

/// Completions the autocomplete endpoint returns for 'johndoe', used as the username existence
/// check. The prefix 'johndoe2' is included on purpose: only an exact match means the name exists.
const _autocompleteResponse = '["johndoe","johndoe2"]';

/// Client that walks the happy path of the email login protocol.
MockClientHandler happyPath({
  Uri Function(Uri url)? recordUrl,
  int emailStatus = 204,
  int bearerStatus = 200,
  String autocompleteResponse = _autocompleteResponse,
  int autocompleteStatus = 200,
}) {
  return (request) {
    recordUrl?.call(request.url);
    switch (request.url.path) {
      case '/api/player/autocomplete':
        return mockResponse(autocompleteResponse, autocompleteStatus);
      case '/auth/mobile-code/email':
        return mockResponse('', emailStatus);
      case '/auth/mobile-code/bearer':
        return mockResponse('lio_token', bearerStatus);
      case '/api/account':
        return mockResponse(_accountResponse, 200);
      default:
        return mockResponse('', 404);
    }
  };
}

Future<Widget> makeApp(WidgetTester tester, MockClientHandler handler) {
  return makeTestProviderScopeApp(
    tester,
    home: const EmailLoginScreen(),
    overrides: {
      httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
        return FakeHttpClientFactory(() => MockClient(handler));
      }),
    },
  );
}

Future<void> submitEmail(WidgetTester tester, {String username = 'johndoe', String? email}) async {
  await tester.enterText(find.widgetWithText(TextFormField, 'Username'), username);
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Email'),
    email ?? 'johndoe@lichess.org',
  );
  await tester.tap(find.widgetWithText(FilledButton, 'Send me a code'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('moves to the code step once the code has been requested', (tester) async {
    final urls = <Uri>[];
    final app = await makeApp(
      tester,
      happyPath(
        recordUrl: (url) {
          urls.add(url);
          return url;
        },
      ),
    );
    await tester.pumpWidget(app);

    await submitEmail(tester);

    final emailUrl = urls.firstWhere((url) => url.path == '/auth/mobile-code/email');
    expect(emailUrl.queryParameters, {'email': 'johndoe@lichess.org', 'username': 'johndoe'});
    expect(find.textContaining('johndoe@lichess.org'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Sign in'), findsOneWidget);
  });

  testWidgets('does not leave the email step when the request is rate limited', (tester) async {
    final app = await makeApp(tester, happyPath(emailStatus: 429));
    await tester.pumpWidget(app);

    await submitEmail(tester);

    expect(find.widgetWithText(FilledButton, 'Send me a code'), findsOneWidget);
    expect(find.text('Too many attempts. Please try again later.'), findsOneWidget);
  });

  testWidgets('does not send a request for an obviously invalid address', (tester) async {
    var requests = 0;
    final app = await makeApp(tester, (request) {
      requests++;
      return mockResponse('', 204);
    });
    await tester.pumpWidget(app);

    await submitEmail(tester, email: 'not-an-email');

    expect(requests, 0);
    expect(find.text('Please enter a valid email address.'), findsOneWidget);
  });

  testWidgets('does not send a request without a username', (tester) async {
    var requests = 0;
    final app = await makeApp(tester, (request) {
      requests++;
      return mockResponse('', 204);
    });
    await tester.pumpWidget(app);

    await submitEmail(tester, username: '');

    expect(requests, 0);
    expect(find.text('Please enter your username.'), findsOneWidget);
  });

  testWidgets('does not request a code for a username the server does not know', (tester) async {
    final urls = <Uri>[];
    final app = await makeApp(
      tester,
      happyPath(
        recordUrl: (url) {
          urls.add(url);
          return url;
        },
      ),
    );
    await tester.pumpWidget(app);

    // Only a prefix of the known 'johndoe', so the completions come back without an exact match.
    await submitEmail(tester, username: 'johnd');

    expect(urls.single.path, '/api/player/autocomplete');
    expect(urls.single.queryParameters, {'term': 'johnd'});
    expect(find.text("We couldn't find any user by this name: johnd."), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Send me a code'), findsOneWidget);
  });

  testWidgets('requests a code when the username differs only by case', (tester) async {
    final urls = <Uri>[];
    final app = await makeApp(
      tester,
      happyPath(
        recordUrl: (url) {
          urls.add(url);
          return url;
        },
      ),
    );
    await tester.pumpWidget(app);

    await submitEmail(tester, username: 'JohnDoe');

    expect(urls.any((url) => url.path == '/auth/mobile-code/email'), isTrue);
    expect(find.widgetWithText(FilledButton, 'Sign in'), findsOneWidget);
  });

  testWidgets('requests a code anyway when the existence check fails', (tester) async {
    final urls = <Uri>[];
    final app = await makeApp(
      tester,
      happyPath(
        autocompleteStatus: 429,
        recordUrl: (url) {
          urls.add(url);
          return url;
        },
      ),
    );
    await tester.pumpWidget(app);

    await submitEmail(tester, username: 'johnd');
    // The client retries a 429 once after a back-off, which no frame is waiting on.
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // A check that could not be made must never keep a real account from signing in.
    expect(urls.any((url) => url.path == '/auth/mobile-code/email'), isTrue);
    expect(find.widgetWithText(FilledButton, 'Sign in'), findsOneWidget);
  });

  testWidgets('signs the user in and pops when the code is accepted', (tester) async {
    final urls = <Uri>[];
    final app = await makeApp(
      tester,
      happyPath(
        recordUrl: (url) {
          urls.add(url);
          return url;
        },
      ),
    );
    await tester.pumpWidget(app);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(EmailLoginScreen)),
      listen: false,
    );
    // The auth controller is autoDispose: keep it alive so its state survives the screen being
    // popped, and can be read at the end of the test.
    container.listen(authControllerProvider, (_, _) {});

    await submitEmail(tester);

    await tester.enterText(find.byType(TextFormField), 'xxxxxx');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    final bearerUrl = urls.firstWhere((url) => url.path == '/auth/mobile-code/bearer');
    expect(bearerUrl.queryParameters, {
      'email': 'johndoe@lichess.org',
      'username': 'johndoe',
      'code': 'xxxxxx',
    });

    final authUser = container.read(authControllerProvider);
    expect(authUser?.token, 'lio_token');
    expect(authUser?.user.name, 'test');
    expect(find.byType(EmailLoginScreen), findsNothing);
  });

  testWidgets('stays on the code step and clears the field when the code is invalid', (
    tester,
  ) async {
    final app = await makeApp(tester, happyPath(bearerStatus: 404));
    await tester.pumpWidget(app);

    await submitEmail(tester);

    await tester.enterText(find.byType(TextFormField), 'expire');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('This code is invalid or has expired.'), findsOneWidget);
    expect(find.byType(EmailLoginScreen), findsOneWidget);
    expect(tester.widget<TextFormField>(find.byType(TextFormField)).controller?.text, '');
  });

  testWidgets('goes back to the email step from the code step', (tester) async {
    final app = await makeApp(tester, happyPath());
    await tester.pumpWidget(app);

    await submitEmail(tester);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(FilledButton, 'Send me a code'), findsOneWidget);
    // Both fields are kept, so a typo can be fixed without retyping it all.
    expect(
      tester.widget<TextFormField>(find.widgetWithText(TextFormField, 'Username')).controller?.text,
      'johndoe',
    );
    expect(
      tester.widget<TextFormField>(find.widgetWithText(TextFormField, 'Email')).controller?.text,
      'johndoe@lichess.org',
    );
  });
}
