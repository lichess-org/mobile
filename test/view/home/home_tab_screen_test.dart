import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/app.dart';
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/nnue_service.dart';
import 'package:lichess_mobile/src/model/game/game_storage.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/view/account/profile_screen.dart';
import 'package:lichess_mobile/src/view/auth/email_login_screen.dart';
import 'package:lichess_mobile/src/view/game/game_list_tile.dart';
import 'package:lichess_mobile/src/view/home/games_carousel.dart';
import 'package:lichess_mobile/src/view/home/home_tab_screen.dart';
import 'package:lichess_mobile/src/view/play/quick_game_matrix.dart';
import 'package:lichess_mobile/src/view/tournament/tournament_list_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/server_outage_display.dart';
import 'package:material_ui/material_ui.dart';

import '../../binding.dart';
import '../../example_data.dart';
import '../../mock_server_responses.dart';
import '../../model/auth/auth_repository_test.dart';
import '../../model/auth/fake_auth_storage.dart';
import '../../model/challenge/challenge_repository_test.dart';
import '../../model/engine/fake_nnue_service.dart';
import '../../network/fake_http_client_factory.dart';
import '../../network/server_down_client.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

void main() {
  group('Home online', () {
    testWidgets('shows Play button', (tester) async {
      final app = await makeTestProviderScope(tester, child: const Application());
      await tester.pumpWidget(app);

      // wait for connectivity
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('shows challenge button if has challenges', (tester) async {
      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        authUser: fakeAuthUser,
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(
              () => MockClient((request) {
                if (request.url.path == '/api/challenge') {
                  return mockResponse(challengesList, 200);
                }
                if (request.url.path == '/tournament/featured') {
                  return mockResponse('{"featured":[]}', 200);
                }
                return mockResponse('', 200);
              }),
            ),
          ),
        },
      );
      await tester.pumpWidget(app);

      // wait for connectivity
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump();

      // wait for challenge list to load
      await tester.pump();

      expect(
        tester
            .widget<SemanticIconButton>(
              find.ancestor(
                of: find.byIcon(LichessIcons.crossed_swords),
                matching: find.byType(SemanticIconButton),
              ),
            )
            .onPressed,
        isNotNull,
      );
    });

    testWidgets('no authUser, no stored game: shows welcome screen ', (tester) async {
      final app = await makeTestProviderScope(tester, child: const Application());
      await tester.pumpWidget(app);
      // wait for connectivity
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();

      expect(
        find.textContaining('libre, no-ads, open source chess server.', findRichText: true),
        findsOneWidget,
      );
      expect(find.text('Sign in'), findsOneWidget);
      expect(find.text('About Lichess...'), findsOneWidget);
    });

    testWidgets('authUser, no played game: do not show welcome screen', (tester) async {
      int nbUserGamesRequests = 0;
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/games/user/testuser') {
          nbUserGamesRequests++;
          return mockResponse('', 200);
        }
        if (request.url.path == '/tournament/featured') {
          return mockResponse('{"featured":[]}', 200);
        }
        return mockResponse('', 200);
      });
      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        authUser: fakeAuthUser,
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(() => mockClient),
          ),
        },
      );
      await tester.pumpWidget(app);
      // wait for connectivity
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();

      expect(nbUserGamesRequests, 1);
      expect(find.text('Sign in'), findsNothing);
      expect(find.text('About Lichess...'), findsNothing);
    });

    testWidgets('no authUser, with stored games: shows list of recent games', (tester) async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/tournament/featured') {
          return mockResponse('{"featured":[]}', 200);
        }
        return mockResponse('', 200);
      });
      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(() => mockClient),
          ),
        },
      );
      await tester.pumpWidget(app);

      final container = ProviderScope.containerOf(tester.element(find.byType(Application)));
      final storage = await container.read(gameStorageProvider.future);
      final games = generateExportedGames(count: 3);
      for (final game in games) {
        await storage.save(game);
      }

      // wait for connectivity
      await tester.pumpAndSettle();

      expect(find.text('About Lichess...'), findsNothing);
      expect(find.text('Recent games'), findsOneWidget);
      expect(find.byType(GameListTile), findsNWidgets(3));
      expect(find.text('Anonymous'), findsNWidgets(3));
    });

    testWidgets('authUser, with played games: shows recent games', (tester) async {
      int nbUserGamesRequests = 0;
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/games/user/testuser') {
          nbUserGamesRequests++;
          return mockResponse(mockUserRecentGameResponse('testUser'), 200);
        }
        if (request.url.path == '/tournament/featured') {
          return mockResponse('{"featured":[]}', 200);
        }
        return mockResponse('', 200);
      });
      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        authUser: fakeAuthUser,
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(() => mockClient),
          ),
        },
      );
      await tester.pumpWidget(app);
      // wait for connectivity
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();

      expect(nbUserGamesRequests, 1);
      expect(find.text('About Lichess...'), findsNothing);
      expect(find.text('Recent games'), findsOneWidget);
      expect(find.byType(GameListTile), findsNWidgets(3));
      expect(find.text('MightyNanook'), findsOneWidget);
    });

    testWidgets('shows ongoing games if any', (tester) async {
      int nbOngoingGamesRequests = 0;
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/account/playing') {
          nbOngoingGamesRequests++;
          return mockResponse(mockAccountOngoingGamesResponse(), 200);
        }
        if (request.url.path == '/tournament/featured') {
          return mockResponse('{"featured":[]}', 200);
        }
        return mockResponse('', 200);
      });
      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        authUser: fakeAuthUser,
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(() => mockClient),
          ),
        },
      );
      await tester.pumpWidget(app);
      // wait for connectivity
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();

      expect(nbOngoingGamesRequests, 1);
      expect(find.text('About Lichess...'), findsNothing);
      expect(find.text('Recent games'), findsNothing);
      expect(find.text('1 game in play'), findsOneWidget);
      expect(find.byType(OngoingGameCarouselItem), findsOneWidget);
    });

    group('home widgets edit mode', () {
      testWidgets('featured tournaments checkbox is hidden when there are none to show', (
        tester,
      ) async {
        final mockClient = MockClient((request) {
          if (request.url.path == '/tournament/featured') {
            return mockResponse('{"featured":[]}', 200);
          }
          return mockResponse('', 200);
        });
        final app = await makeTestProviderScope(
          tester,
          child: const Application(),
          defaultPreferences: {kWelcomeMessageShownKey: true},
          overrides: {
            httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
              (ref) => FakeHttpClientFactory(() => mockClient),
            ),
          },
        );
        await tester.pumpWidget(app);

        // wait for connectivity
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Customize'));
        await tester.pumpAndSettle(); // wait for settings screen to open

        expect(find.widgetWithText(PlatformAppBar, 'Home widgets'), findsOneWidget);
        expect(find.byType(FeaturedTournamentsWidget), findsNothing);
      });

      testWidgets('featured tournaments checkbox is shown when there are some to show', (
        tester,
      ) async {
        final mockClient = MockClient((request) {
          if (request.url.path == '/tournament/featured') {
            return mockResponse(mockFeaturedTournamentsResponse, 200);
          }
          return mockResponse('', 200);
        });
        final app = await makeTestProviderScope(
          tester,
          child: const Application(),
          defaultPreferences: {kWelcomeMessageShownKey: true},
          overrides: {
            httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
              (ref) => FakeHttpClientFactory(() => mockClient),
            ),
          },
        );
        await tester.pumpWidget(app);

        // wait for connectivity
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Customize'));
        await tester.pumpAndSettle(); // wait for settings screen to open

        expect(find.widgetWithText(PlatformAppBar, 'Home widgets'), findsOneWidget);
        expect(find.byType(FeaturedTournamentsWidget), findsOneWidget);
        expect(find.text('Open tournaments'), findsOneWidget);
      });
    });
  });

  group('Home offline', () {
    testWidgets('shows offline banner', (tester) async {
      final app = await makeOfflineTestProviderScope(tester, child: const Application());

      await tester.pumpWidget(app);
      // wait for connectivity
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump();

      expect(find.byType(OfflineBanner), findsOneWidget);
    });

    testWidgets('shows Play button', (tester) async {
      final app = await makeOfflineTestProviderScope(tester, child: const Application());

      await tester.pumpWidget(app);

      // wait for connectivity
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('no authUser, no stored game: shows welcome screen ', (tester) async {
      final app = await makeTestProviderScope(tester, child: const Application());
      await tester.pumpWidget(app);
      // wait for connectivity
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();

      expect(
        find.textContaining('libre, no-ads, open source chess server.', findRichText: true),
        findsOneWidget,
      );
      expect(find.text('Sign in'), findsOneWidget);
      expect(find.text('About Lichess...'), findsOneWidget);
    });

    testWidgets('no authUser, with stored games: shows list of recent games', (tester) async {
      final app = await makeOfflineTestProviderScope(tester, child: const Application());
      await tester.pumpWidget(app);

      final container = ProviderScope.containerOf(tester.element(find.byType(Application)));
      final storage = await container.read(gameStorageProvider.future);
      final games = generateExportedGames(count: 3);
      for (final game in games) {
        await storage.save(game);
      }

      // wait for connectivity
      await tester.pumpAndSettle();

      expect(find.text('About Lichess...'), findsNothing);
      expect(find.text('Recent games'), findsOneWidget);
      expect(find.byType(GameListTile), findsNWidgets(3));
      expect(find.text('Anonymous'), findsNWidgets(3));
    });

    testWidgets('authUser, with stored games: shows list of recent games', (tester) async {
      final app = await makeOfflineTestProviderScope(
        tester,
        child: const Application(),
        authUser: fakeAuthUser,
      );
      await tester.pumpWidget(app);

      final container = ProviderScope.containerOf(tester.element(find.byType(Application)));
      final storage = await container.read(gameStorageProvider.future);
      final games = generateExportedGames(count: 3, username: 'testUser');
      for (final game in games) {
        await storage.save(game);
      }

      // wait for connectivity
      await tester.pumpAndSettle();

      expect(find.text('About Lichess...'), findsNothing);
      expect(find.text('Recent games'), findsOneWidget);
      expect(find.byType(GameListTile), findsNWidgets(3));
    });

    group('home customization tip', () {
      const customizeTip =
          "Tip: You can add more widgets to the Home Screen or remove those you don't need!";
      testWidgets('shown when logged out', (tester) async {
        final app = await makeTestProviderScope(tester, child: const Application());

        await tester.pumpWidget(app);

        // wait for connectivity
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pump();

        expect(find.text(customizeTip), findsOneWidget);
      });

      testWidgets('shown when logged in', (tester) async {
        final app = await makeTestProviderScope(
          tester,
          child: const Application(),
          authUser: fakeAuthUser,
        );

        await tester.pumpWidget(app);

        // wait for connectivity
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pump();

        expect(find.text(customizeTip), findsOneWidget);
      });

      testWidgets('Can be dismissed via button', (tester) async {
        final app = await makeTestProviderScope(
          tester,
          child: const Application(),
          defaultPreferences: {kWelcomeMessageShownKey: true},
        );

        await tester.pumpWidget(app);

        // wait for connectivity
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pump();

        expect(find.text(customizeTip), findsOneWidget);
        await tester.tap(find.text('Dismiss'));
        await tester.pumpAndSettle(); // wait for tip widget to be removed
        expect(find.text(customizeTip), findsNothing);
      });

      testWidgets('Not shown if already dismissed', (tester) async {
        final app = await makeTestProviderScope(tester, child: const Application());

        TestLichessBinding.instance.sharedPreferences.setBool(
          'app_hide_home_widget_customization_tip',
          true,
        );

        await tester.pumpWidget(app);

        // wait for connectivity
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pump();

        expect(find.text(customizeTip), findsNothing);
      });

      testWidgets('Can be dismissed via going to settings', (tester) async {
        final app = await makeTestProviderScope(
          tester,
          child: const Application(),
          defaultPreferences: {kWelcomeMessageShownKey: true},
        );

        await tester.pumpWidget(app);

        // wait for connectivity
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pump();

        expect(find.text(customizeTip), findsOneWidget);

        await tester.tap(find.text('Customize'));
        await tester.pumpAndSettle(); // wait for settings screen to open

        expect(find.widgetWithText(PlatformAppBar, 'Home widgets'), findsOneWidget);

        await tester.tap(find.widgetWithText(TextButton, 'OK'));
        await tester.pumpAndSettle(); // wait for home screen to re-appear

        expect(find.byIcon(LichessIcons.logo_lichess), findsOneWidget); // we're back on home

        expect(find.text(customizeTip), findsNothing);
      });

      testWidgets('Not shown when > $kColdAppStartsHideCustomizationTipThreshold app starts', (
        tester,
      ) async {
        final app = await makeTestProviderScope(tester, child: const Application());

        TestLichessBinding.instance.numAppStarts = kColdAppStartsHideCustomizationTipThreshold + 1;

        await tester.pumpWidget(app);

        // wait for connectivity
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pump();

        expect(find.text(customizeTip), findsNothing);
      });
    });

    group('NNUE files missing tip', () {
      const nnueFilesMissingTip =
          'New Stockfish version available! Go to the settings to download the updated NNUE files.';
      testWidgets('Shown if engine pref is latest sf and NNUE files are missing', (tester) async {
        final app = await makeTestProviderScope(
          tester,
          overrides: {
            nnueServiceProvider: nnueServiceProvider.overrideWithValue(
              FakeNnueServiceUnavailable(),
            ),
          },
          authUser: fakeAuthUser,
          defaultPreferences: {
            PrefCategory.engineEvaluation.storageKey: jsonEncode(
              EngineEvaluationPrefState.defaults
                  .copyWith(enginePref: ChessEnginePref.sfLatest)
                  .toJson(),
            ),
          },
          child: const Application(),
        );

        await tester.pumpWidget(app);

        // Wait for hasOutdatedNNUEFiles() future to complete
        await tester.pumpAndSettle();

        expect(find.text(nnueFilesMissingTip), findsOneWidget);
      });

      testWidgets('Not shown if nnue files are available', (tester) async {
        final app = await makeTestProviderScope(
          tester,
          overrides: {
            nnueServiceProvider: nnueServiceProvider.overrideWithValue(FakeNnueService()),
          },
          authUser: fakeAuthUser,
          defaultPreferences: {
            PrefCategory.engineEvaluation.storageKey: jsonEncode(
              EngineEvaluationPrefState.defaults
                  .copyWith(enginePref: ChessEnginePref.sfLatest)
                  .toJson(),
            ),
          },
          child: const Application(),
        );

        await tester.pumpWidget(app);

        // Wait for hasOutdatedNNUEFiles() future to complete
        await tester.pumpAndSettle();

        expect(find.text(nnueFilesMissingTip), findsNothing);
      });

      testWidgets('Not shown if engine pref is sf16', (tester) async {
        final app = await makeTestProviderScope(
          tester,
          overrides: {
            nnueServiceProvider: nnueServiceProvider.overrideWithValue(
              FakeNnueServiceUnavailable(),
            ),
          },
          authUser: fakeAuthUser,
          defaultPreferences: {
            PrefCategory.engineEvaluation.storageKey: jsonEncode(
              EngineEvaluationPrefState.defaults
                  .copyWith(enginePref: ChessEnginePref.sf16)
                  .toJson(),
            ),
          },
          child: const Application(),
        );

        await tester.pumpWidget(app);

        // Wait for hasOutdatedNNUEFiles() future to complete
        await tester.pumpAndSettle();

        expect(find.text(nnueFilesMissingTip), findsNothing);
      });
    });
  });
  group('Server offline', () {
    testWidgets('offline-capable widgets are kept, server-backed ones are replaced', (
      tester,
    ) async {
      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        authUser: fakeAuthUser,
        // Tall surface so the whole list is laid out and nothing is missed
        // simply for being below the fold.
        surfaceSize: const Size(390, 1600),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => serverDownClient());
          }),
        },
      );
      await tester.pumpWidget(app);

      final container = ProviderScope.containerOf(tester.element(find.byType(Application)));
      final storage = await container.read(gameStorageProvider.future);
      for (final game in generateExportedGames(count: 3, username: 'testUser')) {
        await storage.save(game);
      }

      await tester.pumpAndSettle();

      // The outage message replaces the widgets that need the server...
      expect(find.byType(ServerOutageDisplay), findsOneWidget);
      expect(find.byType(QuickGameMatrix), findsNothing);
      expect(find.byType(AccountPerfCards), findsNothing);

      // ...but the locally stored games are still listed below it.
      expect(find.text('Recent games'), findsOneWidget);
      expect(find.byType(GameListTile), findsNWidgets(3));
    });

    testWidgets('outage page shown and Play button still accessible', (tester) async {
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

      expect(find.byType(ServerOutageDisplay), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('a 502 shows the outage message', (tester) async {
      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => serverDownClient(statusCode: 502));
          }),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.textContaining('Lichess is down'), findsOneWidget);
      expect(find.textContaining('scheduled maintenance'), findsNothing);
      // The website shows this drawing on its outage page; mirror that.
      expect(imageAssetNames(tester), contains('assets/images/maintenance.webp'));
    });

    testWidgets('a 503 shows the maintenance message', (tester) async {
      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => serverDownClient(statusCode: 503));
          }),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.textContaining('scheduled maintenance'), findsOneWidget);
      expect(find.textContaining('Lichess is down'), findsNothing);
      // The website's maintenance page has no drawing, only the logo.
      expect(imageAssetNames(tester), isNot(contains('assets/images/maintenance.webp')));
    });
  });

  group('Sign in options', () {
    testWidgets('opens the email login screen', (tester) async {
      final app = await makeTestProviderScope(tester, child: const Application());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign in with an email'));
      await tester.pumpAndSettle();

      expect(find.byType(EmailLoginScreen), findsOneWidget);
    });
  });

  group('Sign in error handling', () {
    testWidgets('shows an error snackbar when sign-in fails', (tester) async {
      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        overrides: {
          appAuthProvider: appAuthProvider.overrideWith(
            (ref) => FakeFlutterAppAuth((request) async => throw Exception('authorization failed')),
          ),
        },
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.text('Sign in'), findsOneWidget);

      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign in with the browser'));
      await tester.pumpAndSettle();

      expect(find.text('Something went wrong.'), findsOneWidget);
    });

    testWidgets('does not show a snackbar when the user cancels sign-in', (tester) async {
      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        overrides: {
          appAuthProvider: appAuthProvider.overrideWith(
            (ref) => FakeFlutterAppAuth((request) async => throw userCancelled()),
          ),
        },
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.text('Sign in'), findsOneWidget);

      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign in with the browser'));
      await tester.pumpAndSettle();

      expect(find.text('Something went wrong.'), findsNothing);
    });
  });
}
