import 'dart:async';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    hide Tuple2;
import 'package:lichess_mobile/src/common/move_feedback.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/tree.dart';
import 'package:lichess_mobile/src/common/uci.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_preferences.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_session.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_difficulty.dart';

part 'puzzle_screen_model.g.dart';
part 'puzzle_screen_model.freezed.dart';

@riverpod
class PuzzleScreenModel extends _$PuzzleScreenModel {
  // ignore: avoid-late-keyword
  late Node _gameTree;
  Timer? _viewSolutionTimer;

  @override
  PuzzleScreenState build(PuzzleContext context) {
    final root = Root.fromPgn(context.puzzle.game.pgn);
    _gameTree = root.nodeAt(root.mainlinePath.penultimate) as Node;

    // play first move after 1 second
    Future<void>.delayed(const Duration(seconds: 1))
        .then((_) => _setPath(state.initialPath));

    final initialPath = UciPath.fromId(_gameTree.children.first.id);

    ref.onDispose(() {
      _viewSolutionTimer?.cancel();
    });

    return PuzzleScreenState(
      mode: PuzzleMode.play,
      initialPath: initialPath,
      currentPath: UciPath.empty,
      nodeList: IList([ViewNode.fromNode(_gameTree)]),
      pov: _gameTree.nodeAt(initialPath).ply.isEven ? Side.white : Side.black,
      resultSent: false,
      isChangingDifficulty: false,
    );
  }

