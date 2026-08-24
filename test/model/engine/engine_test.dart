import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/engine_failure.dart';
import 'package:lichess_mobile/src/model/engine/engine_spec.dart';
import 'package:multistockfish/multistockfish.dart';

import 'fake_transport.dart';

SearchRequest makeRequest({
  Variant variant = Variant.standard,
  IList<UCIMove> moves = const IListConst([]),
  IMap<String, String> options = const IMapConst({}),
  Duration searchTime = const Duration(seconds: 1),
  String? fenOverride,
  int multiPv = 1,
  bool newGame = false,
}) => SearchRequest(
  initialPosition: Chess.initial,
  moves: moves,
  variant: variant,
  limit: SearchLimit.movetime(searchTime),
  fenOverride: fenOverride,
  multiPv: multiPv,
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

      expect(transport.takeCommands(), ['isready']);
      expect(engine.isSearching.value, isFalse);

      transport.emit('readyok');
      await pumpEventQueue();

      expect(transport.commands, [
        'setoption name UCI_Chess960 value true',
        // A fresh engine has never been told what it is playing.
        'ucinewgame',
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
        expect(
          transport.takeCommands(),
          containsAllInOrder(<String>[
            'setoption name UCI_Variant value crazyhouse',
            'ucinewgame',
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
        const EngineFailure(
          kind: EngineFailureKind.runtime,
          message: 'boom',
          flavor: StockfishFlavor.sf16,
        ),
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
