import 'dart:async';
import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/common_analysis_state.dart';
import 'package:lichess_mobile/src/model/analysis/server_analysis_service.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_mixin.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/explorer/opening_explorer_preferences.dart';
import 'package:lichess_mobile/src/model/explorer/opening_explorer_repository.dart';
import 'package:lichess_mobile/src/model/game/exported_game.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:logging/logging.dart';

part 'retro_controller.freezed.dart';

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
const double _kEvalDepthThreshold = kDebugMode ? 12 : 18;

const Duration _kLowerDepthThresholdTime = Duration(seconds: 6);

/// If we don't reach [_kEvalDepthThreshold] after [_kLowerDepthThresholdTime], we lower the depth threshold to this value.
const double _kEvalDepthThresholdAfterLongEvalTime = _kEvalDepthThreshold - 4;

/// Threshold for considering a move a correct alternative solution.
///
/// When checking a move that is not the server solution,
/// consider it a correct move if the eval difference is above this threshold,
/// i.e. the move does not make the position significantly worse.
const double _kCorrectMovePovDiffThreshold = -0.04;

/// Threshold for considering a move a mistake due to how it affected the evaluation.
const double _kEvalSwingThreshold = 0.1;

/// A provider for [RetroController].
final retroControllerProvider = AsyncNotifierProvider.autoDispose
    .family<RetroController, RetroState, RetroOptions>(
      RetroController.new,
      name: 'RetroControllerProvider',
    );

class RetroController extends AsyncNotifier<RetroState> with EngineEvaluationMixin {
  RetroController(this.options);

  final RetroOptions options;

  late Root _root;

  late ExportedGame _game;

  final Completer<void> _serverAnalysisCompleter = Completer<void>();

  @override
  @protected
  late SocketClient socketClient;

  @override
  @protected
  Node get positionTree => _root;

  @override
  Future<RetroState> build() async {
    final serverAnalysisService = ref.watch(serverAnalysisServiceProvider);

    ref.onDispose(() {
      serverAnalysisService.lastAnalysisEvent.removeListener(_listenToServerAnalysisEvents);
    });

    socketClient = ref.watch(socketPoolProvider).open(AnalysisController.socketUri);

    _game = await ref.watch(archivedGameProvider(options.id).future);

    _root = _game.makeTree();

    if (_game.serverAnalysis == null) {
      await serverAnalysisService.requestAnalysis(options.id);

      _serverAnalysisCompleter.future.timeout(
        kMaxWaitForServerAnalysis,
        onTimeout: () {
          _logger.warning(
            'Server analysis did not finish within $kMaxWaitForServerAnalysis for game ${options.id}',
          );
          state = AsyncError(
            Exception('Server analysis did not finish within $kMaxWaitForServerAnalysis'),
            StackTrace.current,
          );
        },
      );

      final retroState = RetroState(
        serverAnalysisAvailable: false,
        mistakes: const IList.empty(),
        currentMistakeIndex: 0,
        feedback: RetroFeedback.findMove,
        mainlinePath: _root.mainlinePath,
        pov: options.initialSide,
        currentNode: RetroCurrentNode.fromNode(_root),
        variant: _game.meta.variant,
        currentPath: UciPath.empty,
        evaluationContext: EvaluationContext(
          id: options.id,
          variant: _game.meta.variant,
          initialPosition: _root.position,
        ),
      );

      state = AsyncValue.data(retroState);

      serverAnalysisService.lastAnalysisEvent.addListener(_listenToServerAnalysisEvents);

      return retroState;
    }

    state = AsyncData(await _computeMistakes(options.initialSide));

    socketClient.firstConnection.then((_) {
      requestEval();
    });

    return state.requireValue;
  }

