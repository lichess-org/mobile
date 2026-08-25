import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/engine/engine_opponent.dart';
import 'package:lichess_mobile/src/model/engine/opponent_level.dart';

import '../../test_container.dart';
import 'fake_engine.dart';

/// The opponent for [level], kept alive for the duration of the test.
EngineOpponent readOpponent(ProviderContainer container, [StockfishLevel? level]) {
  final provider = engineOpponentProvider(StockfishOpponentSpec(level ?? StockfishLevel.level3));
  container.listen(provider, (_, _) {});
  return container.read(provider);
}

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
      expect(engine.spec?.flavor.name, 'variant');
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
}
