import 'dart:io';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_batch_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../test_container.dart';
import '../../test_helpers.dart';

void main() {
  Future<ProviderContainer> makeTestContainer(MockClient mockClient) {
    return makeContainer(
      overrides: [
        lichessClientProvider.overrideWith((ref) {
          return LichessClient(mockClient, ref);
        }),
      ],
    );
  }

  group('PuzzleService', () {
    test('will download data if local queue is empty', () async {
      int nbReq = 0;
      final mockClient = MockClient((request) {
        nbReq++;
        if (request.url.path == '/api/puzzle/batch/mix') {
          return mockResponse(batchOf3, 200);
        }
        return mockResponse('', 404);
      });

      final container = await makeTestContainer(mockClient);
      final storage = await container.read(puzzleBatchStorageProvider.future);
      final service = await container.read(puzzleServiceFactoryProvider)(queueLength: 3);

      final next = await service.nextPuzzle(userId: null);
      expect(nbReq, equals(1));
      expect(next?.puzzle.puzzle.id, equals(const PuzzleId('20yWT')));
      final data = await storage.fetch(userId: null);
      expect(data?.solved, equals(IList(const [])));
      expect(data?.unsolved.length, equals(3));
    });

    test('will not download data if local queue is full', () async {
      int nbReq = 0;
      final mockClient = MockClient((request) {
        nbReq++;
        if (request.url.path == '/api/puzzle/batch/mix') {
          return mockResponse('{"puzzles":[]}', 200);
        }
        return mockResponse('', 404);
      });

      final container = await makeTestContainer(mockClient);
      final storage = await container.read(puzzleBatchStorageProvider.future);
      final service = await container.read(puzzleServiceFactoryProvider)(queueLength: 1);

      await storage.save(userId: null, data: _makePuzzleBatch(unsolved: [const PuzzleId('pId3')]));

      final next = await service.nextPuzzle(userId: null);
      expect(nbReq, equals(0));
      expect(next?.puzzle.puzzle.id, equals(const PuzzleId('pId3')));
      final data = await storage.fetch(userId: null);
      expect(data?.unsolved.length, equals(1));
    });

    test('will fetch puzzle deficit if local queue is not full', () async {
      int nbReq = 0;
      final mockClient = MockClient((request) {
        nbReq++;
        if (request.url.path == '/api/puzzle/batch/mix') {
          // will fetch only 1 since queueLength is 2
          return mockResponse(batchOf1, 200);
        }
        return mockResponse('', 404);
      });

      final container = await makeTestContainer(mockClient);
      final storage = await container.read(puzzleBatchStorageProvider.future);
      final service = await container.read(puzzleServiceFactoryProvider)(queueLength: 2);
      await storage.save(userId: null, data: _makePuzzleBatch(unsolved: [const PuzzleId('pId3')]));

      final next = await service.nextPuzzle(userId: null);
      expect(next?.puzzle.puzzle.id, equals(const PuzzleId('pId3')));
      expect(nbReq, equals(1));
      final data = await storage.fetch(userId: null);
      expect(data?.unsolved.length, equals(2));
    });

    test('will post solve request even if puzzle deficit is 0 (if userId is not null)', () async {
      int nbGETReq = 0;
      int nbPOSTReq = 0;
      final mockClient = MockClient((request) {
        if (request.method == 'GET') {
          nbGETReq++;
        } else if (request.method == 'POST') {
          nbPOSTReq++;
        }
        if (request.url.path == '/api/puzzle/batch/mix') {
          return mockResponse(emptyBatch, 200);
        }
        return mockResponse('', 404);
      });

      final container = await makeTestContainer(mockClient);
      final storage = await container.read(puzzleBatchStorageProvider.future);
      // queueLength is 1, so we will not fetch any puzzle
      final service = await container.read(puzzleServiceFactoryProvider)(queueLength: 1);
      await storage.save(
        userId: const UserId('testUserId'),
        data: _makePuzzleBatch(
          unsolved: [const PuzzleId('pId3')],
          solved: [const PuzzleSolution(id: PuzzleId('soAw'), win: true, rated: true)],
        ),
      );

      final next = await service.nextPuzzle(userId: const UserId('testUserId'));
      expect(nbPOSTReq, equals(1), reason: '1 POST request should be made to save solved puzzle');
      expect(nbGETReq, equals(0), reason: 'No GET request should be made to fetch puzzles');
      expect(next?.puzzle.puzzle.id, equals(const PuzzleId('pId3')));
      final data = await storage.fetch(userId: const UserId('testUserId'));
      expect(data?.unsolved.length, equals(1));
      expect(data?.solved.length, equals(0));
    });

    test('nextPuzzle will always get the first puzzle of unsolved queue', () async {
      int nbReq = 0;
      final mockClient = MockClient((request) {
        nbReq++;
        return mockResponse('', 404);
      });

      final container = await makeTestContainer(mockClient);
      final storage = await container.read(puzzleBatchStorageProvider.future);
      final service = await container.read(puzzleServiceFactoryProvider)(queueLength: 1);
      await storage.save(userId: null, data: _makePuzzleBatch(unsolved: [const PuzzleId('pId3')]));

      expect(nbReq, equals(0));
      final next = await service.nextPuzzle(userId: null);
      expect(next?.puzzle.puzzle.id, equals(const PuzzleId('pId3')));
      final data = await storage.fetch(userId: null);
      expect(data?.unsolved.length, equals(1));

      final next2 = await service.nextPuzzle(userId: null);
      expect(next2?.puzzle.puzzle.id, equals(const PuzzleId('pId3')));
      final data2 = await storage.fetch(userId: null);
      expect(data2?.unsolved.length, equals(1));
    });

    test('nextPuzzle returns null is unsolved queue is empty and is offline', () async {
      final mockClient = MockClient((request) {
        throw const SocketException('offline');
      });

      final container = await makeTestContainer(mockClient);
      final service = await container.read(puzzleServiceFactoryProvider)(queueLength: 1);

      final nextPuzzle = await service.nextPuzzle(userId: null);

      expect(nextPuzzle, isNull);
    });

    test('different batch is saved per userId', () async {
      int nbReq = 0;
      final mockClient = MockClient((request) {
        nbReq++;
        if (request.url.path == '/api/puzzle/batch/mix') {
          return mockResponse(batchOf1, 200);
        }
        return mockResponse('', 404);
      });

      final container = await makeTestContainer(mockClient);
      final storage = await container.read(puzzleBatchStorageProvider.future);
      final service = await container.read(puzzleServiceFactoryProvider)(queueLength: 1);
      await storage.save(userId: null, data: _makePuzzleBatch(unsolved: [const PuzzleId('pId3')]));

      final next = await service.nextPuzzle(userId: const UserId('testUserId'));
      expect(next?.puzzle.puzzle.id, equals(const PuzzleId('20yWT')));
      expect(nbReq, equals(1));

      final data = await storage.fetch(userId: const UserId('testUserId'));
      expect(data?.unsolved.length, equals(1));
    });

    test('different batch is saved per angle', () async {
      int nbReq = 0;
      final mockClient = MockClient((request) {
        nbReq++;
        if (request.url.path == '/api/puzzle/batch/opening') {
          return mockResponse(batchOf1, 200);
        }
        return mockResponse('', 404);
      });

      final container = await makeTestContainer(mockClient);
      final storage = await container.read(puzzleBatchStorageProvider.future);
      final service = await container.read(puzzleServiceFactoryProvider)(queueLength: 1);
      await storage.save(userId: null, data: _makePuzzleBatch(unsolved: [const PuzzleId('pId3')]));

      final next = await service.nextPuzzle(
        angle: const PuzzleTheme(PuzzleThemeKey.opening),
        userId: null,
      );
      expect(next?.puzzle.puzzle.id, equals(const PuzzleId('20yWT')));
      expect(nbReq, equals(1));

      final data = await storage.fetch(
        userId: null,
        angle: const PuzzleTheme(PuzzleThemeKey.opening),
      );
      expect(data?.unsolved.length, equals(1));
    });

    test('solve puzzle when online, no userId', () async {
      int nbReq = 0;
      final mockClient = MockClient((request) {
        nbReq++;
        if (request.url.path == '/api/puzzle/batch/mix') {
          return mockResponse(batchOf1, 200);
        }
        return mockResponse('', 404);
      });

      final container = await makeTestContainer(mockClient);
      final storage = await container.read(puzzleBatchStorageProvider.future);
      final service = await container.read(puzzleServiceFactoryProvider)(queueLength: 1);
      await storage.save(userId: null, data: _makePuzzleBatch(unsolved: [const PuzzleId('pId3')]));

      final next = await service.solve(
        puzzle: samplePuzzle,
        solution: const PuzzleSolution(id: PuzzleId('pId3'), win: true, rated: true),
        userId: null,
      );

      expect(nbReq, equals(1));

      final data = await storage.fetch(userId: null);
      expect(data?.solved, equals(IList(const [])));
      expect(data?.unsolved[0].puzzle.id, equals(const PuzzleId('20yWT')));
      expect(next?.puzzle.puzzle.id, equals(const PuzzleId('20yWT')));
      expect(next?.glicko, isNull);
      expect(next?.rounds, isNull);
    });

    test('solve puzzle when online, with a userId', () async {
      int nbReq = 0;
      final mockClient = MockClient((request) {
        nbReq++;
        if (request.method == 'POST' &&
            request.url.path == '/api/puzzle/batch/mix' &&
            request.body == '{"solutions":[{"id":"pId3","win":true,"rated":true}]}') {
          return mockResponse(
            '''{"puzzles":[{"game":{"id":"PrlkCqOv","perf":{"key":"rapid","name":"Rapid"},"rated":true,"players":[{"userId":"silverjo","name":"silverjo (1777)","color":"white"},{"userId":"robyarchitetto","name":"Robyarchitetto (1742)","color":"black"}],"pgn":"e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2 Bb7 Bh6 d5 e5 d4 Bxg7 Kxg7 Qf4 Bxf3 Qxf3 dxc3 Nxc3 Nac6 Qf6+ Kg8 Rd1 Nd4 O-O c5 Ne4 Nef5 Rd2 Qxf6 Nxf6+ Kg7 Re1 h5 h3 Rad8 b4 Nh4 Re3 Nhf5 Re1 a5 bxc5 bxc5 Bc4 Ra8 Rb1 Nh4 Rdb2 Nc6 Rb7 Nxe5 Bxe6 Kxf6 Bd5 Nf5 R7b6+ Kg7 Bxa8 Rxa8 R6b3 Nd4 Rb7 Nxd3 Rd1 Ne2+ Kh2 Ndf4 Rdd7 Rf8 Ra7 c4 Rxa5 c3 Rc5 Ne6 Rc4 Ra8 a4 Rb8 a5 Rb2 a6 c2","clock":"5+8"},"puzzle":{"id":"20yWT","rating":1859,"plays":551,"initialPly":93,"solution":["a6a7","b2a2","c4c2","a2a7","d7a7"],"themes":["endgame","long","advantage","advancedPawn"]}}], "glicko":{"rating":1834.54,"deviation":23.45},"rounds":[{"id": "pId3","ratingDiff": 10,"win": true}]}''',
            200,
          );
        }
        return mockResponse('', 404);
      });

      final container = await makeTestContainer(mockClient);
      final storage = await container.read(puzzleBatchStorageProvider.future);
      final service = await container.read(puzzleServiceFactoryProvider)(queueLength: 1);
      await storage.save(
        userId: const UserId('testUserId'),
        data: _makePuzzleBatch(unsolved: [const PuzzleId('pId3')]),
      );

      final next = await service.solve(
        puzzle: samplePuzzle,
        solution: const PuzzleSolution(id: PuzzleId('pId3'), win: true, rated: true),
        userId: const UserId('testUserId'),
      );

      expect(nbReq, equals(1));

      final data = await storage.fetch(userId: const UserId('testUserId'));
      expect(data?.solved, equals(IList<PuzzleSolution>(const [])));
      expect(data?.unsolved[0].puzzle.id, equals(const PuzzleId('20yWT')));
      expect(next?.puzzle.puzzle.id, equals(const PuzzleId('20yWT')));
      expect(next?.glicko?.rating, equals(1834.54));
      expect(next?.glicko?.deviation, equals(23.45));
      expect(
        next?.rounds,
        equals(IList(const [PuzzleRound(id: PuzzleId('pId3'), ratingDiff: 10, win: true)])),
      );
    });

    test('solve puzzle when offline', () async {
      int nbReq = 0;
      final mockClient = MockClient((request) {
        nbReq++;
        throw const SocketException('offline');
      });

      final container = await makeTestContainer(mockClient);
      final storage = await container.read(puzzleBatchStorageProvider.future);
      final service = await container.read(puzzleServiceFactoryProvider)(queueLength: 2);
      await storage.save(
        userId: const UserId('testUserId'),
        data: _makePuzzleBatch(unsolved: [const PuzzleId('pId3'), const PuzzleId('pId4')]),
      );

      const solution = PuzzleSolution(id: PuzzleId('pId3'), win: true, rated: true);

      final next = await service.solve(
        puzzle: samplePuzzle,
        solution: solution,
        userId: const UserId('testUserId'),
      );

      expect(nbReq, equals(1));

      final data = await storage.fetch(userId: const UserId('testUserId'));
      expect(data?.solved, equals(IList(const [solution])));
      expect(data?.unsolved.length, equals(1));
      expect(next?.puzzle.puzzle.id, equals(const PuzzleId('pId4')));
    });

    test('resetBatch', () async {
      int nbReq = 0;
      final mockClient = MockClient((request) {
        nbReq++;
        if (request.url.path == '/api/puzzle/batch/mix') {
          return mockResponse(batchOf2, 200);
        }
        return mockResponse('', 404);
      });

      final container = await makeTestContainer(mockClient);
      final storage = await container.read(puzzleBatchStorageProvider.future);
      final service = await container.read(puzzleServiceFactoryProvider)(queueLength: 2);

      await storage.save(
        userId: const UserId('testUserId'),
        data: _makePuzzleBatch(unsolved: [const PuzzleId('pId3'), const PuzzleId('pId4')]),
      );

      final next = await service.resetBatch(userId: const UserId('testUserId'));

      expect(nbReq, equals(1));
      final data = await storage.fetch(userId: const UserId('testUserId'));
      expect(next?.puzzle.puzzle.id, equals(const PuzzleId('20yWT')));
      expect(data?.solved, equals(IList(const [])));
      expect(data?.unsolved.length, equals(2));
      expect(data?.unsolved[0].puzzle.id, equals(const PuzzleId('20yWT')));
      expect(data?.unsolved[1].puzzle.id, equals(const PuzzleId('7H5EV')));
    });
  });
}

