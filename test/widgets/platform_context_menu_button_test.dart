import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart' show kLongPressTimeout;
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';
import 'package:material_ui/material_ui.dart';

import '../test_helpers.dart';
import '../test_provider_scope.dart';

void main() {
  testWidgets('opens the menu and runs an action', variant: kPlatformVariant, (tester) async {
    var pressed = 0;

    final app = await makeTestProviderScopeApp(
      tester,
      home: PlatformScaffold(
        appBar: PlatformAppBar(
          title: const Text('Title'),
          actions: [
            ContextMenuIconButton(
              icon: const Icon(Icons.more_horiz),
              semanticsLabel: 'Menu',
              actions: [
                ContextMenuAction(
                  icon: Icons.settings,
                  label: 'Settings',
                  onPressed: () => pressed++,
                ),
              ],
            ),
          ],
        ),
        body: const SizedBox.shrink(),
      ),
    );

    await tester.pumpWidget(app);

    expect(find.text('Settings'), findsNothing);

    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(pressed, 1);
  });

  group('ContextMenuRegion', () {
    Future<void> pumpRegion(WidgetTester tester, VoidCallback onCopy) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: PlatformScaffold(
          body: Center(
            child: ContextMenuRegion(
              actions: [ContextMenuAction(icon: Icons.copy, label: 'Copy', onPressed: onCopy)],
              child: const SizedBox(width: 200, height: 50, child: Text('Message')),
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);
    }

    testWidgets('opens the menu on long press and runs an action', variant: kPlatformVariant, (
      tester,
    ) async {
      var pressed = 0;
      await pumpRegion(tester, () => pressed++);

      expect(find.text('Copy'), findsNothing);

      await tester.longPress(find.text('Message'));
      await tester.pumpAndSettle();

      expect(find.text('Copy'), findsOneWidget);

      await tester.tap(find.text('Copy'));
      await tester.pumpAndSettle();

      expect(pressed, 1);
      expect(find.text('Copy'), findsNothing);
    });

    testWidgets('selects an action by sliding the long press onto it', variant: kPlatformVariant, (
      tester,
    ) async {
      var pressed = 0;
      await pumpRegion(tester, () => pressed++);

      final gesture = await tester.startGesture(tester.getCenter(find.text('Message')));
      await tester.pump(kLongPressTimeout + const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      expect(find.text('Copy'), findsOneWidget);

      // Only the iOS menu follows the finger; the Material menu waits for a tap.
      if (debugDefaultTargetPlatformOverride == TargetPlatform.iOS) {
        await gesture.moveTo(tester.getCenter(find.text('Copy')));
        await tester.pump();
        await gesture.up();
        await tester.pumpAndSettle();
        expect(pressed, 1);
      } else {
        await gesture.up();
        await tester.pumpAndSettle();
        expect(find.text('Copy'), findsOneWidget);
      }
    });
  });
}
