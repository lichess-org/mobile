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
  Iterable<Step> get currentPathSteps;
  Position? get currentPosition;
  ClientEval? get initialPositionEval;
}

/// A mixin to provide engine evaluation functionality to an [AsyncNotifier].
///
/// The parent must initialize the engine evaluation by calling [initEngineEvaluation] and dispose it
/// by calling [disposeEngineEvaluation].
///
/// The parent must implement the following methods:
/// - [onCurrentPathEvalChanged] to refresh the current node after an evaluation.
/// - [socketClient] to provide the [SocketClient] to use for cloud evaluations.o
/// - [positionTree] to provide the tree where the evaluations are stored.
mixin EngineEvaluationMixin<T extends EvaluationMixinState> {
  AsyncValue<T> get state;
  // doesn't compile with `Ref<T>` right now; should not be a problem in next Riverpod version
  // ignore: deprecated_member_use
  AutoDisposeAsyncNotifierProviderRef<T> get ref;

  final _cloudEvalGetDebounce = Debouncer(kCloudEvalDebounceDelay);
  final _engineEvalDebounce = Debouncer(kEngineEvalDebounceDelay);

  EvaluationOptions get _evaluationOptions =>
      ref.read(engineEvaluationPreferencesProvider).evaluationOptions;

  EngineEvaluationPrefState get _prefs => ref.read(engineEvaluationPreferencesProvider);

  StreamSubscription<SocketEvent>? _subscription;

  EvaluationService? _evaluationService;

  /// Called when a received evaluation is for the current path.
  ///
  /// If the evaluation string is the same for both the received and the current evaluation, the
  /// [isSameEvalString] parameter will be `true`. It can be used to avoid refreshing the UI if the
  /// evaluation string is the same.
  void onCurrentPathEvalChanged(bool isSameEvalString);

  /// The [SocketClient] to use for the cloud evaluation.
  ///
  /// If `null`, the cloud evaluation will not be available.
  SocketClient? get socketClient;

  /// The tree where the evaluations are stored.
  Node get positionTree;

  /// Initializes the engine evaluation.
  ///
  /// Will start listening to the [SocketClient] for cloud evaluations.
  ///
  /// The local engine is not started here, but only when [requestEval] is called.
  @nonVirtual
  void initEngineEvaluation() {
    _subscription = socketClient?.stream.listen(_handleSocketEvent);
    _evaluationService = ref.read(evaluationServiceProvider);
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
    if (!state.hasValue) return;

    await ref.read(engineEvaluationPreferencesProvider.notifier).toggle();

    if (state.requireValue.isEngineAvailable(_prefs)) {
      await ref
          .read(evaluationServiceProvider)
          .initEngine(state.requireValue.evaluationContext, options: _evaluationOptions);
      requestEval();
    } else {
      _stopEngineEval();
      ref.read(evaluationServiceProvider).disposeEngine();
    }
  }

  @mustCallSuper
  void setNumEvalLines(int numEvalLines) {
    // clear all saved evals since the number of eval lines has changed
    positionTree.updateAll((node) => node.eval = null);
    onCurrentPathEvalChanged(false);

    ref.read(engineEvaluationPreferencesProvider.notifier).setNumEvalLines(numEvalLines);

    ref.read(evaluationServiceProvider).setOptions(_evaluationOptions);

    requestEval();
  }

  @mustCallSuper
  void setEngineCores(int numEngineCores) {
    ref.read(engineEvaluationPreferencesProvider.notifier).setEngineCores(numEngineCores);

    ref.read(evaluationServiceProvider).setOptions(_evaluationOptions);

    requestEval();
  }

  @mustCallSuper
  void setEngineSearchTime(Duration searchTime) {
    ref.read(engineEvaluationPreferencesProvider.notifier).setEngineSearchTime(searchTime);

    ref.read(evaluationServiceProvider).setOptions(_evaluationOptions);

    requestEval();
  }

  /// Requests an engine evaluation.
  ///
  /// This sends an `evalGet` event to the server to get the cloud evaluation and starts the local
  /// engine evaluation after an additional delay. The delay should be enough to get the cloud eval
  /// during a socket round trip. If the cloud eval is available the [EvaluationService] will detect
  /// it and not run the local engine, in order to save battery.
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
    if (!state.hasValue) return;

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

    if (state.requireValue.currentPath == path) {
      onCurrentPathEvalChanged(eval.evalString == state.valueOrNull?.currentPathEval?.evalString);
    }
  }

  void _sendEvalGetEvent() {
    if (!state.requireValue.isEngineAvailable(_prefs)) return;
    final curPosition = state.requireValue.currentPosition;
    if (curPosition == null) return;

    final numEvalLines = ref.read(engineEvaluationPreferencesProvider).numEvalLines;

    socketClient?.send('evalGet', {
      'fen': curPosition.fen,
      'path': state.requireValue.currentPath.value,
      'mpv': numEvalLines,
      'up': true,
    });
  }

  /// Do not call this method directly, use [_startEngineEval] instead.
  Future<void> _doStartEngineEval() async {
    final curState = state.requireValue;
    if (!curState.isEngineAvailable(_prefs)) return;
    await ref
        .read(evaluationServiceProvider)
        .ensureEngineInitialized(state.requireValue.evaluationContext, options: _evaluationOptions);
    ref
        .read(evaluationServiceProvider)
        .start(
          curState.currentPath,
          curState.currentPathSteps,
          initialPositionEval: curState.initialPositionEval,
          shouldEmit: (work) => work.path == state.valueOrNull?.currentPath,
        )
        ?.forEach((tuple) {
          final (work, eval) = tuple;
          positionTree.updateAt(work.path, (node) => node.eval = eval);
          if (work.path == state.requireValue.currentPath) {
            onCurrentPathEvalChanged(
              eval.evalString == state.valueOrNull?.currentPathEval?.evalString,
            );
          }
        });
  }

  void _stopEngineEval() {
    ref.read(evaluationServiceProvider).stop();
  }
}
