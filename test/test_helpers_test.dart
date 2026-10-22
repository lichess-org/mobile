import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/utils/gestures_exclusion.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('board platform mocks handle focus loss', (tester) async {
    mockBoardPlatformChannels();
    await tester.runAsync(() async {
      await WakelockPlus.enable();
      await WakelockPlus.disable();
      await clearAndroidBoardGesturesExclusion();
    });
    expect(tester.takeException(), isNull);
  }, variant: kPlatformVariant);

  testWidgets('TestSurface preserves the simulated view metrics', (tester) async {
    tester.view.devicePixelRatio = 3.0;
    tester.view.physicalSize = const Size(960.0, 2079.0);
    tester.view.padding = const FakeViewPadding(top: 141.0, bottom: 102.0);
    tester.view.viewPadding = const FakeViewPadding(top: 141.0, bottom: 102.0);
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    late MediaQueryData metrics;
    const childKey = ValueKey('surface-child');
    await tester.pumpWidget(
      TestSurface(
        child: Builder(
          key: childKey,
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
    expect(metrics.textScaler.scale(16.0), 16.0);

    final childElement = tester.element(find.byKey(childKey));
    tester.platformDispatcher.textScaleFactorTestValue = 2.0;
    await resizeTestSurface(
      tester,
      const Size(693.0, 320.0),
      physicalViewPadding: const EdgeInsets.only(left: 141.0, right: 141.0, bottom: 63.0),
    );
    expect(metrics.size, const Size(693.0, 320.0));
    expect(metrics.orientation, Orientation.landscape);
    expect(metrics.padding, const EdgeInsets.only(left: 47.0, right: 47.0, bottom: 21.0));
    expect(metrics.viewPadding, metrics.padding);
    expect(metrics.textScaler.scale(16.0), 32.0);
    expect(tester.element(find.byKey(childKey)), same(childElement));
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

class const _ControlsFixture({
  required final double top,
  required final bool covered,
  required final bool enabled,
}) extends StatelessWidget {
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
