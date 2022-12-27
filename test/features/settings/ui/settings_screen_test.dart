import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/features/settings/ui/settings_screen.dart';
import 'package:lichess_mobile/src/features/settings/data/settings_repository.dart';
import '../data/fake_settings_repository.dart';
import '../../../utils.dart';

void main() {
  group('SettingsScreen', () {
    testWidgets('meets accessibility guidelines', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsRepositoryProvider
                .overrideWithValue(FakeSettingsRepository()),
          ],
          child: buildTestApp(
            home: Consumer(builder: (context, ref, _) {
              return const Scaffold(
                body: SettingsScreen(),
              );
            }),
          ),
        ),
      );

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));

      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));

      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });
  });
}
