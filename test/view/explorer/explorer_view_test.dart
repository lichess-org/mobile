import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/explorer/explorer_view.dart';
import 'package:lichess_mobile/src/view/explorer/opening_explorer_view.dart';
import 'package:lichess_mobile/src/view/explorer/tablebase_view.dart';

import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

void main() {
  final mockClient = MockClient((request) {
    if (request.url.host == 'explorer.lichess.ovh') {
      if (request.url.path == '/masters') {
        return mockResponse(mastersOpeningExplorerResponse, 200);
      }
    }
    if (request.url.host == 'tablebase.lichess.ovh') {
      if (request.url.path == '/standard') {
        return mockResponse(tablebaseResponse, 200);
      }
    }
    return mockResponse('', 404);
  });

  group('ExplorerView', () {
    testWidgets('shows opening explorer for initial position', (WidgetTester tester) async {
      const position = Chess.initial;

      final app = await makeTestProviderScopeApp(
        tester,
        home: Scaffold(
          body: ExplorerView(
            position: position,
            onMoveSelected: (move) {},
            isComputerAnalysisAllowed: true,
          ),
        ),
        overrides: [defaultClientProvider.overrideWithValue(mockClient)],
      );
      await tester.pumpWidget(app);

      // wait for opening explorer data to load
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.byType(OpeningExplorerView), findsOneWidget);
      expect(find.byType(TablebaseView), findsNothing);
    });
    testWidgets('shows opening explorer for position with >8 pieces', (WidgetTester tester) async {
      final position = Chess.fromSetup(
        Setup.parseFen('r4rk1/pb2qppp/2n1pn2/1pb5/8/PP1N1NP1/1Q2PPBP/R1B2RK1 b - - 2 15'),
      );

      final app = await makeTestProviderScopeApp(
        tester,
        home: Scaffold(
          body: ExplorerView(
            position: position,
            onMoveSelected: (move) => {},
            isComputerAnalysisAllowed: true,
          ),
        ),
        overrides: [defaultClientProvider.overrideWithValue(mockClient)],
      );
      await tester.pumpWidget(app);

      // wait for opening explorer data to load
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.byType(OpeningExplorerView), findsOneWidget);
      expect(find.byType(TablebaseView), findsNothing);
    });

    testWidgets('shows tablebase for 8-piece endgame', (WidgetTester tester) async {
      // 8-piece endgame position
      final position = Chess.fromSetup(Setup.parseFen('6k1/8/8/8/3RPP1P/4K3/4N2q/8 b - - 0 114'));

      final app = await makeTestProviderScopeApp(
        tester,
        home: Scaffold(
          body: ExplorerView(
            position: position,
            onMoveSelected: (move) => {},
            isComputerAnalysisAllowed: true,
          ),
        ),
        overrides: [defaultClientProvider.overrideWithValue(mockClient)],
      );
      await tester.pumpWidget(app);

      // wait for tablebase data to load
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.byType(TablebaseView), findsOneWidget);
      expect(find.byType(OpeningExplorerView), findsNothing);
    });
    testWidgets('shows tablebase for endgame position', (WidgetTester tester) async {
      final position = Chess.fromSetup(Setup.parseFen('4k3/8/4q3/4PR2/5P2/6NK/8/8 w - - 3 131'));

      final app = await makeTestProviderScopeApp(
        tester,
        home: Scaffold(
          body: ExplorerView(
            position: position,
            onMoveSelected: (move) => {},
            isComputerAnalysisAllowed: true,
          ),
        ),
        overrides: [defaultClientProvider.overrideWithValue(mockClient)],
      );
      await tester.pumpWidget(app);

      // wait for tablebase data to load
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.byType(TablebaseView), findsOneWidget);
      expect(find.byType(OpeningExplorerView), findsNothing);
      // Check if the specific move is parsed correctly
      expect(find.text('Winning'), findsOneWidget);
      expect(find.text('Kh4'), findsOneWidget);
    });

    testWidgets('shows checkmate message for checkmate position', (WidgetTester tester) async {
      // Fool's mate position
      final position = Chess.fromSetup(
        Setup.parseFen('r1bqkb1r/pppp1Qpp/2n2n2/4p3/2B1P3/8/PPPP1PPP/RNB1K1NR b KQkq - 0 4'),
      );

      final app = await makeTestProviderScopeApp(
        tester,
        home: Scaffold(
          body: ExplorerView(
            position: position,
            onMoveSelected: (move) => {},
            isComputerAnalysisAllowed: true,
          ),
        ),
        overrides: [defaultClientProvider.overrideWithValue(mockClient)],
      );
      await tester.pumpWidget(app);

      expect(find.text('Checkmate'), findsOneWidget);
      expect(find.byType(OpeningExplorerView), findsNothing);
      expect(find.byType(TablebaseView), findsNothing);
    });

    testWidgets('shows stalemate message for stalemate position', (WidgetTester tester) async {
      // Stalemate position
      final position = Chess.fromSetup(Setup.parseFen('6k1/6P1/6K1/8/8/8/8/8 b - - 0 1'));

      final app = await makeTestProviderScopeApp(
        tester,
        home: Scaffold(
          body: ExplorerView(
            position: position,
            onMoveSelected: (move) => {},
            isComputerAnalysisAllowed: true,
          ),
        ),
        overrides: [defaultClientProvider.overrideWithValue(mockClient)],
      );
      await tester.pumpWidget(app);

      expect(find.text('Stalemate'), findsOneWidget);
      expect(find.byType(OpeningExplorerView), findsNothing);
      expect(find.byType(TablebaseView), findsNothing);
    });
  });
}

const mastersOpeningExplorerResponse = '''
{
  "white": 834333,
  "draws": 1085272,
  "black": 600303,
  "moves": [
    {
      "uci": "e2e4",
      "san": "e4",
      "averageRating": 2399,
      "white": 372266,
      "draws": 486092,
      "black": 280238,
      "game": null
    }
  ],
  "topGames": [],
  "opening": null
}
''';

const tablebaseResponse = '''
{
    "checkmate": false,
    "stalemate": false,
    "variant_win": false,
    "variant_loss": false,
    "insufficient_material": false,
    "dtz": 63,
    "precise_dtz": 63,
    "dtm": null,
    "dtw": null,
    "dtc": null,
    "category": "win",
    "moves": [{
        "uci": "h3h4",
        "san": "Kh4",
        "zeroing": false,
        "checkmate": false,
        "stalemate": false,
        "variant_win": false,
        "variant_loss": false,
        "insufficient_material": false,
        "dtz": -62,
        "precise_dtz": -62,
        "dtm": null,
        "dtw": null,
        "dtc": null,
        "category": "loss"
    }
  ]
}
''';
