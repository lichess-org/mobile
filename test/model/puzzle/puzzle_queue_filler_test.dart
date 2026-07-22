import 'dart:io';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_batch_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_queue_filler.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../test_container.dart';
import '../../test_helpers.dart';

void main() {
  Future<ProviderContainer> makeTestContainer(MockClient mockClient) {
    return makeContainer(
      overrides: {
        lichessClientProvider: lichessClientProvider.overrideWith((ref) {
          return LichessClient(mockClient, ref);
        }),
      },
    );
  }

  group('PuzzleQueueFiller', () {
    test('fills an empty queue up to the configured count over multiple requests', () async {
      // Each server batch is capped (50 in prod, 1 here), so a queue larger than
      // the cap must be filled with several sequential select requests.
      int nbReq = 0;
      final mockClient = MockClient((request) {
        if (request.method == 'GET' && request.url.path == '/api/puzzle/batch/mix') {
          nbReq++;
          // distinct id per request so each pass appends a new puzzle
          return mockResponse(_batchOf1.replaceFirst('"20yWT"', '"pz$nbReq"'), 200);
        }
        // The filler must never POST solves.
        return mockResponse('', 404);
      });

      final container = await makeTestContainer(mockClient);
      final storage = await container.read(puzzleBatchStorageProvider.future);

      await container
          .read(puzzleQueueFillerProvider.notifier)
          .fill(userId: null, queueLengthOverride: 3);

      expect(nbReq, equals(3), reason: 'three GET requests to reach a queue of 3');
      final data = await storage.fetch(userId: null);
      expect(data?.unsolved.length, equals(3));
      expect(data?.solved, equals(IList(const [])));
    });

    test('only fetches the deficit when the queue is partially full', () async {
      int nbReq = 0;
      final mockClient = MockClient((request) {
        if (request.method == 'GET' && request.url.path == '/api/puzzle/batch/mix') {
          nbReq++;
          // request 1 needs nb=2 (queue 1 -> 3); serve two new puzzles at once
          return mockResponse(_batchOf2, 200);
        }
        return mockResponse('', 404);
      });

      final container = await makeTestContainer(mockClient);
      final storage = await container.read(puzzleBatchStorageProvider.future);
      await storage.save(userId: null, data: _makePuzzleBatch(unsolved: [const PuzzleId('pId3')]));

      await container
          .read(puzzleQueueFillerProvider.notifier)
          .fill(userId: null, queueLengthOverride: 3);

      expect(nbReq, equals(1));
      final data = await storage.fetch(userId: null);
      expect(data?.unsolved.length, equals(3));
    });

    test('does nothing when the queue is already full', () async {
      int nbReq = 0;
      final mockClient = MockClient((request) {
        nbReq++;
        return mockResponse('', 404);
      });

      final container = await makeTestContainer(mockClient);
      final storage = await container.read(puzzleBatchStorageProvider.future);
      await storage.save(userId: null, data: _makePuzzleBatch(unsolved: [const PuzzleId('pId3')]));

      await container
          .read(puzzleQueueFillerProvider.notifier)
          .fill(userId: null, queueLengthOverride: 1);

      expect(nbReq, equals(0), reason: 'no request when there is no deficit');
      final data = await storage.fetch(userId: null);
      expect(data?.unsolved.length, equals(1));
    });

    test('stops when the server runs out of puzzles', () async {
      int nbReq = 0;
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/puzzle/batch/mix') {
          nbReq++;
          // first request yields one puzzle, then the server is exhausted
          return mockResponse(nbReq == 1 ? _batchOf1 : '{"puzzles":[]}', 200);
        }
        return mockResponse('', 404);
      });

      final container = await makeTestContainer(mockClient);
      final storage = await container.read(puzzleBatchStorageProvider.future);

      await container
          .read(puzzleQueueFillerProvider.notifier)
          .fill(userId: null, queueLengthOverride: 10);

      expect(nbReq, equals(2), reason: 'one filling request, one empty response, then stop');
      final data = await storage.fetch(userId: null);
      expect(data?.unsolved.length, equals(1));
    });

    test('stops and keeps existing puzzles when offline', () async {
      int nbReq = 0;
      final mockClient = MockClient((request) {
        nbReq++;
        throw const SocketException('offline');
      });

      final container = await makeTestContainer(mockClient);
      final storage = await container.read(puzzleBatchStorageProvider.future);
      await storage.save(userId: null, data: _makePuzzleBatch(unsolved: [const PuzzleId('pId3')]));

      // must not throw
      await container
          .read(puzzleQueueFillerProvider.notifier)
          .fill(userId: null, queueLengthOverride: 5);

      expect(nbReq, equals(1));
      final data = await storage.fetch(userId: null);
      expect(data?.unsolved.length, equals(1));
    });

    test('never submits a solve request (select-only)', () async {
      int nbPost = 0;
      final mockClient = MockClient((request) {
        if (request.method == 'POST') nbPost++;
        if (request.method == 'GET' && request.url.path == '/api/puzzle/batch/mix') {
          return mockResponse(_batchOf2, 200);
        }
        return mockResponse('', 404);
      });

      final container = await makeTestContainer(mockClient);
      final storage = await container.read(puzzleBatchStorageProvider.future);
      // storage already holds a solved entry: the filler must not report it
      await storage.save(
        userId: const UserId('u1'),
        data: _makePuzzleBatch(
          unsolved: const [],
          solved: [const PuzzleSolution(id: PuzzleId('old'), win: true, rated: true)],
        ),
      );

      await container
          .read(puzzleQueueFillerProvider.notifier)
          .fill(userId: const UserId('u1'), queueLengthOverride: 2);

      expect(nbPost, equals(0), reason: 'fill must only GET, never POST solves');
      final data = await storage.fetch(userId: const UserId('u1'));
      // pre-existing solved list is preserved untouched
      expect(data?.solved.length, equals(1));
      expect(data?.unsolved.length, equals(2));
    });

    test('single-flight: a second concurrent fill is a no-op', () async {
      int nbReq = 0;
      final mockClient = MockClient((request) async {
        if (request.method == 'GET' && request.url.path == '/api/puzzle/batch/mix') {
          nbReq++;
          await Future<void>.delayed(const Duration(milliseconds: 20));
          return mockResponse(_batchOf1.replaceFirst('"20yWT"', '"pz$nbReq"'), 200);
        }
        return mockResponse('', 404);
      });

      final container = await makeTestContainer(mockClient);
      final storage = await container.read(puzzleBatchStorageProvider.future);
      final notifier = container.read(puzzleQueueFillerProvider.notifier);

      // fire two overlapping fills; the second must return immediately
      final first = notifier.fill(userId: null, queueLengthOverride: 2);
      final second = notifier.fill(userId: null);
      await Future.wait([first, second]);

      // only the first fill ran: exactly 2 requests to reach a queue of 2
      expect(nbReq, equals(2));
      final data = await storage.fetch(userId: null);
      expect(data?.unsolved.length, equals(2));
    });
  });
}

