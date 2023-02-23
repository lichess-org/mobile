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
    final nodeList = _makeNodeList(currentPath);

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

    if (_testMoveAgainstSolution(move)) {
      final replyMove = Move.fromUci(
        state.puzzle.solution.elementAt(state.nodeList.length - 1),
      );
      await Future<void>.delayed(const Duration(seconds: 1));

      _addMove(replyMove!);
    }
  }

  void _addMove(Move move) {
    final tuple = _gameTree!.addMoveAt(state.currentPath, move);
    final newPath = tuple.item1;
    if (newPath != null) {
      final newNodeList = _makeNodeList(newPath);
      state = state.copyWith(
        currentPath: newPath,
        nodeList: newNodeList,
        lastMove: newNodeList.last.sanMove.move,
      );
    }
  }

  bool _testMoveAgainstSolution(Move move) {
    final sanMoves = state.nodeList.sublist(1).map((e) => e.sanMove);
    for (var i = 0; i < sanMoves.length; i++) {
      final sanMove = sanMoves.elementAt(i);
      final uci = sanMove.move.uci;
      final isCheckmate = sanMove.san.endsWith('#');
      final solutionUci = state.puzzle.solution.elementAt(i);
      if (isCheckmate) {
        return true;
      }
      if (uci == solutionUci) {
        return true;
      }
      if (altCastles.containsKey(uci) && altCastles[uci] == solutionUci) {
        return true;
      }
    }
    return false;
  }

  void _replayFirstMove() {
    final newPath = state.initialPath;
    final newNodeList = _makeNodeList(newPath);
    state = state.copyWith(
      currentPath: newPath,
      nodeList: newNodeList,
      lastMove: newNodeList.last.sanMove.move,
    );
  }

  // don't show all game moves but only the ones from the puzzle position
  IList<Branch> _makeNodeList(UciPath current) {
    final nodeList = _gameTree!.nodesOn(current);
    return IList(nodeList).sublist(current.size - 1);
  }
}

const altCastles = {
  'e1a1': 'e1c1',
  'e1h1': 'e1g1',
  'e8a8': 'e8c8',
  'e8h8': 'e8g8',
};
