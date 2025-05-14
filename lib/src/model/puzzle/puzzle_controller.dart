import 'dart:async';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_mixin.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_difficulty.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_preferences.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_session.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'puzzle_controller.freezed.dart';
part 'puzzle_controller.g.dart';

@riverpod
class PuzzleController extends _$PuzzleController with EngineEvaluationMixin {
  static final Uri socketUri = Uri(path: '/analysis/socket/v5');

  late Branch _gameTree;
  Timer? _firstMoveTimer;
  Timer? _viewSolutionTimer;

  @override
  @protected
  EngineEvaluationPrefState get evaluationPrefs => ref.read(engineEvaluationPreferencesProvider);

  @override
  @protected
  EngineEvaluationPreferences get evaluationPreferencesNotifier =>
      ref.read(engineEvaluationPreferencesProvider.notifier);

  @override
  @protected
  EvaluationService evaluationServiceFactory() => ref.read(evaluationServiceProvider);

  @override
  @protected
  PuzzleState get evaluationState => state;

  @override
  @protected
  SocketClient? socketClient;

  @override
  @protected
  Branch get positionTree => _gameTree;

  Future<PuzzleService> get _service =>
      ref.read(puzzleServiceFactoryProvider)(queueLength: kPuzzleLocalQueueLength);

  @override
  PuzzleState build(PuzzleContext initialContext, {bool isPuzzleStreak = false}) {
    initEngineEvaluation();

    ref.onDispose(() {
      _firstMoveTimer?.cancel();
      _viewSolutionTimer?.cancel();
      disposeEngineEvaluation();
    });

    // we might not have the user rating yet so let's update it now
    // then it will be updated on each puzzle completion
    if (initialContext.userId != null) {
      _updateUserRating();
    }

    return _loadNewContext(initialContext);
  }

  PuzzleRepository _repository(LichessClient client) => PuzzleRepository(client);

  Future<void> _updateUserRating() async {
    try {
      final data = await ref.withClient((client) => _repository(client).selectBatch(nb: 0));
      final glicko = data.glicko;
      if (glicko != null) {
        state = state.copyWith(glicko: glicko);
      }
    } catch (_) {}
  }

  PuzzleState _loadNewContext(PuzzleContext context) {
    final root = Root.fromPgnMoves(context.puzzle.game.pgn);
    _gameTree = root.nodeAt(root.mainlinePath.penultimate) as Branch;

    // play first move after 1 second
    _firstMoveTimer = Timer(const Duration(seconds: 1), () {
      _setPath(state.initialPath, firstMove: true);
    });

    final initialPath = UciPath.fromId(_gameTree.children.first.id);

    return PuzzleState(
      puzzle: context.puzzle,
      glicko: context.glicko,
      mode: PuzzleMode.load,
      initialPosition: _gameTree.position,
      initialPath: initialPath,
      currentPath: UciPath.empty,
      node: _gameTree.view,
      pov: _gameTree.nodeAt(initialPath).position.ply.isEven ? Side.white : Side.black,
      hintShown: false,
      resultSent: false,
      isChangingDifficulty: false,
      shouldBlinkNextArrow: false,
      isEvaluationEnabled: false,
    );
  }

  Future<void> toggleEvaluation() async {
    state = state.copyWith(isEvaluationEnabled: !state.isEvaluationEnabled);
    if (state.isEvaluationEnabled) {
      requestEval();
    } else {
      await ref.read(evaluationServiceProvider).disposeEngine();
    }
  }

  Future<void> onUserMove(NormalMove move) async {
    if (isPromotionPawnMove(state.currentPosition, move)) {
      state = state.copyWith(promotionMove: move);
      return;
    }

    _addMove(move);

    if (state.mode == PuzzleMode.play) {
      state = state.copyWith(hintSquare: null);
      final nodeList = _gameTree.branchesOn(state.currentPath).toList();
      final movesToTest = nodeList.sublist(state.initialPath.size).map((e) => e.sanMove);

      final isGoodMove = state.puzzle.testSolution(movesToTest);

      if (isGoodMove) {
        state = state.copyWith(feedback: PuzzleFeedback.good);

        final isCheckmate = movesToTest.last.san.endsWith('#');
        final nextUci = state.puzzle.puzzle.solution.getOrNull(movesToTest.length);
        // checkmate is always a win
        if (isCheckmate) {
          _completePuzzle();
        }
        // another puzzle move: let's continue
        else if (nextUci != null) {
          await Future<void>.delayed(const Duration(milliseconds: 500));
          _addMove(Move.parse(nextUci)!);
        }
        // no more puzzle move: it's a win
        else {
          _completePuzzle();
        }
      } else {
        state = state.copyWith(feedback: PuzzleFeedback.bad);
        _onFailOrWin(PuzzleResult.lose);
        if (!isPuzzleStreak) {
          await Future<void>.delayed(const Duration(milliseconds: 500));
          _setPath(state.currentPath.penultimate);
        }
      }
    }
  }

