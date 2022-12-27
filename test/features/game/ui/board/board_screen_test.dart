import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:dartchess/dartchess.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chessground/chessground.dart' as cg;

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/widgets/countdown_clock.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/http.dart';
import 'package:lichess_mobile/src/common/sound.dart';
import 'package:lichess_mobile/src/common/shared_preferences.dart';
import 'package:lichess_mobile/src/features/game/ui/board/board_screen.dart';
import 'package:lichess_mobile/src/features/game/model/game.dart' as game;
import '../../../auth/data/fake_auth_repository.dart';
import '../../../../utils.dart';

class MockClient extends Mock implements http.Client {}

class MockLogger extends Mock implements Logger {}

class MockSoundService extends Mock implements SoundService {}

void main() {
  final mockLogger = MockLogger();
  final mockClient = MockClient();
  final mockSoundService = MockSoundService();

  setUpAll(() {
    reset(mockClient);

    registerFallbackValue(http.Request('GET', Uri.parse('http://api.test')));
  });

  group('BoardScreen', () {
    testWidgets(
        'displays game info during loading state and update state after 1st gameFull event',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();

      when(() => mockClient.send(any(
              that: sameRequest(http.Request(
                  'GET',
                  Uri.parse(
                      '$kLichessHost/api/board/game/stream/$gameIdTest'))))))
          .thenAnswer((_) => mockHttpStreamFromIterable([
                '{ "type": "gameFull", "id": "$gameIdTest", "speed": "blitz", "initialFen": "$kInitialFEN", "white": { "id": "white", "name": "White", "rating": 1405 }, "black": { "id": "black", "name": "Black", "rating": 1789 }, "state": { "type": "gameState", "moves": "", "wtime": 180000, "btime": 180000, "status": "started" }}'
              ]));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
            apiClientProvider
                .overrideWithValue(ApiClient(mockLogger, mockClient)),
            soundServiceProvider.overrideWithValue(mockSoundService),
          ],
          child: buildTestApp(
            home: Consumer(builder: (context, ref, _) {
              return Scaffold(
                  body: BoardScreen(game: testGame, account: fakeUser));
            }),
          ),
        ),
      );

      expect(find.byType(cg.Board), findsOneWidget);
      expect(find.byType(cg.PieceWidget), findsNWidgets(32));
      expect(find.widgetWithText(Player, 'White'), findsOneWidget);
      expect(find.widgetWithText(Player, 'Black'), findsOneWidget);
      expect(find.widgetWithText(Player, '1405'), findsOneWidget);
      expect(find.widgetWithText(Player, '1789'), findsOneWidget);
      expect(find.widgetWithText(CountdownClock, '0:00'), findsNWidgets(2));

      // cannot interact with board during loading state
      await tester.tap(find.byKey(const Key('e2-whitepawn')));
      await tester.pump();
      expect(find.byKey(const Key('e2-selected')), findsNothing);

      // wait for stream loading
      await tester.pump(const Duration(milliseconds: 100));

      // same info displayed
      expect(find.byType(cg.Board), findsOneWidget);
      expect(find.byType(cg.PieceWidget), findsNWidgets(32));
      expect(find.widgetWithText(Player, 'White'), findsOneWidget);
      expect(find.widgetWithText(Player, 'Black'), findsOneWidget);
      expect(find.widgetWithText(Player, '1405'), findsOneWidget);
      expect(find.widgetWithText(Player, '1789'), findsOneWidget);
      // clock is updated
      expect(find.widgetWithText(CountdownClock, '3:00'), findsNWidgets(2));

      // board interaction is now possible
      await tester.tap(find.byKey(const Key('e2-whitepawn')));
      await tester.pump();
      expect(find.byKey(const Key('e2-selected')), findsOneWidget);
    });

    testWidgets('play two moves', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
            apiClientProvider.overrideWithValue(
                ApiClient(mockLogger, FakeGameClient(), retries: [])),
            soundServiceProvider.overrideWithValue(mockSoundService),
          ],
          child: buildTestApp(
            home: Consumer(builder: (context, ref, _) {
              return Scaffold(
                  body: BoardScreen(game: testGame, account: fakeUser));
            }),
          ),
        ),
      );

      await tester
          .pump(const Duration(milliseconds: 100)); // wait for stream loading

      final boardPos = tester.getRect(find.byType(cg.Board));

      // both clocks are not active first
      _checkActiveClocks(tester, whiteActive: false, blackActive: false);

      await makeMove(tester, boardPos, 'e2', 'e4');

      // move made
      verify(() => mockSoundService.playMove()).called(1);
      expect(find.byKey(const Key('e4-whitepawn')), findsOneWidget);
      expect(find.byKey(const Key('e2-whitepawn')), findsNothing);

      // can interact to make premoves
      await tester.tapAt(squareOffset('f1', boardPos));
      await tester.pump();
      expect(find.byKey(const Key('f1-selected')), findsOneWidget);
      // move cursor updated, can go backward
      expect(
          tester
              .widget<IconButton>(find.byKey(const ValueKey('cursor-first')))
              .onPressed,
          isNotNull);
      expect(
          tester
              .widget<IconButton>(find.byKey(const ValueKey('cursor-back')))
              .onPressed,
          isNotNull);

      // wait for both white and black move events;
      await tester.pump(const Duration(seconds: 2));

      // black move happened
      verify(() => mockSoundService.playMove()).called(1);
      expect(find.byKey(const Key('e7-blackpawn')), findsNothing);
      expect(find.byKey(const Key('e5-blackpawn')), findsOneWidget);

      _checkActiveClocks(tester, whiteActive: true, blackActive: false);

      // white plays a second move
      await makeMove(tester, boardPos, 'd2', 'd4');
      verify(() => mockSoundService.playMove()).called(1);
      expect(find.byKey(const Key('d4-whitepawn')), findsOneWidget);
      expect(find.byKey(const Key('d2-whitepawn')), findsNothing);

      _checkActiveClocks(tester, whiteActive: false, blackActive: true);

      // wait for both white and black move events;
      await tester.pump(const Duration(seconds: 2));

      // black 2nd move happened
      verify(() => mockSoundService.playMove()).called(1);
      expect(find.byKey(const Key('b8-blackknight')), findsNothing);
      expect(find.byKey(const Key('c6-blackknight')), findsOneWidget);

      _checkActiveClocks(tester, whiteActive: true, blackActive: false);

      // can go back in history
      await tester.tap(find.byKey(const Key('cursor-back')));
      await tester.pump();
      // cannot interact anymore
      expect(tester.widget<cg.Board>(find.byType(cg.Board)).interactableSide,
          cg.InteractableSide.none);

      // can go back 3 more times
      await tester.tap(find.byKey(const Key('cursor-back')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('cursor-back')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('cursor-back')));
      await tester.pump();
      // back at initial position
      expect(find.byKey(const Key('e2-whitepawn')), findsOneWidget);
      // cannot go backward anymore
      expect(
          tester
              .widget<IconButton>(find.byKey(const Key('cursor-back')))
              .onPressed,
          isNull);
      // go back to last position
      await tester.tap(find.byKey(const Key('cursor-last')));
      await tester.pump();
      // board is interactable again
      expect(tester.widget<cg.Board>(find.byType(cg.Board)).interactableSide,
          cg.InteractableSide.white);
    });

    testWidgets('reacts to abort event', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();
      final streamController = StreamController<String>();
      streamController.onListen = () {
        streamController.add(
            '{ "type": "gameFull", "id": "$gameIdTest", "speed": "blitz", "initialFen": "$kInitialFEN", "white": { "id": "white", "name": "White", "rating": 1405 }, "black": { "id": "black", "name": "Black", "rating": 1789 }, "state": { "type": "gameState", "moves": "", "wtime": 180000, "btime": 180000, "status": "started" }}');
      };

      when(() => mockClient.send(any(
              that: sameRequest(http.Request(
                  'GET',
                  Uri.parse(
                      '$kLichessHost/api/board/game/stream/$gameIdTest'))))))
          .thenAnswer((_) => mockHttpStream(streamController.stream));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
            apiClientProvider
                .overrideWithValue(ApiClient(mockLogger, mockClient)),
            soundServiceProvider.overrideWithValue(mockSoundService),
          ],
          child: buildTestApp(
            home: Consumer(builder: (context, ref, _) {
              return Scaffold(
                  body: BoardScreen(game: testGame, account: fakeUser));
            }),
          ),
        ),
      );

      // wait for stream loading
      await tester.pump(const Duration(milliseconds: 50));
      // board is interactable
      expect(tester.widget<cg.Board>(find.byType(cg.Board)).interactableSide,
          cg.InteractableSide.white);

      // trying to exit game will show an alert
      await tester.tap(find.widgetWithIcon(IconButton, Icons.arrow_back));
      await tester.pump();
      expect(
          find.text('Are you sure you want to quit the game?'), findsOneWidget);

      // cancel popup
      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pump();

      streamController.add(
          '{ "type": "gameState", "moves": "", "wtime": 180000, "btime": 180000, "status": "aborted" }');
      // wait for abort event
      await tester.pump(const Duration(milliseconds: 20));

      verify(() => mockSoundService.playDong()).called(1);
      // board is not interactable anymore
      expect(tester.widget<cg.Board>(find.byType(cg.Board)).interactableSide,
          cg.InteractableSide.none);

      // trying now to exit will not show the alert
      await tester.tap(find.widgetWithIcon(IconButton, Icons.arrow_back));
      await tester.pump();
      expect(
          find.text('Are you sure you want to quit the game?'), findsNothing);
    });
  });
}

