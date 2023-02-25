import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartchess/dartchess.dart';
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_local_db.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import '../../test_utils.dart';

class MockLogger extends Mock implements Logger {}

class MockClient extends Mock implements http.Client {}

void main() {
  final mockLogger = MockLogger();
  final mockClient = MockClient();

  final puzzleRepo = PuzzleRepository(
    mockLogger,
    apiClient: ApiClient(mockLogger, mockClient),
  );

  setUpAll(() {
    registerFallbackValue(
      Uri.parse('$kLichessHost/api/puzzle/batch/mix?nb=30'),
    );
  });

  setUp(() {
    reset(mockClient);
  });

  group('PuzzleService', () {
    test('will download data if local queue is empty', () async {
      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();

      final db = PuzzleLocalDB(sharedPreferences);
      final service = PuzzleService(mockLogger, db: db, repository: puzzleRepo);

      when(
        () => mockClient.get(
          Uri.parse('$kLichessHost/api/puzzle/batch/mix?nb=30'),
        ),
      ).thenAnswer((_) => mockResponse(batchOf3, 200));

      final puzzle = await service.nextPuzzle();
      expect(puzzle?.puzzle.id, equals(const PuzzleId('20yWT')));
      verify(
        () => mockClient.get(
          Uri.parse('$kLichessHost/api/puzzle/batch/mix?nb=30'),
        ),
      ).called(1);
      expect(db.fetch()?.solved, equals(IList(const [])));
      expect(db.fetch()?.unsolved.length, equals(3));
    });

    test('will not download data if local queue is full', () async {
      SharedPreferences.setMockInitialValues({
        'PuzzleLocalDB.angle:mix': oneSavedPuzzle,
      });
      final sharedPreferences = await SharedPreferences.getInstance();

      final db = PuzzleLocalDB(sharedPreferences);
      final service = PuzzleService(
        mockLogger,
        db: db,
        repository: puzzleRepo,
        localQueueLength: 1,
      );

      final puzzle = await service.nextPuzzle();
      expect(puzzle?.puzzle.id, equals(const PuzzleId('pId3')));
      verifyNever(() => mockClient.get(any()));
      expect(db.fetch()?.unsolved.length, equals(1));
    });

    test('will fetch puzzle deficit if local queue is not full', () async {
      SharedPreferences.setMockInitialValues({
        'PuzzleLocalDB.angle:mix': oneSavedPuzzle,
      });
      final sharedPreferences = await SharedPreferences.getInstance();

      final db = PuzzleLocalDB(sharedPreferences);
      final service = PuzzleService(
        mockLogger,
        db: db,
        repository: puzzleRepo,
        localQueueLength: 2,
      );

      // will fetch only 1 since localQueueLength is 2
      when(
        () => mockClient.get(
          Uri.parse('$kLichessHost/api/puzzle/batch/mix?nb=1'),
        ),
      ).thenAnswer((_) => mockResponse(batchOf1, 200));

      final puzzle = await service.nextPuzzle();
      expect(puzzle?.puzzle.id, equals(const PuzzleId('pId3')));
      verify(
        () => mockClient
            .get(Uri.parse('$kLichessHost/api/puzzle/batch/mix?nb=1')),
      ).called(1);
      expect(db.fetch()?.unsolved.length, equals(2));
    });

    test(
        'nextPuzzle will always get the first puzzle of the queue as long as it is not solved',
        () async {
      SharedPreferences.setMockInitialValues({
        'PuzzleLocalDB.angle:mix': oneSavedPuzzle,
      });
      final sharedPreferences = await SharedPreferences.getInstance();

      final db = PuzzleLocalDB(sharedPreferences);
      final service = PuzzleService(
        mockLogger,
        db: db,
        repository: puzzleRepo,
        localQueueLength: 1,
      );

      final puzzle = await service.nextPuzzle();
      expect(puzzle?.puzzle.id, equals(const PuzzleId('pId3')));
      expect(db.fetch()?.unsolved.length, equals(1));

      final puzzle2 = await service.nextPuzzle();
      expect(puzzle2?.puzzle.id, equals(const PuzzleId('pId3')));
      expect(db.fetch()?.unsolved.length, equals(1));
    });

    test('different batch is saved per userId', () async {
      SharedPreferences.setMockInitialValues({
        'PuzzleLocalDB.angle:mix': oneSavedPuzzle,
      });
      final sharedPreferences = await SharedPreferences.getInstance();

      final db = PuzzleLocalDB(sharedPreferences);
      final service = PuzzleService(
        mockLogger,
        db: db,
        repository: puzzleRepo,
        localQueueLength: 1,
      );

      when(
        () => mockClient.get(
          Uri.parse('$kLichessHost/api/puzzle/batch/mix?nb=1'),
        ),
      ).thenAnswer((_) => mockResponse(batchOf1, 200));

      final puzzle = await service.nextPuzzle(userId: 'testUserId');
      expect(puzzle?.puzzle.id, equals(const PuzzleId('20yWT')));
      verify(
        () => mockClient
            .get(Uri.parse('$kLichessHost/api/puzzle/batch/mix?nb=1')),
      ).called(1);

      expect(db.fetch(userId: 'testUserId')?.unsolved.length, equals(1));
    });

    test('different batch is saved per angle', () async {
      SharedPreferences.setMockInitialValues({
        'PuzzleLocalDB.angle:mix': oneSavedPuzzle,
      });
      final sharedPreferences = await SharedPreferences.getInstance();

      final db = PuzzleLocalDB(sharedPreferences);
      final service = PuzzleService(
        mockLogger,
        db: db,
        repository: puzzleRepo,
        localQueueLength: 1,
      );

      when(
        () => mockClient.get(
          Uri.parse('$kLichessHost/api/puzzle/batch/opening?nb=1'),
        ),
      ).thenAnswer((_) => mockResponse(batchOf1, 200));

      final puzzle = await service.nextPuzzle(angle: PuzzleTheme.opening);
      expect(puzzle?.puzzle.id, equals(const PuzzleId('20yWT')));
      verify(
        () => mockClient.get(
          Uri.parse('$kLichessHost/api/puzzle/batch/opening?nb=1'),
        ),
      ).called(1);

      expect(db.fetch(angle: PuzzleTheme.opening)?.unsolved.length, equals(1));
    });

    test('solve puzzle when online', () async {
      SharedPreferences.setMockInitialValues({
        'PuzzleLocalDB.angle:mix': oneSavedPuzzle,
      });
      final sharedPreferences = await SharedPreferences.getInstance();

      final db = PuzzleLocalDB(sharedPreferences);
      final service = PuzzleService(
        mockLogger,
        db: db,
        repository: puzzleRepo,
        localQueueLength: 1,
      );

      when(
        () => mockClient.post(
          Uri.parse('$kLichessHost/api/puzzle/batch/mix?nb=1'),
          headers: any(
            named: 'headers',
            that: sameHeaders({'Content-type': 'application/json'}),
          ),
          body:
              '{"solutions":[{"id":{"value":"pId3"},"win":true,"rated":true}]}',
        ),
      ).thenAnswer((_) => mockResponse(batchOf1, 200));

      await service.solve(
        solution: const PuzzleSolution(
          id: PuzzleId('pId3'),
          win: true,
          rated: true,
        ),
      );
      final data = db.fetch();
      expect(data?.solved, equals(IList(const [])));
      expect(data?.unsolved[0].puzzle.id, equals(const PuzzleId('20yWT')));
    });

    test('solve puzzle when offline', () async {
      SharedPreferences.setMockInitialValues({
        'PuzzleLocalDB.angle:mix': oneSavedPuzzle,
      });
      final sharedPreferences = await SharedPreferences.getInstance();

      final db = PuzzleLocalDB(sharedPreferences);
      final service = PuzzleService(
        mockLogger,
        db: db,
        repository: puzzleRepo,
        localQueueLength: 1,
      );

      when(
        () => mockClient.post(
          Uri.parse('$kLichessHost/api/puzzle/batch/mix?nb=1'),
          headers: any(
            named: 'headers',
            that: sameHeaders({'Content-type': 'application/json'}),
          ),
          body:
              '{"solutions":[{"id":{"value":"pId3"},"win":true,"rated":true}]}',
        ),
      ).thenAnswer((_) => Future.error(const SocketException('offline')));

      const solution =
          PuzzleSolution(id: PuzzleId('pId3'), win: true, rated: true);
      await service.solve(solution: solution);

      verify(
        () => mockClient.post(
          Uri.parse('$kLichessHost/api/puzzle/batch/mix?nb=1'),
          headers: any(
            named: 'headers',
            that: sameHeaders({'Content-type': 'application/json'}),
          ),
          body:
              '{"solutions":[{"id":{"value":"pId3"},"win":true,"rated":true}]}',
        ),
      ).called(1);

      final data = db.fetch();
      expect(data?.solved, equals(IList(const [solution])));
      expect(data?.unsolved, equals(IList(const [])));
    });
  });
}

