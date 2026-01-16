import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:dartchess/dartchess.dart' hide File;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show AlertDialog, Navigator, Text, showAdaptiveDialog;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/uci_protocol.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
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

typedef NNUEFiles = ({File bigNet, File smallNet});

/// A provider for [EvaluationService].
final evaluationServiceProvider = Provider<EvaluationService>((Ref ref) {
  final maxMemory = ref.read(preloadedDataProvider).requireValue.engineMaxMemoryInMb;
  final service = EvaluationService(ref, maxMemory: maxMemory);

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
  EvaluationService(Ref ref, {required this.maxMemory}) : _ref = ref;

  final Ref _ref;
  final int maxMemory;

  Stockfish get _stockfish => LichessBinding.instance.stockfish;

  final UCIProtocol _protocol = UCIProtocol();

  StreamSubscription<String>? _stdoutSubscription;
  StreamSubscription<EvalResult>? _evalSubscription;

  /// The current work being evaluated, if any.
  Work? _currentWork;

  /// Current engine flavor running.
  StockfishFlavor? _currentFlavor;

  /// Whether engine initialization is in progress.
  bool _initInProgress = false;

  /// Whether the service has been disposed.
  bool _isDisposed = false;

  final ValueNotifier<double> _nnueDownloadProgress = ValueNotifier(0.0);
  bool _nnueOperationInProgress = false;

  ValueListenable<double> get nnueDownloadProgress => _nnueDownloadProgress;
  bool get isDownloadingNNUEFiles =>
      nnueDownloadProgress.value > 0.0 && nnueDownloadProgress.value < 1.0;

  final _evalController = StreamController<EvalResult>.broadcast();

  /// Stream of evaluation results tagged with their [Work].
  ///
  /// Listeners should filter results by comparing the Work to their own request
  /// to determine if the result is relevant to them.
  Stream<EvalResult> get evalStream =>
      _evalController.stream.throttle(kEngineEvalEmissionThrottleDelay, trailing: true);

  final ValueNotifier<EngineState> _engineState = ValueNotifier(EngineState.initial);
  ValueListenable<EngineState> get engineState => _engineState;

  /// The current local evaluation, if any.
  final ValueNotifier<LocalEval?> _currentEval = ValueNotifier(null);
  ValueListenable<LocalEval?> get currentEval => _currentEval;

  /// The current work being evaluated, if any.
  Work? get currentWork => _currentWork;

  /// The name of the engine.
  Future<String> get engineName => _protocol.engineName;

  /// Get the NNUE files paths.
  NNUEFiles get nnueFiles {
    final appSupportDirectory = _ref.read(preloadedDataProvider).requireValue.appSupportDirectory;
    if (appSupportDirectory == null) {
      throw Exception('App support directory is null.');
    }

    final bigNetFile = File('${appSupportDirectory.path}/${Stockfish.latestBigNNUE}');
    final smallNetFile = File('${appSupportDirectory.path}/${Stockfish.latestSmallNNUE}');

    return (bigNet: bigNetFile, smallNet: smallNetFile);
  }

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

    // Determine flavor based on options
    final flavor = work.enginePref == ChessEnginePref.sfLatest
        ? StockfishFlavor.latestNoNNUE
        : StockfishFlavor.sf16;

    // Check if we need to restart the engine (different flavor or not running)
    final needsRestart = _currentFlavor != flavor || _stockfish.state.value != StockfishState.ready;

    _currentWork = work;

    if (_initInProgress) {
      // Init in progress, work will be computed when init finishes
      // (the _initEngine callback checks _currentWork)
      return evalStream.where((result) => result.$1 == work);
    }

    if (needsRestart) {
      _initInProgress = true;
      _engineState.value = EngineState.loading;
      _initEngine(flavor).then((_) {
        // Compute the current work (might be different from original if another evaluate() came in)
        final currentWork = _currentWork;
        if (currentWork != null) {
          _protocol.compute(currentWork);
        }
      });
    } else {
      _protocol.compute(work);
    }

    // Return filtered stream for this work
    return evalStream.where((result) => result.$1 == work);
  }

  Future<void> _initEngine(StockfishFlavor flavor) async {
    try {
      _stdoutSubscription?.cancel();

      await _stockfish.quit();
      if (_isDisposed) return;

      // Check NNUE files for latest flavor
      String? smallNetPath;
      String? bigNetPath;
      StockfishFlavor actualFlavor = flavor;

      if (flavor == StockfishFlavor.latestNoNNUE) {
        if (await checkNNUEFiles()) {
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

      // Check if stockfish failed to start
      if (_stockfish.state.value == StockfishState.error) {
        _engineState.value = EngineState.error;
        return;
      }

      _currentFlavor = actualFlavor;

      _stdoutSubscription = _stockfish.stdout.listen(_protocol.received);

      _stockfish.state.addListener(_onStockfishStateChange);

      _protocol.connected((cmd) => _stockfish.stdin = cmd);

      _evalSubscription?.cancel();
      _evalSubscription = _protocol.evalStream.listen((result) {
        _currentEval.value = result.$2;
        _evalController.add(result);
      });

      _protocol.isComputing.addListener(_onComputingChange);

      _engineState.value = EngineState.idle;
    } catch (e, s) {
      _logger.severe('Error initializing engine', e, s);
      if (!_isDisposed) {
        _engineState.value = EngineState.error;
      }
    } finally {
      _initInProgress = false;
    }
  }

  void _onStockfishStateChange() {
    switch (_stockfish.state.value) {
      case StockfishState.ready:
        if (_engineState.value != EngineState.computing) {
          _engineState.value = EngineState.idle;
        }
      case StockfishState.error:
        _engineState.value = EngineState.error;
      default:
        break;
    }
  }

  void _onComputingChange() {
    if (_protocol.isComputing.value) {
      _engineState.value = EngineState.computing;
    } else {
      _engineState.value = EngineState.idle;
    }
  }

  /// Stop the current evaluation.
  void stop() {
    _protocol.compute(null);
    _currentWork = null;
    _currentEval.value = null;
  }

  /// Quit the engine entirely.
  ///
  /// This should be called when the engine is no longer needed (e.g., when leaving an analysis screen).
  /// The service can be reused after calling this method.
  void quit() {
    _protocol.compute(null);
    _currentWork = null;
    _stdoutSubscription?.cancel();
    _evalSubscription?.cancel();
    _stockfish.state.removeListener(_onStockfishStateChange);
    _protocol.isComputing.removeListener(_onComputingChange);
    _stockfish.quit();
    _currentFlavor = null;
    _initInProgress = false;
  }

  void _dispose() {
    _isDisposed = true;
    _stdoutSubscription?.cancel();
    _evalSubscription?.cancel();
    _stockfish.state.removeListener(_onStockfishStateChange);
    _protocol.isComputing.removeListener(_onComputingChange);
    _protocol.dispose();
    _stockfish.quit();
    _evalController.close();
    _engineState.dispose();
    _currentEval.dispose();
  }

  /// Cache the result of the NNUE checksum verification.
  bool? _nnueSumCheckResult;

  /// Check the presence and integrity of the NNUE files.
  Future<bool> checkNNUEFiles() async {
    final (:bigNet, :smallNet) = nnueFiles;

    try {
      final found = await bigNet.exists() && await smallNet.exists();
      if (found) {
        _nnueSumCheckResult ??= await Isolate.run(() {
          return _checksumMatches(bigNet.path, bigNetHash) &&
              _checksumMatches(smallNet.path, smallNetHash);
        });

        if (_nnueSumCheckResult == true) {
          return true;
        } else {
          _logger.warning('NNUE files are corrupted.');
        }
      }

      return false;
    } catch (e) {
      _logger.warning('Error checking NNUE files: $e');
      return false;
    }
  }

  Future<bool> downloadNNUEFiles({bool inBackground = true}) async {
    if (_nnueOperationInProgress) {
      _logger.warning('NNUE download already in progress, ignoring request');
      return false;
    }

    _nnueOperationInProgress = true;

    try {
      final (:bigNet, :smallNet) = nnueFiles;

      // delete any existing nnue files before downloading
      await deleteNNUEFiles();

      Future<bool> doDownload() {
        final client = _ref.read(defaultClientProvider);
        return downloadFiles(
          client,
          [bigNetUrl, smallNetUrl],
          [bigNet, smallNet],
          onProgress: (received, length) {
            _nnueDownloadProgress.value = received / length;
          },
        );
      }

      final connectivityResult = await _ref.read(connectivityPluginProvider).checkConnectivity();
      final onWifi = connectivityResult.contains(ConnectivityResult.wifi);
      if (onWifi == false) {
        if (inBackground) {
          throw Exception('Cannot download in background on mobile data.');
        } else {
          final context = _ref.read(currentNavigatorKeyProvider).currentContext;
          if (context == null || !context.mounted) return false;
          final isOk = await showAdaptiveDialog<bool>(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return AlertDialog.adaptive(
                content: const Text('Are you sure you want to download the NNUE files (79MB)?'),
                actions: [
                  PlatformDialogAction(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                  PlatformDialogAction(
                    child: Text(context.l10n.cancel),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ],
              );
            },
          );
          if (isOk == true) {
            await doDownload();
            return checkNNUEFiles();
          } else {
            return Future.value(false);
          }
        }
      } else {
        return doDownload();
      }
    } finally {
      _nnueOperationInProgress = false;
      _nnueDownloadProgress.value = 0.0;
    }
  }

  Future<void> deleteNNUEFiles() async {
    final appSupportDirectory = _ref.read(preloadedDataProvider).requireValue.appSupportDirectory;
    if (appSupportDirectory == null) {
      throw Exception('App support directory is null.');
    }

    _nnueSumCheckResult = null;

    // delete any existing nnue files before downloading
    await for (final entity in appSupportDirectory.list(followLinks: false)) {
      if (entity is File && entity.path.endsWith('.nnue')) {
        _logger.info('Deleting existing nnue ${entity.path}');
        await entity.delete();
      }
    }
  }
}

/// Engine state.
enum EngineState { initial, loading, idle, computing, error }

/// A provider that holds the current engine state.
final engineStateProvider = NotifierProvider.autoDispose<EngineStateNotifier, EngineState>(
  EngineStateNotifier.new,
  name: 'EngineStateProvider',
);

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
  String? _cachedEngineName;
  bool _disposed = false;

  @override
  EngineEvaluationState build() {
    _service = ref.watch(evaluationServiceProvider);
    _disposed = false;

    // Listen to engine state changes
    _service.engineState.addListener(_onStateChange);
    // Listen to eval changes
    _service.currentEval.addListener(_onEvalChange);

    ref.onDispose(() {
      _disposed = true;
      _service.engineState.removeListener(_onStateChange);
      _service.currentEval.removeListener(_onEvalChange);
    });

    // Get engine name asynchronously
    _service.engineName.then((name) {
      if (!_disposed) {
        _cachedEngineName = name;
        _updateState();
      }
    });

    return (
      engineName: _cachedEngineName,
      eval: _service.currentEval.value,
      state: _service.engineState.value,
      currentWork: _service.currentWork,
    );
  }

  void _onStateChange() {
    if (!_disposed) {
      _updateState();
    }
  }

  void _onEvalChange() {
    if (!_disposed) {
      _updateState();
    }
  }

  void _updateState() {
    state = (
      engineName: _cachedEngineName,
      eval: _service.currentEval.value,
      state: _service.engineState.value,
      currentWork: _service.currentWork,
    );
  }
}

class EngineStateNotifier extends Notifier<EngineState> {
  late ValueListenable<EngineState> _listenable;
  bool _disposed = false;

  @override
  EngineState build() {
    _listenable = ref.watch(evaluationServiceProvider).engineState;
    _disposed = false;

    _listenable.addListener(_listener);

    ref.onDispose(() {
      _disposed = true;
      _listenable.removeListener(_listener);
    });

    return _listenable.value;
  }

  void _listener() {
    if (!_disposed) {
      state = _listenable.value;
    }
  }
}

@freezed
sealed class EvaluationContext with _$EvaluationContext {
  const factory EvaluationContext({required Variant variant, required Position initialPosition}) =
      _EvaluationContext;
}

@freezed
sealed class EvaluationOptions with _$EvaluationOptions {
  const factory EvaluationOptions({
    required ChessEnginePref enginePref,
    required int multiPv,
    required int cores,
    required Duration searchTime,
  }) = _EvaluationOptions;
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

bool _checksumMatches(String filePath, String expectedHash) {
  final bytes = File(filePath).readAsBytesSync();
  final hash = sha256.convert(bytes).toString().substring(0, 12);
  return hash == expectedHash;
}
