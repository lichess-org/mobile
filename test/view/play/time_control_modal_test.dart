import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/view/play/time_control_modal.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';

import '../../test_provider_scope.dart';

void main() {
  group('TimeControlModal delay slider', () {
    testWidgets('is hidden when showDelay is false', (tester) async {
      // A non-preset time control keeps the custom section expanded.
      final app = await makeTestProviderScopeApp(
        tester,
        home: Scaffold(
          body: TimeControlModal(timeIncrement: const TimeIncrement(120, 4), onSelected: (_) {}),
        ),
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // Only the minutes and increment sliders, no delay slider.
      expect(find.byType(NonLinearSlider), findsNWidgets(2));
      expect(find.textContaining('Delay in seconds'), findsNothing);
    });

    testWidgets('is shown when showDelay is true', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: Scaffold(
          body: TimeControlModal(
            timeIncrement: const TimeIncrement(600, 0, delay: 5),
            showDelay: true,
            onSelected: (_) {},
          ),
        ),
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // Minutes, increment and delay sliders.
      expect(find.byType(NonLinearSlider), findsNWidgets(3));
      expect(find.textContaining('Delay in seconds'), findsOneWidget);
    });

    testWidgets('custom OK returns the configured delay', (tester) async {
      TimeIncrement? selected;
      final app = await makeTestProviderScopeApp(
        tester,
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => TimeControlModal(
                    timeIncrement: const TimeIncrement(600, 0, delay: 5),
                    showDelay: true,
                    onSelected: (choice) => selected = choice,
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      // The custom section's only FilledButton is the confirm/OK button (avoid
      // coupling to the translated label).
      final okButton = find.byType(FilledButton);
      await tester.ensureVisible(okButton);
      await tester.pumpAndSettle();
      await tester.tap(okButton);
      await tester.pumpAndSettle();

      expect(selected, isNotNull);
      expect(selected!.time, 600);
      expect(selected!.increment, 0);
      expect(selected!.delay, 5);
    });
  });
}
