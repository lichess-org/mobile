import 'dart:convert';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/misc.dart' show Override, ProviderOrFamily;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/game/game_socket_events.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen_providers.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/clock.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wakelock_plus_platform_interface/messages.g.dart';

import '../../model/game/game_socket_example_data.dart';
import '../../network/fake_websocket_channel.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

final client = MockClient((request) {
  if (request.url.path == '/api/board/seek') {
    return mockResponse('ok', 200);
  } else if (request.url.path == '/game/export/CCW6EEru') {
    return mockResponse('''
{"id":"CCW6EEru","rated":true,"source":"lobby","variant":"standard","speed":"bullet","perf":"bullet","createdAt":1706185945680,"lastMoveAt":1706186170504,"status":"resign","players":{"white":{"user":{"name":"veloce","id":"veloce"},"rating":1789,"ratingDiff":9},"black":{"user":{"name":"chabrot","id":"chabrot"},"rating":1810,"ratingDiff":-9}},"winner":"white","opening":{"eco":"C52","name":"Italian Game: Evans Gambit, Main Line","ply":10},"moves":"e4 e5 Nf3 Nc6 Bc4 Bc5 b4 Bxb4 c3 Ba5 d4 Bb6 Ba3 Nf6 Qb3 d6 Bxf7+ Kf8 O-O Qe7 Nxe5 Nxe5 dxe5 Be6 Bxe6 Nxe4 Re1 Nc5 Bxc5 Bxc5 Qxb7 Re8 Bh3 dxe5 Qf3+ Kg8 Nd2 Rf8 Qd5+ Rf7 Be6 Qxe6 Qxe6","clocks":[12003,12003,11883,11811,11683,11379,11307,11163,11043,11043,10899,10707,10155,10483,10019,9995,9635,9923,8963,8603,7915,8283,7763,7459,7379,6083,6587,5819,6363,5651,6075,5507,5675,4803,5059,4515,4547,3555,3971,3411,3235,3123,3120,2742],"clock":{"initial":120,"increment":1,"totalTime":160}}
''', 200);
  }
  return mockResponse('', 404);
});

class MockSoundService extends Mock implements SoundService {}

