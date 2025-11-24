import 'dart:convert';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/explorer/opening_explorer.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/analysis/retro_screen.dart';

import '../../network/fake_websocket_channel.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

const testId = GameId('abcdefgh');

Future<Widget> makeTestApp(
  WidgetTester tester, {
  required String moves,
  Iterable<ExternalEval>? evals,
  IMap<String, OpeningExplorerEntry> openingExplorerEntries = const IMap.empty(),
}) async {
  final mockClient = MockClient((request) {
    if (request.url.path == '/game/export/$testId') {
      return mockResponse('''
{
  "id": "${testId.value}",
  "rated": true,
  "source": "lobby",
  "variant": "standard",
  "speed": "bullet",
  "perf": "bullet",
  "createdAt": 1706185945680,
  "lastMoveAt": 1706186170504,
  "status": "resign",
  "players": {
    "white": {
      "user": {
        "name": "veloce",
        "id": "veloce"
      },
      "rating": 1789,
      "ratingDiff": 9,
      "analysis": {
        "inaccuracy": 2,
        "mistake": 1,
        "blunder": 3,
        "acpl": 90
      }
    },
    "black": {
      "user": {
        "name": "chabrot",
        "id": "chabrot"
      },
      "rating": 1810,
      "ratingDiff": -9,
      "analysis": {
        "inaccuracy": 3,
        "mistake": 0,
        "blunder": 5,
        "acpl": 135
      }
    }
  },
  "winner": "white",
  "opening": {
    "eco": "C52",
    "name": "Italian Game: Evans Gambit, Main Line",
    "ply": 10
  },
  "moves": "$moves",
  "clocks": [${Iterable.generate(moves.length, (_) => '1000').join(',')}],
  "analysis": [
    ${evals?.map((eval) => jsonEncode({if (eval.cp != null) 'eval': eval.cp, if (eval.mate != null) 'mate': eval.mate, if (eval.variation != null) 'variation': eval.variation})).join(',') ?? ''}
  ],
  "clock": {
    "initial": 120,
    "increment": 1,
    "totalTime": 160
  }
}
        ''', 200);
    }
    if (request.url.host == kLichessOpeningExplorerHost && request.url.path == '/masters') {
      final fen = request.url.queryParameters['fen']!;
      final entry = openingExplorerEntries.entryOrNull(fen)?.value;
      if (entry != null) {
        return mockResponse(
          jsonEncode({
            'white': entry.white,
            'draws': entry.draws,
            'black': entry.black,
            'moves': entry.moves
                .map(
                  (move) => {
                    'uci': move.uci,
                    'san': move.san,
                    'white': move.white,
                    'draws': move.draws,
                    'black': move.black,
                  },
                )
                .toList(),
          }),
          200,
        );
      }
      return mockResponse('{"white":0,"draws":0,"black":0,"moves":[]}', 200);
    }
    return mockResponse('', 404);
  });

  return await makeTestProviderScopeApp(
    tester,
    home: const RetroScreen(options: (id: testId, initialSide: Side.white)),
    overrides: {
      lichessClientProvider: lichessClientProvider.overrideWith((ref) {
        return LichessClient(mockClient, ref);
      }),
      defaultClientProvider: defaultClientProvider.overrideWithValue(mockClient),
    },
    defaultPreferences: {},
  );
}

String makeEvalHitEvent({
  required Iterable<UCIMove> uciMoves,
  required UCIMove bestMove,
  int? cp,
  int? mate,
}) =>
    '''
{
  "t": "evalHit",
  "d": {
    "path": "${UciPath.fromUciMoves(uciMoves).value}",
    "knodes": 1,
    "depth": 20,
    "pvs": [
      {
        "moves": ["${uciMoves.last}"]
        ${cp != null ? ',"cp": $cp' : ''}
        ${mate != null ? '",mate": $mate' : ''}
      }
    ]
  }
}
''';

