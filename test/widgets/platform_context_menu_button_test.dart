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
}
