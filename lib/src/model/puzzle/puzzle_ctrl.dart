import 'dart:async';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/tree.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_streak.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_preferences.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_session.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_difficulty.dart';
import 'package:lichess_mobile/src/model/engine/engine_evaluation.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';

part 'puzzle_ctrl.g.dart';
part 'puzzle_ctrl.freezed.dart';

@riverpod
class PuzzleCtrl extends _$PuzzleCtrl {
  // ignore: avoid-late-keyword
  late Node _gameTree;
  Timer? _firstMoveTimer;
  Timer? _viewSolutionTimer;
  // on streak, we pre-load the next puzzle to avoid a delay when the user
  // completes the current one
  FutureResult<PuzzleContext?>? _nextPuzzleFuture;

  final _engineEvalDebounce = Debouncer(const Duration(milliseconds: 100));

  @override
  PuzzleCtrlState build(
    PuzzleContext initialContext, {
    PuzzleStreak? initialStreak,
  }) {
    ref.onDispose(() {
      _firstMoveTimer?.cancel();
      _viewSolutionTimer?.cancel();
      _engineEvalDebounce.dispose();
    });

    return _loadNewContext(initialContext, initialStreak);
  }

  PuzzleCtrlState _loadNewContext(
    PuzzleContext context,
    PuzzleStreak? streak,
  ) {
    final root = Root.fromPgn(context.puzzle.game.pgn);
    _gameTree = root.nodeAt(root.mainlinePath.penultimate) as Node;

    // play first move after 1 second
    _firstMoveTimer = Timer(const Duration(seconds: 1), () {
      _setPath(state.initialPath);
    });

    final initialPath = UciPath.fromId(_gameTree.children.first.id);

    // preload next streak puzzle
    if (streak != null) {
      _nextPuzzleFuture = _fetchNextStreakPuzzle(streak);
    }

    return PuzzleCtrlState(
      puzzle: context.puzzle,
      glicko: context.glicko,
      mode: PuzzleMode.play,
      initialFen: _gameTree.fen,
      initialPath: initialPath,
      currentPath: UciPath.empty,
      nodeList: IList([ViewNode.fromNode(_gameTree)]),
      pov: _gameTree.nodeAt(initialPath).ply.isEven ? Side.white : Side.black,
      resultSent: false,
      isChangingDifficulty: false,
      isLocalEvalEnabled: false,
      streak: streak,
      nextPuzzleStreakFetchError: false,
      nextPuzzleStreakFetchIsRetrying: false,
    );
  }

