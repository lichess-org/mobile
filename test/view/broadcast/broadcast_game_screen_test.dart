import 'package:chessground/chessground.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_mixin.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_screen.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/view/engine/engine_lines.dart';

import '../../model/broadcast/example_data.dart';
import '../../network/fake_websocket_channel.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';
import '../engine/test_engine_app.dart';

const _tournamentId = BroadcastTournamentId('RAIoMC7L');
const _roundId = BroadcastRoundId('6VuqTjes');
const _gameId = BroadcastGameId('G2LUflKg');
const _gameIdWithServerAnalysis = BroadcastGameId('Wf2MqRBR');

final client = MockClient((request) {
  if (request.url.path == '/api/broadcast/-/-/$_roundId') {
    return mockResponse(
      broadcastRoundMockResponses[(_tournamentId, _roundId)]!,
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }
  if (request.url.path == '/api/study/$_roundId/$_gameId.pgn') {
    return mockResponse(
      broadcastGamePgnResponses[_gameId]!,
      200,
      headers: {'content-type': 'application/x-chess-pgn'},
    );
  }
  return mockResponse('', 404);
});

void main() {
  group('Broadcast game screen', () {
    testWidgets('displays screen', variant: kPlatformVariant, (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const BroadcastGameScreen(
          tournamentId: _tournamentId,
          roundId: _roundId,
          gameId: _gameId,
        ),
        overrides: [lichessClientProvider.overrideWith((ref) => LichessClient(client, ref))],
      );

      await tester.pumpWidget(app);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the broadcast analysis controller
      await tester.pump();

      expect(find.byType(Chessboard), findsOneWidget);

      // Load the broadcast round game provider
      await tester.pump();

      expect(find.text('Dastan, Muhammed Batuhan'), findsOne);
      expect(find.text('Gokerkan, Cem Kaan'), findsOne);
    });

    testWidgets('Receives a new move of the game', variant: kPlatformVariant, (tester) async {
      final fakeSocket = FakeWebSocketChannel();
      final app = await makeTestProviderScopeApp(
        tester,
        home: const BroadcastGameScreen(
          tournamentId: _tournamentId,
          roundId: _roundId,
          gameId: _gameId,
        ),
        overrides: [
          lichessClientProvider.overrideWith((ref) => LichessClient(client, ref)),
          webSocketChannelFactoryProvider.overrideWith((ref) {
            return FakeWebSocketChannelFactory((_) => fakeSocket);
          }),
        ],
      );

      await tester.pumpWidget(app);

      // Load the game analysis controller
      await tester.pump();

      expect(find.byKey(const Key('c1-whitebishop')), findsOneWidget);

      fakeSocket.addIncomingMessages([
        r'''{"v":151,"t":"addNode","d":{"n":{"ply":23,"fen":"rnq2rk1/pp2ppbp/5np1/2P1N3/2N5/4B1P1/PP2PPKP/R2Q1R2 b - - 2 12","id":"%7","uci":"c1e3","san":"Be3","clock":359500},"p":{"chapterId":"G2LUflKg","path":")8aP19YQ(1`Y'*_b.>VF-=F=$3UE3=]O8GOF>EF1)1^]"},"d":"0S 978 TCEJNZ8 WGO 3NV 6xEILQSYZ78 !? UM 5OQZ 2V? XHP","s":false,"relayPath":"!"}}''',
      ]);

      await tester.pump();

      expect(find.byKey(const Key('e3-whitebishop')), findsOneWidget);
    });
  });

  group('Engine evaluation:', () {
    group('Engine lines', () {
      testWidgets('are displayed', (tester) async {
        await makeEngineTestApp(tester, broadcastGame: (_tournamentId, _roundId, _gameId));
        await tester.pump(kRequestEvalDebounceDelay);
        expect(find.byType(Engineline), findsOne);
      });

      testWidgets('are not displayed if computer analysis is not enabled', (tester) async {
        await makeEngineTestApp(
          tester,
          broadcastGame: (_tournamentId, _roundId, _gameId),
          isComputerAnalysisEnabled: false,
        );
        await tester.pump(kRequestEvalDebounceDelay);
        expect(find.byType(Engineline), findsNothing);
      });

      testWidgets('are not displayed if engine is disabled by user preferences', (tester) async {
        await makeEngineTestApp(
          tester,
          broadcastGame: (_tournamentId, _roundId, _gameId),
          isEngineEnabled: false,
        );
        await tester.pump(kRequestEvalDebounceDelay);
        expect(find.byType(Engineline), findsNothing);
      });

      testWidgets('are not displayed if they are disabled by user preferences', (tester) async {
        await makeEngineTestApp(
          tester,
          broadcastGame: (_tournamentId, _roundId, _gameId),
          numEvalLines: 0,
        );
        await tester.pump(kRequestEvalDebounceDelay);
        expect(find.byType(Engineline), findsNothing);
      });
    });

    group('Engine gauge', () {
      testWidgets('is not displayed if computer analysis is not enabled', (tester) async {
        await makeEngineTestApp(
          tester,
          broadcastGame: (_tournamentId, _roundId, _gameIdWithServerAnalysis),
          isComputerAnalysisEnabled: false,
        );
        await tester.pump(kRequestEvalDebounceDelay);
        expect(find.byType(EngineGauge), findsNothing);
      });

      testWidgets('is not displayed if engine is disabled and no server eval available', (
        tester,
      ) async {
        await makeEngineTestApp(
          tester,
          broadcastGame: (_tournamentId, _roundId, _gameId),
          isEngineEnabled: false,
        );
        await tester.pump(kRequestEvalDebounceDelay);
        expect(find.byType(EngineGauge), findsNothing);
      });

      testWidgets('engine gauge is displayed if engine is available', (tester) async {
        await makeEngineTestApp(tester, broadcastGame: (_tournamentId, _roundId, _gameId));
        await tester.pump(kRequestEvalDebounceDelay);
        expect(find.byType(EngineGauge), findsOne);
      });

      testWidgets('engine gauge is displayed if engine is disabled but an eval is available', (
        tester,
      ) async {
        await makeEngineTestApp(
          tester,
          broadcastGame: (_tournamentId, _roundId, _gameIdWithServerAnalysis),
          isEngineEnabled: false,
        );
        await tester.pump(kRequestEvalDebounceDelay);
        expect(find.byType(EngineGauge), findsOne);
      });
    });

    group('Engine best move arrow', () {
      testWidgets('is not displayed if best move arrow is disabled', (tester) async {
        await makeEngineTestApp(
          tester,
          broadcastGame: (_tournamentId, _roundId, _gameId),
          showBestMoveArrow: false,
        );
        await tester.pump(kRequestEvalDebounceDelay);
        expect(find.byType(BoardShapeWidget), findsNothing);
      });

      testWidgets('is not displayed if computer analysis is not enabled', (tester) async {
        await makeEngineTestApp(
          tester,
          broadcastGame: (_tournamentId, _roundId, _gameId),
          isComputerAnalysisEnabled: false,
        );
        await tester.pump(kRequestEvalDebounceDelay);
        expect(find.byType(BoardShapeWidget), findsNothing);
      });

      testWidgets('is not displayed if engine is disabled by user preferences', (tester) async {
        await makeEngineTestApp(
          tester,
          broadcastGame: (_tournamentId, _roundId, _gameId),
          isEngineEnabled: false,
        );
        await tester.pump(kRequestEvalDebounceDelay);
        expect(find.byType(BoardShapeWidget), findsNothing);
      });

      testWidgets('is displayed if engine is available', (tester) async {
        await makeEngineTestApp(tester, broadcastGame: (_tournamentId, _roundId, _gameId));
        await tester.pump(kRequestEvalDebounceDelay);
        expect(find.byType(BoardShapeWidget), findsOne);
      });
    });
  });
}
