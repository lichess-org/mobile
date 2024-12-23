import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:lichess_mobile/src/model/game/game_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../test_container.dart';
import '../../test_helpers.dart';

void main() {
  group('GameRepository.getRecentGames', () {
    test('json read, full example', () async {
      const response = '''
{"id":"Huk88k3D","rated":false,"variant":"fromPosition","speed":"blitz","perf":"blitz","createdAt":1673716450321,"lastMoveAt":1673716450321,"status":"noStart","players":{"white":{"user":{"name":"MightyNanook","id":"mightynanook"},"rating":1116,"provisional":true},"black":{"user":{"name":"Thibault","patron":true,"id":"thibault"},"rating":1772}},"initialFen":"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - - 0 1","winner":"black","tournament":"ZZQ9tunK","clock":{"initial":300,"increment":0,"totalTime":300},"lastFen":"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - - 0 1"}
{"id":"g2bzFol8","rated":true,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1673553626465,"lastMoveAt":1673553936657,"status":"resign","players":{"white":{"user":{"name":"SchallUndRausch","id":"schallundrausch"},"rating":1751,"ratingDiff":-5},"black":{"user":{"name":"Thibault","patron":true,"id":"thibault"},"rating":1767,"ratingDiff":5}},"winner":"black","clock":{"initial":180,"increment":2,"totalTime":260},"lastFen":"r7/pppk4/4p1B1/3pP3/6Pp/q1P1P1nP/P1QK1r2/R5R1 w - - 1 1"}
{"id":"9WLmxmiB","rated":true,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1673553299064,"lastMoveAt":1673553615438,"status":"resign","players":{"white":{"user":{"name":"Dr-Alaakour","id":"dr-alaakour"},"rating":1806,"ratingDiff":5},"black":{"user":{"name":"Thibault","patron":true,"id":"thibault"},"rating":1772,"ratingDiff":-5}},"winner":"white","clock":{"initial":180,"increment":0,"totalTime":180},"lastFen":"2b1Q1k1/p1r4p/1p2p1p1/3pN3/2qP4/P4R2/1P3PPP/4R1K1 b - - 0 1"}
''';

      final mockClient = MockClient((request) {
        if (request.url.path == '/api/games/user/testUser') {
          return mockResponse(response, 200);
        }
        return mockResponse('', 404);
      });

      final container = await lichessClientContainer(mockClient);
      final client = container.read(lichessClientProvider);

      final repo = GameRepository(client);

      final result = await repo.getUserGames(const UserId('testUser'));
      expect(result, isA<IList<LightArchivedGameWithPov>>());
      expect(result.length, 3);
      expect(result[0].game.id, const GameId('Huk88k3D'));
    });
  });

  group('GameRepository.getGamesByIds', () {
    test('json read, full example', () async {
      const response = '''
{"id":"Huk88k3D","rated":false,"variant":"fromPosition","speed":"blitz","perf":"blitz","createdAt":1673716450321,"lastMoveAt":1673716450321,"status":"noStart","players":{"white":{"user":{"name":"MightyNanook","id":"mightynanook"},"rating":1116,"provisional":true},"black":{"user":{"name":"Thibault","patron":true,"id":"thibault"},"rating":1772}},"initialFen":"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - - 0 1","winner":"black","tournament":"ZZQ9tunK","clock":{"initial":300,"increment":0,"totalTime":300},"lastFen":"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - - 0 1"}
{"id":"g2bzFol8","rated":true,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1673553626465,"lastMoveAt":1673553936657,"status":"resign","players":{"white":{"user":{"name":"SchallUndRausch","id":"schallundrausch"},"rating":1751,"ratingDiff":-5},"black":{"user":{"name":"Thibault","patron":true,"id":"thibault"},"rating":1767,"ratingDiff":5}},"winner":"black","clock":{"initial":180,"increment":2,"totalTime":260},"lastFen":"r7/pppk4/4p1B1/3pP3/6Pp/q1P1P1nP/P1QK1r2/R5R1 w - - 1 1"}
{"id":"9WLmxmiB","rated":true,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1673553299064,"lastMoveAt":1673553615438,"status":"resign","players":{"white":{"user":{"name":"Dr-Alaakour","id":"dr-alaakour"},"rating":1806,"ratingDiff":5},"black":{"user":{"name":"Thibault","patron":true,"id":"thibault"},"rating":1772,"ratingDiff":-5}},"winner":"white","clock":{"initial":180,"increment":0,"totalTime":180},"lastFen":"2b1Q1k1/p1r4p/1p2p1p1/3pN3/2qP4/P4R2/1P3PPP/4R1K1 b - - 0 1"}
''';

      final ids = ISet(const {GameId('Huk88k3D'), GameId('g2bzFol8'), GameId('9WLmxmiB')});

      final mockClient = MockClient((request) {
        if (request.url.path == '/api/games/export/_ids') {
          return mockResponse(response, 200);
        }
        return mockResponse('', 404);
      });

      final container = await lichessClientContainer(mockClient);
      final client = container.read(lichessClientProvider);
      final repo = GameRepository(client);
      final result = await repo.getGamesByIds(ids);

      expect(result, isA<IList<LightArchivedGame>>());
      expect(result.length, 3);
      expect(result[0].id, const GameId('Huk88k3D'));
    });
  });

  group('GameRepository.getGame', () {
    test('game with clocks', () async {
      const testResponse = '''
{"id":"qVChCOTc","rated":false,"source":"lobby","variant":"standard","speed":"blitz","perf":"blitz","createdAt":1673443822389,"lastMoveAt":1673444036416,"status":"mate","players":{"white":{"aiLevel":1},"black":{"user":{"name":"veloce","patron":true,"id":"veloce"},"rating":1435,"provisional":true}},"winner":"black","opening":{"eco":"C20","name":"King's Pawn Game: Wayward Queen Attack, Kiddie Countergambit","ply":4},"moves":"e4 e5 Qh5 Nf6 Qxe5+ Be7 b3 d6 Qb5+ Bd7 Qxb7 Nc6 Ba3 Rb8 Qa6 Nxe4 Bb2 O-O Nc3 Nb4 Nf3 Nxa6 Nd5 Nb4 Nxe7+ Qxe7 Nd4 Qf6 f4 Qe7 Ke2 Ng3+ Kd1 Nxh1 Bc4 Nf2+ Kc1 Qe1#","clocks":[18003,18003,17915,17627,17771,16691,17667,16243,17475,15459,17355,14779,17155,13795,16915,13267,14771,11955,14451,10995,14339,10203,13899,9099,12427,8379,12003,7547,11787,6691,11355,6091,11147,5763,10851,5099,10635,4657],"clock":{"initial":180,"increment":0,"totalTime":180},"division":{"middle":18,"end":42}}
''';

      final mockClient = MockClient((request) {
        if (request.url.path == '/game/export/qVChCOTc') {
          return mockResponse(testResponse, 200);
        }
        return mockResponse('', 404);
      });

      final container = await lichessClientContainer(mockClient);
      final client = container.read(lichessClientProvider);
      final repo = GameRepository(client);
      final game = await repo.getGame(const GameId('qVChCOTc'));

      expect(game, isA<ArchivedGame>());

      expect(game.data.id, const GameId('qVChCOTc'));
      expect(game.meta.opening?.eco, 'C20');
    });

    test('threeCheck game', () async {
      const testResponse = '''
{"id":"1vdsvmxp","rated":true,"source":"lobby","variant":"threeCheck","speed":"bullet","perf":"threeCheck","createdAt":1604194310939,"lastMoveAt":1604194361831,"status":"variantEnd","players":{"white":{"user":{"name":"Zhigalko_Sergei","title":"GM","patron":true,"id":"zhigalko_sergei"},"rating":2448,"ratingDiff":6,"analysis":{"inaccuracy":1,"mistake":1,"blunder":1,"acpl":75}},"black":{"user":{"name":"catask","id":"catask"},"rating":2485,"ratingDiff":-6,"analysis":{"inaccuracy":1,"mistake":0,"blunder":2,"acpl":115}}},"winner":"white","opening":{"eco":"B02","name":"Alekhine Defense: Scandinavian Variation, Geschev Gambit","ply":6},"moves":"e4 c6 Nc3 d5 exd5 Nf6 Nf3 e5 Bc4 Bd6 O-O O-O h3 e4 Kh1 exf3 Qxf3 cxd5 Nxd5 Nxd5 Bxd5 Nc6 Re1 Be6 Rxe6 fxe6 Bxe6+ Kh8 Qh5 h6 Qg6 Qf6 Qh7+ Kxh7 Bf5+","analysis":[{"eval":340},{"eval":359},{"eval":231},{"eval":300,"best":"g8f6","variation":"Nf6 e5 d5 d4 Ne4 Bd3 Bf5 Nf3 e6 O-O","judgment":{"name":"Inaccuracy","comment":"Inaccuracy. Nf6 was best."}},{"eval":262},{"eval":286},{"eval":184,"best":"f1c4","variation":"Bc4 e6 dxe6 Bxe6 Bxe6 fxe6 Qe2 Qd7 Nf3 Bd6","judgment":{"name":"Inaccuracy","comment":"Inaccuracy. Bc4 was best."}},{"eval":235},{"eval":193},{"eval":243},{"eval":269},{"eval":219},{"eval":-358,"best":"d2d3","variation":"d3 Bg4 h3 e4 Nxe4 Bh2+ Kh1 Nxe4 dxe4 Qf6","judgment":{"name":"Blunder","comment":"Blunder. d3 was best."}},{"eval":-376},{"eval":-386},{"eval":-383},{"eval":-405},{"eval":-363},{"eval":-372},{"eval":-369},{"eval":-345},{"eval":-276},{"eval":-507,"best":"b2b3","variation":"b3 Be6","judgment":{"name":"Mistake","comment":"Mistake. b3 was best."}},{"eval":-49,"best":"c6e5","variation":"Ne5 Qh5","judgment":{"name":"Blunder","comment":"Blunder. Ne5 was best."}},{"eval":-170},{"mate":7,"best":"g8h8","variation":"Kh8 Rh6","judgment":{"name":"Blunder","comment":"Checkmate is now unavoidable. Kh8 was best."}},{"mate":6},{"mate":6},{"mate":5},{"mate":3},{"mate":2},{"mate":2},{"mate":1},{"mate":1}],"clock":{"initial":60,"increment":0,"totalTime":60},"division":{"middle":18,"end":42}}
''';

      final mockClient = MockClient((request) {
        if (request.url.path == '/game/export/1vdsvmxp') {
          return mockResponse(testResponse, 200);
        }
        return mockResponse('', 404);
      });

      final container = await lichessClientContainer(mockClient);
      final client = container.read(lichessClientProvider);
      final repo = GameRepository(client);
      final result = await repo.getGame(const GameId('1vdsvmxp'));

      expect(result, isA<ArchivedGame>());
      expect(result.steps[0].position is ThreeCheck, true);
    });
  });
}
