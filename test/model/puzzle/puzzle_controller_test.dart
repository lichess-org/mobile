import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_controller.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';

import '../../test_container.dart';

final _puzzle = Puzzle(
  puzzle: PuzzleData(
    id: const PuzzleId('MptxK'),
    rating: 1012,
    plays: 5557,
    initialPly: 66,
    solution: IList(const ['e5e1', 'g1h2', 'f6f4', 'g2g3', 'f4f2']),
    themes: ISet(const ['endgame', 'long', 'mateIn3']),
  ),
  game: const PuzzleGame(
    id: GameId('Xndtxsoa'),
    perf: Perf.blitz,
    rated: true,
    white: PuzzleGamePlayer(side: Side.white, name: 'VincV'),
    black: PuzzleGamePlayer(side: Side.black, name: 'Rex9646'),
    pgn:
        'e4 c5 Nf3 e6 d4 cxd4 Nxd4 a6 Be2 Nf6 Nc3 Bb4 e5 Ne4 Bd2 Bxc3 Bxc3 Nxc3 bxc3 Qa5 '
        'O-O Qxe5 Re1 O-O Bxa6 Qc5 Bd3 Nc6 Re3 f5 Rh3 h6 Nxc6 bxc6 c4 Ra3 Qh5 Qd4 Rf1 Rxa2 '
        'Rg3 Kh8 Rg6 Rf6 Rxf6 Qxf6 Qe8+ Kh7 Qxc8 Qe7 h3 Qf7 Re1 Qe7 Bxf5+ g6 Bd3 Kg7 Qb7 '
        'Ra5 Rd1 Re5 Bxg6 Kxg6 Rxd7 Qf6 Qc8',
  ),
);

void main() {
  test('loadForReview keeps the puzzle in view mode past the first-move delay', () async {
    final container = await makeContainer();
    addTearDown(container.dispose);

    final context = PuzzleContext(
      puzzle: _puzzle,
      angle: const PuzzleTheme(PuzzleThemeKey.mix),
      userId: null,
      isPuzzleStreak: true,
    );
    final provider = puzzleControllerProvider(context);
    final subscription = container.listen(provider, (_, _) {});
    addTearDown(subscription.close);

    container.read(provider.notifier).loadForReview(context);
    expect(container.read(provider).mode, PuzzleMode.view);

    // The opponent's first move is scheduled 1s after a context is loaded. A
    // reviewed puzzle must stay in view mode rather than flipping to play.
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    expect(container.read(provider).mode, PuzzleMode.view);
  });
}
