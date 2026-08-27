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

    test('the two roles of an offline game agree when they are one engine', () {
      const budget = EngineBudget(maxMemoryInMb: 1200, maxCores: 8);

      final evaluator = budget.evaluatorShare(sharesEngineWithOpponent: true);
      final opponent = budget.opponentShare(sharesEngineWithEvaluator: true, threads: 2);

      // Anything else is a `setoption name Hash` — and a cleared transposition table — on every
      // hand-off between the opponent and the hints.
      expect(evaluator, opponent);
      // One engine holds one table, so it gets what the two shares came to together.
      expect(evaluator.hash, budget.soleHash);
    });

    test('the two roles keep their own shares when they are two engines', () {
      const budget = EngineBudget(maxMemoryInMb: 1200, maxCores: 8);

      final evaluator = budget.evaluatorShare(sharesEngineWithOpponent: false);
      final opponent = budget.opponentShare(sharesEngineWithEvaluator: false, threads: 2);

      expect(evaluator.hash, budget.evaluatorHash);
      expect(opponent.hash, budget.opponentHash);
      expect(opponent.threads, 2);
    });

    test('a shared engine searches on the threads the evaluator asks for', () {
      const budget = EngineBudget(maxMemoryInMb: 300, maxCores: 3);

      // The larger of the two: every level asks for one or two threads, and the evaluator's figure
      // is the one deliberately chosen to leave a core for the UI.
      expect(
        budget.opponentShare(sharesEngineWithEvaluator: true, threads: 1).threads,
        budget.sharedThreads,
      );
      expect(budget.sharedThreads, greaterThanOrEqualTo(1));
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
