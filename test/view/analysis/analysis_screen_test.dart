import 'dart:convert';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/engine/engine_depth.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/view/engine/engine_lines.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';

import '../../test_provider_scope.dart';

void main() {
  // ignore: avoid_dynamic_calls
  final sanMoves = jsonDecode(gameResponse)['moves'] as String;

  group('Analysis Screen', () {
    testWidgets('displays correct move and position', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: AnalysisScreen(
          options: AnalysisOptions(
            orientation: Side.white,
            standalone: (
              pgn: sanMoves,
              isComputerAnalysisAllowed: false,
              variant: Variant.standard,
            ),
          ),
        ),
      );

      await tester.pumpWidget(app);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 1));

      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.byType(PieceWidget), findsNWidgets(25));
      final currentMove = find.textContaining('Qe1#');
      expect(currentMove, findsOneWidget);
      expect(
        tester
            .widget<InlineMove>(find.ancestor(of: currentMove, matching: find.byType(InlineMove)))
            .isCurrentMove,
        isTrue,
      );
    });

    testWidgets('move backwards and forward', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: AnalysisScreen(
          options: AnalysisOptions(
            orientation: Side.white,
            standalone: (
              pgn: sanMoves,
              isComputerAnalysisAllowed: false,
              variant: Variant.standard,
            ),
          ),
        ),
      );

      await tester.pumpWidget(app);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 1));

      // cannot go forward
      expect(tester.widget<BottomBarButton>(find.byKey(const Key('goto-next'))).onTap, isNull);

      // can go back
      expect(
        tester.widget<BottomBarButton>(find.byKey(const Key('goto-previous'))).onTap,
        isNotNull,
      );

      // goto previous move
      await tester.tap(find.byKey(const Key('goto-previous')));
      await tester.pumpAndSettle();

      final currentMove = find.textContaining('Kc1');
      expect(currentMove, findsOneWidget);
      expect(
        tester
            .widget<InlineMove>(find.ancestor(of: currentMove, matching: find.byType(InlineMove)))
            .isCurrentMove,
        isTrue,
      );
    });
  });

  group('Analysis Tree View', () {
    Future<void> buildTree(WidgetTester tester, String pgn, PgnTreeDisplayMode displayMode) async {
      final app = await makeTestProviderScopeApp(
        tester,
        defaultPreferences: {
          PrefCategory.analysis.storageKey: jsonEncode(
            AnalysisPrefs.defaults
                .copyWith(
                  enableLocalEvaluation: false,
                  inlineNotation: displayMode == PgnTreeDisplayMode.inlineNotation,
                )
                .toJson(),
          ),
        },
        home: AnalysisScreen(
          options: AnalysisOptions(
            orientation: Side.white,
            standalone: (pgn: pgn, isComputerAnalysisAllowed: false, variant: Variant.standard),
          ),
          enableDrawingShapes: false,
        ),
      );

      await tester.pumpWidget(app);
      await tester.pump(const Duration(milliseconds: 1));
    }

    Text parentText(WidgetTester tester, String move) {
      return tester.widget<Text>(find.ancestor(of: find.text(move), matching: find.byType(Text)));
    }

    void expectSameLine(WidgetTester tester, Iterable<String> moves) {
      final line = parentText(tester, moves.first);

      for (final move in moves.skip(1)) {
        final moveText = find.text(move);
        expect(moveText, findsOneWidget);
        expect(parentText(tester, move), line);
      }
    }

    void expectDifferentLines(WidgetTester tester, List<String> moves) {
      for (int i = 0; i < moves.length; i++) {
        for (int j = i + 1; j < moves.length; j++) {
          expect(parentText(tester, moves[i]), isNot(parentText(tester, moves[j])));
        }
      }
    }

    group('PgnTreeDisplayMode.inlineNotation', () {
      testWidgets('inline notation displays short sideline as inline', (tester) async {
        await buildTree(
          tester,
          '1. e4 e5 (1... d5 2. exd5) 2. Nf3 *',
          PgnTreeDisplayMode.inlineNotation,
        );

        final mainline = find.ancestor(of: find.text('1. e4'), matching: find.byType(Text));
        expect(mainline, findsOneWidget);

        expectSameLine(tester, ['1. e4', 'e5', '1… d5', '2. exd5', '2. Nf3']);
      });

      testWidgets('inline notation displays long sideline on its own line', (tester) async {
        await buildTree(
          tester,
          '1. e4 e5 (1... d5 2. exd5 Qxd5 3. Nc3 Qd8 4. d4 Nf6) 2. Nc3 *',
          PgnTreeDisplayMode.inlineNotation,
        );

        expectSameLine(tester, ['1. e4', 'e5']);
        expectSameLine(tester, ['1… d5', '2. exd5', 'Qxd5', '3. Nc3', 'Qd8', '4. d4', 'Nf6']);
        expectSameLine(tester, ['2. Nc3']);

        expectDifferentLines(tester, ['1. e4', '1… d5', '2. Nc3']);
      });

      testWidgets('inline notation displays sideline with branching on its own line', (
        tester,
      ) async {
        await buildTree(
          tester,
          '1. e4 e5 (1... d5 2. exd5 (2. Nc3)) *',
          PgnTreeDisplayMode.inlineNotation,
        );

        expectSameLine(tester, ['1. e4', 'e5']);

        // 2nd branch is rendered inline again
        expectSameLine(tester, ['1… d5', '2. exd5', '2. Nc3']);

        expectDifferentLines(tester, ['1. e4', '1… d5']);
      });

      testWidgets('multiple sidelines', (tester) async {
        await buildTree(
          tester,
          '1. e4 e5 (1... d5 2. exd5) (1... Nf6 2. e5) 2. Nf3 Nc6 (2... a5) *',
          PgnTreeDisplayMode.inlineNotation,
        );

        expectSameLine(tester, ['1. e4', 'e5']);
        expectSameLine(tester, ['1… d5', '2. exd5']);
        expectSameLine(tester, ['1… Nf6', '2. e5']);
        expectSameLine(tester, ['2. Nf3', 'Nc6', '2… a5']);

        expectDifferentLines(tester, ['1. e4', '1… d5', '1… Nf6', '2. Nf3']);
      });

      testWidgets('collapses lines with nesting > 2', (tester) async {
        await buildTree(
          tester,
          '1. e4 e5 (1... d5 2. Nc3 (2. h4 h5 (2... Nc6 3. d3) (2... Qd7))) *',
          PgnTreeDisplayMode.inlineNotation,
        );

        expectSameLine(tester, ['1. e4', 'e5']);
        expectSameLine(tester, ['1… d5']);
        expectSameLine(tester, ['2. Nc3']);
        expectSameLine(tester, ['2. h4']);

        expect(find.text('2… h5'), findsNothing);
        expect(find.text('2… Nc6'), findsNothing);
        expect(find.text('3. d3'), findsNothing);
        expect(find.text('2… Qd7'), findsNothing);

        // sidelines with nesting > 2 are collapsed -> expand them
        expect(find.byIcon(Icons.add_box), findsOneWidget);

        await tester.tap(find.byIcon(Icons.add_box));
        await tester.pumpAndSettle();

        expectSameLine(tester, ['2… h5']);
        expectSameLine(tester, ['2… Nc6', '3. d3']);
        expectSameLine(tester, ['2… Qd7']);

        final d3 = find.text('3. d3');
        await tester.longPress(d3);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Collapse variations'));

        // need to wait for current move change debounce delay
        await tester.pumpAndSettle(const Duration(milliseconds: 200));

        // Sidelines should be collapsed again
        expect(find.byIcon(Icons.add_box), findsOneWidget);

        expect(find.text('2… h5'), findsNothing);
        expect(find.text('2… Nc6'), findsNothing);
        expect(find.text('3. d3'), findsNothing);
        expect(find.text('2… Qd7'), findsNothing);
      });

      testWidgets('Expanding one line does not expand the following one (regression test)', (
        tester,
      ) async {
        /// Will be rendered as:
        /// -------------------
        /// 1. e4 e5
        /// |- 1... d5 2. Nf3 (2.Nc3)
        /// 2. Nf3
        /// |- 2. a4 d5 (2... f5)
        /// -------------------
        await buildTree(
          tester,
          '1. e4 e5 (1... d5 2. Nf3 (2. Nc3)) 2. Nf3 (2. a4 d5 (2... f5))',
          PgnTreeDisplayMode.inlineNotation,
        );

        expect(find.byIcon(Icons.add_box), findsNothing);

        // Collapse both lines
        await tester.longPress(find.text('1… d5'));
        await tester.pumpAndSettle(); // wait for context menu to appear
        await tester.tap(find.text('Collapse variations'));

        // wait for dialog to close and tree to refresh
        await tester.pumpAndSettle(const Duration(milliseconds: 200));

        await tester.longPress(find.text('2. a4'));
        await tester.pumpAndSettle(); // wait for context menu to appear
        await tester.tap(find.text('Collapse variations'));

        // wait for dialog to close and tree to refresh
        await tester.pumpAndSettle(const Duration(milliseconds: 200));

        // In this state, there used to be a bug where expanding the first line would
        // also expand the second line.
        expect(find.byIcon(Icons.add_box), findsNWidgets(2));
        await tester.tap(find.byIcon(Icons.add_box).first);

        // need to wait for current move change debounce delay
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.add_box), findsOneWidget);

        // Second sideline should still be collapsed
        expect(find.text('2. a4'), findsNothing);
      });

      testWidgets('subtrees not part of the current mainline part are cached', (tester) async {
        await buildTree(
          tester,
          '1. e4 e5 (1... d5 2. exd5) (1... Nf6 2. e5) 2. Nf3 Nc6 (2... a5) *',
          PgnTreeDisplayMode.inlineNotation,
        );

        // will be rendered as:
        // -------------------
        // 1. e4 e5              <-- first mainline part
        // |- 1... d5 2. exd5
        // |- 1... Nf6 2. e5
        // 2. Nf3 Nc6 (2... a5)  <-- second mainline part
        //         ^
        //         |
        //         current move

        final firstMainlinePart = parentText(tester, '1. e4');
        final secondMainlinePart = parentText(tester, '2. Nf3');

        expect(
          tester
              .widgetList<InlineMove>(
                find.ancestor(of: find.textContaining('Nc6'), matching: find.byType(InlineMove)),
              )
              .last
              .isCurrentMove,
          isTrue,
        );

        await tester.tap(find.byKey(const Key('goto-previous')));
        // need to wait for current move change debounce delay
        await tester.pumpAndSettle(const Duration(milliseconds: 200));

        expect(
          tester
              .widgetList<InlineMove>(
                find.ancestor(of: find.textContaining('Nf3'), matching: find.byType(InlineMove)),
              )
              .last
              .isCurrentMove,
          isTrue,
        );

        // first mainline part has not changed since the current move is
        // not part of it
        expect(identical(firstMainlinePart, parentText(tester, '1. e4')), isTrue);

        final secondMainlinePartOnMoveNf3 = parentText(tester, '2. Nf3');

        // second mainline part has changed since the current move is part of it
        expect(secondMainlinePart, isNot(secondMainlinePartOnMoveNf3));

        await tester.tap(find.byKey(const Key('goto-previous')));
        // need to wait for current move change debounce delay
        await tester.pumpAndSettle(const Duration(milliseconds: 200));

        expect(
          tester
              .widgetList<InlineMove>(
                find.ancestor(of: find.textContaining('e5'), matching: find.byType(InlineMove)),
              )
              .first
              .isCurrentMove,
          isTrue,
        );

        final firstMainlinePartOnMoveE5 = parentText(tester, '1. e4');
        final secondMainlinePartOnMoveE5 = parentText(tester, '2. Nf3');

        // first mainline part has changed since the current move is part of it
        expect(firstMainlinePart, isNot(firstMainlinePartOnMoveE5));

        // second mainline part has changed since the current move is not part of it
        // anymore
        expect(secondMainlinePartOnMoveNf3, isNot(secondMainlinePartOnMoveE5));

        await tester.tap(find.byKey(const Key('goto-previous')));
        // need to wait for current move change debounce delay
        await tester.pumpAndSettle(const Duration(milliseconds: 200));

        expect(
          tester
              .firstWidget<InlineMove>(
                find.ancestor(of: find.textContaining('e4'), matching: find.byType(InlineMove)),
              )
              .isCurrentMove,
          isTrue,
        );

        final firstMainlinePartOnMoveE4 = parentText(tester, '1. e4');
        final secondMainlinePartOnMoveE4 = parentText(tester, '2. Nf3');

        // first mainline part has changed since the current move is part of it
        expect(firstMainlinePartOnMoveE4, isNot(firstMainlinePartOnMoveE5));

        // second mainline part has not changed since the current move is not part of it
        expect(identical(secondMainlinePartOnMoveE5, secondMainlinePartOnMoveE4), isTrue);
      });

      testWidgets(
        'Select first move of sideline if mainline part has only one move (regression test)',
        (tester) async {
          /// Will be rendered as:
          /// -------------------
          /// 1. e4
          /// |- 1. d4
          /// |- 1. c4
          /// -------------------
          await buildTree(tester, '1. e4 (1. d4) (1. c4)', PgnTreeDisplayMode.inlineNotation);

          await tester.tap(find.text('1. d4'));
          // need to wait for current move change debounce delay
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final e4NodeBeforeTap = parentText(tester, '1. e4');

          await tester.tap(find.text('1. c4'));
          // need to wait for current move change debounce delay
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final e4NodeAfterTap = parentText(tester, '1. e4');

          // There was a bug where the subtree would not be rebuilt here
          expect(e4NodeBeforeTap, isNot(e4NodeAfterTap));
        },
      );
    });

    group('PgnTreeDisplayMode.twoColumn', () {
      Row parentRow(WidgetTester tester, String move) {
        return tester.firstWidget<Row>(
          find.ancestor(of: find.text(move), matching: find.byType(Row)),
        );
      }

      testWidgets('two column view does NOT display short sideline on its own line', (
        tester,
      ) async {
        await buildTree(tester, '1. e4 (1. d4 2. d5) 1... e5 *', PgnTreeDisplayMode.twoColumn);

        expect(parentRow(tester, 'e4'), isNot(parentRow(tester, 'e5')));
      });

      testWidgets('two column view adds "..." if mainline part starts with black move', (
        tester,
      ) async {
        await buildTree(
          tester,
          '1. e4 (1. d4 2. d5) 1... e5 2. Nf3 Nc6 *',
          PgnTreeDisplayMode.twoColumn,
        );

        // Test that it's rendered like this:
        /// 1  e4 ...
        /// |- 1. d4 2. d5
        /// 1 ... e5
        /// 2 Nf3 Nc6
        ///
        /// ... and not like this:
        /// 1  e4 ...
        /// |- 1. d4 2. d5
        /// 1 e5
        /// 2 Nf3 Nc6

        expect(find.text('...'), findsNWidgets(2));
      });
    });
  });

  group('Test engine widgets', () {
    Future<void> buildApp(WidgetTester tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        defaultPreferences: {
          PrefCategory.analysis.storageKey: jsonEncode(
            AnalysisPrefs.defaults.copyWith(numEvalLines: 1).toJson(),
          ),
        },
        home: const AnalysisScreen(
          options: AnalysisOptions(
            orientation: Side.white,
            standalone: (pgn: '', isComputerAnalysisAllowed: true, variant: Variant.standard),
          ),
        ),
      );

      await tester.pumpWidget(app);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // The time the controller waits before launching the evaluation
      await tester.pump(const Duration(milliseconds: 800));
    }

    testWidgets('Test engine lines are displayed', (tester) async {
      await buildApp(tester);

      expect(find.byType(Engineline), findsOne);
      expect(find.widgetWithText(Engineline, '1. e4 e5 2. Nf3 Nc6 3. Bb5 Nf6 '), findsOne);

      // Required to stop the timer of the throttle in the eval stream of the evaluation service
      await tester.pump(const Duration(milliseconds: 300));
    });

    testWidgets('Test engine depth is displayed', (tester) async {
      await buildApp(tester);

      expect(find.byType(EngineDepth), findsOne);
      expect(find.widgetWithText(EngineDepth, '6'), findsOne);

      // Required to stop the timer of the throttle in the eval stream of the evaluation service
      await tester.pump(const Duration(milliseconds: 300));
    });

    testWidgets('Test engine gauge is displayed', (tester) async {
      await buildApp(tester);

      expect(find.byType(EngineGauge), findsOne);
      expect(find.widgetWithText(EngineGauge, '+0.2'), findsOne);

      // Required to stop the timer of the throttle in the eval stream of the evaluation service
      await tester.pump(const Duration(milliseconds: 300));
    });
  });
}

