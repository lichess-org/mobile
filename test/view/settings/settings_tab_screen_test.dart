import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/settings/settings_tab_screen.dart';

import '../../model/auth/fake_session_storage.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

final client = MockClient((request) {
  if (request.method == 'DELETE' && request.url.path == '/api/token') {
    return mockResponse('ok', 200);
  }
  return mockResponse('', 404);
});

void main() {
  group('SettingsTabScreen', () {
    testWidgets('meets accessibility guidelines', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();

      final app = await makeTestProviderScopeApp(tester, home: const SettingsTabScreen());

      await tester.pumpWidget(app);

      await meetsTapTargetGuideline(tester);

      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    }, variant: kPlatformVariant);

    testWidgets("don't show signOut if no session", (WidgetTester tester) async {
      final app = await makeTestProviderScopeApp(tester, home: const SettingsTabScreen());

      await tester.pumpWidget(app);

      expect(find.text('Sign out'), findsNothing);
    }, variant: kPlatformVariant);

    testWidgets('signout', (WidgetTester tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const SettingsTabScreen(),
        userSession: fakeSession,
        overrides: [
          lichessClientProvider.overrideWith((ref) => LichessClient(client, ref)),
          getDbSizeInBytesProvider.overrideWith((_) => 1000),
        ],
      );

      await tester.pumpWidget(app);

      expect(find.text('Sign out'), findsOneWidget);

      await tester.tap(find.widgetWithText(ListTile, 'Sign out'), warnIfMissed: false);
      await tester.pumpAndSettle();

      // confirm
      if (debugDefaultTargetPlatformOverride == TargetPlatform.iOS) {
        await tester.tap(find.widgetWithText(CupertinoActionSheetAction, 'Sign out'));
      } else {
        await tester.tap(find.text('OK'));
      }
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // wait for sign out future
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Sign out'), findsNothing);
    }, variant: kPlatformVariant);
  });
}
