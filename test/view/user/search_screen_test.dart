import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/user/search_screen.dart';
import 'package:lichess_mobile/src/widgets/user_list_tile.dart';

import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

final client = MockClient((request) {
  if (request.url.path == '/api/player/autocomplete') {
    if (request.url.queryParameters['term'] == 'joh') {
      return mockResponse(johResponse, 200);
    }
    return mockResponse(emptyResponse, 200);
  }
  return mockResponse('', 404);
});

void main() {
  group('SearchScreen', () {
    testWidgets('should see search results', variant: kPlatformVariant, (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const SearchScreen(),
        overrides: [lichessClientProvider.overrideWith((ref) => LichessClient(client, ref))],
      );

      await tester.pumpWidget(app);

      final textFieldFinder =
          debugDefaultTargetPlatformOverride == TargetPlatform.iOS
              ? find.byType(CupertinoSearchTextField)
              : find.byType(SearchBar);

      await tester.enterText(textFieldFinder, 'joh');

      // await debouce call
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // await response
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Players with "joh"'), findsOneWidget);
      expect(find.byType(UserListTile), findsNWidgets(2));
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('John Doe 2'), findsOneWidget);

      // await debouce call for saving search history
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('should see "no result" when search finds nothing', variant: kPlatformVariant, (
      tester,
    ) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const SearchScreen(),
        overrides: [lichessClientProvider.overrideWith((ref) => LichessClient(client, ref))],
      );

      await tester.pumpWidget(app);

      final textFieldFinder =
          debugDefaultTargetPlatformOverride == TargetPlatform.iOS
              ? find.byType(CupertinoSearchTextField)
              : find.byType(SearchBar);

      await tester.enterText(textFieldFinder, 'johnny');
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

const johResponse = '''
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
