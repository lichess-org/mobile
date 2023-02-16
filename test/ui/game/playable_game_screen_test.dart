import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dartchess/dartchess.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chessground/chessground.dart' as cg;

import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/widgets/countdown_clock.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/common/sound.dart';
import 'package:lichess_mobile/src/common/shared_preferences.dart';
import 'package:lichess_mobile/src/ui/game/playable_game_screen.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import '../../utils.dart';

class MockSoundService extends Mock implements SoundService {}

void main() {
  final mockSoundService = MockSoundService();

  group('PlayableGameScreen', () {
    testWidgets(
      'displays game info during loading state and update state after 1st gameFull event',
      (tester) async {
        final mockClient = MockClient.streaming((request, bodyStream) {
          if (request.url.path == '/api/board/game/stream/$gameIdTest') {
            return mockHttpStreamFromIterable([
              '{ "type": "gameFull", "id": "$gameIdTest", "speed": "blitz", "initialFen": "$kInitialFEN", "white": { "id": "white", "name": "White", "rating": 1405 }, "black": { "id": "black", "name": "Black", "rating": 1789 }, "state": { "type": "gameState", "moves": "", "wtime": 180000, "btime": 180000, "status": "started" }}'
            ]);
          }

          return mockStreamedResponse('', 404);
        });

        final app = await buildTestApp(
          tester,
          home: Consumer(
            builder: (context, ref, _) {
              return const PlayableGameScreen(game: testGame);
            },
          ),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              ...await makeDefaultProviderOverrides(),
              httpClientProvider.overrideWithValue(mockClient),
              soundServiceProvider.overrideWithValue(mockSoundService),
            ],
            child: app,
          ),
        );

        expect(find.byType(cg.Board), findsOneWidget);
        expect(find.byType(cg.PieceWidget), findsNWidgets(32));
        expect(find.widgetWithText(BoardPlayer, 'White'), findsOneWidget);
        expect(find.widgetWithText(BoardPlayer, 'Black'), findsOneWidget);
        expect(find.widgetWithText(BoardPlayer, '1405'), findsOneWidget);
        expect(find.widgetWithText(BoardPlayer, '1789'), findsOneWidget);
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
        expect(find.widgetWithText(BoardPlayer, 'White'), findsOneWidget);
        expect(find.widgetWithText(BoardPlayer, 'Black'), findsOneWidget);
        expect(find.widgetWithText(BoardPlayer, '1405'), findsOneWidget);
        expect(find.widgetWithText(BoardPlayer, '1789'), findsOneWidget);
        // clock is updated
        expect(find.widgetWithText(CountdownClock, '3:00'), findsNWidgets(2));

        // board interaction is now possible
        await tester.tap(find.byKey(const Key('e2-whitepawn')));
        await tester.pump();
        expect(find.byKey(const Key('e2-selected')), findsOneWidget);
      },
      variant: kPlatformVariant,
    );

    testWidgets(
      'play two moves',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        final sharedPreferences = await SharedPreferences.getInstance();

        final app = await buildTestApp(
          tester,
          home: Consumer(
            builder: (context, ref, _) {
              return const PlayableGameScreen(game: testGame);
            },
          ),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              ...await makeDefaultProviderOverrides(),
              sharedPreferencesProvider.overrideWithValue(sharedPreferences),
              httpClientProvider.overrideWithValue(FakeGameClient()),
              soundServiceProvider.overrideWithValue(mockSoundService),
            ],
            child: app,
          ),
        );

        await tester
            .pump(const Duration(milliseconds: 100)); // wait for stream loading

        final boardRect = tester.getRect(find.byType(cg.Board));

        // both clocks are not active first
        _checkActiveClocks(tester, whiteActive: false, blackActive: false);

        await makeMove(tester, boardRect, 'e2', 'e4');

        // move made
        verify(() => mockSoundService.playMove()).called(1);
        expect(find.byKey(const Key('e4-whitepawn')), findsOneWidget);
        expect(find.byKey(const Key('e2-whitepawn')), findsNothing);

        // can interact to make premoves
        await tester.tapAt(squareOffset('f1', boardRect));
        await tester.pump();
        expect(find.byKey(const Key('f1-selected')), findsOneWidget);
        // move cursor updated, can go backward
        expect(
          tester
              .widget<IconButton>(find.byKey(const ValueKey('cursor-first')))
              .onPressed,
          isNotNull,
        );
        expect(
          tester
              .widget<IconButton>(find.byKey(const ValueKey('cursor-back')))
              .onPressed,
          isNotNull,
        );

        // wait for both white and black move events;
        await tester.pump(const Duration(seconds: 2));

        // black move happened
        verify(() => mockSoundService.playMove()).called(1);
        expect(find.byKey(const Key('e7-blackpawn')), findsNothing);
        expect(find.byKey(const Key('e5-blackpawn')), findsOneWidget);

        _checkActiveClocks(tester, whiteActive: true, blackActive: false);

        // white plays a second move
        await makeMove(tester, boardRect, 'd2', 'd4');
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
        expect(
          tester.widget<cg.Board>(find.byType(cg.Board)).data.interactableSide,
          cg.InteractableSide.none,
        );

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
          isNull,
        );
        // go back to last position
        await tester.tap(find.byKey(const Key('cursor-last')));
        // need to wait for move list animation
        await tester.pumpAndSettle();
        // board is interactable again
        expect(
          tester.widget<cg.Board>(find.byType(cg.Board)).data.interactableSide,
          cg.InteractableSide.white,
        );
      },
      variant: kPlatformVariant,
    );

    testWidgets(
      'reacts to abort event',
      (tester) async {
        final streamController = StreamController<String>();
        streamController.onListen = () {
          streamController.add(
            '{ "type": "gameFull", "id": "$gameIdTest", "speed": "blitz", "initialFen": "$kInitialFEN", "white": { "id": "white", "name": "White", "rating": 1405 }, "black": { "id": "black", "name": "Black", "rating": 1789 }, "state": { "type": "gameState", "moves": "", "wtime": 180000, "btime": 180000, "status": "started" }}',
          );
        };

        final mockClient = MockClient.streaming((request, bodyStream) {
          if (request.url.path == '/api/board/game/stream/$gameIdTest') {
            return mockHttpStream(streamController.stream);
          }

          return mockStreamedResponse('', 404);
        });

        final app = await buildTestApp(
          tester,
          home: Consumer(
            builder: (context, ref, _) {
              return const PlayableGameScreen(game: testGame);
            },
          ),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              ...await makeDefaultProviderOverrides(),
              httpClientProvider.overrideWithValue(mockClient),
              soundServiceProvider.overrideWithValue(mockSoundService),
            ],
            child: app,
          ),
        );

        // wait for stream loading
        await tester.pump(const Duration(milliseconds: 50));
        // board is interactable
        expect(
          tester.widget<cg.Board>(find.byType(cg.Board)).data.interactableSide,
          cg.InteractableSide.white,
        );

        // trying to exit game will show an alert
        await tapBackButton(tester);
        await tester.pump();
        expect(
          find.text('Are you sure you want to quit the game?'),
          findsOneWidget,
        );

        // cancel popup
        await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
        await tester.pump();

        streamController.add(
          '{ "type": "gameState", "moves": "", "wtime": 180000, "btime": 180000, "status": "aborted" }',
        );
        // wait for abort event
        await tester.pump(const Duration(milliseconds: 20));

        verify(() => mockSoundService.playDong()).called(1);
        // board is not interactable anymore
        expect(
          tester.widget<cg.Board>(find.byType(cg.Board)).data.interactableSide,
          cg.InteractableSide.none,
        );

        // trying now to exit will not show the alert
        await tapBackButton(tester);
        // needs this to avoid timer pending
        await tester.pumpAndSettle();
        expect(
          find.text('Are you sure you want to quit the game?'),
          findsNothing,
        );
      },
      variant: kPlatformVariant,
    );
  });
}

