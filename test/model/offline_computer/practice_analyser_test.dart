import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_context.dart';
import 'package:lichess_mobile/src/model/engine/position_evaluator.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/model/offline_computer/practice_analyser.dart';

import '../../binding.dart';
import '../../test_container.dart';
import '../engine/fake_engine.dart';

/// Long enough for the evaluator's throttle to have let the last info line through.
Future<void> settleEvals() =>
    Future<void>.delayed(kEngineEvalEmissionThrottleDelay * 2, () => Future<void>.value());

const _context = EvaluationContext(
  id: StringId('practice'),
  variant: Variant.standard,
  initialPosition: Chess.initial,
);

/// The evaluator the analyser runs on, kept alive for the duration of the test.
PositionEvaluator readEvaluator(ProviderContainer container) {
  final provider = positionEvaluatorProvider(_context);
  container.listen(provider, (_, _) {});
  return container.read(provider.notifier);
}

EvalWork makeWork({IList<Step> steps = const IListConst<Step>([])}) => EvalWork(
  id: const StringId('practice'),
  variant: Variant.standard,
  threads: 1,
  searchTime: kPracticeMaxSearchTime,
  multiPv: 2,
  threatMode: false,
  initialPosition: Chess.initial,
  steps: steps,
);

/// The work for the position after 1. e4, which is a different position to analyse.
EvalWork makeWorkAfterE4() {
  const move = NormalMove(from: Square.e2, to: Square.e4);
  final (position, san) = Chess.initial.makeSan(move);
  return makeWork(
    steps: IList([Step(position: position, sanMove: SanMove(san, move))]),
  );
}

void main() {
  TestLichessBinding.ensureInitialized();

  late AnalysisTestEngine engine;

  setUp(() {
    engine = AnalysisTestEngine();
    fakeEngine = engine;
  });

  group('PracticeAnalyser', () {
    test('keeps searching past the usable depth, and stops at the target', () async {
      final container = await makeContainer();
      final analyser = PracticeAnalyser(
        evaluator: () => readEvaluator(container),
        onEval: (_, _) {},
      );
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      await settleEvals();

      engine.emitDepthRange(toDepth: kPracticeUsableDepth);
      await settleEvals();

      // The whole point: the player's thinking time is engine time, so a usable eval is not the
      // end of the search.
      expect(analyser.isAnalysing, isTrue);
      expect(analyser.evalFor(Chess.initial)?.depth, kPracticeUsableDepth);

      engine.emitDepthRange(toDepth: kPracticeTargetDepth);
      await settleEvals();

      expect(analyser.isAnalysing, isFalse);
      expect(analyser.evalFor(Chess.initial)?.depth, kPracticeTargetDepth);
      expect(engine.stopCount, 1);
    });

    test('usableEval completes as soon as the analysis is deep enough', () async {
      final container = await makeContainer();
      final analyser = PracticeAnalyser(
        evaluator: () => readEvaluator(container),
        onEval: (_, _) {},
      );
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      await settleEvals();

      // A depth the analysis has already passed does not have to be waited for at all.
      engine.emitDepthRange(toDepth: kPracticeUsableDepth - 2);
      await settleEvals();

      var completed = false;
      final waiting = analyser.usableEval(Chess.initial, timeout: const Duration(seconds: 5)).then((
        eval,
      ) {
        completed = true;
        return eval;
      });
      await settleEvals();
      expect(completed, isFalse, reason: 'the analysis is not deep enough yet');

      engine.emitDepthRange(toDepth: kPracticeUsableDepth);
      await settleEvals();

      expect((await waiting)?.depth, greaterThanOrEqualTo(kPracticeUsableDepth));
    });

    test('usableEval gives up with the best it has when the deadline passes', () async {
      final container = await makeContainer();
      final analyser = PracticeAnalyser(
        evaluator: () => readEvaluator(container),
        onEval: (_, _) {},
      );
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      await settleEvals();
      engine.emitDepthRange(toDepth: kPracticeUsableDepth - 3);
      await settleEvals();

      // A slow device may never reach the depth; the shallow eval is still worth having.
      final eval = await analyser.usableEval(
        Chess.initial,
        timeout: const Duration(milliseconds: 100),
      );

      expect(eval?.depth, kPracticeUsableDepth - 3);
    });

    test('yieldEngine hands the engine over, and analysing takes it back', () async {
      final container = await makeContainer();
      final evaluator = readEvaluator(container);
      final analyser = PracticeAnalyser(evaluator: () => evaluator, onEval: (_, _) {});
      addTearDown(analyser.dispose);

      final work = makeWork();
      analyser.analyse(work);
      await settleEvals();
      expect(evaluator.currentWork, work);

      // The opponent needs the engine — on a variant it is the same one.
      analyser.yieldEngine();
      expect(analyser.isAnalysing, isFalse);
      expect(evaluator.currentWork, isNull);

      // Asking for the same position again is how it comes back: nothing is remembered to be
      // restarted, because what is worth analysing is a question about the position now.
      analyser.analyse(makeWork());
      await settleEvals();

      expect(analyser.isAnalysing, isTrue);
      expect(evaluator.currentWork, work);
    });

    test('an eval from elsewhere can end the search', () async {
      final container = await makeContainer();
      final analyser = PracticeAnalyser(
        evaluator: () => readEvaluator(container),
        onEval: (_, _) {},
      );
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      await settleEvals();
      engine.emitDepthRange(toDepth: kPracticeUsableDepth - 2);
      await settleEvals();

      // A cloud eval, or a tablebase lookup: deeper than the search would ever get.
      analyser.offer(
        Chess.initial,
        const CloudEval(
          position: Chess.initial,
          depth: 40,
          nodes: 0,
          pvs: IListConst([
            PvData(moves: IListConst(['e2e4']), cp: 20),
          ]),
        ),
      );

      expect(analyser.isAnalysing, isFalse);
      expect(analyser.evalFor(Chess.initial)?.depth, 40);
      expect(engine.stopCount, 1);
    });

    test('a position already analysed to the target depth is not searched again', () async {
      final container = await makeContainer();
      final analyser = PracticeAnalyser(
        evaluator: () => readEvaluator(container),
        onEval: (_, _) {},
      );
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      await settleEvals();
      engine.emitDepthRange(toDepth: kPracticeTargetDepth);
      await settleEvals();
      expect(engine.requestedPositions, hasLength(1));

      // What a takeback and a replay come back to: there is nothing left to learn about it.
      analyser.analyse(makeWorkAfterE4());
      await settleEvals();
      expect(engine.requestedPositions, hasLength(2));

      analyser.analyse(makeWork());
      await settleEvals();

      expect(engine.requestedPositions, hasLength(2));
      expect(analyser.evalFor(Chess.initial)?.depth, kPracticeTargetDepth);
    });

    test('forgets everything it knows when the game is replaced', () async {
      final container = await makeContainer();
      final analyser = PracticeAnalyser(
        evaluator: () => readEvaluator(container),
        onEval: (_, _) {},
      );
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      await settleEvals();
      engine.emitDepthRange(toDepth: kPracticeTargetDepth);
      await settleEvals();

      analyser.clear();

      expect(analyser.evalFor(Chess.initial), isNull);
      expect(analyser.isAnalysing, isFalse);
    });
  });
}
