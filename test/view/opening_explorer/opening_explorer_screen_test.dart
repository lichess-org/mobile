import 'dart:convert';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer_preferences.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/opening_explorer/opening_explorer_screen.dart';

import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

void main() {
  // final explorerViewFinder = find.descendant(
  //   of: find.byType(LayoutBuilder),
  //   matching: find.byType(Scrollable),
  // );

  final mockClient = MockClient((request) {
    if (request.url.host == 'explorer.lichess.ovh') {
      if (request.url.path == '/masters') {
        return mockResponse(mastersOpeningExplorerResponse, 200);
      }
      if (request.url.path == '/lichess') {
        return mockResponse(lichessOpeningExplorerResponse, 200);
      }
      if (request.url.path == '/player') {
        return mockResponse(playerOpeningExplorerResponse, 200);
      }
    }
    return mockResponse('', 404);
  });

  const options = AnalysisOptions(
    id: standaloneOpeningExplorerId,
    isLocalEvaluationAllowed: false,
    orientation: Side.white,
    variant: Variant.standard,
  );

  const name = 'John';

  final user = LightUser(
    id: UserId.fromUserName(name),
    name: name,
  );

  final session = AuthSessionState(
    user: user,
    token: 'test-token',
  );

  group('OpeningExplorerScreen', () {
    testWidgets(
      'master opening explorer loads',
      (WidgetTester tester) async {
        final app = await makeTestProviderScopeApp(
          tester,
          home: const OpeningExplorerScreen(
            pgn: '',
            options: options,
          ),
          overrides: [
            defaultClientProvider.overrideWithValue(mockClient),
          ],
        );
        await tester.pumpWidget(app);

        // wait for opening explorer data to load (taking debounce delay into account)
        await tester.pump(const Duration(milliseconds: 350));

        final moves = [
          'e4',
          'd4',
        ];
        expect(find.byType(Table), findsOneWidget);
        for (final move in moves) {
          expect(find.widgetWithText(TableRowInkWell, move), findsOneWidget);
        }

        expect(find.widgetWithText(Container, 'Top games'), findsOneWidget);
        expect(find.widgetWithText(Container, 'Recent games'), findsNothing);

        // TODO: make a custom scrollUntilVisible that works with the non-scrollable
        // board widget

        // await tester.scrollUntilVisible(
        //   find.text('Firouzja, A.'),
        //   200,
        //   scrollable: explorerViewFinder,
        // );

        // expect(
        //   find.byType(OpeningExplorerGameTile),
        //   findsNWidgets(2),
        // );
      },
      variant: kPlatformVariant,
    );

    testWidgets(
      'lichess opening explorer loads',
      (WidgetTester tester) async {
        final app = await makeTestProviderScopeApp(
          tester,
          home: const OpeningExplorerScreen(
            pgn: '',
            options: options,
          ),
          overrides: [
            defaultClientProvider.overrideWithValue(mockClient),
          ],
          defaultPreferences: {
            SessionPreferencesStorage.key(
              PrefCategory.openingExplorer.storageKey,
              null,
            ): jsonEncode(
              OpeningExplorerPrefs.defaults()
                  .copyWith(db: OpeningDatabase.lichess)
                  .toJson(),
            ),
          },
        );
        await tester.pumpWidget(app);

        // wait for opening explorer data to load (taking debounce delay into account)
        await tester.pump(const Duration(milliseconds: 350));

        final moves = [
          'd4',
        ];
        expect(find.byType(Table), findsOneWidget);
        for (final move in moves) {
          expect(find.widgetWithText(TableRowInkWell, move), findsOneWidget);
        }

        expect(find.widgetWithText(Container, 'Top games'), findsNothing);
        expect(find.widgetWithText(Container, 'Recent games'), findsOneWidget);

        // await tester.scrollUntilVisible(
        //   find.byType(OpeningExplorerGameTile),
        //   200,
        //   scrollable: explorerViewFinder,
        // );

        // expect(
        //   find.byType(OpeningExplorerGameTile),
        //   findsOneWidget,
        // );
      },
      variant: kPlatformVariant,
    );

    testWidgets(
      'player opening explorer loads',
      (WidgetTester tester) async {
        final app = await makeTestProviderScopeApp(
          tester,
          home: const OpeningExplorerScreen(
            pgn: '',
            options: options,
          ),
          overrides: [
            defaultClientProvider.overrideWithValue(mockClient),
          ],
          userSession: session,
          defaultPreferences: {
            SessionPreferencesStorage.key(
              PrefCategory.openingExplorer.storageKey,
              session,
            ): jsonEncode(
              OpeningExplorerPrefs.defaults(user: user)
                  .copyWith(db: OpeningDatabase.player)
                  .toJson(),
            ),
          },
        );
        await tester.pumpWidget(app);

        // wait for opening explorer data to load (taking debounce delay into account)
        await tester.pump(const Duration(milliseconds: 350));

        final moves = [
          'c4',
        ];
        expect(find.byType(Table), findsOneWidget);
        for (final move in moves) {
          expect(find.widgetWithText(TableRowInkWell, move), findsOneWidget);
        }

        expect(find.widgetWithText(Container, 'Top games'), findsNothing);
        expect(find.widgetWithText(Container, 'Recent games'), findsOneWidget);

        // await tester.scrollUntilVisible(
        //   find.byType(OpeningExplorerGameTile),
        //   200,
        //   scrollable: explorerViewFinder,
        // );

        // expect(
        //   find.byType(OpeningExplorerGameTile),
        //   findsOneWidget,
        // );
      },
      variant: kPlatformVariant,
    );
  });
}

