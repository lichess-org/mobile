import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/features/leaderboard/ui/leaderboard_screen.dart';
import 'package:lichess_mobile/src/features/leaderboard/ui/leaderboard_widget.dart';
import 'package:mocktail/mocktail.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;

import 'package:lichess_mobile/src/common/http.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/features/leaderboard/model/leaderboard.dart';
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

  testWidgets('meets accessibility guidelines', (WidgetTester tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();

    final app = await buildTestApp(
      tester,
      home: Consumer(builder: (context, ref, _) {
        return LeaderboardScreen(leaderboard: testLeaderboard);
      }),
    );
    await tester.pumpWidget(ProviderScope(child: app));

    await tester.pump();

    await meetsTapTargetGuideline(tester);

    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

    if (debugDefaultTargetPlatformOverride == TargetPlatform.android) {
      await expectLater(tester, meetsGuideline(textContrastGuideline));
    }
    handle.dispose();
  }, variant: kPlatformVariant);

  testWidgets('leaderbord widget test', (WidgetTester tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();

    final app = await buildTestApp(tester,
        home: Consumer(
            builder: (context, ref, _) =>
                Column(children: const [LeaderboardWidget()])));

    await tester.pumpWidget(ProviderScope(overrides: [
      apiClientProvider.overrideWithValue(ApiClient(mockLogger, mockClient))
    ], child: app));

    await tester.pump(const Duration(milliseconds: 50));

    // 11 leaderboard rows with username test
    expect(find.widgetWithText(Row, 'test'), findsNWidgets(11));

    await meetsTapTargetGuideline(tester);

    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

    if (debugDefaultTargetPlatformOverride == TargetPlatform.android) {
      await expectLater(tester, meetsGuideline(textContrastGuideline));
    }
    handle.dispose();
  }, variant: kPlatformVariant);
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
    racingKings: _fakeList);

final _fakeList = [
  const LightUser(id: 'test', username: 'test', rating: 1000, progress: 10)
];

const testRes = '''
{"bullet":[{"id":"test","username":"test","perfs":{"bullet":{"rating":1000,"progress":10}}}],
"blitz":[{"id":"test","username":"test","perfs":{"bullet":{"rating":1000,"progress":10}}}],
"rapid":[{"id":"test","username":"test","perfs":{"bullet":{"rating":1000,"progress":10}}}],
"classical":[{"id":"test","username":"test","perfs":{"bullet":{"rating":1000,"progress":10}}}],
"ultraBullet":[{"id":"test","username":"test","perfs":{"bullet":{"rating":1000,"progress":10}}}],
"crazyhouse":[{"id":"test","username":"test","perfs":{"bullet":{"rating":1000,"progress":10}}}],
"chess960":[{"id":"test","username":"test","perfs":{"bullet":{"rating":1000,"progress":10}}}],
"kingOfTheHill":[{"id":"test","username":"test","perfs":{"bullet":{"rating":1000,"progress":10}}}],
"threeCheck":[{"id":"test","username":"test","perfs":{"bullet":{"rating":1000,"progress":10}}}],
"antichess":[{"id":"test","username":"test","perfs":{"bullet":{"rating":1000,"progress":10}}}],
"atomic":[{"id":"test","username":"test","perfs":{"bullet":{"rating":1000,"progress":10}}}],
"horde":[{"id":"test","username":"test","perfs":{"bullet":{"rating":1000,"progress":10}}}],
"racingKings":[{"id":"test","username":"test","perfs":{"bullet":{"rating":1000,"progress":10}}}]}
''';
