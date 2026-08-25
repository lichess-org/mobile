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

/// How the engines that can be resident at once share the device.
///
/// The two axes behave differently. **Cores are not split**: only one engine searches at a time —
/// an offline game's opponent thinks, its move is played, and only then are the hints computed —
/// so whoever is searching can have the whole core budget. **Memory is**: `Hash` is allocated when
/// the option is set, not when a search starts, so two resident engines hold two tables for as
/// long as they are both loaded.
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
