import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:logging/logging.dart';
import 'package:dartchess/dartchess.dart';

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
{"id":"Huk88k3D","rated":false,"variant":"fromPosition","speed":"blitz","perf":"blitz","createdAt":1673716450321,"lastMoveAt":1673716450321,"status":"noStart","players":{"white":{"user":{"name":"MightyNanook","id":"mightynanook"},"rating":1116,"provisional":true},"black":{"user":{"name":"Thibault","patron":true,"id":"thibault"},"rating":1772}},"initialFen":"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - - 0 1","winner":"black","tournament":"ZZQ9tunK","clock":{"initial":300,"increment":0,"totalTime":300},"lastFen":"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - - 0 1"}
{"id":"g2bzFol8","rated":true,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1673553626465,"lastMoveAt":1673553936657,"status":"resign","players":{"white":{"user":{"name":"SchallUndRausch","id":"schallundrausch"},"rating":1751,"ratingDiff":-5},"black":{"user":{"name":"Thibault","patron":true,"id":"thibault"},"rating":1767,"ratingDiff":5}},"winner":"black","clock":{"initial":180,"increment":2,"totalTime":260},"lastFen":"r7/pppk4/4p1B1/3pP3/6Pp/q1P1P1nP/P1QK1r2/R5R1 w - - 1 1"}
{"id":"9WLmxmiB","rated":true,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1673553299064,"lastMoveAt":1673553615438,"status":"resign","players":{"white":{"user":{"name":"Dr-Alaakour","id":"dr-alaakour"},"rating":1806,"ratingDiff":5},"black":{"user":{"name":"Thibault","patron":true,"id":"thibault"},"rating":1772,"ratingDiff":-5}},"winner":"white","clock":{"initial":180,"increment":0,"totalTime":180},"lastFen":"2b1Q1k1/p1r4p/1p2p1p1/3pN3/2qP4/P4R2/1P3PPP/4R1K1 b - - 0 1"}
''';

      when(() => mockApiClient.get(
            Uri.parse(
                '$kLichessHost/api/games/user/testUser?max=10&moves=false&lastFen=true'),
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
    test('minimal example game', () async {
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

    test('game with analysis', () async {
      const testResponse = '''
{"id":"NchH5KBj","rated":true,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1647115605598,"lastMoveAt":1647116025236,"status":"resign","players":{"white":{"user":{"name":"matyizom","id":"matyizom"},"rating":1224,"ratingDiff":10,"analysis":{"inaccuracy":3,"mistake":2,"blunder":0,"acpl":60}},"black":{"user":{"name":"veloce","patron":true,"id":"veloce"},"rating":1147,"ratingDiff":-8,"analysis":{"inaccuracy":3,"mistake":1,"blunder":1,"acpl":105}}},"winner":"white","opening":{"eco":"B01","name":"Scandinavian Defense: Main Line, Mieses Variation","ply":8},"moves":"e4 d5 exd5 Qxd5 Nc3 Qa5 d4 Nf6 Nf3 c5 a3 e6 Bg5 Be7 Bb5+ Bd7 Bxd7+ Nbxd7 O-O O-O Ne5 cxd4 Nxd7 Nxd7 Bxe7 Rfe8 Bb4 Qf5 Qxd4 e5 Qe3 Qxc2 Ne4 Qxb2 Ng5 f6 Qh3 h6 Nf3 a5 Qxd7 Red8 Qxb7 axb4 Qxb4 Qxa3 Rxa3","analysis":[{"eval":28},{"eval":82,"best":"e7e5","variation":"e5 Nf3 Nc6 Bb5 Nf6 d3 Bc5 c3 O-O O-O"},{"eval":66},{"eval":80},{"eval":71},{"eval":63},{"eval":75},{"eval":60},{"eval":80},{"eval":136,"best":"g7g6","variation":"g6 Bc4 Bg7 O-O O-O Bd2 c5 Nd5 Qd8 Nxf6+"},{"eval":53,"best":"d4d5","variation":"d5 g6 Bc4 Bg7 O-O a6 Bd2 Qd8 a4 Nbd7","judgment":{"name":"Inaccuracy","comment":"Inaccuracy. d5 was best."}},{"eval":63},{"eval":-16,"best":"c1f4","variation":"Bf4 Nc6 Bb5 cxd4 Nxd4 Bd7 Nxc6 Bxc6 Bxc6+ bxc6","judgment":{"name":"Inaccuracy","comment":"Inaccuracy. Bf4 was best."}},{"eval":131,"best":"f6e4","variation":"Ne4","judgment":{"name":"Mistake","comment":"Mistake. Ne4 was best."}},{"eval":-10,"best":"d4c5","variation":"dxc5","judgment":{"name":"Mistake","comment":"Mistake. dxc5 was best."}},{"eval":-27},{"eval":-20},{"eval":-31},{"eval":-57},{"eval":20,"best":"c5d4","variation":"cxd4 Qxd4","judgment":{"name":"Inaccuracy","comment":"Inaccuracy. cxd4 was best."}},{"eval":-138,"best":"d4d5","variation":"d5 exd5 Nxd5 Bd8 Ne3 Qa6 Re1 Re8 Qd2 Ne5 Nxe5 Rxe5 Bxf6 Bxf6","judgment":{"name":"Mistake","comment":"Mistake. d5 was best."}},{"eval":-91},{"eval":-107},{"eval":538,"best":"a5g5","variation":"Qxg5 Qxd4","judgment":{"name":"Blunder","comment":"Blunder. Qxg5 was best."}},{"eval":506},{"eval":515},{"eval":515},{"eval":745,"best":"a5b6","variation":"Qb6 Ne4","judgment":{"name":"Inaccuracy","comment":"Inaccuracy. Qb6 was best."}},{"eval":739},{"eval":792},{"eval":753},{"eval":800},{"eval":745},{"eval":858},{"eval":575,"best":"a1d1","variation":"Rad1 Qd4","judgment":{"name":"Inaccuracy","comment":"Inaccuracy. Rad1 was best."}},{"eval":730},{"eval":685},{"eval":737},{"eval":621},{"eval":645},{"eval":578},{"eval":977,"best":"a5b4","variation":"axb4 axb4 Qxa1 Qxe8+ Rxe8 Rxa1 Rc8 Kf1 Rc4 Rb1 Kf7 Nd2 Rd4 Ke2","judgment":{"name":"Inaccuracy","comment":"Inaccuracy. axb4 was best."}},{"eval":700},{"eval":716},{"eval":730},{"eval":1054},{"eval":1014}],"clock":{"initial":180,"increment":2,"totalTime":260}}
''';

      const gameId = GameId('NchH5KBj');

      when(() =>
              mockApiClient.get(Uri.parse('$kLichessHost/game/export/$gameId')))
          .thenReturn(TaskEither.right(http.Response(testResponse, 200)));

      final result = await repo.getGameTask(gameId).run();

      expect(result.isRight(), true);
    });

    test('threeCheck game', () async {
      const testResponse = '''
{"id":"1vdsvmxp","rated":true,"variant":"threeCheck","speed":"bullet","perf":"threeCheck","createdAt":1604194310939,"lastMoveAt":1604194361831,"status":"variantEnd","players":{"white":{"user":{"name":"Zhigalko_Sergei","title":"GM","patron":true,"id":"zhigalko_sergei"},"rating":2448,"ratingDiff":6,"analysis":{"inaccuracy":1,"mistake":1,"blunder":1,"acpl":75}},"black":{"user":{"name":"catask","id":"catask"},"rating":2485,"ratingDiff":-6,"analysis":{"inaccuracy":1,"mistake":0,"blunder":2,"acpl":115}}},"winner":"white","opening":{"eco":"B02","name":"Alekhine Defense: Scandinavian Variation, Geschev Gambit","ply":6},"moves":"e4 c6 Nc3 d5 exd5 Nf6 Nf3 e5 Bc4 Bd6 O-O O-O h3 e4 Kh1 exf3 Qxf3 cxd5 Nxd5 Nxd5 Bxd5 Nc6 Re1 Be6 Rxe6 fxe6 Bxe6+ Kh8 Qh5 h6 Qg6 Qf6 Qh7+ Kxh7 Bf5+","analysis":[{"eval":340},{"eval":359},{"eval":231},{"eval":300,"best":"g8f6","variation":"Nf6 e5 d5 d4 Ne4 Bd3 Bf5 Nf3 e6 O-O","judgment":{"name":"Inaccuracy","comment":"Inaccuracy. Nf6 was best."}},{"eval":262},{"eval":286},{"eval":184,"best":"f1c4","variation":"Bc4 e6 dxe6 Bxe6 Bxe6 fxe6 Qe2 Qd7 Nf3 Bd6","judgment":{"name":"Inaccuracy","comment":"Inaccuracy. Bc4 was best."}},{"eval":235},{"eval":193},{"eval":243},{"eval":269},{"eval":219},{"eval":-358,"best":"d2d3","variation":"d3 Bg4 h3 e4 Nxe4 Bh2+ Kh1 Nxe4 dxe4 Qf6","judgment":{"name":"Blunder","comment":"Blunder. d3 was best."}},{"eval":-376},{"eval":-386},{"eval":-383},{"eval":-405},{"eval":-363},{"eval":-372},{"eval":-369},{"eval":-345},{"eval":-276},{"eval":-507,"best":"b2b3","variation":"b3 Be6","judgment":{"name":"Mistake","comment":"Mistake. b3 was best."}},{"eval":-49,"best":"c6e5","variation":"Ne5 Qh5","judgment":{"name":"Blunder","comment":"Blunder. Ne5 was best."}},{"eval":-170},{"mate":7,"best":"g8h8","variation":"Kh8 Rh6","judgment":{"name":"Blunder","comment":"Checkmate is now unavoidable. Kh8 was best."}},{"mate":6},{"mate":6},{"mate":5},{"mate":3},{"mate":2},{"mate":2},{"mate":1},{"mate":1}],"clock":{"initial":60,"increment":0,"totalTime":60}}
''';

      const gameId = GameId('1vdsvmxp');

      when(() =>
              mockApiClient.get(Uri.parse('$kLichessHost/game/export/$gameId')))
          .thenReturn(TaskEither.right(http.Response(testResponse, 200)));

      final result = await repo.getGameTask(gameId).run();

      expect(result.isRight(), true);

      result.match((_) => null, (game) {
        expect(game.steps[0].position is ThreeCheck, true);
      });
    });
  });
}
