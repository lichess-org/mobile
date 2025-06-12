import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/app.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart';
import 'package:lichess_mobile/src/view/home/home_tab_screen.dart';

import 'model/auth/fake_session_storage.dart';
import 'network/fake_http_client_factory.dart';
import 'test_helpers.dart';
import 'test_provider_scope.dart';

void main() {
  testWidgets('App loads', (tester) async {
    final app = await makeTestProviderScope(tester, child: const Application());

    await tester.pumpWidget(app);

    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(HomeTabScreen), findsOneWidget);
  }, variant: kPlatformVariant);

  testWidgets('App loads with system theme, which defaults to light', (tester) async {
    final app = await makeTestProviderScope(tester, child: const Application());

    await tester.pumpWidget(app);

    expect(Theme.of(tester.element(find.byType(MaterialApp))).brightness, Brightness.light);
  }, variant: kPlatformVariant);

  testWidgets('App will delete a stored session on startup if one request return 401', (
    tester,
  ) async {
    int tokenTestRequests = 0;
    final mockClient = MockClient((request) {
      if (request.url.path == '/api/token/test') {
        tokenTestRequests++;
        return mockResponse('''
{
  "${fakeSession.token}": null
}
        ''', 200);
      } else if (request.url.path == '/api/account') {
        return mockResponse('{"error": "Unauthorized"}', 401);
      }
      return mockResponse('', 404);
    });

    final app = await makeTestProviderScope(
      tester,
      child: const Application(),
      userSession: fakeSession,
      overrides: [
        httpClientFactoryProvider.overrideWith((ref) => FakeHttpClientFactory(() => mockClient)),
      ],
    );

    await tester.pumpWidget(app);

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(HomeTabScreen), findsOneWidget);

    // wait for the startup requests and animations to complete
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    // should see welcome message
    expect(
      find.text(
        'Lichess is a free (really), libre, no-ads, open source chess server.',
        findRichText: true,
      ),
      findsOneWidget,
    );

    // should have made a request to test the token
    expect(tokenTestRequests, 1);

    // session is not active anymore
    expect(find.text('Sign in'), findsOneWidget);
  }, variant: kPlatformVariant);

  testWidgets('Bottom navigation', variant: kPlatformVariant, (tester) async {
    final app = await makeTestProviderScope(tester, child: const Application());

    await tester.pumpWidget(app);

    expect(find.byType(MainTabScaffold), findsOneWidget);

    expect(find.text('Play'), findsOneWidget);
    expect(find.text('Puzzles'), findsOneWidget);
    expect(find.text('Learn'), findsOneWidget);
    expect(find.text('Watch'), findsOneWidget);
  });

  testWidgets("don't show signOut if no session", (WidgetTester tester) async {
    final app = await makeTestProviderScopeApp(tester, home: const Application());

    await tester.pumpWidget(app);
    // wait for the startup requests and animations to complete
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    await tester.tap(find.byIcon(Icons.account_circle_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Sign out'), findsNothing);
    expect(find.text('Sign in'), findsOneWidget);
  }, variant: kPlatformVariant);

  testWidgets('signout', (WidgetTester tester) async {
    final client = MockClient((request) {
      if (request.method == 'DELETE' && request.url.path == '/api/token') {
        return mockResponse('ok', 200);
      }
      return mockResponse('', 404);
    });

    final app = await makeTestProviderScopeApp(
      tester,
      home: const Application(),
      userSession: fakeSession,
      overrides: [lichessClientProvider.overrideWith((ref) => LichessClient(client, ref))],
    );

    await tester.pumpWidget(app);
    // wait for the startup requests and animations to complete
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    await tester.tap(find.byType(CircleAvatar));
    await tester.pumpAndSettle();

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

    // expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // wait for sign out future
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Sign out'), findsNothing);

    // if not logged in, there is no circle avatar
    expect(find.byType(CircleAvatar), findsNothing);
  }, variant: kPlatformVariant);

  testWidgets('language support', (tester) async {
    for (final locale in AppLocalizations.supportedLocales) {
      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        defaultPreferences: {
          PrefCategory.general.storageKey: jsonEncode(
            GeneralPrefs.defaults.copyWith(locale: locale).toJson(),
          ),
        },
        key: ValueKey('locale_$locale'),
      );

      await tester.pumpWidget(app);

      expect(find.byType(MaterialApp), findsOneWidget, reason: 'app loads with locale: $locale');

      // TODO find the reason why home does not load
      // expect(find.byType(HomeTabScreen), findsOneWidget, reason: 'app loads with locale: $locale');
    }
  }, variant: kPlatformVariant);
}
