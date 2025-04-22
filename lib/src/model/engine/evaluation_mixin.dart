import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
const kLocalEngineAfterCloudEvalDelay = Duration(milliseconds: 500);

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

  final _cloudEvalGetDebounce = Debouncer(kRequestEvalDebounceDelay);
  final _engineEvalDebounce = Debouncer(kLocalEngineAfterCloudEvalDelay);

  StreamSubscription<SocketEvent>? _subscription;

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
    _subscription = socketClient?.stream.listen(_handleSocketEvent);
    _evaluationService = evaluationServiceFactory();
  }

  /// Disposes all resources related to the engine evaluation.
  @nonVirtual
  void disposeEngineEvaluation() {
    _cloudEvalGetDebounce.cancel();
    _engineEvalDebounce.cancel();
    _subscription?.cancel();
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
  void requestEval() {
    if (!evaluationState.isEngineAvailable(evaluationPrefs)) return;

    _cloudEvalGetDebounce(() {
      _sendEvalGetEvent();
      if (!evaluationState.alwaysRequestCloudEval) {
        _startEngineEval();
      }
    });

    if (evaluationState.alwaysRequestCloudEval) {
      _engineEvalDebounce(() {
        _startEngineEval();
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
    final depth = pick(event.data, 'depth').asIntOrThrow();

    final pvs =
        pick(event.data, 'pvs')
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
      final eval = CloudEval(depth: depth, pvs: pvs, position: node.position);
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

  void _sendEvalGetEvent() {
    if (!evaluationState.isEngineAvailable(evaluationPrefs)) return;
    final curPosition = evaluationState.currentPosition;
    if (curPosition == null) return;
    if (evaluationState.currentPosition!.ply >= 15 && !evaluationState.alwaysRequestCloudEval) {
      return;
    }
    if (positionTree.nodeAt(evaluationState.currentPath).eval is CloudEval) return;

    final numEvalLines = evaluationPrefs.numEvalLines;

    socketClient?.send('evalGet', {
      'fen': curPosition.fen,
      'path': evaluationState.currentPath.value,
      'mpv': numEvalLines,
      'up': true,
    });
  }

  Future<void> _startEngineEval() async {
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
          shouldEmit: (work) => work.path == evaluationState.currentPath,
        )
        ?.forEach((tuple) {
          final (work, eval) = tuple;
          bool isSameEvalString = true;
          positionTree.updateAt(work.path, (node) {
            if (node.eval is CloudEval) {
              // in case of high network latency, the cloud eval may arrive after the local eval
              // in this case, we should not override the cloud eval with the local eval
              _stopEngineEval();
              return;
            }
            isSameEvalString = eval.evalString == node.eval?.evalString;
            node.eval = eval;
          });
          if (work.path == evaluationState.currentPath) {
            onCurrentPathEvalChanged(isSameEvalString);
          }
        });
  }

  void _stopEngineEval() {
    _evaluationService?.stop();
  }
}
