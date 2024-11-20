import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/clock.dart';
import 'package:mocktail/mocktail.dart';

import '../../model/game/game_socket_example_data.dart';
import '../../network/fake_websocket_channel.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

final client = MockClient((request) {
  if (request.url.path == '/api/board/seek') {
    return mockResponse('ok', 200);
  }
  return mockResponse('', 404);
});

class MockSoundService extends Mock implements SoundService {}

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

      // now the game controller is loading and screen doesn't have changed yet
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

    testWidgets('a game from the pool with a seek',
        (WidgetTester tester) async {
      final fakeLobbySocket = FakeWebSocketChannel();
      final fakeGameSocket = FakeWebSocketChannel();

      final app = await makeTestProviderScopeApp(
        tester,
        home: const GameScreen(
          seek: GameSeek(
            clock: (Duration(minutes: 3), Duration(seconds: 2)),
            rated: true,
          ),
        ),
        overrides: [
          lichessClientProvider
              .overrideWith((ref) => LichessClient(client, ref)),
          webSocketChannelFactoryProvider.overrideWith((ref) {
            return FakeWebSocketChannelFactory(
              (String url) =>
                  url.contains('lobby') ? fakeLobbySocket : fakeGameSocket,
            );
          }),
        ],
      );
      await tester.pumpWidget(app);

      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.byType(PieceWidget), findsNothing);
      expect(find.text('Waiting for opponent to join...'), findsOneWidget);
      expect(find.text('3+2'), findsOneWidget);
      expect(find.widgetWithText(BottomBarButton, 'Cancel'), findsOneWidget);

      // waiting for the game
      await tester.pump(const Duration(seconds: 2));

      // when a seek is accepted, server sends a 'redirect' message with game id
      fakeLobbySocket.addIncomingMessages([
        '{"t": "redirect", "d": {"id": "qVChCOTcHSeW" }, "v": 1}',
      ]);
      await tester.pump(const Duration(milliseconds: 1));

      // now the game controller is loading
      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.byType(PieceWidget), findsNothing);
      expect(find.text('Waiting for opponent to join...'), findsNothing);
      expect(find.text('3+2'), findsNothing);
      expect(find.widgetWithText(BottomBarButton, 'Cancel'), findsNothing);

      await fakeGameSocket.connectionEstablished;
      // now that game socket is open, lobby socket should be closed
      expect(fakeLobbySocket.closeCode, isNotNull);

      fakeGameSocket.addIncomingMessages([
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
      expect(find.text('Waiting for opponent to join...'), findsNothing);
      expect(find.text('3+2'), findsNothing);
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
          emerg: Duration(seconds: 30),
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
          emerg: Duration(seconds: 30),
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

    testWidgets('compensates opponent lag', (WidgetTester tester) async {
      final fakeSocket = FakeWebSocketChannel();
      int socketVersion = 0;
      await createTestGame(
        fakeSocket,
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
        fakeSocket,
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
      expect(tester.widgetList<Clock>(find.byType(Clock)).first.active, true);
      expect(findClockWithTime('0:54'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 250));
      // lag is 250ms, so clock will only start after that delay
      expect(findClockWithTime('0:54'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      expect(findClockWithTime('0:53'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime('0:52'), findsOneWidget);
    });

    testWidgets('onEmergency', (WidgetTester tester) async {
      final mockSoundService = MockSoundService();
      when(() => mockSoundService.play(Sound.lowTime)).thenAnswer((_) async {});
      final fakeSocket = FakeWebSocketChannel();
      await createTestGame(
        fakeSocket,
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
        overrides: [
          soundServiceProvider.overrideWith((_) => mockSoundService),
        ],
      );
      expect(
        tester.widget<Clock>(findClockWithTime('0:40')).emergencyThreshold,
        const Duration(seconds: 30),
      );
      await tester.pump(const Duration(seconds: 10));
      expect(findClockWithTime('0:30'), findsOneWidget);
      verify(() => mockSoundService.play(Sound.lowTime)).called(1);
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
          emerg: Duration(seconds: 30),
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

/// Simulates playing a move and getting the ack from the server after [elapsedTime].
Future<void> playMoveWithServerAck(
  FakeWebSocketChannel socket,
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
  socket.addIncomingMessages([
    '{"t": "move", "v": $socketVersion, "d": {"ply": $ply, "uci": "$uci", "san": "$san", "clock": {"white": ${(clockAck.white.inMilliseconds / 1000).toStringAsFixed(2)}, "black": ${(clockAck.black.inMilliseconds / 1000).toStringAsFixed(2)}$lagStr}}}',
  ]);
  await tester.pump(const Duration(milliseconds: 1));
}

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
    emerg: Duration(seconds: 30),
  ),
  List<Override>? overrides,
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
      ...?overrides,
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
