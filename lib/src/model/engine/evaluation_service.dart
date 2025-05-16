import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartchess/dartchess.dart' hide File;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show AlertDialog, Navigator, Text, showAdaptiveDialog;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
import 'package:multistockfish/multistockfish.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_transform/stream_transform.dart';

part 'evaluation_service.freezed.dart';
part 'evaluation_service.g.dart';

const kEngineEvalEmissionThrottleDelay = Duration(milliseconds: 200);

final maxEngineCores = max(Platform.numberOfProcessors - 1, 1);
final defaultEngineCores = min((Platform.numberOfProcessors / 2).ceil(), maxEngineCores);

const engineSupportedVariants = {Variant.standard, Variant.chess960, Variant.fromPosition};

/// A function that returns true if the evaluation should be emitted by the [EngineEvaluation]
/// provider.
typedef ShouldEmitEvalFilter = bool Function(Work work);

typedef NNUEFiles = ({File bigNet, File smallNet});

@Riverpod(keepAlive: true)
EvaluationService evaluationService(Ref ref) {
  final maxMemory = ref.read(preloadedDataProvider).requireValue.engineMaxMemoryInMb;
  final service = EvaluationService(ref, maxMemory: maxMemory);

  ref.onDispose(() {
    service._dispose();
  });

  return service;
}

/// A service to evaluate chess positions using an engine.
class EvaluationService {
  EvaluationService(Ref ref, {required this.maxMemory}) : _ref = ref;

  final Ref _ref;
  final int maxMemory;

  Engine? _engine;

  EvaluationContext? _context;

  final ValueNotifier<double> _nnueDownloadProgress = ValueNotifier(0.0);

  ValueListenable<double> get nnueDownloadProgress => _nnueDownloadProgress;
  bool get isDownloadingNNUEFiles =>
      nnueDownloadProgress.value > 0.0 && nnueDownloadProgress.value < 1.0;

  EvaluationOptions options = EvaluationOptions(
    enginePref: ChessEnginePref.sf16,
    multiPv: 1,
    cores: defaultEngineCores,
    searchTime: const Duration(seconds: 10),
  );

  static const _defaultState = (
    engineName: 'Stockfish',
    state: EngineState.initial,
    eval: null,
    currentWork: null,
  );

  final ValueNotifier<EngineEvaluationState> _state = ValueNotifier(_defaultState);
  ValueListenable<EngineEvaluationState> get state => _state;

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

  Engine _engineFactory(ChessEnginePref pref) {
    // TODO support variants
    switch (pref) {
      case ChessEnginePref.sfLatest:
        try {
          if (!checkNNUEFilesExist()) {
            throw Exception('NNUE files not found.');
          }
          return StockfishEngine(
            StockfishFlavor.latestNoNNUE,
            bigNetPath: nnueFiles.bigNet.path,
            smallNetPath: nnueFiles.smallNet.path,
          );
        } catch (e, st) {
          debugPrint('Failed to load NNUE files: $e\n$st');
          return StockfishEngine(StockfishFlavor.sf16);
        }
      case ChessEnginePref.sf16:
        return StockfishEngine(StockfishFlavor.sf16);
    }
  }

  /// Initialize the engine with the given context and options.
  ///
  /// If the engine is already initialized, it is disposed first.
  ///
  /// If [options] is not provided, the default options are used.
  /// This method must be called before calling [start]. It is the caller's
  /// responsibility to close the engine.
  Future<void> _initEngine(EvaluationContext context, {EvaluationOptions? initOptions}) async {
    await disposeEngine();
    _context = context;
    if (initOptions != null) options = initOptions;
    _engine = _engineFactory(options.enginePref);
    _engine!.state.addListener(() {
      debugPrint('Engine state: ${_engine?.state.value}');
      if (_engine?.state.value == EngineState.initial ||
          _engine?.state.value == EngineState.disposed) {
        _state.value = _defaultState;
      }
      if (_engine?.state != null) {
        _state.value = (
          engineName: _engine!.name,
          state: _engine!.state.value,
          eval: _state.value.eval,
          currentWork: _state.value.currentWork,
        );
      }
    });
  }

  /// Ensure the engine is initialized with the given context and options.
  Future<void> ensureEngineInitialized(
    EvaluationContext context, {
    EvaluationOptions? initOptions,
  }) async {
    if (_engine == null ||
        _engine?.isDisposed == true ||
        _context != context ||
        options != initOptions) {
      await _initEngine(context, initOptions: initOptions);
    }
  }

