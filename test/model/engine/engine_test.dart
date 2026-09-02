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
  int threads = 1,
  Object game = 'test-game',
}) => SearchRequest(
  initialPosition: Chess.initial,
  moves: moves,
  variant: variant,
  limit: SearchLimit.movetime(searchTime),
  fenOverride: fenOverride,
  multiPv: multiPv,
  threads: threads,
  options: options,
  game: game,
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

    test('a search for another game is announced as one, and only its first is', () async {
      final transport = FakeTransport();
      final engine = Engine(transport);
      addTearDown(engine.dispose);
      await pumpEventQueue();

      await startSearch(engine, transport, makeRequest());
      transport.emit('bestmove e2e4');
      await pumpEventQueue();
      transport.takeCommands();

      // The engine is not fresh any more: what says that the table it has built up is for another
      // game is that this search names a different one.
      await startSearch(engine, transport, makeRequest(game: 'another-game'));
      expect(transport.takeCommands(), containsAllInOrder(<String>['ucinewgame', 'isready']));

      transport.emit('bestmove e2e4');
      await pumpEventQueue();

      // Still that game: the table it is filling is the one this search wants.
      await startSearch(engine, transport, makeRequest(game: 'another-game'));
      expect(transport.takeCommands(), isNot(contains('ucinewgame')));
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

    test('the hash is the one the engine was created with, and is never re-sent', () async {
      // The table belongs to the engine, not to the search: `setoption name Hash` frees it and
      // allocates and zeroes a new one on the thread running the UCI loop, which is where an engine
      // stops being able to read `quit`. On a variant offline game the opponent and the evaluator
      // are literally the same engine, so a per-search size would rebuild it on every hand-off.
      final transport = FakeTransport();
      final engine = Engine(transport, hashSizeInMb: 96);
      addTearDown(engine.dispose);
      await pumpEventQueue();

      await startSearch(engine, transport, makeRequest());
      expect(transport.takeCommands(), contains('setoption name Hash value 96'));
      transport.emit('bestmove e2e4');
      await pumpEventQueue();

      // Every later search runs on the table already allocated, whoever asked for it.
      await startSearch(engine, transport, makeRequest(multiPv: 3));
      expect(transport.takeCommands().join(' '), isNot(contains('Hash')));
    });

    test('threads are set before the hash', () async {
      // `setoption name Threads` reallocates and zeroes the table at whatever `Hash` currently is
      // (`Engine::resize_threads` -> `set_tt_size(options["Hash"])`). This way round costs one
      // zeroing of the 16MB default plus one of the real size; reversed, it costs two of the real
      // size on every engine that starts.
      final transport = FakeTransport();
      final engine = Engine(transport, hashSizeInMb: 96);
      addTearDown(engine.dispose);
      await pumpEventQueue();

      await startSearch(engine, transport, makeRequest(threads: 2));

      final commands = transport.takeCommands();
      final threads = commands.indexWhere((c) => c.startsWith('setoption name Threads'));
      final hash = commands.indexWhere((c) => c.startsWith('setoption name Hash'));
      expect(threads, greaterThanOrEqualTo(0));
      expect(hash, greaterThan(threads));
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

  // The `option` declarations of the `uci` handshake are what option hygiene puts an option back
  // to, so the parser has to read what real engines actually print. The lines below are copied
  // from Stockfish 17, Fairy-Stockfish and LC0 v0.32.1 handshakes.
  //
  // The grammar is:
  //   option name <name…> type <type> [default <value…>] [min <x>] [max <x>] [var <x>]…
  // A value can hold spaces, so it runs to the next `min`, `max` or `var` keyword, or to the end
  // of the line.
  group('Engine option declarations', () {
    test('a spin default stops before min and max', () async {
      expect(
        await declaredDefaultOf('Skill Level', const [
          'option name Skill Level type spin default 20 min 0 max 20',
        ]),
        '20',
      );
    });

    test('a negative spin default is read whole', () async {
      // LC0's `TaskWorkers`, and Fairy's `Skill Level`, both go below zero.
      expect(
        await declaredDefaultOf('TaskWorkers', const [
          'option name TaskWorkers type spin default -1 min -1 max 128',
        ]),
        '-1',
      );
    });

    test('a combo default stops before the var list', () async {
      expect(
        await declaredDefaultOf('ScoreType', const [
          'option name ScoreType type combo default WDL_mu var centipawn var Q var W-L var WDL_mu',
        ]),
        'WDL_mu',
      );
    });

    test('a check default is read as its literal', () async {
      expect(
        await declaredDefaultOf('Syzygy50MoveRule', const [
          'option name Syzygy50MoveRule type check default true',
        ]),
        'true',
      );
    });

    test('a string default is read whole, spaces and all', () async {
      // A file name may hold spaces; Stockfish reads a `setoption` value the same way, joining
      // its tokens with single spaces, so this round-trips.
      expect(
        await declaredDefaultOf('EvalFile', const [
          'option name EvalFile type string default nn-1c0000000000.nnue',
        ]),
        'nn-1c0000000000.nnue',
      );
      expect(
        await declaredDefaultOf('Debug Log File', const [
          'option name Debug Log File type string default my engine log.txt',
        ]),
        'my engine log.txt',
      );
    });

    test("Stockfish's <empty> and LC0's blank string default both mean the empty value", () async {
      // Stockfish prints `<empty>` for an empty string option, LC0 prints nothing at all after
      // `default`. Fairy-Stockfish goes the other way and takes `<empty>` as a value meaning
      // none, so the empty string we send back is the same thing to it.
      expect(
        await declaredDefaultOf('SyzygyPath', const [
          'option name SyzygyPath type string default <empty>',
        ]),
        '',
      );
      expect(
        await declaredDefaultOf('LogFile', const ['option name LogFile type string default ']),
        '',
      );
      expect(
        await declaredDefaultOf('BackendOptions', const [
          'option name BackendOptions type string default',
        ]),
        '',
      );
    });

    test('a default declared after min and max is still found', () async {
      // The spec fixes no order for the keywords after `type`, only that each value runs to the
      // next one.
      expect(
        await declaredDefaultOf('Weird', const [
          'option name Weird type spin min 1 max 10 default 5',
        ]),
        '5',
      );
    });

    test('a name is taken up to the type keyword, however many words it holds', () async {
      expect(
        await declaredDefaultOf('Use NNUE', const ['option name Use NNUE type check default true']),
        'true',
      );
    });

    test('padding between the tokens is not part of the name or the value', () async {
      expect(
        await declaredDefaultOf('Skill Level', const [
          '  option   name  Skill   Level  type spin  default  20  min 0 max 20',
        ]),
        '20',
      );
    });

    test('the last declaration of an option wins', () async {
      expect(
        await declaredDefaultOf('Skill Level', const [
          'option name Skill Level type spin default 20 min 0 max 20',
          'option name Skill Level type spin default 12 min 0 max 20',
        ]),
        '12',
      );
    });

    test('a button is not an option to be put back', () async {
      // `Clear Hash` is a button: setting it is what presses it, and pressing it wipes the
      // transposition table. It has no default, and must never be reset like a value option.
      final transport = FakeTransport(
        startupLines: const [
          'id name Stockfish 17',
          'option name Clear Hash type button',
          'option name Skill Level type spin default 20 min 0 max 20',
          'uciok',
        ],
      );
      final engine = Engine(transport);
      addTearDown(engine.dispose);
      await pumpEventQueue();

      await startSearch(
        engine,
        transport,
        makeRequest(options: const IMapConst({'Clear Hash': 'now', 'Skill Level': '3'})),
      );
      transport.emit('bestmove e2e4');
      await pumpEventQueue();
      transport.takeCommands();

      // The search that follows names neither, but only the value option is put back.
      await startSearch(engine, transport, makeRequest());
      final commands = transport.takeCommands();
      expect(commands, contains('setoption name Skill Level value 20'));
      expect(commands.join(' '), isNot(contains('Clear Hash')));
    });

    test('a declaration that is not one is ignored, and does not stop the others', () async {
      final transport = FakeTransport(
        startupLines: const [
          'id name Stockfish 17',
          'option',
          'option name',
          'option name type spin default 1',
          'option Skill Level type spin default 20',
          'option name Skill Level type spin default 20 min 0 max 20',
          'uciok',
        ],
      );
      final engine = Engine(transport);
      addTearDown(engine.dispose);
      await pumpEventQueue();

      await startSearch(
        engine,
        transport,
        makeRequest(options: const IMapConst({'Skill Level': '3'})),
      );
      transport.emit('bestmove e2e4');
      await pumpEventQueue();
      transport.takeCommands();

      await startSearch(engine, transport, makeRequest());
      expect(transport.takeCommands(), contains('setoption name Skill Level value 20'));
    });

    test('a real LC0 handshake is read the way LC0 means it', () async {
      // Verbatim from `lc0 v0.32.1`, which is the shape the app runs.
      const contemptMode =
          'option name ContemptMode type combo default play var play var white_side_analysis '
          'var black_side_analysis var disable';
      const lc0 = [
        'option name LogFile type string default ',
        'option name ConfigFile type string default lc0.config',
        'option name Threads type spin default 0 min 0 max 128',
        'option name CPuct type string default 1.745000',
        'option name FpuStrategy type combo default reduction var reduction var absolute',
        contemptMode,
        'option name HistoryFill type combo default fen_only var no var fen_only var always',
        'option name WeightsFile type string default <autodiscover>',
        'option name Backend type combo default metal var metal var blas var eigen var random',
        'option name UCI_Chess960 type check default false',
      ];

      expect(await declaredDefaultOf('CPuct', lc0), '1.745000');
      expect(await declaredDefaultOf('FpuStrategy', lc0), 'reduction');
      expect(await declaredDefaultOf('ContemptMode', lc0), 'play');
      expect(await declaredDefaultOf('HistoryFill', lc0), 'fen_only');
      expect(await declaredDefaultOf('WeightsFile', lc0), '<autodiscover>');
      expect(await declaredDefaultOf('Backend', lc0), 'metal');
      expect(await declaredDefaultOf('ConfigFile', lc0), 'lc0.config');
      expect(await declaredDefaultOf('LogFile', lc0), '');
    });
  });
}

/// The value an engine that declared [declarations] puts [name] back to, once a search has moved
/// it off its default.
///
/// This is the only way the parsed declarations are observable from outside: option hygiene sends
/// an option the current search does not name back to the default the engine declared for it.
Future<String?> declaredDefaultOf(
  String name,
  List<String> declarations, {
  String set = 'something else',
}) async {
  final transport = FakeTransport(startupLines: ['id name Fake Engine', ...declarations, 'uciok']);
  final engine = Engine(transport);
  await pumpEventQueue();

  await startSearch(engine, transport, makeRequest(options: IMap({name: set})));
  transport.emit('bestmove e2e4');
  await pumpEventQueue();
  transport.takeCommands();

  await startSearch(engine, transport, makeRequest());
  final prefix = 'setoption name $name value ';
  final reset = transport.takeCommands().where((command) => command.startsWith(prefix)).lastOrNull;
  await engine.dispose();
  return reset?.substring(prefix.length);
}
