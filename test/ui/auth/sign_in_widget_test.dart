import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';

import 'package:lichess_mobile/src/http_client.dart';
import 'package:lichess_mobile/src/view/auth/sign_in_widget.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import '../../test_utils.dart';
import '../../test_app.dart';

void main() {
  final mockClient = MockClient((request) {
    if (request.url.path != '/api/account') {
      return mockResponse('', 404);
    }
    return mockResponse(testAccountResponse, 200);
  });

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
            httpClientProvider.overrideWithValue(mockClient),
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
            httpClientProvider.overrideWithValue(mockClient),
          ],
        );

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