void main() {
  const testGameFullId = GameFullId('qVChCOTcHSeW');
  final testGameSocketUri = GameController.socketUri(testGameFullId);

  group('Loading', () {
    testWidgets('a game directly with initialGameId', (WidgetTester tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const GameScreen(source: ExistingGameSource(testGameFullId)),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(client, ref),
          ),
        },
      );
      await tester.pumpWidget(app);

      // while loading, displays an empty board
      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.byType(PieceWidget), findsNothing);

      final initialBoardPosition = tester.getTopLeft(find.byType(Chessboard));

      // now the game controller is loading and screen doesn't have changed yet
      await tester.pump(const Duration(milliseconds: 10));
      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.byType(PieceWidget), findsNothing);
      expect(
        tester.getTopLeft(find.byType(Chessboard)),
        initialBoardPosition,
        reason: 'board position should not change',
      );

      await tester.pump(kFakeWebSocketConnectionLag);

      sendServerSocketMessages(testGameSocketUri, [
        makeFullEvent(
          const GameId('qVChCOTc'),
          '',
          whiteUserName: 'Peter',
          blackUserName: 'Steven',
        ),
      ]);
      // wait for socket message handling
      await tester.pump();

      expect(find.byType(PieceWidget), findsNWidgets(32));
      expect(find.text('Peter'), findsOneWidget);
      expect(find.text('Steven'), findsOneWidget);
      expect(
        tester.getTopLeft(find.byType(Chessboard)),
        initialBoardPosition,
        reason: 'board position should not change',
      );
    });

    testWidgets('a game from the pool with a seek', (WidgetTester tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const GameScreen(
          source: LobbySource(
            GameSeek(clock: (Duration(minutes: 3), Duration(seconds: 2)), rated: true),
          ),
        ),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(client, ref),
          ),
        },
      );
      await tester.pumpWidget(app);

      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.byType(PieceWidget), findsNothing);
      expect(find.text('Waiting for opponent to join...'), findsOneWidget);
      expect(find.text('3+2'), findsOneWidget);
      expect(find.widgetWithText(BottomBarButton, 'Cancel'), findsOneWidget);

      final initialBoardPosition = tester.getTopLeft(find.byType(Chessboard));

      // waiting for the game
      await tester.pump(const Duration(seconds: 2));

      // when a seek is accepted, server lobby sends a 'redirect' message with game id
      sendServerSocketMessages(Uri(path: '/lobby/socket/v5'), [
        '{"t": "redirect", "d": {"id": "qVChCOTcHSeW" }, "v": 1}',
      ]);
      // wait for socket message handling
      await tester.pump(const Duration(milliseconds: 1));

      // now the game controller is loading
      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.byType(PieceWidget), findsNothing);
      expect(find.text('Waiting for opponent to join...'), findsNothing);
      expect(find.text('3+2'), findsNothing);
      expect(find.widgetWithText(BottomBarButton, 'Cancel'), findsNothing);
      expect(
        tester.getTopLeft(find.byType(Chessboard)),
        initialBoardPosition,
        reason: 'board position should not change',
      );

      // wait for game socket to connect
      await tester.pump(kFakeWebSocketConnectionLag);

      sendServerSocketMessages(GameController.socketUri(testGameFullId), [
        makeFullEvent(
          const GameId('qVChCOTc'),
          '',
          whiteUserName: 'Peter',
          blackUserName: 'Steven',
        ),
      ]);
      // wait for socket message handling
      await tester.pump();

      expect(find.byType(PieceWidget), findsNWidgets(32));
      expect(find.text('Peter'), findsOneWidget);
      expect(find.text('Steven'), findsOneWidget);
      expect(find.text('Waiting for opponent to join...'), findsNothing);
      expect(find.text('3+2'), findsNothing);
      expect(
        tester.getTopLeft(find.byType(Chessboard)),
        initialBoardPosition,
        reason: 'board position should not change',
      );
    });
  });

  group('Game actions', () {
    testWidgets('move confirmation', (WidgetTester tester) async {
      await createTestGame(
        tester,
        pgn: 'e4 e5',
        clock: const (
          running: true,
          initial: Duration(minutes: 1),
          increment: Duration.zero,
          white: Duration(seconds: 58),
          black: Duration(seconds: 54),
          emerg: Duration(seconds: 10),
        ),
        serverPrefs: const ServerGamePrefs(
          showRatings: true,
          enablePremove: true,
          autoQueen: AutoQueen.always,
          confirmResign: true,
          submitMove: true,
          zenMode: Zen.no,
        ),
      );
      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.byType(PieceWidget), findsNWidgets(32));

      await playMove(tester, 'g1', 'f3');

      // see confirmation dialog
      expect(find.text('Confirm move'), findsOneWidget);
      // move is shown on board
      expect(find.byKey(const Key('f3-whiteknight')), findsOneWidget);
      // move is not yet played so it doesn't appear in the move list
      expect(find.text('Nf3'), findsNothing);

      // confirm the move
      await tester.tap(find.byIcon(CupertinoIcons.checkmark_rectangle_fill));
      await tester.pump();

      // move still shown on board
      expect(find.byKey(const Key('f3-whiteknight')), findsOneWidget);
      // move appears in move list
      expect(find.text('Nf3'), findsOneWidget);
    });

    testWidgets('takeback', (WidgetTester tester) async {
      await createTestGame(
        tester,
        pgn: 'e4 e5 Nf3',
        clock: const (
          running: true,
          initial: Duration(minutes: 1),
          increment: Duration.zero,
          white: Duration(seconds: 58),
          black: Duration(seconds: 54),
          emerg: Duration(seconds: 10),
        ),
      );
      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.byType(PieceWidget), findsNWidgets(32));

      // black plays
      sendServerSocketMessages(testGameSocketUri, [
        '{"t": "move", "v": 1, "d": {"ply": 4, "uci": "b8c6", "san": "Nc6", "clock": {"white": 58, "black": 52}}}',
      ]);
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byKey(const Key('c6-blackknight')), findsOneWidget);
      expect(
        tester.widgetList<Clock>(find.byType(Clock)).last.active,
        true,
        reason: 'white clock is active',
      );
      // white clock ticking
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime(Side.white, '0:56'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime(Side.white, '0:55'), findsOneWidget);

      // black asks for takeback
      sendServerSocketMessages(testGameSocketUri, [
        '{"t":"takebackOffers","v":2,"d":{"black":true}}',
      ]);
      await tester.pump(const Duration(milliseconds: 1));

      // see takeback button
      expect(find.byIcon(CupertinoIcons.arrowshape_turn_up_left), findsOneWidget);
      await tester.tap(find.byIcon(CupertinoIcons.arrowshape_turn_up_left));
      // wait for the popup to show (cannot use pumpAndSettle because of clocks)
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(find.text('Accept'));
      await tester.pump(const Duration(milliseconds: 10));
      // server acknowledges the takeback and ask client to reload
      sendServerSocketMessages(testGameSocketUri, ['{"v": 3}', '{"t":"reload","v":4,"d":null}']);
      // wait for client to reconnect
      await tester.pump(const Duration(milliseconds: 1));
      // socket will reconnect, wait for connection
      await tester.pump(kFakeWebSocketConnectionLag);
      // server sends 'full' event immediately after reconnect
      sendServerSocketMessages(testGameSocketUri, [
        makeFullEvent(
          const GameId('qVChCOTc'),
          'e4 e5 Nf3',
          whiteUserName: 'Peter',
          blackUserName: 'Steven',
          youAre: Side.white,
          socketVersion: 5,
          clock: (
            running: true,
            initial: const Duration(minutes: 1),
            increment: Duration.zero,
            white: const Duration(seconds: 55),
            black: const Duration(seconds: 53),
            emerg: const Duration(seconds: 10),
          ),
        ),
      ]);
      await tester.pump(const Duration(milliseconds: 1));

      // black move is cancelled
      expect(find.byKey(const Key('c6-blackknight')), findsNothing);
      expect(find.byKey(const Key('b8-blackknight')), findsOneWidget);
      expect(tester.widget<Clock>(findClock(Side.black)).active, true);
      expect(tester.widget<Clock>(findClock(Side.white)).active, false);
      // black clock is ticking
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime(Side.black, '0:52'), findsOneWidget);
      expect(findClockWithTime(Side.white, '0:55'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime(Side.black, '0:51'), findsOneWidget);
      expect(findClockWithTime(Side.white, '0:55'), findsOneWidget);
    });
  });

  group('Castling', () {
    const String castlingSetupPgn = 'e4 e5 Nf3 Nf6 Bc4 Bc5 d3 d6 Bd2 Bd7 Nc3 Nc6 Qe2 Qe7';

    for (final castlingMethod in CastlingMethod.values) {
      testWidgets('respect castling preference ($castlingMethod)', (tester) async {
        await createTestGame(
          pgn: castlingSetupPgn,
          defaultPreferences: {
            PrefCategory.board.storageKey: jsonEncode(
              BoardPrefs.defaults.copyWith(castlingMethod: castlingMethod).toJson(),
            ),
          },
          tester,
        );

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
      testWidgets('chess960: $castlingMethod', (tester) async {
        await createTestGame(
          pgn: castlingSetupPgn,
          variant: Variant.chess960,
          initialFen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
          defaultPreferences: {
            PrefCategory.board.storageKey: jsonEncode(
              BoardPrefs.defaults.copyWith(castlingMethod: castlingMethod).toJson(),
            ),
          },
          tester,
        );

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

  group('Tournament Game', () {
    final tournamentGameEvent = makeFullEvent(
      const GameId('qVChCOTc'),
      '',
      whiteUserName: 'Peter',
      blackUserName: 'Steven',
      youAre: Side.white,
      tournament: TournamentMeta(
        id: const TournamentId('id'),
        name: 'Test Tournament',
        clock: (timeLeft: const Duration(minutes: 10), at: DateTime.now()),
        berserkable: true,
        ranks: (white: 42, black: 24),
      ),
    );
    testWidgets('displays tournament info', (WidgetTester tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const GameScreen(source: ExistingGameSource(GameFullId('qVChCOTcHSeW'))),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(client, ref),
          ),
        },
      );
      await tester.pumpWidget(app);
      // Wait for game screen to load
      await tester.pump(const Duration(milliseconds: 10));

      sendServerSocketMessages(GameController.socketUri(testGameFullId), [tournamentGameEvent]);
      // wait for socket message handling
      await tester.pump();

      // Should display tournament info
      expect(find.text('Peter'), findsOneWidget);
      expect(find.text('Steven'), findsOneWidget);
      expect(find.text('Test Tournament'), findsOneWidget);
      expect(find.textContaining('#42'), findsOneWidget);
      expect(find.textContaining('#24'), findsOneWidget);
    });

    testWidgets('supports berserking', (WidgetTester tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const GameScreen(source: ExistingGameSource(GameFullId('qVChCOTcHSeW'))),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(client, ref),
          ),
        },
      );
      await tester.pumpWidget(app);
      // Wait for game screen to load
      await tester.pump(const Duration(milliseconds: 10));

      sendServerSocketMessages(GameController.socketUri(testGameFullId), [tournamentGameEvent]);
      // wait for socket message handling
      await tester.pump();

      // Nobody has berserked yet.
      // The widget we're finding is our own berserk button.
      expect(find.byIcon(LichessIcons.body_cut), findsOneWidget);

      // we berserk
      await tester.tap(find.byIcon(LichessIcons.body_cut));
      await tester.pump(const Duration(milliseconds: 10));

      // No server response yet, so should not yet show the berserk icon next to our name.
      expect(find.byIcon(LichessIcons.body_cut), findsOneWidget);

      sendServerSocketMessages(GameController.socketUri(testGameFullId), [
        '''{"t": "berserk", "d": "white"}''',
      ]);
      // wait for socket message handling
      await tester.pump();

      // We have berserked, which caused the berserk icon appear next to our name.
      // Also, the berserk button is still there (but disabled).
      expect(find.byIcon(LichessIcons.body_cut), findsNWidgets(2));

      // opponent berserks
      sendServerSocketMessages(GameController.socketUri(testGameFullId), [
        '''{"t": "berserk", "d": "black"}''',
      ]);
      // wait for socket message handling
      await tester.pump();

      expect(find.byIcon(LichessIcons.body_cut), findsNWidgets(3));
    });
  });

  group('Clock', () {
    testWidgets('loads on game start', (WidgetTester tester) async {
      await createTestGame(tester);
      expect(findClockWithTime(Side.white, '3:00'), findsOneWidget);
      expect(findClockWithTime(Side.black, '3:00'), findsOneWidget);
      expect(
        tester
            .widgetList<Clock>(find.byType(Clock))
            .where((widget) => widget.active == false)
            .length,
        2,
        reason: 'clocks are not active yet',
      );
    });

    testWidgets('ticks after the first full move', (WidgetTester tester) async {
      await createTestGame(tester);
      expect(findClockWithTime(Side.white, '3:00'), findsOneWidget);
      expect(findClockWithTime(Side.black, '3:00'), findsOneWidget);
      await playMove(tester, 'e2', 'e4');
      // at that point clock is not yet started
      expect(
        tester
            .widgetList<Clock>(find.byType(Clock))
            .where((widget) => widget.active == false)
            .length,
        2,
        reason: 'clocks are not active yet',
      );
      sendServerSocketMessages(testGameSocketUri, [
        '{"t": "move", "v": 1, "d": {"ply": 1, "uci": "e2e4", "san": "e4", "clock": {"white": 180, "black": 180}}}',
        '{"t": "move", "v": 2, "d": {"ply": 2, "uci": "e7e5", "san": "e5", "clock": {"white": 180, "black": 180}}}',
      ]);
      await tester.pump(const Duration(milliseconds: 10));
      expect(tester.widget<Clock>(findClock(Side.white)).active, true);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime(Side.white, '2:59'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime(Side.white, '2:58'), findsOneWidget);
    });

    testWidgets('ticks immediately when resuming game', (WidgetTester tester) async {
      await createTestGame(
        tester,
        pgn: 'e4 e5 Nf3',
        clock: const (
          running: true,
          initial: Duration(minutes: 3),
          increment: Duration(seconds: 2),
          white: Duration(minutes: 2, seconds: 58),
          black: Duration(minutes: 2, seconds: 54),
          emerg: Duration(seconds: 30),
        ),
      );
      expect(tester.widget<Clock>(findClock(Side.black)).active, true);
      expect(findClockWithTime(Side.white, '2:58'), findsOneWidget);
      expect(findClockWithTime(Side.black, '2:54'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime(Side.black, '2:53'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime(Side.black, '2:52'), findsOneWidget);
    });

    testWidgets('switch timer side after a move', (WidgetTester tester) async {
      await createTestGame(
        tester,
        pgn: 'e4 e5',
        clock: const (
          running: true,
          initial: Duration(minutes: 3),
          increment: Duration(seconds: 2),
          white: Duration(minutes: 2, seconds: 58),
          black: Duration(minutes: 3),
          emerg: Duration(seconds: 30),
        ),
      );
      expect(tester.widget<Clock>(findClock(Side.white)).active, true);
      // simulates think time of 3s
      await tester.pump(const Duration(seconds: 3));
      await playMove(tester, 'g1', 'f3');
      expect(findClockWithTime(Side.white, '2:55'), findsOneWidget);
      expect(
        tester.widget<Clock>(findClock(Side.white)).active,
        false,
        reason: 'white clock is stopped while waiting for server ack',
      );
      expect(
        tester.widget<Clock>(findClock(Side.black)).active,
        true,
        reason: 'black clock is now active but not yet ticking',
      );
      expect(findClockWithTime(Side.black, '3:00'), findsOneWidget);
      // simulates a long lag just to show the clock is not running yet
      await tester.pump(const Duration(milliseconds: 200));
      expect(findClockWithTime(Side.black, '3:00'), findsOneWidget);
      // server ack having the white clock updated with the increment
      sendServerSocketMessages(testGameSocketUri, [
        '{"t": "move", "v": 1, "d": {"ply": 3, "uci": "g1f3", "san": "Nf3", "clock": {"white": 177, "black": 180}}}',
      ]);
      await tester.pump(const Duration(milliseconds: 10));
      // we see now the white clock has got its increment
      expect(findClockWithTime(Side.white, '2:57'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      // black clock is ticking
      expect(findClockWithTime(Side.black, '2:59'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime(Side.white, '2:57'), findsOneWidget);
      expect(findClockWithTime(Side.black, '2:58'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime(Side.white, '2:57'), findsOneWidget);
      expect(findClockWithTime(Side.black, '2:57'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime(Side.white, '2:57'), findsOneWidget);
      expect(findClockWithTime(Side.black, '2:56'), findsOneWidget);
    });

    testWidgets('compensates opponent lag', (WidgetTester tester) async {
      int socketVersion = 0;
      await createTestGame(
        tester,
        pgn: 'e4 e5 Nf3 Nc6',
        clock: const (
          running: true,
          initial: Duration(minutes: 1),
          increment: Duration.zero,
          white: Duration(seconds: 58),
          black: Duration(seconds: 54),
          emerg: Duration(seconds: 10),
        ),
        socketVersion: socketVersion,
      );
      await tester.pump(const Duration(seconds: 3));
      await playMoveWithServerAck(
        testGameFullId,
        tester,
        'f1',
        'c4',
        ply: 5,
        san: 'Bc4',
        clockAck: (
          white: const Duration(seconds: 55),
          black: const Duration(seconds: 54),
          lag: const Duration(milliseconds: 250),
        ),
        socketVersion: ++socketVersion,
      );
      // black clock is active
      expect(tester.widget<Clock>(findClock(Side.black)).active, true);
      expect(findClockWithTime(Side.black, '0:54'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 250));
      // lag is 250ms, so clock will only start after that delay
      expect(findClockWithTime(Side.black, '0:54'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      expect(findClockWithTime(Side.black, '0:53'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime(Side.black, '0:52'), findsOneWidget);
    });

    testWidgets('onEmergency', (WidgetTester tester) async {
      final mockSoundService = MockSoundService();
      when(() => mockSoundService.play(Sound.lowTime)).thenAnswer((_) async {});
      await createTestGame(
        tester,
        pgn: 'e4 e5',
        clock: const (
          running: true,
          initial: Duration(minutes: 3),
          increment: Duration(seconds: 2),
          white: Duration(seconds: 40),
          black: Duration(minutes: 3),
          emerg: Duration(seconds: 30),
        ),
        overrides: {
          soundServiceProvider: soundServiceProvider.overrideWith((_) => mockSoundService),
        },
      );
      expect(
        tester.widget<Clock>(findClockWithTime(Side.white, '0:40')).emergencyThreshold,
        const Duration(seconds: 30),
      );
      await tester.pump(const Duration(seconds: 10));
      expect(findClockWithTime(Side.white, '0:30'), findsOneWidget);
      verify(() => mockSoundService.play(Sound.lowTime)).called(1);
    });

    testWidgets('flags', (WidgetTester tester) async {
      final socketFactory = ListenableFakeWebSocketChannelFactory(
        createDefaultFakeWebSocketChannel,
      );
      await createTestGame(
        tester,
        socketFactory: socketFactory,
        pgn: 'e4 e5 Nf3',
        clock: const (
          running: true,
          initial: Duration(minutes: 3),
          increment: Duration(seconds: 2),
          white: Duration(minutes: 2, seconds: 58),
          black: Duration(minutes: 2, seconds: 54),
          emerg: Duration(seconds: 30),
        ),
      );
      expect(tester.widget<Clock>(findClock(Side.black)).active, true);

      expect(findClockWithTime(Side.white, '2:58'), findsOneWidget);
      expect(findClockWithTime(Side.black, '2:54'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime(Side.black, '2:53'), findsOneWidget);
      await tester.pump(const Duration(minutes: 2, seconds: 53));
      expect(findClockWithTime(Side.white, '2:58'), findsOneWidget);
      expect(findClockWithTime(Side.black, '0:00.0'), findsOneWidget);

      expect(
        tester.widgetList<Clock>(find.byType(Clock)).first.active,
        true,
        reason:
            'black clock is still active after flag (as long as we have not received server ack)',
      );

      // flag messages are throttled with 500ms delay
      // we'll simulate an anormally long server response of 1s to check 2
      // flag messages are sent
      expectLater(
        socketFactory.outgoingMessages(testGameSocketUri),
        emitsInOrder(['{"t":"flag","d":"black"}', '{"t":"flag","d":"black"}']),
      );
      await tester.pump(const Duration(seconds: 1));
      sendServerSocketMessages(testGameSocketUri, [
        '{"t":"endData","d":{"status":"outoftime","winner":"white","clock":{"wc":17800,"bc":0}}}',
      ]);
      await tester.pump(const Duration(milliseconds: 10));

      expect(
        tester
            .widgetList<Clock>(find.byType(Clock))
            .where((widget) => widget.active == false)
            .length,
        2,
        reason: 'both clocks are now inactive',
      );
      expect(findClockWithTime(Side.white, '2:58'), findsOneWidget);
      expect(findClockWithTime(Side.black, '0:00.00'), findsOneWidget);

      // wait for the dong
      await tester.pump(const Duration(seconds: 500));
    });
  });

  group('Opening analysis', () {
    testWidgets('is not possible for an unfinished real time game', (WidgetTester tester) async {
      await createTestGame(
        tester,
        pgn: 'e4 e5 Nf3 Nc6 Bc4 Nf6 Ng5 d5 exd5 Na5 Bb5+ c6 dxc6 bxc6 Qf3 Rb8 Bd3',
        socketVersion: 0,
      );
      expect(find.byType(Chessboard), findsOneWidget);
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Analysis board'), findsNothing);
    });

    testWidgets('for an unfinished correspondence game', (WidgetTester tester) async {
      const gameFullId = GameFullId('qVChCOTcHSeW');
      final fullEventString = makeFullEvent(
        gameFullId.gameId,
        'e4 e5 Nf3 Nc6 Bc4 Nf6 Ng5 d5 exd5 Na5 Bb5+ c6 dxc6 bxc6 Qf3 Rb8 Bd3',
        whiteUserName: 'Peter',
        blackUserName: 'Steven',
        socketVersion: 0,
        clock: null,
        correspondenceClock: (
          daysPerTurn: 3,
          white: const Duration(days: 3),
          black: const Duration(days: 2, hours: 22, minutes: 49, seconds: 59),
        ),
      );

      // AnalysisScreen uses this to get the game data
      final mockClient = MockClient((request) {
        if (request.url.path == '/$gameFullId/forecasts') {
          return mockResponse(
            jsonEncode(
              SocketEvent.fromJson(jsonDecode(fullEventString) as Map<String, dynamic>).data,
            ),
            200,
          );
        }
        return mockResponse('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: const GameScreen(source: ExistingGameSource(gameFullId)),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(mockClient, ref),
          ),
        },
      );
      await tester.pumpWidget(app);
      await tester.pump(const Duration(milliseconds: 10));

      sendServerSocketMessages(GameController.socketUri(gameFullId), [fullEventString]);
      await tester.pump();

      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.byKey(const Key('d3-whitebishop')), findsOneWidget);
      expect(find.byKey(const Key('b5-lastMove')), findsOneWidget);
      expect(find.byKey(const Key('d3-lastMove')), findsOneWidget);
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(Dialog), findsOneWidget);
      await tester.tap(find.text('Analysis board'));
      await tester.pumpAndSettle(); // wait for analysis screen to open
      expect(
        find.widgetWithText(AppBar, 'Analysis board'),
        findsOneWidget,
      ); // analysis screen is now open
      expect(find.byKey(const Key('f3-whitequeen')), findsOneWidget);
      expect(find.byKey(const Key('d3-whitebishop')), findsOneWidget);
      expect(find.byKey(const Key('b5-lastMove')), findsOneWidget);
      expect(find.byKey(const Key('d3-lastMove')), findsOneWidget);
      await tester.tap(find.byIcon(LichessIcons.flow_cascade));
      await tester.pumpAndSettle(); // wait for the moves tab menu to open
      expect(find.text('Moves played'), findsOneWidget);
      // computer analysis is not available when game is not finished
      expect(find.text('Computer analysis'), findsNothing);
    });

    testWidgets('for a finished game', (WidgetTester tester) async {
      await loadFinishedTestGame(tester);
      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.byKey(const Key('e6-whitequeen')), findsOneWidget);
      expect(find.byKey(const Key('d5-lastMove')), findsOneWidget);
      expect(find.byKey(const Key('e6-lastMove')), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 500)); // wait for popup
      await tester.tap(find.text('Analysis board'));
      await tester.pumpAndSettle(); // wait for analysis screen to open
      expect(
        find.widgetWithText(AppBar, 'Analysis board'),
        findsOneWidget,
      ); // analysis screen is now open
      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.byKey(const Key('e6-whitequeen')), findsOneWidget);
      expect(find.byKey(const Key('d5-lastMove')), findsOneWidget);
      expect(find.byKey(const Key('e6-lastMove')), findsOneWidget);
      await tester.tap(find.byIcon(LichessIcons.flow_cascade));
      await tester.pumpAndSettle(); // wait for the moves tab menu to open
      expect(find.text('Moves played'), findsOneWidget);
      expect(find.text('Computer analysis'), findsOneWidget); // computer analysis is available
    });
  });

  group('Chat', () {
    group('Enabled', () {
      testWidgets('onNewMessage', (WidgetTester tester) async {
        final mockSoundService = MockSoundService();
        when(
          () => mockSoundService.play(Sound.confirmation, volume: any(named: 'volume')),
        ).thenAnswer((_) async {});
        await createTestGame(
          tester,
          pgn: 'e4 e5',
          overrides: {
            soundServiceProvider: soundServiceProvider.overrideWith((_) => mockSoundService),
          },
        );
        sendServerSocketMessages(testGameSocketUri, [
          '{"t":"message","d":{"u":"Steven","t":"Hello!"}}',
        ]);
        await tester.pump();
        verify(
          () => mockSoundService.play(Sound.confirmation, volume: any(named: 'volume')),
        ).called(1);
      });
    });

    group('Disabled', () {
      testWidgets('onNewMessage', (WidgetTester tester) async {
        final mockSoundService = MockSoundService();
        when(() => mockSoundService.play(Sound.confirmation)).thenAnswer((_) async {});
        await createTestGame(
          tester,
          pgn: 'e4 e5',
          defaultPreferences: {PrefCategory.game.storageKey: '{"enableChat": false}'},
          overrides: {
            soundServiceProvider: soundServiceProvider.overrideWith((_) => mockSoundService),
          },
        );
        sendServerSocketMessages(testGameSocketUri, [
          '{"t":"message","d":{"u":"Steven","t":"Hello!"}}',
        ]);
        await tester.pump();
        verifyNever(() => mockSoundService.play(Sound.confirmation));
      });
    });
  });

  group('Wakelock', () {
    for (final gameStatus in GameStatus.values) {
      final gameIsFinished = gameStatus != GameStatus.started && gameStatus != GameStatus.created;
      testWidgets(
        '${gameIsFinished ? 'disables' : 'does not disable'} when game status is ${gameStatus.name}',
        (tester) async {
          final List<ToggleMessage> messages = <ToggleMessage>[];
          const pigeonCodec = _PigeonCodec();

          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
            'dev.flutter.pigeon.wakelock_plus_platform_interface.WakelockPlusApi.toggle',
            (ByteData? data) async {
              final decodedMessages = (pigeonCodec.decodeMessage(data) as List)
                  .cast<ToggleMessage>();
              messages.add(decodedMessages.single);
              return data;
            },
          );

          addTearDown(() {
            TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
              'dev.flutter.pigeon.wakelock_plus_platform_interface.WakelockPlusApi.toggle',
              null,
            );
          });

          await createTestGame(
            tester,
            pgn: 'e4 e5',
            defaultPreferences: {PrefCategory.game.storageKey: '{"enableChat": false}'},
          );

          sendServerSocketMessages(testGameSocketUri, [
            '{"t":"endData","d":{"status":"${gameStatus.name}","winner":"white","clock":{"wc":17800,"bc":0}}}',
          ]);

          await tester.pump();

          await tester.pump(const Duration(seconds: 500));
          expect(messages.last.enable, gameIsFinished ? isFalse : isTrue);
        },
      );
    }
  });
}

/// Finds the clock on the specified [side].
Finder findClock(Side side, {bool skipOffstage = true}) {
  return find.byKey(ValueKey('${side.name}-clock'), skipOffstage: skipOffstage);
}

/// Finds the clock with the given [text] on the specified [side].
Finder findClockWithTime(Side side, String text, {bool skipOffstage = true}) {
  return find.ancestor(
    of: find.text(text, findRichText: true, skipOffstage: skipOffstage),
    matching: find.byKey(ValueKey('${side.name}-clock'), skipOffstage: skipOffstage),
  );
}

/// Simulates playing a move and getting the ack from the server after [elapsedTime].
Future<void> playMoveWithServerAck(
  GameFullId gameFullId,
  WidgetTester tester,
  String from,
  String to, {
  required String san,
  required ({Duration white, Duration black, Duration? lag}) clockAck,
  required int socketVersion,
  required int ply,
  Duration elapsedTime = const Duration(milliseconds: 10),
  Side orientation = Side.white,
}) async {
  await playMove(tester, from, to, orientation: orientation);
  final uci = '$from$to';
  final lagStr = clockAck.lag != null
      ? ', "lag": ${(clockAck.lag!.inMilliseconds / 10).round()}'
      : '';
  await tester.pump(elapsedTime - const Duration(milliseconds: 1));
  sendServerSocketMessages(GameController.socketUri(gameFullId), [
    '{"t": "move", "v": $socketVersion, "d": {"ply": $ply, "uci": "$uci", "san": "$san", "clock": {"white": ${(clockAck.white.inMilliseconds / 1000).toStringAsFixed(2)}, "black": ${(clockAck.black.inMilliseconds / 1000).toStringAsFixed(2)}$lagStr}}}',
  ]);
  await tester.pump();
}

/// Convenient function to start a new test game
Future<void> createTestGame(
  WidgetTester tester, {
  Variant variant = Variant.standard,
  String? initialFen,
  Side? youAre = Side.white,
  String? pgn,
  int socketVersion = 0,
  FullEventTestClock? clock = const (
    running: false,
    initial: Duration(minutes: 3),
    increment: Duration(seconds: 2),
    white: Duration(minutes: 3),
    black: Duration(minutes: 3),
    emerg: Duration(seconds: 30),
  ),
  FullEventTestCorrespondenceClock? correspondenceClock,
  Map<String, Object>? defaultPreferences,
  Map<ProviderOrFamily, Override>? overrides,
  TournamentMeta? tournament,
  ServerGamePrefs? serverPrefs,

  /// An optional listenable fake web socket channel factory to use in place of the default one if
  /// we need to listen to the sent messages.
  ListenableFakeWebSocketChannelFactory? socketFactory,
}) async {
  const gameFullId = GameFullId('qVChCOTcHSeW');
  final app = await makeTestProviderScopeApp(
    tester,
    home: const GameScreen(source: ExistingGameSource(gameFullId)),
    defaultPreferences: defaultPreferences,
    overrides: {
      lichessClientProvider: lichessClientProvider.overrideWith(
        (ref) => LichessClient(client, ref),
      ),
      if (socketFactory != null)
        webSocketChannelFactoryProvider: webSocketChannelFactoryProvider.overrideWith((ref) {
          ref.onDispose(socketFactory.dispose);
          return socketFactory;
        }),
      ...?overrides,
    },
  );
  await tester.pumpWidget(app);
  await tester.pump(const Duration(milliseconds: 10));

  sendServerSocketMessages(GameController.socketUri(gameFullId), [
    makeFullEvent(
      variant: variant,
      const GameId('qVChCOTc'),
      pgn ?? '',
      initialFen: initialFen,
      whiteUserName: 'Peter',
      blackUserName: 'Steven',
      youAre: youAre,
      socketVersion: socketVersion,
      clock: clock,
      correspondenceClock: correspondenceClock,
      tournament: tournament,
      serverPrefs: serverPrefs,
    ),
  ]);
  await tester.pump();
}

Future<void> loadFinishedTestGame(
  WidgetTester tester, {
  String serverFullEvent = _finishedGameFullEvent,
  Map<ProviderOrFamily, Override>? overrides,
}) async {
  final json = jsonDecode(serverFullEvent) as Map<String, dynamic>;
  final gameId = GameFullEvent.fromJson(json['d'] as Map<String, dynamic>).game.id;
  final gameFullId = GameFullId('${gameId.value}test');
  final app = await makeTestProviderScopeApp(
    tester,
    home: GameScreen(source: ExistingGameSource(gameFullId)),
    overrides: {
      lichessClientProvider: lichessClientProvider.overrideWith(
        (ref) => LichessClient(client, ref),
      ),
      ...?overrides,
    },
  );
  await tester.pumpWidget(app);
  await tester.pump(const Duration(milliseconds: 10));
  // wait for socket
  await tester.pump(kFakeWebSocketConnectionLag);

  sendServerSocketMessages(GameController.socketUri(gameFullId), [serverFullEvent]);
  await tester.pump();
}

const _finishedGameFullEvent = '''
{"t":"full","d":{"game":{"id":"CCW6EEru","variant":{"key":"standard","name":"Standard","short":"Std"},"speed":"bullet","perf":"bullet","rated":true,"fen":"6kr/p1p2rpp/4Q3/2b1p3/8/2P5/P2N1PPP/R3R1K1 b - - 0 22","turns":43,"source":"lobby","status":{"id":31,"name":"resign"},"createdAt":1706185945680,"winner":"white","pgn":"e4 e5 Nf3 Nc6 Bc4 Bc5 b4 Bxb4 c3 Ba5 d4 Bb6 Ba3 Nf6 Qb3 d6 Bxf7+ Kf8 O-O Qe7 Nxe5 Nxe5 dxe5 Be6 Bxe6 Nxe4 Re1 Nc5 Bxc5 Bxc5 Qxb7 Re8 Bh3 dxe5 Qf3+ Kg8 Nd2 Rf8 Qd5+ Rf7 Be6 Qxe6 Qxe6"},"white":{"user":{"name":"veloce","id":"veloce"},"rating":1789,"ratingDiff":9},"black":{"user":{"name":"chabrot","id":"chabrot"},"rating":1810,"ratingDiff":-9},"socket":0,"clock":{"running":false,"initial":120,"increment":1,"white":31.2,"black":27.42,"emerg":15,"moretime":15},"takebackable":true,"youAre":"white","prefs":{"autoQueen":2,"zen":2,"confirmResign":true,"enablePremove":true},"chat":{"lines":[]}}}
''';

/// Necessary to mock wakelock_plus method calls
/// See: https://github.com/fluttercommunity/wakelock_plus/blob/0c74e5bbc6aefac57b6c96bb7ef987705ed559ec/wakelock_plus_platform_interface/lib/messages.g.dart#L127-L156
class _PigeonCodec extends StandardMessageCodec {
  const _PigeonCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is int) {
      buffer.putUint8(4);
      buffer.putInt64(value);
    } else if (value is ToggleMessage) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is IsEnabledMessage) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 129:
        return ToggleMessage.decode(readValue(buffer)!);
      case 130:
        return IsEnabledMessage.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}
