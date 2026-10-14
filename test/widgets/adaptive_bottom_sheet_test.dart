import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
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
    final card = tester.widget<Card>(
      find.descendant(of: find.byType(ListSection), matching: find.byType(Card)),
    );
    expect(card.color != null && card.color!.a < 1, isIOS);

    // On the glass sheet, the switch and the slider are glass controls.
    expect(find.byType(GlassSwitch), isIOS ? findsOneWidget : findsNothing);
    expect(find.byType(GlassSlider), isIOS ? findsOneWidget : findsNothing);
    expect(find.byType(Switch), isIOS ? findsNothing : findsOneWidget);
    expect(find.byType(Slider), isIOS ? findsNothing : findsOneWidget);
  });
}