  Future<void> onUserMove(Move move) async {
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
        final nextUci =
            state.puzzle.puzzle.solution.getOrNull(movesToTest.length);
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
        _onFailOrWin(PuzzleResult.lose);
        if (initialStreak == null) {
          await Future<void>.delayed(const Duration(milliseconds: 500));
          _setPath(state.currentPath.penultimate);
        }
      }
    }
  }

  void userNext({bool hapticFeedback = true}) {
    _viewSolutionTimer?.cancel();
    _goToNextNode(replaying: true);
    if (hapticFeedback) HapticFeedback.lightImpact();
  }

  void userPrevious() {
    _viewSolutionTimer?.cancel();
    _goToPreviousNode(replaying: true);
  }

  void viewSolution() {
    if (state.mode == PuzzleMode.view) return;

    _mergeSolution();

    state = state.copyWith(
      nodeList: IList(_gameTree.nodesOn(state.currentPath)),
    );

    _onFailOrWin(PuzzleResult.lose);

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

  void skipMove() {
    if (state.streak != null) {
      state = state.copyWith.streak!(hasSkipped: true);
      final moveIndex = state.currentPath.size - state.initialPath.size;
      final solution = state.puzzle.puzzle.solution[moveIndex];
      onUserMove(Move.fromUci(solution)!);
    }
  }

  Future<PuzzleContext?> changeDifficulty(PuzzleDifficulty difficulty) async {
    state = state.copyWith(
      isChangingDifficulty: true,
    );

    await ref
        .read(
          puzzlePreferencesProvider(initialContext.userId).notifier,
        )
        .setDifficulty(difficulty);

    // ignore: avoid_manual_providers_as_generated_provider_dependency
    final nextPuzzle = await ref.read(defaultPuzzleServiceProvider).resetBatch(
          userId: initialContext.userId,
          angle: initialContext.theme,
        );

    state = state.copyWith(
      isChangingDifficulty: false,
    );

    return nextPuzzle;
  }

  void loadPuzzle(PuzzleContext nextContext) {
    state = _loadNewContext(nextContext, state.streak);
  }

  void sendStreakResult() {
    if (initialContext.userId != null) {
      final repo = ref.read(puzzleRepositoryProvider);
      final streak = state.streak?.index;
      if (streak != null && streak > 0) {
        repo.postStreakRun(streak);
      }
    }
  }

  FutureResult<PuzzleContext?> retryFetchNextStreakPuzzle(
    PuzzleStreak streak,
  ) async {
    state = state.copyWith(
      nextPuzzleStreakFetchIsRetrying: true,
    );

    final result = await _fetchNextStreakPuzzle(streak);

    state = state.copyWith(
      nextPuzzleStreakFetchIsRetrying: false,
    );

    result.match(
      onSuccess: (nextContext) {
        if (nextContext != null) {
          state = state.copyWith(
            streak: streak.copyWith(
              index: streak.index + 1,
            ),
          );
        } else {
          // no more puzzle
          state = state.copyWith(
            streak: streak.copyWith(
              index: streak.index + 1,
              finished: true,
            ),
          );
        }
      },
    );

    return result;
  }

  FutureResult<PuzzleContext?> _fetchNextStreakPuzzle(PuzzleStreak streak) {
    return streak.nextId != null
        ? ref.read(puzzleRepositoryProvider).fetch(streak.nextId!).map(
              (puzzle) => PuzzleContext(
                theme: PuzzleTheme.mix,
                puzzle: puzzle,
                userId: initialContext.userId,
              ),
            )
        : Future.value(Result.value(null));
  }

  void _goToNextNode({bool replaying = false}) {
    if (state.node.children.isEmpty) return;
    _setPath(
      state.currentPath + state.node.children.first.id,
      replaying: replaying,
    );
  }

  void _goToPreviousNode({bool replaying = false}) {
    _setPath(state.currentPath.penultimate, replaying: replaying);
  }

  Future<void> _completePuzzle() async {
    state = state.copyWith(
      mode: PuzzleMode.view,
    );
    await _onFailOrWin(state.result ?? PuzzleResult.win);
  }

  Future<void> _onFailOrWin(PuzzleResult result) async {
    if (state.resultSent) return;

    state = state.copyWith(
      result: result,
      resultSent: true,
    );

    final sessionNotifier =
        puzzleSessionProvider(initialContext.userId, initialContext.theme)
            .notifier;

    // ignore: avoid_manual_providers_as_generated_provider_dependency
    final service = ref.read(defaultPuzzleServiceProvider);
    final soundService = ref.read(soundServiceProvider);

    if (state.streak == null) {
      final next = await service.solve(
        userId: initialContext.userId,
        angle: initialContext.theme,
        puzzle: state.puzzle,
        solution: PuzzleSolution(
          id: state.puzzle.puzzle.id,
          win: state.result == PuzzleResult.win,
          rated: initialContext.userId != null,
        ),
      );

      state = state.copyWith(
        nextContext: next,
      );

      // ignore: avoid_manual_providers_as_generated_provider_dependency
      ref.read(sessionNotifier).addAttempt(
            state.puzzle.puzzle.id,
            win: result == PuzzleResult.win,
          );

      final rounds = next?.rounds;
      if (rounds != null) {
        // ignore: avoid_manual_providers_as_generated_provider_dependency
        ref.read(sessionNotifier).setRatingDiffs(rounds);
      }
    } else {
      // one fail and streak is over
      if (result == PuzzleResult.lose) {
        soundService.play(Sound.error);
        await Future<void>.delayed(const Duration(milliseconds: 500));
        _setPath(state.currentPath.penultimate);
        _mergeSolution();
        state = state.copyWith(
          mode: PuzzleMode.view,
          nodeList: IList(_gameTree.nodesOn(state.currentPath)),
          streak: state.streak!.copyWith(
            finished: true,
          ),
        );
        sendStreakResult();
      } else {
        if (_nextPuzzleFuture == null) {
          assert(false, 'next puzzle future cannot be null with streak');
        } else {
          final result = await _nextPuzzleFuture!;
          result.match(
            onSuccess: (nextContext) async {
              state = state.copyWith.streak!(
                index: state.streak!.index + 1,
              );
              if (nextContext != null) {
                await Future<void>.delayed(const Duration(milliseconds: 250));
                soundService.play(Sound.confirmation);
                loadPuzzle(nextContext);
              } else {
                // no more puzzle
                state = state.copyWith.streak!(
                  finished: true,
                );
              }
            },
            onError: (error, _) {
              state = state.copyWith(
                nextPuzzleStreakFetchError: true,
              );
            },
          );
        }
      }
    }
  }

  void _setPath(UciPath path, {bool replaying = false}) {
    final pathChange = state.currentPath != path;
    final newNodeList = IList(_gameTree.nodesOn(path));
    final sanMove = newNodeList.last.sanMove;
    if (!replaying) {
      final isForward = path.size > state.currentPath.size;
      if (isForward) {
        final isCheck = sanMove.san.contains('+');
        if (sanMove.san.contains('x')) {
          ref.read(moveFeedbackServiceProvider).captureFeedback(check: isCheck);
        } else {
          ref.read(moveFeedbackServiceProvider).moveFeedback(check: isCheck);
        }
      }
    } else {
      // when replaying moves fast we don't want haptic feedback
      final soundService = ref.read(soundServiceProvider);
      if (sanMove.san.contains('x')) {
        soundService.stopCurrent();
        soundService.play(Sound.capture);
      } else {
        soundService.stopCurrent();
        soundService.play(Sound.move);
      }
    }
    state = state.copyWith(
      currentPath: path,
      nodeList: newNodeList,
      lastMove: sanMove.move,
    );

    if (pathChange) {
      _startEngineEval();
    }
  }

  void toggleLocalEvaluation() {
    state = state.copyWith(
      isLocalEvalEnabled: !state.isLocalEvalEnabled,
    );
    if (state.isLocalEvalEnabled) {
      _startEngineEval();
    } else {
      ref
          .read(
            engineEvaluationProvider(state.evaluationContext).notifier,
          )
          .stop();
    }
  }

  void _startEngineEval() {
    if (!state.isEngineEnabled) return;
    _engineEvalDebounce(
      () => ref
          .read(
            engineEvaluationProvider(state.evaluationContext).notifier,
          )
          .start(
            state.currentPath,
            state.nodeList.map(Step.fromNode),
            shouldEmit: (work) => work.path == state.currentPath,
          )
          ?.forEach((t) {
        final (work, eval) = t;
        _gameTree.updateAt(work.path, (node) {
          node.eval = eval;
        });
      }),
    );
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
    final fromPly = initialNode.ply;
    final (_, newNodes) = state.puzzle.puzzle.solution.foldIndexed(
      (initialNode.position, IList<Node>(const [])),
      (index, previous, uci) {
        final move = Move.fromUci(uci);
        final (pos, nodes) = previous;
        final (newPos, newSan) = pos.playToSan(move!);
        return (
          newPos,
          nodes.add(
            Node(
              id: UciCharPair.fromMove(move),
              ply: fromPly + index + 1,
              fen: newPos.fen,
              position: newPos,
              sanMove: SanMove(newSan, move),
            ),
          ),
        );
      },
    );
    _gameTree.addNodesAt(state.initialPath, newNodes, prepend: true);
  }
}

