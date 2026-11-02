import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' show GlassButton;
import 'package:material_ui/material_ui.dart';

import '../test_provider_scope.dart';

Widget makeScreen({required VoidCallback onPrevious, required VoidCallback onNext}) =>
    PlatformScaffold(
      body: const SizedBox.expand(),
      bottomNavigationBar: BottomBar(
        cupertinoGlass: true,
        children: [
          BottomBarButton(label: 'Menu', icon: Icons.menu, onTap: () {}),
          BottomBarGroup(
            children: [
              BottomBarButton(
                key: const ValueKey('previous'),
                label: 'Previous',
                showLabel: true,
                icon: Icons.chevron_left,
                onTap: onPrevious,
              ),
              BottomBarButton(
                key: const ValueKey('next'),
                label: 'Next',
                showLabel: true,
                icon: Icons.chevron_right,
                onTap: onNext,
              ),
            ],
          ),
        ],
      ),
    );

void main() {
  testWidgets('iOS: the buttons of a group share one glass capsule, without labels', (
    tester,
  ) async {
    var previous = 0;
    var next = 0;
    await tester.pumpWidget(
      await makeTestProviderScopeApp(
        tester,
        home: makeScreen(onPrevious: () => previous++, onNext: () => next++),
      ),
    );
    await tester.pumpAndSettle();

    // One capsule for the menu button, one for the group.
    expect(find.byType(GlassButton), findsNWidgets(2));
    final groupCapsule = find.ancestor(
      of: find.byKey(const ValueKey('previous')),
      matching: find.byType(GlassButton),
    );
    expect(
      find.descendant(of: groupCapsule, matching: find.byKey(const ValueKey('next'))),
      findsOneWidget,
    );
    expect(find.text('Previous'), findsNothing);
    expect(find.bySemanticsLabel('Previous'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('previous')));
    await tester.tap(find.byKey(const ValueKey('next')));
    await tester.tap(find.byKey(const ValueKey('next')));
    expect(previous, 1);
    expect(next, 2);
  }, variant: const TargetPlatformVariant({TargetPlatform.iOS}));

  testWidgets('iOS: when the buttons do not fit, only the widest ones shrink', (tester) async {
    final longLabel = List.filled(20, 'label').join(' ');
    await tester.pumpWidget(
      await makeTestProviderScopeApp(
        tester,
        home: PlatformScaffold(
          body: const SizedBox.expand(),
          bottomNavigationBar: BottomBar(
            cupertinoGlass: true,
            children: [
              BottomBarButton(
                key: const ValueKey('icon'),
                label: 'Menu',
                icon: Icons.menu,
                onTap: () {},
              ),
              for (final i in [1, 2])
                BottomBarButton(
                  key: ValueKey('long$i'),
                  label: longLabel,
                  showLabel: true,
                  icon: Icons.menu,
                  onTap: () {},
                ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    // The icon button keeps its width, the long labels share the rest.
    expect(tester.getSize(find.byKey(const ValueKey('icon'))).width, 48.0);
    final long1 = tester.getRect(find.byKey(const ValueKey('long1')));
    final long2 = tester.getRect(find.byKey(const ValueKey('long2')));
    expect(long1.width, long2.width);
    expect(long2.right, lessThanOrEqualTo(tester.getSize(find.byType(BottomBar)).width));
  }, variant: const TargetPlatformVariant({TargetPlatform.iOS}));

  testWidgets('Android: the buttons of a group are laid out like the other buttons', (
    tester,
  ) async {
    await tester.pumpWidget(
      await makeTestProviderScopeApp(
        tester,
        home: makeScreen(onPrevious: () {}, onNext: () {}),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GlassButton), findsNothing);
    expect(find.text('Previous'), findsOneWidget);
    final menuWidth = tester.getSize(find.widgetWithIcon(InkWell, Icons.menu)).width;
    expect(tester.getSize(find.byKey(const ValueKey('previous'))).width, menuWidth);
    expect(tester.getSize(find.byKey(const ValueKey('next'))).width, menuWidth);
  }, variant: const TargetPlatformVariant({TargetPlatform.android}));
}
