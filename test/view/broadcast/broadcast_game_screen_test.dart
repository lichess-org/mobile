import 'dart:convert';

import 'package:chessground/chessground.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_mixin.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_screen.dart';
import 'package:lichess_mobile/src/view/engine/engine_button.dart';
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
    if (request.url.queryParameters['analysisHeader'] == '1') {
      return mockResponse(
        broadcastGamePgnResponses[_gameId]!,
        200,
        headers: {
          'content-type': 'application/x-chess-pgn',
          'x-lichess-analysis': jsonEncode(analysisSummaryJson),
        },
      );
    }
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
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(client, ref),
          ),
        },
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

    // TODO investigate this failing test

    // testWidgets('Receives a new move of the game', variant: kPlatformVariant, (tester) async {
    //   final app = await makeTestProviderScopeApp(
    //     tester,
    //     home: const BroadcastGameScreen(
    //       tournamentId: _tournamentId,
    //       roundId: _roundId,
    //       gameId: _gameId,
    //     ),
    //     overrides: [lichessClientProvider.overrideWith((ref) => LichessClient(client, ref))],
    //   );

    //   await tester.pumpWidget(app);

    //   // Load the game analysis controller
    //   await tester.pump();

    //   expect(find.byKey(const Key('c1-whitebishop')), findsOneWidget);

    //   sendServerSocketMessages(BroadcastAnalysisController.broadcastSocketUri(_roundId), [
    //     r'''{"v":151,"t":"addNode","d":{"n":{"ply":23,"fen":"rnq2rk1/pp2ppbp/5np1/2P1N3/2N5/4B1P1/PP2PPKP/R2Q1R2 b - - 2 12","id":"%7","uci":"c1e3","san":"Be3","clock":359500},"p":{"chapterId":"G2LUflKg","path":")8aP19YQ(1`Y'*_b.>VF-=F=$3UE3=]O8GOF>EF1)1^]"},"d":"0S 978 TCEJNZ8 WGO 3NV 6xEILQSYZ78 !? UM 5OQZ 2V? XHP","s":false,"relayPath":"!"}}''',
    //   ]);
    //   await tester.pump();

    //   expect(find.byKey(const Key('e3-whitebishop')), findsOneWidget);
    // });
    testWidgets('Broadcast Game Summary available', variant: kPlatformVariant, (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const BroadcastGameScreen(
          tournamentId: _tournamentId,
          roundId: _roundId,
          gameId: _gameId,
        ),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(client, ref),
          ),
        },
      );
      await tester.pumpWidget(app);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the broadcast analysis controller
      await tester.pump();

      expect(find.byType(Chessboard), findsOneWidget);

      // Load the broadcast round game provider
      await tester.pump();

      expect(find.byIcon(LichessIcons.flow_cascade), findsOne);
      await tester.tap(find.byIcon(LichessIcons.flow_cascade));
      //allow animation on iOS to complete
      await tester.pumpAndSettle();
      expect(find.text('Computer analysis'), findsOne);
      await tester.tap(find.text('Computer analysis'));
      //allow switching tabs animation to complete
      await tester.pumpAndSettle();
      expect(find.text('61%'), findsOne);
      expect(find.text('Blunders'), findsOne);
      // Check that the evaluation chart is displayed
      expect(find.byType(LineChart), findsOne);
    });
  });

  group('Engine evaluation:', () {
    group('Engine lines', () {
      testWidgets('are displayed', (tester) async {
        await makeEngineTestApp(tester, broadcastGame: (_tournamentId, _roundId, _gameId));
        await tester.pump(kRequestEvalDebounceDelay + kFakeWebSocketConnectionLag);
        expect(find.byType(Engineline), findsOne);
      });

      testWidgets('are not displayed if computer analysis is not enabled', (tester) async {
        await makeEngineTestApp(
          tester,
          broadcastGame: (_tournamentId, _roundId, _gameId),
          isServerAnalysisEnabled: false,
          isEngineEnabled: false,
        );
        await tester.pump(kRequestEvalDebounceDelay + kFakeWebSocketConnectionLag);
        expect(find.byType(Engineline), findsNothing);
      });

      testWidgets('are not displayed if engine is disabled by user preferences', (tester) async {
        await makeEngineTestApp(
          tester,
          broadcastGame: (_tournamentId, _roundId, _gameId),
          isEngineEnabled: false,
        );
        await tester.pump(kRequestEvalDebounceDelay + kFakeWebSocketConnectionLag);
        expect(find.byType(Engineline), findsNothing);
      });

      testWidgets('are not displayed if they are disabled by user preferences', (tester) async {
        await makeEngineTestApp(
          tester,
          broadcastGame: (_tournamentId, _roundId, _gameId),
          numEvalLines: 0,
        );
        await tester.pump(kRequestEvalDebounceDelay + kFakeWebSocketConnectionLag);
        expect(find.byType(Engineline), findsNothing);
      });
    });

    group('Engine gauge', () {
      testWidgets('is not displayed if computer analysis is not enabled', (tester) async {
        await makeEngineTestApp(
          tester,
          broadcastGame: (_tournamentId, _roundId, _gameIdWithServerAnalysis),
          isServerAnalysisEnabled: false,
          isEngineEnabled: false,
        );
        await tester.pump(kRequestEvalDebounceDelay + kFakeWebSocketConnectionLag);
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
        await tester.pump(kRequestEvalDebounceDelay + kFakeWebSocketConnectionLag);
        expect(find.byType(EngineGauge), findsNothing);
      });

      testWidgets('engine gauge is displayed if engine is available', (tester) async {
        await makeEngineTestApp(tester, broadcastGame: (_tournamentId, _roundId, _gameId));
        await tester.pump(kRequestEvalDebounceDelay + kFakeWebSocketConnectionLag);
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
        await tester.pump(kRequestEvalDebounceDelay + kFakeWebSocketConnectionLag);
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
        await tester.pump(kRequestEvalDebounceDelay + kFakeWebSocketConnectionLag);
        expect(find.byType(BoardShapeWidget), findsNothing);
      });

      testWidgets('is not displayed if engine is disabled by user preferences', (tester) async {
        await makeEngineTestApp(
          tester,
          broadcastGame: (_tournamentId, _roundId, _gameId),
          isEngineEnabled: false,
        );
        await tester.pump(kRequestEvalDebounceDelay + kFakeWebSocketConnectionLag);
        expect(find.byType(BoardShapeWidget), findsNothing);
      });

      testWidgets('is displayed if engine is available', (tester) async {
        await makeEngineTestApp(tester, broadcastGame: (_tournamentId, _roundId, _gameId));
        await tester.pump(kRequestEvalDebounceDelay + kFakeWebSocketConnectionLag);
        expect(find.byType(BoardShapeWidget), findsOne);
      });
    });

    group('Local engine is delayed:', () {
      testWidgets('starts local engine if cloud eval is not available', (tester) async {
        await makeEngineTestApp(
          tester,
          broadcastGame: (_tournamentId, _roundId, _gameId),
          isCloudEvalEnabled: false,
        );
        expect(find.byType(EngineButton), findsOne);
        // displays initial state
        expect(find.widgetWithText(EngineButton, '-'), findsOne);

        await tester.pump(kRequestEvalDebounceDelay + kFakeWebSocketConnectionLag);
        // cloud eval is not available, so it still display initial state
        expect(find.widgetWithText(EngineButton, '-'), findsOne);
        expect(isCloudEvalDisplayed(), isFalse);

        // Now wait for local engine
        await tester.pump(kLocalEngineAfterCloudEvalDelay + kEngineEvalEmissionThrottleDelay);
        expect(find.widgetWithText(EngineButton, '16'), findsOne);
      });

      testWidgets('Cloud eval will override local engine eval', (tester) async {
        // Simulates a connection lag that will make the cloud eval come 300ms after the local engine
        final connectionLag =
            kLocalEngineAfterCloudEvalDelay -
            kRequestEvalDebounceDelay +
            const Duration(milliseconds: 300);
        await makeEngineTestApp(
          tester,
          broadcastGame: (_tournamentId, _roundId, _gameId),
          connectionLag: connectionLag,
        );

        // Wait for local engine eval
        await tester.pump(kLocalEngineAfterCloudEvalDelay);
        expect(find.widgetWithText(EngineButton, '15'), findsOne);

        // cloud eval will be available 300ms after the local engine eval
        await tester.pump(const Duration(milliseconds: 300));
        expect(isCloudEvalDisplayed(), isTrue);
        expect(find.widgetWithText(EngineButton, '36'), findsOne);
      });

      testWidgets('Local engine will not override cloud eval with greater depth', (tester) async {
        // Simulates a connection lag that will make the local engine come 100ms after the cloud eval
        final connectionLag =
            kLocalEngineAfterCloudEvalDelay -
            kRequestEvalDebounceDelay +
            const Duration(milliseconds: 100);
        await makeEngineTestApp(
          tester,
          broadcastGame: (_tournamentId, _roundId, _gameId),
          connectionLag: connectionLag,
        );

        // Wait for local engine eval
        await tester.pump(kLocalEngineAfterCloudEvalDelay);
        expect(find.widgetWithText(EngineButton, '15'), findsOne);

        // Cloud eval will be available 100ms after the first local engine eval emission
        await tester.pump(const Duration(milliseconds: 100));
        expect(isCloudEvalDisplayed(), isTrue);
        expect(find.widgetWithText(EngineButton, '36'), findsOne);

        // local engine is still running, but it will not override the cloud eval
        // wait for the next local engine eval emission (after throttle delay minus the 100ms already waited)
        await tester.pump(kEngineEvalEmissionThrottleDelay - const Duration(milliseconds: 100));
        expect(isCloudEvalDisplayed(), isTrue);
        expect(find.widgetWithText(EngineButton, '36'), findsOne);
      });
    });
  });
}

/// Checks if the cloud eval label is displayed in the EngineButton widget
bool isCloudEvalDisplayed() {
  return find.widgetWithText(EngineButton, 'CLOUD').evaluate().isNotEmpty;
}