const emptyBatch = '''
{"puzzles":[], "glicko":{"rating":1834.54,"deviation":23.45}}
''';

const batchOf3 = '''
{"puzzles":[{"game":{"id":"PrlkCqOv","perf":{"key":"rapid","name":"Rapid"},"rated":true,"players":[{"userId":"silverjo","name":"silverjo (1777)","color":"white"},{"userId":"robyarchitetto","name":"Robyarchitetto (1742)","color":"black"}],"pgn":"e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2 Bb7 Bh6 d5 e5 d4 Bxg7 Kxg7 Qf4 Bxf3 Qxf3 dxc3 Nxc3 Nac6 Qf6+ Kg8 Rd1 Nd4 O-O c5 Ne4 Nef5 Rd2 Qxf6 Nxf6+ Kg7 Re1 h5 h3 Rad8 b4 Nh4 Re3 Nhf5 Re1 a5 bxc5 bxc5 Bc4 Ra8 Rb1 Nh4 Rdb2 Nc6 Rb7 Nxe5 Bxe6 Kxf6 Bd5 Nf5 R7b6+ Kg7 Bxa8 Rxa8 R6b3 Nd4 Rb7 Nxd3 Rd1 Ne2+ Kh2 Ndf4 Rdd7 Rf8 Ra7 c4 Rxa5 c3 Rc5 Ne6 Rc4 Ra8 a4 Rb8 a5 Rb2 a6 c2","clock":"5+8"},"puzzle":{"id":"20yWT","rating":1859,"plays":551,"initialPly":93,"solution":["a6a7","b2a2","c4c2","a2a7","d7a7"],"themes":["endgame","long","advantage","advancedPawn"]}},{"game":{"id":"0lwkiJbZ","perf":{"key":"classical","name":"Classical"},"rated":true,"players":[{"userId":"nirdosh","name":"nirdosh (2035)","color":"white"},{"userId":"burn_it_down","name":"burn_it_down (2139)","color":"black"}],"pgn":"d4 Nf6 Nf3 c5 e3 g6 Bd3 Bg7 c3 Qc7 O-O O-O Nbd2 d6 Qe2 Nbd7 e4 cxd4 cxd4 e5 dxe5 dxe5 b3 Nc5 Bb2 Nh5 g3 Bh3 Rfc1 Qd6 Bc4 Rac8 Bd5 Qb8 Ng5 Bd7 Ba3 b6 Rc2 h6 Ngf3 Rfe8 Rac1 Ne6 Nc4 Bb5 Qe3 Bxc4 Bxc4 Nd4 Nxd4 exd4 Qd3 Rcd8 f4 Nf6 e5 Ng4 Qxg6 Ne3 Bxf7+ Kh8 Rc7 Qa8 Qxg7+ Kxg7 Bd5+ Kg6 Bxa8 Rxa8 Rd7 Rad8 Rc6+ Kf5 Rcd6 Rxd7 Rxd7 Ke4 Bb2 Nc2 Kf2 d3 Bc1 Nd4 h3","clock":"15+15"},"puzzle":{"id":"7H5EV","rating":1852,"plays":410,"initialPly":84,"solution":["e8c8","d7d4","e4d4"],"themes":["endgame","short","advantage"]}},{"game":{"id":"eWGRX5AI","perf":{"key":"rapid","name":"Rapid"},"rated":true,"players":[{"userId":"sacalot","name":"sacalot (2151)","color":"white"},{"userId":"landitirana","name":"landitirana (1809)","color":"black"}],"pgn":"e4 e5 Nf3 Nc6 d4 exd4 Bc4 Nf6 O-O Nxe4 Re1 d5 Bxd5 Qxd5 Nc3 Qd8 Rxe4+ Be6 Nxd4 Nxd4 Rxd4 Qf6 Ne4 Qe5 f4 Qf5 Ng3 Qa5 Bd2 Qb6 Be3 Bc5 f5 Bd5 Rxd5 Bxe3+ Kh1 O-O Rd3 Rfe8 Qf3 Qxb2 Rf1 Bd4 Nh5 Bf6 Rb3 Qd4 Rxb7 Re3 Nxf6+ gxf6 Qf2 Rae8 Rxc7 Qe5 Rc4 Re1 Rf4 Qa1 h3","clock":"10+0"},"puzzle":{"id":"1qUth","rating":1556,"plays":2661,"initialPly":60,"solution":["e1f1","f2f1","e8e1","f1e1","a1e1"],"themes":["endgame","master","advantage","fork","long","pin"]}}]}
''';