  void onPromotionSelection(Role? role) {
    if (role == null) {
      state = state.copyWith(promotionMove: null);
      return;
    }
    final promotionMove = state.promotionMove;
    if (promotionMove != null) {
      final move = promotionMove.withPromotion(role);
      onUserMove(move);
    }
  }

  void userNext() {
    _viewSolutionTimer?.cancel();
    _goToNextNode(isNavigating: true);
  }

  void userPrevious() {
    _viewSolutionTimer?.cancel();
    _goToPreviousNode(isNavigating: true);
  }

  void viewSolution() {
    if (state.mode == PuzzleMode.view) return;

    _mergeSolution();

    state = state.copyWith(node: _gameTree.branchAt(state.currentPath).view);

    _onFailOrWin(PuzzleResult.lose);

    state = state.copyWith(mode: PuzzleMode.view);

    _viewSolutionTimer = Timer(const Duration(milliseconds: 800), () {
      _goToNextNode();

      if (state.canGoNext) {
        state = state.copyWith(shouldBlinkNextArrow: true);
      }
    });
  }

  void toggleHint() {
    if (state.hintSquare == null && state._nextSolutionMove != null) {
      state = state.copyWith(hintShown: true, hintSquare: state._nextSolutionMove!.from);
    } else {
      state = state.copyWith(hintSquare: null);
    }
  }

  void skipMove() {
    if (isPuzzleStreak && state._nextSolutionMove != null) {
      onUserMove(state._nextSolutionMove!);
    }
  }

  Future<PuzzleContext?> changeDifficulty(PuzzleDifficulty difficulty) async {
    state = state.copyWith(isChangingDifficulty: true);

    await ref.read(puzzlePreferencesProvider.notifier).setDifficulty(difficulty);

    final nextPuzzle = (await _service).resetBatch(
      userId: initialContext.userId,
      angle: initialContext.angle,
    );

    state = state.copyWith(isChangingDifficulty: false);

    return nextPuzzle;
  }

  void onLoadPuzzle(PuzzleContext nextContext) {
    ref.read(evaluationServiceProvider).disposeEngine();

    state = _loadNewContext(nextContext);
  }

  void _goToNextNode({bool isNavigating = false}) {
    if (state.node.children.isEmpty) return;
    _setPath(state.currentPath + state.node.children.first.id, isNavigating: isNavigating);
  }

  void _goToPreviousNode({bool isNavigating = false}) {
    _setPath(state.currentPath.penultimate, isNavigating: isNavigating);
  }

  Future<void> _completePuzzle() async {
    state = state.copyWith(mode: PuzzleMode.view);
    await _onFailOrWin(state.result ?? PuzzleResult.win);
  }

  Future<void> _onFailOrWin(PuzzleResult result) async {
    if (state.resultSent) return;

    state = state.copyWith(result: result, resultSent: true);

    final soundService = ref.read(soundServiceProvider);

    if (isPuzzleStreak) {
      // one fail and streak is over
      if (result == PuzzleResult.lose) {
        soundService.play(Sound.error);
        await Future<void>.delayed(const Duration(milliseconds: 500));
        _setPath(state.currentPath.penultimate);
        _mergeSolution();
        state = state.copyWith(
          mode: PuzzleMode.view,
          node: _gameTree.branchAt(state.currentPath).view,
        );
      }
    } else {
      final next = await (await _service).solve(
        userId: initialContext.userId,
        angle: initialContext.angle,
        puzzle: state.puzzle,
        solution: PuzzleSolution(
          id: state.puzzle.puzzle.id,
          win: state.result == PuzzleResult.win,
          rated:
              initialContext.userId != null &&
              !state.hintShown &&
              ref.read(puzzlePreferencesProvider).rated,
        ),
      );

      state = state.copyWith(nextContext: next);

      ref
          .read(puzzleSessionProvider(initialContext.userId, initialContext.angle).notifier)
          .addAttempt(state.puzzle.puzzle.id, win: result == PuzzleResult.win);

      final rounds = next?.rounds;
      if (rounds != null) {
        ref
            .read(puzzleSessionProvider(initialContext.userId, initialContext.angle).notifier)
            .setRatingDiffs(rounds);
      }

      if (next != null &&
          result == PuzzleResult.win &&
          ref.read(puzzlePreferencesProvider).autoNext) {
        onLoadPuzzle(next);
      }
    }
  }

