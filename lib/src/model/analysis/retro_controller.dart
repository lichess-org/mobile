import 'dart:async';
import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/common_analysis_state.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_mixin.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/explorer/opening_explorer_preferences.dart';
import 'package:lichess_mobile/src/model/explorer/opening_explorer_repository.dart';
import 'package:lichess_mobile/src/model/game/exported_game.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'retro_controller.freezed.dart';
part 'retro_controller.g.dart';

typedef RetroOptions = ({GameId id, Side initialSide});

final Logger _logger = Logger('RetroController');

@freezed
sealed class Mistake with _$Mistake {
  const Mistake._();

  const factory Mistake({
    required ViewBranch branch,
    @Default(IList<UCIMove>.empty()) IList<UCIMove> openingExplorerSolutions,
  }) = _Mistake;

  ViewBranch get userBranch => branch.children[0];
  NormalMove get userMove => userBranch.sanMove.move as NormalMove;

  ViewBranch get serverBranch => branch.children[1];
  NormalMove get serverMove => serverBranch.sanMove.move as NormalMove;

  bool isSolution(RetroCurrentNode node) =>
      node.position == serverBranch.position ||
      node.position.isCheckmate ||
      // Any move that was found in the master's database is also considered a solution.
      openingExplorerSolutions.contains(node.sanMove!.move.uci);
}

/// Depth needed to evaluate alternative solution moves.
///
/// https://github.com/lichess-org/lila/blob/d29f27d8cbb0e0dac38308c23c63b828028c085f/ui/analyse/src/retrospect/retroCtrl.ts#L151
const double _kEvalDepthThreshold = kDebugMode ? 12 : 18;

/// Threshold for considering a move a correct alternative solution.
///
/// When checking a move that is not the server solution,
/// consider it a correct move if the eval difference is above this threshold,
/// i.e. the move does not make the position significantly worse.
/// https://github.com/lichess-org/lila/blob/d29f27d8cbb0e0dac38308c23c63b828028c085f/ui/analyse/src/retrospect/retroCtrl.ts#L161
const double _kCorrectMovePovDiffThreshold = -0.04;

/// Logic is based on the `RetroCtrl` class in the lila frontend.
@riverpod
class RetroController extends _$RetroController with EngineEvaluationMixin {
  late Root _root;

  late ExportedGame _game;

  @override
  @protected
  EngineEvaluationPrefState get evaluationPrefs =>
      state.valueOrNull?.feedback == RetroFeedback.evalMove
      // Increase search time to make sure we reach the limit for deciding whether the move
      // is good enough to be considered an alternative solution.
      ? ref
            .read(engineEvaluationPreferencesProvider)
            .copyWith(engineSearchTime: kMaxEngineSearchTime)
      : ref.read(engineEvaluationPreferencesProvider);

  @override
  @protected
  EngineEvaluationPreferences get evaluationPreferencesNotifier =>
      ref.read(engineEvaluationPreferencesProvider.notifier);

  @override
  @protected
  EvaluationService evaluationServiceFactory() => ref.read(evaluationServiceProvider);

  @override
  @protected
  EvaluationMixinState get evaluationState => state.requireValue;

  @override
  @protected
  late SocketClient socketClient;

  @override
  @protected
  Node get positionTree => _root;

  @override
  Future<RetroState> build(RetroOptions options) async {
    ref.onDispose(() {
      disposeEngineEvaluation();
    });

    socketClient = ref.watch(socketPoolProvider).open(AnalysisController.socketUri);

    _game = await ref.read(archivedGameProvider(id: options.id).future);
    _root = _game.makeTree();

    initEngineEvaluation();

    // We need to define the state value in the build method because `requestEval` require the state
    // to have a value.
    state = AsyncData(await _initState(options.initialSide));

    socketClient.firstConnection.then((_) {
      requestEval();
    });

    return state.requireValue;
  }

