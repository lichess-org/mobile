import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/engine/engine_utils.dart';

/// The smallest table worth giving an engine at all.
const _kMinHashInMb = 16;

/// The most any one engine may hold, whatever the device has.
///
/// A mobile analysis runs a few seconds to half a minute on one or two threads and cannot fill a
/// table this size, so the unlimited search time is the only setting this constrains at all.
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
/// [opponentThreads] `sharesEngineWithEvaluator` argument below.
class EngineBudget {
  const EngineBudget({required this.maxMemoryInMb, required this.maxCores});

  /// The whole memory budget for engines on this device, in MB.
  ///
  /// A share of the device's RAM — see [engineMaxMemoryFor] — divided between the engines that can
  /// be resident at once rather than handed to any one of them.
  final int maxMemoryInMb;

  /// The most cores an engine may search on.
  final int maxCores;

  /// The threads to ask for, given what the caller would like.
  int threadsFor(int requested) => math.min(math.max(1, requested), maxCores);

  /// The transposition table every engine is created with.
  ///
  /// One number for every engine, whatever it is going to be used for, because the table is not a
  /// role's: it is allocated when the engine starts and freed when it exits, and one engine serves
  /// whichever roles happen to want it — the evaluator, the opponent, or both at once on a
  /// variant. Sizing it per role would mean either resizing on every hand-off, which clears the
  /// table and blocks the UCI loop while it does, or a number that silently depends on which role
  /// happened to create the engine.
  ///
  /// A share *and* a cap, because the two protect against different things: the share keeps two
  /// resident engines from asking a small device for more than it has, the cap keeps a large one
  /// from being asked to find [kMaxHashPerEngineInMb] more than once in a single block.
  int get engineHash => math.min(
    kMaxHashPerEngineInMb,
    math.max(_kMinHashInMb, maxMemoryInMb ~/ kMaxResidentEngines),
  );

  /// The threads the evaluator of an offline game asks for.
  ///
  /// One fewer than the budget allows: it runs during the player's turn, while the board is being
  /// interacted with, rather than while the user waits for the opponent.
  int get evaluatorThreads => threadsFor(numberOfCoresForEvaluation);

  /// The threads the opponent of an offline game asks for, given what its level wants.
  ///
  /// The evaluator's figure when they are the same engine — the larger of the two, since every
  /// [StockfishLevel] asks for one or two threads — because the alternative is tearing the thread
  /// pool down and back up on every hand-off between them.
  int opponentThreads({required bool sharesEngineWithEvaluator, required int threads}) =>
      sharesEngineWithEvaluator ? evaluatorThreads : threadsFor(threads);

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
