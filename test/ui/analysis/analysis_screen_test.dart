import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartchess/dartchess.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

import '../../test_app.dart';

void main() {
  // ignore: avoid_dynamic_calls
  final moves = jsonDecode(gameResponse)['moves'].split(' ') as List<String>;
  Position position = Chess.initial;
  int index = 0;
  final List<GameStep> steps = [GameStep(ply: index, position: position)];

  for (final san in moves) {
    index++;
    final move = position.parseSan(san);
    position = position.playUnchecked(move!);
    steps.add(
      GameStep(
        ply: index,
        sanMove: SanMove(san, move),
        position: position,
      ),
    );
  }

  final gameStep = steps.toIList();

  group('Analysis Screen', () {
    testWidgets('displays correct move and position', (tester) async {
      final app = await buildTestApp(
        tester,
        home: AnalysisScreen(
          variant: Variant.standard,
          steps: gameStep,
          orientation: Side.white,
          id: gameData.id,
        ),
      );

      await tester.pumpWidget(app);

      expect(find.byType(cg.Board), findsOneWidget);
      expect(find.byType(cg.PieceWidget), findsNWidgets(25));
      final currentMove = find.widgetWithText(InlineMove, 'Qe1#');
      expect(currentMove, findsOneWidget);
      expect(
        tester.widgetList<InlineMove>(currentMove).any((e) => e.isCurrentMove),
        isTrue,
      );
    });
    testWidgets('move backwards and forward', (tester) async {
      final app = await buildTestApp(
        tester,
        home: AnalysisScreen(
          variant: Variant.standard,
          steps: gameStep,
          orientation: Side.white,
          id: gameData.id,
        ),
      );

      await tester.pumpWidget(app);

      // cannot go forward
      expect(
        tester
            .widget<BottomBarButton>(find.byKey(const Key('goto-next')))
            .onTap,
        isNull,
      );

      // can go back
      expect(
        tester
            .widget<BottomBarButton>(find.byKey(const Key('goto-previous')))
            .onTap,
        isNotNull,
      );

      // goto previous move
      await tester.tap(find.byKey(const Key('goto-previous')));
      await tester.pumpAndSettle();

      final currentMove = find.widgetWithText(InlineMove, 'Kc1');
      expect(currentMove, findsOneWidget);
      expect(
        tester.widgetList<InlineMove>(currentMove).any((e) => e.isCurrentMove),
        isTrue,
      );
    });
  });
}

final gameData = ArchivedGameData(
  id: const GameId('qVChCOTc'),
  rated: false,
  speed: Speed.blitz,
  perf: Perf.blitz,
  createdAt: DateTime.parse('2023-01-11 14:30:22.389'),
  lastMoveAt: DateTime.parse('2023-01-11 14:33:56.416'),
  status: GameStatus.mate,
  white: const Player(name: 'Stockfish', aiLevel: 1),
  black: const Player(
    id: UserId('veloce'),
    name: 'veloce',
    rating: 1435,
    patron: true,
  ),
  variant: Variant.standard,
  lastFen: '1r3rk1/p1pb1ppp/3p4/8/1nBN1P2/1P6/PBPP1nPP/R1K1q3 w - - 4 1',
  winner: Side.black,
);

const gameResponse = '''
{"id":"qVChCOTc","rated":false,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1673443822389,"lastMoveAt":1673444036416,"status":"mate","players":{"white":{"aiLevel":1},"black":{"user":{"name":"veloce","patron":true,"id":"veloce"},"rating":1435,"provisional":true}},"winner":"black","opening":{"eco":"C20","name":"King's Pawn Game: Wayward Queen Attack, Kiddie Countergambit","ply":4},"moves":"e4 e5 Qh5 Nf6 Qxe5+ Be7 b3 d6 Qb5+ Bd7 Qxb7 Nc6 Ba3 Rb8 Qa6 Nxe4 Bb2 O-O Nc3 Nb4 Nf3 Nxa6 Nd5 Nb4 Nxe7+ Qxe7 Nd4 Qf6 f4 Qe7 Ke2 Ng3+ Kd1 Nxh1 Bc4 Nf2+ Kc1 Qe1#","clocks":[18003,18003,17915,17627,17771,16691,17667,16243,17475,15459,17355,14779,17155,13795,16915,13267,14771,11955,14451,10995,14339,10203,13899,9099,12427,8379,12003,7547,11787,6691,11355,6091,11147,5763,10851,5099,10635,4657],"clock":{"initial":180,"increment":0,"totalTime":180}}
''';
