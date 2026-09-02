import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/engine/engine_utils.dart';

/// The smallest table worth giving an engine at all.
const _kMinHashInMb = 16;

/// The biggest table size a single engine can ask for.
const kMaxHashPerEngineInMb = 256;

/// The most engines that can hold a transposition table at the same time.
///
/// An offline game runs an evaluator and an opponent. Every other screen runs one engine, and the
/// engine provider releases an unwatched engine before the next one allocates, so this is the
/// worst case rather than the usual one.
const kMaxResidentEngines = 2;

/// How the engines that can be resident at once share the device.
///
/// The two axes are settled at different times, and that asymmetry is the whole of this class.
///
/// **Memory is fixed when the engine is created.** `Hash` is allocated when the option is set and
/// freed when the engine exits, so the table belongs to the engine and not to any one search —
/// and no caller has a reason to want a different one, which is what lets [engineHash] be a single
/// number nobody passes around. See [engineHash] for what bounds it.
///
/// **Cores are negotiated per search**, because two callers legitimately disagree about them: a
/// weak [StockfishLevel] plays on one thread deliberately, and the analysis screen has a slider.
/// That freedom is not free. `setoption name Threads` destroys and recreates the thread pool,
/// clears the search history, reallocates and zeroes the table *at the current `Hash`*, and
/// re-runs `Search::init()` — all synchronously on the thread running the UCI loop. So the one
/// case where two roles share an engine has to make them agree: on a variant offline game the
/// evaluator and the opponent are literally the same Fairy-Stockfish, and a `Threads` they
/// disagreed about would tear the pool down several times a move. Hence the
/// [offlineOpponentThreads] `sharesEngineWithEvaluator` argument below.
class EngineBudget {
  const EngineBudget({required this.maxMemoryInMb, required this.maxCores});

  /// The whole memory budget for engines on this device, in MB.
  ///
  /// A share of the device's RAM — see [engineMaxMemoryFor] — divided between the engines that can
  /// be resident at once rather than handed to any one of them.
  final int maxMemoryInMb;

  /// The most cores an engine may search on.
  final int maxCores;

  /// The threads the engine of an analysis screen asks for, given the core count the user chose.
  ///
  /// Nothing but a clamp: on these screens the whole device is the analysis, and the user is the
  /// one deciding how much of it to spend.
  int analysisThreads(int requested) => _clamp(requested);

  /// The transposition table every engine is created with.
  ///
  /// A share *and* a cap, because the two protect against different things: the share keeps two
  /// resident engines from asking a small device for more than it has, the cap keeps a large one
  /// from being asked to find [kMaxHashPerEngineInMb] more than once in a single block.
  int get engineHash => math.min(
    kMaxHashPerEngineInMb,
    math.max(_kMinHashInMb, maxMemoryInMb ~/ kMaxResidentEngines),
  );

  /// The threads the evaluator of an offline computer game asks for — the engine behind hints and
  /// move feedback, not the one playing the moves.
  ///
  /// Half the budget, floored at 1. It searches during the player's turn, while the board is being
  /// touched and animated, so an engine that saturates the device shows up as dropped frames.
  int get offlineEvalThreads => math.max(1, maxCores ~/ 2);

  /// The lines the evaluator of an offline computer game asks for.
  ///
  /// A third line is another whole search tree, so it is only worth asking for on a device with
  /// cores to spare — where it buys a hint a third good move to choose between, instead of a
  /// slower one with two.
  int get offlineEvalMultiPv => maxCores >= 6 ? 3 : 2;

  /// The threads the opponent of an offline computer game asks for, given what its level wants.
  ///
  /// The evaluator's figure when they are the same engine, because the alternative is tearing the
  /// thread pool down and back up on every hand-off between them.
  int offlineOpponentThreads({required bool sharesEngineWithEvaluator, required int threads}) =>
      sharesEngineWithEvaluator ? offlineEvalThreads : _clamp(threads);

  /// A thread count a caller asked for, brought inside the budget.
  int _clamp(int requested) => math.min(math.max(1, requested), maxCores);

  @override
  String toString() =>
      'EngineBudget(memory: ${maxMemoryInMb}MB, cores: $maxCores, hash: ${engineHash}MB)';
}

/// The device's engine budget.
final engineBudgetProvider = Provider<EngineBudget>((ref) {
  return EngineBudget(
    maxMemoryInMb: ref.watch(preloadedDataProvider).requireValue.engineMaxMemoryInMb,
    maxCores: maxEngineCores,
  );
}, name: 'EngineBudgetProvider');
