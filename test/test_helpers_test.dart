import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:material_ui/material_ui.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('TestSurface preserves the simulated view metrics', (tester) async {
    tester.view.devicePixelRatio = 3.0;
    tester.view.physicalSize = const Size(960.0, 2079.0);
    tester.view.padding = const FakeViewPadding(top: 141.0, bottom: 102.0);
    tester.view.viewPadding = const FakeViewPadding(top: 141.0, bottom: 102.0);
    addTearDown(tester.view.reset);

    late MediaQueryData metrics;
    await tester.pumpWidget(
      TestSurface(
        size: const Size(320.0, 693.0),
        child: Builder(
          builder: (context) {
            metrics = MediaQuery.of(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(metrics.size, const Size(320.0, 693.0));
    expect(metrics.devicePixelRatio, 3.0);
    expect(metrics.padding, const EdgeInsets.only(top: 47.0, bottom: 34.0));
    expect(metrics.viewPadding, metrics.padding);
  });

  group('expectGameControlsVisible', () {
    for (final scenario in [
      (name: 'visible enabled button', top: 400.0, covered: false, enabled: true, passes: true),
      (name: 'visible disabled button', top: 400.0, covered: false, enabled: false, passes: true),
      (name: 'top safe area intrusion', top: 20.0, covered: false, enabled: true, passes: false),
      (
        name: 'bottom safe area intrusion',
        top: 630.0,
        covered: false,
        enabled: true,
        passes: false,
      ),
      (name: 'board overlap', top: 150.0, covered: false, enabled: true, passes: false),
      (name: 'covered enabled button', top: 400.0, covered: true, enabled: true, passes: false),
    ]) {
      testWidgets(scenario.name, (tester) async {
        tester.view.devicePixelRatio = 3.0;
        tester.view.physicalSize = const Size(960.0, 2079.0);
        tester.view.viewPadding = const FakeViewPadding(top: 141.0, bottom: 102.0);
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _ControlsFixture(top: scenario.top, covered: scenario.covered, enabled: scenario.enabled),
        );
        if (scenario.passes) {
          expectGameControlsVisible(tester, find.byType(BottomBarButton));
        } else {
          expect(
            () => expectGameControlsVisible(tester, find.byType(BottomBarButton)),
            throwsA(isA<TestFailure>()),
          );
        }
      }, variant: kPlatformVariant);
    }
  });
}

class _ControlsFixture extends StatelessWidget {
  const _ControlsFixture({required this.top, required this.covered, required this.enabled});

  final double top;
  final bool covered;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final buttonRect = Rect.fromLTWH(20.0, top, 80.0, 48.0);
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            const Positioned(
              left: 0,
              top: 100,
              child: StaticChessboard(size: 200, orientation: Side.white, fen: kInitialFEN),
            ),
            Positioned.fromRect(
              rect: buttonRect,
              child: BottomBarButton(
                icon: Icons.menu,
                label: 'Menu',
                onTap: enabled ? () {} : null,
              ),
            ),
            if (covered)
              Positioned.fromRect(
                rect: buttonRect,
                child: const AbsorbPointer(child: ColoredBox(color: Colors.black)),
              ),
          ],
        ),
      ),
    );
  }
}
