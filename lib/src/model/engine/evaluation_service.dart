import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dartchess/dartchess.dart' hide File;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/nnue_service.dart';
import 'package:lichess_mobile/src/model/engine/uci_protocol.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:logging/logging.dart';
import 'package:multistockfish/multistockfish.dart';
import 'package:stream_transform/stream_transform.dart';

part 'evaluation_service.freezed.dart';

final _logger = Logger('EvaluationService');

const kEngineEvalEmissionThrottleDelay = Duration(milliseconds: 200);

final maxEngineCores = max(Platform.numberOfProcessors - 1, 1);
final defaultEngineCores = min((Platform.numberOfProcessors / 2).ceil(), maxEngineCores);

/// Variants supported by the local engine.
const engineSupportedVariants = {Variant.standard, Variant.chess960, Variant.fromPosition};

/// A provider for [EvaluationService].
final evaluationServiceProvider = Provider<EvaluationService>((Ref ref) {
  final maxMemory = ref.read(preloadedDataProvider).requireValue.engineMaxMemoryInMb;
  final nnueService = ref.read(nnueServiceProvider);
  final service = EvaluationService(maxMemory: maxMemory, nnueService: nnueService);

  ref.onDispose(() {
    service._dispose();
  });

  return service;
}, name: 'EvaluationServiceProvider');

/// A service to evaluate chess positions using Stockfish.
///
/// This is a singleton service that wraps the Stockfish engine. Only one evaluation
/// can run at a time - when a new evaluation is requested, it takes over from any
/// previous one ("last caller wins").
class EvaluationService {
  EvaluationService({required this.maxMemory, required NnueService nnueService})
    : _nnueService = nnueService {
    _stdoutSubscription = _stockfish.stdout.listen(_protocol.received);
    _stockfish.state.addListener(_onStockfishStateChange);
    _protocol.isComputing.addListener(_onComputingChange);
    _protocol.engineName.addListener(_onEngineNameChange);
    _evalSubscription = _protocol.evalStream.listen((result) {
      _currentEval.value = result.$2;
      _evalController.add(result);
      _updateEvaluationState();
    });
  }

  final int maxMemory;
  final NnueService _nnueService;

  Stockfish get _stockfish => LichessBinding.instance.stockfish;

  final UCIProtocol _protocol = UCIProtocol();

  late final StreamSubscription<String> _stdoutSubscription;
  late final StreamSubscription<EvalResult> _evalSubscription;

  Work? _currentWork;
  StockfishFlavor? _currentFlavor;
  bool _initInProgress = false;
  bool _isDisposed = false;

  /// Expose NNUE download progress from the nnue service.
  ValueListenable<double> get nnueDownloadProgress => _nnueService.nnueDownloadProgress;

  /// Whether NNUE files are currently being downloaded.
  bool get isDownloadingNNUEFiles => _nnueService.isDownloadingNNUEFiles;

  final _evalController = StreamController<EvalResult>.broadcast();

  /// Stream of evaluation results tagged with their [Work].
  ///
  /// Listeners should filter results by comparing the Work to their own request
  /// to determine if the result is relevant to them.
  Stream<EvalResult> get evalStream =>
      _evalController.stream.throttle(kEngineEvalEmissionThrottleDelay, trailing: true);

  final ValueNotifier<EngineState> _engineState = ValueNotifier(EngineState.initial);

  final ValueNotifier<EngineEvaluationState> _evaluationState = ValueNotifier(
    (engineName: null, eval: null, state: EngineState.initial, currentWork: null),
  );

  /// The current engine evaluation state, combining engine name, eval, state, and current work.
  ValueListenable<EngineEvaluationState> get evaluationState => _evaluationState;

  void _setEngineState(EngineState newState) {
    final oldState = _engineState.value;
    if (oldState != newState) {
      _logger.fine('Engine state: ${newState.name}');
      _engineState.value = newState;
      _updateEvaluationState();
    }
  }

  void _updateEvaluationState() {
    final newState = (
      engineName: _protocol.engineName.value,
      eval: _currentEval.value,
      state: _engineState.value,
      currentWork: _currentWork,
    );
    if (_evaluationState.value != newState) {
      _evaluationState.value = newState;
    }
  }

  final ValueNotifier<LocalEval?> _currentEval = ValueNotifier(null);

