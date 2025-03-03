import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_mixin.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/view/engine/engine_depth.dart';

import 'test_engine_app.dart';

void main() {
  bool isCloudEvalDisplayed() {
    return find
        .descendant(of: find.byType(EngineDepth), matching: find.byIcon(Icons.cloud))
        .evaluate()
        .isNotEmpty;
  }

  bool isLocalEngineEvalDisplayed() {
    TestAsyncUtils.guardSync();
    return find
        .descendant(of: find.byType(EngineDepth), matching: find.byType(CustomPaint))
        .evaluate()
        .map((w) => w.widget as CustomPaint)
        .where((w) => w.painter is MicroChipPainter)
        .isNotEmpty;
  }

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

  testWidgets('displays a cloud icon if cloud eval is available', (tester) async {
    await makeEngineTestApp(tester);

    // it always tries to fetch the cloud eval
    expect(isCloudEvalDisplayed(), isTrue);
    // displays loading indicator
    expect(find.widgetWithText(EngineDepth, '\u{2026}'), findsOne);
    await tester.pump(kRequestCloudEvalDebounceDelay);
    expect(find.widgetWithText(EngineDepth, '36'), findsOne);
  });

  testWidgets('Displays a microchip for local engine if cloud eval is not available', (
    tester,
  ) async {
    await makeEngineTestApp(tester, isCloudEvalEnabled: false);
    expect(find.byType(EngineDepth), findsOne);
    // it always tries to fetch the cloud eval
    expect(isCloudEvalDisplayed(), isTrue);
    // displays loading indicator
    expect(find.widgetWithText(EngineDepth, '\u{2026}'), findsOne);

    await tester.pump(kRequestCloudEvalDebounceDelay);
    // cloud eval is not available, so it still displays loading indicator
    expect(find.widgetWithText(EngineDepth, '\u{2026}'), findsOne);

    // Now wait for local engine
    await tester.pump(kRequestEngineEvalDebounceDelay);
    expect(isLocalEngineEvalDisplayed(), isTrue);
    expect(find.widgetWithText(EngineDepth, '16'), findsOne);
  });

  testWidgets('Cloud eval will override local engine eval', (tester) async {
    // Simulates a connection lag that will make the cloud eval come 300ms after the local engine
    final connectionLag =
        kRequestEngineEvalDebounceDelay -
        kRequestCloudEvalDebounceDelay +
        const Duration(milliseconds: 300);
    await makeEngineTestApp(tester, connectionLag: connectionLag);

    // Wait for local engine eval
    await tester.pump(kRequestEngineEvalDebounceDelay);
    expect(isLocalEngineEvalDisplayed(), isTrue);
    expect(find.widgetWithText(EngineDepth, '15'), findsOne);

    // cloud eval will be available 300ms after the local engine eval
    await tester.pump(const Duration(milliseconds: 300));
    expect(isCloudEvalDisplayed(), isTrue);
    expect(find.widgetWithText(EngineDepth, '36'), findsOne);
  });

  testWidgets('Local engine will not override cloud eval', (tester) async {
    // Simulates a connection lag that will make the local engine come 100ms after the cloud eval
    final connectionLag =
        kRequestEngineEvalDebounceDelay -
        kRequestCloudEvalDebounceDelay +
        const Duration(milliseconds: 100);
    await makeEngineTestApp(tester, connectionLag: connectionLag);

    // Wait for local engine eval
    await tester.pump(kRequestEngineEvalDebounceDelay);
    expect(isLocalEngineEvalDisplayed(), isTrue);
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
}