  Future<RetroState> _initState(Side side) async {
    final mistakes = (await Future.wait(
      _root.view.mainline.map((branch) async {
        if (branch.position.turn != side || branch.children.isEmpty) {
          return null;
        }

        final eval = branch.serverEval;
        final newEval = branch.children.first.serverEval;

        if (eval == null || newEval == null) {
          return null;
        }

        // https://github.com/lichess-org/lila/blob/d29f27d8cbb0e0dac38308c23c63b828028c085f/ui/analyse/src/nodeFinder.ts#L26
        final bigEvalSwing = Eval.winningChancesPovDiff(side, eval, newEval).abs() > 0.1;

        final lostEasyMate = eval.mate != null && newEval.mate == null && eval.mate!.abs() <= 3;

        final hasSolution = branch.children.length > 1;

        final isMistake = (bigEvalSwing || lostEasyMate) && hasSolution;
        if (!isMistake) return null;

        var openingExplorerSolutions = const IList<UCIMove>.empty();
        final middlegame = _game.meta.division?.middlegame;
        if (middlegame == null || branch.position.ply + 1 < middlegame) {
          try {
            final entry = await ref
                .read(openingExplorerRepositoryProvider)
                .getMasterDatabase(branch.position.fen, since: MasterDb.kEarliestYear);

            // https://github.com/lichess-org/lila/blob/d28f27d8cbb0e0dac38308c23c63b828028c085f/ui/analyse/src/retrospect/retroCtrl.ts#L108
            final masterMovesPlayedMoreThanOnce = entry.moves.where(
              (move) => move.white + move.draws + move.black > 1,
            );
            // If we find this move in a master's game, be generous and not consider it a mistake.
            if (masterMovesPlayedMoreThanOnce.any(
              (move) => move.uci == branch.children.first.sanMove.move.uci,
            )) {
              return null;
            }

            openingExplorerSolutions = masterMovesPlayedMoreThanOnce
                .map((move) => move.uci)
                .toIList();
          } catch (e, st) {
            _logger.warning(
              'Failed to fetch opening explorer data for ply ${branch.position.ply}',
              e,
              st,
            );
          }
        }

        return Mistake(branch: branch, openingExplorerSolutions: openingExplorerSolutions);
      }),
    )).nonNulls.toIList();

    return RetroState(
      mistakes: mistakes.toIList(),
      currentMistakeIndex: 0,
      feedback: mistakes.isNotEmpty ? RetroFeedback.findMove : RetroFeedback.done,
      mainlinePath: _root.mainlinePath,
      pov: side,
      currentNode: RetroCurrentNode.fromNode(mistakes.firstOrNull?.branch ?? _root.view),
      lastMove: mistakes.firstOrNull?.branch.sanMove.move,
      variant: Variant.standard,
      evaluationContext: EvaluationContext(
        variant: Variant.standard,
        initialPosition: _root.position,
      ),
      root: _root.view,
      currentPath: mistakes.isNotEmpty
          ? _root.mainlinePath.truncate(mistakes[0].branch.position.ply)
          : UciPath.empty,
    );
  }

  void onUserMove(NormalMove move) {
    if (!state.requireValue.currentPosition!.isLegal(move)) return;

    if (isPromotionPawnMove(state.requireValue.currentPosition!, move)) {
      state = AsyncValue.data(state.requireValue.copyWith(promotionMove: move));
      return;
    }

    final (newPath, isNewNode) = _root.addMoveAt(state.requireValue.currentPath, move);
    if (newPath != null) {
      _setPath(newPath, shouldRecomputeRootView: isNewNode, shouldForceShowVariation: true);
    }
  }

  void onPromotionSelection(Role? role) {
    final state = this.state.valueOrNull;
    if (state == null) return;

    if (role == null) {
      this.state = AsyncValue.data(state.copyWith(promotionMove: null));
      return;
    }
    final promotionMove = state.promotionMove;
    if (promotionMove != null) {
      final promotion = promotionMove.withPromotion(role);
      onUserMove(promotion);
    }
  }

  void userNext() {
    _setPath(
      state.requireValue.currentPath +
          _root.nodeAt(state.requireValue.currentPath).children.first.id,
      isNavigating: true,
    );
  }

  void userPrevious() {
    _setPath(state.requireValue.currentPath.penultimate, isNavigating: true);
  }

  void viewSolution() {
    final currentMistake = state.valueOrNull?.currentMistake;
    if (currentMistake != null) {
      onUserMove(currentMistake.serverMove);
      state = AsyncValue.data(state.requireValue.copyWith(feedback: RetroFeedback.viewingSolution));
    }
  }

  Future<void> flipSide() async {
    state = AsyncValue.data(await _initState(state.requireValue.pov.opposite));
  }

