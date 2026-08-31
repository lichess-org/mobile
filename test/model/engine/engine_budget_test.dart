import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/engine/engine_budget.dart';
import 'package:lichess_mobile/src/model/engine/engine_utils.dart';

void main() {
  group('EngineBudget', () {
    test('gives every engine the same table, whatever it is for', () {
      const budget = EngineBudget(maxMemoryInMb: 300, maxCores: 4);
      expect(budget.engineHash, 150);
    });

    test('two resident engines never ask for more than the budget', () {
      for (final memory in [25, 64, 128, 200, 300, 512, 1200, 4096]) {
        final budget = EngineBudget(maxMemoryInMb: memory, maxCores: 4);
        expect(
          budget.engineHash * kMaxResidentEngines,
          lessThanOrEqualTo(memory < 32 ? 32 : memory),
          reason: 'memory=$memory',
        );
      }
    });

    test('never gives an engine a table too small to be worth having', () {
      const tiny = EngineBudget(maxMemoryInMb: 25, maxCores: 1);
      expect(tiny.engineHash, 16);
    });

    test('caps a large device, which cannot be asked for one huge block', () {
      // `TranspositionTable::resize` calls `exit(EXIT_FAILURE)` — killing the app, not the engine —
      // when the allocation fails, and it is one contiguous block.
      const big = EngineBudget(maxMemoryInMb: 4096, maxCores: 8);
      expect(big.engineHash, kMaxHashPerEngineInMb);
    });

    test('a shared engine searches on the threads the evaluator asks for', () {
      const budget = EngineBudget(maxMemoryInMb: 300, maxCores: 3);

      // The larger of the two: every level asks for one or two threads, and the evaluator's figure
      // is the one deliberately chosen to leave a core for the UI. Anything else tears the thread
      // pool down and rebuilds it on every hand-off, clearing the table with it.
      expect(
        budget.opponentThreads(sharesEngineWithEvaluator: true, threads: 1),
        budget.evaluatorThreads,
      );
      expect(budget.evaluatorThreads, greaterThanOrEqualTo(1));
    });

    test('an opponent on its own engine gets the threads its level asks for', () {
      const budget = EngineBudget(maxMemoryInMb: 300, maxCores: 3);
      expect(budget.opponentThreads(sharesEngineWithEvaluator: false, threads: 2), 2);
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

    test('a small device still leaves both resident engines a usable table', () {
      final budget = EngineBudget(maxMemoryInMb: engineMaxMemoryFor(2048), maxCores: 4);
      expect(budget.engineHash, 64);
    });

    test('a large device is bounded by the cap rather than by its RAM', () {
      final budget = EngineBudget(maxMemoryInMb: engineMaxMemoryFor(12288), maxCores: 8);
      expect(budget.engineHash, kMaxHashPerEngineInMb);
    });
  });
}
