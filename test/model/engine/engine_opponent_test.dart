import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/engine/engine_budget.dart';
import 'package:lichess_mobile/src/model/engine/engine_opponent.dart';
import 'package:lichess_mobile/src/model/engine/maia_book.dart';
import 'package:lichess_mobile/src/model/engine/maia_online_book.dart';
import 'package:lichess_mobile/src/model/engine/opponent_level.dart';

import 'package:lichess_mobile/src/model/engine/thinking_time.dart';
import 'package:lichess_mobile/src/model/engine/weights_service.dart';

import '../../test_container.dart';
import 'fake_engine.dart';
import 'fake_maia_book_service.dart';
import 'fake_maia_online_book.dart';
import 'fake_weights_service.dart';
import 'polyglot_fixture.dart';

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

      // On a variant the opponent and the hints are the same Fairy-Stockfish, and a `Threads` the
      // two roles disagree about tears the thread pool down and rebuilds it — clearing the
      // transposition table with it — on every hand-off.
      expect(engine.options['Threads'], budget.offlineEvalThreads.toString());
      // The table is the engine's own, settled when it was created.
      expect(engine.options['Hash'], budget.engineHash.toString());
    });

    test('searches on the threads its level asks for when it has its own engine', () async {
      final engine = FakeEngine();
      fakeEngine = engine;
      final container = await makeContainer();
      final budget = container.read(engineBudgetProvider);

      await readOpponent(container, StockfishLevel.level6).findMove(
        initialPosition: Chess.initial,
        moves: const IListConst([]),
        variant: Variant.standard,
      );

      expect(engine.options['Threads'], '2');
      expect(engine.options['Hash'], budget.engineHash.toString());
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
    Future<ProviderContainer> makeMaiaContainer(FakeMaiaWeightsService weights, {MaiaBook? book}) =>
        makeContainer(
          overrides: {
            maiaWeightsServiceProvider: maiaWeightsServiceProvider.overrideWithValue(weights),
            maiaBookServiceProvider: maiaBookServiceProvider.overrideWithValue(
              FakeMaiaBookService(book: book),
            ),
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

      // The two temperatures compose: the priors are softmaxed at `PolicyTemperature`, then each
      // move is weighted `pow(prior, 1 / Temperature)`. Pinning the first to Maia's training value
      // is what makes the second one readable.
      expect(engine.options['PolicyTemperature'], '1.0');
      expect(engine.options['Temperature'], '0.8');
      // The full temperature holds until the opening book runs out at move 5, then fades.
      expect(engine.options['TempDecayDelayMoves'], '5');
      expect(engine.options['TempDecayMoves'], '35');
      // Not a phase of the game: with no `TempCutoffMove` this is the floor the decay stops at.
      expect(engine.options['TempEndgame'], '0.2');
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

  group('MaiaOpponent opening book', () {
    /// A book that answers the initial position and nothing else.
    MaiaBook firstMoveBook() => MaiaBook(bookFor(Chess.initial, {'e2e4': 1000}));

    Future<ProviderContainer> makeBookContainer(MaiaBook? book, {MaiaOnlineBook? online}) =>
        makeContainer(
          overrides: {
            maiaWeightsServiceProvider: maiaWeightsServiceProvider.overrideWithValue(
              FakeMaiaWeightsService(),
            ),
            maiaBookServiceProvider: maiaBookServiceProvider.overrideWithValue(
              FakeMaiaBookService(book: book),
            ),
            if (online != null)
              maiaOnlineBookProvider: maiaOnlineBookProvider.overrideWithValue(online),
          },
        );

    test('plays a book move without asking the engine for one', () async {
      final engine = FakeEngine();
      fakeEngine = engine;
      final container = await makeBookContainer(firstMoveBook());

      final move = await readOpponentFor(container, const MaiaOpponentSpec(MaiaRating.maia1500))
          .findMove(
            initialPosition: Chess.initial,
            moves: const IListConst([]),
            variant: Variant.standard,
          );

      expect(move, 'e2e4');
      // The opponent keeps an engine alive for the game either way; what the book saves is the
      // search, which is the whole point of putting it in front of the engine.
      expect(engine.commands.where((command) => command.startsWith('go')), isEmpty);
    });

    test('prefers the online book, which knows its own rating band', () async {
      final engine = FakeEngine();
      fakeEngine = engine;
      final container = await makeBookContainer(
        firstMoveBook(),
        online: FakeMaiaOnlineBook(
          moves: {
            Chess.initial.fen: [(uci: 'd2d4', weight: 1000)],
          },
        ),
      );

      final move = await readOpponentFor(container, const MaiaOpponentSpec(MaiaRating.maia1500))
          .findMove(
            initialPosition: Chess.initial,
            moves: const IListConst([]),
            variant: Variant.standard,
          );

      // The bundled book only ever plays e2e4 here.
      expect(move, 'd2d4');
      expect(engine.commands.where((command) => command.startsWith('go')), isEmpty);
    });

    test('falls back to the bundled book when the online one cannot answer', () async {
      final engine = FakeEngine();
      fakeEngine = engine;
      final online = FakeMaiaOnlineBook();
      final container = await makeBookContainer(firstMoveBook(), online: online);

      final move = await readOpponentFor(container, const MaiaOpponentSpec(MaiaRating.maia1500))
          .findMove(
            initialPosition: Chess.initial,
            moves: const IListConst([]),
            variant: Variant.standard,
          );

      expect(online.requests, [Chess.initial.fen]);
      expect(move, 'e2e4');
      expect(engine.commands.where((command) => command.startsWith('go')), isEmpty);
    });

    test('falls through to the engine once out of book', () async {
      final engine = FakeEngine();
      fakeEngine = engine;
      final container = await makeBookContainer(firstMoveBook());

      final move = await readOpponentFor(container, const MaiaOpponentSpec(MaiaRating.maia1500))
          .findMove(
            initialPosition: Chess.initial,
            moves: const IListConst(['e2e4', 'e7e5']),
            variant: Variant.standard,
          );

      expect(move, isNotEmpty);
      expect(engine.commands.where((command) => command.startsWith('go')), hasLength(1));
    });

    test('plays its own moves when there is no book to read', () async {
      final engine = FakeEngine();
      fakeEngine = engine;
      final container = await makeBookContainer(null);

      await readOpponentFor(container, const MaiaOpponentSpec(MaiaRating.maia1500)).findMove(
        initialPosition: Chess.initial,
        moves: const IListConst([]),
        variant: Variant.standard,
      );

      expect(engine.commands.where((command) => command.startsWith('go')), hasLength(1));
    });

    test('skips the book from a position other than the standard start', () async {
      final engine = FakeEngine();
      fakeEngine = engine;
      final container = await makeBookContainer(firstMoveBook());
      final books = container.read(maiaBookServiceProvider) as FakeMaiaBookService;

      await readOpponentFor(container, const MaiaOpponentSpec(MaiaRating.maia1500)).findMove(
        initialPosition: Chess.fromSetup(
          Setup.parseFen('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b KQkq - 0 1'),
        ),
        moves: const IListConst([]),
        variant: Variant.standard,
      );

      expect(books.requests, isEmpty);
      expect(engine.commands.where((command) => command.startsWith('go')), hasLength(1));
    });

    test('skips the book outside standard chess', () async {
      final engine = FakeEngine();
      fakeEngine = engine;
      final container = await makeBookContainer(firstMoveBook());
      final books = container.read(maiaBookServiceProvider) as FakeMaiaBookService;

      await readOpponentFor(container, const MaiaOpponentSpec(MaiaRating.maia1500)).findMove(
        initialPosition: Chess.initial,
        moves: const IListConst([]),
        variant: Variant.chess960,
      );

      expect(books.requests, isEmpty);
      expect(engine.commands.where((command) => command.startsWith('go')), hasLength(1));
    });

    test('reads the book of the rating it is playing at', () async {
      fakeEngine = FakeEngine();
      final container = await makeBookContainer(firstMoveBook());
      final books = container.read(maiaBookServiceProvider) as FakeMaiaBookService;

      await readOpponentFor(container, const MaiaOpponentSpec(MaiaRating.maia1900)).findMove(
        initialPosition: Chess.initial,
        moves: const IListConst([]),
        variant: Variant.standard,
      );

      expect(books.requests, [MaiaRating.maia1900]);
    });
  });

  group('MaiaOpponent thinking time', () {
    /// A container whose Maia opponent waits [think] before answering, however fast the engine is.
    Future<ProviderContainer> makeSlowContainer(Duration think, {MaiaBook? book}) => makeContainer(
      overrides: {
        maiaWeightsServiceProvider: maiaWeightsServiceProvider.overrideWithValue(
          FakeMaiaWeightsService(),
        ),
        thinkingTimeProvider: thinkingTimeProvider.overrideWithValue(FixedThinkingTime(think)),
        maiaBookServiceProvider: maiaBookServiceProvider.overrideWithValue(
          FakeMaiaBookService(book: book),
        ),
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

    test('a book move waits as long as a searched one', () async {
      fakeEngine = FakeEngine();
      final container = await makeSlowContainer(
        const Duration(milliseconds: 200),
        book: MaiaBook(bookFor(Chess.initial, {'e2e4': 1000})),
      );
      final opponent = readOpponentFor(container, const MaiaOpponentSpec(MaiaRating.maia1500));

      final elapsed = Stopwatch()..start();
      final move = await opponent.findMove(
        initialPosition: Chess.initial,
        moves: const IListConst([]),
        variant: Variant.standard,
      );

      // A book lookup is instant, which would make the opening the most obviously inhuman part of
      // the game if the wait did not cover it too.
      expect(move, 'e2e4');
      expect(elapsed.elapsed, greaterThanOrEqualTo(const Duration(milliseconds: 180)));
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
      expect(
        const StockfishOpponentSpec(StockfishLevel.level1).supportsVariant(Variant.chess960),
        isTrue,
      );
      expect(const MaiaOpponentSpec(MaiaRating.maia1500).supportsVariant(Variant.atomic), isFalse);
      expect(
        const MaiaOpponentSpec(MaiaRating.maia1500).supportsVariant(Variant.chess960),
        isFalse,
      );
      expect(const MaiaOpponentSpec(MaiaRating.maia1500).supportsVariant(Variant.standard), isTrue);
      expect(
        const MaiaOpponentSpec(MaiaRating.maia1500).supportsVariant(Variant.fromPosition),
        isTrue,
      );
    });
  });
}
