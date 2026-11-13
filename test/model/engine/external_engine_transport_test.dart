import 'dart:async';
import 'dart:convert';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/engine_failure.dart';
import 'package:lichess_mobile/src/model/engine/engine_spec.dart';
import 'package:lichess_mobile/src/model/engine/engine_transport.dart';
import 'package:lichess_mobile/src/model/engine/external_engine_transport.dart';

import 'fake_external_engines.dart';

const testEngineSpec = ExternalEngineSpec(testExternalEngine);

const testAnalyseUrl = 'https://engine.lichess.ovh/api/external-engine/eei_aTKImBJOnv6j/analyse';

/// One iteration of a search, as the broker reports it.
const testNdjsonLine =
    '{"time":100,"depth":12,"nodes":5000,"pvs":['
    '{"depth":12,"cp":35,"moves":["g1f3","b8c6"]},'
    '{"depth":11,"cp":20,"moves":["f1c4"]}]}\n';

/// Every line the transport writes, filling as they arrive.
List<String> collect(EngineTransport transport) {
  final lines = <String>[];
  transport.lines.listen(lines.add);
  return lines;
}

/// A transport whose first listener has already been given the handshake.
Future<ExternalEngineTransport> connected(Client client) async {
  final transport = await ExternalEngineTransport.connect(testEngineSpec, client);
  addTearDown(transport.dispose);
  return transport;
}

/// Sets up the standard opening position with [moves] played from it.
void setUpPosition(ExternalEngineTransport transport, {List<String> moves = const []}) {
  transport.send(
    'position fen ${Chess.initial.fen}${moves.isEmpty ? '' : ' moves ${moves.join(' ')}'}',
  );
}

