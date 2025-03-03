import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_mixin.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';

import 'test_engine_app.dart';

void main() {
  testWidgets('engine gauge is displayed', (tester) async {
    await makeEngineTestApp(tester);
    await tester.pump(kRequestCloudEvalDebounceDelay);
    expect(find.byType(EngineGauge), findsOne);
    expect(find.widgetWithText(EngineGauge, '+0.2'), findsOne);
  });

  testWidgets('engine gauge is not displayed if computer analysis is not allowed', (tester) async {
    await makeEngineTestApp(tester, isComputerAnalysisAllowed: false);
    await tester.pump(kRequestCloudEvalDebounceDelay);
    expect(find.byType(EngineGauge), findsNothing);
  });

  testWidgets('engine gauge is not displayed if computer analysis is not enabled', (tester) async {
    await makeEngineTestApp(tester, isComputerAnalysisEnabled: false);
    await tester.pump(kRequestCloudEvalDebounceDelay);
    expect(find.byType(EngineGauge), findsNothing);
  });

  testWidgets('engine gauge is not displayed if engine is disabled by user preferences', (
    tester,
  ) async {
    await makeEngineTestApp(tester, isEngineEnabled: false);
    await tester.pump(kRequestCloudEvalDebounceDelay);
    expect(find.byType(EngineGauge), findsNothing);
  });
}