  /// Start evaluating the given [work].
  ///
  /// This will stop any current evaluation and start a new one. Last caller wins.
  ///
  /// Returns a [Stream] of [EvalResult]s for this work only. The stream completes
  /// when the evaluation finishes or is replaced by another request.
  ///
  /// If [goDeeper] is true, the engine will use the maximum search time.
  /// If [forceRestart] is true, the engine will restart even if a cached eval exists.
  ///
  /// Returns `null` if the variant is not supported or if a cached eval is sufficient.
  Stream<EvalResult>? evaluate(Work work, {bool goDeeper = false, bool forceRestart = false}) {
    if (!engineSupportedVariants.contains(work.variant)) {
      return null;
    }

    // Check if cached eval is sufficient
    if (!work.threatMode && !forceRestart) {
      switch (work.evalCache) {
        case final LocalEval localEval when localEval.searchTime >= work.searchTime:
        case CloudEval _ when goDeeper == false:
          stop();
          return null;
        case _:
          break;
      }
    }

    _logger.info(
      'Starting evaluation at ply ${work.position.ply} with options: '
      'enginePref=${work.enginePref}, multiPv=${work.multiPv}, cores=${work.threads}, '
      'searchTime=${work.searchTime.inMilliseconds}ms, threatMode=${work.threatMode}',
    );

    final flavor = work.enginePref == ChessEnginePref.sfLatest
        ? StockfishFlavor.latestNoNNUE
        : StockfishFlavor.sf16;

    final stockfishState = _stockfish.state.value;
    final needsRestart =
        _currentFlavor != flavor ||
        stockfishState == StockfishState.initial ||
        stockfishState == StockfishState.error;

    // Check if we need to clear engine context (different game/puzzle)
    final needsNewGame =
        _currentWork != null &&
        (_currentWork!.id != work.id || _currentWork!.initialPosition != work.initialPosition);

    _logger.fine(
      'Engine restart needed: $needsRestart, new game needed: $needsNewGame, current engine state: $stockfishState',
    );

    _currentWork = work;
    _updateEvaluationState();

    if (_initInProgress) {
      _logger.fine('Evaluate called while engine initialization is in progress, queuing work');

      // Init in progress, work will be computed when init finishes
      // (the _initEngine callback checks _currentWork)
      return evalStream.where((result) => result.$1 == work);
    }

    if (needsRestart) {
      _initInProgress = true;
      _setEngineState(EngineState.loading);
      _initEngine(flavor).then((_) {
        // Compute the current work (might be different from original if another evaluate() came in)
        final currentWork = _currentWork;
        if (currentWork != null) {
          _protocol.compute(currentWork);
        }
      });
    } else {
      _protocol.compute(work, newGame: needsNewGame);
    }

    return evalStream.where((result) => result.$1 == work);
  }

  Future<void> _initEngine(StockfishFlavor flavor) async {
    try {
      _logger.fine('Initializing engine with flavor: $flavor');

      await _stockfish.quit();
      if (_isDisposed) return;

      // Reset the protocol for the new engine session
      _protocol.reset();

      String? smallNetPath;
      String? bigNetPath;
      StockfishFlavor actualFlavor = flavor;

      if (flavor == StockfishFlavor.latestNoNNUE) {
        if (await _nnueService.checkNNUEFiles()) {
          final nnueFiles = _nnueService.nnueFiles;
          smallNetPath = nnueFiles.smallNet.path;
          bigNetPath = nnueFiles.bigNet.path;
        } else {
          _logger.warning('NNUE files not found or corrupted. Falling back to SF16.');
          actualFlavor = StockfishFlavor.sf16;
        }
        if (_isDisposed) return;
      }

      await _stockfish.start(
        flavor: actualFlavor,
        smallNetPath: smallNetPath,
        bigNetPath: bigNetPath,
      );
      if (_isDisposed) return;

      if (_stockfish.state.value == StockfishState.error) {
        return;
      }

      _logger.fine('Engine initialized successfully with flavor: $actualFlavor');

      _currentFlavor = actualFlavor;

      _protocol.connected((cmd) => _stockfish.stdin = cmd);
    } catch (e, s) {
      _logger.severe('Error initializing engine', e, s);
      if (!_isDisposed) {
        _setEngineState(EngineState.error);
      }
    } finally {
      _initInProgress = false;
    }
  }

  void _onStockfishStateChange() {
    switch (_stockfish.state.value) {
      case StockfishState.initial:
        // Don't overwrite loading state during engine restart
        if (_engineState.value != EngineState.loading) {
          _setEngineState(EngineState.initial);
        }
      case StockfishState.starting:
        _setEngineState(EngineState.loading);
      case StockfishState.ready:
        if (_engineState.value != EngineState.computing) {
          _setEngineState(EngineState.idle);
        }
      case StockfishState.error:
        _setEngineState(EngineState.error);
    }
  }

