import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/app.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/model/study/pinned_studies.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/learn/pinned_studies_section.dart';
import 'package:lichess_mobile/src/widgets/server_outage_display.dart';

import '../../model/auth/fake_auth_storage.dart';
import '../../network/fake_http_client_factory.dart';
import '../../network/server_down_client.dart';
import '../../test_provider_scope.dart';

void main() {
  group('Learn tab', () {
    testWidgets('shows the studies when the server is up', (tester) async {
      final app = await makeTestProviderScope(tester, child: const Application());

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Learn'));
      await tester.pumpAndSettle();

      expect(find.text('Coordinate training'), findsOneWidget);
      expect(find.text('Study'), findsOneWidget);
      expect(find.byType(ServerOutageDisplay), findsNothing);
    });

    testWidgets('outage replaces the studies but keeps coordinate training', (tester) async {
      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => serverDownClient());
          }),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Learn'));
      await tester.pumpAndSettle();

      expect(find.byType(ServerOutageDisplay), findsOneWidget);
      // The study section is gone...
      expect(find.text('Study'), findsNothing);
      // ...but coordinate training and practice work offline and stay available.
      expect(find.text('Coordinate training'), findsOneWidget);
      expect(find.text('Practice'), findsOneWidget);
    });

    testWidgets('pulling to refresh once the server is back restores the studies', (tester) async {
      var statusCode = 502;
      final client = serverDownClientWithStatus(() => statusCode);

      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => client);
          }),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Learn'));
      await tester.pumpAndSettle();

      expect(find.byType(ServerOutageDisplay), findsOneWidget);

      // The server comes back up.
      statusCode = 200;

      await tester.fling(find.text('Coordinate training'), const Offset(0.0, 300.0), 1000.0);
      await tester.pumpAndSettle();

      expect(find.byType(ServerOutageDisplay), findsNothing);
      expect(find.text('Coordinate training'), findsOneWidget);
    });
  });

  group('Pinned studies', () {
    final pinnedStudiesPrefs = {
      SessionPreferencesStorage.key(PrefCategory.pinnedStudies.storageKey, null): jsonEncode(
        const PinnedStudies(
          studies: IListConst([
            PinnedStudy(
              id: StudyId('abc'),
              name: 'My repertoire',
              chapterCount: 3,
              lastChapterId: StudyChapterId('ch2'),
            ),
          ]),
        ).toJson(),
      ),
    };

    testWidgets('hidden when no study is pinned', (tester) async {
      final app = await makeTestProviderScope(tester, child: const Application());

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Learn'));
      await tester.pumpAndSettle();

      expect(find.byType(PinnedStudiesSection), findsOneWidget);
      expect(find.text('Pinned studies'), findsNothing);
    });

    testWidgets('shows pinned studies and can unpin them', (tester) async {
      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        defaultPreferences: pinnedStudiesPrefs,
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Learn'));
      await tester.pumpAndSettle();

      expect(find.text('Pinned studies'), findsOneWidget);
      expect(find.text('My repertoire'), findsOneWidget);
      expect(find.text('3 Chapters'), findsOneWidget);

      await tester.longPress(find.text('My repertoire'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Unpin study'));
      await tester.pumpAndSettle();

      expect(find.text('Pinned studies'), findsNothing);
      expect(find.text('My repertoire'), findsNothing);
    });

    testWidgets('pinned studies are stored per account', (tester) async {
      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        authUser: fakeAuthUser,
        // pinned while logged out
        defaultPreferences: pinnedStudiesPrefs,
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Learn'));
      await tester.pumpAndSettle();

      expect(find.text('My repertoire'), findsNothing);
    });

    testWidgets('hidden when the server is unavailable', (tester) async {
      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        defaultPreferences: pinnedStudiesPrefs,
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => serverDownClient());
          }),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Learn'));
      await tester.pumpAndSettle();

      expect(find.byType(ServerOutageDisplay), findsOneWidget);
      expect(find.text('My repertoire'), findsNothing);
    });
  });
}
