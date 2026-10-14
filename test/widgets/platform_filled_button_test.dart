import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/platform_filled_button.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' show GlassButton;
import 'package:material_ui/material_ui.dart';

import '../test_helpers.dart';
import '../test_provider_scope.dart';

void main() {
  testWidgets('is a glass button on a glass sheet only', variant: kPlatformVariant, (tester) async {
    var pressed = 0;
    final app = await makeTestProviderScopeApp(
      tester,
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: SizedBox(
              width: 200,
              child: PlatformFilledButton(
                onPressed: () => showAdaptiveBottomSheet<void>(
                  context: context,
                  builder: (_) => BottomSheetScrollableContainer(
                    children: [
                      PlatformFilledButton(onPressed: () => pressed++, child: const Text('Play')),
                    ],
                  ),
                ),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpWidget(app);

    // Outside a glass sheet, a Material filled button on both platforms.
    expect(find.byType(FilledButton), findsOneWidget);
    expect(find.byType(GlassButton), findsNothing);

    await tester.tap(find.text('Show'));
    await tester.pumpAndSettle();

    final isIOS = debugDefaultTargetPlatformOverride == TargetPlatform.iOS;
    expect(
      find.ancestor(of: find.text('Play'), matching: find.byType(GlassButton)),
      isIOS ? findsOneWidget : findsNothing,
    );
    expect(
      find.ancestor(of: find.text('Play'), matching: find.byType(FilledButton)),
      isIOS ? findsNothing : findsOneWidget,
    );

    await tester.tap(find.text('Play'));
    expect(pressed, 1);
  });
}