// final gameData = LightArchivedGame(
//   id: const GameId('qVChCOTc'),
//   rated: false,
//   speed: Speed.blitz,
//   perf: Perf.blitz,
//   createdAt: DateTime.parse('2023-01-11 14:30:22.389'),
//   lastMoveAt: DateTime.parse('2023-01-11 14:33:56.416'),
//   status: GameStatus.mate,
//   white: const Player(aiLevel: 1),
//   black: const Player(
//     user: LightUser(
//       id: UserId('veloce'),
//       name: 'veloce',
//       isPatron: true,
//     ),
//     rating: 1435,
//   ),
//   variant: Variant.standard,
//   lastFen: '1r3rk1/p1pb1ppp/3p4/8/1nBN1P2/1P6/PBPP1nPP/R1K1q3 w - - 4 1',
//   winner: Side.black,
// );

const gameResponse = '''
{"id":"qVChCOTc","rated":false,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1673443822389,"lastMoveAt":1673444036416,"status":"mate","players":{"white":{"aiLevel":1},"black":{"user":{"name":"veloce","patron":true,"id":"veloce"},"rating":1435,"provisional":true}},"winner":"black","opening":{"eco":"C20","name":"King's Pawn Game: Wayward Queen Attack, Kiddie Countergambit","ply":4},"moves":"e4 e5 Qh5 Nf6 Qxe5+ Be7 b3 d6 Qb5+ Bd7 Qxb7 Nc6 Ba3 Rb8 Qa6 Nxe4 Bb2 O-O Nc3 Nb4 Nf3 Nxa6 Nd5 Nb4 Nxe7+ Qxe7 Nd4 Qf6 f4 Qe7 Ke2 Ng3+ Kd1 Nxh1 Bc4 Nf2+ Kc1 Qe1#","clocks":[18003,18003,17915,17627,17771,16691,17667,16243,17475,15459,17355,14779,17155,13795,16915,13267,14771,11955,14451,10995,14339,10203,13899,9099,12427,8379,12003,7547,11787,6691,11355,6091,11147,5763,10851,5099,10635,4657],"clock":{"initial":180,"increment":0,"totalTime":180}}
''';
