import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';

import '../test_helpers.dart';

enum TestEnumLarge { one, two, three, four, five, six, seven, eight, nine, ten, eleven }

enum TestEnumSmall { one, two, three }

void main() {
  testWidgets('showChoicePicker call onSelectedItemChanged (large choices)', (
    WidgetTester tester,
  ) async {
    final List<TestEnumLarge> selectedItems = <TestEnumLarge>[];

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return Center(
                child: ElevatedButton(
                  child: const Text('Show picker'),
                  onPressed: () {
                    showChoicePicker(
                      context,
                      choices: TestEnumLarge.values,
                      selectedItem: TestEnumLarge.one,
                      labelBuilder: (choice) => Text(choice.name),
                      onSelectedItemChanged: (choice) {
                        selectedItems.add(choice);
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show picker'));
    await tester.pumpAndSettle();

    // with large choices (>= 6), on iOS the picker scrolls
    if (debugDefaultTargetPlatformOverride == TargetPlatform.iOS) {
      // scroll 2 items (2 * 40 height)
      await tester.drag(
        find.text('one'),
        const Offset(0.0, -80.0),
        warnIfMissed: false,
      ); // has an IgnorePointer
      expect(selectedItems, <TestEnumLarge>[]);
      await tester.pumpAndSettle(); // await for scroll ends
      // only third item is selected as the scroll ends
      expect(selectedItems, [TestEnumLarge.three]);
    } else {
      await tester.tap(find.text('three'));
      expect(selectedItems, [TestEnumLarge.three]);
    }
  }, variant: kPlatformVariant);

  testWidgets('showChoicePicker call onSelectedItemChanged (small choices)', (
    WidgetTester tester,
  ) async {
    final List<TestEnumSmall> selectedItems = <TestEnumSmall>[];

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return Center(
                child: ElevatedButton(
                  child: const Text('Show picker'),
                  onPressed: () {
                    showChoicePicker(
                      context,
                      choices: TestEnumSmall.values,
                      selectedItem: TestEnumSmall.one,
                      labelBuilder: (choice) => Text(choice.name),
                      onSelectedItemChanged: (choice) {
                        selectedItems.add(choice);
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show picker'));
    await tester.pumpAndSettle();

    // With small choices, on iOS the picker is an action sheet
    await tester.tap(find.text('three'));
    expect(selectedItems, [TestEnumSmall.three]);
  }, variant: kPlatformVariant);
}