  void restart() {
    _showMistake(0);
  }

  void nextMistake() {
    _showMistake(state.requireValue.currentMistakeIndex + 1);
  }

  void _showMistake(int index) {
    final nextMistake = state.requireValue.mistakes.getOrNull(index);
    final lastMistake = state.requireValue.mistakes.lastOrNull;

    _setPath(
      _root.mainlinePath.truncate(
        nextMistake?.branch.position.ply ??
            lastMistake?.branch.position.ply ??
            _root.mainlinePath.size,
      ),
    );

    state = AsyncValue.data(
      state.requireValue.copyWith(
        currentMistakeIndex: index,
        currentNode: RetroCurrentNode.fromNode(
          nextMistake?.branch ?? lastMistake?.branch ?? _root.view,
        ),
        feedback: nextMistake != null ? RetroFeedback.findMove : RetroFeedback.done,
      ),
    );
  }

  void _setPath(
    UciPath path, {
    bool shouldForceShowVariation = false,
    bool shouldRecomputeRootView = false,

    /// Whether the user is navigating through the moves (as opposed to playing a move).
    bool isNavigating = false,
  }) {
    final state = this.state.valueOrNull;
    if (state == null) return;

    final pathChange = state.currentPath != path;
    final currentNode = _root.nodeAt(path);

    // always show variation if the user plays a move
    if (shouldForceShowVariation && currentNode is Branch && currentNode.isCollapsed) {
      _root.updateAt(path, (node) {
        if (node is Branch) node.isCollapsed = false;
      });
    }

    // root view is only used to display move list, so we need to
    // recompute the root view only when the nodelist length changes
    // or a variation is hidden/shown
    final rootView = shouldForceShowVariation || shouldRecomputeRootView ? _root.view : state.root;

    final isForward = path.size > state.currentPath.size;
    if (currentNode is Branch) {
      // normal move feedback
      if (!isNavigating && isForward) {
        final isCheck = currentNode.sanMove.isCheck;
        if (currentNode.sanMove.isCapture) {
          ref.read(moveFeedbackServiceProvider).captureFeedback(check: isCheck);
        } else {
          ref.read(moveFeedbackServiceProvider).moveFeedback(check: isCheck);
        }
      }
      // if navigating, only sound feedback
      else {
        final soundService = ref.read(soundServiceProvider);
        if (currentNode.sanMove.isCapture) {
          soundService.play(Sound.capture);
        } else {
          soundService.play(Sound.move);
        }
      }

      this.state = AsyncValue.data(
        state.copyWith(
          currentPath: path,
          currentNode: RetroCurrentNode.fromNode(currentNode.view),
          lastMove: currentNode.sanMove.move,
          promotionMove: null,
          root: rootView,
        ),
      );
    } else {
      this.state = AsyncValue.data(
        state.copyWith(
          currentPath: path,
          currentNode: RetroCurrentNode.fromNode(currentNode.view),
          lastMove: null,
          promotionMove: null,
          root: rootView,
        ),
      );
    }

    if (pathChange) {
      requestEval();
    }

    _updateFeedback();
  }

  void _onIncorrectMove() {
    state = AsyncValue.data(state.requireValue.copyWith(feedback: RetroFeedback.incorrect));
    userPrevious();
  }

  void _onCorrectMove() {
    state = AsyncValue.data(state.requireValue.copyWith(feedback: RetroFeedback.correct));
  }

  @override
  void onCurrentPathEvalChanged(bool isSameEvalString) {
    _refreshCurrentNode(recomputeRootView: !isSameEvalString);

    if (state.requireValue.feedback == RetroFeedback.evalMove) {
      final eval = state.requireValue.currentNode.eval;
      if (eval == null) return;

      // https://github.com/lichess-org/lila/blob/d29f27d8cbb0e0dac38308c23c63b828028c085f/ui/analyse/src/retrospect/retroCtrl.ts#L151
      if (eval.depth >= _kEvalDepthThreshold ||
          (eval.depth >= 14 && state.requireValue.evalTime!.inSeconds > 6)) {
        final diff = Eval.winningChancesPovDiff(
          state.requireValue.pov,
          eval,
          state.requireValue.currentMistake!.branch.serverEval!,
        );

        if (diff > _kCorrectMovePovDiffThreshold) {
          _onCorrectMove();
        } else {
          _onIncorrectMove();
        }

        // We used unlimited search time during Feedback.evalMove,
        // now restart evaluation with normal search time (effectively stopping it for this move)
        requestEval();
      }
    }
  }