  void _onComputingChange() {
    if (_protocol.isComputing.value) {
      _setEngineState(EngineState.computing);
    } else {
      _setEngineState(EngineState.idle);
    }
  }

  void _onEngineNameChange() {
    _updateEvaluationState();
  }

  /// Stop the current evaluation.
  void stop() {
    _protocol.compute(null);
    _currentWork = null;
    _updateEvaluationState();
  }

  /// Quit the engine entirely.
  ///
  /// This should be called when the engine is no longer needed (e.g., when leaving an analysis screen).
  /// The service can be reused after calling this method.
  void quit() {
    _protocol.compute(null);
    _currentWork = null;
    _stockfish.quit();
    _currentFlavor = null;
    _initInProgress = false;
    _updateEvaluationState();
  }

  void _dispose() {
    _isDisposed = true;
    _stdoutSubscription.cancel();
    _evalSubscription.cancel();
    _stockfish.state.removeListener(_onStockfishStateChange);
    _protocol.isComputing.removeListener(_onComputingChange);
    _protocol.engineName.removeListener(_onEngineNameChange);
    _protocol.dispose();
    _stockfish.quit();
    _evalController.close();
    _engineState.dispose();
    _currentEval.dispose();
    _evaluationState.dispose();
  }

  /// Check the presence and integrity of the NNUE files.
  ///
  /// Delegates to [NnueService.checkNNUEFiles].
  Future<bool> checkNNUEFiles() => _nnueService.checkNNUEFiles();

  /// Download the NNUE files.
  ///
  /// Delegates to [NnueService.downloadNNUEFiles].
  Future<bool> downloadNNUEFiles({bool inBackground = true}) =>
      _nnueService.downloadNNUEFiles(inBackground: inBackground);

  /// Delete the NNUE files.
  ///
  /// Delegates to [NnueService.deleteNNUEFiles].
  Future<void> deleteNNUEFiles() => _nnueService.deleteNNUEFiles();
}

/// Engine state.
enum EngineState { initial, loading, idle, computing, error }

/// A record type holding the current engine evaluation state.
typedef EngineEvaluationState = ({
  String? engineName,
  LocalEval? eval,
  EngineState state,
  Work? currentWork,
});

/// A provider that exposes the current engine evaluation state to the UI.
final engineEvaluationProvider =
    NotifierProvider.autoDispose<EngineEvaluationNotifier, EngineEvaluationState>(
      EngineEvaluationNotifier.new,
      name: 'EngineEvaluationProvider',
    );

class EngineEvaluationNotifier extends Notifier<EngineEvaluationState> {
  late EvaluationService _service;

  @override
  EngineEvaluationState build() {
    _service = ref.watch(evaluationServiceProvider);

    _service.evaluationState.addListener(_onStateChange);

    ref.onDispose(() {
      _service.evaluationState.removeListener(_onStateChange);
    });

    return _service.evaluationState.value;
  }

  void _onStateChange() {
    state = _service.evaluationState.value;
  }
}

@freezed
sealed class EvaluationContext with _$EvaluationContext {
  const factory EvaluationContext({required Variant variant, required Position initialPosition}) =
      _EvaluationContext;
}

/// A function to choose the eval that should be displayed.
Eval? pickBestEval({
  /// The eval from the local engine
  required LocalEval? localEval,

  /// The cached eval which is either a saved eval from the local evaluation or a cloud eval
  required ClientEval? savedEval,

  /// The eval from the server analysis
  required ExternalEval? serverEval,
}) {
  if (localEval?.threatMode == true) {
    return localEval;
  }

  return switch (savedEval) {
    CloudEval() => savedEval,
    final LocalEval eval => localEval != null && localEval.isBetter(eval) ? localEval : eval,
    null => localEval ?? serverEval,
  };
}

/// A function to choose the client eval that should be displayed.
ClientEval? pickBestClientEval({
  /// The eval from the local engine
  required LocalEval? localEval,

  /// The cached eval which is either a saved eval from the local evaluation or a cloud eval
  required ClientEval? savedEval,
}) {
  final eval =
      pickBestEval(localEval: localEval, savedEval: savedEval, serverEval: null) as ClientEval?;

  return eval;
}
