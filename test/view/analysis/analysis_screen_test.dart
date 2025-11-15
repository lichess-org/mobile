import 'dart:convert';

import 'package:chessground/chessground.dart';
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_mixin.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/view/engine/engine_lines.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';

import '../../network/fake_websocket_channel.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';
import '../engine/test_engine_app.dart';

void main() {
  // ignore: avoid_dynamic_calls
  final sanMoves = jsonDecode(gameResponse)['moves'] as String;

  group('Analysis Screen', () {
    testWidgets('displays correct move and position', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: AnalysisScreen(
          options: AnalysisOptions.standalone(
            orientation: Side.white,
            pgn: sanMoves,
            isComputerAnalysisAllowed: false,
            variant: Variant.standard,
          ),
        ),
      );

      await tester.pumpWidget(app);
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
          options: AnalysisOptions.standalone(
            orientation: Side.white,
            pgn: sanMoves,
            isComputerAnalysisAllowed: false,
            variant: Variant.standard,
          ),
        ),
      );

      await tester.pumpWidget(app);

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
    Future<void> buildTree(
      WidgetTester tester,
      String pgn,
      PgnTreeDisplayMode displayMode, {
      AnalysisOptions? options,
      MockClient? mockClient,
    }) async {
      final app = await makeTestProviderScopeApp(
        tester,
        defaultPreferences: {
          PrefCategory.analysis.storageKey: jsonEncode(
            AnalysisPrefs.defaults
                .copyWith(inlineNotation: displayMode == PgnTreeDisplayMode.inlineNotation)
                .toJson(),
          ),
          PrefCategory.engineEvaluation.storageKey: jsonEncode(
            EngineEvaluationPrefState.defaults.copyWith(isEnabled: false).toJson(),
          ),
        },
        home: AnalysisScreen(
          options:
              options ??
              AnalysisOptions.standalone(
                orientation: Side.white,
                pgn: pgn,
                isComputerAnalysisAllowed: false,
                variant: Variant.standard,
              ),
        ),
        overrides: [
          if (mockClient != null)
            lichessClientProvider.overrideWith((ref) {
              return LichessClient(mockClient, ref);
            }),
        ],
      );

      await tester.pumpWidget(app);
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

    testWidgets('Displays conditional premove lines saved on server', (tester) async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/$kGameFullId/forecasts') {
          return mockResponse(
            makeCorrespondenceGameJsonWithForecast(
              pgn: 'e4 e5',
              youAre: Side.white,
              forecast: [
                [SanMove('Nf3', Move.parse('g1f3')!), SanMove('Nc6', Move.parse('b8c6')!)].lock,
              ].lock,
            ),
            200,
          );
        }
        return mockResponse('', 404);
      });

      await buildTree(
        tester,
        '1. e4 e5 *',
        PgnTreeDisplayMode.inlineNotation,
        options: const AnalysisOptions.activeCorrespondenceGame(
          orientation: Side.white,
          gameFullId: kGameFullId,
        ),
        mockClient: mockClient,
      );

      // Wait for correspondence game to be loaded
      await tester.pumpAndSettle();

      expectSameLine(tester, ['1. e4', 'e5', '2. Nf3', 'Nc6']);
    });

    testWidgets('Regaining focus refreshes correspondence moves', (tester) async {
      var liveGamePgn = 'e4 e5';
      final mockClient = MockClient((request) {
        if (request.url.path == '/$kGameFullId/forecasts') {
          return mockResponse(
            makeCorrespondenceGameJsonWithForecast(
              pgn: liveGamePgn,
              youAre: Side.black,
              forecast: const IList.empty(),
            ),
            200,
          );
        }
        return mockResponse('', 404);
      });

      await buildTree(
        tester,
        '1. e4 e5 *',
        PgnTreeDisplayMode.inlineNotation,
        options: const AnalysisOptions.activeCorrespondenceGame(
          orientation: Side.white,
          gameFullId: kGameFullId,
        ),
        mockClient: mockClient,
      );

      await tester.pumpAndSettle();

      // This will be added to the mainline
      await playMove(tester, 'd2', 'd4');
      await playMove(tester, 'e5', 'd4');

      expectSameLine(tester, ['1. e4', 'e5', '2. d4', 'exd4']);

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);

      liveGamePgn = 'e4 e5 Nf3 Nc6';

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);

      // Wait for API call to refresh game and tree to be updated
      await tester.pumpAndSettle();

      // 2. Nf3 Nc6 should have been added and promoted to mainline
      expectSameLine(tester, ['1. e4', 'e5', '2. Nf3', 'Nc6']);

      // This is now a sideline
      expectSameLine(tester, ['2. d4', 'exd4']);
    });
  });

  // more engine evaluation test files are to be found in /test/view/engine/
  group('Engine evaluation:', () {
    group('in move tree', () {
      testWidgets('evals are displayed', (tester) async {
        await makeEngineTestApp(tester, isCloudEvalEnabled: false);
        await playMove(tester, 'e2', 'e4');
        expect(find.byType(InlineMove), findsOne);
        // ensure that the eval is displayed and pending eval throttle time is over
        await tester.pump(kRequestEvalDebounceDelay + kEngineEvalEmissionThrottleDelay);
        expect(find.widgetWithText(InlineMove, '+0.2'), findsOne);
        await playMove(tester, 'e7', 'e5');
        await tester.pump(kLocalEngineAfterCloudEvalDelay + kEngineEvalEmissionThrottleDelay);
        expect(find.widgetWithText(InlineMove, '+0.2'), findsNWidgets(2));
      });

      testWidgets(
        'computer variations are displayed in the move tree when server analysis is enabled',
        (tester) async {
          await makeEngineTestApp(tester, gameId: const GameId('xze7RH66'));

          expect(find.byType(CircularProgressIndicator), findsOne);
          // wait for the game to be loaded
          await tester.pump(const Duration(milliseconds: 50));

          expect(find.text('Mistake. dxe6 was best.'), findsOne);
          expect(find.text('13. dxe6'), findsOne);
        },
      );

      testWidgets(
        'computer variations are not displayed in the move tree when server analysis is disabled',
        (tester) async {
          await makeEngineTestApp(
            tester,
            isServerAnalysisEnabled: false,
            gameId: const GameId('xze7RH66'),
          );

          expect(find.byType(CircularProgressIndicator), findsOne);
          // wait for the game to be loaded
          await tester.pump(const Duration(milliseconds: 50));

          expect(find.text('Mistake. dxe6 was best.'), findsNothing);
          expect(find.text('13. dxe6'), findsNothing);
        },
      );
    });

    group('Engine lines', () {
      testWidgets('are displayed', (tester) async {
        await makeEngineTestApp(tester);
        // ensure that the eval is displayed and pending eval throttle time is over
        await tester.pump(kRequestEvalDebounceDelay + kEngineEvalEmissionThrottleDelay);
        expect(find.byType(Engineline), findsOne);
        expect(find.widgetWithText(Engineline, '1. e4 e5 2. Nf3 Nc6 3. Bb5 Nf6 '), findsOne);
      });

      testWidgets('are not displayed if computer analysis is not allowed', (tester) async {
        await makeEngineTestApp(tester, isComputerAnalysisAllowed: false);
        // ensure that the eval is displayed and pending eval throttle time is over
        await tester.pump(kRequestEvalDebounceDelay + kEngineEvalEmissionThrottleDelay);
        expect(find.byType(Engineline), findsNothing);
      });

      testWidgets('are not displayed if computer analysis is not enabled (on an analysed game)', (
        tester,
      ) async {
        await makeEngineTestApp(
          tester,
          gameId: const GameId('xze7RH66'),
          isServerAnalysisEnabled: false,
          isEngineEnabled: false,
        );
        // ensure that the eval is displayed and pending eval throttle time is over
        await tester.pump(kRequestEvalDebounceDelay + kEngineEvalEmissionThrottleDelay);
        expect(find.byType(Engineline), findsNothing);
      });

      testWidgets('are not displayed if engine is disabled by user preferences', (tester) async {
        await makeEngineTestApp(tester, isEngineEnabled: false);
        // ensure that the eval is displayed and pending eval throttle time is over
        await tester.pump(kRequestEvalDebounceDelay + kEngineEvalEmissionThrottleDelay);
        expect(find.byType(Engineline), findsNothing);
      });

      testWidgets('are not displayed if they are disabled by user preferences', (tester) async {
        await makeEngineTestApp(tester, numEvalLines: 0);
        // ensure that the eval is displayed and pending eval throttle time is over
        await tester.pump(kRequestEvalDebounceDelay + kEngineEvalEmissionThrottleDelay);
        expect(find.byType(Engineline), findsNothing);
      });
    });

    group('Engine gauge', () {
      testWidgets('is not displayed if computer analysis is not allowed', (tester) async {
        await makeEngineTestApp(tester, isComputerAnalysisAllowed: false);
        // ensure that the eval is displayed and pending eval throttle time is over
        await tester.pump(kRequestEvalDebounceDelay + kEngineEvalEmissionThrottleDelay);
        expect(find.byType(EngineGauge), findsNothing);
      });

      testWidgets('is not displayed if computer analysis is not enabled (on an analysed game)', (
        tester,
      ) async {
        await makeEngineTestApp(
          tester,
          isServerAnalysisEnabled: false,
          isEngineEnabled: false,
          gameId: const GameId('xze7RH66'),
        );
        // ensure that the eval is displayed and pending eval throttle time is over
        await tester.pump(kRequestEvalDebounceDelay + kEngineEvalEmissionThrottleDelay);
        expect(find.byType(EngineGauge), findsNothing);
      });

      testWidgets('is not displayed if engine is disabled by user preferences', (tester) async {
        await makeEngineTestApp(tester, isEngineEnabled: false);
        // ensure that the eval is displayed and pending eval throttle time is over
        await tester.pump(kRequestEvalDebounceDelay + kEngineEvalEmissionThrottleDelay);
        expect(find.byType(EngineGauge), findsNothing);
      });

      testWidgets('is displayed if engine is available', (tester) async {
        await makeEngineTestApp(tester);
        // ensure that the eval is displayed and pending eval throttle time is over
        await tester.pump(kRequestEvalDebounceDelay + kEngineEvalEmissionThrottleDelay);
        expect(find.byType(EngineGauge), findsOne);
        expect(find.widgetWithText(EngineGauge, '+0.2'), findsOne);
      });

      testWidgets('is displayed on an analysed game, even if engine eval is disabled', (
        tester,
      ) async {
        await makeEngineTestApp(tester, isEngineEnabled: false, gameId: const GameId('xze7RH66'));

        expect(find.byType(CircularProgressIndicator), findsOne);
        // wait for the game to be loaded
        await tester.pump(const Duration(milliseconds: 50));

        expect(find.byType(EngineGauge), findsOne);
        expect(find.widgetWithText(EngineGauge, 'Checkmate'), findsOne);
      });
    });

    group('Engine best move arrow', () {
      testWidgets('is not displayed if best move arrow is disabled', (tester) async {
        await makeEngineTestApp(tester, showBestMoveArrow: false);
        // ensure that the eval is displayed and pending eval throttle time is over
        await tester.pump(kRequestEvalDebounceDelay + kEngineEvalEmissionThrottleDelay);
        expect(find.byType(BoardShapeWidget), findsNothing);
      });

      testWidgets('is not displayed if computer analysis is not allowed', (tester) async {
        await makeEngineTestApp(tester, isComputerAnalysisAllowed: false);
        // ensure that the eval is displayed and pending eval throttle time is over
        await tester.pump(kRequestEvalDebounceDelay + kEngineEvalEmissionThrottleDelay);
        expect(find.byType(BoardShapeWidget), findsNothing);
      });

      testWidgets('is not displayed if engine is disabled by user preferences', (tester) async {
        await makeEngineTestApp(tester, isEngineEnabled: false);
        // ensure that the eval is displayed and pending eval throttle time is over
        await tester.pump(kRequestEvalDebounceDelay + kEngineEvalEmissionThrottleDelay);
        expect(find.byType(BoardShapeWidget), findsNothing);
      });

      testWidgets('is displayed if engine is available', (tester) async {
        await makeEngineTestApp(tester);
        // ensure that the eval is displayed and pending eval throttle time is over
        await tester.pump(kRequestEvalDebounceDelay + kEngineEvalEmissionThrottleDelay);
        expect(find.byType(BoardShapeWidget), findsOne);
      });
    });
  });

  group('Castling', () {
    const String castlingSetupPgn =
        '1. e4 e5 2. Nf3 Nf6 3. Bc4 Bc5 4. d3 d6 5. Bd2 Bd7 6. Nc3 Nc6 7. Qe2 Qe7';

    for (final castlingMethod in CastlingMethod.values) {
      testWidgets('respect castling preference ($castlingMethod)', (tester) async {
        final app = await makeTestProviderScopeApp(
          tester,
          defaultPreferences: {
            PrefCategory.board.storageKey: jsonEncode(
              BoardPrefs.defaults.copyWith(castlingMethod: castlingMethod).toJson(),
            ),
          },
          home: const AnalysisScreen(
            options: AnalysisOptions.standalone(
              orientation: Side.white,
              pgn: castlingSetupPgn,
              isComputerAnalysisAllowed: false,
              variant: Variant.standard,
              initialMoveCursor: 14,
            ),
          ),
        );

        await tester.pumpWidget(app);

        expect(find.byKey(const Key('e1-whiteking')), findsOneWidget);

        await tester.tap(find.byKey(const Key('e1-whiteking')));
        await tester.pump();

        switch (castlingMethod) {
          case CastlingMethod.kingOverRook:
            // kingOverRook acts as either kingTwoSquares or kingOverRook
            expect(find.byKey(const Key('f1-dest')), findsOneWidget);
            expect(find.byKey(const Key('g1-dest')), findsOneWidget);
            expect(find.byKey(const Key('h1-dest')), findsOneWidget);
            expect(find.byKey(const Key('c1-dest')), findsOneWidget);
            expect(find.byKey(const Key('d1-dest')), findsOneWidget);
            expect(find.byKey(const Key('a1-dest')), findsOneWidget);
          case CastlingMethod.kingTwoSquares:
            expect(find.byKey(const Key('f1-dest')), findsOneWidget);
            expect(find.byKey(const Key('g1-dest')), findsOneWidget);
            expect(find.byKey(const Key('h1-dest')), findsNothing);
            expect(find.byKey(const Key('c1-dest')), findsOneWidget);
            expect(find.byKey(const Key('d1-dest')), findsOneWidget);
            expect(find.byKey(const Key('a1-dest')), findsNothing);
        }
      });
    }

    for (final castlingMethod in CastlingMethod.values) {
      testWidgets('Chess960 castling: $castlingMethod', (tester) async {
        final app = await makeTestProviderScopeApp(
          tester,
          defaultPreferences: {
            PrefCategory.board.storageKey: jsonEncode(
              BoardPrefs.defaults.copyWith(castlingMethod: castlingMethod).toJson(),
            ),
          },
          home: AnalysisScreen(
            key: ValueKey(castlingMethod),
            options: const AnalysisOptions.standalone(
              orientation: Side.white,
              pgn: castlingSetupPgn,
              isComputerAnalysisAllowed: false,
              variant: Variant.chess960,
              initialMoveCursor: 14,
            ),
          ),
        );

        await tester.pumpWidget(app);

        await tester.tap(find.byKey(const Key('e1-whiteking')));

        await tester.pump();

        // in chess960, castling is only king over rook, no matter the preference
        expect(find.byKey(const Key('f1-dest')), findsOneWidget);
        expect(find.byKey(const Key('g1-dest')), findsNothing);
        expect(find.byKey(const Key('h1-dest')), findsOneWidget);
        expect(find.byKey(const Key('c1-dest')), findsNothing);
        expect(find.byKey(const Key('d1-dest')), findsOneWidget);
        expect(find.byKey(const Key('a1-dest')), findsOneWidget);
      });
    }
  });

  group('conditional premoves', () {
    testWidgets('no conditional premove tab for standalone analysis', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: AnalysisScreen(
          options: AnalysisOptions.standalone(
            orientation: Side.white,
            pgn: sanMoves,
            isComputerAnalysisAllowed: false,
            variant: Variant.standard,
          ),
        ),
      );

      await tester.pumpWidget(app);

      expect(find.byIcon(LichessIcons.flow_cascade), findsOneWidget);
      await tester.tap(find.byIcon(LichessIcons.flow_cascade));

      // Wait for menu to open
      await tester.pumpAndSettle();

      // Menu should not contain conditional premoves tab
      expect(find.byIcon(Icons.save), findsNothing);
    });

    Future<void> switchToPremoveTab(WidgetTester tester) async {
      expect(find.byIcon(LichessIcons.flow_cascade), findsOneWidget);
      await tester.tap(find.byIcon(LichessIcons.flow_cascade));

      // Wait for menu to open
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.save), findsOneWidget);
      await tester.tap(find.byIcon(Icons.save));

      // Wait for premove tab to open
      await tester.pumpAndSettle();
    }

    void expectPremoveLineAddable(WidgetTester tester) {
      expect(find.text('Play a variation to create conditional premoves'), findsNothing);
      expect(find.text('Add current variation'), findsOneWidget);
    }

    void expectNoPremoveLineAddable(WidgetTester tester) {
      expect(find.text('Play a variation to create conditional premoves'), findsOneWidget);
      expect(find.text('Add current variation'), findsNothing);
    }

    const kingsPawnGameForeast = [
      {
        'ply': 1,
        'san': 'e4',
        'uci': 'e2e4',
        'fen': 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1',
      },
      {
        'ply': 2,
        'san': 'e5',
        'uci': 'e7e5',
        'fen': 'rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
      },
    ];

    const queensPawnGameForecast = [
      {
        'ply': 1,
        'san': 'd4',
        'uci': 'd2d4',
        'fen': 'rnbqkbnr/pppppppp/8/8/3P4/8/PPP1PPPP/RNBQKBNR b KQkq - 0 1',
      },
      {
        'ply': 2,
        'san': 'd5',
        'uci': 'd7d5',
        'fen': 'rnbqkbnr/ppp1pppp/8/3p4/3P4/8/PPP1PPPP/RNBQKBNR w KQkq - 0 2',
      },
    ];

    testWidgets("Can add and remove premove lines on opponent's turn", (tester) async {
      Set<List<Map<String, dynamic>>>? lastForecastJsonRequest;

      final mockClient = MockClient((request) {
        if (request.url.path == '/$kGameFullId/forecasts') {
          if (request.method == 'POST') {
            lastForecastJsonRequest = (jsonDecode(request.body) as List<dynamic>)
                .map(
                  (steps) => (steps as List<dynamic>)
                      .map((step) => step as Map<String, dynamic>)
                      .toList(growable: false),
                )
                .toSet();
            return mockResponse('', 200);
          } else {
            return mockResponse(
              makeCorrespondenceGameJsonWithForecast(
                pgn: '',
                forecast: [
                  [SanMove('e4', Move.parse('e2e4')!), SanMove('e5', Move.parse('e7e5')!)].lock,
                ].lock,
                youAre: Side.black,
              ),
              200,
            );
          }
        }
        return mockResponse('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: const AnalysisScreen(
          options: AnalysisOptions.activeCorrespondenceGame(
            orientation: Side.white,
            gameFullId: kGameFullId,
          ),
        ),
        overrides: [
          lichessClientProvider.overrideWith((ref) {
            return LichessClient(mockClient, ref);
          }),
        ],
      );

      await tester.pumpWidget(app);
      await tester.pump();

      await switchToPremoveTab(tester);

      // Should display the initial premove line stored on the server
      expect(find.text('1. e4 e5'), findsOneWidget);

      expectNoPremoveLineAddable(tester);

      // We are black, so this is not a valid premove line yet
      await playMove(tester, 'd2', 'd4');
      expectNoPremoveLineAddable(tester);

      // Now this should be addable as a premove line
      await playMove(tester, 'd7', 'd5');
      expectPremoveLineAddable(tester);

      await tester.tap(find.text('Add current variation'));

      // Wait for network request to be sent and UI to be updated
      await tester.pumpAndSettle();

      expect(find.text('1. e4 e5'), findsOneWidget);
      expect(find.text('1. d4 d5'), findsOneWidget);

      // We've added the line, so should not display the "add" button anymore
      expectNoPremoveLineAddable(tester);

      expect(lastForecastJsonRequest, {queensPawnGameForecast, kingsPawnGameForeast});

      expect(find.byIcon(CupertinoIcons.delete), findsNWidgets(2));

      // Newly added forecast appear at the top (to ensure they are visible),
      // so tapping the first one should delete the queens pawn game forecast
      await tester.tap(find.byIcon(CupertinoIcons.delete).first);

      expect(lastForecastJsonRequest, {kingsPawnGameForeast});

      // Wait for network request to be sent and UI to be updated
      await tester.pumpAndSettle();

      expect(find.byIcon(CupertinoIcons.delete), findsOneWidget);

      await tester.tap(find.byIcon(CupertinoIcons.delete));

      expect(lastForecastJsonRequest, isEmpty);
    });

    testWidgets('Can add premove lines on our turn', (tester) async {
      String? playedMoveUci;
      Set<List<Map<String, dynamic>>>? lastForecastJsonRequest;

      final mockClient = MockClient((request) {
        if (request.url.path.startsWith('/$kGameFullId/forecasts/') && request.method == 'POST') {
          lastForecastJsonRequest = (jsonDecode(request.body) as List<dynamic>)
              .map(
                (steps) => (steps as List<dynamic>)
                    .map((step) => step as Map<String, dynamic>)
                    .toList(growable: false),
              )
              .toSet();
          playedMoveUci = request.url.pathSegments.last;
          return mockResponse('', 200);
        } else if (request.url.path == '/$kGameFullId/forecasts' && request.method == 'GET') {
          return mockResponse(
            makeCorrespondenceGameJsonWithForecast(
              pgn: '',
              youAre: Side.white,
              forecast: const IList.empty(),
            ),
            200,
          );
        }
        return mockResponse('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: const AnalysisScreen(
          options: AnalysisOptions.activeCorrespondenceGame(
            orientation: Side.white,
            gameFullId: kGameFullId,
          ),
        ),
        overrides: [
          lichessClientProvider.overrideWith((ref) {
            return LichessClient(mockClient, ref);
          }),
        ],
      );

      await tester.pumpWidget(app);
      await tester.pump();

      await switchToPremoveTab(tester);

      expectNoPremoveLineAddable(tester);

      await playMove(tester, 'e2', 'e4');
      expectPremoveLineAddable(tester);

      await tester.tap(find.text('Add current variation'));
      // Wait for variation to be saved and "play move" button to appear
      await tester.pumpAndSettle();

      expect(find.text('Play e4'), findsOneWidget);
      expect(find.text('No conditional premoves'), findsOneWidget);

      await playMove(tester, 'e7', 'e5');
      // Can't add a premove line here yet, we haven't played a response to e7 yet
      expectNoPremoveLineAddable(tester);

      await playMove(tester, 'g1', 'f3');
      expectPremoveLineAddable(tester);

      // Save the variation (1. e4 e5 2. Nc3) - Since it's our turn, this will NOT post a API request
      await tester.tap(find.text('Add current variation'));
      // Wait for variation to be saved and "play move" button to appear
      await tester.pumpAndSettle();

      expect(playedMoveUci, isNull);
      expect(lastForecastJsonRequest, isNull);

      expect(find.text('Play e4'), findsOneWidget);
      expect(find.text('and save 1 premove line'), findsOneWidget);

      // Go back to starting position
      await tester.tap(find.byKey(const Key('goto-previous')));
      await tester.pumpAndSettle(); // Wait for board to update
      await tester.tap(find.byKey(const Key('goto-previous')));
      await tester.pumpAndSettle(); // Wait for board to update
      await tester.tap(find.byKey(const Key('goto-previous')));
      await tester.pumpAndSettle(); // Wait for board to update

      // Save Queen's Gambit as another premove line
      await playMove(tester, 'd2', 'd4');
      await playMove(tester, 'd7', 'd5');
      await playMove(tester, 'c2', 'c4');

      await tester.tap(find.text('Add current variation'));
      // Wait for variation to be saved and "play move" button to appear
      await tester.pumpAndSettle();

      // Should still not post anything until we actually play our first move
      expect(playedMoveUci, isNull);
      expect(lastForecastJsonRequest, isNull);

      // Go back to 1. d2
      await tester.tap(find.byKey(const Key('goto-previous')));
      await tester.pumpAndSettle(); // Wait for board to update
      await tester.tap(find.byKey(const Key('goto-previous')));
      await tester.pumpAndSettle(); // Wait for board to update

      await playMove(tester, 'g8', 'f6');
      await playMove(tester, 'c2', 'c4');

      await tester.tap(find.text('Add current variation'));
      // Wait for varation to be saved and "play move" button text to be updated
      await tester.pumpAndSettle();

      expect(find.text('Play d4'), findsOneWidget);
      expect(find.text('and save 2 premove lines'), findsOneWidget);

      // Now play d4, which should save (1...d5 2. c4) and (1...Nf6 2. c4) as premove lines
      await tester.tap(find.text('Play d4'));

      // wait for confirm dialog to appear
      await tester.pumpAndSettle();

      await tester.tap(find.text('OK'));

      expect(playedMoveUci, 'd2d4');
      expect(lastForecastJsonRequest, {
        [
          {
            'ply': 2,
            'san': 'd5',
            'uci': 'd7d5',
            'fen': 'rnbqkbnr/ppp1pppp/8/3p4/3P4/8/PPP1PPPP/RNBQKBNR w KQkq - 0 2',
          },
          {
            'ply': 3,
            'san': 'c4',
            'uci': 'c2c4',
            'fen': 'rnbqkbnr/ppp1pppp/8/3p4/2PP4/8/PP2PPPP/RNBQKBNR b KQkq - 0 2',
          },
        ],
        [
          {
            'ply': 2,
            'san': 'Nf6',
            'uci': 'g8f6',
            'fen': 'rnbqkb1r/pppppppp/5n2/8/3P4/8/PPP1PPPP/RNBQKBNR w KQkq - 1 2',
          },
          {
            'ply': 3,
            'san': 'c4',
            'uci': 'c2c4',
            'fen': 'rnbqkb1r/pppppppp/5n2/8/2PP4/8/PP2PPPP/RNBQKBNR b KQkq - 0 2',
          },
        ],
      });
    });

    testWidgets('Tapping a premove line jumps to its final position', (tester) async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/$kGameFullId/forecasts') {
          return mockResponse(
            makeCorrespondenceGameJsonWithForecast(
              pgn: '',
              youAre: Side.black,
              forecast: [
                [SanMove('e4', Move.parse('e2e4')!), SanMove('e5', Move.parse('e7e5')!)].lock,
              ].lock,
            ),
            200,
          );
        }
        return mockResponse('', 404);
      });
      final app = await makeTestProviderScopeApp(
        tester,
        home: const AnalysisScreen(
          options: AnalysisOptions.activeCorrespondenceGame(
            orientation: Side.white,
            gameFullId: kGameFullId,
          ),
        ),
        overrides: [
          lichessClientProvider.overrideWith((ref) {
            return LichessClient(mockClient, ref);
          }),
        ],
      );

      await tester.pumpWidget(app);
      await tester.pump();

      await switchToPremoveTab(tester);

      // Should be in starting position
      expect(find.byKey(const ValueKey('e2-whitepawn')), findsOneWidget);
      expect(find.byKey(const ValueKey('e7-blackpawn')), findsOneWidget);

      await tester.tap(find.text('1. e4 e5'));

      // Wait for board to update
      await tester.pumpAndSettle();

      // Should switch to the final position of the premove line (1. e4 e5)
      expect(find.byKey(const ValueKey('e2-whitepawn')), findsNothing);
      expect(find.byKey(const ValueKey('e4-whitepawn')), findsOneWidget);
      expect(find.byKey(const ValueKey('e7-blackpawn')), findsNothing);
      expect(find.byKey(const ValueKey('e5-blackpawn')), findsOneWidget);
    });

    testWidgets('New move by opponent updates premove lines', (tester) async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/$kGameFullId/forecasts') {
          return mockResponse(
            makeCorrespondenceGameJsonWithForecast(
              pgn: '',
              youAre: Side.black,
              forecast: [
                [
                  SanMove('e4', Move.parse('e2e4')!),
                  SanMove('e5', Move.parse('e7e5')!),
                  SanMove('Nf3', Move.parse('g1f3')!),
                  SanMove('Nc6', Move.parse('b8c6')!),
                ].lock,
                [
                  SanMove('e4', Move.parse('e2e4')!),
                  SanMove('e5', Move.parse('e7e5')!),
                  SanMove('Bc4', Move.parse('f1c4')!),
                  SanMove('Nf6', Move.parse('g8f6')!),
                ].lock,
                [
                  SanMove('d4', Move.parse('d2d4')!),
                  SanMove('d5', Move.parse('d7d5')!),
                  SanMove('c4', Move.parse('c2c4')!),
                  SanMove('e6', Move.parse('e7e6')!),
                ].lock,
              ].lock,
            ),
            200,
          );
        }
        return mockResponse('', 404);
      });
      final app = await makeTestProviderScopeApp(
        tester,
        home: const AnalysisScreen(
          options: AnalysisOptions.activeCorrespondenceGame(
            orientation: Side.white,
            gameFullId: kGameFullId,
          ),
        ),
        overrides: [
          lichessClientProvider.overrideWith((ref) {
            return LichessClient(mockClient, ref);
          }),
        ],
      );

      await tester.pumpWidget(app);
      await tester.pump();

      await switchToPremoveTab(tester);

      expect(find.text('1. e4 e5 2. Nf3 Nc6'), findsOneWidget);
      expect(find.text('1. e4 e5 2. Bc4 Nf6'), findsOneWidget);
      expect(find.text('1. d4 d5 2. c4 e6'), findsOneWidget);

      // Opponent plays e4
      sendServerSocketMessages(AnalysisController.socketUri, [
        '{"t": "fen", "d": {"id": "${kGameFullId.gameId.value}", "fen": "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR", "lm": "e2e4", "wc": 0, "bc": 0}  }',
      ]);
      // Wait for socket message to arrive and board to update
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('e2-whitepawn')), findsNothing);
      expect(find.byKey(const ValueKey('e4-whitepawn')), findsOneWidget);

      // We've premoved e5, so the server will play this move for us
      sendServerSocketMessages(AnalysisController.socketUri, [
        '{"t": "fen", "d": {"id": "${kGameFullId.gameId.value}", "fen": "rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR", "lm": "e7e5", "wc": 0, "bc": 0}  }',
      ]);
      // Wait for socket message to arrive and board to update
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('e7-blackpawn')), findsNothing);
      expect(find.byKey(const ValueKey('e5-blackpawn')), findsOneWidget);

      // Only lines that started with 1. e4 e5 should be kept
      expect(find.text('2. Nf3 Nc6'), findsOneWidget);
      expect(find.text('2. Bc4 Nf6'), findsOneWidget);

      // This was the 1. d4 d5 line, it should have been discarded
      expect(find.text('2. c4 e6'), findsNothing);
    });
  });
}

