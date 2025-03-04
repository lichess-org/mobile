import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_mixin.dart';
import 'package:lichess_mobile/src/view/engine/engine_lines.dart';

import 'test_engine_app.dart';

void main() {
  testWidgets('engine lines are displayed', (tester) async {
    await makeEngineTestApp(tester);
    await tester.pump(kRequestCloudEvalDebounceDelay);
    expect(find.byType(Engineline), findsOne);
    expect(find.widgetWithText(Engineline, '1. e4 e5 2. Nf3 Nc6 3. Bb5 Nf6 '), findsOne);
  });

  testWidgets('engine lines are not displayed if computer analysis is not allowed', (tester) async {
    await makeEngineTestApp(tester, isComputerAnalysisAllowed: false);
    await tester.pump(kRequestCloudEvalDebounceDelay);
    expect(find.byType(Engineline), findsNothing);
  });

  testWidgets('engine lines are not displayed if computer analysis is not enabled', (tester) async {
    await makeEngineTestApp(tester, isComputerAnalysisEnabled: false);
    await tester.pump(kRequestCloudEvalDebounceDelay);
    expect(find.byType(Engineline), findsNothing);
  });

  testWidgets('engine lines are not displayed if engine is disabled by user preferences', (
    tester,
  ) async {
    await makeEngineTestApp(tester, isEngineEnabled: false);
    await tester.pump(kRequestCloudEvalDebounceDelay);
    expect(find.byType(Engineline), findsNothing);
  });

  testWidgets('engine lines are not displayed if they are disabled by user preferences', (
    tester,
  ) async {
    await makeEngineTestApp(tester, numEvalLines: 0);
    await tester.pump(kRequestCloudEvalDebounceDelay);
    expect(find.byType(Engineline), findsNothing);
  });
}
