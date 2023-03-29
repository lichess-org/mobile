import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/api_client.dart';

import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import '../../test_utils.dart';
import '../../test_container.dart';

void main() {
  Future<ProviderContainer> makeTestContainer(MockClient mockClient) async {
    return makeContainer(
      overrides: [
        httpClientProvider.overrideWith((ref) {
          return mockClient;
        }),
      ],
    );
  }

  group('PuzzleRepository', () {
    test('selectBatch', () async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/puzzle/batch/mix') {
          return mockResponse(
            '''
{"puzzles":[{"game":{"id":"PrlkCqOv","perf":{"key":"rapid","name":"Rapid"},"rated":true,"players":[{"userId":"silverjo","name":"silverjo (1777)","color":"white"},{"userId":"robyarchitetto","name":"Robyarchitetto (1742)","color":"black"}],"pgn":"e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2 Bb7 Bh6 d5 e5 d4 Bxg7 Kxg7 Qf4 Bxf3 Qxf3 dxc3 Nxc3 Nac6 Qf6+ Kg8 Rd1 Nd4 O-O c5 Ne4 Nef5 Rd2 Qxf6 Nxf6+ Kg7 Re1 h5 h3 Rad8 b4 Nh4 Re3 Nhf5 Re1 a5 bxc5 bxc5 Bc4 Ra8 Rb1 Nh4 Rdb2 Nc6 Rb7 Nxe5 Bxe6 Kxf6 Bd5 Nf5 R7b6+ Kg7 Bxa8 Rxa8 R6b3 Nd4 Rb7 Nxd3 Rd1 Ne2+ Kh2 Ndf4 Rdd7 Rf8 Ra7 c4 Rxa5 c3 Rc5 Ne6 Rc4 Ra8 a4 Rb8 a5 Rb2 a6 c2","clock":"5+8"},"puzzle":{"id":"20yWT","rating":1859,"plays":551,"initialPly":93,"solution":["a6a7","b2a2","c4c2","a2a7","d7a7"],"themes":["endgame","long","advantage","advancedPawn"]}},{"game":{"id":"0lwkiJbZ","perf":{"key":"classical","name":"Classical"},"rated":true,"players":[{"userId":"nirdosh","name":"nirdosh (2035)","color":"white"},{"userId":"burn_it_down","name":"burn_it_down (2139)","color":"black"}],"pgn":"d4 Nf6 Nf3 c5 e3 g6 Bd3 Bg7 c3 Qc7 O-O O-O Nbd2 d6 Qe2 Nbd7 e4 cxd4 cxd4 e5 dxe5 dxe5 b3 Nc5 Bb2 Nh5 g3 Bh3 Rfc1 Qd6 Bc4 Rac8 Bd5 Qb8 Ng5 Bd7 Ba3 b6 Rc2 h6 Ngf3 Rfe8 Rac1 Ne6 Nc4 Bb5 Qe3 Bxc4 Bxc4 Nd4 Nxd4 exd4 Qd3 Rcd8 f4 Nf6 e5 Ng4 Qxg6 Ne3 Bxf7+ Kh8 Rc7 Qa8 Qxg7+ Kxg7 Bd5+ Kg6 Bxa8 Rxa8 Rd7 Rad8 Rc6+ Kf5 Rcd6 Rxd7 Rxd7 Ke4 Bb2 Nc2 Kf2 d3 Bc1 Nd4 h3","clock":"15+15"},"puzzle":{"id":"7H5EV","rating":1852,"plays":410,"initialPly":84,"solution":["e8c8","d7d4","e4d4"],"themes":["endgame","short","advantage"]}},{"game":{"id":"eWGRX5AI","perf":{"key":"rapid","name":"Rapid"},"rated":true,"players":[{"userId":"sacalot","name":"sacalot (2151)","color":"white"},{"userId":"landitirana","name":"landitirana (1809)","color":"black"}],"pgn":"e4 e5 Nf3 Nc6 d4 exd4 Bc4 Nf6 O-O Nxe4 Re1 d5 Bxd5 Qxd5 Nc3 Qd8 Rxe4+ Be6 Nxd4 Nxd4 Rxd4 Qf6 Ne4 Qe5 f4 Qf5 Ng3 Qa5 Bd2 Qb6 Be3 Bc5 f5 Bd5 Rxd5 Bxe3+ Kh1 O-O Rd3 Rfe8 Qf3 Qxb2 Rf1 Bd4 Nh5 Bf6 Rb3 Qd4 Rxb7 Re3 Nxf6+ gxf6 Qf2 Rae8 Rxc7 Qe5 Rc4 Re1 Rf4 Qa1 h3","clock":"10+0"},"puzzle":{"id":"1qUth","rating":1556,"plays":2661,"initialPly":60,"solution":["e1f1","f2f1","e8e1","f1e1","a1e1"],"themes":["endgame","master","advantage","fork","long","pin"]}}]}
''',
            200,
          );
        }
        return mockResponse('', 404);
      });

      final container = await makeTestContainer(mockClient);
      final repo = container.read(puzzleRepositoryProvider);

      final result = await repo.selectBatch(nb: 3);

      expect(result.isValue, true);
    });

    test('selectBatch with glicko', () async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/puzzle/batch/mix') {
          return mockResponse(
            '''
{"puzzles":[{"game":{"id":"PrlkCqOv","perf":{"key":"rapid","name":"Rapid"},"rated":true,"players":[{"userId":"silverjo","name":"silverjo (1777)","color":"white"},{"userId":"robyarchitetto","name":"Robyarchitetto (1742)","color":"black"}],"pgn":"e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2 Bb7 Bh6 d5 e5 d4 Bxg7 Kxg7 Qf4 Bxf3 Qxf3 dxc3 Nxc3 Nac6 Qf6+ Kg8 Rd1 Nd4 O-O c5 Ne4 Nef5 Rd2 Qxf6 Nxf6+ Kg7 Re1 h5 h3 Rad8 b4 Nh4 Re3 Nhf5 Re1 a5 bxc5 bxc5 Bc4 Ra8 Rb1 Nh4 Rdb2 Nc6 Rb7 Nxe5 Bxe6 Kxf6 Bd5 Nf5 R7b6+ Kg7 Bxa8 Rxa8 R6b3 Nd4 Rb7 Nxd3 Rd1 Ne2+ Kh2 Ndf4 Rdd7 Rf8 Ra7 c4 Rxa5 c3 Rc5 Ne6 Rc4 Ra8 a4 Rb8 a5 Rb2 a6 c2","clock":"5+8"},"puzzle":{"id":"20yWT","rating":1859,"plays":551,"initialPly":93,"solution":["a6a7","b2a2","c4c2","a2a7","d7a7"],"themes":["endgame","long","advantage","advancedPawn"]}}],"glicko":{"rating":1834.54,"deviation":23.45}}
''',
            200,
          );
        }
        return mockResponse('', 404);
      });

      final container = await makeTestContainer(mockClient);
      final repo = container.read(puzzleRepositoryProvider);

      final result = await repo.selectBatch(nb: 1);

      expect(result.isValue, true);
    });

    test('selectBatch with rounds', () async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/puzzle/batch/mix') {
          return mockResponse(
            '''
{"puzzles":[{"game":{"id":"PrlkCqOv","perf":{"key":"rapid","name":"Rapid"},"rated":true,"players":[{"userId":"silverjo","name":"silverjo (1777)","color":"white"},{"userId":"robyarchitetto","name":"Robyarchitetto (1742)","color":"black"}],"pgn":"e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2 Bb7 Bh6 d5 e5 d4 Bxg7 Kxg7 Qf4 Bxf3 Qxf3 dxc3 Nxc3 Nac6 Qf6+ Kg8 Rd1 Nd4 O-O c5 Ne4 Nef5 Rd2 Qxf6 Nxf6+ Kg7 Re1 h5 h3 Rad8 b4 Nh4 Re3 Nhf5 Re1 a5 bxc5 bxc5 Bc4 Ra8 Rb1 Nh4 Rdb2 Nc6 Rb7 Nxe5 Bxe6 Kxf6 Bd5 Nf5 R7b6+ Kg7 Bxa8 Rxa8 R6b3 Nd4 Rb7 Nxd3 Rd1 Ne2+ Kh2 Ndf4 Rdd7 Rf8 Ra7 c4 Rxa5 c3 Rc5 Ne6 Rc4 Ra8 a4 Rb8 a5 Rb2 a6 c2","clock":"5+8"},"puzzle":{"id":"20yWT","rating":1859,"plays":551,"initialPly":93,"solution":["a6a7","b2a2","c4c2","a2a7","d7a7"],"themes":["endgame","long","advantage","advancedPawn"]}}],"glicko":{"rating":1834.54,"deviation":23.45}, "rounds": [{"id": "07jQK", "ratingDiff": 10, "win": true}, {"id": "06jOK", "ratingDiff": -40, "win": false}]}
''',
            200,
          );
        }
        return mockResponse('', 404);
      });
      final container = await makeTestContainer(mockClient);
      final repo = container.read(puzzleRepositoryProvider);

      final result = await repo.selectBatch(nb: 1);

      expect(result.isValue, true);
    });

    test('streak', () async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/streak') {
          return mockResponse(
            '''
{"game":{"id":"3dwjUYP0","perf":{"key":"rapid","name":"Rapid"},"rated":true,"players":[{"userId":"suresh","name":"Suresh (1716)","color":"white"},{"userId":"yulia","name":"Yulia (1765)","color":"black"}],"pgn":"d4 Nf6 Nf3 e6 c4 d5 cxd5 Bb4+ Nc3 Nxd5 Bd2 c6 a3 Bxc3 Bxc3 Nd7 Ne5 Qc7 e3 O-O Bd3 Nxc3 bxc3 Nxe5 dxe5 Qxe5 O-O Qxc3 a4 b6 Rc1 Qf6 Rxc6 Bb7 Rc4 Rad8 Rd4 Qg5 g3 Rxd4 exd4 Qd5 f3 Rd8 Rf2 g6 Be4 Qd7 Bxb7 Qxb7 Kg2 Qd7 Rd2 e5 dxe5","clock":"10+0"},"puzzle":{"id":"9afDa","rating":642,"plays":13675,"initialPly":54,"solution":["d7d2","d1d2","d8d2"],"themes":["endgame","crushing","short"]},"angle":{"key":"mix","name":"Puzzle themes","desc":"A bit of everything. You don't know what to expect, so you remain ready for anything! Just like in real games."},"streak":"9afDa 4V5gW 3mslj 41adQ 2tu7D 9RkvX 0vy7p A4v8U 5ZOBZ 193w0 98fRK CeonU 7yLlT 5RSB1 1tHFC 0Vsh7 7VFdg Dw0Rn EL08H 4dfgu 9ZxSP DUs0d 55MLt 9kmiT 0H0mL 0tBRV 7J6hk 0TjRQ 4G3KC DVlXY 1160r B8UHS 9NmPL 70ujM DJc5M BwkrY 94ynq D9wc6 41QGW 5sDnM 6xRVq 0EkpQ 7nksF 35Umd 0lJjY BrA7Z 8iHjv 5ypqy 4seCY 1bKuj 27svg 6K2S9 5lR21 9WveK DseMX C9m8Q 0K2CK 73mQX Bey7R CFniS 2NMq3 1eKTu 6131w 9m4mG 1H3Oi 9FxX2 4zRod 1C05H 9iEBH 21pIt 95dod 01tg7 47p37 1sK7x 0nSaW BWD8D C6WCD 9h38Q AoWyN CPdp8 ATUTK EFWL2 7GrRe 6W1OR 538Mf CH2cU An8P5 9LrrA 1cIQP B56EI 32pBl 34nq9 1aS2z 3qxyU 4NGY7 9GCq2 C43lx 2W8WA 1bnwL 4I8D1 Dc1u5 BG3VT 3pC4h C5tQJ 3rM5l 6KF3m 6Xnj5 EUX2q 1qiVv 2UTkb 7AtYx CbRCh 5xs9Y BlYuY BGFSj E7AIl 5keIv 1431G 7KYgv 68F2M 16IRi 8cNr9 8g79l BBM7N CmgIo 6zoOr D6Zsx 20mtz"}
''',
            200,
          );
        }
        return mockResponse('', 404);
      });

      final container = await makeTestContainer(mockClient);
      final repo = container.read(puzzleRepositoryProvider);
      final result = await repo.streak();

      expect(result.isValue, true);
    });

    test('puzzle dashboard', () async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/puzzle/dashboard/30') {
          return mockResponse(
            '''
      {"days":30,"global":{"nb":196,"firstWins":107,"replayWins":0,"puzzleRatingAvg":1607,"performance":1653},"themes":{"middlegame":{"theme":"Middlegame","results":{"nb":97,"firstWins":51,"replayWins":0,"puzzleRatingAvg":1608,"performance":1634}},"endgame":{"theme":"Endgame","results":{"nb":81,"firstWins":48,"replayWins":0,"puzzleRatingAvg":1604,"performance":1697}}}}
      ''',
            200,
          );
        }
        return mockResponse('', 404);
      });

      final container = await makeTestContainer(mockClient);
      final repo = container.read(puzzleRepositoryProvider);
      final result = await repo.puzzleDashboard(30);

      expect(result.isValue, true);
    });
  });
}
