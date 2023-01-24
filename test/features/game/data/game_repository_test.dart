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
{"id":"pew0Im0U","rated":false,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1673361618840,"lastMoveAt":1673361714573,"status":"mate","players":{"white":{"user":{"name":"maia1","title":"BOT","id":"maia1"},"rating":1429},"black":{"user":{"name":"veloce","patron":true,"id":"veloce"},"rating":1178}},"winner":"black","opening":{"eco":"C65","name":"Ruy Lopez: Berlin Defense","ply":6},"pgn":"[Event \\"Casual Blitz game\\"]\\n[Site \\"https://lichess.org/pew0Im0U\\"]\\n[Date \\"2023.01.10\\"]\\n[White \\"maia1\\"]\\n[Black \\"veloce\\"]\\n[Result \\"0-1\\"]\\n[UTCDate \\"2023.01.10\\"]\\n[UTCTime \\"14:40:18\\"]\\n[WhiteElo \\"1429\\"]\\n[BlackElo \\"1178\\"]\\n[WhiteTitle \\"BOT\\"]\\n[Variant \\"Standard\\"]\\n[TimeControl \\"180+2\\"]\\n[ECO \\"C65\\"]\\n[Opening \\"Ruy Lopez: Berlin Defense\\"]\\n[Termination \\"Normal\\"]\\n\\n1. e4 { [%clk 0:03:00] } 1... e5 { [%clk 0:03:00] } 2. Nf3 { [%clk 0:03:02] } 2... Nc6 { [%clk 0:03:00] } 3. Bb5 { [%clk 0:03:01] } 3... Nf6 { [%clk 0:02:58] } 4. Bxc6 { [%clk 0:03:03] } 4... dxc6 { [%clk 0:02:58] } 5. Nxe5 { [%clk 0:03:03] } 5... Bd6 { [%clk 0:02:55] } 6. Nf3 { [%clk 0:03:05] } 6... Bg4 { [%clk 0:02:55] } 7. O-O { [%clk 0:03:05] } 7... Nxe4 { [%clk 0:02:56] } 8. Re1 { [%clk 0:03:04] } 8... Bxf3 { [%clk 0:02:45] } 9. Qxf3 { [%clk 0:03:00] } 9... Qh4 { [%clk 0:02:35] } 10. Rxe4+ { [%clk 0:02:56] } 10... Qxe4 { [%clk 0:02:29] } 11. Qxe4+ { [%clk 0:02:58] } 11... Be7 { [%clk 0:02:28] } 12. d3 { [%clk 0:02:55] } 12... O-O-O { [%clk 0:02:28] } 13. Qxe7 { [%clk 0:02:55] } 13... Rhe8 { [%clk 0:02:28] } 14. Qxf7 { [%clk 0:02:54] } 14... Re1# { [%clk 0:02:26] } 0-1\\n\\n\\n","clock":{"initial":180,"increment":2,"totalTime":260}}
''';

      when(() => mockApiClient.get(
            Uri.parse('$kLichessHost/game/export/pew0Im0U?pgnInJson=true'),
            headers: {'Accept': 'application/json'},
          )).thenReturn(TaskEither.right(http.Response(testResponse, 200)));

      final result = await repo.getGameTask(const GameId('pew0Im0U')).run();

      expect(result.isRight(), true);
    });

    test('game with analysis', () async {
      const testResponse = '''
{"id":"3zfAoBZs","rated":false,"variant":"standard","speed":"bullet","perf":"bullet","createdAt":1674191740792,"lastMoveAt":1674191772185,"status":"outoftime","players":{"white":{"user":{"name":"penguingim1","title":"GM","patron":true,"id":"penguingim1"},"rating":3302,"analysis":{"inaccuracy":1,"mistake":1,"blunder":0,"acpl":30}},"black":{"user":{"name":"TackoFall","title":"FM","id":"tackofall"},"rating":2817,"analysis":{"inaccuracy":0,"mistake":0,"blunder":2,"acpl":95}}},"winner":"white","opening":{"eco":"A01","name":"Nimzo-Larsen Attack: Classical Variation","ply":2},"moves":"b3 d5 Bb2 Nc6 Nf3 Nf6 e3 g6 c4 Bg7 cxd5 Qxd5 Nc3 Qd8 h4 O-O h5 Nxh5 Rxh5 gxh5 Ng5 Bg4 Qc2 Re8 Qxh7+ Kf8 Nd5 e5 Ba3+ Ne7 Nf6","pgn":"[Event \\"Casual Bullet game\\"]\\n[Site \\"https://lichess.org/3zfAoBZs\\"]\\n[Date \\"2023.01.20\\"]\\n[White \\"penguingim1\\"]\\n[Black \\"TackoFall\\"]\\n[Result \\"1-0\\"]\\n[UTCDate \\"2023.01.20\\"]\\n[UTCTime \\"05:15:40\\"]\\n[WhiteElo \\"3302\\"]\\n[BlackElo \\"2817\\"]\\n[WhiteTitle \\"GM\\"]\\n[BlackTitle \\"FM\\"]\\n[Variant \\"Standard\\"]\\n[TimeControl \\"30+0\\"]\\n[ECO \\"A01\\"]\\n[Opening \\"Nimzo-Larsen Attack: Classical Variation\\"]\\n[Termination \\"Time forfeit\\"]\\n\\n1. b3 { [%eval 0.0] [%clk 0:00:30] } 1... d5 { [%eval 0.0] [%clk 0:00:30] } 2. Bb2 { [%eval 0.0] [%clk 0:00:30] } 2... Nc6 { [%eval 0.51] [%clk 0:00:30] } 3. Nf3 { [%eval 0.56] [%clk 0:00:30] } 3... Nf6 { [%eval 0.53] [%clk 0:00:30] } 4. e3 { [%eval 0.51] [%clk 0:00:30] } 4... g6 { [%eval 0.87] [%clk 0:00:30] } 5. c4 { [%eval 0.79] [%clk 0:00:29] } 5... Bg7 { [%eval 0.79] [%clk 0:00:30] } 6. cxd5 { [%eval 0.79] [%clk 0:00:29] } 6... Qxd5 { [%eval 0.85] [%clk 0:00:29] } 7. Nc3 { [%eval 0.69] [%clk 0:00:29] } 7... Qd8 { [%eval 0.74] [%clk 0:00:29] } 8. h4 { [%eval 0.2] [%clk 0:00:28] } 8... O-O { [%eval 0.27] [%clk 0:00:29] } 9. h5 { [%eval -0.57] [%clk 0:00:28] } 9... Nxh5 { [%eval -0.71] [%clk 0:00:29] } 10. Rxh5 { [%eval -2.16] [%clk 0:00:27] } 10... gxh5 { [%eval -1.99] [%clk 0:00:28] } 11. Ng5 { [%eval -2.59] [%clk 0:00:27] } 11... Bg4 { [%eval 2.23] [%clk 0:00:28] } 12. Qc2 { [%eval 2.08] [%clk 0:00:25] } 12... Re8 { [%eval 7.45] [%clk 0:00:24] } 13. Qxh7+ { [%eval 7.37] [%clk 0:00:24] } 13... Kf8 { [%eval 7.73] [%clk 0:00:23] } 14. Nd5 { [%eval 7.57] [%clk 0:00:16] } 14... e5 { [%eval 8.06] [%clk 0:00:23] } 15. Ba3+ { [%eval 8.02] [%clk 0:00:14] } 15... Ne7 { [%eval 10.02] [%clk 0:00:21] } 16. Nf6 { [%eval 9.45] [%clk 0:00:14] } 1-0\\n\\n\\n","analysis":[{"eval":0},{"eval":0},{"eval":0},{"eval":51},{"eval":56},{"eval":53},{"eval":51},{"eval":87},{"eval":79},{"eval":79},{"eval":79},{"eval":85},{"eval":69},{"eval":74},{"eval":20},{"eval":27},{"eval":-57,"best":"d2d4","variation":"d4","judgment":{"name":"Inaccuracy","comment":"Inaccuracy. d4 was best."}},{"eval":-71},{"eval":-216,"best":"d2d4","variation":"d4 e5 d5 Ne7 Qd2 Bd7 Rg1 e4 Ng5 Bg4 Ngxe4 Nxd5 Nxd5 Bxb2","judgment":{"name":"Mistake","comment":"Mistake. d4 was best."}},{"eval":-199},{"eval":-259},{"eval":223,"best":"c8f5","variation":"Bf5","judgment":{"name":"Blunder","comment":"Blunder. Bf5 was best."}},{"eval":208},{"eval":745,"best":"f7f5","variation":"f5 Bc4+ Kh8 Ne6 Qd7 Nxg7 Kxg7 f3 e5 d4 f4 O-O-O Bf5 e4","judgment":{"name":"Blunder","comment":"Blunder. f5 was best."}},{"eval":737},{"eval":773},{"eval":757},{"eval":806},{"eval":802},{"eval":1002},{"eval":945}],"clock":{"initial":30,"increment":0,"totalTime":30}}
''';

      when(() => mockApiClient.get(
            Uri.parse('$kLichessHost/game/export/3zfAoBZs?pgnInJson=true'),
            headers: {'Accept': 'application/json'},
          )).thenReturn(TaskEither.right(http.Response(testResponse, 200)));

      final result = await repo.getGameTask(const GameId('3zfAoBZs')).run();

      expect(result.isRight(), true);
    });

    test('threeCheck game', () async {
      const testResponse = '''
{"id":"1vdsvmxp","rated":true,"variant":"threeCheck","speed":"bullet","perf":"threeCheck","createdAt":1604194310939,"lastMoveAt":1604194361831,"status":"variantEnd","players":{"white":{"user":{"name":"Zhigalko_Sergei","title":"GM","patron":true,"id":"zhigalko_sergei"},"rating":2448,"ratingDiff":6,"analysis":{"inaccuracy":1,"mistake":1,"blunder":1,"acpl":75}},"black":{"user":{"name":"catask","id":"catask"},"rating":2485,"ratingDiff":-6,"analysis":{"inaccuracy":1,"mistake":0,"blunder":2,"acpl":115}}},"winner":"white","opening":{"eco":"B02","name":"Alekhine Defense: Scandinavian Variation, Geschev Gambit","ply":6},"moves":"e4 c6 Nc3 d5 exd5 Nf6 Nf3 e5 Bc4 Bd6 O-O O-O h3 e4 Kh1 exf3 Qxf3 cxd5 Nxd5 Nxd5 Bxd5 Nc6 Re1 Be6 Rxe6 fxe6 Bxe6+ Kh8 Qh5 h6 Qg6 Qf6 Qh7+ Kxh7 Bf5+","pgn":"[Event \\"Rated Three-check game\\"]\\n[Site \\"https://lichess.org/1vdsvmxp\\"]\\n[Date \\"2020.11.01\\"]\\n[White \\"Zhigalko_Sergei\\"]\\n[Black \\"catask\\"]\\n[Result \\"1-0\\"]\\n[UTCDate \\"2020.11.01\\"]\\n[UTCTime \\"01:31:50\\"]\\n[WhiteElo \\"2448\\"]\\n[BlackElo \\"2485\\"]\\n[WhiteRatingDiff \\"+6\\"]\\n[BlackRatingDiff \\"-6\\"]\\n[WhiteTitle \\"GM\\"]\\n[Variant \\"Three-check\\"]\\n[TimeControl \\"60+0\\"]\\n[ECO \\"B02\\"]\\n[Opening \\"Alekhine Defense: Scandinavian Variation, Geschev Gambit\\"]\\n[Termination \\"Normal\\"]\\n\\n1. e4 { [%eval 3.4] [%clk 0:01:00] } 1... c6 { [%eval 3.59] [%clk 0:01:00] } 2. Nc3 { [%eval 2.31] [%clk 0:01:00] } 2... d5 { [%eval 3.0] [%clk 0:00:59] } 3. exd5 { [%eval 2.62] [%clk 0:00:59] } 3... Nf6 { [%eval 2.86] [%clk 0:00:59] } 4. Nf3 { [%eval 1.84] [%clk 0:00:58] } 4... e5 { [%eval 2.35] [%clk 0:00:59] } 5. Bc4 { [%eval 1.93] [%clk 0:00:57] } 5... Bd6 { [%eval 2.43] [%clk 0:00:58] } 6. O-O { [%eval 2.69] [%clk 0:00:56] } 6... O-O { [%eval 2.19] [%clk 0:00:57] } 7. h3 { [%eval -3.58] [%clk 0:00:56] } 7... e4 { [%eval -3.76] [%clk 0:00:56] } 8. Kh1 { [%eval -3.86] [%clk 0:00:51] } 8... exf3 { [%eval -3.83] [%clk 0:00:53] } 9. Qxf3 { [%eval -4.05] [%clk 0:00:51] } 9... cxd5 { [%eval -3.63] [%clk 0:00:50] } 10. Nxd5 { [%eval -3.72] [%clk 0:00:51] } 10... Nxd5 { [%eval -3.69] [%clk 0:00:50] } 11. Bxd5 { [%eval -3.45] [%clk 0:00:51] } 11... Nc6 { [%eval -2.76] [%clk 0:00:49] } 12. Re1 { [%eval -5.07] [%clk 0:00:48] } 12... Be6 { [%eval -0.49] [%clk 0:00:48] } 13. Rxe6 { [%eval -1.7] [%clk 0:00:44] } 13... fxe6 { [%eval #7] [%clk 0:00:48] } 14. Bxe6+ { [%eval #6] [%clk 0:00:44] } 14... Kh8 { [%eval #6] [%clk 0:00:47] } 15. Qh5 { [%eval #5] [%clk 0:00:44] } 15... h6 { [%eval #3] [%clk 0:00:38] } 16. Qg6 { [%eval #2] [%clk 0:00:43] } 16... Qf6 { [%eval #2] [%clk 0:00:32] } 17. Qh7+ { [%eval #1] [%clk 0:00:42] } 17... Kxh7 { [%eval #1] [%clk 0:00:32] } 18. Bf5+ { [%clk 0:00:42] } 1-0\\n\\n\\n","analysis":[{"eval":340},{"eval":359},{"eval":231},{"eval":300,"best":"g8f6","variation":"Nf6 e5 d5 d4 Ne4 Bd3 Bf5 Nf3 e6 O-O","judgment":{"name":"Inaccuracy","comment":"Inaccuracy. Nf6 was best."}},{"eval":262},{"eval":286},{"eval":184,"best":"f1c4","variation":"Bc4 e6 dxe6 Bxe6 Bxe6 fxe6 Qe2 Qd7 Nf3 Bd6","judgment":{"name":"Inaccuracy","comment":"Inaccuracy. Bc4 was best."}},{"eval":235},{"eval":193},{"eval":243},{"eval":269},{"eval":219},{"eval":-358,"best":"d2d3","variation":"d3 Bg4 h3 e4 Nxe4 Bh2+ Kh1 Nxe4 dxe4 Qf6","judgment":{"name":"Blunder","comment":"Blunder. d3 was best."}},{"eval":-376},{"eval":-386},{"eval":-383},{"eval":-405},{"eval":-363},{"eval":-372},{"eval":-369},{"eval":-345},{"eval":-276},{"eval":-507,"best":"b2b3","variation":"b3 Be6","judgment":{"name":"Mistake","comment":"Mistake. b3 was best."}},{"eval":-49,"best":"c6e5","variation":"Ne5 Qh5","judgment":{"name":"Blunder","comment":"Blunder. Ne5 was best."}},{"eval":-170},{"mate":7,"best":"g8h8","variation":"Kh8 Rh6","judgment":{"name":"Blunder","comment":"Checkmate is now unavoidable. Kh8 was best."}},{"mate":6},{"mate":6},{"mate":5},{"mate":3},{"mate":2},{"mate":2},{"mate":1},{"mate":1}],"clock":{"initial":60,"increment":0,"totalTime":60}}
''';

      when(() => mockApiClient.get(
            Uri.parse('$kLichessHost/game/export/1vdsvmxp?pgnInJson=true'),
            headers: {'Accept': 'application/json'},
          )).thenReturn(TaskEither.right(http.Response(testResponse, 200)));

      final result = await repo.getGameTask(const GameId('1vdsvmxp')).run();

      expect(result.isRight(), true);

      result.match((_) => null, (game) {
        expect(game.steps[0].position is ThreeCheck, true);
      });
    });
  });
}
