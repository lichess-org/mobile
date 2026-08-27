import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/engine/engine_utils.dart';

/// The most the opponent's transposition table is ever worth.
///
/// It searches for half a second to two seconds at levels 1–12 and gains very little from a large
/// table; a share of a big device's budget would be hundreds of megabytes held for nothing.
const _kMaxOpponentHashInMb = 64;

/// The smallest table worth giving an engine at all.
const _kMinHashInMb = 16;

/// What one role of an offline game asks its engine for.
typedef EngineShare = ({int hash, int threads});

/// How the engines that can be resident at once share the device.
///
/// The two axes behave differently. **Cores are not split**: only one engine searches at a time —
/// an offline game's opponent thinks, its move is played, and only then are the hints computed —
/// so whoever is searching can have the whole core budget. **Memory is**: `Hash` is allocated when
/// the option is set, not when a search starts, so two resident engines hold two tables for as
/// long as they are both loaded.
///
/// **Whether there are two engines at all is a property of the game.** An offline game's evaluator
/// and its opponent both run on Fairy-Stockfish on every variant, and the same [EngineSpec] means
/// literally the same [Engine] — so the split above would have the two roles asking one engine for
/// two different `Hash` values, and `setoption name Hash` makes Stockfish reallocate and clear its
/// transposition table. Several times a move, that throws away the search each role is about to
/// want. `Threads` re-initialises the thread pool and clears it too. Hence [evaluatorShare] and
/// [opponentShare], which agree when the roles share an engine.
class EngineBudget {
  const EngineBudget({required this.maxMemoryInMb, required this.maxCores});

  /// The whole memory budget for engines on this device, in MB.
  final int maxMemoryInMb;

  /// The most cores an engine may search on.
  final int maxCores;

  /// The threads to ask for, given what the caller would like.
  int threadsFor(int requested) => math.min(math.max(1, requested), maxCores);

  /// The hash for an engine that has the device to itself, as on an analysis screen.
  int get soleHash => math.max(_kMinHashInMb, maxMemoryInMb);

  /// The hash for the opponent, which shares the device with the evaluator computing the hints.
  int get opponentHash =>
      math.min(_kMaxOpponentHashInMb, math.max(_kMinHashInMb, maxMemoryInMb ~/ 4));

  /// The hash for an evaluator running beside an opponent.
  int get evaluatorHash => math.max(_kMinHashInMb, maxMemoryInMb - opponentHash);

  /// The hash both roles ask for when they are the same engine.
  ///
  /// The whole budget, because there is then only one table: the split above exists to stop two
  /// resident engines holding two of them, and one engine holding one costs exactly what the two
  /// shares came to together.
  int get sharedHash => soleHash;

  /// The threads both roles ask for when they are the same engine.
  ///
  /// The evaluator's figure, which is the larger of the two — every [StockfishLevel] asks for one
  /// or two threads — and is the one deliberately chosen to leave a core for the UI.
  int get sharedThreads => threadsFor(numberOfCoresForEvaluation);

  /// The evaluator's share of an offline game's device.
  EngineShare evaluatorShare({required bool sharesEngineWithOpponent}) => sharesEngineWithOpponent
      ? (hash: sharedHash, threads: sharedThreads)
      : (hash: evaluatorHash, threads: threadsFor(numberOfCoresForEvaluation));

  /// The opponent's share of an offline game's device, given the [threads] its level asks for.
  EngineShare opponentShare({required bool sharesEngineWithEvaluator, required int threads}) =>
      sharesEngineWithEvaluator
      ? (hash: sharedHash, threads: sharedThreads)
      : (hash: opponentHash, threads: threadsFor(threads));

  @override
  String toString() =>
      'EngineBudget(memory: ${maxMemoryInMb}MB, cores: $maxCores, '
      'sole: ${soleHash}MB, opponent: ${opponentHash}MB, evaluator: ${evaluatorHash}MB)';
}

/// The device's engine budget.
final engineBudgetProvider = Provider<EngineBudget>((ref) {
  return EngineBudget(
    maxMemoryInMb: ref.watch(preloadedDataProvider).requireValue.engineMaxMemoryInMb,
    maxCores: maxEngineCores,
  );
}, name: 'EngineBudgetProvider');
