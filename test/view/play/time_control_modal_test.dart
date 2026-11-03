import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/view/play/time_control_modal.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/platform_choice_chip.dart';
import 'package:material_ui/material_ui.dart';

import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

void main() {
  testWidgets('selects a time control', variant: kPlatformVariant, (tester) async {
    TimeIncrement? selected;
    await tester.pumpWidget(
      await makeTestProviderScopeApp(
        tester,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showAdaptiveBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (_) => TimeControlModal(
                  timeIncrement: const TimeIncrement(180, 2),
                  onSelected: (choice) => selected = choice,
                ),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    final isIOS = debugDefaultTargetPlatformOverride == TargetPlatform.iOS;
    expect(find.byType(PlatformChoiceChip), isIOS ? findsWidgets : findsNothing);

    await tester.tap(find.text('5+0'));
    await tester.pumpAndSettle();

    expect(selected, const TimeIncrement(300, 0));
    expect(find.byType(TimeControlModal), findsNothing);
  });
}
