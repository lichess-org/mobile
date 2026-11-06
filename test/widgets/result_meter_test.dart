import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/widgets/result_meter.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('renders one segment per non zero result', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ResultMeter(wins: 2, draws: 1, losses: 2))),
    );

    final segments = tester
        .widgetList<Expanded>(
          find.descendant(of: find.byType(ResultMeter), matching: find.byType(Expanded)),
        )
        .toList(growable: false);

    expect(segments.map((segment) => segment.flex), [2, 1, 2]);
  });

  testWidgets('renders an empty track when there are no games', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ResultMeter(wins: 0, draws: 0, losses: 0))),
    );

    expect(
      find.descendant(of: find.byType(ResultMeter), matching: find.byType(Expanded)),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('is excluded from semantics', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ResultMeter(wins: 1, draws: 0, losses: 0))),
    );

    expect(
      find.descendant(of: find.byType(ResultMeter), matching: find.byType(ExcludeSemantics)),
      findsOneWidget,
    );
  });
}
