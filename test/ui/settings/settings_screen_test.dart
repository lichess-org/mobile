import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lichess_mobile/src/ui/settings/settings_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import '../../test_utils.dart';
import '../../test_app.dart';
import '../../model/auth/fake_session_storage.dart';

void main() {
  group('SettingsScreen', () {
    testWidgets(
      'meets accessibility guidelines',
      (WidgetTester tester) async {
        final SemanticsHandle handle = tester.ensureSemantics();

        final app = await buildTestApp(
          tester,
          home: const SettingsScreen(),
        );

        await tester.pumpWidget(app);

        await meetsTapTargetGuideline(tester);

        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
      },
      variant: kPlatformVariant,
    );

    testWidgets(
      "don't show signOut if no session",
      (WidgetTester tester) async {
        final app = await buildTestApp(
          tester,
          home: const SettingsScreen(),
        );

        await tester.pumpWidget(app);

        expect(find.text('Sign out'), findsNothing);
      },
      variant: kPlatformVariant,
    );

    testWidgets(
      'signout',
      (WidgetTester tester) async {
        final app = await buildTestApp(
          tester,
          home: const SettingsScreen(),
          userSession: fakeSession,
        );

        await tester.pumpWidget(app);

        expect(find.text('Sign out'), findsOneWidget);

        await tester.tap(
          find.widgetWithText(PlatformListTile, 'Sign out'),
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();

        // confirm
        if (debugDefaultTargetPlatformOverride == TargetPlatform.iOS) {
          await tester
              .tap(find.widgetWithText(CupertinoActionSheetAction, 'Sign out'));
        } else {
          await tester.tap(find.text('Accept'));
        }
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        // wait for sign out future
        await tester.pump(const Duration(seconds: 1));

        expect(find.text('Sign out'), findsNothing);
      },
      variant: kPlatformVariant,
    );
  });
}
