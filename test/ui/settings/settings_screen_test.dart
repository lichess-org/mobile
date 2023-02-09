import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lichess_mobile/src/common/shared_preferences.dart';
import 'package:lichess_mobile/src/ui/settings/settings_screen.dart';
import '../../utils.dart';

void main() {
  group('SettingsScreen', () {
    testWidgets(
      'meets accessibility guidelines',
      (WidgetTester tester) async {
        final SemanticsHandle handle = tester.ensureSemantics();

        SharedPreferences.setMockInitialValues({});
        final sharedPreferences = await SharedPreferences.getInstance();

        final app = await buildTestApp(
          tester,
          home: Consumer(
            builder: (context, ref, _) {
              return const SettingsScreen();
            },
          ),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              ...defaultProviderOverrides,
              sharedPreferencesProvider.overrideWithValue(sharedPreferences),
            ],
            child: app,
          ),
        );

        await meetsTapTargetGuideline(tester);

        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
      },
      variant: kPlatformVariant,
    );
  });
}