const mastersOpeningExplorerResponse = '''
{
  "white": 834333,
  "draws": 1085272,
  "black": 600303,
  "moves": [
    {
      "uci": "e2e4",
      "san": "e4",
      "averageRating": 2399,
      "white": 372266,
      "draws": 486092,
      "black": 280238,
      "game": null
    },
    {
      "uci": "d2d4",
      "san": "d4",
      "averageRating": 2414,
      "white": 302160,
      "draws": 397224,
      "black": 209077,
      "game": null
    }
  ],
  "topGames": [
    {
      "uci": "d2d4",
      "id": "QR5UbqUY",
      "winner": null,
      "black": {
        "name": "Caruana, F.",
        "rating": 2818
      },
      "white": {
        "name": "Carlsen, M.",
        "rating": 2882
      },
      "year": 2019,
      "month": "2019-08"
    },
    {
      "uci": "e2e4",
      "id": "Sxov6E94",
      "winner": "white",
      "black": {
        "name": "Carlsen, M.",
        "rating": 2882
      },
      "white": {
        "name": "Firouzja, A.",
        "rating": 2808
      },
      "year": 2019,
      "month": "2019-08"
    }
  ],
  "opening": null
}
''';

const lichessOpeningExplorerResponse = '''
{
  "white": 2848672002,
  "draws": 225287646,
  "black": 2649860106,
  "moves": [
    {
      "uci": "d2d4",
      "san": "d4",
      "averageRating": 1604,
      "white": 1661457614,
      "draws": 129433754,
      "black": 1565161663,
      "game": null
    }
  ],
  "recentGames": [
    {
      "uci": "e2e4",
      "id": "RVb19S9O",
      "winner": "white",
      "speed": "rapid",
      "mode": "rated",
      "black": {
        "name": "Jcats1",
        "rating": 1548
      },
      "white": {
        "name": "carlosrivero32",
        "rating": 1690
      },
      "year": 2024,
      "month": "2024-06"
    }
  ],
  "topGames": [],
  "opening": null
}
''';

const playerOpeningExplorerResponse = '''
{
  "white": 1713,
  "draws": 119,
  "black": 1459,
  "moves": [
    {
      "uci": "c2c4",
      "san": "c4",
      "averageOpponentRating": 1767,
      "performance": 1796,
      "white": 1691,
      "draws": 116,
      "black": 1432,
      "game": null
    }
  ],
  "recentGames": [
    {
      "uci": "e2e4",
      "id": "RVb19S9O",
      "winner": "white",
      "speed": "bullet",
      "mode": "rated",
      "black": {
        "name": "foo",
        "rating": 1869
      },
      "white": {
        "name": "baz",
        "rating": 1912
      },
      "year": 2023,
      "month": "2023-08"
    }
  ],
  "opening": null,
  "queuePosition": 0
}
''';
