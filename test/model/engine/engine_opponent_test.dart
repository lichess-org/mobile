import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/engine/engine_budget.dart';
import 'package:lichess_mobile/src/model/engine/engine_opponent.dart';
import 'package:lichess_mobile/src/model/engine/opponent_level.dart';

import 'package:lichess_mobile/src/model/engine/thinking_time.dart';
import 'package:lichess_mobile/src/model/engine/weights_service.dart';

import '../../test_container.dart';
import 'fake_engine.dart';
import 'fake_weights_service.dart';

/// A [ThinkingTime] that always asks for the same wait, so a test can time the wiring rather than
/// the distribution — which `thinking_time_test.dart` covers on its own.
class FixedThinkingTime extends ThinkingTime {
  FixedThinkingTime(this.duration);

  final Duration duration;

  @override
  Duration forMove({required Position position, required Move move, Move? lastMove}) => duration;
}

/// The opponent for [spec], kept alive for the duration of the test.
EngineOpponent readOpponentFor(ProviderContainer container, OpponentSpec spec) {
  final provider = engineOpponentProvider(spec);
  container.listen(provider, (_, _) {});
  return container.read(provider);
}

/// The opponent for [level], kept alive for the duration of the test.
EngineOpponent readOpponent(ProviderContainer container, [StockfishLevel? level]) =>
    readOpponentFor(container, StockfishOpponentSpec(level ?? StockfishLevel.level3));

