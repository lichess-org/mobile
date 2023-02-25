import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/tree.dart';
import 'package:lichess_mobile/src/common/uci.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
// import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
// import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';

part 'puzzle_screen_state.g.dart';
part 'puzzle_screen_state.freezed.dart';

enum PuzzleMode { play, view }

enum PuzzleResult { win, lose }

enum PuzzleFeedback { good, bad }

@freezed
class PuzzleVm with _$PuzzleVm {
  const PuzzleVm._();

  const factory PuzzleVm({
    required PuzzleData puzzle,
    required UserId? userId,
    required PuzzleMode mode,
    required UciPath initialPath,
    required UciPath currentPath,
    required Side pov,
    required IList<Node> nodeList, // must be non empty
    Move? lastMove,
    PuzzleResult? result,
    PuzzleFeedback? feedback,
    required bool resultSent,
  }) = _PuzzleVm;

  Node get node => nodeList.last;
  Position get position => nodeList.last.position;
  String get fen => nodeList.last.fen;
  bool get isReplaying => mode == PuzzleMode.play && canGoNext;
  bool get canGoNext => node.children.isNotEmpty;
  bool get canGoBack => currentPath.size > initialPath.size;

  Map<String, Set<String>> get validMoves => algebraicLegalMoves(position);
}

@riverpod
class PuzzleScreenState extends _$PuzzleScreenState {
  late Node _gameTree;

  @override
  PuzzleVm build(Puzzle puzzle, UserId? userId) {
    final root = Root.fromPgn(puzzle.game.pgn);
    _gameTree = root.nodeAt(root.mainlinePath.penultimate) as Node;

    // play first move after 1 second
    Future<void>.delayed(const Duration(seconds: 1))
        .then((_) => _setPath(state.initialPath));

    final initialPath = UciPath.fromId(_gameTree.children.first.id);

    return PuzzleVm(
      puzzle: puzzle.puzzle,
      userId: userId,
      mode: PuzzleMode.play,
      initialPath: initialPath,
      currentPath: UciPath.empty,
      nodeList: IList([_gameTree]),
      pov: _gameTree.nodeAt(initialPath).ply.isEven ? Side.white : Side.black,
      resultSent: false,
    );
  }

  Future<void> playUserMove(Move move) async {
    _addMove(move);

    if (state.mode == PuzzleMode.play) {
      final movesToTest =
          state.nodeList.sublist(state.initialPath.size).map((e) => e.sanMove);

      final isGoodMove = state.puzzle.testSolution(movesToTest);

      if (isGoodMove) {
        state = state.copyWith(
          feedback: PuzzleFeedback.good,
        );

        final isCheckmate = movesToTest.last.san.endsWith('#');
        final nextUci = state.puzzle.solution.getOrNull(movesToTest.length);
        // checkmate is always a win
        if (isCheckmate) {
          _completePuzzle();
        }
        // another puzzle move: let's continue
        else if (nextUci != null) {
          await Future<void>.delayed(const Duration(milliseconds: 500));
          _addMove(Move.fromUci(nextUci)!);
        }
        // no more puzzle move: it's a win
        else {
          _completePuzzle();
        }
      } else {
        state = state.copyWith(
          feedback: PuzzleFeedback.bad,
          result: PuzzleResult.lose,
        );
        _sendResult();
        await Future<void>.delayed(const Duration(milliseconds: 500));
        _setPath(state.currentPath.penultimate);
      }
    }
  }

  void goToNextNode() {
    if (state.node.children.isEmpty) return;
    _setPath(state.currentPath + state.node.children.first.id);
  }

  void goToPreviousNode() {
    _setPath(state.currentPath.penultimate);
  }

  Future<void> _completePuzzle() async {
    state = state.copyWith(
      mode: PuzzleMode.view,
      result: state.result ?? PuzzleResult.win,
    );
    _sendResult();
  }

  Future<void> _sendResult() async {
    if (state.resultSent) return;

    state = state.copyWith(
      resultSent: true,
    );

    // TODO enable later

    // final theme = ref.read(puzzleThemePrefProvider);
    // final service = ref.read(puzzleServiceProvider);

    // await service.solve(
    //   userId: state.userId,
    //   angle: theme,
    //   solution: PuzzleSolution(
    //     id: state.puzzle.id,
    //     win: state.result == PuzzleResult.win,
    //     // TODO add rating option
    //     rated: userId != null,
    //   ),
    // );
  }

  void _setPath(UciPath path) {
    final newNodeList = IList(_gameTree.nodesOn(path));
    state = state.copyWith(
      currentPath: path,
      nodeList: newNodeList,
      lastMove: newNodeList.last.sanMove.move,
    );
  }

  void _addMove(Move move) {
    final tuple = _gameTree.addMoveAt(state.currentPath, move);
    final newPath = tuple.item1;
    if (newPath != null) {
      final newNodeList = IList(_gameTree.nodesOn(newPath));
      state = state.copyWith(
        currentPath: newPath,
        nodeList: newNodeList,
        lastMove: newNodeList.last.sanMove.move,
      );
    }
  }
}
