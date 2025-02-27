import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:meta/meta.dart';

const kCloudEvalDebounceDelay = Duration(milliseconds: 400);
const kEngineEvalDebounceDelay = Duration(milliseconds: 800);

/// Interface for Notifiers's State that support engine evaluation.
abstract class EvaluationNotifierState {
  bool get isEngineAvailable;
  bool get isLocalEvaluationEnabled;
  EvaluationContext get evaluationContext;
  UciPath get currentPath;
  ClientEval? get currentPathEval;
  Iterable<Step> get currentPathSteps;
  Position get position;
  ClientEval? get initialPositionEval;
}

/// A mixin to provide engine evaluation functionality to an [AsyncNotifier]s.
mixin EvaluationNotifier<T extends EvaluationNotifierState> {
  AsyncValue<T> get state;
  // doesn't compile with `Ref<T>` right now; should not be a problem in next Riverpod version
  // ignore: deprecated_member_use
  AutoDisposeAsyncNotifierProviderRef<T> get ref;

  EvaluationOptions get _evaluationOptions =>
      ref.read(analysisPreferencesProvider).evaluationOptions;

  void onEngineEmit(UciPath path, LocalEval eval);
  void onEvalHit(UciPath path, CloudEval eval);
  void refreshCurrentNode({bool recomputeRootView = false});

  SocketClient get socketClient;

  StreamSubscription<SocketEvent>? _subscription;

  void initEngineEvaluation() {
    _subscription = socketClient.stream.listen(_handleSocketEvent);
  }

  void disposeEngineEvaluation() {
    _cloudEvalGetDebounce.dispose();
    _engineEvalDebounce.dispose();
    _subscription?.cancel();
    ref.read(evaluationServiceProvider).disposeEngine();
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

    final cloudEval = CloudEval(depth: depth, position: state.requireValue.position, pvs: pvs);

    onEvalHit(path, cloudEval);

    if (state.requireValue.currentPath != path) return;

    refreshCurrentNode(recomputeRootView: true);
  }

  final _cloudEvalGetDebounce = Debouncer(kCloudEvalDebounceDelay);
  final _engineEvalDebounce = Debouncer(kEngineEvalDebounceDelay);

  /// Toggles the local evaluation on/off.
  @mustCallSuper
  Future<void> toggleLocalEvaluation() async {
    if (!state.hasValue) return;

    await ref.read(analysisPreferencesProvider.notifier).toggleEnableLocalEvaluation();

    if (state.requireValue.isEngineAvailable) {
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
    ref.read(analysisPreferencesProvider.notifier).setNumEvalLines(numEvalLines);

    ref.read(evaluationServiceProvider).setOptions(_evaluationOptions);

    requestEval();
  }

  @mustCallSuper
  void setEngineCores(int numEngineCores) {
    ref.read(analysisPreferencesProvider.notifier).setEngineCores(numEngineCores);

    ref.read(evaluationServiceProvider).setOptions(_evaluationOptions);

    requestEval();
  }

  @mustCallSuper
  void setEngineSearchTime(Duration searchTime) {
    ref.read(analysisPreferencesProvider.notifier).setEngineSearchTime(searchTime);

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
  void requestEval() {
    _cloudEvalGetDebounce(() {
      _sendEvalGetEvent();
    });
    _engineEvalDebounce(() {
      _doStartEngineEval();
    });
  }

  void _sendEvalGetEvent() {
    final numEvalLines = ref.read(analysisPreferencesProvider).numEvalLines;

    socketClient.send('evalGet', {
      'fen': state.requireValue.position.fen,
      'path': state.requireValue.currentPath.value,
      'mpv': numEvalLines,
      'up': true,
    });
  }

  /// Do not call this method directly, use [_startEngineEval] instead.
  Future<void> _doStartEngineEval() async {
    final curState = state.requireValue;
    if (!curState.isEngineAvailable) return;
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
          onEngineEmit(work.path, eval);
          if (work.path == state.requireValue.currentPath) {
            refreshCurrentNode(
              recomputeRootView: eval.evalString != state.valueOrNull?.currentPathEval?.evalString,
            );
          }
        });
  }

  void _stopEngineEval() {
    ref.read(evaluationServiceProvider).stop();
    refreshCurrentNode();
  }
}
