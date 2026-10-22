import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart' show kLongPressTimeout;
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
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

    await tester.tap(find.byIcon(Icons.more_horiz).hitTestable());
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(pressed, 1);
  });

  testWidgets('marks the selected action with a check mark', variant: kPlatformVariant, (
    tester,
  ) async {
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
                ContextMenuAction(label: 'One day', onPressed: () {}),
                ContextMenuAction(label: 'One week', selected: true, onPressed: () {}),
              ],
            ),
          ],
        ),
        body: const SizedBox.shrink(),
      ),
    );

    await tester.pumpWidget(app);
    await tester.tap(find.byIcon(Icons.more_horiz).hitTestable());
    await tester.pumpAndSettle();

    // Before the label of each action, visible on the selected one only.
    final checks = find.byIcon(Icons.check);
    expect(checks, findsNWidgets(2));
    final selectedCheck = find.byWidgetPredicate(
      (widget) => widget is Icon && widget.icon == Icons.check && widget.color == null,
    );
    expect(selectedCheck, findsOneWidget);
    expect(
      tester.getCenter(selectedCheck).dx,
      lessThan(tester.getTopLeft(find.text('One week')).dx),
    );
    expect(
      tester.getCenter(selectedCheck).dy,
      moreOrLessEquals(tester.getCenter(find.text('One week')).dy, epsilon: 1.0),
    );
    // The invisible check keeps the labels aligned.
    expect(tester.getTopLeft(find.text('One day')).dx, tester.getTopLeft(find.text('One week')).dx);
  });

  testWidgets('shows a toggle, a titled section and a submenu', variant: kPlatformVariant, (
    tester,
  ) async {
    var toggled = 0;
    String? picked;

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
                ContextMenuAction(label: 'Eval bar', toggled: true, onPressed: () => toggled++),
                ContextMenuSection(
                  title: 'Filter',
                  actions: [
                    ContextMenuAction(label: 'All', selected: true, onPressed: () {}),
                    ContextMenuAction(
                      label: 'Team',
                      subtitle: 'All teams',
                      onPressed: null,
                      submenu: [
                        for (final team in ['Team A', 'Team B'])
                          ContextMenuAction(label: team, onPressed: () => picked = team),
                      ],
                    ),
                  ],
                ),
                ContextMenuAction(icon: Icons.share, label: 'Share', onPressed: () {}),
              ],
            ),
          ],
        ),
        body: const SizedBox.shrink(),
      ),
    );

    await tester.pumpWidget(app);
    await tester.tap(find.byIcon(Icons.more_horiz).hitTestable());
    await tester.pumpAndSettle();

    expect(find.text('Filter'), findsOneWidget);
    expect(find.text('All teams'), findsOneWidget);
    expect(find.text('Team A'), findsNothing);

    final visibleChecks = find.byWidgetPredicate(
      (widget) => widget is Icon && widget.icon == Icons.check && widget.color == null,
    );
    if (debugDefaultTargetPlatformOverride == TargetPlatform.iOS) {
      // A checked circle before the toggle that is on, a check mark before the selected choice.
      expect(find.byIcon(CupertinoIcons.checkmark_circle_fill), findsOneWidget);
      expect(
        tester.getCenter(find.byIcon(CupertinoIcons.checkmark_circle_fill)).dx,
        lessThan(tester.getTopLeft(find.text('Eval bar')).dx),
      );
      expect(visibleChecks, findsOneWidget);
    } else {
      expect(tester.widget<CheckboxMenuButton>(find.byType(CheckboxMenuButton)).value, isTrue);
      expect(visibleChecks, findsOneWidget);
      // The check mark space is only in the group of choices: the icon of an action after it is
      // where the check marks are.
      expect(
        tester.getCenter(find.byIcon(Icons.share)).dx,
        moreOrLessEquals(tester.getCenter(visibleChecks).dx, epsilon: 1.0),
      );
    }
    // The check mark of the selected choice and the icons are before the labels.
    expect(
      tester.getCenter(visibleChecks.last).dx,
      lessThan(tester.getTopLeft(find.text('All')).dx),
    );
    expect(
      tester.getCenter(find.byIcon(Icons.share)).dx,
      lessThan(tester.getTopLeft(find.text('Share')).dx),
    );

    await tester.tap(find.text('Team'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Team B'));
    await tester.pumpAndSettle();

    expect(picked, 'Team B');

    await tester.tap(find.byIcon(Icons.more_horiz).hitTestable());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eval bar'));
    await tester.pumpAndSettle();

    expect(toggled, 1);
  });

  testWidgets('a long submenu of a pushed screen scrolls', variant: kPlatformVariant, (
    tester,
  ) async {
    String? picked;

    final app = await makeTestProviderScopeApp(
      tester,
      home: Builder(
        builder: (context) => PlatformScaffold(
          body: Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).push(
                buildScreenRoute<void>(
                  screen: PlatformScaffold(
                    appBar: PlatformAppBar(
                      title: const Text('Title'),
                      actions: [
                        ContextMenuIconButton(
                          icon: const Icon(Icons.more_horiz),
                          semanticsLabel: 'Menu',
                          actions: [
                            ContextMenuAction(
                              label: 'Team',
                              onPressed: null,
                              submenu: [
                                for (var i = 0; i < 40; i++)
                                  ContextMenuAction(
                                    label: 'Team $i',
                                    onPressed: () => picked = 'Team $i',
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    body: const SizedBox.shrink(),
                  ),
                ),
              ),
              child: const Text('Push'),
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(app);
    await tester.tap(find.text('Push'));
    await tester.pumpAndSettle();
    // On iOS 26, the menu of the pinned app bar button is the package's.
    await tester.tap(find.byIcon(Icons.more_horiz).hitTestable());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Team'));
    await tester.pumpAndSettle();

    final lastTeam = find.text('Team 39');
    await tester.dragUntilVisible(lastTeam, find.text('Team 0'), const Offset(0, -200));
    await tester.pumpAndSettle();
    await tester.tap(lastTeam);
    await tester.pumpAndSettle();

    expect(picked, 'Team 39');
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
