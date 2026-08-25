import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/engine_budget.dart';
import 'package:lichess_mobile/src/model/engine/engine_utils.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_context.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/position_evaluator.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';

export 'package:lichess_mobile/src/model/engine/evaluation_context.dart';

/// The debounce delay for requesting an eval.
///
/// This value was empirically determined to avoid sending requests during a fast rewind or fast
/// forward of moves.
const kRequestEvalDebounceDelay = Duration(milliseconds: 250);

/// The debounce delay for starting the local engine evaluation in case we assume the cloud eval
/// will be available (broadcasts).
///
/// This is superior to the `kRequestEvalDebounceDelay` to avoid running the local engine too soon
/// to get a chance to get the cloud eval first.
const kLocalEngineAfterCloudEvalDelay = Duration(milliseconds: 600);

/// Interface for Notifiers's State that uses [EngineEvaluationMixin].
mixin EvaluationMixinState<State extends EvaluationMixinState<State>> {
  /// Returns `true` if the engine evaluation is available (for both local and cloud).
  ///
  /// This value may depend on the current state and the user preferences.
  bool isEngineAvailable(EngineEvaluationPrefState prefs);

  /// The context that the local engine is initialized with.
  EvaluationContext get evaluationContext;

  /// Current path in the position tree.
  UciPath get currentPath;

  /// Current position in the position tree. Can be `null` to support illegal position that are
  /// found in studies.
  Position? get currentPosition;

  /// Whether to always request a cloud evaluation, regardless of the current ply.
  bool get alwaysRequestCloudEval;

  /// Whether the engine is in threat mode, i.e. pretending it's the the opposite side's turn.
  bool get engineInThreatMode;

  /// Whether the "show threat" feature can be used in the current position.
  ///
  /// Threat mode makes the engine analyze from the opponent's perspective, which
  /// is invalid when the king is in check (including checkmate)
  /// or if the opponent would be in stalemate if it was their turn.
  bool get canShowThreat =>
      currentPosition != null &&
      currentPosition!.isCheck == false &&
      threatModePosition(currentPosition!).isStalemate == false;

  State withThreatMode(bool engineInThreatMode);
}

