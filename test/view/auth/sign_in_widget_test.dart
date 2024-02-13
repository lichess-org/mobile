import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/view/auth/sign_in_widget.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_app.dart';
import '../../test_utils.dart';

class MockFlutterAppAuth extends Mock implements FlutterAppAuth {}

class FakeClientFactory implements HttpClientFactory {
  @override
  http.Client call() {
    return MockClient((request) {
      if (request.url.path == '/api/account') {
        return mockResponse(testAccountResponse, 200);
      }
      if (request.method == 'DELETE' && request.url.path == '/api/token') {
        return mockResponse('ok', 200);
      }
      return mockResponse('', 404);
    });
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(
      AuthorizationTokenRequest(
        'testClientId',
        'testRedirectUrl',
        discoveryUrl: 'testDiscoveryUrl',
        scopes: ['testScope'],
      ),
    );
  });

  final mockFlutterAppAuth = MockFlutterAppAuth();

  group('SignInWidget', () {
    testWidgets(
      'meets accessibility guidelines',
      (WidgetTester tester) async {
        final SemanticsHandle handle = tester.ensureSemantics();
        final app = await buildTestApp(
          tester,
          home: Scaffold(
            appBar: AppBar(
              actions: const [
                SignInWidget(),
              ],
            ),
          ),
          overrides: [
            httpClientFactoryProvider.overrideWithValue(FakeClientFactory()),
          ],
        );

        await tester.pumpWidget(app);
        await tester.pumpWidget(app);

        await meetsTapTargetGuideline(tester);

        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        handle.dispose();
      },
      variant: kPlatformVariant,
    );

    testWidgets(
      'sign in and sign out',
      (WidgetTester tester) async {
        final app = await buildTestApp(
          tester,
          home: Scaffold(
            appBar: AppBar(
              actions: const [
                SignInWidget(),
              ],
            ),
          ),
          overrides: [
            appAuthProvider.overrideWithValue(mockFlutterAppAuth),
            httpClientFactoryProvider.overrideWithValue(FakeClientFactory()),
          ],
        );

        final signInResponse = AuthorizationTokenResponse(
          'testToken',
          null,
          null,
          null,
          null,
          null,
          null,
          null,
        );

        when(() => mockFlutterAppAuth.authorizeAndExchangeCode(any()))
            .thenAnswer((_) => delayedAnswer(signInResponse));

        await tester.pumpWidget(app);

        expect(find.text('Sign in'), findsOneWidget);

        await tester.tap(find.text('Sign in'));
        await tester.pump();

        expect(
          tester
              .widget<AppBarTextButton>(
                find.widgetWithText(AppBarTextButton, 'Sign in'),
              )
              .onPressed,
          isNull,
        );

        await tester
            .pump(const Duration(seconds: 1)); // wait for sign in future

        expect(find.text('Sign in'), findsNothing);
      },
      variant: kPlatformVariant,
    );
  });
}

const testAccountResponse = '''
{
  "id": "test",
  "username": "test",
  "createdAt": 1290415680000,
  "seenAt": 1290415680000,
  "title": "GM",
  "patron": true,
  "perfs": {
    "blitz": {
      "games": 2340,
      "rating": 1681,
      "rd": 30,
      "prog": 10
    },
    "rapid": {
      "games": 2340,
      "rating": 1677,
      "rd": 30,
      "prog": 10
    },
    "classical": {
      "games": 2340,
      "rating": 1618,
      "rd": 30,
      "prog": 10
    }
  },
  "profile": {
    "country": "France",
    "location": "Lille",
    "bio": "test bio",
    "firstName": "John",
    "lastName": "Doe",
    "fideRating": 1800,
    "links": "http://test.com"
  }
}
''';