const batchOf1 = '''
{"puzzles":[{"game":{"id":"PrlkCqOv","perf":{"key":"rapid","name":"Rapid"},"rated":true,"players":[{"userId":"silverjo","name":"silverjo (1777)","color":"white"},{"userId":"robyarchitetto","name":"Robyarchitetto (1742)","color":"black"}],"pgn":"e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2 Bb7 Bh6 d5 e5 d4 Bxg7 Kxg7 Qf4 Bxf3 Qxf3 dxc3 Nxc3 Nac6 Qf6+ Kg8 Rd1 Nd4 O-O c5 Ne4 Nef5 Rd2 Qxf6 Nxf6+ Kg7 Re1 h5 h3 Rad8 b4 Nh4 Re3 Nhf5 Re1 a5 bxc5 bxc5 Bc4 Ra8 Rb1 Nh4 Rdb2 Nc6 Rb7 Nxe5 Bxe6 Kxf6 Bd5 Nf5 R7b6+ Kg7 Bxa8 Rxa8 R6b3 Nd4 Rb7 Nxd3 Rd1 Ne2+ Kh2 Ndf4 Rdd7 Rf8 Ra7 c4 Rxa5 c3 Rc5 Ne6 Rc4 Ra8 a4 Rb8 a5 Rb2 a6 c2","clock":"5+8"},"puzzle":{"id":"20yWT","rating":1859,"plays":551,"initialPly":93,"solution":["a6a7","b2a2","c4c2","a2a7","d7a7"],"themes":["endgame","long","advantage","advancedPawn"]}}]}
''';

