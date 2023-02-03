import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/features/user/ui/leaderboard_screen.dart';
import 'package:lichess_mobile/src/features/user/ui/leaderboard_widget.dart';
import 'package:mocktail/mocktail.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;

import 'package:lichess_mobile/src/common/http.dart';
import 'package:lichess_mobile/src/constants.dart';
import '../../../utils.dart';

class MockClient extends Mock implements http.Client {}

class MockApiClient extends Mock implements ApiClient {}

class MockLogger extends Mock implements Logger {}

void main() {
  final mockClient = MockClient();
  final mockLogger = MockLogger();

  setUpAll(() {
    when(() => mockClient.get(Uri.parse('$kLichessHost/api/player')))
        .thenAnswer((_) => mockResponse(testRes, 200));
  });

  group('LeaderboardWidget', () {
    testWidgets(
      'accessibility and basic info showing test',
      (WidgetTester tester) async {
        final SemanticsHandle handle = tester.ensureSemantics();
        final app = await buildTestApp(
          tester,
          home: Consumer(
            builder: (context, ref, _) =>
                Column(children: [LeaderboardWidget()]),
          ),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              ...defaultProviderOverrides,
              apiClientProvider
                  .overrideWithValue(ApiClient(mockLogger, mockClient))
            ],
            child: app,
          ),
        );

        await tester.pump(const Duration(milliseconds: 50));

        for (final name in [
          'bulletUser',
          'blitzUser',
          'rapidUser',
          'classicalUser'
        ]) {
          expect(
            find.widgetWithText(LeaderboardListTile, name),
            findsOneWidget,
          );
        }

        await meetsTapTargetGuideline(tester);

        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

        if (debugDefaultTargetPlatformOverride == TargetPlatform.android) {
          await expectLater(tester, meetsGuideline(textContrastGuideline));
        }
        handle.dispose();
      },
      variant: kPlatformVariant,
    );
  });
}

const testRes = '''
{"bullet":[{"id":"bulletuser","username":"bulletUser","perfs":{"bullet":{"rating":1000,"progress":10}}}],
"blitz":[{"id":"blitzuser","username":"blitzUser","perfs":{"bullet":{"rating":1000,"progress":10}}}],
"rapid":[{"id":"rapiduser","username":"rapidUser","perfs":{"bullet":{"rating":1000,"progress":10}}}],
"classical":[{"id":"classicaluser","username":"classicalUser","perfs":{"bullet":{"rating":1000,"progress":10}}}],
"ultraBullet":[{"id":"ultrauser","username":"ultrabulletUser","perfs":{"bullet":{"rating":1000,"progress":10}}}],
"crazyhouse":[{"id":"test","username":"test","perfs":{"bullet":{"rating":1000,"progress":10}}}],
"chess960":[{"id":"test","username":"test","perfs":{"bullet":{"rating":1000,"progress":10}}}],
"kingOfTheHill":[{"id":"test","username":"test","perfs":{"bullet":{"rating":1000,"progress":10}}}],
"threeCheck":[{"id":"test","username":"test","perfs":{"bullet":{"rating":1000,"progress":10}}}],
"antichess":[{"id":"test","username":"test","perfs":{"bullet":{"rating":1000,"progress":10}}}],
"atomic":[{"id":"test","username":"test","perfs":{"bullet":{"rating":1000,"progress":10}}}],
"horde":[{"id":"test","username":"test","perfs":{"bullet":{"rating":1000,"progress":10}}}],
"racingKings":[{"id":"test","username":"test","perfs":{"bullet":{"rating":1000,"progress":10}}}]}
''';
