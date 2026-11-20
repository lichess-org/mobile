import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/user/search_screen.dart';
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';
import 'package:lichess_mobile/src/widgets/user_list_tile.dart';
import 'package:material_ui/material_ui.dart';

import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

final requests = <http.BaseRequest>[];

final client = MockClient((request) {
  requests.add(request);
  if (request.url.path == '/api/player/autocomplete') {
    final term = request.url.queryParameters['term'];
    if (term == 'john') {
      return mockResponse(johnResponse, 200);
    }
    // Mirror the real server: short terms are rejected.
    if (term != null && term.length < 4) {
      return mockResponse('No search term provided', 400);
    }
    return mockResponse(emptyResponse, 200);
  }
  return mockResponse('', 404);
});

void main() {
  setUp(requests.clear);

  group('SearchScreen', () {
    testWidgets('should see search results', variant: kPlatformVariant, (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const SearchScreen(),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(client, ref),
          ),
        },
      );

      await tester.pumpWidget(app);

      await tester.enterText(
        find.descendant(of: find.byType(PlatformSearchBar), matching: find.byType(EditableText)),
        'john',
      );

      // await debouce call
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // await response
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Players with "john"'), findsOneWidget);
      expect(find.byType(UserListTile), findsNWidgets(2));
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('John Doe 2'), findsOneWidget);

      // await debouce call for saving search history
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets(
      'should not call autocomplete for terms shorter than 4 characters',
      variant: kPlatformVariant,
      (tester) async {
        final app = await makeTestProviderScopeApp(
          tester,
          home: const SearchScreen(),
          overrides: {
            lichessClientProvider: lichessClientProvider.overrideWith(
              (ref) => LichessClient(client, ref),
            ),
          },
        );

        await tester.pumpWidget(app);

        await tester.enterText(
          find.descendant(of: find.byType(PlatformSearchBar), matching: find.byType(EditableText)),
          'joh',
        );

        // await debouce call
        await tester.pump(const Duration(milliseconds: 300));

        // await response
        await tester.pumpAndSettle(const Duration(milliseconds: 100));

        expect(requests.where((r) => r.url.path == '/api/player/autocomplete'), isEmpty);
        expect(find.text('Players with "joh"'), findsNothing);
        expect(find.text('Could not load search results.'), findsNothing);

        // await debouce call for saving search history
        await tester.pump(const Duration(seconds: 2));
      },
    );

    testWidgets('should see "no result" when search finds nothing', variant: kPlatformVariant, (
      tester,
    ) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const SearchScreen(),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(client, ref),
          ),
        },
      );

      await tester.pumpWidget(app);

      await tester.enterText(
        find.descendant(of: find.byType(PlatformSearchBar), matching: find.byType(EditableText)),
        'johnny',
      );
      // await debouce call
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // await response
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      expect(find.text('Players with "johnny"'), findsNothing);
      expect(find.text('No results'), findsOneWidget);

      // await debouce call for saving search history
      await tester.pump(const Duration(seconds: 2));
    });
  });
}

const johnResponse = '''
{
    "result": [
        {
            "id": "johndoe1",
            "name": "John Doe"
        },
        {
            "id": "johndoe2",
            "name": "John Doe 2"
        }
    ]
}
''';

const emptyResponse = '''
{
    "result": []
}
''';
