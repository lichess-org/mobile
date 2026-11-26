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

  testWidgets('iOS: a group of one button is a circle of its own', (tester) async {
    await tester.pumpWidget(
      await makeTestProviderScopeApp(
        tester,
        home: PlatformScaffold(
          body: const SizedBox.expand(),
          bottomNavigationBar: BottomBar(
            cupertinoGlass: true,
            children: [
              BottomBarGroup(
                children: [
                  BottomBarButton(
                    key: const ValueKey('single'),
                    label: 'Single',
                    icon: Icons.flag_outlined,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final size = tester.getSize(find.byType(GlassButton));
    expect(size.width, size.height);
  }, variant: const TargetPlatformVariant({TargetPlatform.iOS}));

  testWidgets('iOS: a navigation group has wider buttons, with larger icons', (tester) async {
    Widget group({required bool navigation, required String prefix}) => BottomBarGroup(
      navigation: navigation,
      children: [
        for (final i in [1, 2])
          BottomBarButton(
            key: ValueKey('$prefix$i'),
            label: '$prefix$i',
            icon: Icons.menu,
            onTap: () {},
          ),
      ],
    );
    await tester.pumpWidget(
      await makeTestProviderScopeApp(
        tester,
        home: PlatformScaffold(
          body: const SizedBox.expand(),
          bottomNavigationBar: BottomBar(
            cupertinoGlass: true,
            children: [
              group(navigation: false, prefix: 'other'),
              group(navigation: true, prefix: 'nav'),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    double iconSize(String key) => tester
        .getSize(find.descendant(of: find.byKey(ValueKey(key)), matching: find.byType(Icon)))
        .width;
    expect(tester.getSize(find.byKey(const ValueKey('other1'))).width, 48.0);
    expect(iconSize('other1'), 24.0);
    expect(tester.getSize(find.byKey(const ValueKey('nav1'))).width, 60.0);
    expect(iconSize('nav1'), 28.0);
    // Both capsules keep the same height.
    expect(find.byType(GlassButton), findsNWidgets(2));
    expect(
      tester.getSize(find.byType(GlassButton).last).height,
      tester.getSize(find.byType(GlassButton).first).height,
    );
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

  testWidgets(
    'iOS: a tap in the bar that misses the buttons does nothing, and never reaches the content',
    (tester) async {
      var content = 0;
      var menu = 0;
      var previous = 0;
      var next = 0;
      await tester.pumpWidget(
        await makeTestProviderScopeApp(
          tester,
          home: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => content++,
                  child: const SizedBox.expand(),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: BottomBar(
                  cupertinoGlass: true,
                  children: [
                    BottomBarButton(
                      key: const ValueKey('menu'),
                      label: 'Menu',
                      icon: Icons.menu,
                      onTap: () => menu++,
                    ),
                    BottomBarGroup(
                      children: [
                        BottomBarButton(
                          key: const ValueKey('previous'),
                          label: 'Previous',
                          icon: Icons.chevron_left,
                          onTap: () => previous++,
                        ),
                        BottomBarButton(
                          key: const ValueKey('next'),
                          label: 'Next',
                          icon: Icons.chevron_right,
                          onTap: () => next++,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final bar = tester.getRect(find.byType(BottomBar));
      final menuRect = tester.getRect(find.byKey(const ValueKey('menu')));
      final previousRect = tester.getRect(find.byKey(const ValueKey('previous')));
      final nextRect = tester.getRect(find.byKey(const ValueKey('next')));
      final group = tester.getRect(
        find.ancestor(of: find.byKey(const ValueKey('next')), matching: find.byType(GlassButton)),
      );

      // Above the bar, the content takes the tap.
      await tester.tapAt(Offset(nextRect.center.dx, bar.top - 4.0));
      expect(content, 1);

      // On the buttons.
      await tester.tapAt(menuRect.center);
      await tester.tapAt(previousRect.center);
      await tester.tapAt(nextRect.center);
      expect((menu, previous, next), (1, 1, 1));

      // Off the buttons, in the bar: above a button, below it, between buttons, beside them.
      await tester.tapAt(Offset(nextRect.center.dx, nextRect.top - 2.0));
      await tester.tapAt(Offset(menuRect.center.dx, bar.bottom - 2.0));
      await tester.tapAt(Offset(group.left - 2.0, group.center.dy));
      await tester.tapAt(Offset(group.right + 2.0, group.center.dy));
      await tester.tapAt(Offset(menuRect.left - 2.0, menuRect.center.dy));
      expect((menu, previous, next), (1, 1, 1));

      expect(content, 1);
    },
    variant: const TargetPlatformVariant({TargetPlatform.iOS}),
  );

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
