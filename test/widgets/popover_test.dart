import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/widgets/popover.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' show GlassPopover;
import 'package:material_ui/material_ui.dart';

import '../test_helpers.dart';

void main() {
  testWidgets('shows the body when the trigger asks for it', variant: kPlatformVariant, (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: PlatformPopover(
              triggerBuilder: (context, showPopover) =>
                  TextButton(onPressed: showPopover, child: const Text('Trigger')),
              bodyBuilder: (_) => const ListTile(title: Text('Popover body')),
            ),
          ),
        ),
      ),
    );

    final isIOS = debugDefaultTargetPlatformOverride == TargetPlatform.iOS;
    expect(find.byType(GlassPopover), isIOS ? findsOneWidget : findsNothing);
    expect(find.text('Popover body'), findsNothing);

    await tester.tap(find.text('Trigger'));
    await tester.pumpAndSettle();

    expect(find.text('Popover body'), findsOneWidget);
  });
}
