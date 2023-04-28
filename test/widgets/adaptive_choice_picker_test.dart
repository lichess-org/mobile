import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';

import '../test_utils.dart';

enum TestEnum { one, two, three }

void main() {
  testWidgets(
    'showChoicePicker call onSelectedItemChanged',
    (WidgetTester tester) async {
      final List<TestEnum> selectedItems = <TestEnum>[];

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
                        choices: TestEnum.values,
                        selectedItem: TestEnum.one,
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

      if (debugDefaultTargetPlatformOverride == TargetPlatform.iOS) {
        // scroll 2 items (2 * 40 height)
        await tester.drag(
          find.text('one'),
          const Offset(0.0, -80.0),
          warnIfMissed: false,
        ); // has an IgnorePointer
        expect(selectedItems, <TestEnum>[]);
        await tester.pumpAndSettle(); // await for scroll ends
        // only third item is selected as the scroll ends
        expect(selectedItems, [TestEnum.three]);
      } else {
        await tester.tap(find.text('three'));
        expect(selectedItems, [TestEnum.three]);
      }
    },
    variant: kPlatformVariant,
  );
}
