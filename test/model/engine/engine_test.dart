import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/engine_failure.dart';
import 'package:lichess_mobile/src/model/engine/engine_spec.dart';

import 'fake_transport.dart';

SearchRequest makeRequest({
  Variant variant = Variant.standard,
  IList<UCIMove> moves = const IListConst([]),
  IMap<String, String> options = const IMapConst({}),
  Duration searchTime = const Duration(seconds: 1),
  String? fenOverride,
  int multiPv = 1,
  int hashSize = 16,
  bool newGame = false,
}) => SearchRequest(
  initialPosition: Chess.initial,
  moves: moves,
  variant: variant,
  limit: SearchLimit.movetime(searchTime),
  fenOverride: fenOverride,
  multiPv: multiPv,
  hashSize: hashSize,
  options: options,
  newGame: newGame,
);

/// Runs [engine] up to the point where it has issued the commands for [request].
Future<Search> startSearch(Engine engine, FakeTransport transport, SearchRequest request) async {
  final search = engine.search(request);
  await pumpEventQueue();
  transport.emit('readyok');
  await pumpEventQueue();
  return search;
}

void main() {
  group('Engine', () {
    test('picks up the name and the option defaults from the handshake it missed', () async {
      final transport = FakeTransport();
      final engine = Engine(transport);
      await pumpEventQueue();

      expect(engine.name.value, 'Stockfish 16.1');
      addTearDown(engine.dispose);
    });

    test('a search is announced with a ready handshake and issued on readyok', () async {
      final transport = FakeTransport();
      final engine = Engine(transport);
      addTearDown(engine.dispose);
      await pumpEventQueue();

      engine.search(makeRequest());
      await pumpEventQueue();

      // A fresh engine has never been told what it is playing, and `ucinewgame` goes in front of
      // the handshake: clearing the hash takes the engine a moment, and `readyok` is how it says
      // it is done.
      expect(transport.takeCommands(), ['ucinewgame', 'isready']);
      expect(engine.isSearching.value, isFalse);

      transport.emit('readyok');
      await pumpEventQueue();

      expect(transport.commands, [
        'setoption name UCI_Chess960 value true',
        'position fen ${Chess.initial.fen}',
        'go movetime 1000',
      ]);
      expect(engine.isSearching.value, isTrue);
    });

    test('options already at their declared value are not sent again', () async {
      final transport = FakeTransport();
      final engine = Engine(transport);
      addTearDown(engine.dispose);
      await pumpEventQueue();

      await startSearch(engine, transport, makeRequest());
      transport.takeCommands();

      transport.emit('bestmove e2e4');
      await pumpEventQueue();
      await startSearch(engine, transport, makeRequest());

      // Threads, Hash and MultiPV are all at their defaults, and UCI_Chess960 has not changed
      // since the first search, so only the position and the search itself are sent.
      expect(transport.takeCommands(), [
        'isready',
        'position fen ${Chess.initial.fen}',
        'go movetime 1000',
      ]);
    });

    test('an option a search does not name is put back to its declared default', () async {
      final transport = FakeTransport();
      final engine = Engine(transport);
      addTearDown(engine.dispose);
      await pumpEventQueue();

      await startSearch(
        engine,
        transport,
        makeRequest(options: const IMapConst({'Skill Level': '3'})),
      );
      expect(transport.takeCommands(), contains('setoption name Skill Level value 3'));

      transport.emit('bestmove e2e4');
      await pumpEventQueue();

      // The next search says nothing about Skill Level, so it must not inherit a deliberately
      // weakened engine.
      await startSearch(engine, transport, makeRequest());
      expect(transport.takeCommands(), contains('setoption name Skill Level value 20'));
    });

    test('an option is reset even when the engine declared no defaults', () async {
      // A handshake with no `option` lines is what the plugin's own fakes produce, and what an
      // engine that answers `uciok` without listing its options would look like.
      final transport = FakeTransport(startupLines: const ['id name Stockfish 16.1', 'uciok']);
      final engine = Engine(transport);
      addTearDown(engine.dispose);
      await pumpEventQueue();

      await startSearch(
        engine,
        transport,
        makeRequest(options: const IMapConst({'Skill Level': '-8'})),
      );
      expect(transport.takeCommands(), contains('setoption name Skill Level value -8'));

      transport.emit('bestmove e2e4');
      await pumpEventQueue();

      await startSearch(engine, transport, makeRequest());
      expect(transport.takeCommands(), contains('setoption name Skill Level value 20'));
    });

    test(
      'a Fairy engine is given the variant per search, and a new game when it changes',
      () async {
        final transport = FakeTransport(spec: const StockfishSpec.fairy());
        final engine = Engine(transport);
        addTearDown(engine.dispose);
        await pumpEventQueue();

        await startSearch(engine, transport, makeRequest(variant: Variant.crazyhouse));
        // The fresh engine's own `ucinewgame` already covers the variant it starts on, so the
        // variant change does not send a second one.
        expect(
          transport.takeCommands(),
          containsAllInOrder(<String>[
            'ucinewgame',
            'isready',
            'setoption name UCI_Variant value crazyhouse',
            'position fen ${Chess.initial.fen}',
          ]),
        );

        transport.emit('bestmove e2e4');
        await pumpEventQueue();

        // Same engine, another variant: no restart, but its rules have to be rebuilt before the
        // position is set up under them.
        await startSearch(engine, transport, makeRequest(variant: Variant.atomic));
        expect(
          transport.takeCommands(),
          containsAllInOrder(<String>[
            'setoption name UCI_Variant value atomic',
            'ucinewgame',
            'position fen ${Chess.initial.fen}',
          ]),
        );
      },
    );

    test('the hash grows to the largest a search asks for and never shrinks again', () async {
      // On a variant offline game the opponent and the evaluator share one engine and ask for
      // different sizes on alternating moves. Honouring each one would rebuild the transposition
      // table every hand-off, on the thread running the UCI loop, which is where an engine stops
      // being able to read `quit`.
      final transport = FakeTransport();
      final engine = Engine(transport);
      addTearDown(engine.dispose);
      await pumpEventQueue();

      // The opponent's turn: a small table.
      await startSearch(engine, transport, makeRequest(hashSize: 48));
      expect(transport.takeCommands(), contains('setoption name Hash value 48'));
      transport.emit('bestmove e2e4');
      await pumpEventQueue();

      // The evaluator's turn: a larger one, which the engine does grow to.
      await startSearch(engine, transport, makeRequest(hashSize: 144));
      expect(transport.takeCommands(), contains('setoption name Hash value 144'));
      transport.emit('bestmove e2e4');
      await pumpEventQueue();

      // Back to the opponent. The table it gets is the one already allocated, not a new one.
      await startSearch(engine, transport, makeRequest(hashSize: 48));
      expect(transport.takeCommands().join(' '), isNot(contains('Hash')));
    });

    test("an option the engine did not declare is not sent on the engine's behalf", () async {
      // LC0 has no `Hash`, and sending it one is an `error Unknown option` on every search.
      final transport = FakeTransport(
        spec: const Lc0Spec(),
        startupLines: const ['id name Lc0 v0.32.1', ...kFakeLc0OptionDeclarations, 'uciok'],
      );
      final engine = Engine(transport);
      addTearDown(engine.dispose);
      await pumpEventQueue();

      await startSearch(engine, transport, makeRequest());

      final commands = transport.takeCommands().join(' ');
      expect(commands, isNot(contains('Hash')));
      // The ones it did declare still go out.
      expect(commands, contains('setoption name UCI_Chess960 value true'));
    });

    test('an option the caller named is sent even when the engine did not declare it', () async {
      // LC0 accepts `Temperature` by name but declares it "pro only", so it never reaches the
      // handshake. A caller that names an option meant it; only the engine's own guesses at the
      // vocabulary are dropped.
      final transport = FakeTransport(
        spec: const Lc0Spec(),
        startupLines: const ['id name Lc0 v0.32.1', ...kFakeLc0OptionDeclarations, 'uciok'],
      );
      final engine = Engine(transport);
      addTearDown(engine.dispose);
      await pumpEventQueue();

      await startSearch(
        engine,
        transport,
        makeRequest(options: const IMapConst({'Temperature': '0.5'})),
      );
      expect(transport.takeCommands(), contains('setoption name Temperature value 0.5'));

      transport.emit('bestmove e2e4');
      await pumpEventQueue();

      // And it is still put back afterwards, from the fallback defaults, since the engine never
      // declared one to put it back to.
      await startSearch(engine, transport, makeRequest());
      expect(transport.takeCommands(), contains('setoption name Temperature value 0'));
    });

    test('a standard engine is never told about UCI_Variant', () async {
      final transport = FakeTransport();
      final engine = Engine(transport);
      addTearDown(engine.dispose);
      await pumpEventQueue();

      await startSearch(engine, transport, makeRequest());
      expect(transport.takeCommands().join(' '), isNot(contains('UCI_Variant')));
    });

    test('a search of a doctored FEN is sent without the moves that led to it', () async {
      final transport = FakeTransport();
      final engine = Engine(transport);
      addTearDown(engine.dispose);
      await pumpEventQueue();

      const fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b KQkq - 1 1';
      await startSearch(
        engine,
        transport,
        makeRequest(moves: const IListConst(['e2e4']), fenOverride: fen),
      );

      expect(transport.takeCommands(), contains('position fen $fen'));
    });

    test('info lines are parsed and delivered to the running search', () async {
      final transport = FakeTransport();
      final engine = Engine(transport);
      addTearDown(engine.dispose);
      await pumpEventQueue();

      final search = await startSearch(engine, transport, makeRequest());
      final infos = <UciInfo>[];
      search.infos.listen(infos.add);

      transport.emit(
        'info depth 18 seldepth 24 multipv 1 score cp 31 nodes 12345 nps 359000 time 240 '
        'pv e2e4 e7e5 g1f3',
      );
      transport.emit('info depth 19 multipv 1 score mate -3 nodes 22345 time 300 pv e2e4');
      await pumpEventQueue();

      expect(infos, hasLength(2));
      expect(infos.first.depth, 18);
      expect(infos.first.nodes, 12345);
      expect(infos.first.cp, 31);
      expect(infos.first.mate, isNull);
      expect(infos.first.elapsed, const Duration(milliseconds: 240));
      expect(infos.first.pv, const IListConst(['e2e4', 'e7e5', 'g1f3']));
      expect(infos.last.mate, -3);
      expect(infos.last.cp, isNull);
    });

    test('bounds are reported rather than swallowed', () async {
      final transport = FakeTransport();
      final engine = Engine(transport);
      addTearDown(engine.dispose);
      await pumpEventQueue();

      final search = await startSearch(engine, transport, makeRequest());
      final infos = <UciInfo>[];
      search.infos.listen(infos.add);

      transport.emit('info depth 9 multipv 1 score cp 20 lowerbound nodes 1 time 1 pv e2e4');
      await pumpEventQueue();

      expect(infos.single.isLowerBound, isTrue);
      expect(infos.single.isUpperBound, isFalse);
    });

    test('a search completes with the engine bestmove', () async {
      final transport = FakeTransport();
      final engine = Engine(transport);
      addTearDown(engine.dispose);
      await pumpEventQueue();

      final search = await startSearch(engine, transport, makeRequest());
      transport.emit('bestmove g1f3 ponder b8c6');
      await pumpEventQueue();

      expect(await search.bestMove, 'g1f3');
      expect(engine.isSearching.value, isFalse);
    });

    test('a new search stops the running one and starts once it has answered', () async {
      final transport = FakeTransport();
      final engine = Engine(transport);
      addTearDown(engine.dispose);
      await pumpEventQueue();

      final first = await startSearch(engine, transport, makeRequest());
      transport.takeCommands();

      final second = engine.search(makeRequest(moves: const IListConst(['e2e4'])));
      await pumpEventQueue();

      expect(transport.takeCommands(), ['stop', 'isready']);

      // The engine has not answered yet, so the new search has not started either.
      transport.emit('readyok');
      await pumpEventQueue();
      expect(transport.commands, isEmpty);

      transport.emit('bestmove e2e4');
      await pumpEventQueue();

      expect(await first.bestMove, 'e2e4');
      expect(transport.takeCommands(), [
        'position fen ${Chess.initial.fen} moves e2e4',
        'go movetime 1000',
      ]);
      expect(engine.isSearching.value, isTrue);
      expect(second, isNotNull);
    });

    test('a search superseded before it started is answered with nothing', () async {
      final transport = FakeTransport();
      final engine = Engine(transport);
      addTearDown(engine.dispose);
      await pumpEventQueue();

      final superseded = engine.search(makeRequest());
      engine.search(makeRequest(moves: const IListConst(['d2d4'])));
      await pumpEventQueue();

      expect(await superseded.bestMove, isNull);
    });

    test('an engine that dies releases the searches waiting on it', () async {
      final transport = FakeTransport();
      final engine = Engine(transport);
      addTearDown(engine.dispose);
      await pumpEventQueue();

      final search = await startSearch(engine, transport, makeRequest());

      transport.die(
        const EngineFailure(kind: EngineFailureKind.runtime, message: 'boom', engine: 'sf16'),
      );
      await pumpEventQueue();

      expect(await search.bestMove, isNull);
      expect(engine.isSearching.value, isFalse);
      final failure = await engine.death;
      expect(failure?.kind, EngineFailureKind.runtime);
      // The engine knows what it was searching, which the transport underneath it does not.
      expect(failure?.variant, Variant.standard);
    });

    test('a search asked for on a dead engine is refused rather than left pending', () async {
      final transport = FakeTransport();
      final engine = Engine(transport);
      addTearDown(engine.dispose);
      await pumpEventQueue();

      transport.die();
      await pumpEventQueue();

      final search = engine.search(makeRequest());
      expect(await search.bestMove, isNull);
    });
  });
}