// --

void _checkActiveClocks(WidgetTester tester,
    {required bool whiteActive, required bool blackActive}) {
  expect(
      tester
          .widget<CountdownClock>(find.descendant(
              of: find.byKey(const ValueKey('white-player')),
              matching: find.byType(CountdownClock)))
          .active,
      whiteActive);
  expect(
      tester
          .widget<CountdownClock>(find.descendant(
              of: find.byKey(const ValueKey('black-player')),
              matching: find.byType(CountdownClock)))
          .active,
      blackActive);
}

Future<void> makeMove(
    WidgetTester tester, Rect boardPos, String from, String to) async {
  await tester.tapAt(squareOffset(from, boardPos));
  await tester.pump();
  await tester.tapAt(squareOffset(to, boardPos));
  await tester.pump();
}

Offset squareOffset(cg.SquareId id, Rect boardPos,
    {cg.Side orientation = cg.Side.white,
    double squareSize = kTestScreenWidth / 8}) {
  final o = cg.Coord.fromSquareId(id).offset(orientation, squareSize);
  return Offset(o.dx + boardPos.left + squareSize / 2,
      o.dy + boardPos.top + squareSize / 2);
}

class FakeGameClient extends Fake implements http.Client {
  final streamController = StreamController<String>();
  final List<String> moves = [];
  Position<Chess> position = Chess.initial;
  int whiteTime = 180000;
  int blackTime = 180000;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (request.url.path.contains('game/stream')) {
      streamController.onListen = () {
        streamController.add(
            '{ "type": "gameFull", "id": "$gameIdTest", "speed": "blitz", "initialFen": "$kInitialFEN", "white": { "id": "white", "name": "White", "rating": 1405 }, "black": { "id": "black", "name": "Black", "rating": 1789 }, "state": { "type": "gameState", "moves": "", "wtime": 180000, "btime": 180000, "status": "started" }}');
      };

      return mockHttpStream(streamController.stream);
    } else if (request.method == 'POST' &&
        request.url.path.contains('/move/')) {
      // white move
      final move = request.url.path.substring(request.url.path.length - 4);
      moves.add(move);
      whiteTime -= 5000;
      position = position.play(Move.fromUci(move));
      _sendGameEvent(
          '{ "type": "gameState", "moves": "${moves.join(' ')}", "wtime": $whiteTime, "btime": $blackTime, "status": "started" }');

      // black response
      await Future<void>.delayed(const Duration(milliseconds: 500));
      switch (moves.length) {
        case 1:
          moves.add('e7e5');
          blackTime -= 3000;
          position = position.play(Move.fromUci('e7e5'));
          _sendGameEvent(
              '{ "type": "gameState", "moves": "${moves.join(' ')}", "wtime": $whiteTime, "btime": $blackTime, "status": "started" }');
          break;
        case 3:
          moves.add('b8c6');
          blackTime -= 6000;
          position = position.play(Move.fromUci('b8c6'));
          _sendGameEvent(
              '{ "type": "gameState", "moves": "${moves.join(' ')}", "wtime": $whiteTime, "btime": $blackTime, "status": "started" }');
          break;
        default:
          break;
      }
      return http.StreamedResponse(Stream.value(utf8.encode('ok')), 200);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  void close() {
    streamController.close();
  }

  void _sendGameEvent(String event) {
    Future<void>.delayed(const Duration(milliseconds: 10))
        .then((_) => streamController.add(event));
  }
}

const gameIdTest = 'rCRw1AuO';

const testGame = game.PlayableGame(
  id: GameId(gameIdTest),
  rated: false,
  speed: game.Speed.blitz,
  initialFen: kInitialFEN,
  orientation: Side.white,
  white: game.Player(name: 'White', id: 'white', rating: 1405),
  black: game.Player(name: 'Black', id: 'black', rating: 1789),
);
