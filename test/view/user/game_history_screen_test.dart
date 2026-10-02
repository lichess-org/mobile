import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/user/game_history_screen.dart';
import 'package:material_ui/material_ui.dart' as mui;

import '../../mock_server_responses.dart';
import '../../network/fake_http_client_factory.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

const historyUser = LightUser(id: UserId('testuser'), name: 'testUser');

void main() {
  group('GameHistoryScreen filter sheet', () {
    testWidgets('shows a Result section with a Won chip and applies it', (tester) async {
      final requestedGameUrls = <Uri>[];
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/games/user/testuser') {
          requestedGameUrls.add(request.url);
          return mockResponse(mockUserRecentGameResponse('testUser'), 200);
        }
        return mockResponse('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: const GameHistoryScreen(user: historyUser, isOnline: true),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(() => mockClient),
          ),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Result'));
      await tester.pumpAndSettle();

      expect(find.text('Result'), findsOneWidget);
      expect(find.text('Won'), findsOneWidget);
      // Lost and Draw are not rendered this iteration
      expect(find.text('Lost'), findsNothing);
      expect(find.text('Draw'), findsNothing);

      await tester.tap(find.text('Won'));
      await tester.pump();

      await tester.ensureVisible(find.text('Submit'));
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(find.text('Result'), findsNothing);
      // the app bar title now shows the selection label
      expect(find.text('Won'), findsOneWidget);

      expect(requestedGameUrls.any((url) => url.queryParameters['wonBy'] == 'testuser'), isTrue);
    });

    testWidgets('keeps the Won chip selected until it is deselected again', (tester) async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/games/user/testuser') {
          return mockResponse(mockUserRecentGameResponse('testUser'), 200);
        }
        return mockResponse('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: const GameHistoryScreen(user: historyUser, isOnline: true),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(() => mockClient),
          ),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Result'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(mui.ChoiceChip, 'Won'));
      await tester.pump();
      await tester.ensureVisible(find.text('Submit'));
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(find.text('Won'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Result'));
      await tester.pumpAndSettle();

      final chip = tester.widget<mui.ChoiceChip>(find.widgetWithText(mui.ChoiceChip, 'Won'));
      expect(chip.selected, isTrue);

      await tester.tap(find.widgetWithText(mui.ChoiceChip, 'Won'));
      await tester.pump();
      await tester.ensureVisible(find.text('Submit'));
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(find.text('Won'), findsNothing);

      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Result'));
      await tester.pumpAndSettle();

      final clearedChip = tester.widget<mui.ChoiceChip>(find.widgetWithText(mui.ChoiceChip, 'Won'));
      expect(clearedChip.selected, isFalse);
    });

    testWidgets('never shows games the profile lost once the Won filter is applied', (
      tester,
    ) async {
      final full = mockUserRecentGameResponse('testUser');
      final requestedGameUrls = <Uri>[];
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/games/user/testuser') {
          requestedGameUrls.add(request.url);
          final wonBy = request.url.queryParameters['wonBy'];
          if (wonBy == null) return mockResponse(full, 200);
          // emulate the server rule: only the games the profile actually won
          final wonLines = full.split('\n').where((line) => line.isNotEmpty).where((line) {
            final json = jsonDecode(line) as Map<String, dynamic>;
            final players = json['players'] as Map<String, dynamic>;
            final white = (players['white'] as Map<String, dynamic>)['user'];
            final profileSide = white != null && (white as Map<String, dynamic>)['id'] == wonBy
                ? 'white'
                : 'black';
            return json['winner'] == profileSide;
          }).toList();
          return mockResponse(wonLines.join('\n'), 200);
        }
        return mockResponse('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: const GameHistoryScreen(user: historyUser, isOnline: true),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(() => mockClient),
          ),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // sanity: the unfiltered list shows the game the profile lost (opponent Dr-Alaakour)
      expect(find.textContaining('Dr-Alaakour'), findsOneWidget);
      expect(find.textContaining('MightyNanook'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Result'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(mui.ChoiceChip, 'Won'));
      await tester.pump();
      await tester.ensureVisible(find.text('Submit'));
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // the filtered list is not empty, shows the won games, and no lost game
      expect(find.textContaining('MightyNanook'), findsOneWidget);
      expect(find.textContaining('SchallUndRausch'), findsOneWidget);
      expect(find.textContaining('Dr-Alaakour'), findsNothing);
    });

    testWidgets('combines the result filter with the side filter', (tester) async {
      final requestedGameUrls = <Uri>[];
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/games/user/testuser') {
          requestedGameUrls.add(request.url);
          return mockResponse(mockUserRecentGameResponse('testUser'), 200);
        }
        return mockResponse('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: const GameHistoryScreen(user: historyUser, isOnline: true),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(() => mockClient),
          ),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Result'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(mui.ChoiceChip, 'White'));
      await tester.pump();
      await tester.tap(find.widgetWithText(mui.ChoiceChip, 'Won'));
      await tester.pump();
      await tester.ensureVisible(find.text('Submit'));
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(
        requestedGameUrls.any(
          (url) =>
              url.queryParameters['color'] == 'white' && url.queryParameters['wonBy'] == 'testuser',
        ),
        isTrue,
      );
    });
  });
}
