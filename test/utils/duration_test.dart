import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:lichess_mobile/src/utils/duration.dart';

void main() {
  group('DurationExtensions.toDaysHoursMinutes()', () {
    // The following tests are widget tests because the function being
    // tested need access to the BuildContext, and this is a simple way to access it.
    testWidgets('all values nonzero, plural', (WidgetTester tester) async {
      await tester.pumpWidget(
          emptyTestWidget(2, 2, 2, '2 days, 2 hours and 2 minutes'));
    });

    testWidgets('all values nonzero, single', (WidgetTester tester) async {
      await tester
          .pumpWidget(emptyTestWidget(1, 1, 1, '1 day, 1 hour and 1 minute'));
    });

    testWidgets('no days', (WidgetTester tester) async {
      await tester
          .pumpWidget(emptyTestWidget(0, 2, 2, '2 hours and 2 minutes'));
    });

    testWidgets('no hours', (WidgetTester tester) async {
      await tester.pumpWidget(emptyTestWidget(2, 0, 2, '2 days and 2 minutes'));
    });

    testWidgets('no minutes', (WidgetTester tester) async {
      await tester.pumpWidget(emptyTestWidget(2, 2, 0, '2 days and 2 hours'));
    });

    testWidgets('only days', (WidgetTester tester) async {
      await tester.pumpWidget(emptyTestWidget(2, 0, 0, '2 days'));
    });

    testWidgets('only hours', (WidgetTester tester) async {
      await tester.pumpWidget(emptyTestWidget(0, 2, 0, '2 hours'));
    });

    testWidgets('only minutes', (WidgetTester tester) async {
      await tester.pumpWidget(emptyTestWidget(0, 0, 2, '2 minutes'));
    });

    testWidgets('all values zero', (WidgetTester tester) async {
      await tester.pumpWidget(emptyTestWidget(0, 0, 0, '0 minutes'));
    });
  });
}

Widget emptyTestWidget(int days, int hours, int minutes, String expected) {
  return Localizations(
    delegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate
    ],
    locale: const Locale('en'),
    child: Builder(
      builder: (BuildContext context) {
        final timeStr = Duration(days: days, hours: hours, minutes: minutes)
            .toDaysHoursMinutes(context);
        expect(timeStr, expected);

        // The builder function must return a widget.
        return const Placeholder();
      },
    ),
  );
}
