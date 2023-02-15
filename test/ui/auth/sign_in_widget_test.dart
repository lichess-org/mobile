import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/ui/auth/sign_in_widget.dart';
import '../../utils.dart';

class MockClient extends Mock implements http.Client {}

class MockLogger extends Mock implements Logger {}

void main() {
  final mockClient = MockClient();
  final mockLogger = MockLogger();

  testWidgets(
    'SignInWidget',
    (WidgetTester tester) async {
      when(
        () => mockClient.get(
          Uri.parse('$kLichessHost/api/account'),
          headers: any(
            named: 'headers',
            that: sameHeaders({'Authorization': 'Bearer testToken'}),
          ),
        ),
      ).thenAnswer((_) => mockResponse(testAccountResponse, 200));

      final app = await buildTestApp(
        tester,
        home: Consumer(
          builder: (context, ref, _) {
            return Scaffold(
              appBar: AppBar(
                actions: const [
                  SignInWidget(),
                ],
              ),
            );
          },
        ),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            ...defaultProviderOverrides,
            apiClientProvider
                .overrideWithValue(ApiClient(mockLogger, mockClient)),
          ],
          child: app,
        ),
      );

      // first frame is a loading state
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Sign in'), findsOneWidget);

      await tester.tap(find.text('Sign in'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(seconds: 1)); // wait for sign in future

      expect(find.text('Sign in'), findsNothing);
    },
    // fails on iOS, no idea why
    // variant: kPlatformVariant,
  );
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
