import 'dart:math' show max;

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
import 'package:lichess_mobile/src/model/puzzle/puzzle_controller.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_difficulty.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_queue_filler.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../test_container.dart';
import '../../test_helpers.dart';
import '../auth/fake_auth_storage.dart';

final _userId = fakeAuthUser.user.id;

void main() {
  group('PuzzleController.changeDifficulty', () {
    test('does not start the offline queue fill while resetBatch is in flight', () async {
      // Regression test: `resetBatch` saves a batch built from a snapshot taken
      // before its own request and does not merge, so a fill running
      // concurrently would have its writes overwritten, and would then stop
      // early on its "the queue did not grow" check, leaving the offline queue
      // below the configured count.
      int nbBatchReq = 0;
      int inFlight = 0;
      int maxInFlight = 0;
      final mockClient = MockClient((request) async {
        if (request.url.path == '/api/puzzle/batch/mix') {
          // the rating probe made on controller build asks for nb=0
          if (request.url.queryParameters['nb'] == '0') {
            return mockResponse(_emptyBatch, 200);
          }
          nbBatchReq++;
          inFlight++;
          maxInFlight = max(maxInFlight, inFlight);
          // keep the request in flight long enough for an overlapping fill to
          // start before the response is stored
          await Future<void>.delayed(const Duration(milliseconds: 20));
          inFlight--;
          return mockResponse(_batchOf2, 200);
        }
        return mockResponse('', 404);
      });

      final container = await makeContainer(
        authUser: fakeAuthUser,
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith((ref) {
            return LichessClient(mockClient, ref);
          }),
        },
      );
      final storage = await container.read(puzzleBatchStorageProvider.future);

      final ctrlProvider = puzzleControllerProvider(_initialContext);
      // keep the autoDispose controller alive for the duration of the test
      final sub = container.listen(ctrlProvider, (_, _) {});
      addTearDown(sub.close);

      await container.read(ctrlProvider.notifier).changeDifficulty(PuzzleDifficulty.harder);
      await _waitForFill(container);

      expect(maxInFlight, equals(1), reason: 'the fill must not overlap the resetBatch request');
      expect(nbBatchReq, equals(2), reason: 'one reset request, then one fill request');

      // The reset batch survived the fill: the two puzzles of the new difficulty
      // are still queued, and the fill did not restore any of the pre-reset ones.
      final data = await storage.fetch(userId: _userId);
      expect(
        data?.unsolved.map((p) => p.puzzle.id).toList(),
        equals(const [PuzzleId('20yWT'), PuzzleId('7H5EV')]),
      );
    });

    test('is a no-op for the fill when the user is anonymous', () async {
      int nbBatchReq = 0;
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/puzzle/batch/mix') {
          nbBatchReq++;
          return mockResponse(_batchOf2, 200);
        }
        return mockResponse('', 404);
      });

      final container = await makeContainer(
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith((ref) {
            return LichessClient(mockClient, ref);
          }),
        },
      );

      final ctrlProvider = puzzleControllerProvider(_initialContext.copyWith(userId: null));
      final sub = container.listen(ctrlProvider, (_, _) {});
      addTearDown(sub.close);

      await container.read(ctrlProvider.notifier).changeDifficulty(PuzzleDifficulty.harder);
      await _waitForFill(container);

      expect(nbBatchReq, equals(1), reason: 'only the resetBatch request, no fill');
      expect(container.read(puzzleQueueFillerProvider), isFalse);
    });
  });
}

/// Waits for the fire-and-forget queue fill kicked off by the controller.
Future<void> _waitForFill(ProviderContainer container) async {
  for (int i = 0; i < 200 && container.read(puzzleQueueFillerProvider); i++) {
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
  expect(container.read(puzzleQueueFillerProvider), isFalse, reason: 'the fill should be done');
}

final _initialContext = PuzzleContext(
  puzzle: Puzzle(
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
  ),
  angle: const PuzzleTheme(PuzzleThemeKey.mix),
  userId: _userId,
);

const _emptyBatch = '{"puzzles":[]}';

const _batchOf2 = '''
{"puzzles":[{"game":{"id":"PrlkCqOv","perf":{"key":"rapid","name":"Rapid"},"rated":true,"players":[{"userId":"silverjo","name":"silverjo (1777)","color":"white"},{"userId":"robyarchitetto","name":"Robyarchitetto (1742)","color":"black"}],"pgn":"e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2","clock":"5+8"},"puzzle":{"id":"20yWT","rating":1859,"plays":551,"initialPly":93,"solution":["a6a7","b2a2","c4c2","a2a7","d7a7"],"themes":["endgame","long","advantage","advancedPawn"]}},{"game":{"id":"0lwkiJbZ","perf":{"key":"classical","name":"Classical"},"rated":true,"players":[{"userId":"nirdosh","name":"nirdosh (2035)","color":"white"},{"userId":"burn_it_down","name":"burn_it_down (2139)","color":"black"}],"pgn":"d4 Nf6 Nf3 c5 e3 g6 Bd3 Bg7 c3 Qc7 O-O O-O","clock":"15+15"},"puzzle":{"id":"7H5EV","rating":1852,"plays":410,"initialPly":84,"solution":["e8c8","d7d4","e4d4"],"themes":["endgame","short","advantage"]}}]}
''';