  Future<void> playUserMove(Move move) async {
    _addMove(move);

    if (state.mode == PuzzleMode.play) {
      final movesToTest =
          state.nodeList.sublist(state.initialPath.size).map((e) => e.sanMove);

      final isGoodMove = context.puzzle.testSolution(movesToTest);

      if (isGoodMove) {
        state = state.copyWith(
          feedback: PuzzleFeedback.good,
        );

        final isCheckmate = movesToTest.last.san.endsWith('#');
        final nextUci =
            context.puzzle.puzzle.solution.getOrNull(movesToTest.length);
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
        );
        _sendResult(PuzzleResult.lose);
        await Future<void>.delayed(const Duration(milliseconds: 500));
        _setPath(state.currentPath.penultimate);
      }
    }
  }

  void userNext() {
    _viewSolutionTimer?.cancel();
    _goToNextNode();
  }

  void userPrevious() {
    _viewSolutionTimer?.cancel();
    _goToPreviousNode();
  }

  void viewSolution() {
    if (state.mode == PuzzleMode.view) return;

    _mergeSolution();

    state = state.copyWith(
      nodeList: IList(_gameTree.nodesOn(state.currentPath)),
    );

    _sendResult(PuzzleResult.lose);

    state = state.copyWith(
      mode: PuzzleMode.view,
    );

    _viewSolutionTimer =
        Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (state.canGoNext) {
        _goToNextNode();
      } else {
        timer.cancel();
      }
    });
  }

  Future<PuzzleContext?> changeDifficulty(PuzzleDifficulty difficulty) async {
    state = state.copyWith(
      isChangingDifficulty: true,
    );

    await ref
        .read(
          puzzlePreferencesProvider(context.userId).notifier,
        )
        .setDifficulty(difficulty);

    final nextPuzzle = await ref.read(defaultPuzzleServiceProvider).resetBatch(
          userId: context.userId,
          angle: context.theme,
        );

    state = state.copyWith(
      isChangingDifficulty: false,
    );

    return nextPuzzle;
  }

  // --

  void _goToNextNode() {
    if (state.node.children.isEmpty) return;
    _setPath(state.currentPath + state.node.children.first.id);
  }

  void _goToPreviousNode() {
    _setPath(state.currentPath.penultimate);
  }

  Future<void> _completePuzzle() async {
    state = state.copyWith(
      mode: PuzzleMode.view,
    );
    await _sendResult(state.result ?? PuzzleResult.win);
  }

  Future<void> _sendResult(PuzzleResult result) async {
    if (state.resultSent) return;

    state = state.copyWith(
      result: result,
      resultSent: true,
    );

    final sessionNotifier =
        puzzleSessionProvider(context.userId, context.theme).notifier;

    ref.read(sessionNotifier).addAttempt(
          context.puzzle.puzzle.id,
          win: result == PuzzleResult.win,
        );

    final service = ref.read(defaultPuzzleServiceProvider);

    final next = await service.solve(
      userId: context.userId,
      angle: context.theme,
      solution: PuzzleSolution(
        id: context.puzzle.puzzle.id,
        win: state.result == PuzzleResult.win,
        rated: context.userId != null,
      ),
    );

    final round = next?.rounds?.firstWhereOrNull(
      (p) => p.id == context.puzzle.puzzle.id,
    );
    if (round != null) {
      ref
          .read(sessionNotifier)
          .setRatingDiff(context.puzzle.puzzle.id, round.ratingDiff);
    }

    // We need to invalidate the next puzzle for the offline puzzle preview on
    // home screen tab and the healthy mix puzzle button on the puzzle screen tab.
    // Not the best solution because we must ensure to always provide a puzzle
    // parameter to the puzzle screen (PuzzleScreen must no be watching nextPuzzleProvider).
    // It would be better to have invalidate the `nextPuzzleProvider` when the
    // puzzle screen pops.
    if (context.theme == PuzzleTheme.mix) {
      ref.invalidate(nextPuzzleProvider(context.theme));
    }

    // TODO check if next is null and show a message

    state = state.copyWith(
      nextContext: next,
    );
  }

  void _setPath(UciPath path) {
    final newNodeList = IList(_gameTree.nodesOn(path));
    final sanMove = newNodeList.last.sanMove;
    final isForward = path.size > state.currentPath.size;
    if (isForward) {
      if (sanMove.san.contains('x')) {
        ref.read(moveFeedbackServiceProvider).captureFeedback();
      } else {
        ref.read(moveFeedbackServiceProvider).moveFeedback();
      }
    }
    state = state.copyWith(
      currentPath: path,
      nodeList: newNodeList,
      lastMove: sanMove.move,
    );
  }

  void _addMove(Move move) {
    final tuple = _gameTree.addMoveAt(
      state.currentPath,
      move,
      prepend: state.mode == PuzzleMode.play,
    );
    final newPath = tuple.item1;
    if (newPath != null) {
      _setPath(newPath);
    }
  }

  void _mergeSolution() {
    final initialNode = _gameTree.nodeAt(state.initialPath);
    final fromPly = initialNode.ply;
    final posAndNodes = context.puzzle.puzzle.solution.foldIndexed(
      Tuple2(initialNode.position, IList<Node>(const [])),
      (index, previous, uci) {
        final move = Move.fromUci(uci);
        final tuple = previous.item1.playToSan(move!);
        final newPos = tuple.item1;
        final newSan = tuple.item2;
        return Tuple2(
          newPos,
          previous.item2.add(
            Node(
              id: UciCharPair.fromMove(move),
              ply: fromPly + index,
              fen: newPos.fen,
              position: newPos,
              sanMove: SanMove(newSan, move),
            ),
          ),
        );
      },
    );
    _gameTree.addNodesAt(state.initialPath, posAndNodes.item2, prepend: true);
  }
}

enum PuzzleMode { play, view }

enum PuzzleResult { win, lose }

enum PuzzleFeedback { good, bad }

@freezed
class PuzzleScreenState with _$PuzzleScreenState {
  const PuzzleScreenState._();

  const factory PuzzleScreenState({
    required PuzzleMode mode,
    required UciPath initialPath,
    required UciPath currentPath,
    required Side pov,
    required IList<ViewNode> nodeList, // must be non empty
    Move? lastMove,
    PuzzleResult? result,
    PuzzleFeedback? feedback,
    required bool resultSent,
    required bool isChangingDifficulty,
    PuzzleContext? nextContext,
  }) = _PuzzleScreenState;

  ViewNode get node => nodeList.last;
  Position get position => nodeList.last.position;
  String get fen => nodeList.last.fen;
  bool get canGoNext => mode == PuzzleMode.view && node.children.isNotEmpty;
  bool get canGoBack =>
      mode == PuzzleMode.view && currentPath.size > initialPath.size;

  IMap<String, ISet<String>> get validMoves => algebraicLegalMoves(position);
}
