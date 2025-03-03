import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_mixin.dart';
import 'package:lichess_mobile/src/view/engine/engine_depth.dart';

import 'test_engine_app.dart';

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

  testWidgets('displays a cloud icon if cloud eval is available', (tester) async {
    await makeEngineTestApp(tester);

    // it always tries to fetch the cloud eval
    expect(find.byIcon(Icons.cloud), findsOneWidget);
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
    expect(find.byIcon(Icons.cloud), findsOneWidget);
    // displays loading indicator
    expect(find.widgetWithText(EngineDepth, '\u{2026}'), findsOne);

    await tester.pump(kRequestCloudEvalDebounceDelay);
    // cloud eval is not available, so it still displays loading indicator
    expect(find.widgetWithText(EngineDepth, '\u{2026}'), findsOne);

    // Now wait for local engine
    await tester.pump(kRequestEngineEvalDebounceDelay);
    expect(find.widgetWithText(EngineDepth, '16'), findsOne);
    expect(find.byIcon(Icons.cloud), findsNothing);
    expect(
      tester
          .widgetList(
            find.descendant(of: find.byType(EngineDepth), matching: find.byType(CustomPaint)),
          )
          .where((w) => w is CustomPaint && w.painter is MicroChipPainter)
          .first,
      isNotNull,
    );
  });
}
