import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/app.dart';
import 'package:lichess_mobile/src/home_widget_service.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';

import 'model/auth/fake_auth_storage.dart';
import 'model/home_widget/fake_home_widget_client.dart';
import 'test_helpers.dart';
import 'test_provider_scope.dart';

void main() {
  group('resolveQuickPairingHomeWidgetSeek', () {
    test('uses most recent seek when available', () {
      const recentSeek = GameSeek(
        clock: (Duration(minutes: 3), Duration(seconds: 2)),
        rated: true,
        variant: Variant.chess960,
      );

      final resolvedSeek = resolveQuickPairingHomeWidgetSeek(
        recentGameSeekPrefs: const RecentGameSeekPrefs(seeks: IListConst([recentSeek])),
        authUser: fakeAuthUser,
      );

      expect(resolvedSeek, recentSeek);
    });

    test('falls back to 5+0 when there is no recent seek', () {
      final resolvedSeek = resolveQuickPairingHomeWidgetSeek(
        recentGameSeekPrefs: RecentGameSeekPrefs.empty,
        authUser: fakeAuthUser,
      );

      expect(resolvedSeek.timeIncrement?.display, '5+0');
      expect(resolvedSeek.rated, true);
      expect(resolvedSeek.variant, isNull);
    });

    test('downgrades rated recent seek to casual when logged out', () {
      final resolvedSeek = resolveQuickPairingHomeWidgetSeek(
        recentGameSeekPrefs: const RecentGameSeekPrefs(
          seeks: IListConst([GameSeek(clock: (Duration(minutes: 1), Duration.zero), rated: true)]),
        ),
        authUser: null,
      );

      expect(resolvedSeek.rated, false);
      expect(resolvedSeek.timeIncrement?.display, '1+0');
    });
  });

  group('HomeWidgetService integration', () {
    testWidgets('cold start widget launch opens GameScreen', (tester) async {
      final fakeHomeWidgetClient = FakeHomeWidgetClient()
        ..initialLaunchUri = Uri.parse(kQuickPairingHomeWidgetLaunchUri);
      addTearDown(fakeHomeWidgetClient.dispose);

      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        authUser: fakeAuthUser,
        overrides: {
          homeWidgetClientProvider: homeWidgetClientProvider.overrideWithValue(
            fakeHomeWidgetClient,
          ),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.byType(GameScreen), findsOneWidget);
    }, variant: kPlatformVariant);

    testWidgets('warm start widget click opens GameScreen', (tester) async {
      final fakeHomeWidgetClient = FakeHomeWidgetClient();
      addTearDown(fakeHomeWidgetClient.dispose);

      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        authUser: fakeAuthUser,
        overrides: {
          homeWidgetClientProvider: homeWidgetClientProvider.overrideWithValue(
            fakeHomeWidgetClient,
          ),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.byType(GameScreen), findsNothing);

      fakeHomeWidgetClient.emitClick(Uri.parse(kQuickPairingHomeWidgetLaunchUri));
      await tester.pumpAndSettle();

      expect(find.byType(GameScreen), findsOneWidget);
    }, variant: kPlatformVariant);

    testWidgets('syncs widget payload and updates when recent seek changes', (tester) async {
      final fakeHomeWidgetClient = FakeHomeWidgetClient();
      addTearDown(fakeHomeWidgetClient.dispose);

      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        authUser: fakeAuthUser,
        overrides: {
          homeWidgetClientProvider: homeWidgetClientProvider.overrideWithValue(
            fakeHomeWidgetClient,
          ),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(fakeHomeWidgetClient.savedData[kQuickPairingHomeWidgetTitleKey], 'Quick pairing');
      expect(fakeHomeWidgetClient.savedData[kQuickPairingHomeWidgetPrimaryTextKey], '5+0');
      expect(fakeHomeWidgetClient.savedData[kQuickPairingHomeWidgetSecondaryTextKey], 'Rated');
      expect(
        fakeHomeWidgetClient.savedData[kQuickPairingHomeWidgetLaunchUriKey],
        kQuickPairingHomeWidgetLaunchUri,
      );
      expect(fakeHomeWidgetClient.updateWidgetCalls, 1);

      final container = ProviderScope.containerOf(tester.element(find.byType(Application)));
      await container
          .read(recentGameSeekProvider.notifier)
          .addSeek(
            const GameSeek(
              clock: (Duration(minutes: 3), Duration(seconds: 2)),
              rated: true,
              variant: Variant.chess960,
            ),
          );

      await tester.pumpAndSettle();

      expect(fakeHomeWidgetClient.savedData[kQuickPairingHomeWidgetPrimaryTextKey], '3+2');
      expect(
        fakeHomeWidgetClient.savedData[kQuickPairingHomeWidgetSecondaryTextKey],
        'Rated • 960',
      );
      expect(fakeHomeWidgetClient.updateWidgetCalls, greaterThanOrEqualTo(2));
    }, variant: kPlatformVariant);

    testWidgets('logged out payload downgrades rated recent seek to casual', (tester) async {
      final fakeHomeWidgetClient = FakeHomeWidgetClient();
      addTearDown(fakeHomeWidgetClient.dispose);

      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        defaultPreferences: {
          PrefCategory.gameSeeks.storageKey: jsonEncode(
            const RecentGameSeekPrefs(
              seeks: IListConst([
                GameSeek(clock: (Duration(minutes: 3), Duration(seconds: 2)), rated: true),
              ]),
            ).toJson(),
          ),
        },
        overrides: {
          homeWidgetClientProvider: homeWidgetClientProvider.overrideWithValue(
            fakeHomeWidgetClient,
          ),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(fakeHomeWidgetClient.savedData[kQuickPairingHomeWidgetSecondaryTextKey], 'Casual');
    }, variant: kPlatformVariant);
  });
}
