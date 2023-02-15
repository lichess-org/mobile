import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lichess_mobile/src/common/shared_preferences.dart';
import 'package:lichess_mobile/src/model/auth/session_repository.dart';
import 'package:lichess_mobile/src/ui/settings/settings_screen.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import '../../utils.dart';
import '../../model/auth/fake_session_repository.dart';

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

        // wait for auth controller
        await tester.pump(const Duration(milliseconds: 20));

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

        // wait for auth controller
        await tester.pump(const Duration(milliseconds: 20));

        expect(find.text('Sign out'), findsNothing);
      },
      variant: kPlatformVariant,
    );

    testWidgets(
      'signout',
      (WidgetTester tester) async {
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
              sessionRepositoryProvider
                  .overrideWithValue(FakeSessionRepository(fakeSession)),
              sharedPreferencesProvider.overrideWithValue(sharedPreferences),
            ],
            child: app,
          ),
        );

        // wait for auth controller
        await tester.pump(const Duration(milliseconds: 20));

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