  void _setPath(UciPath path, {bool isNavigating = false, bool firstMove = false}) {
    final pathChange = state.currentPath != path;
    final newNode = _gameTree.branchAt(path).view;
    final sanMove = newNode.sanMove;
    if (!isNavigating) {
      final isForward = path.size > state.currentPath.size;
      if (isForward) {
        final isCheck = sanMove.isCheck;
        if (sanMove.isCapture) {
          ref.read(moveFeedbackServiceProvider).captureFeedback(check: isCheck);
        } else {
          ref.read(moveFeedbackServiceProvider).moveFeedback(check: isCheck);
        }
      }
    } else {
      // when isNavigating moves fast we don't want haptic feedback
      final soundService = ref.read(soundServiceProvider);
      if (sanMove.isCapture) {
        soundService.play(Sound.capture);
      } else {
        soundService.play(Sound.move);
      }
    }
    state = state.copyWith(
      mode: firstMove ? PuzzleMode.play : state.mode,
      currentPath: path,
      node: newNode,
      lastMove: sanMove.move,
      promotionMove: null,
      shouldBlinkNextArrow: false,
    );

    if (pathChange) requestEval();
  }

  String makePgn() {
    final initPosition = _gameTree.nodeAt(state.initialPath).position;
    var currentPosition = initPosition;
    final pgnMoves = state.puzzle.puzzle.solution.fold<List<String>>([], (List<String> acc, move) {
      final moveObj = Move.parse(move);
      if (moveObj != null) {
        final String san;
        (currentPosition, san) = currentPosition.makeSan(moveObj);
        return acc..add(san);
      }
      return acc;
    });
    final pgn =
        '[FEN "${initPosition.fen}"][Site "${lichessUri('/training/${state.puzzle.puzzle.id}')}"]${pgnMoves.join(' ')}';
    return pgn;
  }

  void _addMove(Move move) {
    final (newPath, _) = _gameTree.addMoveAt(
      state.currentPath,
      move,
      prepend: state.mode == PuzzleMode.play,
    );
    if (newPath != null) {
      _setPath(newPath);
    }
  }

  void _mergeSolution() {
    final initialNode = _gameTree.nodeAt(state.initialPath);
    final (_, newNodes) = state.puzzle.puzzle.solution.foldIndexed(
      (initialNode.position, IList<Branch>(const [])),
      (index, previous, uci) {
        final move = Move.parse(uci);
        final (pos, nodes) = previous;
        final (newPos, newSan) = pos.makeSan(move!);
        return (newPos, nodes.add(Branch(position: newPos, sanMove: SanMove(newSan, move))));
      },
    );
    _gameTree.addNodesAt(state.initialPath, newNodes, prepend: true);
  }
}

enum PuzzleMode { load, play, view }

enum PuzzleResult { win, lose }

enum PuzzleFeedback { good, bad }

@freezed
sealed class PuzzleState with _$PuzzleState implements EvaluationMixinState {
  const PuzzleState._();

  const factory PuzzleState({
    required Puzzle puzzle,
    required PuzzleGlicko? glicko,
    required PuzzleMode mode,
    required Position initialPosition,
    required UciPath initialPath,
    required UciPath currentPath,
    required Side pov,
    required ViewBranch node,
    Move? lastMove,
    NormalMove? promotionMove,
    PuzzleResult? result,
    PuzzleFeedback? feedback,
    required bool hintShown,
    Square? hintSquare,
    required bool resultSent,
    required bool isChangingDifficulty,
    required bool shouldBlinkNextArrow,
    required bool isEvaluationEnabled,
    PuzzleContext? nextContext,
  }) = _PuzzleState;

  @override
  bool get alwaysRequestCloudEval => false;

  @override
  bool isEngineAvailable(EngineEvaluationPrefState _) =>
      mode == PuzzleMode.view && isEvaluationEnabled;

  @override
  EvaluationContext get evaluationContext =>
      EvaluationContext(variant: Variant.standard, initialPosition: initialPosition);

  @override
  Position get currentPosition => node.position;

  String get fen => node.position.fen;

  bool get canGoNext => mode == PuzzleMode.view && node.children.isNotEmpty;

  bool get canGoBack => mode == PuzzleMode.view && currentPath.size > initialPath.size;

  NormalMove? get _nextSolutionMove {
    final uci = puzzle.puzzle.solution.getOrNull(currentPath.size - initialPath.size);
    return uci == null ? null : NormalMove.fromUci(uci);
  }
}
