import 'dart:convert';
import 'dart:math' show max;

import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_preferences.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_screen.dart';
import 'package:multistockfish/multistockfish.dart';

import '../../binding.dart';
import '../../model/broadcast/example_data.dart';
import '../../model/engine/fake_stockfish.dart';
import '../../network/fake_websocket_channel.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

/// Creates a test app to test engine evaluation.
Future<void> makeEngineTestApp(
  WidgetTester tester, {
  GameId? gameId,
  (BroadcastTournamentId, BroadcastRoundId, BroadcastGameId)? broadcastGame,
  int numEvalLines = 1,

  /// Whether the computer analysis is allowed (only for analysis screen)
  bool isComputerAnalysisAllowed = true,
  bool isServerAnalysisEnabled = true,
  bool isEngineEnabled = true,
  bool isCloudEvalEnabled = true,
  bool showBestMoveArrow = true,
  Duration connectionLag = kFakeWebSocketConnectionLag,

  /// Custom Stockfish instance for tests requiring controllable eval emission.
  /// Note: If provided, it will be reset to a default FakeStockfish after the test.
  Stockfish? stockfish,
}) async {
  // Ensure the binding is initialized before accessing it
  final binding = TestLichessBinding.ensureInitialized();

  // Set custom stockfish if provided
  if (stockfish != null) {
    binding.stockfish = stockfish;
    // Reset to default after test to not affect other tests
    addTearDown(() {
      binding.stockfish = FakeStockfish();
    });
  }

  final app = await makeTestProviderScopeApp(
    tester,
    defaultPreferences: {
      PrefCategory.engineEvaluation.storageKey: jsonEncode(
        EngineEvaluationPrefState.defaults
            .copyWith(numEvalLines: numEvalLines, isEnabled: isEngineEnabled)
            .toJson(),
      ),
      PrefCategory.analysis.storageKey: jsonEncode(
        AnalysisPrefs.defaults
            .copyWith(
              enableServerAnalysis: isServerAnalysisEnabled,
              showBestMoveArrow: showBestMoveArrow,
            )
            .toJson(),
      ),
      PrefCategory.broadcast.storageKey: jsonEncode(
        BroadcastPrefs.defaults
            .copyWith(
              enableServerAnalysis: isServerAnalysisEnabled,
              showBestMoveArrow: showBestMoveArrow,
            )
            .toJson(),
      ),
    },
    overrides: {
      if (gameId != null)
        lichessClientProvider: lichessClientProvider.overrideWith((ref) {
          final client = MockClient((request) {
            if (request.url.path == '/game/export/$gameId' && gameResponses.containsKey(gameId)) {
              return mockResponse(gameResponses[gameId]!, 200);
            }
            return mockResponse('', 404);
          });

          return LichessClient(client, ref);
        })
      else if (broadcastGame != null)
        lichessClientProvider: lichessClientProvider.overrideWith((ref) {
          final client = MockClient((request) {
            if (request.url.path == '/api/broadcast/-/-/${broadcastGame.$2}') {
              return mockResponse(
                broadcastRoundMockResponses[(broadcastGame.$1, broadcastGame.$2)]!,
                200,
                headers: {'content-type': 'application/json; charset=utf-8'},
              );
            }
            if (request.url.path == '/api/study/${broadcastGame.$2}/${broadcastGame.$3}.pgn') {
              return mockResponse(
                broadcastGamePgnResponses[broadcastGame.$3]!,
                200,
                headers: {'content-type': 'application/x-chess-pgn'},
              );
            }
            return mockResponse('', 404);
          });

          return LichessClient(client, ref);
        }),
      webSocketChannelFactoryProvider: webSocketChannelFactoryProvider.overrideWith(
        (_) => FakeWebSocketChannelFactory(
          (uri) => FakeWebSocketChannel(
            uri,
            connectionLag: connectionLag,
            serverHandlers: {
              if (isCloudEvalEnabled)
                'evalGet': (json) {
                  final data = json['d'] as Map<String, dynamic>;
                  // final fen = data['fen'] as String;
                  return {
                    't': 'evalHit',
                    'd': {
                      'path': data['path'],
                      'knodes': '119234',
                      'depth': '36',
                      'pvs': [
                        for (var i = 0; i < max(1, numEvalLines); i++)
                          {'moves': 'e2e4 e7e5 g1f3 b8c6 f1b5 g8f6', 'cp': '23'},
                      ],
                    },
                  };
                },
            },
          ),
        ),
      ),
    },
    home: broadcastGame != null
        ? BroadcastGameScreen(
            tournamentId: broadcastGame.$1,
            roundId: broadcastGame.$2,
            gameId: broadcastGame.$3,
          )
        : AnalysisScreen(
            options: gameId != null
                ? AnalysisOptions.archivedGame(orientation: Side.white, gameId: gameId)
                : AnalysisOptions.standalone(
                    orientation: Side.white,
                    pgn: '',
                    isComputerAnalysisAllowed: isComputerAnalysisAllowed,
                    variant: Variant.standard,
                  ),
          ),
  );

  await tester.pumpWidget(app);

  if (broadcastGame != null) {
    // Load the broadcast analysis controller
    await tester.pump();
    // Load the broadcast round game provider
    await tester.pump();
  }
}

