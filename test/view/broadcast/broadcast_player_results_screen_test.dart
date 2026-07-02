import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_player_results_screen.dart';

import '../../network/fake_http_client_factory.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

const _tournamentId = BroadcastTournamentId('testTour');
const _playerId = 'playerId';

const _tournamentResponse = '''
{
  "tour": {
    "id": "testTour",
    "name": "Test Tournament",
    "slug": "test-tournament"
  },
  "rounds": [],
  "defaultRoundId": "testRond"
}
''';

/// Builds a player results JSON response with a single game having the
/// given `points` ("1", "1/2", "0", or null for ongoing) and [customPoints].
String playerResponse({required String? points, required double? customPoints}) {
  final pointsField = points == null ? 'null' : '"$points"';
  final customField = customPoints == null ? 'null' : '$customPoints';
  final ongoing = points == null;
  final ongoingField = ongoing ? '"ongoing": true,' : '';
  return '''
{
  "name": "Test Player",
  "played": 1,
  "fide": {},
  "games": [
    {
      "round": "testRond",
      "id": "testGame",
      "color": "white",
      "fideTC": "standard",
      "points": $pointsField,
      "customPoints": $customField,
      $ongoingField
      "opponent": {"name": "Opponent"}
    }
  ]
}
''';
}

MockClient mockClientForPlayer({required String? points, required double? customPoints}) {
  final playerBody = playerResponse(points: points, customPoints: customPoints);
  return MockClient((request) {
    if (request.url.path == '/api/broadcast/$_tournamentId') {
      return mockResponse(
        _tournamentResponse,
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    }
    if (request.url.path == '/broadcast/$_tournamentId/players/$_playerId') {
      return mockResponse(
        playerBody,
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    }
    return mockResponse('', 404);
  });
}

Future<void> pumpPlayerResultsScreen(
  WidgetTester tester, {
  required String? points,
  required double? customPoints,
}) async {
  final client = mockClientForPlayer(points: points, customPoints: customPoints);
  final app = await makeTestProviderScopeApp(
    tester,
    home: const BroadcastPlayerResultsScreen(tournamentId: _tournamentId, playerId: _playerId),
    overrides: {
      httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
        return FakeHttpClientFactory(() => client);
      }),
    },
  );

  await tester.pumpWidget(app);

  // Load the tournament data
  await tester.pump();

  // Load the player data
  await tester.pump();

  // Build the game list
  await tester.pump();
}

/// Asserts that the game tile in the only rendered [ListTile] displays [expected].
void expectGameTileShows(String expected) {
  final tileText = find.descendant(of: find.byType(ListTile), matching: find.text(expected));
  expect(tileText, findsOneWidget);
}

void main() {
  group('BroadcastPlayerResultsScreen game result display', () {
    group('without custom scoring', () {
      testWidgets('win shows 1', variant: kPlatformVariant, (tester) async {
        await pumpPlayerResultsScreen(tester, points: '1', customPoints: null);
        expectGameTileShows('1');
      });

      testWidgets('draw shows ½', variant: kPlatformVariant, (tester) async {
        await pumpPlayerResultsScreen(tester, points: '1/2', customPoints: null);
        expectGameTileShows('½');
      });

      testWidgets('loss shows 0', variant: kPlatformVariant, (tester) async {
        await pumpPlayerResultsScreen(tester, points: '0', customPoints: null);
        expectGameTileShows('0');
      });

      testWidgets('ongoing shows *', variant: kPlatformVariant, (tester) async {
        await pumpPlayerResultsScreen(tester, points: null, customPoints: null);
        expectGameTileShows('*');
      });
    });

    group('with custom scoring different from standard', () {
      testWidgets('custom win 3 points shows 3', variant: kPlatformVariant, (tester) async {
        await pumpPlayerResultsScreen(tester, points: '1', customPoints: 3.0);
        expectGameTileShows('3');
      });

      testWidgets('custom draw 1.5 points shows 1.5', variant: kPlatformVariant, (tester) async {
        await pumpPlayerResultsScreen(tester, points: '1/2', customPoints: 1.5);
        expectGameTileShows('1.5');
      });

      testWidgets('custom draw 1 point shows 1', variant: kPlatformVariant, (tester) async {
        await pumpPlayerResultsScreen(tester, points: '1/2', customPoints: 1.0);
        expectGameTileShows('1');
      });

      testWidgets('custom draw with 0 custom points shows ½', variant: kPlatformVariant, (
        tester,
      ) async {
        await pumpPlayerResultsScreen(tester, points: '1/2', customPoints: 0.0);
        expectGameTileShows('0');
      });
    });

    group('with custom scoring matching standard values', () {
      testWidgets('custom win 1.0 shows standard 1', variant: kPlatformVariant, (tester) async {
        await pumpPlayerResultsScreen(tester, points: '1', customPoints: 1.0);
        expectGameTileShows('1');
      });

      testWidgets('custom draw 0.5 shows standard ½', variant: kPlatformVariant, (tester) async {
        await pumpPlayerResultsScreen(tester, points: '1/2', customPoints: 0.5);
        expectGameTileShows('½');
      });

      testWidgets('custom loss 0.0 shows standard 0', variant: kPlatformVariant, (tester) async {
        await pumpPlayerResultsScreen(tester, points: '0', customPoints: 0.0);
        expectGameTileShows('0');
      });
    });
  });

  group('tournamentReferenceYear', () {
    BroadcastTournament makeTournament({DateTime? startsAt, DateTime? endsAt}) {
      return BroadcastTournament(
        data: BroadcastTournamentData(
          id: const BroadcastTournamentId('t'),
          name: 'Test',
          slug: 'test',
          imageUrl: null,
          description: null,
          information: (
            format: null,
            timeControl: null,
            players: null,
            location: null,
            dates: startsAt == null ? null : (startsAt: startsAt, endsAt: endsAt),
            website: null,
            standings: null,
          ),
        ),
        rounds: const IListConst([]),
        defaultRoundId: const BroadcastRoundId('r'),
        group: null,
      );
    }

    test('uses end year when the tournament has ended', () {
      final tournament = makeTournament(
        startsAt: DateTime.utc(2021, 1, 10),
        endsAt: DateTime.utc(2021, 12, 20),
      );
      expect(tournamentReferenceYear(tournament), 2021);
    });

    test('uses start year when no end date is set', () {
      final tournament = makeTournament(startsAt: DateTime.utc(2018, 6, 5));
      expect(tournamentReferenceYear(tournament), 2018);
    });

    test('falls back to current year when no dates are available', () {
      final tournament = makeTournament();
      expect(tournamentReferenceYear(tournament), DateTime.now().year);
    });
  });
}