  /// Dispose the engine.
  ///
  /// Returns a future that completes once the engine is disposed.
  /// It is safe to call this method multiple times.
  Future<void> disposeEngine() {
    return (_engine?.dispose() ?? Future.value()).then((_) {
      _engine = null;
      _state.value = _defaultState;
    });
  }

  /// Dispose the service.
  void _dispose() {
    disposeEngine();
    _state.dispose();
  }

  /// Start the engine evaluation with the given [path] and [steps].
  ///
  /// Returns a stream of [EvalResult]s. The stream is throttled to emit at most
  /// one value every 200 milliseconds.
  /// For each evaluation in the stream, if [shouldEmit] returns true, the eval
  /// is emitted by the [EngineEvaluation] provider.
  ///
  /// [initEngine] must be called before calling this method.
  Stream<EvalResult>? start(
    UciPath path,
    Iterable<Step> steps, {
    ClientEval? initialPositionEval,
    required ShouldEmitEvalFilter shouldEmit,
    bool goDeeper = false,
  }) {
    final context = _context;
    final engine = _engine;
    if (context == null || engine == null) {
      assert(false, 'Engine not initialized');
      return null;
    }

    if (!engineSupportedVariants.contains(context.variant)) {
      return null;
    }

    // reset eval
    _state.value = (
      engineName: _state.value.engineName,
      state: _state.value.state,
      eval: null,
      currentWork: null,
    );

    final work = Work(
      variant: context.variant,
      threads: options.cores,
      hashSize: maxMemory,
      searchTime: goDeeper ? kMaxEngineSearchTime : options.searchTime,
      isDeeper: goDeeper,
      multiPv: options.multiPv,
      path: path,
      initialPosition: context.initialPosition,
      steps: IList(steps),
    );

    switch (work.evalCache) {
      // if the search time is greater than the current search time, don't evaluate again
      case final LocalEval localEval when localEval.searchTime >= work.searchTime:
      case CloudEval _:
        return null;
      case _:
        break;
    }

    final evalStream = engine
        .start(work)
        .throttle(kEngineEvalEmissionThrottleDelay, trailing: true);

    evalStream.forEach((t) {
      final (work, eval) = t;
      if (shouldEmit(work)) {
        _state.value = (
          engineName: _state.value.engineName,
          state: _state.value.state,
          eval: eval,
          currentWork: work,
        );
      }
    });

    return evalStream;
  }

  void stop() {
    _engine?.stop();
  }

  /// Check if the NNUE files are present in the app support directory.
  bool checkNNUEFilesExist() {
    final (:bigNet, :smallNet) = nnueFiles;

    return bigNet.existsSync() && smallNet.existsSync();
  }

  Future<bool> downloadNNUEFiles({bool inBackground = true}) async {
    final (:bigNet, :smallNet) = nnueFiles;

    // delete any existing nnue files before downloading
    await deleteNNUEFiles();

    Future<bool> doDownload() {
      final client = _ref.read(defaultClientProvider);
      return downloadFiles(
        client,
        [StockfishEngine.bigNetUrl, StockfishEngine.smallNetUrl],
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
          return doDownload();
        } else {
          return Future.value(false);
        }
      }
    } else {
      return doDownload();
    }
  }

  Future<void> deleteNNUEFiles() async {
    final appSupportDirectory = _ref.read(preloadedDataProvider).requireValue.appSupportDirectory;
    if (appSupportDirectory == null) {
      throw Exception('App support directory is null.');
    }

    // delete any existing nnue files before downloading
    await for (final entity in appSupportDirectory.list(followLinks: false)) {
      if (entity is File && entity.path.endsWith('.nnue')) {
        debugPrint('Deleting existing nnue ${entity.path}');
        await entity.delete();
      }
    }
  }
}

typedef EngineEvaluationState =
    ({String engineName, EngineState state, Work? currentWork, LocalEval? eval});

/// A provider that holds the state of the engine and the current evaluation.
@riverpod
class EngineEvaluation extends _$EngineEvaluation {
  @override
  EngineEvaluationState build() {
    final listenable = ref.watch(evaluationServiceProvider).state;

    listenable.addListener(_listener);

    ref.onDispose(() {
      listenable.removeListener(_listener);
    });

    return listenable.value;
  }

  void _listener() {
    final newState = ref.read(evaluationServiceProvider).state.value;
    if (state != newState) {
      state = newState;
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