const Map<GameId, String> gameResponses = {
  GameId('qVChCOTc'): '''
{"id":"qVChCOTc","rated":false,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1673443822389,"lastMoveAt":1673444036416,"status":"mate","players":{"white":{"aiLevel":1},"black":{"user":{"name":"veloce","patron":true,"id":"veloce"},"rating":1435,"provisional":true}},"winner":"black","opening":{"eco":"C20","name":"King's Pawn Game: Wayward Queen Attack, Kiddie Countergambit","ply":4},"moves":"e4 e5 Qh5 Nf6 Qxe5+ Be7 b3 d6 Qb5+ Bd7 Qxb7 Nc6 Ba3 Rb8 Qa6 Nxe4 Bb2 O-O Nc3 Nb4 Nf3 Nxa6 Nd5 Nb4 Nxe7+ Qxe7 Nd4 Qf6 f4 Qe7 Ke2 Ng3+ Kd1 Nxh1 Bc4 Nf2+ Kc1 Qe1#","clocks":[18003,18003,17915,17627,17771,16691,17667,16243,17475,15459,17355,14779,17155,13795,16915,13267,14771,11955,14451,10995,14339,10203,13899,9099,12427,8379,12003,7547,11787,6691,11355,6091,11147,5763,10851,5099,10635,4657],"clock":{"initial":180,"increment":0,"totalTime":180}}
''',
  GameId('xze7RH66'): analysedGameResponse,
};

