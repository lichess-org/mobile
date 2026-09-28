import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/analysis/server_analysis_service.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/network/http.dart';

const _gameId = GameId('H9fIRZUk');

/// The URL [GameRepository.requestServerAnalysis] posts to.
final _requestUri = Uri(path: '/$_gameId/request-analysis');

/// A 400 exactly as the server sends it. [Analyse.requestAnalysis] forwards the analyser's error
/// string verbatim, so the body is plain text rather than JSON.
ServerException _badRequest(String body) => ServerException(
  400,
  'Request to $_requestUri failed with status 400: $body',
  _requestUri,
  null,
);

void main() {
  group('ServerAnalysisService.classifyRequestAnalysisError', () {
    test('an already analysed game still has evals coming', () {
      expect(
        ServerAnalysisService.classifyRequestAnalysisError(
          _badRequest('This game is already analysed'),
        ),
        ServerAnalysisRequestError.alreadyAnalysed,
      );
    });

    test('an ongoing request for another game means nothing will arrive here', () {
      // FishnetLimiter.concurrentCheck only looks at sender.ip / sender.userId, never the game id:
      //   analysisColl.exists(or(bdoc("sender.ip" -> ip), bdoc("sender.userId" -> userId))).not
      // So this refusal may be about a *different* game, or another user behind the same NAT. The
      // socket for this game would then never emit, so listening would burn a full minute and
      // report nothing. It must not be treated as benign.
      expect(
        ServerAnalysisService.classifyRequestAnalysisError(
          _badRequest('You already have an ongoing requested analysis'),
        ),
        ServerAnalysisRequestError.concurrentAnalysis,
      );
    });

    test('the weekly limit means nothing is running', () {
      // Treating this as "already requested" is the bug: the socket would be listened to for
      // a minute and then time out, with no evals ever arriving.
      expect(
        ServerAnalysisService.classifyRequestAnalysisError(
          _badRequest('You have reached the weekly analysis limit'),
        ),
        ServerAnalysisRequestError.weeklyLimitReached,
      );
    });

    test('the daily limit means nothing is running', () {
      expect(
        ServerAnalysisService.classifyRequestAnalysisError(
          _badRequest('You have reached the daily analysis limit'),
        ),
        ServerAnalysisRequestError.dailyLimitReached,
      );
    });

    test('the daily IP limit is distinct from the account daily limit', () {
      // The account message is a prefix of the IP one, so a naive `contains` scan in declaration
      // order would report every IP-limited request as a plain daily limit.
      expect(
        ServerAnalysisService.classifyRequestAnalysisError(
          _badRequest('You have reached the daily analysis limit on this IP'),
        ),
        ServerAnalysisRequestError.dailyIpLimitReached,
      );
    });

    test('a game that cannot be analysed reports why', () {
      expect(
        ServerAnalysisService.classifyRequestAnalysisError(
          _badRequest('This game is not analysable'),
        ),
        ServerAnalysisRequestError.notAnalysable,
      );
    });

    test('an unrecognised 400 is reported rather than assumed harmless', () {
      expect(
        ServerAnalysisService.classifyRequestAnalysisError(_badRequest('Something new')),
        ServerAnalysisRequestError.unknown,
      );
    });

    test('a 400 with an empty body is unknown', () {
      expect(
        ServerAnalysisService.classifyRequestAnalysisError(_badRequest('')),
        ServerAnalysisRequestError.unknown,
      );
    });

    test('a non-400 is not one of these analysis errors', () {
      final e = ServerException(
        500,
        'Request to $_requestUri failed with status 500: This game is already analysed',
        _requestUri,
        null,
      );
      expect(
        ServerAnalysisService.classifyRequestAnalysisError(e),
        ServerAnalysisRequestError.unknown,
      );
    });

    test('only alreadyAnalysed may be treated as success', () {
      // The whole point of the enum: a request that the server did not accept for *this* game
      // must stop the analysis instead of waiting for evals that will never come.
      for (final error in ServerAnalysisRequestError.values) {
        expect(
          error.isBenign,
          error == ServerAnalysisRequestError.alreadyAnalysed,
          reason: '$error',
        );
      }
    });
  });

  group('ServerAnalysisRequestException', () {
    test('carries the reason and a message to show', () {
      // A refusal is not a generic failure: the view has to tell "you are out of analyses" apart
      // from "the game failed to load", because only the latter is worth offering a retry for.
      final e = ServerAnalysisRequestException(
        ServerAnalysisRequestError.weeklyLimitReached,
        'Request to /abcdefgh/request-analysis failed with status 400: '
        'You have reached the weekly analysis limit',
      );
      expect(e.error, ServerAnalysisRequestError.weeklyLimitReached);
      expect(e.message, contains('weekly analysis limit'));
      expect(e.error.message, 'Weekly analysis limit reached');
    });
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