void main() {
  group('retro screen', () {
    testWidgets('No mistakes on both sides', (WidgetTester tester) async {
      await tester.pumpWidget(await makeTestApp(tester, moves: 'e4 e5'));

      // Wait for retro to load
      await tester.pump();

      expect(find.text('No significant mistakes found for White'), findsOneWidget);
      expect(find.text('Review Black mistakes'), findsOneWidget);

      await tester.tap(find.text('Review Black mistakes'));
      await tester.pump(); // Wait for side to flip

      expect(find.text('No significant mistakes found for Black'), findsOneWidget);
      expect(find.text('Review White mistakes'), findsOneWidget);
    });

    testWidgets('One mistake by both sides', (WidgetTester tester) async {
      await tester.pumpWidget(
        await makeTestApp(
          tester,
          moves: 'e4 e5 Nf3',
          evals: [
            const ExternalEval(cp: 0, mate: null),
            // Pretend e5 was a mistake, should've played the Sicilian obviously
            const ExternalEval(cp: 2000, mate: null, variation: 'c5'),
            // ... and white should've played King's gambit instead of Nf3
            const ExternalEval(cp: -2000, mate: null, variation: 'f4'),
          ],
        ),
      );

      // Wait for retro to load
      await tester.pump();

      expect(find.text('2. Nf3 was played'), findsOneWidget);
      expect(find.text('Find a better move for white'), findsOneWidget);
      expect(find.text('Skip this move'), findsOneWidget);

      await playMove(tester, 'g1', 'f3');
      // Wait for failure message to appear and move to be taken back
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byKey(const ValueKey('g1-whiteknight')), findsOneWidget);

      expect(find.text('You can do better'), findsOneWidget);
      expect(find.text('Try another move for white'), findsOneWidget);

      await playMove(tester, 'd2', 'd4');

      expect(find.text('Evaluating your move ...'), findsOneWidget);

      // Should not be able to interact with the board while waiting for eval
      await playMove(tester, 'a7', 'a6');
      await tester.pump();
      expect(find.byKey(const ValueKey('a7-blackpawn')), findsOneWidget);

      // Pretend d4 isn't a good move either
      sendServerSocketMessages(AnalysisController.socketUri, [
        makeEvalHitEvent(uciMoves: ['e2e4', 'e7e5', 'd2d4'], bestMove: 'd7d5', cp: -2000),
      ]);

      await tester.pump(); // Wait for eval to be processed

      // Move should be taken back
      expect(find.byKey(const ValueKey('d2-whitepawn')), findsOneWidget);

      expect(find.text('You can do better'), findsOneWidget);
      expect(find.text('Try another move for white'), findsOneWidget);

      await playMove(tester, 'f2', 'f4');
      await tester.pump(); // Wait for success message to appear

      expect(find.text('Good move'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);

      await tester.tap(find.text('Next mistake'));
      await tester.pump();

      expect(find.text('Done reviewing White mistakes'), findsOneWidget);
      expect(find.text('Review Black mistakes'), findsOneWidget);

      await tester.tap(find.text('Review Black mistakes'));
      await tester.pump(); // Wait for side to flip

      expect(find.text('1... e5 was played'), findsOneWidget);
      expect(find.text('Find a better move for black'), findsOneWidget);
      expect(find.text('View the solution'), findsOneWidget);

      await tester.tap(find.text('View the solution'));
      await tester.pump();

      expect(find.text('Best was 1... c5'), findsOneWidget);
      // Correct move should be on the board
      expect(find.byKey(const ValueKey('c5-blackpawn')), findsOneWidget);

      expect(find.text('Next mistake'), findsOneWidget);
      await tester.tap(find.text('Next mistake'));
      await tester.pump();

      expect(find.text('Done reviewing Black mistakes'), findsOneWidget);
      expect(find.text('Review White mistakes'), findsOneWidget);
    });

    testWidgets('Master move is also a solution', (WidgetTester tester) async {
      await tester.pumpWidget(
        await makeTestApp(
          tester,
          moves: 'e4 e5 Nf3',
          evals: [
            const ExternalEval(cp: 0, mate: null),
            // Pretend e5 was a mistake, should've played the Sicilian obviously
            const ExternalEval(cp: 2000, mate: null, variation: 'c5'),
            // ... and white should've played King's gambit instead of Nf3
            const ExternalEval(cp: -2000, mate: null, variation: 'f4'),
          ],
          openingExplorerEntries: {
            'rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2': OpeningExplorerEntry(
              white: 1,
              draws: 1,
              black: 1,
              moves: [
                const OpeningMove(uci: 'a2a3', san: 'a3', white: 1, draws: 0, black: 0),
                const OpeningMove(uci: 'd2d4', san: 'd4', white: 1, draws: 0, black: 1),
              ].lock,
            ),
          }.lock,
        ),
      );

      // Wait for retro to load
      await tester.pump();

      expect(find.text('2. Nf3 was played'), findsOneWidget);
      expect(find.text('Find a better move for white'), findsOneWidget);
      expect(find.text('Skip this move'), findsOneWidget);

      // This move is in the database but has only been played once,
      // so we will still consult the engine
      await playMove(tester, 'a2', 'a3');

      sendServerSocketMessages(AnalysisController.socketUri, [
        makeEvalHitEvent(uciMoves: ['e2e4', 'e7e5', 'a2a3'], bestMove: 'a7a6', cp: -2000),
      ]);

      // Wait for failure message to appear and move to be taken back
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      expect(find.byKey(const ValueKey('a2-whitepawn')), findsOneWidget);

      // This one has been played multiple times, so it should be accepted as a solution (without consulting the engine)
      await playMove(tester, 'd2', 'd4');
      expect(find.text('Good move'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
    });
  });
}