void main() {
  group('ExternalEngineTransport', () {
    test('the first listener gets the handshake the broker never runs', () async {
      final transport = await connected(MockClient((_) async => Response('', 200)));

      final lines = collect(transport);
      await pumpEventQueue();

      const variantDeclaration =
          'option name UCI_Variant type combo default chess var chess var crazyhouse var antichess '
          'var atomic var horde var kingofthehill var racingkings var 3check';
      expect(lines, [
        'id name External Stockfish',
        'option name MultiPV type spin default 1 min 1 max 256',
        variantDeclaration,
        'uciok',
      ]);
    });

    test('a search is one request carrying the registration, the position and the '
        'limit', () async {
      final requests = <Request>[];
      final transport = await connected(
        MockClient((request) async {
          requests.add(request);
          return Response('', 200);
        }),
      );
      final lines = collect(transport);
      await pumpEventQueue();

      transport.send('ucinewgame');
      transport.send('isready');
      transport.send('setoption name MultiPV value 2');
      transport.send('setoption name UCI_Variant value chess');
      setUpPosition(transport, moves: ['e2e4', 'e7e5']);
      transport.send('go movetime 4000');
      await pumpEventQueue();

      expect(lines, contains('readyok'));
      expect(requests, hasLength(1));

      final request = requests.single;
      expect(request.method, 'POST');
      expect(request.url.toString(), testAnalyseUrl);
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      expect(body['clientSecret'], 'ees_mdF2hK0hlKGSPeC6');

      final work = body['work']! as Map<String, dynamic>;
      expect(work['sessionId'], isA<String>().having((id) => id.length, 'length', isPositive));
      expect(work['threads'], 8);
      expect(work['hash'], 2048);
      expect(work['multiPv'], 2);
      expect(work['variant'], 'chess');
      expect(work['initialFen'], Chess.initial.fen);
      expect(work['moves'], ['e2e4', 'e7e5']);
      expect(work['movetime'], 4000);
    });

    test('what the broker answers is written out as UCI info lines', () async {
      final transport = await connected(MockClient((_) async => Response(testNdjsonLine, 200)));
      final lines = collect(transport);
      await pumpEventQueue();

      setUpPosition(transport);
      transport.send('go movetime 4000');
      await pumpEventQueue();

      expect(lines.sublist(lines.indexOf('uciok') + 1), [
        'info depth 12 multipv 1 score cp 35 nodes 5000 time 100 pv g1f3 b8c6',
        'info depth 11 multipv 2 score cp 20 nodes 5000 time 100 pv f1c4',
        'bestmove g1f3',
      ]);
    });

    // The broker reports scores from White's point of view; a UCI info line is read from the side
    // to move.
    test('a score for Black is negated, whether the side to move comes from the moves '
        'or from the fen', () async {
      const mateLine =
          '{"time":50,"depth":8,"nodes":900,"pvs":[{"depth":8,"mate":3,'
          '"moves":["d1h5"]}]}\n';

      final afterMove = await connected(MockClient((_) async => Response(testNdjsonLine, 200)));
      final afterMoveLines = collect(afterMove);
      await pumpEventQueue();
      setUpPosition(afterMove, moves: ['e2e4']);
      afterMove.send('go movetime 4000');
      await pumpEventQueue();

      expect(afterMoveLines, contains(startsWith('info depth 12 multipv 1 score cp -35 ')));

      final blackFen = await connected(MockClient((_) async => Response(mateLine, 200)));
      final blackFenLines = collect(blackFen);
      await pumpEventQueue();
      blackFen.send('position fen rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1');
      blackFen.send('go movetime 4000');
      await pumpEventQueue();

      expect(blackFenLines, contains(startsWith('info depth 8 multipv 1 score mate -3 ')));
    });

    test('stop ends a search the broker is still answering, with the best move so '
        'far', () async {
      final body = StreamController<List<int>>();
      addTearDown(body.close);
      final transport = await connected(
        MockClient.streaming((_, _) async => StreamedResponse(body.stream, 200)),
      );
      final lines = collect(transport);
      await pumpEventQueue();

      setUpPosition(transport);
      transport.send('go infinite');
      await pumpEventQueue();

      body.add(utf8.encode(testNdjsonLine));
      await pumpEventQueue();

      transport.send('stop');
      await pumpEventQueue();

      expect(lines.last, 'bestmove g1f3');
      expect(body.hasListener, isFalse, reason: 'the request nobody is waiting for is cancelled');
    });

    test('stop before the broker has said anything answers that there is no best '
        'move', () async {
      final body = StreamController<List<int>>();
      addTearDown(body.close);
      final transport = await connected(
        MockClient.streaming((_, _) async => StreamedResponse(body.stream, 200)),
      );
      final lines = collect(transport);
      await pumpEventQueue();

      setUpPosition(transport);
      transport.send('go infinite');
      await pumpEventQueue();
      transport.send('stop');
      await pumpEventQueue();

      expect(lines.last, 'bestmove (none)');
    });

    test('a new game is a new session, and everything else goes on filling the same '
        'one', () async {
      final sessionIds = <String>[];
      final transport = await connected(
        MockClient((request) async {
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          sessionIds.add((body['work']! as Map<String, dynamic>)['sessionId']! as String);
          return Response('', 200);
        }),
      );
      collect(transport);
      await pumpEventQueue();
      setUpPosition(transport);

      transport.send('go movetime 1000');
      await pumpEventQueue();
      transport.send('go movetime 1000');
      await pumpEventQueue();
      transport.send('ucinewgame');
      transport.send('go movetime 1000');
      await pumpEventQueue();

      expect(sessionIds[0], sessionIds[1]);
      expect(sessionIds[2], isNot(sessionIds[0]));
    });

    test('a keepalive line is not written out', () async {
      final transport = await connected(
        MockClient((_) async => Response('{"keepalive":true}\n', 200)),
      );
      final lines = collect(transport);
      await pumpEventQueue();

      setUpPosition(transport);
      transport.send('go movetime 1000');
      await pumpEventQueue();

      expect(lines.sublist(lines.indexOf('uciok') + 1), ['bestmove (none)']);
    });

    test('a request the broker refuses kills the engine', () async {
      final transport = await connected(MockClient((_) async => Response('nope', 404)));
      var closed = false;
      transport.lines.listen(null, onDone: () => closed = true);
      await pumpEventQueue();

      setUpPosition(transport);
      transport.send('go movetime 1000');
      final failure = await transport.death;

      expect(failure, isNotNull);
      expect(failure!.kind, EngineFailureKind.runtime);
      expect(failure.message, contains('404'));
      expect(transport.isDead, isTrue);
      await pumpEventQueue();
      expect(closed, isTrue);
    });

    test('a refused response is let go of', () async {
      var cancelled = false;
      final body = StreamController<List<int>>(onCancel: () => cancelled = true);
      addTearDown(body.close);
      final transport = await connected(
        MockClient.streaming((_, _) async => StreamedResponse(body.stream, 404)),
      );
      collect(transport);
      await pumpEventQueue();

      setUpPosition(transport);
      transport.send('go movetime 1000');
      await transport.death;
      await pumpEventQueue();

      expect(cancelled, isTrue);
    });

    test('a broker with no provider says the engine is not connected', () async {
      final transport = await connected(MockClient((_) async => Response('', 503)));
      collect(transport);
      await pumpEventQueue();

      setUpPosition(transport);
      transport.send('go movetime 1000');
      final failure = await transport.death;

      expect(failure!.message, startsWith('Your external engine does not appear to be connected.'));
    });

    test('a broker that cannot be reached kills the engine', () async {
      final transport = await connected(
        MockClient((_) async => throw ClientException('no route to host')),
      );
      var closed = false;
      transport.lines.listen(null, onDone: () => closed = true);
      await pumpEventQueue();

      setUpPosition(transport);
      transport.send('go movetime 1000');
      final failure = await transport.death;

      expect(failure, isNotNull);
      expect(failure!.kind, EngineFailureKind.runtime);
      expect(failure.error, isA<ClientException>());
      expect(transport.isDead, isTrue);
      await pumpEventQueue();
      expect(closed, isTrue);
    });
  });

  group('Engine over ExternalEngineTransport', () {
    test('the variant of the search is sent to the broker', () async {
      final variants = <Object?>[];
      final transport = await connected(
        MockClient((request) async {
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          variants.add((body['work']! as Map<String, dynamic>)['variant']);
          return Response(testNdjsonLine, 200);
        }),
      );
      final engine = Engine(transport);
      addTearDown(engine.dispose);
      await pumpEventQueue();

      final search = engine.search(
        const SearchRequest(
          initialPosition: Chess.initial,
          moves: IListConst([]),
          variant: Variant.atomic,
          limit: SearchLimit.movetime(Duration(seconds: 4)),
          game: 'g',
        ),
      );
      await search.bestMove;

      expect(variants, ['atomic']);
    });
  });
}
