import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:meta/meta.dart';

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
abstract class EvaluationMixinState {
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
}

/// A mixin to provide engine evaluation functionality to an [AsyncNotifier].
///
/// The parent must initialize the engine evaluation by calling [initEngineEvaluation] and dispose it
/// by calling [disposeEngineEvaluation].
///
/// The parent must implement the following:
/// - [evaluationState]
/// - [socketClient] to provide the [SocketClient] to use for cloud evaluations. If `null`, the
///   cloud evaluations will not be requested.
/// - [positionTree] to provide the tree where the evaluations are stored.
/// - [evaluationServiceFactory]
/// - [evaluationPreferencesNotifier]
/// - [evaluationPrefs]
///
/// The parent can implement:
/// - [onCurrentPathEvalChanged] to refresh the current node after an evaluation.
mixin EngineEvaluationMixin {
  /// Direct access to underlying [EvaluationMixinState].
  ///
  /// This is a workaround to use this mixin in both [Notifier] and [AsyncNotifier].
  /// Parent must ensure that [AsyncNotifier.state] is loaded before using methods that require
  /// [EvaluationMixinState].
  EvaluationMixinState get evaluationState;

  EngineEvaluationPrefState get evaluationPrefs;
  EngineEvaluationPreferences get evaluationPreferencesNotifier;
  EvaluationService evaluationServiceFactory();
  SocketClient? get socketClient;
  Node get positionTree;

  final _evalRequestDebounce = Debouncer(kRequestEvalDebounceDelay);
  final _localEngineAfterDelayDebounce = Debouncer(kLocalEngineAfterCloudEvalDelay);

  StreamSubscription<SocketEvent>? _socketSubscription;

  EvaluationService? _evaluationService;

  /// Called when a received evaluation is for the current path.
  ///
  /// If the evaluation string is the same for both the received and the current evaluation, the
  /// [isSameEvalString] parameter will be `true`. It can be used to avoid refreshing the UI if the
  /// evaluation string is the same.
  void onCurrentPathEvalChanged(bool isSameEvalString) {}

  /// Initializes the engine evaluation.
  ///
  /// Will start listening to the [SocketClient] for cloud evaluations.
  ///
  /// The local engine is not started here, but only when [requestEval] is called.
  @nonVirtual
  void initEngineEvaluation() {
    _socketSubscription = socketClient?.stream.listen(_handleSocketEvent);
    _evaluationService = evaluationServiceFactory();
  }

  /// Disposes all resources related to the engine evaluation.
  @nonVirtual
  void disposeEngineEvaluation() {
    _evalRequestDebounce.cancel();
    _localEngineAfterDelayDebounce.cancel();
    _socketSubscription?.cancel();
    _evaluationService?.disposeEngine();
    _evaluationService = null;
  }

  /// Toggles the engine evaluation on/off.
  @mustCallSuper
  Future<void> toggleEngine() async {
    await evaluationPreferencesNotifier.toggle();

    if (evaluationState.isEngineAvailable(evaluationPrefs)) {
      requestEval();
    } else {
      await _evaluationService?.disposeEngine();
    }
  }

  @mustCallSuper
  Future<void> stopEval() async {
    if (evaluationState.isEngineAvailable(evaluationPrefs)) {
      _evaluationService?.stop();
    }
  }

  @mustCallSuper
  void setNumEvalLines(int numEvalLines) {
    // clear all saved evals since the number of eval lines has changed
    positionTree.updateAll((node) => node.eval = null);
    onCurrentPathEvalChanged(false);

    evaluationPreferencesNotifier.setNumEvalLines(numEvalLines);

    _evaluationService?.options = evaluationPrefs.evaluationOptions;

    requestEval();
  }

  @mustCallSuper
  void setEngineCores(int numEngineCores) {
    evaluationPreferencesNotifier.setEngineCores(numEngineCores);

    _evaluationService?.options = evaluationPrefs.evaluationOptions;

    requestEval();
  }

  @mustCallSuper
  void setEngineSearchTime(Duration searchTime) {
    evaluationPreferencesNotifier.setEngineSearchTime(searchTime);

    _evaluationService?.options = evaluationPrefs.evaluationOptions;

    requestEval();
  }

  /// Requests an engine evaluation if available.
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
    if (!evaluationState.isEngineAvailable(evaluationPrefs)) return;

    final delayLocalEngine =
        evaluationState.alwaysRequestCloudEval &&
        evaluationPrefs.engineSearchTime != kMaxEngineSearchTime;

    _evalRequestDebounce(() {
      _sendEvalGetEvent();

      if (!delayLocalEngine) {
        _startEngineEval(goDeeper);
      }
    });

    if (delayLocalEngine) {
      _localEngineAfterDelayDebounce(() {
        _startEngineEval(goDeeper);
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

    if (evaluationState.currentPath == path) {
      onCurrentPathEvalChanged(isSameEvalString);
    }
  }

  bool _canCloudEval() {
    if (evaluationState.currentPosition!.ply >= 15 && !evaluationState.alwaysRequestCloudEval) {
      return false;
    }
    if (positionTree.nodeAt(evaluationState.currentPath).eval is CloudEval) return false;

    // cloud eval does not support threefold repetition
    final Set<String> fens = <String>{};
    final nodeList = positionTree.branchesOn(evaluationState.currentPath).toList();
    for (var i = nodeList.length - 1; i >= 0; i--) {
      final node = nodeList[i];
      final epd = fenToEpd(node.position.fen);
      if (fens.contains(epd)) return false;
      if (node.sanMove.isIrreversible(evaluationState.evaluationContext.variant)) {
        return true;
      }
      fens.add(epd);
    }

    return true;
  }

  void _sendEvalGetEvent() {
    if (!evaluationState.isEngineAvailable(evaluationPrefs)) return;
    if (evaluationPrefs.engineSearchTime == kMaxEngineSearchTime) return;
    if (!_canCloudEval()) return;
    final curPosition = evaluationState.currentPosition;
    if (curPosition == null) return;
    final numEvalLines = evaluationPrefs.numEvalLines;

    socketClient?.send('evalGet', {
      'fen': curPosition.fen,
      'path': evaluationState.currentPath.value,
      'mpv': numEvalLines,
      'up': true,
    });
  }

  Future<void> _startEngineEval([bool goDeeper = false]) async {
    final curState = evaluationState;
    if (!curState.isEngineAvailable(evaluationPrefs)) return;
    await _evaluationService?.ensureEngineInitialized(
      evaluationState.evaluationContext,
      initOptions: evaluationPrefs.evaluationOptions,
    );
    _evaluationService
        ?.start(
          curState.currentPath,
          positionTree.branchesOn(curState.currentPath).map(Step.fromNode),
          initialPositionEval: positionTree.eval,
          shouldEmit: _shouldEmit,
          goDeeper: goDeeper,
        )
        ?.forEach((event) {
          final (work, eval) = event;
          bool isSameEvalString = true;
          positionTree.updateAt(work.path, (node) {
            final nodeEval = node.eval;
            if (nodeEval is CloudEval) {
              if (nodeEval.depth >= eval.depth &&
                  work.isDeeper != true &&
                  work.searchTime != kMaxEngineSearchTime) {
                final targetTime = work.searchTime;
                final searchTime = eval.searchTime;
                final likelyNodes =
                    ((targetTime.inMilliseconds * eval.nodes) / searchTime.inMilliseconds).round();
                // if the cloud eval is likely better, stop the local engine
                // nps varies with positional complexity so this is rough, but save planet earth
                if (likelyNodes < nodeEval.nodes) {
                  _evaluationService?.stop();
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
          if (work.path == evaluationState.currentPath) {
            onCurrentPathEvalChanged(isSameEvalString);
          }
        });
  }

  bool _shouldEmit(Work work) => work.path == evaluationState.currentPath;
}
