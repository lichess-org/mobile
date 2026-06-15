import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/clock/clock_tool_controller.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/view/clock/clock_tool_screen.dart';

import '../../test_provider_scope.dart';

void main() {
  group('ClockToolScreen delay chip', () {
    testWidgets('shows a d{n} chip for each side when a delay is configured', (tester) async {
      final app = await makeTestProviderScopeApp(tester, home: const ClockToolScreen());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // No delay by default.
      expect(find.text('d5'), findsNothing);

      final container = ProviderScope.containerOf(tester.element(find.byType(ClockToolScreen)));
      container
          .read(clockToolControllerProvider.notifier)
          .updateOptions(const TimeIncrement(60, 0, delay: 5));
      await tester.pumpAndSettle();

      // One static chip per player tile (top and bottom).
      expect(find.text('d5'), findsNWidgets(2));
    });

    testWidgets('shows no delay chip when only an increment is set', (tester) async {
      final app = await makeTestProviderScopeApp(tester, home: const ClockToolScreen());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(tester.element(find.byType(ClockToolScreen)));
      container
          .read(clockToolControllerProvider.notifier)
          .updateOptions(const TimeIncrement(60, 3));
      await tester.pumpAndSettle();

      // No 'd{n}' delay chip is rendered at all (only the '+3' increment chip).
      expect(
        find.byWidgetPredicate(
          (w) => w is Text && w.data != null && RegExp(r'^d\d+$').hasMatch(w.data!),
        ),
        findsNothing,
      );
      expect(find.text('+3'), findsNWidgets(2));
    });
  });
}