void main() {
  group('StockfishOpponent', () {
    test('plays a move', () async {
      fakeEngine = LegalMoveEngine();
      final container = await makeContainer();
      final opponent = readOpponent(container);

      final move = await opponent.findMove(
        initialPosition: Chess.initial,
        moves: const IListConst([]),
        variant: Variant.standard,
      );

      expect(move, isNotEmpty);
      expect(Move.parse(move), isNotNull);
    });

    test('plays on Fairy-Stockfish, whatever the level', () async {
      final engine = FakeEngine();
      fakeEngine = engine;
      final container = await makeContainer();

      await readOpponent(container, StockfishLevel.level1).findMove(
        initialPosition: Chess.initial,
        moves: const IListConst([]),
        variant: Variant.standard,
      );

      // Only Fairy-Stockfish has the negative skill levels the weakest opponents need, and it is
      // the only engine that can play every variant.
      expect(engine.spec?.label, 'variant');
    });

    test('turns the level into skill, candidate moves, threads and search time', () async {
      final engine = FakeEngine();
      fakeEngine = engine;
      final container = await makeContainer();

      await readOpponent(container, StockfishLevel.level6).findMove(
        initialPosition: Chess.initial,
        moves: const IListConst([]),
        variant: Variant.standard,
      );

      expect(engine.options['Skill Level'], '9');
      // Strength limiting works by biasing the scores of slightly worse moves among the
      // candidates, so MultiPV is part of how weak the opponent is.
      expect(engine.options['MultiPV'], '4');
      expect(engine.options['Threads'], '2');
      expect(engine.commands, contains('go movetime 1075'));
    });

    test("asks for the evaluator's options when it shares its engine", () async {
      final engine = FakeEngine();
      fakeEngine = engine;
      final container = await makeContainer();
      final budget = container.read(engineBudgetProvider);

      await readOpponent(container, StockfishLevel.level6).findMove(
        initialPosition: Chess.initial,
        moves: const IListConst([]),
        variant: Variant.crazyhouse,
        sharesEngineWithEvaluator: true,
      );

      // On a variant the opponent and the hints are the same Fairy-Stockfish, and a `Hash` or
      // `Threads` the two roles disagree about is re-sent — and the transposition table cleared —
      // on every hand-off.
      expect(engine.options['Hash'], budget.sharedHash.toString());
      expect(engine.options['Threads'], budget.sharedThreads.toString());
    });

    test('keeps its own small table when the evaluator is on another engine', () async {
      final engine = FakeEngine();
      fakeEngine = engine;
      final container = await makeContainer();
      final budget = container.read(engineBudgetProvider);

      await readOpponent(container, StockfishLevel.level6).findMove(
        initialPosition: Chess.initial,
        moves: const IListConst([]),
        variant: Variant.standard,
      );

      expect(engine.options['Hash'], budget.opponentHash.toString());
      expect(engine.options['Threads'], '2');
    });

    test('tells the engine when a game starts', () async {
      final engine = FakeEngine();
      fakeEngine = engine;
      final container = await makeContainer();
      final opponent = readOpponent(container);

      await opponent.findMove(
        initialPosition: Chess.initial,
        moves: const IListConst([]),
        variant: Variant.standard,
      );
      expect(engine.commands, contains('ucinewgame'));

      engine.commands.clear();
      await opponent.findMove(
        initialPosition: Chess.initial,
        moves: const IListConst(['e2e4']),
        variant: Variant.standard,
      );
      expect(
        engine.commands,
        isNot(contains('ucinewgame')),
        reason: 'a move that is not the first belongs to the game already in progress',
      );
    });

    test('a superseded search is cancelled rather than left waiting', () async {
      fakeEngine = ThrottleTestEngine();
      final container = await makeContainer();
      final opponent = readOpponent(container);

      final first = opponent.findMove(
        initialPosition: Chess.initial,
        moves: const IListConst([]),
        variant: Variant.standard,
      );

      // Let the first search reach the engine before replacing it.
      await pumpEventQueue();

      final second = opponent.findMove(
        initialPosition: Chess.initial,
        moves: const IListConst(['e2e4']),
        variant: Variant.standard,
      );

      await expectLater(first, throwsA(isA<MoveSearchCancelled>()));

      // The engine answers the search it was told to stop, and only then starts the one that
      // replaced it.
      (fakeEngine as ThrottleTestEngine).emitBestMove();
      await pumpEventQueue();
      (fakeEngine as ThrottleTestEngine).emitBestMove();
      expect(await second, 'e2e4');
    });

    test('an engine that will not start fails the search', () async {
      fakeEngine = ThrowingStartEngine();
      final container = await makeContainer();
      final opponent = readOpponent(container);

      await expectLater(
        opponent.findMove(
          initialPosition: Chess.initial,
          moves: const IListConst([]),
          variant: Variant.standard,
        ),
        throwsA(anything),
      );
    });

    test('a broken command stream fails the search instead of hanging', () async {
      fakeEngine = FatalWriteEngine();
      final container = await makeContainer();
      final opponent = readOpponent(container);

      // The engine will never answer a search whose commands never reached it, and findMove has no
      // timeout of its own, so its caller has to be failed explicitly.
      await expectLater(
        opponent.findMove(
          initialPosition: Chess.initial,
          moves: const IListConst([]),
          variant: Variant.standard,
        ),
        throwsA(isA<MoveSearchCancelled>()),
      );
    });
  });

  group('MaiaOpponent', () {
    Future<ProviderContainer> makeMaiaContainer(FakeMaiaWeightsService weights) => makeContainer(
      overrides: {
        maiaWeightsServiceProvider: maiaWeightsServiceProvider.overrideWithValue(weights),
      },
    );

    test("plays the network's own move on LC0, with no search on top of it", () async {
      final engine = FakeEngine();
      fakeEngine = engine;
      final weights = FakeMaiaWeightsService();
      final container = await makeMaiaContainer(weights);

      final move = await readOpponentFor(container, const MaiaOpponentSpec(MaiaRating.maia1500))
          .findMove(
            initialPosition: Chess.initial,
            moves: const IListConst([]),
            variant: Variant.standard,
          );

      expect(move, isNotEmpty);
      expect(engine.spec?.label, 'lc0');
      expect(engine.options['WeightsFile'], '/fake/maia/maia-1500.pb.gz');
      // Maia is a policy network: what makes it human-like is the move it likes best, not a tree
      // search on top of it.
      expect(engine.commands, contains('go nodes 1'));
    });

    test('samples the policy instead of always playing the top move', () async {
      final engine = FakeEngine();
      fakeEngine = engine;
      final container = await makeMaiaContainer(FakeMaiaWeightsService());

      await readOpponentFor(container, const MaiaOpponentSpec(MaiaRating.maia1500)).findMove(
        initialPosition: Chess.initial,
        moves: const IListConst([]),
        variant: Variant.standard,
      );

      // At one node no root child has a visit, so LC0's temperature falls back to the policy
      // priors — which is Maia's own distribution of human choices. Without this every game from
      // a given position is the same game.
      expect(engine.options['Temperature'], '0.5');
      // Variety is worth most in the opening and worst in a sharp endgame.
      expect(engine.options['TempDecayDelayMoves'], '10');
      expect(engine.options['TempDecayMoves'], '30');
    });

    test('downloads the network it needs before playing', () async {
      fakeEngine = FakeEngine();
      final weights = FakeMaiaWeightsService();
      final container = await makeMaiaContainer(weights);

      await readOpponentFor(container, const MaiaOpponentSpec(MaiaRating.maia1900)).findMove(
        initialPosition: Chess.initial,
        moves: const IListConst([]),
        variant: Variant.standard,
      );

      expect(weights.downloads, [MaiaRating.maia1900]);
      expect(fakeEngine.options['WeightsFile'], '/fake/maia/maia-1900.pb.gz');
    });

    test('falls back to the bundled network when the download fails', () async {
      final engine = FakeEngine();
      fakeEngine = engine;
      final weights = FakeMaiaWeightsService(downloadSucceeds: false);
      final container = await makeMaiaContainer(weights);

      final move = await readOpponentFor(container, const MaiaOpponentSpec(MaiaRating.maia1900))
          .findMove(
            initialPosition: Chess.initial,
            moves: const IListConst([]),
            variant: Variant.standard,
          );

      // A game against a Maia of the wrong strength beats no game at all.
      expect(move, isNotEmpty);
      expect(engine.options['WeightsFile'], '/fake/maia/maia-1500.pb.gz');
    });

    test('every rating shares one LC0 engine', () async {
      final engine = FakeEngine();
      fakeEngine = engine;
      final weights = FakeMaiaWeightsService(available: MaiaRating.values.toSet());
      final container = await makeMaiaContainer(weights);

      for (final rating in [MaiaRating.maia1100, MaiaRating.maia1900]) {
        await readOpponentFor(container, MaiaOpponentSpec(rating)).findMove(
          initialPosition: Chess.initial,
          moves: const IListConst([]),
          variant: Variant.standard,
        );
      }

      // The network is a per-search option, so two ratings are the same spec and never fight over
      // the one LC0 slot.
      expect(engine.startCount, 1);
      expect(engine.options['WeightsFile'], '/fake/maia/maia-1900.pb.gz');
    });
  });

  group('MaiaOpponent thinking time', () {
    /// A container whose Maia opponent waits [think] before answering, however fast the engine is.
    Future<ProviderContainer> makeSlowContainer(Duration think) => makeContainer(
      overrides: {
        maiaWeightsServiceProvider: maiaWeightsServiceProvider.overrideWithValue(
          FakeMaiaWeightsService(),
        ),
        thinkingTimeProvider: thinkingTimeProvider.overrideWithValue(FixedThinkingTime(think)),
      },
    );

    test('sits on the move instead of answering the instant the engine does', () async {
      fakeEngine = FakeEngine();
      final container = await makeSlowContainer(const Duration(milliseconds: 200));
      final opponent = readOpponentFor(container, const MaiaOpponentSpec(MaiaRating.maia1500));

      final elapsed = Stopwatch()..start();
      await opponent.findMove(
        initialPosition: Chess.initial,
        moves: const IListConst([]),
        variant: Variant.standard,
      );

      // The fake engine answers immediately; without the wait this would be a couple of
      // milliseconds, and a move landing the instant you finish yours is the tell.
      expect(elapsed.elapsed, greaterThanOrEqualTo(const Duration(milliseconds: 180)));
    });

    test('the wait covers the search rather than being added to it', () async {
      // An engine that takes 150ms of the 200ms think, so only 50ms should be left to wait.
      fakeEngine = SlowEngine(const Duration(milliseconds: 150));
      final container = await makeSlowContainer(const Duration(milliseconds: 200));
      final opponent = readOpponentFor(container, const MaiaOpponentSpec(MaiaRating.maia1500));

      final elapsed = Stopwatch()..start();
      await opponent.findMove(
        initialPosition: Chess.initial,
        moves: const IListConst([]),
        variant: Variant.standard,
      );

      expect(elapsed.elapsed, greaterThanOrEqualTo(const Duration(milliseconds: 180)));
      expect(elapsed.elapsed, lessThan(const Duration(milliseconds: 340)));
    });

    test('a stop during the wait cancels the move rather than playing it late', () async {
      fakeEngine = FakeEngine();
      final container = await makeSlowContainer(const Duration(seconds: 5));
      final opponent = readOpponentFor(container, const MaiaOpponentSpec(MaiaRating.maia1500));

      final move = opponent.findMove(
        initialPosition: Chess.initial,
        moves: const IListConst([]),
        variant: Variant.standard,
      );

      // Long enough for the engine to have answered and the wait to be all that is left. A
      // takeback or a resignation here must not be followed by the move landing five seconds on.
      await pumpEventQueue();
      opponent.stop();

      await expectLater(move, throwsA(isA<MoveSearchCancelled>()));
    });
  });

  group('OpponentSpec', () {
    test('round-trips through JSON', () {
      for (final spec in <OpponentSpec>[
        const StockfishOpponentSpec(StockfishLevel.level7),
        const MaiaOpponentSpec(MaiaRating.maia1300),
      ]) {
        expect(OpponentSpec.fromJson(spec.toJson()), spec);
      }
    });

    test('falls back to the default rather than throwing on an unknown opponent', () {
      expect(
        OpponentSpec.fromJson(const {'type': 'leela', 'rating': 'maia9000'}),
        const StockfishOpponentSpec(StockfishLevel.defaultLevel),
      );
    });

    test('only Stockfish plays the variants', () {
      expect(
        const StockfishOpponentSpec(StockfishLevel.level1).supportsVariant(Variant.atomic),
        isTrue,
      );
      expect(const MaiaOpponentSpec(MaiaRating.maia1500).supportsVariant(Variant.atomic), isFalse);
      expect(const MaiaOpponentSpec(MaiaRating.maia1500).supportsVariant(Variant.standard), isTrue);
    });
  });
}
