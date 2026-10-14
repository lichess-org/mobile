import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/widgets/platform_choice_chip.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' show GlassButton;
import 'package:material_ui/material_ui.dart';

import '../test_helpers.dart';

void main() {
  testWidgets('toggles its selection', variant: kPlatformVariant, (tester) async {
    final changes = <bool>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Row(
              children: [
                PlatformChoiceChip(
                  label: const Text('Selected'),
                  selected: true,
                  onSelected: changes.add,
                ),
                PlatformChoiceChip(
                  label: const Text('Other'),
                  selected: false,
                  multiple: true,
                  onSelected: changes.add,
                ),
                const PlatformChoiceChip(
                  label: Text('Disabled'),
                  selected: false,
                  onSelected: null,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final isIOS = debugDefaultTargetPlatformOverride == TargetPlatform.iOS;
    expect(find.byType(GlassButton), isIOS ? findsNWidgets(3) : findsNothing);
    expect(find.byType(ChoiceChip), isIOS ? findsNothing : findsNWidgets(2));
    expect(find.byType(FilterChip), isIOS ? findsNothing : findsOneWidget);

    await tester.tap(find.text('Selected'));
    await tester.tap(find.text('Other'));
    await tester.tap(find.text('Disabled'), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(changes, [false, true]);
  });
}
