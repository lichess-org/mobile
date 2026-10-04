import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_batch_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_container.dart';

class MockPuzzleBatchStorage() extends Mock implements PuzzleBatchStorage;

void main() {
  const angle = PuzzleTheme(PuzzleThemeKey.mix);

  group('puzzleBatchProvider', () {
    test('serves the preview and the unsolved count from a single batch read', () async {
      final batchStorage = MockPuzzleBatchStorage();
      when(() => batchStorage.fetch(userId: null, angle: angle)).thenAnswer((_) async => _batch);

      final container = await makeContainer(
        overrides: {
          puzzleBatchStorageProvider: puzzleBatchStorageProvider.overrideWith(
            (ref) => batchStorage,
          ),
        },
      );

      final preview = await container.read(nextPuzzlePreviewProvider(angle).future);
      final nbUnsolved = await container.read(savedBatchNbUnsolvedProvider(angle).future);

      expect(preview, _batch.unsolved.first);
      expect(nbUnsolved, _batch.unsolved.length);

      verify(() => batchStorage.fetch(userId: null, angle: angle)).called(1);
      verifyNoMoreInteractions(batchStorage);
    });

    test('counts no unsolved puzzle for an unsaved angle', () async {
      final batchStorage = MockPuzzleBatchStorage();
      when(() => batchStorage.fetch(userId: null, angle: angle)).thenAnswer((_) async => null);

      final container = await makeContainer(
        overrides: {
          puzzleBatchStorageProvider: puzzleBatchStorageProvider.overrideWith(
            (ref) => batchStorage,
          ),
        },
      );

      expect(await container.read(savedBatchNbUnsolvedProvider(angle).future), 0);
    });
  });
}

final _batch = PuzzleBatch(
  solved: IList(const []),
  unsolved: IList([
    Puzzle(
      puzzle: PuzzleData(
        id: const PuzzleId('6Sz3s'),
        rating: 1984,
        plays: 68176,
        initialPly: 40,
        solution: IList(const ['h4h2']),
        themes: ISet(const {'mateIn3'}),
      ),
      game: const PuzzleGame(
        id: GameId('zgBwsXLr'),
        perf: Perf.blitz,
        rated: true,
        white: PuzzleGamePlayer(side: Side.white, name: 'arroyoM10'),
        black: PuzzleGamePlayer(side: Side.black, name: 'CAMBIADOR'),
        pgn: 'e4 c5 Nf3 e6 c4 Nc6 d4 cxd4 Nxd4 Bc5',
      ),
    ),
  ]),
);
