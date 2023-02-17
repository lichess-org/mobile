import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/ui/user/leaderboard_screen.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/model/user/leaderboard.dart';
import '../../test_utils.dart';
import '../../test_app.dart';

void main() {
  group('LeaderboardScreen', () {
    testWidgets(
      'meets accessibility guidelines',
      (WidgetTester tester) async {
        final SemanticsHandle handle = tester.ensureSemantics();

        final app = await buildTestApp(
          tester,
          home: LeaderboardScreen(leaderboard: testLeaderboard),
        );

        await tester.pumpWidget(app);

        await tester.pump();

        // TODO find why it fails on android
        // await meetsTapTargetGuideline(tester);

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

final testLeaderboard = Leaderboard(
  bullet: _fakeList,
  blitz: _fakeList,
  rapid: _fakeList,
  classical: _fakeList,
  ultrabullet: _fakeList,
  crazyhouse: _fakeList,
  chess960: _fakeList,
  kingOfThehill: _fakeList,
  threeCheck: _fakeList,
  antichess: _fakeList,
  atomic: _fakeList,
  horde: _fakeList,
  racingKings: _fakeList,
);

final _fakeList = [
  const LeaderboardUser(
    id: UserId('test'),
    username: 'test',
    rating: 1000,
    progress: 10,
  )
];