const _batchOf1 = '''
{"puzzles":[{"game":{"id":"PrlkCqOv","perf":{"key":"rapid","name":"Rapid"},"rated":true,"players":[{"userId":"silverjo","name":"silverjo (1777)","color":"white"},{"userId":"robyarchitetto","name":"Robyarchitetto (1742)","color":"black"}],"pgn":"e4 Nc6","clock":"5+8"},"puzzle":{"id":"20yWT","rating":1859,"plays":551,"initialPly":93,"solution":["a6a7","b2a2","c4c2","a2a7","d7a7"],"themes":["endgame","long","advantage","advancedPawn"]}}]}
''';

const _batchOf2 = '''
{"puzzles":[{"game":{"id":"PrlkCqOv","perf":{"key":"rapid","name":"Rapid"},"rated":true,"players":[{"userId":"silverjo","name":"silverjo (1777)","color":"white"},{"userId":"robyarchitetto","name":"Robyarchitetto (1742)","color":"black"}],"pgn":"e4 Nc6","clock":"5+8"},"puzzle":{"id":"20yWT","rating":1859,"plays":551,"initialPly":93,"solution":["a6a7","b2a2","c4c2","a2a7","d7a7"],"themes":["endgame"]}},{"game":{"id":"0lwkiJbZ","perf":{"key":"classical","name":"Classical"},"rated":true,"players":[{"userId":"nirdosh","name":"nirdosh (2035)","color":"white"},{"userId":"burn_it_down","name":"burn_it_down (2139)","color":"black"}],"pgn":"d4 Nf6","clock":"15+15"},"puzzle":{"id":"7H5EV","rating":1852,"plays":410,"initialPly":84,"solution":["e8c8","d7d4","e4d4"],"themes":["endgame","short","advantage"]}}]}
''';

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
