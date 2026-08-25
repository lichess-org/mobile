import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/engine/engine_budget.dart';

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
}
