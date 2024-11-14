import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/widgets/countdown_clock.dart';

import '../../model/game/game_socket_example_data.dart';
import '../../network/fake_websocket_channel.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

final client = MockClient((request) {
  return mockResponse('', 404);
});

void main() {
  group('Loading', () {
    testWidgets('a game directly with initialGameId',
        (WidgetTester tester) async {
      final fakeSocket = FakeWebSocketChannel();

      final app = await makeTestProviderScopeApp(
        tester,
        home: const GameScreen(
          initialGameId: GameFullId('qVChCOTcHSeW'),
        ),
        overrides: [
          lichessClientProvider
              .overrideWith((ref) => LichessClient(client, ref)),
          webSocketChannelFactoryProvider.overrideWith((ref) {
            return FakeWebSocketChannelFactory((_) => fakeSocket);
          }),
        ],
      );
      await tester.pumpWidget(app);

      // while loading, displays an empty board
      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.byType(PieceWidget), findsNothing);

      // now loads the game controller
      // screen doesn't have changed yet
      await tester.pump(const Duration(milliseconds: 10));
      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.byType(PieceWidget), findsNothing);

      await fakeSocket.connectionEstablished;

      fakeSocket.addIncomingMessages([
        makeFullEvent(
          const GameId('qVChCOTc'),
          '',
          whiteUserName: 'Peter',
          blackUserName: 'Steven',
        ),
      ]);
      // wait for socket message
      await tester.pump(const Duration(milliseconds: 10));

      expect(find.byType(PieceWidget), findsNWidgets(32));
      expect(find.text('Peter'), findsOneWidget);
      expect(find.text('Steven'), findsOneWidget);
    });
  });

  group('Clock', () {
    testWidgets('loads on game start', (WidgetTester tester) async {
      final fakeSocket = FakeWebSocketChannel();
      await createTestGame(fakeSocket, tester);
      expect(findClockWithTime('3:00'), findsNWidgets(2));
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
      final fakeSocket = FakeWebSocketChannel();
      await createTestGame(fakeSocket, tester);
      expect(findClockWithTime('3:00'), findsNWidgets(2));
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
      fakeSocket.addIncomingMessages([
        '{"t": "move", "v": 1, "d": {"ply": 1, "uci": "e2e4", "san": "e4", "clock": {"white": 180, "black": 180}}}',
        '{"t": "move", "v": 2, "d": {"ply": 2, "uci": "e7e5", "san": "e5", "clock": {"white": 180, "black": 180}}}',
      ]);
      await tester.pump(const Duration(milliseconds: 10));
      expect(
        tester.widgetList<Clock>(find.byType(Clock)).last.active,
        true,
        reason: 'my clock is now active',
      );
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime('2:59'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime('2:58'), findsOneWidget);
    });

    testWidgets('ticks immediately when resuming game',
        (WidgetTester tester) async {
      final fakeSocket = FakeWebSocketChannel();
      await createTestGame(
        fakeSocket,
        tester,
        pgn: 'e4 e5 Nf3',
        clock: const (
          running: true,
          initial: Duration(minutes: 3),
          increment: Duration(seconds: 2),
          white: Duration(minutes: 2, seconds: 58),
          black: Duration(minutes: 2, seconds: 54),
        ),
      );
      expect(
        tester.widgetList<Clock>(find.byType(Clock)).first.active,
        true,
        reason: 'black clock is already active',
      );
      expect(findClockWithTime('2:58'), findsOneWidget);
      expect(findClockWithTime('2:54'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime('2:53'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime('2:52'), findsOneWidget);
    });

    testWidgets('switch timer side after a move', (WidgetTester tester) async {
      final fakeSocket = FakeWebSocketChannel();
      await createTestGame(
        fakeSocket,
        tester,
        pgn: 'e4 e5',
        clock: const (
          running: true,
          initial: Duration(minutes: 3),
          increment: Duration(seconds: 2),
          white: Duration(minutes: 2, seconds: 58),
          black: Duration(minutes: 3),
        ),
      );
      expect(tester.widgetList<Clock>(find.byType(Clock)).last.active, true);
      // simulates think time of 3s
      await tester.pump(const Duration(seconds: 3));
      await playMove(tester, 'g1', 'f3');
      expect(findClockWithTime('2:55'), findsOneWidget);
      expect(
        tester.widgetList<Clock>(find.byType(Clock)).last.active,
        false,
        reason: 'white clock is stopped while waiting for server ack',
      );
      expect(
        tester.widgetList<Clock>(find.byType(Clock)).first.active,
        true,
        reason: 'black clock is now active but not yet ticking',
      );
      expect(findClockWithTime('3:00'), findsOneWidget);
      // simulates a long lag just to show the clock is not running yet
      // in such case the server would send a "lag" field but we'll ignore it in that test
      await tester.pump(const Duration(milliseconds: 200));
      expect(findClockWithTime('3:00'), findsOneWidget);
      // server ack having the white clock updated with the increment
      fakeSocket.addIncomingMessages([
        '{"t": "move", "v": 1, "d": {"ply": 3, "uci": "g1f3", "san": "Nf3", "clock": {"white": 177, "black": 180}}}',
      ]);
      await tester.pump(const Duration(milliseconds: 10));
      // we see now the white clock has got its increment
      expect(findClockWithTime('2:57'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      // black clock is ticking
      expect(findClockWithTime('2:59'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime('2:57'), findsOneWidget);
      expect(findClockWithTime('2:58'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime('2:57'), findsNWidgets(2));
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime('2:57'), findsOneWidget);
      expect(findClockWithTime('2:56'), findsOneWidget);
    });

    testWidgets('flags', (WidgetTester tester) async {
      final fakeSocket = FakeWebSocketChannel();
      await createTestGame(
        fakeSocket,
        tester,
        pgn: 'e4 e5 Nf3',
        clock: const (
          running: true,
          initial: Duration(minutes: 3),
          increment: Duration(seconds: 2),
          white: Duration(minutes: 2, seconds: 58),
          black: Duration(minutes: 2, seconds: 54),
        ),
      );
      expect(
        tester.widgetList<Clock>(find.byType(Clock)).first.active,
        true,
        reason: 'black clock is active',
      );

      expect(findClockWithTime('2:58'), findsOneWidget);
      expect(findClockWithTime('2:54'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime('2:53'), findsOneWidget);
      await tester.pump(const Duration(minutes: 2, seconds: 53));
      expect(findClockWithTime('2:58'), findsOneWidget);
      expect(findClockWithTime('0:00.0'), findsOneWidget);

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
        fakeSocket.sentMessagesExceptPing,
        emitsInOrder([
          '{"t":"flag","d":"black"}',
          '{"t":"flag","d":"black"}',
        ]),
      );
      await tester.pump(const Duration(seconds: 1));
      fakeSocket.addIncomingMessages([
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
      expect(findClockWithTime('2:58'), findsOneWidget);
      expect(findClockWithTime('0:00.00'), findsOneWidget);

      // wait for the dong
      await tester.pump(const Duration(seconds: 500));
    });
  });
}

Finder findClockWithTime(String text, {bool skipOffstage = true}) {
  return find.ancestor(
    of: find.text(text, findRichText: true, skipOffstage: skipOffstage),
    matching: find.byType(Clock, skipOffstage: skipOffstage),
  );
}

// /// Simulates playing a move and getting the ack from the server after [elapsedTime].
// Future<void> playMoveWithServerAck(
//   FakeWebSocketChannel socket,
//   WidgetTester tester,
//   String from,
//   String to, {
//   required String san,
//   required ({Duration white, Duration black}) clockAck,
//   required int socketVersion,
//   required int ply,
//   Duration elapsedTime = const Duration(milliseconds: 10),
//   Rect? rect,
//   Side orientation = Side.white,
// }) async {
//   await playMove(tester, from, to, boardRect: rect, orientation: orientation);
//   final uci = '$from$to';
//   socket.addIncomingMessages([
//     '{"t": "move", "v": $socketVersion, "d": {"ply": $ply, "uci": "$uci", "san": "$san", "clock": {"white": 180, "black": 180}}}',
//   ]);
//   await tester.pump(elapsedTime);
// }

/// Convenient function to start a new test game
Future<void> createTestGame(
  FakeWebSocketChannel socket,
  WidgetTester tester, {
  Side? youAre = Side.white,
  String? pgn,
  int socketVersion = 0,
  FullEventTestClock clock = const (
    running: false,
    initial: Duration(minutes: 3),
    increment: Duration(seconds: 2),
    white: Duration(minutes: 3),
    black: Duration(minutes: 3),
  ),
}) async {
  final app = await makeTestProviderScopeApp(
    tester,
    home: const GameScreen(
      initialGameId: GameFullId('qVChCOTcHSeW'),
    ),
    overrides: [
      lichessClientProvider.overrideWith((ref) => LichessClient(client, ref)),
      webSocketChannelFactoryProvider.overrideWith((ref) {
        return FakeWebSocketChannelFactory((_) => socket);
      }),
    ],
  );
  await tester.pumpWidget(app);
  await tester.pump(const Duration(milliseconds: 10));
  await socket.connectionEstablished;

  socket.addIncomingMessages([
    makeFullEvent(
      const GameId('qVChCOTc'),
      pgn ?? '',
      whiteUserName: 'Peter',
      blackUserName: 'Steven',
      youAre: youAre,
      socketVersion: socketVersion,
      clock: clock,
    ),
  ]);
  await tester.pump(const Duration(milliseconds: 10));
}