const gameResponse = '''
{"id":"qVChCOTc","rated":false,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1673443822389,"lastMoveAt":1673444036416,"status":"mate","players":{"white":{"aiLevel":1},"black":{"user":{"name":"veloce","patron":true,"id":"veloce"},"rating":1435,"provisional":true}},"winner":"black","opening":{"eco":"C20","name":"King's Pawn Game: Wayward Queen Attack, Kiddie Countergambit","ply":4},"moves":"e4 e5 Qh5 Nf6 Qxe5+ Be7 b3 d6 Qb5+ Bd7 Qxb7 Nc6 Ba3 Rb8 Qa6 Nxe4 Bb2 O-O Nc3 Nb4 Nf3 Nxa6 Nd5 Nb4 Nxe7+ Qxe7 Nd4 Qf6 f4 Qe7 Ke2 Ng3+ Kd1 Nxh1 Bc4 Nf2+ Kc1 Qe1#","clocks":[18003,18003,17915,17627,17771,16691,17667,16243,17475,15459,17355,14779,17155,13795,16915,13267,14771,11955,14451,10995,14339,10203,13899,9099,12427,8379,12003,7547,11787,6691,11355,6091,11147,5763,10851,5099,10635,4657],"clock":{"initial":180,"increment":0,"totalTime":180}}
''';

