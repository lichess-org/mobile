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

  group('GameRepository.getUserGamesTask', () {
    test('json read, full example', () async {
      const response = '''
{"id":"rfBxF2P5","rated":false,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1672074461465,"lastMoveAt":1672074683485,"status":"mate","players":{"white":{"user":{"name":"testUser","patron":true,"id":"testUser"},"rating":1178},"black":{"user":{"name":"maia1","title":"BOT","id":"maia1"},"rating":1397}},"winner":"white","moves":"e4 e5 Nf3 d6 Bc4 Nf6 Nc3 Nc6 O-O Be7 d3 O-O Nh4 Bg4 Qd2 Nd4 Nf5 Bxf5 exf5 Nxf5 Nd5 Nxd5 Bxd5 c6 Be4 Nd4 c3 Ne6 d4 exd4 cxd4 d5 Bc2 Bg5 Qd3 Bxc1 Qxh7#","clock":{"initial":300,"increment":3,"totalTime":420}}
{"id":"msAKIkqp","rated":false,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1671791341158,"lastMoveAt":1671791589063,"status":"resign","players":{"white":{"user":{"name":"maia1","title":"BOT","id":"maia1"},"rating":1399},"black":{"user":{"name":"testUser","patron":true,"id":"testUser"},"rating":1178}},"winner":"white","moves":"e4 e5 Nf3 Nc6 Bb5 Nf6 Bxc6 dxc6 Nxe5 Qd4 Nf3 Qxe4+ Qe2 Bc5 Qxe4+ Nxe4 O-O O-O d3 Nf6 Bg5 Nh5 Nc3 Bg4 Ne5 f5 Nd7 Rf7 Nxc5 Raf8 Nxb7 f4 f3 Bc8 Nc5 Rf5 N5e4 Nf6 Bxf6 gxf6 Rae1","clock":{"initial":300,"increment":3,"totalTime":420}}
{"id":"7Jxi9mBF","rated":false,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1671100908073,"lastMoveAt":1671101322211,"status":"mate","players":{"white":{"user":{"name":"testUser","patron":true,"id":"testUser"},"rating":1178},"black":{"user":{"name":"maia1","title":"BOT","id":"maia1"},"rating":1410}},"winner":"white","moves":"e4 e5 Nf3 Nc6 Nc3 Nf6 Bb5 d6 O-O Bd7 Bxc6 Bxc6 d4 exd4 Nxd4 Bxe4 Nxe4 Nxe4 Re1 d5 f3 Bc5 fxe4 dxe4 Rxe4+ Be7 Bg5 f6 Bf4 O-O Ne6 Qxd1+ Rxd1 Rfe8 Bxc7 Rac8 c4 Bc5+ Kh1 b6 Bd6 Bxd6 Rxd6 f5 Rf4 g6 g3 Kf7 Ng5+ Kg7 Rd7+ Kh6 h4 Re1+ Kg2 Re2+ Kf3 Rxb2 Rxh7#","clock":{"initial":300,"increment":3,"totalTime":420}}
''';

      when(() => mockApiClient.get(
            Uri.parse('$kLichessHost/api/games/user/testUser?max=10'),
            headers: {'Accept': 'application/x-ndjson'},
          )).thenReturn(TaskEither.right(http.Response(response, 200)));

      final result = await repo.getUserGamesTask('testUser').run();

      expect(result.isRight(), true);
    });
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

      final result = await repo.getGameTask(gameIdTest).run();

      expect(result.isRight(), true);
    });
  });
}
