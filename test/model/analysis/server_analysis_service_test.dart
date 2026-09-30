import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/analysis/server_analysis_service.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../test_container.dart';

const _source = ServerAnalysisSource.game(gameId: GameId('H9fIRZUk'));

/// A [ServerAnalysisService] whose analysis request is answered with [statusCode] and [body].
///
/// [Analyse.requestAnalysis] forwards the analyser's error string verbatim, so a refusal body is
/// plain text rather than JSON.
Future<ServerAnalysisService> _makeService(int statusCode, String body) async {
  final container = await lichessClientContainer(
    MockClient((request) async {
      if (request.url.path == '/H9fIRZUk/request-analysis') {
        return http.Response(body, statusCode);
      }
      return http.Response('', 404);
    }),
  );
  final ServerAnalysisService service = container.read(serverAnalysisServiceProvider);
  return service;
}

void main() {
  group('ServerAnalysisService.requestAnalysis', () {
    test('starts listening when the server accepts the request', () async {
      final service = await _makeService(200, '');

      await service.requestAnalysis(_source);

      expect(service.currentAnalysis.value, _source);
    });

    test('keeps listening when the game is already analysed', () async {
      final service = await _makeService(400, 'This game is already analysed');

      await service.requestAnalysis(_source);

      expect(service.currentAnalysis.value, _source);
    });

    // The account daily limit message is a prefix of the IP one, so both are needed to check that
    // they are told apart.
    for (final (body, error) in const [
      (
        'You already have an ongoing requested analysis',
        ServerAnalysisRequestError.concurrentAnalysis,
      ),
      ('You have reached the weekly analysis limit', ServerAnalysisRequestError.weeklyLimitReached),
      ('You have reached the daily analysis limit', ServerAnalysisRequestError.dailyLimitReached),
      (
        'You have reached the daily analysis limit on this IP',
        ServerAnalysisRequestError.dailyIpLimitReached,
      ),
      ('This game is not analysable', ServerAnalysisRequestError.notAnalysable),
    ]) {
      test('stops and reports ${error.name} when the server answers "$body"', () async {
        final service = await _makeService(400, body);

        await expectLater(
          service.requestAnalysis(_source),
          throwsA(
            isA<ServerAnalysisRequestException>()
                .having((e) => e.error, 'error', error)
                .having((e) => e.message, 'message', endsWith(body)),
          ),
        );
        expect(service.currentAnalysis.value, isNull);
      });
    }

    for (final (description, statusCode, body) in const [
      ('an unrecognised 400', 400, 'Something new'),
      ('a 400 with an empty body', 400, ''),
      ('a non-400', 500, 'Something went wrong'),
    ]) {
      test('stops and rethrows the ServerException on $description', () async {
        final service = await _makeService(statusCode, body);

        await expectLater(
          service.requestAnalysis(_source),
          throwsA(isA<ServerException>().having((e) => e.statusCode, 'statusCode', statusCode)),
        );
        expect(service.currentAnalysis.value, isNull);
      });
    }
  });

  group('ServerAnalysisService.mergeOngoingAnalysis', () {
    test('merges analysis using UCI instead of id field', () {
      // Create a simple game tree: e2e4
      final root = Root(position: Chess.initial);
      final e4Move = Move.parse('e2e4')!;
      final e4Position = root.position.playUnchecked(e4Move);
      final e4Branch = Branch(sanMove: SanMove('e4', e4Move), position: e4Position);
      root.addChild(e4Branch);

      // Server analysis data - note: no 'id' field, only 'uci'
      final serverNode = {
        'eval': {'cp': 20},
        'children': [
          {
            'uci': 'e2e4',
            'san': 'e4',
            'eval': {'cp': 25},
            'children': [
              {
                'uci': 'e7e5',
                'san': 'e5',
                'eval': {'cp': 30},
                'children': <Map<String, dynamic>>[],
              },
            ],
          },
        ],
      };

      // This should work without the 'id' field
      ServerAnalysisService.mergeOngoingAnalysis(root, serverNode);

      // Verify the tree was merged correctly
      expect(root.children.length, 1);
      expect(root.children.first.sanMove.san, 'e4');
      expect(root.children.first.children.length, 1);
      expect(root.children.first.children.first.sanMove.san, 'e5');
    });

    test('adds new variation from server analysis using UCI', () {
      // Create a game tree with just e2e4
      final root = Root(position: Chess.initial);
      final e4Move = Move.parse('e2e4')!;
      final e4Position = root.position.playUnchecked(e4Move);
      final e4Branch = Branch(sanMove: SanMove('e4', e4Move), position: e4Position);
      root.addChild(e4Branch);

      // Server sends a new variation (d2d4) - no 'id' field
      final serverNode = {
        'children': [
          {
            'uci': 'd2d4',
            'san': 'd4',
            'eval': {'cp': 15},
            'children': <Map<String, dynamic>>[],
          },
        ],
      };

      ServerAnalysisService.mergeOngoingAnalysis(root, serverNode);

      // Should have added d4 as a new variation
      expect(root.children.length, 2);
      final variations = root.children.map((c) => c.sanMove.san).toList();
      expect(variations, containsAll(['e4', 'd4']));
    });

    test('merges evaluation into existing node', () {
      final root = Root(position: Chess.initial);
      final e4Move = Move.parse('e2e4')!;
      final e4Position = root.position.playUnchecked(e4Move);
      final e4Branch = Branch(sanMove: SanMove('e4', e4Move), position: e4Position);
      root.addChild(e4Branch);

      // Server sends eval for e4 - no 'id' field
      final serverNode = {
        'children': [
          {
            'uci': 'e2e4',
            'san': 'e4',
            'eval': {'cp': 42},
            'comments': [
              {'text': 'Best move!'},
            ],
            'children': <Map<String, dynamic>>[],
          },
        ],
      };

      ServerAnalysisService.mergeOngoingAnalysis(root, serverNode);

      // Verify eval was merged
      expect(root.children.length, 1);
      expect(root.children.first.lichessAnalysisComments?.length, 1);
      expect(root.children.first.lichessAnalysisComments?.first.text, 'Best move!');
    });
  });
}