/// A mixin to provide engine evaluation functionality to an [AsyncNotifier].
///
/// The parent must implement the following:
/// - [socketClient] to provide the [SocketClient] to use for cloud evaluations. If `null`, the
///   cloud evaluations will not be requested.
/// - [positionTree] to provide the tree where the evaluations are stored.
///
/// The parent can implement:
/// - [onCurrentPathEvalChanged] to refresh the current node after an evaluation.
mixin EngineEvaluationMixin<T extends EvaluationMixinState<T>> on AnyNotifier<AsyncValue<T>, T> {
  /// What keeps this screen's evaluator — and through it, its engine — alive.
  ///
  /// Acquired lazily rather than watched in [runBuild], because the [EvaluationContext] that keys
  /// it only exists once the state does.
  ProviderSubscription<EngineEvaluationState>? _evaluatorSubscription;
  EvaluationContext? _evaluatorContext;

  PositionEvaluator get _evaluator {
    final context = state.requireValue.evaluationContext;
    if (_evaluatorContext != context) {
      _evaluatorSubscription?.close();
      _evaluatorContext = context;
      _evaluatorSubscription = ref.listen(positionEvaluatorProvider(context), (_, _) {});
    }
    return ref.read(positionEvaluatorProvider(context).notifier);
  }

  SocketClient? get socketClient;
  Node get positionTree;

  EngineEvaluationPrefState get evaluationPrefs => ref.read(engineEvaluationPreferencesProvider);

  EngineBudget get budget => ref.read(engineBudgetProvider);

  EngineEvaluationPreferences get _evaluationPreferencesNotifier =>
      ref.read(engineEvaluationPreferencesProvider.notifier);

  final _evalRequestDebounce = Debouncer(kRequestEvalDebounceDelay);
  final _localEngineAfterDelayDebounce = Debouncer(kLocalEngineAfterCloudEvalDelay);

  StreamSubscription<SocketEvent>? _socketSubscription;

  /// Called when a received evaluation is for the current path.
  ///
  /// If the evaluation string is the same for both the received and the current evaluation, the
  /// [isSameEvalString] parameter will be `true`. It can be used to avoid refreshing the UI if the
  /// evaluation string is the same.
  void onCurrentPathEvalChanged(bool isSameEvalString) {}

  @override
  WhenComplete runBuild() {
    ref.onDispose(() {
      _evalRequestDebounce.cancel();
      _localEngineAfterDelayDebounce.cancel();
      _socketSubscription?.cancel();
      // Letting go of the evaluator disposes it, which releases the engine; the grace window is
      // what makes navigating to another analysis screen free.
      _evaluatorSubscription?.close();
      _evaluatorSubscription = null;
      _evaluatorContext = null;
    });

    final whenComplete = super.runBuild();

    if (socketClient != null) {
      _socketSubscription?.cancel();
      _socketSubscription = socketClient!.stream.listen(_handleSocketEvent);
    } else {
      // if socketClient is null it may be because it has been initialized asynchronously
      var socketSubInitialized = false;
      VoidCallback? stopListen;
      stopListen = listenSelf((_, next) {
        if (next.hasValue && !socketSubInitialized) {
          _socketSubscription?.cancel();
          _socketSubscription = socketClient?.stream.listen(_handleSocketEvent);
          socketSubInitialized = true;
          stopListen?.call();
        }
      });
    }

    return whenComplete;
  }

  /// Toggles the engine evaluation on/off.
  @mustCallSuper
  Future<void> toggleEngine() async {
    await _evaluationPreferencesNotifier.toggle();

    if (state.requireValue.isEngineAvailable(evaluationPrefs)) {
      requestEval();
    } else {
      _evaluator.release();
    }
  }

  Future<void> toggleEngineThreatMode() async {
    if (state.hasValue) {
      final curState = state.requireValue;
      if (!curState.engineInThreatMode && !curState.canShowThreat) {
        return;
      }
      state = AsyncData(state.requireValue.withThreatMode(!curState.engineInThreatMode));
      requestEval();
    }
  }

  @mustCallSuper
  void setNumEvalLines(int numEvalLines) {
    // clear all saved evals since the number of eval lines has changed
    positionTree.updateAll((node) => node.eval = null);
    onCurrentPathEvalChanged(false);

    _evaluationPreferencesNotifier.setNumEvalLines(numEvalLines);

    requestEval();
  }

  @mustCallSuper
  void setEngineCores(int numEngineCores) {
    _evaluationPreferencesNotifier.setEngineCores(numEngineCores);

    requestEval();
  }

  @mustCallSuper
  void setEngineSearchTime(Duration searchTime) {
    _evaluationPreferencesNotifier.setEngineSearchTime(searchTime);

    requestEval();
  }

  /// Requests an engine evaluation if available.
  ///
  /// This must be called after the AsyncNotifier's[state] has been initialized.
  ///
  /// This sends an `evalGet` event to the server to get the cloud evaluation and starts the local
  /// engine evaluation.
  ///
  /// If [EvaluationMixinState.alwaysRequestCloudEval] is `true`, the local engine evaluation will be
  /// delayed to give time to get the cloud eval.
  ///
  /// The evaluation will not be requested if the engine is not available by the context or the
  /// user preferences.
  ///
  /// Eval requests are debounced to avoid sending requests during a fast rewind or fast forward of
  /// moves.
  @nonVirtual
  void requestEval({bool goDeeper = false}) {
    if (!state.requireValue.isEngineAvailable(evaluationPrefs)) return;

    final delayLocalEngine =
        state.requireValue.alwaysRequestCloudEval &&
        evaluationPrefs.engineSearchTime != kMaxEngineSearchTime;

    _evalRequestDebounce(() {
      _sendEvalGetEvent();

      if (!delayLocalEngine) {
        _startEngineEval(goDeeper: goDeeper);
      }
    });

    if (delayLocalEngine) {
      _localEngineAfterDelayDebounce(() {
        _startEngineEval(goDeeper: goDeeper);
      });
    }
  }

  void _handleSocketEvent(SocketEvent event) {
    switch (event.topic) {
      // Sent when a new eval is received
      case 'evalHit':
        _handleEvalHitEvent(event);
    }
  }

  void _handleEvalHitEvent(SocketEvent event) {
    final path = pick(event.data, 'path').asUciPathOrThrow();
    final nodes = pick(event.data, 'knodes').asIntOrThrow() * 1000;
    final depth = pick(event.data, 'depth').asIntOrThrow();

    final pvs = pick(event.data, 'pvs')
        .asListOrThrow(
          (pv) => PvData(
            moves: pv('moves').asStringOrThrow().split(' ').toIList(),
            cp: pv('cp').asIntOrNull(),
            mate: pv('mate').asIntOrNull(),
          ),
        )
        .toIList();

    bool isSameEvalString = true;
    positionTree.updateAt(path, (node) {
      final eval = CloudEval(depth: depth, nodes: nodes, pvs: pvs, position: node.position);
      final nodeDepth = node.eval?.depth;
      if (nodeDepth != null && nodeDepth >= depth) {
        // don't override the local eval if it's deeper than the cloud eval
        return;
      }
      isSameEvalString = eval.evalString == node.eval?.evalString;
      node.eval = eval;
    });

    if (!ref.mounted) return;

    if (state.requireValue.currentPath == path) {
      onCurrentPathEvalChanged(isSameEvalString);
    }
  }

  bool _canCloudEval() {
    if (state.requireValue.currentPosition!.ply >= 15 &&
        !state.requireValue.alwaysRequestCloudEval) {
      return false;
    }
    if (positionTree.nodeAt(state.requireValue.currentPath).eval is CloudEval) return false;

    // cloud eval does not support threefold repetition
    final Set<String> fens = <String>{};
    final nodeList = positionTree.branchesOn(state.requireValue.currentPath).toList();
    for (var i = nodeList.length - 1; i >= 0; i--) {
      final node = nodeList[i];
      final epd = fenToEpd(node.position.fen);
      if (fens.contains(epd)) return false;
      if (node.sanMove.isIrreversible(state.requireValue.evaluationContext.variant)) {
        return true;
      }
      fens.add(epd);
    }

    return true;
  }

  void _sendEvalGetEvent() {
    if (!state.requireValue.isEngineAvailable(evaluationPrefs)) return;
    if (evaluationPrefs.engineSearchTime == kMaxEngineSearchTime) return;
    if (!_canCloudEval()) return;
    final curPosition = state.requireValue.currentPosition;
    if (curPosition == null) return;
    final numEvalLines = evaluationPrefs.numEvalLines;

    socketClient?.send('evalGet', {
      'fen': curPosition.fen,
      'path': state.requireValue.currentPath.value,
      'mpv': numEvalLines,
      if (curPosition.rule != Rule.chess) 'variant': Variant.fromRule(curPosition.rule).name,
      'up': true,
    });
  }

  void _startEngineEval({bool goDeeper = false}) {
    final curState = state.requireValue;
    if (!curState.isEngineAvailable(evaluationPrefs)) return;

    final searchTime = goDeeper ? kMaxEngineSearchTime : evaluationPrefs.engineSearchTime;

    final work = EvalWork(
      id: curState.evaluationContext.id,
      variant: curState.evaluationContext.variant,
      threads: budget.threadsFor(evaluationPrefs.numEngineCores),
      // An analysis screen has the device to itself: nothing else is resident beside it.
      hashSize: budget.soleHash,
      path: curState.currentPath,
      searchTime: searchTime,
      multiPv: evaluationPrefs.numEvalLines,
      threatMode: curState.engineInThreatMode,
      isDeeper: goDeeper ? true : null,
      initialPosition: curState.evaluationContext.initialPosition,
      steps: positionTree.branchesOn(curState.currentPath).map(Step.fromNode).toIList(),
    );

    _evaluator.evaluate(work, goDeeper: goDeeper)?.forEach((event) {
      if (curState.engineInThreatMode) {
        return;
      }
      final (evalWork, eval) = event;
      // Path is always set in EvaluationMixin context since we use a node tree.
      final path = evalWork.path!;

      bool isSameEvalString = true;
      positionTree.updateAt(path, (node) {
        final nodeEval = node.eval;
        if (nodeEval is CloudEval) {
          if (nodeEval.depth >= eval.depth &&
              evalWork.isDeeper != true &&
              evalWork.searchTime != kMaxEngineSearchTime) {
            final targetTime = evalWork.searchTime;
            final evalSearchTime = eval.searchTime;
            final likelyNodes =
                ((targetTime.inMilliseconds * eval.nodes) / evalSearchTime.inMilliseconds).round();
            // if the cloud eval is likely better, stop the local engine
            // nps varies with positional complexity so this is rough, but save planet earth
            if (likelyNodes < nodeEval.nodes) {
              _evaluator.stop();
            }
            return;
          }
        } else if (nodeEval is LocalEval) {
          if (nodeEval.isBetter(eval)) {
            return;
          }
        }
        isSameEvalString = eval.evalString == nodeEval?.evalString;
        node.eval = eval;
      });

      if (!ref.mounted) return;

      if (path == state.requireValue.currentPath) {
        onCurrentPathEvalChanged(isSameEvalString);
      }
    });
  }
}
