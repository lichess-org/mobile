import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_mixin.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/view/engine/engine_depth.dart';

import 'test_engine_app.dart';

/// Checks if the cloud eval label is displayed in the EngineDepth widget
bool isCloudEvalDisplayed() {
  return find.widgetWithText(EngineDepth, 'CLOUD').evaluate().isNotEmpty;
}

void main() {
  testWidgets('engine depth is not displayed if computer analysis is not allowed', (tester) async {
    await makeEngineTestApp(tester, isComputerAnalysisAllowed: false);
    expect(find.byType(EngineDepth), findsNothing);
  });

  testWidgets('engine depth is not displayed if engine is disabled by user preferences', (
    tester,
  ) async {
    await makeEngineTestApp(tester, isEngineEnabled: false);
    expect(find.byType(EngineDepth), findsNothing);
  });

  // This test group is for the case where the local engine is delayed (which is the case for the
  // first 20 plies of the game)
  group('Local engine is delayed', () {
    testWidgets('displays a CLOUD label if cloud eval is available', (tester) async {
      await makeEngineTestApp(tester);

      // displays loading indicator
      expect(
        find.descendant(of: find.byType(EngineDepth), matching: find.byType(SpinKitFadingFour)),
        findsOne,
      );
      await tester.pump(kRequestEvalDebounceDelay);
      expect(isCloudEvalDisplayed(), isTrue);
      expect(find.widgetWithText(EngineDepth, '36'), findsOne);

      // Wait for local engine delay
      await tester.pump(kStartLocalEngineDebounceDelay + kEngineEvalEmissionThrottleDelay);
      // Local engine has not even started
      expect(find.widgetWithText(EngineDepth, '36'), findsOne);
    });

    testWidgets('Starts local engine if cloud eval is not available', (tester) async {
      await makeEngineTestApp(tester, isCloudEvalEnabled: false);
      expect(find.byType(EngineDepth), findsOne);
      // displays loading indicator
      expect(
        find.descendant(of: find.byType(EngineDepth), matching: find.byType(SpinKitFadingFour)),
        findsOne,
      );

      await tester.pump(kRequestEvalDebounceDelay);
      // cloud eval is not available, so it still displays loading indicator
      expect(
        find.descendant(of: find.byType(EngineDepth), matching: find.byType(SpinKitFadingFour)),
        findsOne,
      );
      expect(isCloudEvalDisplayed(), isFalse);

      // Now wait for local engine
      await tester.pump(kStartLocalEngineDebounceDelay + kEngineEvalEmissionThrottleDelay);
      expect(find.widgetWithText(EngineDepth, '16'), findsOne);
    });

    testWidgets('Cloud eval will override local engine eval', (tester) async {
      // Simulates a connection lag that will make the cloud eval come 300ms after the local engine
      final connectionLag =
          kStartLocalEngineDebounceDelay -
          kRequestEvalDebounceDelay +
          const Duration(milliseconds: 300);
      await makeEngineTestApp(tester, connectionLag: connectionLag);

      // Wait for local engine eval
      await tester.pump(kStartLocalEngineDebounceDelay);
      expect(find.widgetWithText(EngineDepth, '15'), findsOne);

      // cloud eval will be available 300ms after the local engine eval
      await tester.pump(const Duration(milliseconds: 300));
      expect(isCloudEvalDisplayed(), isTrue);
      expect(find.widgetWithText(EngineDepth, '36'), findsOne);
    });

    testWidgets('Local engine will not override cloud eval', (tester) async {
      // Simulates a connection lag that will make the local engine come 100ms after the cloud eval
      final connectionLag =
          kStartLocalEngineDebounceDelay -
          kRequestEvalDebounceDelay +
          const Duration(milliseconds: 100);
      await makeEngineTestApp(tester, connectionLag: connectionLag);

      // Wait for local engine eval
      await tester.pump(kStartLocalEngineDebounceDelay);
      expect(find.widgetWithText(EngineDepth, '15'), findsOne);

      // Cloud eval will be available 100ms after the first local engine eval emission
      await tester.pump(const Duration(milliseconds: 100));
      expect(isCloudEvalDisplayed(), isTrue);
      expect(find.widgetWithText(EngineDepth, '36'), findsOne);

      // local engine is still running, but it will not override the cloud eval
      // wait for the next local engine eval emission (after throttle delay minus the 100ms already waited)
      await tester.pump(kEngineEvalEmissionThrottleDelay - const Duration(milliseconds: 100));
      expect(isCloudEvalDisplayed(), isTrue);
      expect(find.widgetWithText(EngineDepth, '36'), findsOne);
    });
  });

  // This test group is for the case where the local engine is not delayed (which is the common case)
  group('Local engine is not delayed', () {
    testWidgets('it starts immediately after the request eval delay', (tester) async {
      // loads a finished game, disable cloud eval because it is ususally not availabe in mid/end game
      await makeEngineTestApp(tester, isCloudEvalEnabled: false, gameId: const GameId('xze7RH66'));

      expect(find.byType(CircularProgressIndicator), findsOne);
      // wait for the game to be loaded
      await tester.pump(const Duration(milliseconds: 50));

      // engine not yet started, so it still displays loading indicator
      expect(
        find.descendant(of: find.byType(EngineDepth), matching: find.byType(SpinKitFadingFour)),
        findsOne,
      );

      // wait for engine
      await tester.pump(kRequestEvalDebounceDelay + kEngineEvalEmissionThrottleDelay);
      expect(find.widgetWithText(EngineDepth, '16'), findsOne);
    });
  });
}