const analysedGameResponse = '''
{"id":"xze7RH66","rated":true,"variant":"standard","speed":"bullet","perf":"bullet","createdAt":1740763258922,"lastMoveAt":1740763308900,"status":"mate","source":"lobby","players":{"white":{"user":{"name":"alireza2003","title":"GM","id":"alireza2003"},"rating":3321,"ratingDiff":6,"analysis":{"inaccuracy":2,"mistake":2,"blunder":3,"acpl":46,"accuracy":82}},"black":{"user":{"name":"Mishka_The_Great","title":"IM","flair":"nature.bear","id":"mishka_the_great"},"rating":3250,"ratingDiff":-5,"analysis":{"inaccuracy":2,"mistake":2,"blunder":4,"acpl":75,"accuracy":74}}},"winner":"white","opening":{"eco":"B06","name":"Modern Defense","ply":2},"moves":"e4 g6 d4 c5 c3 cxd4 cxd4 Bg7 Nc3 Nc6 Be3 d6 Nf3 Nf6 h3 O-O d5 Nb8 Nd4 Nbd7 Be2 Nc5 Qc2 e6 b4 Na6 Bxa6 bxa6 Nc6 Qd7 O-O Bb7 Qa4 Bxc6 dxc6 Qc7 Rac1 Rfc8 b5 d5 Bd4 Nxe4 Bxg7 Kxg7 Nxe4 dxe4 Qd4+ e5 Qxe4 axb5 Rc5 Qd6 Rfc1 f6 c7 a5 Qb7 Qa6 Qd5 b4 Qd7+ Kh6 R5c4 Qb6 Rh4+ Kg5 Qg4#","clocks":[3003,3003,2915,2971,2859,2971,2851,2971,2803,2907,2803,2875,2779,2843,2779,2771,2747,2659,2675,2659,2603,2627,2507,2563,2403,2387,2363,2387,2323,2275,2235,2195,2155,2115,2091,2067,1947,2035,1915,1787,1803,1691,1723,1659,1683,1627,1651,1523,1571,1523,1499,1443,1435,1307,1339,1243,1259,1091,1139,943,1091,861,1051,765,985,730,935],"analysis":[{"eval":18},{"eval":48},{"eval":48},{"eval":78},{"eval":31},{"eval":51},{"eval":57},{"eval":71},{"eval":71},{"eval":124},{"eval":91},{"eval":86},{"eval":60},{"eval":94},{"eval":60},{"eval":92},{"eval":88},{"eval":105},{"eval":103},{"eval":99},{"eval":82},{"eval":80},{"eval":72},{"eval":128},{"eval":-17,"best":"d5e6","variation":"dxe6 Nxe6 Rd1 Nxd4 Rxd4 Ne8 Rd1 Qa5 O-O Be6 Bd4 Qb4","judgment":{"name":"Mistake","comment":"Mistake. dxe6 was best."}},{"eval":172,"best":"c5e4","variation":"Ncxe4 Nxe4 Nxd5 Rd1 f5 Nc3 Nxe3 fxe3 Qh4+ Kf1 d5 Bf3","judgment":{"name":"Blunder","comment":"Blunder. Ncxe4 was best."}},{"eval":71,"best":"d5e6","variation":"dxe6 Bxe6","judgment":{"name":"Inaccuracy","comment":"Inaccuracy. dxe6 was best."}},{"eval":114},{"eval":0,"best":"a1c1","variation":"Rc1 Bb7 dxe6 Qe7 O-O fxe6 f3 Rac8 Rfe1 d5 e5 Nh5","judgment":{"name":"Mistake","comment":"Mistake. Rc1 was best."}},{"eval":0},{"eval":0},{"eval":0},{"eval":-238,"best":"a1c1","variation":"Rac1 Bxc6","judgment":{"name":"Blunder","comment":"Blunder. Rac1 was best."}},{"eval":288,"best":"f6e4","variation":"Nxe4 Nxe4 exd5 Rac1 dxe4 b5 axb5 Qxb5 Bxc6 Rxc6 d5 Qc5","judgment":{"name":"Blunder","comment":"Blunder. Nxe4 was best."}},{"eval":309},{"eval":342},{"eval":267,"best":"a4a6","variation":"Qxa6 Rfc8 b5 d5 exd5 Nxd5 Nxd5 exd5 Rac1 d4 Bd2 Be5","judgment":{"name":"Inaccuracy","comment":"Inaccuracy. Qxa6 was best."}},{"eval":264},{"eval":241},{"eval":342,"best":"a6b5","variation":"axb5 Nxb5 Qe7 Qa6 Nxe4 Qb7 Qe8 c7 d5 Nxa7 Nc3 Nxc8","judgment":{"name":"Inaccuracy","comment":"Inaccuracy. axb5 was best."}},{"eval":34,"best":"a4a6","variation":"Qxa6 Rd8 exd5 exd5 Ne2 Ne4 Rfd1 Be5 Qa3 Bh2+ Kh1 Bd6","judgment":{"name":"Blunder","comment":"Blunder. Qxa6 was best."}},{"eval":216,"best":"e6e5","variation":"e5 Bc5","judgment":{"name":"Blunder","comment":"Blunder. e5 was best."}},{"eval":235},{"eval":216},{"eval":228},{"eval":227},{"eval":47,"best":"a4a6","variation":"Qxa6 Qb6 Qb7 Rcb8 Qxb6 axb6 Rc2 Rc8 Rd1 Ra7 Rd4 f5","judgment":{"name":"Blunder","comment":"Blunder. Qxa6 was best."}},{"eval":43},{"eval":0},{"eval":4},{"eval":11},{"eval":12},{"eval":16},{"eval":349,"best":"c8c7","variation":"Rc7 Rd5 Qf6 Rxb5 Rac8 Rbc5 Rd8 Rxe5 Rd2 f4 Rxa2 Re8","judgment":{"name":"Blunder","comment":"Blunder. Rc7 was best."}},{"eval":322},{"eval":374},{"eval":327},{"eval":540,"best":"d6e6","variation":"Qe6 Qxb5 e4 Rd1 a4 Qd7+ Qxd7 Rxd7+ Kh6 g4 Ra6 Kf1","judgment":{"name":"Mistake","comment":"Mistake. Qe6 was best."}},{"eval":539},{"eval":605},{"eval":545},{"eval":764,"best":"g7h8","variation":"Kh8 Rc6 Qe2 Rxf6 Qh5 Rf7 Qh6 Rc4 a4 Rxb4 Rf8 Rb1","judgment":{"name":"Inaccuracy","comment":"Inaccuracy. Kh8 was best."}},{"eval":764},{"mate":2,"best":"e5e4","variation":"e4 Rxe4 g5 Re6 Qxe6 Qxe6 Kg7 Kh2 b3 axb3 a4 Qd7+","judgment":{"name":"Mistake","comment":"Checkmate is now unavoidable. e4 was best."}},{"mate":1},{"mate":1}],"clock":{"initial":30,"increment":0,"totalTime":30},"division":{"middle":23,"end":46}}
''';
