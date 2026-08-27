import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/engine/engine_budget.dart';
import 'package:lichess_mobile/src/model/engine/engine_utils.dart';

void main() {
  group('EngineBudget', () {
    test('gives an engine that is alone the whole memory budget', () {
      const budget = EngineBudget(maxMemoryInMb: 300, maxCores: 4);
      expect(budget.soleHash, 300);
    });

    test('caps the opponent, which gains little from a large table', () {
      // A quarter of a big device's budget would be hundreds of megabytes held for an engine that
      // thinks for a second.
      const big = EngineBudget(maxMemoryInMb: 1200, maxCores: 8);
      expect(big.opponentHash, 64);
      expect(big.evaluatorHash, 1136);

      const modest = EngineBudget(maxMemoryInMb: 200, maxCores: 4);
      expect(modest.opponentHash, 50);
      expect(modest.evaluatorHash, 150);
    });

    test('never gives an engine a table too small to be worth having', () {
      const tiny = EngineBudget(maxMemoryInMb: 25, maxCores: 1);
      expect(tiny.opponentHash, 16);
      expect(tiny.evaluatorHash, 16);
    });

    test('the two resident engines never ask for more than the budget', () {
      for (final memory in [25, 64, 128, 200, 300, 512, 1200]) {
        final budget = EngineBudget(maxMemoryInMb: memory, maxCores: 4);
        expect(
          budget.opponentHash + budget.evaluatorHash,
          lessThanOrEqualTo(memory < 32 ? 32 : memory),
          reason: 'memory=$memory',
        );
      }
    });

    test('cores are clamped but never split: one engine searches at a time', () {
      const budget = EngineBudget(maxMemoryInMb: 300, maxCores: 3);
      expect(budget.threadsFor(1), 1);
      expect(budget.threadsFor(3), 3);
      expect(budget.threadsFor(8), 3);
      expect(budget.threadsFor(0), 1);
    });
  });

  group('engineMaxMemoryFor', () {
    test('gives a small device a share of what it has', () {
      expect(engineMaxMemoryFor(512), 32);
      expect(engineMaxMemoryFor(1024), 64);
      expect(engineMaxMemoryFor(2048), 128);
    });

    test('caps a large device rather than scaling with it', () {
      // The device this was reported from: 7.2GB of RAM was giving the analysis engine a 722MB
      // transposition table, which Stockfish allocates and zeroes on the thread running its UCI
      // loop.
      expect(engineMaxMemoryFor(7220), kMaxEngineMemoryInMb);
      expect(engineMaxMemoryFor(16384), kMaxEngineMemoryInMb);
    });

    test('a capped budget still leaves both resident engines a usable table', () {
      const budget = EngineBudget(maxMemoryInMb: kMaxEngineMemoryInMb, maxCores: 4);
      expect(budget.soleHash, 192);
      expect(budget.opponentHash, 48);
      expect(budget.evaluatorHash, 144);
    });
  });
}
