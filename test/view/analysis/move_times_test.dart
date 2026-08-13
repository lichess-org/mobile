import 'package:dartchess/dartchess.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/widgets/move_times_chart.dart';

import '../../network/fake_http_client_factory.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

const _gameId = GameId('abcdefgh');

const _moves = 'e4 e5 Nf3 Nc6 Bc4 Bc5 b4 Bxb4';

/// Remaining clock after each of the [_moves], in centiseconds.
const _clocks = [12000, 12000, 11800, 11700, 11500, 11000, 11300, 10600];

Future<Widget> makeTestApp(WidgetTester tester, {List<int> clocks = _clocks}) {
  final mockClient = MockClient((request) {
    if (request.url.path == '/game/export/$_gameId') {
      return mockResponse('''
{
  "id": "${_gameId.value}",
  "rated": true,
  "source": "lobby",
  "variant": "standard",
  "speed": "bullet",
  "perf": "bullet",
  "createdAt": 1706185945680,
  "lastMoveAt": 1706186170504,
  "status": "resign",
  "players": {
    "white": {"user": {"name": "veloce", "id": "veloce"}, "rating": 1789},
    "black": {"user": {"name": "chabrot", "id": "chabrot"}, "rating": 1810}
  },
  "winner": "white",
  "moves": "$_moves",
  ${clocks.isEmpty ? '' : '"clocks": [${clocks.join(',')}],'}
  "clock": {"initial": 120, "increment": 1, "totalTime": 160}
}
''', 200);
    }
    return mockResponse('', 404);
  });

  return makeTestProviderScopeApp(
    tester,
    home: const AnalysisScreen(
      options: AnalysisOptions.archivedGame(orientation: Side.white, gameId: _gameId),
    ),
    overrides: {
      httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
        return FakeHttpClientFactory(() => mockClient);
      }),
    },
  );
}

Future<void> openComputerAnalysisTab(WidgetTester tester) async {
  await tester.tap(find.bySemanticsLabel(RegExp('Computer analysis')));
  await tester.pumpAndSettle();
}

/// The painted area of the chart, which is what the gestures are measured against.
Rect chartPlotRect(WidgetTester tester) => tester.getRect(
  find.descendant(of: find.byType(MoveTimesChart), matching: find.byType(AspectRatio)),
);

void main() {
  group('Move times chart', () {
    testWidgets('is displayed in the computer analysis tab for a game played with a clock', (
      tester,
    ) async {
      await tester.pumpWidget(await makeTestApp(tester));
      await tester.pumpAndSettle();

      expect(find.byType(MoveTimesChart), findsNothing);

      await openComputerAnalysisTab(tester);

      // No server analysis has been requested, so the chart sits below the request button.
      expect(find.textContaining('Request a computer analysis'), findsOneWidget);
      expect(find.byType(MoveTimesChart), findsOneWidget);
      // Total duration of the game, displayed under the chart.
      expect(find.textContaining('Duration'), findsOneWidget);
    });

    testWidgets('is not displayed for a game without clocks', (tester) async {
      await tester.pumpWidget(await makeTestApp(tester, clocks: []));
      await tester.pumpAndSettle();

      await openComputerAnalysisTab(tester);

      expect(find.byType(MoveTimesChart), findsNothing);
    });

    testWidgets('tapping the chart seeks the board to that ply', (tester) async {
      await tester.pumpWidget(await makeTestApp(tester));
      await tester.pumpAndSettle();
      await openComputerAnalysisTab(tester);

      final plot = chartPlotRect(tester);

      // The chart is divided in as many columns as there are moves: tapping in the middle of the
      // 4th one seeks to the 4th ply.
      await tester.tapAt(Offset(plot.left + plot.width * 3.5 / _clocks.length, plot.center.dy));
      await tester.pumpAndSettle();

      expect(tester.widget<MoveTimesChart>(find.byType(MoveTimesChart)).params.currentNodePly, 4);
    });
  });
}
