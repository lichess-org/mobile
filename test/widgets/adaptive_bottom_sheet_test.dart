import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/glass_modal.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:material_ui/material_ui.dart';

import '../test_helpers.dart';
import '../test_provider_scope.dart';

void main() {
  testWidgets('shows an opaque sheet by default', variant: kPlatformVariant, (tester) async {
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
    expect(find.byType(OpaqueBottomSheetFrame), isIOS ? findsOneWidget : findsNothing);
    if (isIOS) {
      // The short content opens at the shared minimum height.
      final screenHeight = tester.view.physicalSize.height / tester.view.devicePixelRatio;
      expect(
        tester.getSize(find.byType(OpaqueBottomSheetFrame)).height,
        moreOrLessEquals(screenHeight * kBottomSheetMinHeightFraction),
      );
      final frameMaterial = tester.widget<Material>(
        find
            .descendant(of: find.byType(OpaqueBottomSheetFrame), matching: find.byType(Material))
            .first,
      );
      expect(frameMaterial.color!.a, 1.0);
    }

    // The section card is opaque.
    final cardMaterial = tester.widget<Material>(
      find.descendant(of: find.byType(ListSection), matching: find.byType(Material)).first,
    );
    expect(cardMaterial.color!.a, 1.0);
  });

  testWidgets('shows an expandable sheet', variant: kPlatformVariant, (tester) async {
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

    // Scrolling the list up expands the sheet first: the first row moves up, still shown.
    final topBefore = tester.getTopLeft(find.text('Row 0')).dy;
    await tester.drag(find.text('Row 1'), const Offset(0, -200));
    await tester.pumpAndSettle();
    expect(find.text('Row 0'), findsOneWidget);
    expect(tester.getTopLeft(find.text('Row 0')).dy, lessThan(topBefore));
  });

  group('navigation sheet', () {
    testWidgets(
      'opens at the full height with a title and a close button',
      variant: kPlatformVariant,
      (tester) async {
        await _showNavigationSheet(
          tester,
          body: (_) => ListView(children: const [ListTile(title: Text('Row'))]),
        );

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
        // The content is below the app bar.
        expect(
          tester.getRect(find.text('Row')).top,
          greaterThan(tester.getRect(find.text('Title')).bottom),
        );
        if (isIOS) {
          // Opaque and flat: no glass card, and opaque content.
          expect(find.byType(GlassModalCard), findsNothing);
          final card = tester.widget<Material>(
            find
                .descendant(
                  of: find.byType(OpaqueBottomSheetFrame),
                  matching: find.byType(Material),
                )
                .first,
          );
          expect(card.color?.a, 1.0);
        }

        await tester.tap(_closeButton());
        await tester.pumpAndSettle();
        expect(find.text('Row'), findsNothing);
      },
    );

    testWidgets(
      'is dragged down to dismiss when its content cannot scroll up',
      variant: kPlatformVariant,
      (tester) async {
        Future<void> showSheet(int rowCount) => _showNavigationSheet(
          tester,
          body: (_) => ListView(
            children: [for (var i = 0; i < rowCount; i++) ListTile(title: Text('Row $i'))],
          ),
        );

        // A list at its top: dragging it down moves the sheet down, without squeezing its app bar.
        await showSheet(50);
        final titleHeight = tester.getSize(find.text('Title')).height;
        final screenHeight = tester.view.physicalSize.height / tester.view.devicePixelRatio;
        final holdGesture = await tester.startGesture(tester.getCenter(find.text('Row 0')));
        for (var i = 0; i < 42; i++) {
          await holdGesture.moveBy(const Offset(0, 20));
          await tester.pump();
        }
        expect(tester.getRect(find.text('Title')).top, greaterThan(screenHeight - 80));
        expect(tester.getSize(find.text('Title')).height, titleHeight);
        await holdGesture.moveBy(const Offset(0, -840));
        await tester.pump();
        await holdGesture.up();
        await tester.pumpAndSettle();
        expect(find.text('Row 0'), findsOneWidget);
        await tester.tap(_closeButton());
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

    Future<void> showSheetWithSecondPage(WidgetTester tester) => _showNavigationSheet(
      tester,
      body: (context) => ListView(
        children: [
          ListTile(
            title: const Text('Next'),
            onTap: () => Navigator.of(context).push(
              buildScreenRoute<void>(
                screen: PlatformScaffold(
                  appBar: const PlatformAppBar(title: Text('Second')),
                  body: ListView(
                    children: [for (var i = 0; i < 50; i++) ListTile(title: Text('Second row $i'))],
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('Full screen'),
            onTap: () => Navigator.of(context).pushHidingTabBar(
              buildScreenRoute<void>(
                screen: const PlatformScaffold(
                  appBar: PlatformAppBar(title: Text('Board')),
                  body: Center(child: Text('Board body')),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Future<void> pushSecond(WidgetTester tester) async {
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      await tester.pump();
      expect(find.text('Second row 0'), findsOneWidget);
    }

    testWidgets('pushes screens in the sheet', variant: kPlatformVariant, (tester) async {
      await showSheetWithSecondPage(tester);
      await pushSecond(tester);

      // Opened in the sheet, below its app bar.
      expect(
        find.descendant(of: find.byType(BottomSheet), matching: find.text('Second row 0')),
        findsOneWidget,
      );
      expect(
        tester.getRect(find.text('Second row 0')).top,
        greaterThan(tester.getRect(find.text('Second')).bottom),
      );

      // The back button of the second page pops it, in the sheet.
      final isIOS = debugDefaultTargetPlatformOverride == TargetPlatform.iOS;
      await tester.tap(
        isIOS ? find.byIcon(CupertinoIcons.back).hitTestable() : find.byType(BackButton),
      );
      await tester.pumpAndSettle();
      await tester.pump();
      expect(find.text('Second row 0'), findsNothing);
      expect(find.text('Next'), findsOneWidget);

      // The close button of the first page closes the sheet.
      await tester.tap(_closeButton());
      await tester.pumpAndSettle();
      expect(find.text('Next'), findsNothing);
    });

    testWidgets('closes the sheet, then pushes a screen hiding the tab bar', (tester) async {
      await showSheetWithSecondPage(tester);
      await tester.tap(find.text('Full screen'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Not pushed while the sheet is closing.
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Board body'), findsNothing);

      await tester.pumpAndSettle();
      expect(find.byType(BottomSheet), findsNothing);
      expect(find.text('Board body'), findsOneWidget);

      // Popping it goes back to the screen below, without the sheet.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Board body'), findsNothing);
      expect(find.text('Next'), findsNothing);
      expect(find.text('Show'), findsOneWidget);
    });

    testWidgets('the system back pops the pages before the sheet', (tester) async {
      await showSheetWithSecondPage(tester);
      await pushSecond(tester);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Second row 0'), findsNothing);
      expect(find.text('Next'), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Next'), findsNothing);
    });

    testWidgets('a pushed screen drags the sheet down to dismiss it', variant: kPlatformVariant, (
      tester,
    ) async {
      await showSheetWithSecondPage(tester);
      await pushSecond(tester);

      // Scrolled, the list scrolls back up first.
      final sheetTop = tester.getRect(find.byType(BottomSheet)).top;
      await tester.drag(find.text('Second row 3'), const Offset(0, -600));
      await tester.pumpAndSettle();
      expect(find.text('Second row 0'), findsNothing);
      await tester.drag(find.text('Second row 12'), const Offset(0, 200));
      await tester.pumpAndSettle();
      expect(tester.getRect(find.byType(BottomSheet)).top, sheetTop);

      // Back to the top in the same drag, which goes on dragging the sheet down.
      final gesture = await tester.startGesture(tester.getCenter(find.text('Second row 12')));
      for (var i = 0; i < 60; i++) {
        await gesture.moveBy(const Offset(0, 25));
        await tester.pump();
      }
      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.byType(BottomSheet), findsNothing);
    });

    testWidgets('content does not switch while the sheet is opening', (tester) async {
      final ready = ValueNotifier(false);
      addTearDown(ready.dispose);
      await _showNavigationSheet(
        tester,
        settle: false,
        body: (_) => ListView(
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
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      // Ready when the sheet opens: shown during the transition.
      expect(find.text('Early content', skipOffstage: false), findsOneWidget);

      // Ready during the transition: shown once it is over.
      ready.value = true;
      await tester.pump();
      // The sheet is still mostly below the screen.
      expect(find.text('Loading late', skipOffstage: false), findsOneWidget);
      expect(find.text('Late content', skipOffstage: false), findsNothing);
      await tester.pumpAndSettle();
      expect(find.text('Late content'), findsOneWidget);
    });

    testWidgets('content does not switch while a page is pushed', (tester) async {
      final ready = ValueNotifier(false);
      addTearDown(ready.dispose);
      await _showNavigationSheet(
        tester,
        body: (context) => ListView(
          children: [
            ListTile(
              title: const Text('Next'),
              onTap: () => Navigator.of(context).push(
                buildScreenRoute<void>(
                  screen: PlatformScaffold(
                    appBar: const PlatformAppBar(title: Text('Second')),
                    body: ValueListenableBuilder(
                      valueListenable: ready,
                      builder: (context, value, _) => WhenRouteSettled(
                        ready: value,
                        placeholder: const Center(child: Text('Loading')),
                        builder: (_) => const Center(child: Text('Loaded')),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      await tester.tap(find.text('Next'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      ready.value = true;
      await tester.pump();
      expect(find.text('Loading', skipOffstage: false), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Loaded'), findsOneWidget);
    });
  });
}

/// Shows a navigation sheet whose first page has the title "Title" and [body].
Future<void> _showNavigationSheet(
  WidgetTester tester, {
  required WidgetBuilder body,
  bool settle = true,
}) async {
  final app = await makeTestProviderScopeApp(
    tester,
    home: Scaffold(
      body: Builder(
        builder: (context) => Center(
          child: ElevatedButton(
            onPressed: () => showAdaptiveNavigationSheet<void>(
              context: context,
              builder: (context) => PlatformScaffold(
                appBar: const PlatformAppBar(title: Text('Title')),
                body: Builder(builder: body),
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
  if (settle) {
    await tester.pumpAndSettle();
    // The pinned app bar buttons are drawn a frame later.
    await tester.pump();
  }
}

/// The close button that the app bar of the first page of a navigation sheet has.
Finder _closeButton() => find
    .byIcon(
      debugDefaultTargetPlatformOverride == TargetPlatform.iOS ? Icons.close_rounded : Icons.close,
    )
    .hitTestable();

Widget _buildEarlyContent(BuildContext context) => const Text('Early content');
