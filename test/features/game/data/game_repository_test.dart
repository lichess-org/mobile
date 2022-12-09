import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/http.dart';
import 'package:lichess_mobile/src/features/game/data/game_repository.dart';
import 'package:lichess_mobile/src/features/game/data/game_event.dart';
import 'package:lichess_mobile/src/features/game/data/api_event.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockLogger extends Mock implements Logger {}

const gameIdTest = GameId('5IrD6Gzz');

void main() {
  final mockLogger = MockLogger();
  final mockApiClient = MockApiClient();
  final repo = GameRepository(mockLogger, apiClient: mockApiClient);

  setUpAll(() {
    reset(mockApiClient);
  });

  group('GameRepository.events', () {
    test('can read all supported types of events', () async {
      when(() =>
              mockApiClient.stream(Uri.parse('$kLichessHost/api/stream/event')))
          .thenAnswer((_) async {
        return http.StreamedResponse(
            Stream.fromIterable([
              utf8.encode('''{
  "type": "gameStart",
  "game": {
    "gameId": "rCRw1AuO",
    "fullId": "rCRw1AuOvonq",
    "color": "black",
    "fen": "r1bqkbnr/pppp2pp/2n1pp2/8/8/3PP3/PPPB1PPP/RN1QKBNR w KQkq - 2 4",
    "hasMoved": true,
    "isMyTurn": false,
    "lastMove": "b8c6",
    "opponent": {
      "id": "philippe",
      "rating": 1790,
      "username": "Philippe"
    },
    "perf": "correspondence",
    "rated": false,
    "secondsLeft": 1209600,
    "source": "friend",
    "speed": "correspondence",
    "variant": {
      "key": "standard",
      "name": "Standard"
    },
    "compat": {
      "bot": false,
      "board": true
    }
  }
}'''),
            ]),
            200);
      });

      final stream = repo.events();

      expect(
          stream,
          emitsInOrder([
            predicate((value) => value is GameStartEvent),
          ]));
    });

    test('filter out unsupported types of events', () async {
      when(() =>
              mockApiClient.stream(Uri.parse('$kLichessHost/api/stream/event')))
          .thenAnswer((_) async {
        return http.StreamedResponse(
            Stream.fromIterable([
              utf8.encode('''{
  "type": "challenge",
  "challenge": {
    "id": "7pGLxJ4F",
    "url": "https://lichess.org/VU0nyvsW",
    "status": "created",
    "compat": {
      "bot": false,
      "board": true
    },
    "challenger": {
      "id": "lovlas",
      "name": "Lovlas",
      "title": "IM",
      "rating": 2506,
      "patron": true,
      "online": true,
      "lag": 24
    },
    "destUser": {
      "id": "thibot",
      "name": "thibot",
      "title": null,
      "rating": 1500,
      "provisional": true,
      "online": true,
      "lag": 45
    },
    "variant": {
      "key": "standard",
      "name": "Standard",
      "short": "Std"
    },
    "rated": true,
    "timeControl": {
      "type": "clock",
      "limit": 300,
      "increment": 25,
      "show": "5+25"
    },
    "color": "random",
    "speed": "rapid",
    "perf": {
      "icon": "#",
      "name": "Rapid"
    }
  }
}'''),
            ]),
            200);
      });

      final stream = repo.events();

      expect(stream, emitsInOrder([emitsDone]));
    });
  });

  group('GameRepository.gameStateEvents', () {
    test('can read all supported types of events', () async {
      when(() => mockApiClient.stream(
              Uri.parse('$kLichessHost/api/board/game/stream/$gameIdTest')))
          .thenAnswer((_) async {
        return http.StreamedResponse(
            Stream.fromIterable([
              utf8.encode(
                  '{ "type": "gameFull", "id": "$gameIdTest", "initialFen": "startPos", "state": { "type": "gameState", "moves": "e2e4 c7c5 f2f4 d7d6 g1f3", "wtime": 7598040, "btime": 8395220, "status": "started" }}'),
              utf8.encode(
                  '{ "type": "gameState", "moves": "e2e4 c7c5 f2f4 d7d6 g1f3 b8c6", "wtime": 7598140, "btime": 8395220, "status": "started" }'),
              utf8.encode(
                  '{ "type": "gameState", "moves": "e2e4 c7c5 f2f4 d7d6 g1f3 b8c6 f1c4", "wtime": 7598140, "btime": 8398220, "status": "started" }'),
            ]),
            200);
      });

      final stream = repo.gameStateEvents(gameIdTest);

      expect(
          stream,
          emitsInOrder([
            predicate((value) => value is GameFullEvent),
            predicate((value) => value is GameStateEvent),
            predicate((value) => value is GameStateEvent),
          ]));
    });

    test('filter out unsupported types of events', () async {
      when(() => mockApiClient.stream(
              Uri.parse('$kLichessHost/api/board/game/stream/$gameIdTest')))
          .thenAnswer((_) async {
        return http.StreamedResponse(
            Stream.fromIterable([
              utf8.encode(
                  '{ "type": "gameState", "moves": "e2e4 c7c5 f2f4 d7d6 g1f3 b8c6", "wtime": 7598140, "btime": 8395220, "status": "started" }'),
              utf8.encode(
                  '{ "type": "chatLine", "username": "testUser", "message": "oops" }'),
            ]),
            200);
      });

      final stream = repo.gameStateEvents(gameIdTest);

      expect(
          stream,
          emitsInOrder([
            predicate((value) => value is GameStateEvent),
          ]));
    });
  });
}
