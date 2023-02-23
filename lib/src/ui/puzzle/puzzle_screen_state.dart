import 'dart:math' as math;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/common/tree.dart';
import 'package:lichess_mobile/src/common/uci.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';

part 'puzzle_screen_state.g.dart';
part 'puzzle_screen_state.freezed.dart';

@freezed
class PuzzleVm with _$PuzzleVm {
  const PuzzleVm._();

  const factory PuzzleVm({
    required PuzzleData puzzle,
    required UciPath initialPath,
    required UciPath currentPath,
    required Side pov,
    required IList<Branch> nodeList,
    Move? lastMove,
  }) = _PuzzleVm;

  Position get position => nodeList.last.position;
  String get fen => nodeList.last.fen;
  Map<String, Set<String>> get validMoves => algebraicLegalMoves(position);
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
    final nodeList = _makeNodeList(currentPath, initialPath);

    return PuzzleVm(
      puzzle: puzzle.puzzle,
      initialPath: initialPath,
      currentPath: currentPath,
      nodeList: IList(nodeList),
      pov: _gameTree!.nodeAt(initialPath).ply.isEven ? Side.white : Side.black,
    );
  }

  Future<void> playUserMove(Move move) async {
    _addMove(move);

    final movesToTest = state.nodeList.sublist(1).map((e) => e.sanMove);

    if (state.puzzle.testSolution(movesToTest)) {
      final nextUci = state.puzzle.solution.getOrNull(movesToTest.length);
      if (nextUci != null) {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        _addMove(Move.fromUci(nextUci)!);
      }
    }
  }

  void _addMove(Move move) {
    final tuple = _gameTree!.addMoveAt(state.currentPath, move);
    final newPath = tuple.item1;
    if (newPath != null) {
      final newNodeList = _makeNodeList(newPath, state.initialPath);
      state = state.copyWith(
        currentPath: newPath,
        nodeList: newNodeList,
        lastMove: newNodeList.last.sanMove.move,
      );
    }
  }

  void _replayFirstMove() {
    final newPath = state.initialPath;
    final newNodeList = _makeNodeList(newPath, state.initialPath);
    state = state.copyWith(
      currentPath: newPath,
      nodeList: newNodeList,
      lastMove: newNodeList.last.sanMove.move,
    );
  }

  // don't show all game moves but only the ones from the puzzle position
  IList<Branch> _makeNodeList(UciPath current, UciPath initial) {
    final nodeList = _gameTree!.nodesOn(current);
    return IList(nodeList).sublist(math.min(current.size, initial.size) - 1);
  }
}
