import 'package:chessground/chessground.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_mixin.dart';

import 'test_engine_app.dart';

void main() {
  testWidgets('best move arrow is not displayed if best move arrow is disabled', (tester) async {
    await makeEngineTestApp(tester, showBestMoveArrow: false);
    await tester.pump(kRequestEvalDebounceDelay);
    expect(find.byType(BoardShapeWidget), findsNothing);
  });

  testWidgets('best move arrow is not displayed if computer analysis is not allowed', (
    tester,
  ) async {
    await makeEngineTestApp(tester, isComputerAnalysisAllowed: false);
    await tester.pump(kRequestEvalDebounceDelay);
    expect(find.byType(BoardShapeWidget), findsNothing);
  });

  testWidgets('engine gauge is not displayed if computer analysis is not enabled', (tester) async {
    await makeEngineTestApp(tester, isComputerAnalysisEnabled: false);
    await tester.pump(kRequestEvalDebounceDelay);
    expect(find.byType(BoardShapeWidget), findsNothing);
  });

  testWidgets('engine gauge is not displayed if engine is disabled by user preferences', (
    tester,
  ) async {
    await makeEngineTestApp(tester, isEngineEnabled: false);
    await tester.pump(kRequestEvalDebounceDelay);
    expect(find.byType(BoardShapeWidget), findsNothing);
  });

  testWidgets('engine gauge is displayed if engine is available', (tester) async {
    await makeEngineTestApp(tester);
    await tester.pump(kRequestEvalDebounceDelay);
    expect(find.byType(BoardShapeWidget), findsOne);
  });
}
