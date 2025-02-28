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

/// The debounce delay for sending `evalGet` to the server.
///
/// This value was empirically determined to avoid sending requests during a fast rewind or fast
/// forward of moves.
const kCloudEvalDebounceDelay = Duration(milliseconds: 400);

/// The debounce delay for starting the local engine evaluation.
///
/// This delay must be superior to the `kCloudEvalDebounceDelay` to avoid running the local engine
/// when the cloud evaluation is available. The delay is thus increased by 400ms to ensure that the
/// socket 'evalGet/evalHit' round trip is completed.
const kEngineEvalDebounceDelay = Duration(milliseconds: 800);

/// Interface for Notifiers's State that uses [EngineEvaluationMixin].
abstract class EvaluationMixinState {
  /// Returns `true` if the engine evaluation is available (for both local and cloud).
  ///
  /// This value depends on the current state and the user preferences.
  bool isEngineAvailable(EngineEvaluationPrefState prefs);

  /// The context that the local engine is initialized with.
  EvaluationContext get evaluationContext;
  UciPath get currentPath;
  ClientEval? get currentPathEval;
  Position? get currentPosition;
  ClientEval? get initialPositionEval;
}

/// A mixin to provide engine evaluation functionality to an [AsyncNotifier].
///
/// The parent must initialize the engine evaluation by calling [initEngineEvaluation] and dispose it
/// by calling [disposeEngineEvaluation].
///
/// The parent must implement the following methods:
/// - [evaluationState]
/// - [socketClient] to provide the [SocketClient] to use for cloud evaluations.
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
  /// This is a workaround to enable this mixin in both [Notifier] and [AsyncNotifier].
  /// Methods in this mixin always assume that [AsyncNotifier.state] is loaded.
  EvaluationMixinState get evaluationState;

  final _cloudEvalGetDebounce = Debouncer(kCloudEvalDebounceDelay);
  final _engineEvalDebounce = Debouncer(kEngineEvalDebounceDelay);

  EngineEvaluationPrefState get evaluationPrefs;
  EngineEvaluationPreferences get evaluationPreferencesNotifier;
  EvaluationService evaluationServiceFactory();

  StreamSubscription<SocketEvent>? _subscription;

  EvaluationService? _evaluationService;

  /// Called when a received evaluation is for the current path.
  ///
  /// If the evaluation string is the same for both the received and the current evaluation, the
  /// [isSameEvalString] parameter will be `true`. It can be used to avoid refreshing the UI if the
  /// evaluation string is the same.
  void onCurrentPathEvalChanged(bool isSameEvalString) {}

  /// The [SocketClient] to use for the cloud evaluation.
  ///
  /// If `null`, the cloud evaluation will not be available.
  SocketClient? get socketClient;

  /// The tree where the evaluations are stored.
  Node get positionTree;

  /// Initializes the engine evaluation.
  ///
  /// Will start listening to the [socketGlobalStream] for cloud evaluations.
  ///
  /// The local engine is not started here, but only when [requestEval] is called.
  @nonVirtual
  void initEngineEvaluation() {
    _subscription = socketGlobalStream.listen(_handleSocketEvent);
    _evaluationService = evaluationServiceFactory();
  }

  /// Disposes the engine evaluation.
  @nonVirtual
  void disposeEngineEvaluation() {
    _cloudEvalGetDebounce.dispose();
    _engineEvalDebounce.dispose();
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
      _stopEngineEval();
      _evaluationService?.disposeEngine();
    }
  }

  @mustCallSuper
  void setNumEvalLines(int numEvalLines) {
    // clear all saved evals since the number of eval lines has changed
    positionTree.updateAll((node) => node.eval = null);
    onCurrentPathEvalChanged(false);

    evaluationPreferencesNotifier.setNumEvalLines(numEvalLines);

    _evaluationService?.setOptions(evaluationPrefs.evaluationOptions);

    requestEval();
  }

  @mustCallSuper
  void setEngineCores(int numEngineCores) {
    evaluationPreferencesNotifier.setEngineCores(numEngineCores);

    _evaluationService?.setOptions(evaluationPrefs.evaluationOptions);

    requestEval();
  }

  @mustCallSuper
  void setEngineSearchTime(Duration searchTime) {
    evaluationPreferencesNotifier.setEngineSearchTime(searchTime);

    _evaluationService?.setOptions(evaluationPrefs.evaluationOptions);

    requestEval();
  }

  /// Requests an engine evaluation.
  ///
  /// This sends an `evalGet` event to the server to get the cloud evaluation and starts the local
  /// engine evaluation after an additional delay. The delay should be enough to get the cloud eval
  /// during a socket round trip. If the cloud eval is available the [EvaluationService] will detect
  /// it and not run the local engine, in order to save battery.
  ///
  /// The evaluation will not be requested if the engine is not available by the context or the
  /// user preferences.
  ///
  /// Socket messages are also debounced to avoid sending too many `evalGet` to the server.
  @nonVirtual
  void requestEval() {
    _cloudEvalGetDebounce(() {
      _sendEvalGetEvent();
    });
    _engineEvalDebounce(() {
      _doStartEngineEval();
    });
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

    final eval = CloudEval(depth: depth, pvs: pvs, position: positionTree.nodeAt(path).position);
    positionTree.updateAt(path, (node) => node.eval = eval);

    if (evaluationState.currentPath == path) {
      onCurrentPathEvalChanged(eval.evalString == evaluationState.currentPathEval?.evalString);
    }
  }

  void _sendEvalGetEvent() {
    if (!evaluationState.isEngineAvailable(evaluationPrefs)) return;
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

  /// Do not call this method directly, use [_startEngineEval] instead.
  Future<void> _doStartEngineEval() async {
    final curState = evaluationState;
    if (!curState.isEngineAvailable(evaluationPrefs)) return;
    await _evaluationService?.ensureEngineInitialized(
      evaluationState.evaluationContext,
      options: evaluationPrefs.evaluationOptions,
    );
    _evaluationService
        ?.start(
          curState.currentPath,
          positionTree.branchesOn(curState.currentPath).map(Step.fromNode),
          initialPositionEval: curState.initialPositionEval,
          shouldEmit: (work) => work.path == evaluationState.currentPath,
        )
        ?.forEach((tuple) {
          final (work, eval) = tuple;
          positionTree.updateAt(work.path, (node) => node.eval = eval);
          if (work.path == evaluationState.currentPath) {
            onCurrentPathEvalChanged(
              eval.evalString == evaluationState.currentPathEval?.evalString,
            );
          }
        });
  }

  void _stopEngineEval() {
    _evaluationService?.stop();
  }
}