const kGameFullId = GameFullId('qVChCOTc1234');

String makeCorrespondenceGameJsonWithForecast({
  required Side youAre,
  required String pgn,
  required CorrespondenceForecast forecast,
}) {
  final forecastJson = jsonEncode(
    forecast
        .map(
          (line) => line
              // Server also sends ply and fen, but we don't use them in the app,
              // so don't bother including them here
              .mapIndexed((i, move) => {'san': move.san, 'uci': move.move.uci})
              .toList(growable: false),
        )
        .toList(growable: false),
  );

  return '''
{
  "youAre": "${youAre.name}",
  "game": {
    "id": "${kGameFullId.gameId.value}",
      "variant": {
        "key": "standard",
        "name": "Standard",
        "short": "Std"
      },
      "speed": "correspondence",
      "perf": "correspondence",
      "rated": false,
      "source": "ai",
      "status": {
        "id": 20,
        "name": "started"
      },
      "createdAt": 1685698678928,
      "pgn": "$pgn"
  },
  "forecast": {
    "_id": "w48wCvjwDKff",
    "steps": $forecastJson,
    "date": 1750526972246
  },
  "white": {
    "user": {
      "name": "thibault",
      "patron": true,
      "patronColor": 1,
      "id": "thibault"
    },
    "rating": 1806,
    "provisional": true,
    "onGame": true
  },
  "black": {
    "aiLevel": 2,
    "onGame": true
  },
  "socket": 4,
  "clock": {
    "running": true,
    "initial": 600,
    "increment": 30,
    "white": 149.05,
    "black": 775.94,
    "emerg": 60,
    "moretime": 15
  },
  "expiration": {
    "idleMillis": 245,
    "millisToMove": 30000
  }
}
''';
}