const batchOf3 = '''
{"puzzles":[{"game":{"id":"PrlkCqOv","perf":{"key":"rapid","name":"Rapid"},"rated":true,"players":[{"userId":"silverjo","name":"silverjo (1777)","color":"white"},{"userId":"robyarchitetto","name":"Robyarchitetto (1742)","color":"black"}],"pgn":"e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2 Bb7 Bh6 d5 e5 d4 Bxg7 Kxg7 Qf4 Bxf3 Qxf3 dxc3 Nxc3 Nac6 Qf6+ Kg8 Rd1 Nd4 O-O c5 Ne4 Nef5 Rd2 Qxf6 Nxf6+ Kg7 Re1 h5 h3 Rad8 b4 Nh4 Re3 Nhf5 Re1 a5 bxc5 bxc5 Bc4 Ra8 Rb1 Nh4 Rdb2 Nc6 Rb7 Nxe5 Bxe6 Kxf6 Bd5 Nf5 R7b6+ Kg7 Bxa8 Rxa8 R6b3 Nd4 Rb7 Nxd3 Rd1 Ne2+ Kh2 Ndf4 Rdd7 Rf8 Ra7 c4 Rxa5 c3 Rc5 Ne6 Rc4 Ra8 a4 Rb8 a5 Rb2 a6 c2","clock":"5+8"},"puzzle":{"id":"20yWT","rating":1859,"plays":551,"initialPly":93,"solution":["a6a7","b2a2","c4c2","a2a7","d7a7"],"themes":["endgame","long","advantage","advancedPawn"]}},{"game":{"id":"0lwkiJbZ","perf":{"key":"classical","name":"Classical"},"rated":true,"players":[{"userId":"nirdosh","name":"nirdosh (2035)","color":"white"},{"userId":"burn_it_down","name":"burn_it_down (2139)","color":"black"}],"pgn":"d4 Nf6 Nf3 c5 e3 g6 Bd3 Bg7 c3 Qc7 O-O O-O Nbd2 d6 Qe2 Nbd7 e4 cxd4 cxd4 e5 dxe5 dxe5 b3 Nc5 Bb2 Nh5 g3 Bh3 Rfc1 Qd6 Bc4 Rac8 Bd5 Qb8 Ng5 Bd7 Ba3 b6 Rc2 h6 Ngf3 Rfe8 Rac1 Ne6 Nc4 Bb5 Qe3 Bxc4 Bxc4 Nd4 Nxd4 exd4 Qd3 Rcd8 f4 Nf6 e5 Ng4 Qxg6 Ne3 Bxf7+ Kh8 Rc7 Qa8 Qxg7+ Kxg7 Bd5+ Kg6 Bxa8 Rxa8 Rd7 Rad8 Rc6+ Kf5 Rcd6 Rxd7 Rxd7 Ke4 Bb2 Nc2 Kf2 d3 Bc1 Nd4 h3","clock":"15+15"},"puzzle":{"id":"7H5EV","rating":1852,"plays":410,"initialPly":84,"solution":["e8c8","d7d4","e4d4"],"themes":["endgame","short","advantage"]}},{"game":{"id":"eWGRX5AI","perf":{"key":"rapid","name":"Rapid"},"rated":true,"players":[{"userId":"sacalot","name":"sacalot (2151)","color":"white"},{"userId":"landitirana","name":"landitirana (1809)","color":"black"}],"pgn":"e4 e5 Nf3 Nc6 d4 exd4 Bc4 Nf6 O-O Nxe4 Re1 d5 Bxd5 Qxd5 Nc3 Qd8 Rxe4+ Be6 Nxd4 Nxd4 Rxd4 Qf6 Ne4 Qe5 f4 Qf5 Ng3 Qa5 Bd2 Qb6 Be3 Bc5 f5 Bd5 Rxd5 Bxe3+ Kh1 O-O Rd3 Rfe8 Qf3 Qxb2 Rf1 Bd4 Nh5 Bf6 Rb3 Qd4 Rxb7 Re3 Nxf6+ gxf6 Qf2 Rae8 Rxc7 Qe5 Rc4 Re1 Rf4 Qa1 h3","clock":"10+0"},"puzzle":{"id":"1qUth","rating":1556,"plays":2661,"initialPly":60,"solution":["e1f1","f2f1","e8e1","f1e1","a1e1"],"themes":["endgame","master","advantage","fork","long","pin"]}}]}
''';

