import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoSlidingSegmentedControl;
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_tab_bar.dart';
import 'package:material_ui/material_ui.dart';

int? selectedSegment(WidgetTester tester) => tester
    .widget<CupertinoSlidingSegmentedControl<int>>(
      find.byType(CupertinoSlidingSegmentedControl<int>),
    )
    .groupValue;

final testApp = MaterialApp(
  theme: ThemeData(platform: TargetPlatform.iOS),
  home: DebugLiquidGlassOverride(
    enabled: false,
    child: DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            const PlatformTabBar(tabs: ['One', 'Two'], inAppBar: false),
            Expanded(
              child: TabBarView(
                children: [
                  Container(color: Colors.red),
                  Container(color: Colors.blue),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);

void main() {
  testWidgets('iOS segmented control follows a swipe of the tab view before it settles', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(testApp);

    expect(selectedSegment(tester), 0);

    final width = tester.getSize(find.byType(TabBarView)).width;
    final gesture = await tester.startGesture(tester.getCenter(find.byType(TabBarView)));
    await gesture.moveBy(Offset(-width * 0.3, 0));
    await tester.pump();
    expect(selectedSegment(tester), 0);

    // Past the middle of the swipe, while the finger is still down.
    await gesture.moveBy(Offset(-width * 0.3, 0));
    await tester.pump();
    expect(selectedSegment(tester), 1);

    // Back before the middle.
    await gesture.moveBy(Offset(width * 0.3, 0));
    await tester.pump();
    expect(selectedSegment(tester), 0);

    await gesture.moveBy(Offset(-width * 0.5, 0));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(selectedSegment(tester), 1);
  }, variant: TargetPlatformVariant.only(.iOS));

  testWidgets('iOS segmented control selects a tapped segment right away', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(testApp);

    await tester.tap(find.text('Two'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 16));
    expect(selectedSegment(tester), 1);

    await tester.pumpAndSettle();
    expect(selectedSegment(tester), 1);
  }, variant: TargetPlatformVariant.only(.iOS));
}
