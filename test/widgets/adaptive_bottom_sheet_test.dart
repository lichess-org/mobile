import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/glass_modal.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' show GlassSlider, GlassSwitch;
import 'package:material_ui/material_ui.dart';

import '../test_helpers.dart';
import '../test_provider_scope.dart';

void main() {
  testWidgets('shows a glass sheet on iOS only', variant: kPlatformVariant, (tester) async {
    final app = await makeTestProviderScopeApp(
      tester,
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () => showAdaptiveBottomSheet<void>(
                context: context,
                builder: (_) => BottomSheetScrollableContainer(
                  children: [
                    const ListSection(
                      children: [
                        ListTile(title: Text('Row')),
                        SwitchSettingTile(title: Text('Switch'), value: true),
                      ],
                    ),
                    NonLinearSlider(value: 2, values: const [1, 2, 3]),
                  ],
                ),
              ),
              child: const Text('Show'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpWidget(app);
    await tester.tap(find.text('Show'));
    await tester.pumpAndSettle();

    final isIOS = debugDefaultTargetPlatformOverride == TargetPlatform.iOS;
    expect(find.text('Row'), findsOneWidget);
    expect(find.byType(GlassBottomSheetFrame), isIOS ? findsOneWidget : findsNothing);
    if (isIOS) {
      // The short content opens at the shared minimum height.
      final screenHeight = tester.view.physicalSize.height / tester.view.devicePixelRatio;
      expect(
        tester.getSize(find.byType(GlassBottomSheetFrame)).height,
        moreOrLessEquals(screenHeight * kGlassBottomSheetMinHeightFraction),
      );
    }

    // On the glass sheet, the section card is translucent.
    final cardMaterial = tester.widget<Material>(
      find.descendant(of: find.byType(ListSection), matching: find.byType(Material)).first,
    );
    expect(cardMaterial.color!.a < 1, isIOS);

    // On the glass sheet, the switch and the slider are glass controls.
    expect(find.byType(GlassSwitch), isIOS ? findsOneWidget : findsNothing);
    expect(find.byType(GlassSlider), isIOS ? findsOneWidget : findsNothing);
    expect(find.byType(Switch), isIOS ? findsNothing : findsOneWidget);
    expect(find.byType(Slider), isIOS ? findsNothing : findsOneWidget);
  });

  testWidgets('shows an opaque expandable sheet', variant: kPlatformVariant, (tester) async {
    final app = await makeTestProviderScopeApp(
      tester,
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () => showAdaptiveDraggableBottomSheet<void>(
                context: context,
                builder: (_, scrollController) => ListView(
                  controller: scrollController,
                  children: [for (var i = 0; i < 50; i++) ListTile(title: Text('Row $i'))],
                ),
              ),
              child: const Text('Show'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpWidget(app);
    await tester.tap(find.text('Show'));
    await tester.pumpAndSettle();

    final isIOS = debugDefaultTargetPlatformOverride == TargetPlatform.iOS;
    expect(find.byType(DraggableScrollableSheet), findsOneWidget);
    expect(find.byType(OpaqueBottomSheetFrame), isIOS ? findsOneWidget : findsNothing);
    if (isIOS) {
      // Opaque and flat: no glass card, and opaque content.
      expect(find.byType(GlassModalCard), findsNothing);
      expect(find.byType(GlassSheetScope), findsNothing);
      final card = tester.widget<Material>(
        find
            .descendant(of: find.byType(OpaqueBottomSheetFrame), matching: find.byType(Material))
            .first,
      );
      expect(card.color?.a, 1.0);
    }

    // Scrolling the list up expands the sheet.
    final heightBefore = tester.getSize(find.byType(DraggableScrollableSheet)).height;
    await tester.drag(find.text('Row 1'), const Offset(0, -200));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(DraggableScrollableSheet)).height, greaterThan(heightBefore));
  });

  testWidgets(
    'shows a full height sheet with a title and a close button',
    variant: kPlatformVariant,
    (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () => showAdaptiveFullHeightBottomSheet<void>(
                  context: context,
                  title: const Text('Title'),
                  builder: (_, scrollController) => ListView(
                    controller: scrollController,
                    children: const [ListTile(title: Text('Row'))],
                  ),
                ),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);
      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      final isIOS = debugDefaultTargetPlatformOverride == TargetPlatform.iOS;
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Row'), findsOneWidget);
      expect(find.byType(OpaqueBottomSheetFrame), isIOS ? findsOneWidget : findsNothing);

      // The short content opens at the full height, down to the bottom of the screen.
      final screenSize = tester.view.physicalSize / tester.view.devicePixelRatio;
      final sheetRect = tester.getRect(find.byType(BottomSheet));
      final topPadding = tester.view.padding.top / tester.view.devicePixelRatio;
      expect(sheetRect.top, moreOrLessEquals(topPadding));
      expect(sheetRect.bottom, moreOrLessEquals(screenSize.height));
      if (isIOS) {
        // Opaque and flat: no glass card, and opaque content.
        expect(find.byType(GlassModalCard), findsNothing);
        expect(find.byType(GlassSheetScope), findsNothing);
        final card = tester.widget<Material>(
          find
              .descendant(of: find.byType(OpaqueBottomSheetFrame), matching: find.byType(Material))
              .first,
        );
        expect(card.color?.a, 1.0);
      }

      await tester.tap(find.byType(SheetHeaderButton));
      await tester.pumpAndSettle();
      expect(find.text('Row'), findsNothing);
    },
  );

  testWidgets(
    'full height sheet is dragged down to dismiss when its content cannot scroll up',
    variant: kPlatformVariant,
    (tester) async {
      Future<void> showSheet(int rowCount) async {
        final app = await makeTestProviderScopeApp(
          tester,
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: ElevatedButton(
                  onPressed: () => showAdaptiveFullHeightBottomSheet<void>(
                    context: context,
                    title: const Text('Title'),
                    builder: (_, scrollController) => ListView(
                      controller: scrollController,
                      children: [
                        for (var i = 0; i < rowCount; i++) ListTile(title: Text('Row $i')),
                      ],
                    ),
                  ),
                  child: const Text('Show'),
                ),
              ),
            ),
          ),
        );
        await tester.pumpWidget(app);
        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();
      }

      // A list at its top: dragging it down moves the sheet down, without squeezing its header.
      await showSheet(50);
      final headerHeight = tester.getSize(find.byType(NavigationToolbar)).height;
      final screenHeight = tester.view.physicalSize.height / tester.view.devicePixelRatio;
      final holdGesture = await tester.startGesture(tester.getCenter(find.text('Row 0')));
      for (var i = 0; i < 42; i++) {
        await holdGesture.moveBy(const Offset(0, 20));
        await tester.pump();
      }
      expect(tester.getRect(find.byType(NavigationToolbar)).top, greaterThan(screenHeight - 80));
      expect(tester.getSize(find.byType(NavigationToolbar)).height, headerHeight);
      await holdGesture.moveBy(const Offset(0, -840));
      await tester.pump();
      await holdGesture.up();
      await tester.pumpAndSettle();
      expect(find.text('Row 0'), findsOneWidget);
      await tester.tap(find.byType(SheetHeaderButton));
      await tester.pumpAndSettle();

      // Nothing to scroll: dragging the content dismisses the sheet.
      await showSheet(1);
      await tester.drag(find.text('Row 0'), const Offset(0, 500));
      await tester.pumpAndSettle();
      expect(find.text('Row 0'), findsNothing);

      // A scrolled list scrolls back up first, then drags the sheet once at its top.
      await showSheet(50);
      final sheetTop = tester.getRect(find.byType(BottomSheet)).top;
      await tester.drag(find.text('Row 3'), const Offset(0, -600));
      await tester.pumpAndSettle();
      expect(find.text('Row 0'), findsNothing);
      await tester.drag(find.text('Row 12'), const Offset(0, 200));
      await tester.pumpAndSettle();
      expect(tester.getRect(find.byType(BottomSheet)).top, sheetTop);
      expect(find.text('Row 0'), findsNothing);
      // Back to the top in the same drag, which goes on dragging the sheet down.
      final gesture = await tester.startGesture(tester.getCenter(find.text('Row 12')));
      for (var i = 0; i < 60; i++) {
        await gesture.moveBy(const Offset(0, 25));
        await tester.pump();
      }
      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.text('Title'), findsNothing);
    },
  );

  testWidgets('sheet content does not switch while the sheet is opening', (tester) async {
    final ready = ValueNotifier(false);
    addTearDown(ready.dispose);
    final app = await makeTestProviderScopeApp(
      tester,
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () => showAdaptiveFullHeightBottomSheet<void>(
                context: context,
                title: const Text('Title'),
                builder: (_, scrollController) => ListView(
                  controller: scrollController,
                  children: [
                    const WhenRouteSettled(
                      ready: true,
                      placeholder: Text('Loading early'),
                      builder: _buildEarlyContent,
                    ),
                    ValueListenableBuilder(
                      valueListenable: ready,
                      builder: (context, value, _) => WhenRouteSettled(
                        ready: value,
                        placeholder: const Text('Loading late'),
                        builder: (_) => const Text('Late content'),
                      ),
                    ),
                  ],
                ),
              ),
              child: const Text('Show'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpWidget(app);
    await tester.tap(find.text('Show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Ready when the sheet opens: shown during the transition.
    expect(find.text('Early content'), findsOneWidget);

    // Ready during the transition: shown once it is over.
    ready.value = true;
    await tester.pump();
    // The sheet is still mostly below the screen.
    expect(find.text('Loading late', skipOffstage: false), findsOneWidget);
    expect(find.text('Late content', skipOffstage: false), findsNothing);
    await tester.pumpAndSettle();
    expect(find.text('Late content'), findsOneWidget);
  });
}

Widget _buildEarlyContent(BuildContext context) => const Text('Early content');
