import 'package:chessground/chessground.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/view/correspondence/offline_correspondence_game_screen.dart';
import 'package:lichess_mobile/src/view/game/correspondence_clock_widget.dart';
import 'package:lichess_mobile/src/view/game/game_player.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';

import '../../example_data.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

const _iPhone16ZoomedSurface = Size(320.0, 693.0);
const _iPhone16ZoomedDevicePixelRatio = 3.0;
const _iPhone16ZoomedPhysicalViewPadding = EdgeInsets.only(top: 141.0, bottom: 102.0);

void main() {
  group('Offline correspondence game', () {
    for (final profile in kCompactPortraitProfiles) {
      for (final side in Side.values) {
        testWidgets('compact post-startup correspondence ${profile.name} ${side.name}', (
          tester,
        ) async {
          await prepareLayoutGolden(tester);
          final game = offlineCorrespondenceGame.copyWith(
            steps: makeSteps(side == Side.white ? 'e4 e5' : 'e4 e5 Nf3'),
            youAre: side,
          );
          final flutterTestOnError = FlutterError.onError!;
          final app = await makeTestProviderScopeApp(
            tester,
            home: OfflineCorrespondenceGameScreen(initialGame: (DateTime.now(), game)),
            surfaceSize: profile.surface,
            devicePixelRatio: 3.0,
            physicalViewPadding: profile.physicalPadding,
          );
          FlutterError.onError = flutterTestOnError;
          addTearDown(() => FlutterError.onError = flutterTestOnError);
          await tester.pumpWidget(app);
          await tester.pumpAndSettle();
          final me = side == Side.white ? 'White' : 'Black';
          final opponent = side == Side.white ? 'Black' : 'White';
          final cancel = find.byIcon(CupertinoIcons.xmark_rectangle_fill);
          final accept = find.byIcon(CupertinoIcons.checkmark_rectangle_fill);

          void checkLayout({required bool pending}) {
            expectCompactBoardLayout(tester, heightCapped: profile.heightCapped);
            // Offline white shows only its own clock; offline black also sees white's.
            expect(find.byType(CorrespondenceClock), findsNWidgets(side == Side.white ? 1 : 2));
            expectGameControlsVisible(tester, find.byType(CorrespondenceClock));
            expectGameControlsVisible(tester, find.text(opponent));
            expect(find.textContaining('1500', findRichText: true), findsNWidgets(pending ? 1 : 2));
            expectGameControlsVisible(tester, find.textContaining('1500', findRichText: true));
            expectGameControlsVisible(tester, find.byType(BottomBarButton));
            if (pending) {
              expect(find.text(me), findsNothing);
              expectGameControlsVisible(tester, find.byType(ConfirmMove));
              expect(cancel.hitTestable(), findsOneWidget);
              expect(accept.hitTestable(), findsOneWidget);
              final confirmation = tester.getRect(find.byType(ConfirmMove));
              final clocks = find.byType(CorrespondenceClock);
              for (var index = 0; index < clocks.evaluate().length; index++) {
                expect(confirmation.overlaps(tester.getRect(clocks.at(index))), isFalse);
              }
            } else {
              expect(find.byType(ConfirmMove), findsNothing);
              expectGameControlsVisible(tester, find.text(me));
            }
            expect(tester.takeException(), isNull);
          }

          final from = side == Side.white ? 'g1' : 'b8';
          final to = side == Side.white ? 'f3' : 'c6';
          checkLayout(pending: false);
          expect(
            tester
                .widgetList<CorrespondenceClock>(find.byType(CorrespondenceClock))
                .where((clock) => clock.active)
                .length,
            1,
          );
          await tester.pump(const Duration(minutes: 1));
          checkLayout(pending: false);
          await playMove(tester, from, to, orientation: side);
          checkLayout(pending: true);
          await expectLayoutGolden(
            find.byType(OfflineCorrespondenceGameScreen),
            '../../../build/compact-layout/correspondence-pending-${profile.name}-${side.name}',
          );
          await tester.tap(cancel);
          await tester.pump();
          checkLayout(pending: false);
          expect(
            boardHasPiece(tester, Square.fromName(from), Piece(color: side, role: Role.knight)),
            isTrue,
          );

          await playMove(tester, from, to, orientation: side);
          checkLayout(pending: true);
          await tester.tap(accept);
          await tester.pumpAndSettle();
          checkLayout(pending: false);
          expect(
            boardHasPiece(tester, Square.fromName(to), Piece(color: side, role: Role.knight)),
            isTrue,
          );
          expect(
            tester
                .widgetList<CorrespondenceClock>(find.byType(CorrespondenceClock))
                .where((clock) => clock.active)
                .length,
            side == Side.white ? 0 : 1,
          );
          await expectLayoutGolden(
            find.byType(OfflineCorrespondenceGameScreen),
            '../../../build/compact-layout/correspondence-confirmed-${profile.name}-${side.name}',
          );
        }, variant: kPlatformVariant);
      }
    }

    testWidgets('compact portrait board fills width with correspondence controls visible', (
      tester,
    ) async {
      final flutterTestOnError = FlutterError.onError!;
      final app = await makeTestProviderScopeApp(
        tester,
        home: OfflineCorrespondenceGameScreen(
          initialGame: (DateTime(2021, 1, 1), offlineCorrespondenceGame),
        ),
        surfaceSize: _iPhone16ZoomedSurface,
        devicePixelRatio: _iPhone16ZoomedDevicePixelRatio,
        physicalViewPadding: _iPhone16ZoomedPhysicalViewPadding,
      );
      FlutterError.onError = flutterTestOnError;
      addTearDown(() => FlutterError.onError = flutterTestOnError);

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final boardRect = tester.getRect(find.byType(Chessboard));
      expect(boardRect.left, 0.0);
      expect(boardRect.right, _iPhone16ZoomedSurface.width);
      expect(boardRect.size, const Size.square(320.0));
      expect(find.byType(BottomBar), findsOneWidget);
      expect(find.byType(BottomBarButton), findsNWidgets(6));
      expectGameControlsVisible(tester, find.byType(BottomBarButton));
    }, variant: kPlatformVariant);

    testWidgets('Last move is highlighted when loading a game', (tester) async {
      // Regression test: interactive boards read the last move from
      // InteractiveBoardParams.lastMove, not GameLayout.lastMove (readonly only).
      // The last move of a loaded game must be highlighted on the board.
      final app = await makeTestProviderScopeApp(
        tester,
        home: OfflineCorrespondenceGameScreen(
          initialGame: (DateTime(2021, 1, 1), offlineCorrespondenceGame),
        ),
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // The fixture's last move is Qd2 (d1d2); it must be highlighted on the board.
      expect(getBoardLastMove(tester), Move.parse('d1d2'));
    });

    testWidgets('Last move is highlighted after playing a move', (tester) async {
      // A game where it's the user's (white's) turn from the initial position.
      final game = offlineCorrespondenceGame.copyWith(
        steps: [const GameStep(position: Chess.initial)].lock,
      );

      final app = await makeTestProviderScopeApp(
        tester,
        home: OfflineCorrespondenceGameScreen(initialGame: (DateTime(2021, 1, 1), game)),
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // No last move highlight before any move is played.
      expect(getBoardLastMove(tester), isNull);

      await playMove(tester, 'e2', 'e4');
      await tester.pumpAndSettle();

      expect(getBoardLastMove(tester), Move.parse('e2e4'));
    });
  });
}