  Future<RetroState> _computeMistakes(Side side) async {
    final mistakes = (await Future.wait(
      _root.mainline.map((branch) async {
        if (branch.position.turn != side || branch.children.isEmpty) {
          return null;
        }

        final eval = branch.externalEval;
        final newEval = branch.children.first.externalEval;

        if (eval == null || newEval == null) {
          return null;
        }

        final bigEvalSwing =
            Eval.winningChancesPovDiff(side, eval, newEval).abs() > _kEvalSwingThreshold;

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

        return Mistake(branch: branch.view, openingExplorerSolutions: openingExplorerSolutions);
      }),
    )).nonNulls.toIList();

    return RetroState(
      serverAnalysisAvailable: true,
      mistakes: mistakes.toIList(),
      currentMistakeIndex: 0,
      feedback: mistakes.isNotEmpty ? RetroFeedback.findMove : RetroFeedback.done,
      mainlinePath: _root.mainlinePath,
      pov: side,
      currentNode: RetroCurrentNode.fromNode(mistakes.firstOrNull?.branch.branch ?? _root),
      lastMove: mistakes.firstOrNull?.branch.sanMove.move,
      variant: _game.meta.variant,
      evaluationContext: EvaluationContext(
        id: options.id,
        variant: _game.meta.variant,
        initialPosition: _root.position,
      ),
      currentPath: mistakes.isNotEmpty
          ? _root.mainlinePath.truncate(mistakes[0].branch.position.ply)
          : UciPath.empty,
    );
  }

  void onUserMove(Move move) {
    if (!state.requireValue.currentPosition.isLegal(move)) return;

    if (move case NormalMove() when isPromotionPawnMove(state.requireValue.currentPosition, move)) {
      state = AsyncValue.data(state.requireValue.copyWith(promotionMove: move));
      return;
    }

    final (newPath, isNewNode) = _root.addMoveAt(state.requireValue.currentPath, move);
    if (newPath != null) {
      _setPath(newPath);
    }
  }

  void onPromotionSelection(Role? role) {
    final state = this.state.value;
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
    final currentMistake = state.value?.currentMistake;
    if (currentMistake != null) {
      onUserMove(currentMistake.serverMove);
      state = AsyncValue.data(state.requireValue.copyWith(feedback: RetroFeedback.viewingSolution));
    }
  }

  Future<void> flipSide() async {
    state = AsyncValue.data(await _computeMistakes(state.requireValue.pov.opposite));
  }

  void restart() {
    _showMistake(0);
  }

  void nextMistake() {
    _showMistake(state.requireValue.currentMistakeIndex + 1);
  }

  Future<void> toggleEngineThreatMode() async {
    if (state.hasValue) {
      state = AsyncData(
        state.requireValue.copyWith(engineInThreatMode: !state.requireValue.engineInThreatMode),
      );
      requestEval();
    }
  }

  void _showMistake(int index) {
    final mistake = state.requireValue.mistakes.getOrNull(index);
    final lastMistake = state.requireValue.mistakes.lastOrNull;

    _setPath(
      _root.mainlinePath.truncate(
        mistake?.branch.position.ply ?? lastMistake?.branch.position.ply ?? _root.mainlinePath.size,
      ),
    );

    state = AsyncValue.data(
      state.requireValue.copyWith(
        currentMistakeIndex: index,
        currentNode: RetroCurrentNode.fromNode(
          mistake?.branch.branch ?? lastMistake?.branch.branch ?? _root,
        ),
        feedback: mistake != null ? RetroFeedback.findMove : RetroFeedback.done,
      ),
    );
  }

