import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/http.dart';
import 'package:lichess_mobile/src/features/game/data/game_repository.dart';
import 'package:lichess_mobile/src/features/game/data/game_event.dart';
import 'package:lichess_mobile/src/features/game/data/api_event.dart';
import '../../../utils.dart';

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
          .thenAnswer((_) => mockHttpStreamFromIterable([
                '''
{
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
}
'''
              ]));

      expect(
          repo.events(),
          emitsInOrder([
            predicate((value) => value is GameStartEvent),
          ]));
    });

    test('filter out unsupported types of events', () async {
      when(() =>
              mockApiClient.stream(Uri.parse('$kLichessHost/api/stream/event')))
          .thenAnswer((_) => mockHttpStreamFromIterable([
                '{ "type": "challenge", "challenge": {}}',
              ]));

      expect(repo.events(), emitsInOrder([emitsDone]));
    });
  });

  group('GameRepository.gameStateEvents', () {
    test('can read all supported types of events', () async {
      when(() => mockApiClient.stream(
              Uri.parse('$kLichessHost/api/board/game/stream/$gameIdTest')))
          .thenAnswer((_) => mockHttpStreamFromIterable([
                '{ "type": "gameFull", "id": "$gameIdTest", "initialFen": "startPos", "state": { "type": "gameState", "moves": "e2e4 c7c5 f2f4 d7d6 g1f3", "wtime": 7598040, "btime": 8395220, "status": "started" }}',
                '{ "type": "gameState", "moves": "e2e4 c7c5 f2f4 d7d6 g1f3 b8c6", "wtime": 7598140, "btime": 8395220, "status": "started" }',
                '{ "type": "gameState", "moves": "e2e4 c7c5 f2f4 d7d6 g1f3 b8c6 f1c4", "wtime": 7598140, "btime": 8398220, "status": "started" }',
              ]));

      expect(
          repo.gameStateEvents(gameIdTest),
          emitsInOrder([
            predicate((value) => value is GameFullEvent),
            predicate((value) => value is GameStateEvent),
            predicate((value) => value is GameStateEvent),
          ]));
    });

    test('filter out unsupported types of events', () async {
      when(() => mockApiClient.stream(
              Uri.parse('$kLichessHost/api/board/game/stream/$gameIdTest')))
          .thenAnswer((_) => mockHttpStreamFromIterable([
                '{ "type": "gameState", "moves": "e2e4 c7c5 f2f4 d7d6 g1f3 b8c6", "wtime": 7598140, "btime": 8395220, "status": "started" }',
                '{ "type": "chatLine", "username": "testUser", "message": "oops" }',
              ]));

      expect(
          repo.gameStateEvents(gameIdTest),
          emitsInOrder([
            predicate((value) => value is GameStateEvent),
          ]));
    });
  });

  group('GameRepository.getGame', () {
    test('can construct a game from json', () async {
      const testResponse = '''
{
  "id": "5IrD6Gzz",
  "rated": true,
  "variant": "standard",
  "speed": "blitz",
  "perf": "blitz",
  "createdAt": 1514505150384,
  "lastMoveAt": 1514505592843,
  "status": "draw",
  "players": {
    "white": {
      "user": {
        "name": "Lance5500",
        "title": "LM",
        "patron": true,
        "id": "lance5500"
      },
      "rating": 2389,
      "ratingDiff": 4
    },
    "black": {
      "user": {
        "name": "TryingHard87",
        "id": "tryinghard87"
      },
      "rating": 2498,
      "ratingDiff": -4
    }
  },
  "opening": {
    "eco": "D31",
    "name": "Semi-Slav Defense: Marshall Gambit",
    "ply": 7
  },
  "moves": "d4 d5 c4 c6 Nc3 e6 e4 Nd7 exd5 cxd5 cxd5 exd5 Nxd5 Nb6 Bb5+ Bd7 Qe2+ Ne7 Nxb6 Qxb6 Bxd7+ Kxd7 Nf3 Qa6 Ne5+ Ke8 Qf3 f6 Nd3 Qc6 Qe2 Kf7 O-O Kg8 Bd2 Re8 Rac1 Nf5 Be3 Qe6 Rfe1 g6 b3 Bd6 Qd2 Kf7 Bf4 Qd7 Bxd6 Nxd6 Nc5 Rxe1+ Rxe1 Qc6 f3 Re8 Rxe8 Nxe8 Kf2 Nc7 Qb4 b6 Qc4+ Nd5 Nd3 Qe6 Nb4 Ne7 Qxe6+ Kxe6 Ke3 Kd6 g3 h6 Kd3 h5 Nc2 Kd5 a3 Nc6 Ne3+ Kd6 h4 Nd8 g4 Ne6 Ke4 Ng7 Nc4+ Ke6 d5+ Kd7 a4 g5 gxh5 Nxh5 hxg5 fxg5 Kf5 Nf4 Ne3 Nh3 Kg4 Ng1 Nc4 Kc7 Nd2 Kd6 Kxg5 Kxd5 f4 Nh3+ Kg4 Nf2+ Kf3 Nd3 Ke3 Nc5 Kf3 Ke6 Ke3 Kf5 Kd4 Ne6+ Kc4",
  "clock": {
    "initial": 300,
    "increment": 3,
    "totalTime": 420
  }
}
''';

      when(() => mockApiClient
              .get(Uri.parse('$kLichessHost/game/export/$gameIdTest')))
          .thenReturn(TaskEither.right(http.Response(testResponse, 200)));

      final result = await repo.getGame(gameIdTest).run();
      print(result);

      expect(result.isRight(), true);
    });
  });
}