const batchOf2 = '''
{"puzzles":[{"game":{"id":"PrlkCqOv","perf":{"key":"rapid","name":"Rapid"},"rated":true,"players":[{"userId":"silverjo","name":"silverjo (1777)","color":"white"},{"userId":"robyarchitetto","name":"Robyarchitetto (1742)","color":"black"}],"pgn":"e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2 Bb7 Bh6 d5 e5 d4 Bxg7 Kxg7 Qf4 Bxf3 Qxf3 dxc3 Nxc3 Nac6 Qf6+ Kg8 Rd1 Nd4 O-O c5 Ne4 Nef5 Rd2 Qxf6 Nxf6+ Kg7 Re1 h5 h3 Rad8 b4 Nh4 Re3 Nhf5 Re1 a5 bxc5 bxc5 Bc4 Ra8 Rb1 Nh4 Rdb2 Nc6 Rb7 Nxe5 Bxe6 Kxf6 Bd5 Nf5 R7b6+ Kg7 Bxa8 Rxa8 R6b3 Nd4 Rb7 Nxd3 Rd1 Ne2+ Kh2 Ndf4 Rdd7 Rf8 Ra7 c4 Rxa5 c3 Rc5 Ne6 Rc4 Ra8 a4 Rb8 a5 Rb2 a6 c2","clock":"5+8"},"puzzle":{"id":"20yWT","rating":1859,"plays":551,"initialPly":93,"solution":["a6a7","b2a2","c4c2","a2a7","d7a7"],"themes":["endgame","long","advantage","advancedPawn"]}},{"game":{"id":"0lwkiJbZ","perf":{"key":"classical","name":"Classical"},"rated":true,"players":[{"userId":"nirdosh","name":"nirdosh (2035)","color":"white"},{"userId":"burn_it_down","name":"burn_it_down (2139)","color":"black"}],"pgn":"d4 Nf6 Nf3 c5 e3 g6 Bd3 Bg7 c3 Qc7 O-O O-O Nbd2 d6 Qe2 Nbd7 e4 cxd4 cxd4 e5 dxe5 dxe5 b3 Nc5 Bb2 Nh5 g3 Bh3 Rfc1 Qd6 Bc4 Rac8 Bd5 Qb8 Ng5 Bd7 Ba3 b6 Rc2 h6 Ngf3 Rfe8 Rac1 Ne6 Nc4 Bb5 Qe3 Bxc4 Bxc4 Nd4 Nxd4 exd4 Qd3 Rcd8 f4 Nf6 e5 Ng4 Qxg6 Ne3 Bxf7+ Kh8 Rc7 Qa8 Qxg7+ Kxg7 Bd5+ Kg6 Bxa8 Rxa8 Rd7 Rad8 Rc6+ Kf5 Rcd6 Rxd7 Rxd7 Ke4 Bb2 Nc2 Kf2 d3 Bc1 Nd4 h3","clock":"15+15"},"puzzle":{"id":"7H5EV","rating":1852,"plays":410,"initialPly":84,"solution":["e8c8","d7d4","e4d4"],"themes":["endgame","short","advantage"]}}]}
''';

