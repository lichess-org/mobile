import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/tree.dart';
import 'package:lichess_mobile/src/common/uci.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';

part 'puzzle_screen_state.g.dart';
part 'puzzle_screen_state.freezed.dart';

@freezed
class PuzzleVm with _$PuzzleVm {
  const PuzzleVm._();

  const factory PuzzleVm({
    required Puzzle puzzle,
    required Node gameTree,
    required UciPath initialPath,
    required UciPath currentPath,
  }) = _PuzzleVm;

  Node get initialNode => gameTree.nodeAtPath(initialPath) ?? gameTree;
  Node get currentNode => gameTree.nodeAtPath(currentPath) ?? gameTree;
  Side get pov => initialNode.ply.isEven ? Side.white : Side.black;
}

@riverpod
class PuzzleScreenState extends _$PuzzleScreenState {
  @override
  PuzzleVm build(Puzzle puzzle) {
    final gameTree = Node.fromPgn(puzzle.game.pgn);
    return PuzzleVm(
      puzzle: puzzle,
      gameTree: gameTree,
      initialPath: gameTree.mainlinePath,
      currentPath: gameTree.mainlinePath.penultimate,
    );
  }
}
