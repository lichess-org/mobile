import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_context.dart';
import 'package:lichess_mobile/src/model/engine/position_evaluator.dart';
import 'package:lichess_mobile/src/model/engine/practice_analyser.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/network/socket.dart';

import '../../binding.dart';
import '../../network/fake_websocket_channel.dart';
import '../../test_container.dart';
import 'fake_engine.dart';

/// Long enough for the evaluator's throttle to have let the last info line through.
Future<void> settleEvals() =>
    Future<void>.delayed(kEngineEvalEmissionThrottleDelay * 2, () => Future<void>.value());

const _context = EvaluationContext(
  id: StringId('practice'),
  variant: Variant.standard,
  initialPosition: Chess.initial,
);

/// A [Ref] to build the analyser on, which is all it uses the container for.
final refProvider = Provider<Ref>((ref) => ref, name: 'TestRefProvider');

/// The analyser under test, running on [container]'s evaluator.
///
/// The network lookups it races the search with go nowhere here: nothing answers the `evalGet` on
/// the fake socket, and the mock HTTP client has no tablebase entry to give.
PracticeAnalyser makeAnalyser(
  ProviderContainer container, {
  PositionEvaluator Function()? evaluator,
  bool alwaysRequestCloudEvals = false,
  void Function(Position position, ClientEval eval) onEval = ignoreEval,
}) => PracticeAnalyser(
  ref: container.read(refProvider),
  evaluator: evaluator ?? () => readEvaluator(container),
  alwaysRequestCloudEvals: alwaysRequestCloudEvals,
  onEval: onEval,
);

/// A container whose socket answers `evalGet` with a cloud eval at [depth].
Future<ProviderContainer> cloudEvalContainer({required int depth}) => makeContainer(
  overrides: {
    webSocketChannelFactoryProvider: webSocketChannelFactoryProvider.overrideWith(
      (_) => FakeWebSocketChannelFactory(
        (uri) => FakeWebSocketChannel(
          uri,
          serverHandlers: {
            'evalGet': (json) {
              final data = json['d']! as Map<String, dynamic>;
              return {
                't': 'evalHit',
                'd': {
                  'path': data['path'],
                  'knodes': '119234',
                  'depth': '$depth',
                  'pvs': [
                    {'moves': 'e2e4 e7e5 g1f3', 'cp': '23'},
                  ],
                },
              };
            },
          },
        ),
      ),
    ),
  },
);