const batchOf1 = '''
{"puzzles":[{"game":{"id":"PrlkCqOv","perf":{"key":"rapid","name":"Rapid"},"rated":true,"players":[{"userId":"silverjo","name":"silverjo (1777)","color":"white"},{"userId":"robyarchitetto","name":"Robyarchitetto (1742)","color":"black"}],"pgn":"e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2 Bb7 Bh6 d5 e5 d4 Bxg7 Kxg7 Qf4 Bxf3 Qxf3 dxc3 Nxc3 Nac6 Qf6+ Kg8 Rd1 Nd4 O-O c5 Ne4 Nef5 Rd2 Qxf6 Nxf6+ Kg7 Re1 h5 h3 Rad8 b4 Nh4 Re3 Nhf5 Re1 a5 bxc5 bxc5 Bc4 Ra8 Rb1 Nh4 Rdb2 Nc6 Rb7 Nxe5 Bxe6 Kxf6 Bd5 Nf5 R7b6+ Kg7 Bxa8 Rxa8 R6b3 Nd4 Rb7 Nxd3 Rd1 Ne2+ Kh2 Ndf4 Rdd7 Rf8 Ra7 c4 Rxa5 c3 Rc5 Ne6 Rc4 Ra8 a4 Rb8 a5 Rb2 a6 c2","clock":"5+8"},"puzzle":{"id":"20yWT","rating":1859,"plays":551,"initialPly":93,"solution":["a6a7","b2a2","c4c2","a2a7","d7a7"],"themes":["endgame","long","advantage","advancedPawn"]}}]}
''';

final String oneSavedPuzzle = jsonEncode(
  PuzzleLocalData(
    solved: IList(const []),
    unsolved: IList([
      Puzzle(
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
          white: PuzzlePlayer(side: Side.white, userId: 'user1', name: 'user1'),
          black: PuzzlePlayer(side: Side.black, userId: 'user2', name: 'user2'),
          pgn: 'e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2',
        ),
      ),
    ]),
  ).toJson(),
);