  void _refreshCurrentNode({bool recomputeRootView = false}) {
    state = AsyncData(
      state.requireValue.copyWith(
        root: recomputeRootView ? _root.view : state.requireValue.root,
        currentNode: RetroCurrentNode.fromNode(_root.nodeAt(state.requireValue.currentPath).view),
      ),
    );
  }

  void _updateFeedback() {
    final state = this.state.requireValue;
    switch (state.feedback) {
      case RetroFeedback.incorrect:
      case RetroFeedback.findMove:
        if (state.currentPosition!.ply == state.currentMistake!.serverBranch.position.ply) {
          if (state.currentMistake!.isSolution(state.currentNode)) {
            _onCorrectMove();
          } else if (state.currentPosition == state.currentMistake!.userBranch.position) {
            Timer(const Duration(milliseconds: 500), () {
              _onIncorrectMove();
            });
          } else {
            this.state = AsyncValue.data(
              state.copyWith(feedback: RetroFeedback.evalMove, evalRequestedAt: DateTime.now()),
            );
            requestEval();
          }
        }
      case _:
    }
  }
}

enum RetroFeedback { findMove, evalMove, correct, incorrect, viewingSolution, done }

@freezed
sealed class RetroState with _$RetroState implements EvaluationMixinState, CommonAnalysisState {
  const RetroState._();

  const factory RetroState({
    required IList<Mistake> mistakes,
    required int currentMistakeIndex,
    required RetroFeedback feedback,
    required UciPath mainlinePath,
    required Side pov,
    required RetroCurrentNode currentNode,
    required Variant variant,
    required UciPath currentPath,
    required EvaluationContext evaluationContext,
    required ViewRoot root,
    DateTime? evalRequestedAt,
    Move? lastMove,
    NormalMove? promotionMove,
  }) = _RetroState;

  @override
  bool get alwaysRequestCloudEval => false;

  bool get isSolving =>
      feedback == RetroFeedback.findMove ||
      feedback == RetroFeedback.incorrect ||
      feedback == RetroFeedback.evalMove;

  Duration? get evalTime =>
      evalRequestedAt != null ? DateTime.now().difference(evalRequestedAt!) : null;

  double get evalProgress => feedback == RetroFeedback.evalMove && currentNode.eval != null
      ? min(1.0, currentNode.eval!.depth / _kEvalDepthThreshold)
      : 0.0;

  @override
  Position? get currentPosition => currentNode.position;

  @override
  bool isEngineAvailable(EngineEvaluationPrefState prefs) => true;

  bool get hasMistakes => mistakes.isNotEmpty;

  Mistake? get currentMistake => mistakes.getOrNull(currentMistakeIndex);

  EngineGaugeParams get engineGaugeParams => (
    isLocalEngineAvailable: true,
    orientation: pov,
    position: currentPosition!,
    savedEval: currentNode.eval,
    serverEval: currentNode.serverEval,
  );

  bool get canGoNext => !isSolving && currentNode.hasChild;
  bool get canGoBack => !isSolving && currentPath.size > UciPath.empty.size;
}

@freezed
sealed class RetroCurrentNode with _$RetroCurrentNode implements AnalysisCurrentNodeInterface {
  const RetroCurrentNode._();

  const factory RetroCurrentNode({
    required Position position,
    required bool isRoot,
    required bool hasChild,
    SanMove? sanMove,
    ClientEval? eval,
    ExternalEval? serverEval,
    IList<int>? nags,
  }) = _RetroCurrentNode;

  factory RetroCurrentNode.fromNode(ViewNode node) {
    if (node is ViewBranch) {
      return RetroCurrentNode(
        sanMove: node.sanMove,
        position: node.position,
        isRoot: node is Root,
        eval: node.eval,
        serverEval: node.serverEval,
        nags: IList(node.nags),
        hasChild: node.children.isNotEmpty,
      );
    } else {
      return RetroCurrentNode(
        position: node.position,
        isRoot: node is Root,
        eval: node.eval,
        hasChild: node.children.isNotEmpty,
      );
    }
  }
}