/// Waits for [condition], which the socket's round trip only meets after a few event loop turns.
Future<void> waitFor(bool Function() condition) async {
  final deadline = DateTime.now().add(const Duration(seconds: 2));
  while (!condition() && DateTime.now().isBefore(deadline)) {
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
}

void ignoreEval(Position position, ClientEval eval) {}

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
      final analyser = makeAnalyser(container);
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

    test('a search that ends without a usable eval is started again', () async {
      final container = await makeContainer();
      final analyser = makeAnalyser(container);
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      await settleEvals();
      // A device too slow to get anywhere within its search time: a couple of plies, then the
      // engine stops on its own.
      engine.emitDepthRange(toDepth: kPracticeUsableDepth - 2);
      engine.emit('bestmove e2e4 ponder e7e5');
      await settleEvals();

      expect(analyser.evalFor(Chess.initial)!.depth, lessThan(kPracticeUsableDepth));

      analyser.resumeIfUnfinished();
      await settleEvals();

      // Searched again rather than left with nothing to show for the position.
      expect(engine.requestedPositions, [Chess.initial.fen, Chess.initial.fen]);
      expect(analyser.isAnalysing, isTrue);

      engine.emitDepthRange(toDepth: kPracticeUsableDepth);
      await settleEvals();
      expect(analyser.evalFor(Chess.initial)!.depth, kPracticeUsableDepth);
    });

    test('the engine going quiet is what starts an unfinished search again', () async {
      final container = await makeContainer();
      final analyser = makeAnalyser(container);
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      await settleEvals();
      engine.emit('bestmove e2e4 ponder e7e5');
      await settleEvals();

      // The edge the owner passes on, rather than one it has to pick out itself: both of them
      // hold this subscription for the evaluator's sake anyway.
      const searching = (
        engine: null,
        engineSpec: null,
        eval: null,
        isComputing: true,
        currentWork: null,
      );
      analyser.onEvaluatorStateChanged(searching, PositionEvaluator.defaultState);
      await settleEvals();

      expect(engine.requestedPositions, [Chess.initial.fen, Chess.initial.fen]);
    });

    test('the restarts already spent go with the engine', () async {
      final container = await makeContainer();
      final analyser = makeAnalyser(container);
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      await settleEvals();
      for (var i = 0; i < 6; i++) {
        engine.emit('bestmove e2e4 ponder e7e5');
        await settleEvals();
        analyser.resumeIfUnfinished();
        await settleEvals();
      }
      expect(engine.requestedPositions, hasLength(4), reason: 'the restarts are all spent');

      // The screen goes away and comes back. What ran before was a search on an engine that was
      // starting; this is a fresh go at the position, and it is owed its own restarts.
      analyser.yieldEngine();
      analyser.analyse(makeWork());
      await settleEvals();
      engine.emit('bestmove e2e4 ponder e7e5');
      await settleEvals();
      analyser.resumeIfUnfinished();
      await settleEvals();

      expect(engine.requestedPositions, hasLength(6));
    });

    test('a search that reached the usable depth is left alone when it ends', () async {
      final container = await makeContainer();
      final analyser = makeAnalyser(container);
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      await settleEvals();
      engine.emitDepthRange(toDepth: kPracticeUsableDepth);
      engine.emit('bestmove e2e4 ponder e7e5');
      await settleEvals();

      analyser.resumeIfUnfinished();
      await settleEvals();

      expect(engine.requestedPositions, [Chess.initial.fen]);
    });

    test('it gives up on a position it cannot get a usable eval for', () async {
      final container = await makeContainer();
      final analyser = makeAnalyser(container);
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      await settleEvals();

      // However often the search ends short, the engine is not left running on a loop.
      for (var i = 0; i < 6; i++) {
        engine.emit('bestmove e2e4 ponder e7e5');
        await settleEvals();
        analyser.resumeIfUnfinished();
        await settleEvals();
      }

      expect(engine.requestedPositions.length, 4);
    });

    test('a wait for an engine that is never coming ends on the deadline it was given', () async {
      // An engine that will not start: the evaluator drops the work, and nothing is on its way to
      // the position — so there is no engine start to hold the caller's deadline back for.
      fakeEngine = FakeEngine(startThrows: true);
      final container = await makeContainer();
      final analyser = makeAnalyser(container);
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      await settleEvals();
      expect(readEvaluator(container).currentWork, isNull);

      var completed = false;
      final wait = analyser.usableEval(Chess.initial, timeout: const Duration(milliseconds: 100));
      unawaited(wait.then((_) => completed = true));

      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(completed, isTrue, reason: 'it waited out kPracticeEngineStartWait instead');
      expect(await wait, isNull);
    });

    test('usableEval completes as soon as the analysis is deep enough', () async {
      final container = await makeContainer();
      final analyser = makeAnalyser(container);
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

    test('waiters asking for different depths are served at their own depth', () async {
      final container = await makeContainer();
      final analyser = makeAnalyser(container);
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      await settleEvals();

      // Judging a move played asks for more depth than unlocking a hint does, and both can be
      // waiting on the same position at once.
      ClientEval? shallow;
      ClientEval? deep;
      unawaited(
        analyser
            .usableEval(Chess.initial, timeout: const Duration(seconds: 5))
            .then((eval) => shallow = eval),
      );
      unawaited(
        analyser
            .usableEval(
              Chess.initial,
              minDepth: kPracticeUsableDepth + 3,
              timeout: const Duration(seconds: 5),
            )
            .then((eval) => deep = eval),
      );

      engine.emitDepthRange(toDepth: kPracticeUsableDepth);
      await settleEvals();

      expect(shallow?.depth, kPracticeUsableDepth);
      expect(deep, isNull, reason: 'the deeper waiter is not served by an eval it did not ask for');

      engine.emitDepthRange(toDepth: kPracticeUsableDepth + 3);
      await settleEvals();

      expect(deep?.depth, kPracticeUsableDepth + 3);
    });

    test('usableEval gives up with the best it has when the deadline passes', () async {
      final container = await makeContainer();
      final analyser = makeAnalyser(container);
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

    test('a wait on an engine that has yet to start is given time for the start', () async {
      final container = await makeContainer();
      final analyser = makeAnalyser(container);
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      await settleEvals();

      var completed = false;
      final wait = analyser.usableEval(Chess.initial, timeout: const Duration(milliseconds: 100));
      unawaited(wait.then((_) => completed = true));

      // Long past the caller's own deadline, but the engine has not said a word: it may still be
      // starting up, and none of that is search time to hold against it.
      await Future<void>.delayed(const Duration(milliseconds: 400));
      expect(completed, isFalse);

      // It speaks, deep enough to serve the wait.
      engine.emitDepthRange(toDepth: kPracticeUsableDepth);

      expect((await wait)?.depth, greaterThanOrEqualTo(kPracticeUsableDepth));
    });

    test('a wait on a warm engine runs on the deadline it was given', () async {
      final container = await makeContainer();
      final analyser = makeAnalyser(container);
      addTearDown(analyser.dispose);

      // The engine starts and speaks once, which is all it takes: it stays up from here on.
      analyser.analyse(makeWork());
      await settleEvals();
      engine.emitDepthRange(toDepth: kPracticeUsableDepth);
      await settleEvals();

      // Another position, whose search has said nothing yet. Nothing is starting up any more, so
      // the wait is the caller's to bound rather than kPracticeEngineStartWait's.
      analyser.analyse(makeWorkAfterE4());
      final wait = analyser.usableEval(
        makeWorkAfterE4().position,
        timeout: const Duration(milliseconds: 100),
      );

      var completed = false;
      unawaited(wait.then((_) => completed = true));
      await Future<void>.delayed(const Duration(milliseconds: 300));

      expect(completed, isTrue, reason: 'it waited out kPracticeEngineStartWait instead');
    });

    test('an eval from the server does not eat into the time the engine is given', () async {
      final container = await makeContainer();
      final analyser = makeAnalyser(container);
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      await settleEvals();

      // The server answers long before a cold engine has loaded its network, and too shallow to
      // serve the wait. None of the starting up that is still to come is search time either.
      analyser.offer(
        Chess.initial,
        const CloudEval(
          position: Chess.initial,
          depth: kPracticeUsableDepth - 5,
          nodes: 0,
          pvs: IListConst([
            PvData(moves: IListConst(['e2e4']), cp: 23),
          ]),
        ),
      );

      var completed = false;
      final wait = analyser.usableEval(Chess.initial, timeout: const Duration(milliseconds: 100));
      unawaited(wait.then((_) => completed = true));

      await Future<void>.delayed(const Duration(milliseconds: 400));
      expect(completed, isFalse, reason: 'the engine has still said nothing about the position');

      // It speaks at last, deep enough to serve the wait.
      engine.emitDepthRange(toDepth: kPracticeUsableDepth);

      expect((await wait)?.depth, greaterThanOrEqualTo(kPracticeUsableDepth));
    });

    test('giving the engine up ends the waits on the position it was searching', () async {
      final container = await makeContainer();
      final analyser = makeAnalyser(container);
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      await settleEvals();

      var completed = false;
      final wait = analyser.usableEval(Chess.initial, timeout: const Duration(milliseconds: 100));
      unawaited(wait.then((_) => completed = true));

      // The opponent takes the engine, so nothing is searching this position any more and there is
      // nothing to go on waiting for.
      analyser.yieldEngine();

      expect(await wait, isNull);
      expect(completed, isTrue);
    });

    test('giving the engine up ends a wait whose search was already under way', () async {
      final container = await makeContainer();
      final analyser = makeAnalyser(container);
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      await settleEvals();
      engine.emitDepthRange(toDepth: kPracticeUsableDepth - 3);
      await settleEvals();

      // A generous deadline, so that only the engine being given up can end this.
      final wait = analyser.usableEval(Chess.initial, timeout: const Duration(seconds: 30));
      analyser.yieldEngine();

      // What the search had reached, which is the best there is now that it is over.
      expect((await wait)?.depth, lessThan(kPracticeUsableDepth));
    });

    test('moving the analysis on ends the waits on the position left behind', () async {
      final container = await makeContainer();
      final analyser = makeAnalyser(container);
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      await settleEvals();

      var completed = false;
      final wait = analyser.usableEval(Chess.initial, timeout: const Duration(milliseconds: 100));
      unawaited(wait.then((_) => completed = true));

      // The engine goes to another position, and speaks about that one: a wait on the position
      // left behind is not waiting for an engine to start, it is waiting for nothing.
      analyser.analyse(makeWorkAfterE4());
      await settleEvals();
      engine.emitDepthRange(toDepth: kPracticeUsableDepth);
      await settleEvals();

      expect(completed, isTrue);
    });

    test('a search the evaluator has given up is asked for again', () async {
      // An engine that will not start: the evaluator drops the work, and nothing is ever said
      // about the position.
      fakeEngine = FakeEngine(startThrows: true);
      final container = await makeContainer();
      final analyser = makeAnalyser(container);
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      await settleEvals();
      expect(readEvaluator(container).currentWork, isNull);

      // Asking for the same position again is not taken for the search that is already running,
      // because there is none: a failed start is worth another go, and nothing else would ever
      // start one.
      analyser.analyse(makeWork());
      await settleEvals();

      expect(fakeEngine.startCount, greaterThan(1));
    });

    test('an eval with no move to play does not bury one that has it', () async {
      final container = await makeContainer();
      final analyser = makeAnalyser(container);
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      await settleEvals();
      engine.emitDepthRange(toDepth: kPracticeUsableDepth);
      await settleEvals();

      // What a tablebase entry that lists no moves comes to, and a cloud eval whose variation
      // came back empty: deeper than the search will ever get, and no use for a hint or for the
      // opponent's reply.
      analyser.offer(
        Chess.initial,
        const CloudEval(
          position: Chess.initial,
          depth: 99,
          nodes: 0,
          pvs: IListConst([PvData(moves: IListConst([]), cp: 0)]),
        ),
      );

      expect(analyser.evalFor(Chess.initial)?.bestMove, isNotNull);
      expect(analyser.isAnalysing, isTrue, reason: 'the search still has a move to find');
    });

    test('a position whose only eval has no move to play is searched again', () async {
      final container = await makeContainer();
      final analyser = makeAnalyser(container);
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      await settleEvals();

      // It arrives first, before the engine has said anything: deep enough to end the search on
      // any other reading, and still no move to play.
      analyser.offer(
        Chess.initial,
        const CloudEval(
          position: Chess.initial,
          depth: 99,
          nodes: 0,
          pvs: IListConst([PvData(moves: IListConst([]), cp: 0)]),
        ),
      );

      expect(analyser.isAnalysing, isTrue);

      analyser.yieldEngine();
      analyser.analyse(makeWork());
      await settleEvals();

      expect(engine.requestedPositions, hasLength(2));
    });

    test('a wait is not served by an eval with no move to play', () async {
      final container = await makeContainer();
      final analyser = makeAnalyser(container);
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      await settleEvals();

      var completed = false;
      final wait = analyser.usableEval(Chess.initial, timeout: const Duration(seconds: 5));
      unawaited(wait.then((_) => completed = true));

      // Deeper than the search will ever get, and no use to whoever is waiting: the hint it would
      // unlock and the opponent's reply are both read off the move it does not have.
      analyser.offer(
        Chess.initial,
        const CloudEval(
          position: Chess.initial,
          depth: 99,
          nodes: 0,
          pvs: IListConst([PvData(moves: IListConst([]), cp: 0)]),
        ),
      );
      await settleEvals();
      expect(completed, isFalse);

      // The search finds the move it was left running for, and that is what the wait is served
      // with — shallower than the eval it replaces, and the only one that can be played.
      engine.emitDepthRange(toDepth: kPracticeUsableDepth);
      await settleEvals();

      final eval = await wait;
      expect(eval?.depth, kPracticeUsableDepth);
      expect(eval?.bestMove, isNotNull);
    });

    test('yieldEngine hands the engine over, and analysing takes it back', () async {
      final container = await makeContainer();
      final evaluator = readEvaluator(container);
      final analyser = makeAnalyser(container, evaluator: () => evaluator);
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
      final analyser = makeAnalyser(container);
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
      final analyser = makeAnalyser(container);
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

    test('a cloud eval beats the local search and ends it', () async {
      final container = await cloudEvalContainer(depth: 36);
      final analyser = makeAnalyser(container, alwaysRequestCloudEvals: true);
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      await settleEvals();
      engine.emitDepthRange(toDepth: kPracticeUsableDepth - 2);
      await settleEvals();

      await waitFor(() => !analyser.isAnalysing);

      expect(analyser.evalFor(Chess.initial), isA<CloudEval>());
      expect(analyser.evalFor(Chess.initial)?.depth, 36);
      expect(analyser.isAnalysing, isFalse);
    }, skip: kPracticeCloudEvalsEnabled ? null : 'this build asks the server for nothing');

    test('forgets everything it knows when the game is replaced', () async {
      final container = await makeContainer();
      final analyser = makeAnalyser(container);
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      await settleEvals();
      engine.emitDepthRange(toDepth: kPracticeTargetDepth);
      await settleEvals();

      analyser.clear();

      expect(analyser.evalFor(Chess.initial), isNull);
      expect(analyser.isAnalysing, isFalse);
    });

    test('a wait outliving the game it was for is answered with nothing', () async {
      final container = await makeContainer();
      final analyser = makeAnalyser(container);
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      await settleEvals();
      engine.emitDepthRange(toDepth: kPracticeUsableDepth - 3);
      await settleEvals();

      final wait = analyser.usableEval(Chess.initial, timeout: const Duration(seconds: 5));

      // The player retries. What the search reached belongs to the attempt that was, and handing
      // it to a wait from that attempt would judge the same move by it all over again.
      analyser.clear();

      expect(await wait, isNull);
    });

    test('a cloud eval still in flight does not land in the cache that replaced it', () async {
      final container = await cloudEvalContainer(depth: 36);
      final analyser = makeAnalyser(container, alwaysRequestCloudEvals: true);
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      // A retry, before the round trip is back: what it answers is about the game that was.
      analyser.clear();

      await waitFor(() => analyser.evalFor(Chess.initial) != null);
      expect(analyser.evalFor(Chess.initial), isNull);
    }, skip: kPracticeCloudEvalsEnabled ? null : 'this build asks the server for nothing');

    test('a disposed analyser starts nothing and keeps nobody waiting', () async {
      final container = await makeContainer();
      final analyser = makeAnalyser(container);

      // The owner is gone, and with it the providers the evaluator and the network are read from.
      analyser.dispose();
      analyser.analyse(makeWork());
      await settleEvals();

      expect(engine.requestedPositions, isEmpty);
      expect(analyser.isAnalysing, isFalse);

      // A wait registered now would be one nothing is left to end: the waits that were running
      // have been completed by the disposal already.
      final wait = analyser.usableEval(Chess.initial, timeout: const Duration(seconds: 5));
      expect(await wait, isNull);
    });

    test('an analysis started while an eval is reported is left running', () async {
      final container = await makeContainer();
      late final PracticeAnalyser analyser;
      var moved = false;
      analyser = makeAnalyser(
        container,
        onEval: (position, eval) {
          // What a listener on the state an eval is reported into can do: move the analysis on.
          if (!moved && eval.depth >= kPracticeTargetDepth) {
            moved = true;
            analyser.analyse(makeWorkAfterE4());
          }
        },
      );
      addTearDown(analyser.dispose);

      analyser.analyse(makeWork());
      await settleEvals();
      engine.emitDepthRange(toDepth: kPracticeTargetDepth);
      await settleEvals();

      expect(moved, isTrue);
      // The search that reported the eval is over, but the one started from the report is not: it
      // is not the target depth's to stop.
      expect(analyser.isAnalysing, isTrue);
      expect(engine.requestedPositions, hasLength(2));
    });
  });
}
