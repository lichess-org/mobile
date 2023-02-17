import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/ui/user/leaderboard_screen.dart';
import 'package:lichess_mobile/src/ui/user/leaderboard_widget.dart';
import 'package:http/testing.dart';

import 'package:lichess_mobile/src/common/api_client.dart';
import '../../test_utils.dart';
import '../../test_app.dart';

void main() {
  final mockClient = MockClient((request) {
    if (request.url.path == '/api/player') {
      return mockResponse(testRes, 200);
    }
    return mockResponse('', 404);
  });

  group('LeaderboardWidget', () {
    testWidgets(
      'accessibility and basic info showing test',
      (WidgetTester tester) async {
        final SemanticsHandle handle = tester.ensureSemantics();
        final app = await buildTestApp(
          tester,
          home: Column(children: [LeaderboardWidget()]),
          overrides: [httpClientProvider.overrideWithValue(mockClient)],
        );

        await tester.pumpWidget(app);

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

        // await meetsTapTargetGuideline(tester);

        // await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

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