enum PuzzleMode { play, view }

enum PuzzleResult { win, lose }

enum PuzzleFeedback { good, bad }

@freezed
class PuzzleCtrlState with _$PuzzleCtrlState {
  const PuzzleCtrlState._();

  const factory PuzzleCtrlState({
    required Puzzle puzzle,
    required PuzzleGlicko? glicko,
    required PuzzleMode mode,
    required String initialFen,
    required UciPath initialPath,
    required UciPath currentPath,
    required Side pov,
    required IList<ViewNode> nodeList, // must be non empty
    Move? lastMove,
    PuzzleResult? result,
    PuzzleFeedback? feedback,
    required bool isLocalEvalEnabled,
    required bool resultSent,
    required bool isChangingDifficulty,
    PuzzleContext? nextContext,
    PuzzleStreak? streak,
    // if the automatic attempt to fetch the next puzzle in the streak fails
    // we will make the user retry
    required bool nextPuzzleStreakFetchError,
    required bool nextPuzzleStreakFetchIsRetrying,
  }) = _PuzzleScreenState;

  bool get isEngineEnabled {
    return mode == PuzzleMode.view && isLocalEvalEnabled;
  }

  EvaluationContext get evaluationContext => EvaluationContext(
        variant: Variant.standard,
        initialFen: initialFen,
        contextId: puzzle.puzzle.id,
      );

  ViewNode get node => nodeList.last;
  Position get position => nodeList.last.position;
  String get fen => nodeList.last.fen;
  bool get canGoNext => mode == PuzzleMode.view && node.children.isNotEmpty;
  bool get canGoBack =>
      mode == PuzzleMode.view && currentPath.size > initialPath.size;

  IMap<String, ISet<String>> get validMoves => algebraicLegalMoves(position);
}
