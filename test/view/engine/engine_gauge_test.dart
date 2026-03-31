import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';

import '../../test_provider_scope.dart';

void main() {
  testWidgets('EngineGauge shows 0.0 when eval is 0', (WidgetTester tester) async {
    final params = (
      isLocalEngineAvailable: true,
      orientation: Side.white,
      position: Chess.initial.makeSanUnchecked(Move.parse('e2e4')!).$1,
      savedEval: null,
      serverEval: const ExternalEval(cp: 0, mate: null),
      filters: (id: const StringId('test'), path: null),
    );

    final widget = await makeTestProviderScopeApp(
      tester,
      home: Scaffold(
        body: SizedBox(height: 400, child: EngineGauge(params: params)),
      ),
    );

    await tester.pumpWidget(widget);
    // The gauge has an animation, we need to wait for it.
    await tester.pumpAndSettle();

    expect(find.text('0.0'), findsOneWidget);
  });

  testWidgets('EngineGauge shows 0.0 when game is a draw', (WidgetTester tester) async {
    final drawPosition = Chess.fromSetup(Setup.parseFen('k7/8/K7/8/8/8/8/8 w - - 0 1'));
    final params = (
      isLocalEngineAvailable: true,
      orientation: Side.white,
      position: drawPosition,
      savedEval: null,
      serverEval: null,
      filters: (id: const StringId('test'), path: null),
    );

    final widget = await makeTestProviderScopeApp(
      tester,
      home: Scaffold(
        body: SizedBox(height: 400, child: EngineGauge(params: params)),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    expect(find.text('0.0'), findsOneWidget);
  });
}
