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
    required UciPath initialPath,
    required UciPath currentPath,
    required Side pov,
    required String fen,
    required Position position,
    Move? lastMove,
  }) = _PuzzleVm;
}

@riverpod
class PuzzleScreenState extends _$PuzzleScreenState {
  Node? _gameTree;

  @override
  PuzzleVm build(Puzzle puzzle) {
    _gameTree = Node.fromPgn(puzzle.game.pgn);

    Future<void>.delayed(const Duration(seconds: 1))
        .then((_) => _replayFirstMove());

    final initialPath = _gameTree!.mainlinePath;
    final currentPath = _gameTree!.mainlinePath.penultimate;
    final currentNode = _gameTree!.nodeAt(currentPath);

    return PuzzleVm(
      initialPath: initialPath,
      currentPath: currentPath,
      position: currentNode.position,
      fen: currentNode.fen,
      pov: _gameTree!.nodeAt(initialPath).ply.isEven ? Side.white : Side.black,
    );
  }

  void _replayFirstMove() {
    final newPath = state.initialPath;
    final newNode = _gameTree!.branchAt(newPath);
    state = state.copyWith(
      currentPath: newPath,
      position: newNode.position,
      fen: newNode.fen,
      lastMove: newNode.sanMove.move,
    );
  }
}