final samplePuzzle = Puzzle(
  puzzle: PuzzleData(
    id: const PuzzleId('pId3'),
    rating: 1988,
    plays: 5,
    initialPly: 23,
    solution: IList(const ['a6a7', 'b2a2', 'c4c2']),
    themes: ISet(const ['endgame', 'advantage']),
  ),
  game: const PuzzleGame(
    id: GameId('PrlkCqOv'),
    perf: Perf.blitz,
    rated: true,
    white: PuzzleGamePlayer(side: Side.white, name: 'user1'),
    black: PuzzleGamePlayer(side: Side.black, name: 'user2'),
    pgn: 'e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2',
  ),
);

PuzzleBatch _makePuzzleBatch({
  required List<PuzzleId> unsolved,
  List<PuzzleSolution> solved = const [],
}) {
  return PuzzleBatch(
    solved: IList([for (final solution in solved) solution]),
    unsolved: IList([
      for (final id in unsolved)
        Puzzle(
          puzzle: PuzzleData(
            id: id,
            rating: 1988,
            plays: 5,
            initialPly: 23,
            solution: IList(const ['a6a7', 'b2a2', 'c4c2']),
            themes: ISet(const ['endgame', 'advantage']),
          ),
          game: const PuzzleGame(
            id: GameId('PrlkCqOv'),
            perf: Perf.blitz,
            rated: true,
            white: PuzzleGamePlayer(side: Side.white, name: 'user1'),
            black: PuzzleGamePlayer(side: Side.black, name: 'user2'),
            pgn: 'e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2',
          ),
        ),
    ]),
  );
}