// --

void _checkActiveClocks(
  WidgetTester tester, {
  required bool whiteActive,
  required bool blackActive,
}) {
  expect(
    tester
        .widget<CountdownClock>(
          find.descendant(
            of: find.byKey(const ValueKey('white-player')),
            matching: find.byType(CountdownClock),
          ),
        )
        .active,
    whiteActive,
  );
  expect(
    tester
        .widget<CountdownClock>(
          find.descendant(
            of: find.byKey(const ValueKey('black-player')),
            matching: find.byType(CountdownClock),
          ),
        )
        .active,
    blackActive,
  );
}

Future<void> makeMove(
  WidgetTester tester,
  Rect boardRect,
  String from,
  String to,
) async {
  await tester.tapAt(squareOffset(from, boardRect));
  await tester.pump();
  await tester.tapAt(squareOffset(to, boardRect));
  await tester.pump();
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
          '{ "type": "gameFull", "id": "$gameIdTest", "speed": "blitz", "initialFen": "$kInitialFEN", "white": { "id": "white", "name": "White", "rating": 1405 }, "black": { "id": "black", "name": "Black", "rating": 1789 }, "state": { "type": "gameState", "moves": "", "wtime": 180000, "btime": 180000, "status": "started" }}',
        );
      };

      return mockHttpStream(streamController.stream);
    } else if (request.method == 'POST' &&
        request.url.path.contains('/move/')) {
      // white move
      final move = request.url.path.substring(request.url.path.length - 4);
      moves.add(move);
      whiteTime -= 5000;
      position = position.play(Move.fromUci(move)!);
      _sendBoardEvent(
        '{ "type": "gameState", "moves": "${moves.join(' ')}", "wtime": $whiteTime, "btime": $blackTime, "status": "started" }',
      );

      // black response
      await Future<void>.delayed(const Duration(milliseconds: 500));
      switch (moves.length) {
        case 1:
          moves.add('e7e5');
          blackTime -= 3000;
          position = position.play(Move.fromUci('e7e5')!);
          _sendBoardEvent(
            '{ "type": "gameState", "moves": "${moves.join(' ')}", "wtime": $whiteTime, "btime": $blackTime, "status": "started" }',
          );
          break;
        case 3:
          moves.add('b8c6');
          blackTime -= 6000;
          position = position.play(Move.fromUci('b8c6')!);
          _sendBoardEvent(
            '{ "type": "gameState", "moves": "${moves.join(' ')}", "wtime": $whiteTime, "btime": $blackTime, "status": "started" }',
          );
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

  void _sendBoardEvent(String event) {
    Future<void>.delayed(const Duration(milliseconds: 10))
        .then((_) => streamController.add(event));
  }
}

const gameIdTest = 'rCRw1AuO';

const testGame = PlayableGame(
  id: GameId(gameIdTest),
  rated: false,
  speed: Speed.blitz,
  initialFen: kInitialFEN,
  orientation: Side.white,
  white: Player(name: 'White', id: UserId('white'), rating: 1405),
  black: Player(name: 'Black', id: UserId('black'), rating: 1789),
  variant: Variant.standard,
);