  void _setPath(
    UciPath path, {

    /// Whether the user is navigating through the moves (as opposed to playing a move).
    bool isNavigating = false,
  }) {
    final state = this.state.value;
    if (state == null) return;

    final pathChange = state.currentPath != path;
    final currentNode = _root.nodeAt(path);

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
          currentNode: RetroCurrentNode.fromNode(currentNode),
          lastMove: currentNode.sanMove.move,
          promotionMove: null,
        ),
      );
    } else {
      this.state = AsyncValue.data(
        state.copyWith(
          currentPath: path,
          currentNode: RetroCurrentNode.fromNode(currentNode),
          lastMove: null,
          promotionMove: null,
        ),
      );
    }

    if (pathChange) {
      this.state = AsyncValue.data(this.state.requireValue.copyWith(engineInThreatMode: false));
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

      if (eval.depth >= _kEvalDepthThreshold ||
          (eval.depth >= _kEvalDepthThresholdAfterLongEvalTime &&
              state.requireValue.evalTime! > _kLowerDepthThresholdTime)) {
        final diff = Eval.winningChancesPovDiff(
          state.requireValue.pov,
          eval,
          state.requireValue.currentMistake!.branch.serverEval!,
        );

        if (diff > _kCorrectMovePovDiffThreshold) {
          _onCorrectMove();

          // We used unlimited search time during Feedback.evalMove,
          // now restart evaluation with normal search time
          requestEval();
        } else {
          _onIncorrectMove();
        }
      }
    }
  }

  void _refreshCurrentNode({bool recomputeRootView = false}) {
    state = AsyncData(
      state.requireValue.copyWith(
        currentNode: RetroCurrentNode.fromNode(_root.nodeAt(state.requireValue.currentPath)),
      ),
    );
  }

  void _updateFeedback() {
    final state = this.state.requireValue;
    switch (state.feedback) {
      case RetroFeedback.incorrect:
      case RetroFeedback.findMove:
        if (state.currentPosition.ply == state.currentMistake!.serverBranch.position.ply) {
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
            // Be sure to get enough depth to evaluate the move properly
            requestEval(goDeeper: true);
          }
        }
      case _:
    }
  }

  Future<void> _listenToServerAnalysisEvents() async {
    if (!state.hasValue) return;

    final event = ref.read(serverAnalysisServiceProvider).lastAnalysisEvent.value;
    if (event != null && event.$1 == options.id) {
      ServerAnalysisService.mergeOngoingAnalysis(_root, event.$2.tree);
      final progress = event.$2.evals.where((e) => e.hasEval).length / _root.mainline.length;
      state = AsyncValue.data(state.requireValue.copyWith(serverAnalysisProgress: progress));

      if (event.$2.isAnalysisComplete) {
        if (_serverAnalysisCompleter.isCompleted == false) {
          _serverAnalysisCompleter.complete();
        }
        state = AsyncData(await _computeMistakes(options.initialSide));
        requestEval();
      }
    }
  }
}

enum RetroFeedback { findMove, evalMove, correct, incorrect, viewingSolution, done }

@freezed
sealed class RetroState with _$RetroState implements EvaluationMixinState, CommonAnalysisState {
  const RetroState._();

  const factory RetroState({
    required bool serverAnalysisAvailable,

    /// Progress of server analysis for the whole game, from 0.0 to 1.0.
    double? serverAnalysisProgress,
    required IList<Mistake> mistakes,
    required int currentMistakeIndex,
    required RetroFeedback feedback,
    required UciPath mainlinePath,
    required Side pov,
    required RetroCurrentNode currentNode,
    required Variant variant,
    required UciPath currentPath,
    required EvaluationContext evaluationContext,
    DateTime? evalRequestedAt,
    Move? lastMove,
    NormalMove? promotionMove,
    @Default(false) bool engineInThreatMode,
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
  Position get currentPosition => currentNode.position;

  @override
  bool isEngineAvailable(EngineEvaluationPrefState prefs) => true;

  bool get hasMistakes => mistakes.isNotEmpty;

  Mistake? get currentMistake => mistakes.getOrNull(currentMistakeIndex);

  EngineGaugeParams get engineGaugeParams => (
    isLocalEngineAvailable: true,
    orientation: pov,
    position: currentPosition,
    savedEval: currentNode.eval,
    serverEval: currentNode.serverEval,
    filters: (id: evaluationContext.id, path: currentPath),
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

  factory RetroCurrentNode.fromNode(Node node) {
    if (node is Branch) {
      return RetroCurrentNode(
        sanMove: node.sanMove,
        position: node.position,
        isRoot: node is Root,
        eval: node.eval,
        serverEval: node.externalEval,
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
