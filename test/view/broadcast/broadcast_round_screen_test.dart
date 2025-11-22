import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_players_tab.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_round_screen.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

void main() {
  group('Broadcast round screen', () {
    testWidgets('Check that all tabs except the teams tab are present', variant: kPlatformVariant, (
      tester,
    ) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: BroadcastRoundScreen(broadcast: _finishedBroadcast),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(_finishedBroadcastClient, ref),
          ),
        },
      );

      await tester.pumpWidget(app);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the tournament
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the round
      await tester.pump();

      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Boards'), findsOneWidget);
      expect(find.text('Players'), findsOneWidget);
      expect(find.text('Teams'), findsNothing);
    });

    testWidgets('Check that the screen can be loaded from round id', variant: kPlatformVariant, (
      tester,
    ) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const BroadcastRoundScreenLoading(roundId: BroadcastRoundId('S5VCwuVn')),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(_finishedBroadcastClient, ref),
          ),
        },
      );

      await tester.pumpWidget(app);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the broadcast data
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the tournament data
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the round data
      await tester.pump();

      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Boards'), findsOneWidget);
      expect(find.text('Players'), findsOneWidget);
      expect(find.text('Teams'), findsNothing);
    });
  });

  group('Test boards tab', () {
    testWidgets('Test boards tab with a finished tournament', variant: kPlatformVariant, (
      tester,
    ) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: BroadcastRoundScreen(broadcast: _finishedBroadcast),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(_finishedBroadcastClient, ref),
          ),
        },
      );

      await tester.pumpWidget(app);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the tournament
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the round
      await tester.pump();

      // Check that the right number of boards is displayed
      expect(find.byType(BoardThumbnail), findsNWidgets(4));

      // Check that players name are displayed
      expect(find.text('Nepomniachtchi, Ian'), findsNWidgets(4));
      expect(find.text('Carlsen, Magnus'), findsNWidgets(4));
    });

    testWidgets('Test clocks are ticking with a live round', variant: kPlatformVariant, (
      tester,
    ) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: BroadcastRoundScreen(broadcast: _liveBroadcast),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(_liveBroadcastClient(), ref),
          ),
        },
      );

      await tester.pumpWidget(app);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the tournament
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the round
      await tester.pump();

      expect(find.text('00:08'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));

      expect(find.text('00:07'), findsOneWidget);
    });

    testWidgets('Test search by player names', variant: kPlatformVariant, (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: BroadcastRoundScreen(broadcast: _liveBroadcast),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(_liveBroadcastClient(), ref),
          ),
        },
      );

      await tester.pumpWidget(app);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the tournament
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the round
      await tester.pump();

      expect(find.byType(BoardThumbnail), findsAtLeastNWidgets(6));
      // Enter a query that doesn't match any player
      final searchField = find.byType(SearchBar);
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'aaaaaa');
      await tester.pump();
      // Filtered to zero results
      expect(find.byType(BoardThumbnail), findsNothing);

      await tester.enterText(searchField, 'giri');
      await tester.pump();
      // Filtered to one result
      expect(find.byType(BoardThumbnail), findsOneWidget);
      expect(find.text('Giri, Anish'), findsOneWidget);

      await tester.enterText(searchField, '');
      await tester.pump();
      // Clear the field -> results restored
      await tester.pump();
      expect(find.byType(BoardThumbnail), findsAtLeastNWidgets(6));
    });
  });

  group('Test overview tab', () {
    testWidgets('Test overview tab with an upcoming tournament', variant: kPlatformVariant, (
      tester,
    ) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: BroadcastRoundScreen(broadcast: _upcomingBroadcast),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(_upcomingBroadcastClient, ref),
          ),
        },
      );

      await tester.pumpWidget(app);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the tournament
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the overview
      await mockNetworkImages(() => tester.pump());

      final startsAt = DateTime.fromMillisecondsSinceEpoch(1736526600000);
      final endsAt = DateTime.fromMillisecondsSinceEpoch(1737189000000);
      final f = DateFormat.MMMd();

      expect(find.text('${f.format(startsAt)} - ${f.format(endsAt)}'), findsOneWidget);
      expect(find.text('9-round Swiss'), findsOneWidget);
      expect(find.text('90 min + 30 sec / move'), findsOneWidget);
      expect(find.text('Seville, Spain'), findsOneWidget);
      expect(find.text('Xu, Bonelli, Jacobson'), findsOneWidget);
      expect(find.text('Official website'), findsOneWidget);
      expect(find.text('Official Standings'), findsOneWidget);
    });
  });

  group('Test players tab', () {
    testWidgets('Test rows are displayed', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: BroadcastRoundScreen(
          broadcast: _liveBroadcast,
          initialTab: BroadcastRoundTab.players,
        ),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(_liveBroadcastClient(), ref),
          ),
        },
      );

      await tester.pumpWidget(app);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the tournament
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the round
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the players
      await tester.pump();

      expect(find.text('Carlsen, Magnus'), findsOneWidget);
      expect(find.text('Nepomniachtchi, Ian'), findsOneWidget);
    });

    testWidgets('Test score sort', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: BroadcastRoundScreen(
          broadcast: _liveBroadcast,
          initialTab: BroadcastRoundTab.players,
        ),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(_liveBroadcastClient(), ref),
          ),
        },
      );

      await tester.pumpWidget(app);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the tournament
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the round
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the players
      await tester.pump();

      final playersList = tester
          .widgetList<BroadcastPlayerRow>(find.byType(BroadcastPlayerRow))
          .toList();

      expect(playersList[0].playerWithOverallResult.player.name, 'Carlsen, Magnus');
      expect(playersList[1].playerWithOverallResult.player.name, 'Nepomniachtchi, Ian');

      await tester.tap(find.text('Score'));
      await tester.pump();

      final playersListReversed = tester
          .widgetList<BroadcastPlayerRow>(find.byType(BroadcastPlayerRow))
          .toList();

      expect(playersListReversed[0].playerWithOverallResult.player.name, 'Nepomniachtchi, Ian');
      expect(playersListReversed[1].playerWithOverallResult.player.name, 'Carlsen, Magnus');
    });

    testWidgets('Test elo sort', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: BroadcastRoundScreen(
          broadcast: _liveBroadcast,
          initialTab: BroadcastRoundTab.players,
        ),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(_liveBroadcastClient(), ref),
          ),
        },
      );

      await tester.pumpWidget(app);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the tournament
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the round
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the players
      await tester.pump();

      await tester.tap(find.text('Elo'));
      await tester.pump();

      final playersList = tester
          .widgetList<BroadcastPlayerRow>(find.byType(BroadcastPlayerRow))
          .toList();

      expect(playersList[0].playerWithOverallResult.player.name, 'Carlsen, Magnus');
      expect(playersList[1].playerWithOverallResult.player.name, 'Nepomniachtchi, Ian');

      await tester.tap(find.text('Elo'));
      await tester.pump();

      final playersListReversed = tester
          .widgetList<BroadcastPlayerRow>(find.byType(BroadcastPlayerRow))
          .toList();

      expect(playersListReversed[0].playerWithOverallResult.player.name, 'Nepomniachtchi, Ian');
      expect(playersListReversed[1].playerWithOverallResult.player.name, 'Carlsen, Magnus');
    });

    testWidgets('Test player sort', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: BroadcastRoundScreen(
          broadcast: _liveBroadcast,
          initialTab: BroadcastRoundTab.players,
        ),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(_liveBroadcastClient(), ref),
          ),
        },
      );

      await tester.pumpWidget(app);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the tournament
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the round
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the players
      await tester.pump();

      await tester.tap(find.text('Player'));
      await tester.pump();

      final playersList = tester
          .widgetList<BroadcastPlayerRow>(find.byType(BroadcastPlayerRow))
          .toList();

      expect(playersList[0].playerWithOverallResult.player.name, 'Carlsen, Magnus');
      expect(playersList[1].playerWithOverallResult.player.name, 'Nepomniachtchi, Ian');

      await tester.tap(find.text('Player'));
      await tester.pump();

      final playersListReversed = tester
          .widgetList<BroadcastPlayerRow>(find.byType(BroadcastPlayerRow))
          .toList();

      expect(playersListReversed[0].playerWithOverallResult.player.name, 'Nepomniachtchi, Ian');
      expect(playersListReversed[1].playerWithOverallResult.player.name, 'Carlsen, Magnus');
    });

    testWidgets('Test games sort', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: BroadcastRoundScreen(
          broadcast: _liveBroadcast,
          initialTab: BroadcastRoundTab.players,
        ),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(_liveBroadcastClient(withPlayerScores: false), ref),
          ),
        },
      );

      await tester.pumpWidget(app);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the tournament
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the round
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the players
      await tester.pump();

      await tester.tap(find.text('Games'));
      await tester.pump();

      final playersList = tester
          .widgetList<BroadcastPlayerRow>(find.byType(BroadcastPlayerRow))
          .toList();

      expect(playersList[0].playerWithOverallResult.player.name, 'Carlsen, Magnus');
      expect(playersList[1].playerWithOverallResult.player.name, 'Nepomniachtchi, Ian');

      await tester.tap(find.text('Games'));
      await tester.pump();

      final playersListReversed = tester
          .widgetList<BroadcastPlayerRow>(find.byType(BroadcastPlayerRow))
          .toList();

      expect(playersListReversed[0].playerWithOverallResult.player.name, 'Nepomniachtchi, Ian');
      expect(playersListReversed[1].playerWithOverallResult.player.name, 'Carlsen, Magnus');
    });
  });
  group('Test teams tab', () {
    testWidgets('Check that teams tab is present when teamTable is true', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: BroadcastRoundScreen(broadcast: _liveTeamBroadcast),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(_liveTeamBroadcastClient, ref),
          ),
        },
      );

      await tester.pumpWidget(app);

      // Load the tournament
      await tester.pump();

      // Load the round
      await tester.pump();

      // Verify tabs
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Boards'), findsOneWidget);
      expect(find.text('Players'), findsOneWidget);
      expect(find.text('Teams'), findsOneWidget);
    });

    testWidgets('Check teams tab content is displayed correctly', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: BroadcastRoundScreen(
          broadcast: _liveTeamBroadcast,
          initialTab: BroadcastRoundTab.teams,
        ),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(_liveTeamBroadcastClient, ref),
          ),
        },
      );

      await tester.pumpWidget(app);

      // Load the tournament
      await tester.pump();

      // Load the round
      await tester.pump();

      // Load the teams data
      await tester.pump();

      // Verify team names are displayed
      expect(find.text('Team A'), findsOneWidget);
      expect(find.text('Team B'), findsOneWidget);
      expect(find.text('Team C'), findsOneWidget);
      expect(find.text('Team D'), findsOneWidget);

      expect(find.text('1 - 0'), findsOneWidget);

      expect(find.byType(Card), findsNWidgets(2));
    });
  });
}

final _finishedBroadcastClient = MockClient((request) {
  if (request.url.path == '/api/broadcast/AQ28hmmO') {
    return mockResponse(
      _finishedTournamentResponse,
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }
  if (request.url.path == '/api/broadcast/-/-/S5VCwuVn') {
    return mockResponse(
      _finishedRoundResponse,
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }
  return mockResponse('', 404);
});

MockClient _liveBroadcastClient({bool withPlayerScores = true}) => MockClient((request) {
  if (request.url.path == '/api/broadcast/AAAAAAAA') {
    return mockResponse(
      _liveTournamentResponse,
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }
  if (request.url.path == '/api/broadcast/-/-/00000000') {
    return mockResponse(
      _liveRoundResponse,
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }
  if (request.url.path == '/broadcast/AAAAAAAA/players') {
    return mockResponse(
      withPlayerScores ? _livePlayersResponse : _livePlayersWithoutScoresResponse,
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }
  return mockResponse('', 404);
});

final _upcomingBroadcastClient = MockClient((request) {
  if (request.url.path == '/api/broadcast/KnP1dgul') {
    return mockResponse(
      _upcomingTournamentResponse,
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }
  if (request.url.path == '/api/broadcast/-/-/UN587WBI') {
    return mockResponse(
      _upcomingRoundResponse,
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }
  return mockResponse('', 404);
});

final _finishedBroadcast = Broadcast(
  tour: BroadcastTournamentData(
    id: const BroadcastTournamentId('AQ28hmmO'),
    name: 'FIDE World Rapid & Blitz Championships 2024 | Blitz Open Knockout',
    slug: 'fide-world-rapid--blitz-championships-2024--blitz-open-knockout',
    imageUrl:
        'https://image.lichess1.org/display?fmt=webp&h=400&op=thumbnail&path=relay:AQ28hmmO:HJnFeGh1.webp&w=800&sig=fc2123e62c3ae7da1ebefd6533694bf627f84543',
    description: null,
    tier: 5,
    information: (
      dates: (startsAt: DateTime.fromMillisecondsSinceEpoch(1735671720000), endsAt: null),
      format: '8-player knockout',
      location: 'New York, United States',
      players: 'Carlsen, Firouzja, So, Caruana, Murzin',
      website: Uri.parse('https://worldrapidandblitz2024.fide.com/'),
      standings: Uri.parse('https://worldrapidandbli…e.com/blitz-finals-open/'),
      timeControl: '3 min + 2 sec / move',
    ),
  ),
  round: BroadcastRound(
    id: const BroadcastRoundId('S5VCwuVn'),
    name: 'Final - Tie-breaks',
    slug: 'final-tie-breaks',
    status: RoundStatus.finished,
    startsAt: DateTime.fromMillisecondsSinceEpoch(1735687229333),
    finishedAt: DateTime.fromMillisecondsSinceEpoch(1735689805106),
    startsAfterPrevious: true,
  ),
  roundToLinkId: const BroadcastRoundId('S5VCwuVn'),
  group: 'FIDE World Rapid & Blitz Championships 2024',
);

const _finishedTournamentResponse = '''
{
  "tour": {
    "id": "AQ28hmmO",
    "name": "FIDE World Rapid & Blitz Championships 2024 | Blitz Open Knockout",
    "slug": "fide-world-rapid--blitz-championships-2024--blitz-open-knockout",
    "info": {
      "website": "https://worldrapidandblitz2024.fide.com/",
      "players": "Carlsen, Firouzja, So, Caruana, Murzin",
      "location": "New York, United States",
      "tc": "3 min + 2 sec / move",
      "fideTc": "blitz",
      "timeZone": "America/New_York",
      "standings": "https://worldrapidandblitz2024.fide.com/blitz-finals-open/",
      "format": "8-player knockout"
    },
    "createdAt": 1734772425213,
    "url": "https://lichess.org/broadcast/fide-world-rapid--blitz-championships-2024--blitz-open-knockout/AQ28hmmO",
    "tier": 5,
    "dates": [
      1735671720000
    ],
    "image": "https://image.lichess1.org/display?fmt=webp&h=400&op=thumbnail&path=relay:AQ28hmmO:HJnFeGh1.webp&w=800&sig=fc2123e62c3ae7da1ebefd6533694bf627f84543"
  },
  "rounds": [
    {
      "id": "iNSwFnXR",
      "name": "Quarter-Final - Game 1",
      "slug": "quarter-final-game-1",
      "createdAt": 1734772603808,
      "finishedAt": 1735672455503,
      "finished": true,
      "startsAt": 1735671720000,
      "url": "https://lichess.org/broadcast/fide-world-rapid--blitz-championships-2024--blitz-open-knockout/quarter-final-game-1/iNSwFnXR"
    },
    {
      "id": "VVBf6AIZ",
      "name": "Quarter-Final - Game 2",
      "slug": "quarter-final-game-2",
      "createdAt": 1734772639083,
      "finishedAt": 1735673601490,
      "finished": true,
      "startsAt": 1735673042425,
      "startsAfterPrevious": true,
      "url": "https://lichess.org/broadcast/fide-world-rapid--blitz-championships-2024--blitz-open-knockout/quarter-final-game-2/VVBf6AIZ"
    },
    {
      "id": "dXtRYjoK",
      "name": "Quarter-Final - Game 3",
      "slug": "quarter-final-game-3",
      "createdAt": 1734772647787,
      "finishedAt": 1735674514947,
      "finished": true,
      "startsAt": 1735673869284,
      "startsAfterPrevious": true,
      "url": "https://lichess.org/broadcast/fide-world-rapid--blitz-championships-2024--blitz-open-knockout/quarter-final-game-3/dXtRYjoK"
    },
    {
      "id": "ItP4Pipu",
      "name": "Quarter-Final - Game 4",
      "slug": "quarter-final-game-4",
      "createdAt": 1734772652288,
      "finishedAt": 1735675461562,
      "finished": true,
      "startsAt": 1735674788585,
      "startsAfterPrevious": true,
      "url": "https://lichess.org/broadcast/fide-world-rapid--blitz-championships-2024--blitz-open-knockout/quarter-final-game-4/ItP4Pipu"
    },
    {
      "id": "wp5pjfIP",
      "name": "Semi-Final - Game 1",
      "slug": "semi-final-game-1",
      "createdAt": 1734773126071,
      "finishedAt": 1735677848591,
      "finished": true,
      "startsAt": 1735677120000,
      "url": "https://lichess.org/broadcast/fide-world-rapid--blitz-championships-2024--blitz-open-knockout/semi-final-game-1/wp5pjfIP"
    },
    {
      "id": "Emk1sXDS",
      "name": "Semi-Final - Game 2",
      "slug": "semi-final-game-2",
      "createdAt": 1734773131442,
      "finishedAt": 1735678633966,
      "finished": true,
      "startsAt": 1735678107623,
      "startsAfterPrevious": true,
      "url": "https://lichess.org/broadcast/fide-world-rapid--blitz-championships-2024--blitz-open-knockout/semi-final-game-2/Emk1sXDS"
    },
    {
      "id": "GVh5bp4H",
      "name": "Semi-Final - Game 3",
      "slug": "semi-final-game-3",
      "createdAt": 1734773160965,
      "finishedAt": 1735679522532,
      "finished": true,
      "startsAt": 1735679011442,
      "startsAfterPrevious": true,
      "url": "https://lichess.org/broadcast/fide-world-rapid--blitz-championships-2024--blitz-open-knockout/semi-final-game-3/GVh5bp4H"
    },
    {
      "id": "MoGyMEGL",
      "name": "Semi-Final - Game 4",
      "slug": "semi-final-game-4",
      "createdAt": 1734773177480,
      "finishedAt": 1735680163952,
      "finished": true,
      "startsAt": 1735680161792,
      "startsAfterPrevious": true,
      "url": "https://lichess.org/broadcast/fide-world-rapid--blitz-championships-2024--blitz-open-knockout/semi-final-game-4/MoGyMEGL"
    },
    {
      "id": "IhbanPam",
      "name": "Semi-Final - Tie-breaks",
      "slug": "semi-final-tie-breaks",
      "createdAt": 1734773197874,
      "finishedAt": 1735681239998,
      "finished": true,
      "startsAt": 1735680767893,
      "startsAfterPrevious": true,
      "url": "https://lichess.org/broadcast/fide-world-rapid--blitz-championships-2024--blitz-open-knockout/semi-final-tie-breaks/IhbanPam"
    },
    {
      "id": "IhuCDHj9",
      "name": "Final - Game 1",
      "slug": "final-game-1",
      "createdAt": 1734773217550,
      "finishedAt": 1735684024337,
      "finished": true,
      "startsAt": 1735682520000,
      "url": "https://lichess.org/broadcast/fide-world-rapid--blitz-championships-2024--blitz-open-knockout/final-game-1/IhuCDHj9"
    },
    {
      "id": "TdHdbfCP",
      "name": "Final - Game 2",
      "slug": "final-game-2",
      "createdAt": 1734773232789,
      "finishedAt": 1735684671396,
      "finished": true,
      "startsAt": 1735684239913,
      "startsAfterPrevious": true,
      "url": "https://lichess.org/broadcast/fide-world-rapid--blitz-championships-2024--blitz-open-knockout/final-game-2/TdHdbfCP"
    },
    {
      "id": "OQHCOYeD",
      "name": "Final - Game 3",
      "slug": "final-game-3",
      "createdAt": 1734773271040,
      "finishedAt": 1735685640252,
      "finished": true,
      "startsAt": 1735685074841,
      "startsAfterPrevious": true,
      "url": "https://lichess.org/broadcast/fide-world-rapid--blitz-championships-2024--blitz-open-knockout/final-game-3/OQHCOYeD"
    },
    {
      "id": "nO8RQtYi",
      "name": "Final - Game 4",
      "slug": "final-game-4",
      "createdAt": 1734773276413,
      "finishedAt": 1735686740361,
      "finished": true,
      "startsAt": 1735686289204,
      "startsAfterPrevious": true,
      "url": "https://lichess.org/broadcast/fide-world-rapid--blitz-championships-2024--blitz-open-knockout/final-game-4/nO8RQtYi"
    },
    {
      "id": "S5VCwuVn",
      "name": "Final - Tie-breaks",
      "slug": "final-tie-breaks",
      "createdAt": 1734773289081,
      "finishedAt": 1735689805106,
      "finished": true,
      "startsAt": 1735687229333,
      "startsAfterPrevious": true,
      "url": "https://lichess.org/broadcast/fide-world-rapid--blitz-championships-2024--blitz-open-knockout/final-tie-breaks/S5VCwuVn"
    }
  ],
  "group": {
    "name": "FIDE World Rapid & Blitz Championships 2024",
    "tours": [
      {
        "id": "AQ28hmmO",
        "name": "Blitz Open Knockout"
      },
      {
        "id": "KVFwAvpj",
        "name": "Blitz Women Knockout"
      },
      {
        "id": "ls1b76YS",
        "name": "Blitz Open 1-30"
      },
      {
        "id": "k1zrWM91",
        "name": "Blitz Open 31+"
      },
      {
        "id": "mguNQuBg",
        "name": "Blitz Women"
      },
      {
        "id": "zsiKgSQq",
        "name": "Rapid Open 1-30"
      },
      {
        "id": "zhsXVzKt",
        "name": "Rapid Open 31+"
      },
      {
        "id": "6J76KbFG",
        "name": "Rapid Women"
      }
    ]
  },
  "defaultRoundId": "iNSwFnXR"
}
''';

const _finishedRoundResponse = '''
{
  "round": {
    "id": "S5VCwuVn",
    "name": "Final - Tie-breaks",
    "slug": "final-tie-breaks",
    "createdAt": 1734773289081,
    "finishedAt": 1735689805106,
    "finished": true,
    "startsAt": 1735687229333,
    "startsAfterPrevious": true,
    "url": "https://lichess.org/broadcast/fide-world-rapid--blitz-championships-2024--blitz-open-knockout/final-tie-breaks/S5VCwuVn",
    "delay": 120
  },
  "tour": {
    "id": "AQ28hmmO",
    "name": "FIDE World Rapid & Blitz Championships 2024 | Blitz Open Knockout",
    "slug": "fide-world-rapid--blitz-championships-2024--blitz-open-knockout",
    "info": {
      "website": "https://worldrapidandblitz2024.fide.com/",
      "players": "Carlsen, Firouzja, So, Caruana, Murzin",
      "location": "New York, United States",
      "tc": "3 min + 2 sec / move",
      "fideTc": "blitz",
      "timeZone": "America/New_York",
      "standings": "https://worldrapidandblitz2024.fide.com/blitz-finals-open/",
      "format": "8-player knockout"
    },
    "createdAt": 1734772425213,
    "url": "https://lichess.org/broadcast/fide-world-rapid--blitz-championships-2024--blitz-open-knockout/AQ28hmmO",
    "tier": 5,
    "dates": [
      1735671720000
    ],
    "image": "https://image.lichess1.org/display?fmt=webp&h=400&op=thumbnail&path=relay:AQ28hmmO:HJnFeGh1.webp&w=800&sig=fc2123e62c3ae7da1ebefd6533694bf627f84543"
  },
  "study": {
    "writeable": false
  },
  "games": [
    {
      "id": "gAF7xMTL",
      "name": "Nepomniachtchi, Ian - Carlsen, Magnus",
      "fen": "6k1/7p/6p1/1r6/1P2R3/6PK/8/8 b - - 2 43",
      "players": [
        {
          "name": "Nepomniachtchi, Ian",
          "title": "GM",
          "rating": 2770,
          "fideId": 4168119,
          "fed": "RUS",
          "clock": 2300
        },
        {
          "name": "Carlsen, Magnus",
          "title": "GM",
          "rating": 2890,
          "fideId": 1503014,
          "fed": "NOR",
          "clock": 1200
        }
      ],
      "lastMove": "e6e4",
      "status": "½-½"
    },
    {
      "id": "RgkuB2Mi",
      "name": "Carlsen, Magnus - Nepomniachtchi, Ian",
      "fen": "6k1/5p1p/p3pqp1/8/1P6/P3PQP1/r4PKP/2R5 b - - 2 31",
      "players": [
        {
          "name": "Carlsen, Magnus",
          "title": "GM",
          "rating": 2890,
          "fideId": 1503014,
          "fed": "NOR",
          "clock": 2400
        },
        {
          "name": "Nepomniachtchi, Ian",
          "title": "GM",
          "rating": 2770,
          "fideId": 4168119,
          "fed": "RUS",
          "clock": 3400
        }
      ],
      "lastMove": "b7f3",
      "status": "½-½"
    },
    {
      "id": "rR6sJJ0s",
      "name": "Nepomniachtchi, Ian - Carlsen, Magnus",
      "fen": "8/8/5k2/3K2p1/r5Rp/7P/6P1/8 b - - 1 48",
      "players": [
        {
          "name": "Nepomniachtchi, Ian",
          "title": "GM",
          "rating": 2770,
          "fideId": 4168119,
          "fed": "RUS",
          "clock": 2000
        },
        {
          "name": "Carlsen, Magnus",
          "title": "GM",
          "rating": 2890,
          "fideId": 1503014,
          "fed": "NOR",
          "clock": 800
        }
      ],
      "lastMove": "c4d5",
      "status": "½-½"
    },
    {
      "id": "fwjj3QYM",
      "name": "Carlsen, Magnus - Nepomniachtchi, Ian",
      "players": [
        {
          "name": "Carlsen, Magnus",
          "title": "GM",
          "rating": 2890,
          "fideId": 1503014,
          "fed": "NOR",
          "clock": 18200
        },
        {
          "name": "Nepomniachtchi, Ian",
          "title": "GM",
          "rating": 2770,
          "fideId": 4168119,
          "fed": "RUS",
          "clock": 18200
        }
      ],
      "status": "½-½"
    }
  ],
  "group": {
    "name": "FIDE World Rapid & Blitz Championships 2024",
    "tours": [
      {
        "id": "AQ28hmmO",
        "name": "Blitz Open Knockout"
      },
      {
        "id": "KVFwAvpj",
        "name": "Blitz Women Knockout"
      },
      {
        "id": "ls1b76YS",
        "name": "Blitz Open 1-30"
      },
      {
        "id": "k1zrWM91",
        "name": "Blitz Open 31+"
      },
      {
        "id": "mguNQuBg",
        "name": "Blitz Women"
      },
      {
        "id": "zsiKgSQq",
        "name": "Rapid Open 1-30"
      },
      {
        "id": "zhsXVzKt",
        "name": "Rapid Open 31+"
      },
      {
        "id": "6J76KbFG",
        "name": "Rapid Women"
      }
    ]
  }
}
''';

final _upcomingBroadcast = Broadcast(
  tour: BroadcastTournamentData(
    id: const BroadcastTournamentId('KnP1dgul'),
    name: '"Ciudad de Sevilla" Seville Open 2025',
    slug: 'ciudad-de-sevilla-seville-open-2025',
    imageUrl:
        'https://image.lichess1.org/display?fmt=webp&h=400&op=thumbnail&path=relay:KnP1dgul:2Wv8zqiG.webp&w=800&sig=156cb75295be7ec71e898983e8b1a35896f0a38e',
    description: null,
    tier: 3,
    information: (
      dates: (
        startsAt: DateTime.fromMillisecondsSinceEpoch(1736526600000),
        endsAt: DateTime.fromMillisecondsSinceEpoch(1737189000000),
      ),
      format: '9-round Swiss',
      location: 'Seville, Spain',
      players: 'Xu, Bonelli, Jacobson',
      website: Uri.parse('https://sevillaopenajedrez.com/'),
      standings: Uri.parse('https://chess-results.com/tnr1001542.aspx?lan=1'),
      timeControl: '90 min + 30 sec / move',
    ),
  ),
  round: BroadcastRound(
    id: const BroadcastRoundId('UN587WBI'),
    name: 'Round 1',
    slug: 'round-1',
    status: RoundStatus.upcoming,
    startsAt: DateTime.fromMillisecondsSinceEpoch(1736526600000),
    finishedAt: null,
    startsAfterPrevious: false,
  ),
  roundToLinkId: const BroadcastRoundId('UN587WBI'),
  group: null,
);

const _upcomingTournamentResponse = r'''
{
  "tour": {
    "id": "KnP1dgul",
    "name": "\"Ciudad de Sevilla\" Seville Open 2025",
    "slug": "ciudad-de-sevilla-seville-open-2025",
    "info": {
      "website": "https://sevillaopenajedrez.com/",
      "players": "Xu, Bonelli, Jacobson",
      "location": "Seville, Spain",
      "tc": "90 min + 30 sec / move",
      "fideTc": "standard",
      "timeZone": "Europe/Madrid",
      "standings": "https://chess-results.com/tnr1001542.aspx?lan=1",
      "format": "9-round Swiss"
    },
    "createdAt": 1735736216240,
    "url": "https://lichess.org/broadcast/ciudad-de-sevilla-seville-open-2025/KnP1dgul",
    "tier": 3,
    "dates": [
      1736526600000,
      1737189000000
    ],
    "image": "https://image.lichess1.org/display?fmt=webp&h=400&op=thumbnail&path=relay:KnP1dgul:2Wv8zqiG.webp&w=800&sig=156cb75295be7ec71e898983e8b1a35896f0a38e"
  },
  "rounds": [
    {
      "id": "UN587WBI",
      "name": "Round 1",
      "slug": "round-1",
      "createdAt": 1735736300620,
      "startsAt": 1736526600000,
      "url": "https://lichess.org/broadcast/ciudad-de-sevilla-seville-open-2025/round-1/UN587WBI"
    },
    {
      "id": "ptLkwyBW",
      "name": "Round 2",
      "slug": "round-2",
      "createdAt": 1735736367870,
      "startsAt": 1736613000000,
      "url": "https://lichess.org/broadcast/ciudad-de-sevilla-seville-open-2025/round-2/ptLkwyBW"
    },
    {
      "id": "Uyr4UqvP",
      "name": "Round 3",
      "slug": "round-3",
      "createdAt": 1735736376449,
      "startsAt": 1736699400000,
      "url": "https://lichess.org/broadcast/ciudad-de-sevilla-seville-open-2025/round-3/Uyr4UqvP"
    },
    {
      "id": "SD9tGxHr",
      "name": "Round 4",
      "slug": "round-4",
      "createdAt": 1735736382864,
      "startsAt": 1736785800000,
      "url": "https://lichess.org/broadcast/ciudad-de-sevilla-seville-open-2025/round-4/SD9tGxHr"
    },
    {
      "id": "YnvI7o5i",
      "name": "Round 5",
      "slug": "round-5",
      "createdAt": 1735736388177,
      "startsAt": 1736872200000,
      "url": "https://lichess.org/broadcast/ciudad-de-sevilla-seville-open-2025/round-5/YnvI7o5i"
    },
    {
      "id": "zciOGngM",
      "name": "Round 6",
      "slug": "round-6",
      "createdAt": 1735736390601,
      "startsAt": 1736958600000,
      "url": "https://lichess.org/broadcast/ciudad-de-sevilla-seville-open-2025/round-6/zciOGngM"
    },
    {
      "id": "Nm0Ab76A",
      "name": "Round 7",
      "slug": "round-7",
      "createdAt": 1735736392918,
      "startsAt": 1737045000000,
      "url": "https://lichess.org/broadcast/ciudad-de-sevilla-seville-open-2025/round-7/Nm0Ab76A"
    },
    {
      "id": "ZKH8mtNF",
      "name": "Round 8",
      "slug": "round-8",
      "createdAt": 1735736399672,
      "startsAt": 1737131400000,
      "url": "https://lichess.org/broadcast/ciudad-de-sevilla-seville-open-2025/round-8/ZKH8mtNF"
    },
    {
      "id": "jPF9296X",
      "name": "Round 9",
      "slug": "round-9",
      "createdAt": 1735736411240,
      "startsAt": 1737189000000,
      "url": "https://lichess.org/broadcast/ciudad-de-sevilla-seville-open-2025/round-9/jPF9296X"
    }
  ],
  "defaultRoundId": "UN587WBI"
}
''';

const _upcomingRoundResponse = r'''
{
  "round": {
    "id": "UN587WBI",
    "name": "Round 1",
    "slug": "round-1",
    "createdAt": 1735736300620,
    "startsAt": 1736526600000,
    "url": "https://lichess.org/broadcast/ciudad-de-sevilla-seville-open-2025/round-1/UN587WBI"
  },
  "tour": {
    "id": "KnP1dgul",
    "name": "\"Ciudad de Sevilla\" Seville Open 2025",
    "slug": "ciudad-de-sevilla-seville-open-2025",
    "info": {
      "website": "https://sevillaopenajedrez.com/",
      "players": "Xu, Bonelli, Jacobson",
      "location": "Seville, Spain",
      "tc": "90 min + 30 sec / move",
      "fideTc": "standard",
      "timeZone": "Europe/Madrid",
      "standings": "https://chess-results.com/tnr1001542.aspx?lan=1",
      "format": "9-round Swiss"
    },
    "createdAt": 1735736216240,
    "url": "https://lichess.org/broadcast/ciudad-de-sevilla-seville-open-2025/KnP1dgul",
    "tier": 3,
    "dates": [
      1736526600000,
      1737189000000
    ],
    "image": "https://image.lichess1.org/display?fmt=webp&h=400&op=thumbnail&path=relay:KnP1dgul:2Wv8zqiG.webp&w=800&sig=156cb75295be7ec71e898983e8b1a35896f0a38e"
  },
  "study": {
    "writeable": false
  },
  "games": []
}
''';

final _liveBroadcast = Broadcast(
  tour: BroadcastTournamentData(
    id: const BroadcastTournamentId('AAAAAAAA'),
    name: 'Test tournament',
    slug: 'test-tournament',
    imageUrl: '',
    description: null,
    tier: null,
    information: (
      dates: (startsAt: DateTime.fromMillisecondsSinceEpoch(1735671720000), endsAt: null),
      format: null,
      location: null,
      players: null,
      website: null,
      standings: null,
      timeControl: null,
    ),
  ),
  round: const BroadcastRound(
    id: BroadcastRoundId('00000000'),
    name: 'Test round',
    slug: 'test-round',
    status: RoundStatus.live,
    startsAt: null,
    finishedAt: null,
    startsAfterPrevious: false,
  ),
  roundToLinkId: const BroadcastRoundId('00000000'),
  group: null,
);

const _liveTournamentResponse = '''
{
  "tour": {
    "id": "AAAAAAAA",
    "name": "Test tournament",
    "slug": "test-tournament",
    "dates": [
      1735671720000
    ],
    "image": ""
  },
  "rounds": [
    {
      "id": "00000000",
      "name": "Test round",
      "slug": "test-round",
      "ongoing": "true"
    }
  ],
  "defaultRoundId": "00000000"
}
''';

const _liveRoundResponse = '''
{
  "round": {
    "id": "00000000",
    "name": "Test round",
    "slug": "test-round",
    "ongoing": true
  },
  "tour": {
    "id": "AAAAAAAA",
    "name": "Test tournament",
    "slug": "test-tournament",
    "dates": [
      1735671720000
    ],
    "image": ""
  },
  "study": {
    "writeable": false
  },
  "games": [
    {
      "id": "11111111",
      "name": "Nepomniachtchi, Ian - Carlsen, Magnus",
      "fen": "8/8/5k2/3K2p1/r5Rp/7P/6P1/8 b - - 1 48",
      "players": [
        {
          "name": "Nepomniachtchi, Ian",
          "title": "GM",
          "rating": 2770,
          "fideId": 4168119,
          "fed": "RUS",
          "clock": 2000
        },
        {
          "name": "Carlsen, Magnus",
          "title": "GM",
          "rating": 2890,
          "fideId": 1503014,
          "fed": "NOR",
          "clock": 800
        }
      ],
      "lastMove": "c4d5",
      "thinkTime": 0,
      "status": "*"
    },
    {
      "id": "22222222",
      "name": "Giri, Anish - Keymer, Vincent",
      "fen": "8/8/5k2/3K2p1/r5Rp/7P/6P1/8 b - - 1 48",
      "players": [
        {
          "name": "Giri, Anish",
          "title": "GM",
          "rating": 2769,
          "fideId": 24116068,
          "fed": "NED",
          "clock": 2001
        },
        {
          "name": "Keymer, Vincent",
          "title": "GM",
          "rating": 2773,
          "fideId": 12940690,
          "fed": "GER",
          "clock": 901
        }
      ],
      "lastMove": "c4d5",
      "thinkTime": 0,
      "status": "*"
    },
    {
      "fen": "r1b2rk1/1pp2p2/p5qp/6pQ/8/2nN2B1/P1P2PPP/R3R1K1 w - - 10 24",
      "id": "gYg5KcBI",
      "lastMove": "f5g6",
      "name": "Bellahcene, Bilel - Huschenbeth, Niclas",
      "players": [
      {
        "clock": 579000,
        "fed": "ALG",
        "fideId": 696358,
        "name": "Bellahcene, Bilel",
        "rating": 2487,
        "team": "Algeria",
        "title": "GM"
      },
      {
        "clock": 513500,
        "fed": "GER",
        "fideId": 24604747,
        "name": "Huschenbeth, Niclas",
        "rating": 2587,
        "team": "Germany",
        "title": "GM"
      }
      ],
      "status": "½-½"
    },
    {
      "fen": "r2r2k1/2qnppb1/p1n1b2p/2p3p1/2N1P3/2P1BNPP/P1Q2P2/1R1R1BK1 b - - 3 21",
      "id": "7koytsbS",
      "lastMove": "e1d1",
      "name": "Abasov, Nijat - Suyarov, Mukhammadzokhid",
      "players": [
      {
        "clock": 147900,
        "fed": "AZE",
        "fideId": 13402960,
        "name": "Abasov, Nijat",
        "rating": 2587,
        "team": "Azerbaijan",
        "title": "GM"
      },
      {
        "clock": 157400,
        "fed": "UZB",
        "fideId": 14210495,
        "name": "Suyarov, Mukhammadzokhid",
        "rating": 2487,
        "team": "Uzbekistan",
        "title": "IM"
      }
      ],
      "status": "*",
      "thinkTime": 88
    },
    {
      "fen": "r1q1r1k1/bppb1pp1/2np1n1p/4p3/P1NPP3/1QP2N1P/B4PPK/1RB1R3 b - - 2 20",
      "id": "JNrjijzF",
      "lastMove": "c2b3",
      "name": "Avila Pavas, Santiago - Motylev, Alexander",
      "players": [
      {
        "clock": 39700,
        "fed": "COL",
        "fideId": 4437128,
        "name": "Avila Pavas, Santiago",
        "rating": 2516,
        "team": "Colombia",
        "title": "GM"
      },
      {
        "clock": 278600,
        "fed": "ROU",
        "fideId": 4121830,
        "name": "Motylev, Alexander",
        "rating": 2586,
        "team": "Romania",
        "title": "GM"
      }
      ],
      "status": "*",
      "thinkTime": 270
    },
    {
      "fen": "2r5/4p1k1/1p1n2p1/5p1p/3NPPbP/1P2K1P1/8/R4B2 w - - 0 29",
      "id": "mtGxSHlQ",
      "lastMove": "f7f5",
      "name": "Neiksans, Arturs - Suleymenov, Alisher",
      "players": [
      {
        "clock": 107800,
        "fed": "LAT",
        "fideId": 11601388,
        "name": "Neiksans, Arturs",
        "rating": 2585,
        "team": "Latvia",
        "title": "GM"
      },
      {
        "clock": 249100,
        "fed": "KAZ",
        "fideId": 13707833,
        "name": "Suleymenov, Alisher",
        "rating": 2491,
        "team": "Kazakhstan",
        "title": "GM"
      }
      ],
      "status": "*",
      "thinkTime": 157
    },
    {
      "fen": "r4nk1/pp1q1ppp/2p5/1nP5/3P4/3Q1NPP/P2NRP2/6K1 w - - 1 25",
      "id": "UU9GATDJ",
      "lastMove": "d6b5",
      "name": "Atabayev, Saparmyrat - Nesterov, Arseniy",
      "players": [
      {
        "clock": 196100,
        "fed": "TKM",
        "fideId": 14000571,
        "name": "Atabayev, Saparmyrat",
        "rating": 2494,
        "team": "Turkmenistan",
        "title": "GM"
      },
      {
        "clock": 122800,
        "fed": "FID",
        "fideId": 24198455,
        "name": "Nesterov, Arseniy",
        "rating": 2595,
        "team": "FIDE",
        "title": "GM"
      }
      ],
      "status": "*",
      "thinkTime": 19
    },
    {
      "fen": "5k2/1p1R1ppp/1pn5/8/8/P5PP/1r3PB1/6K1 b - - 11 28",
      "id": "aCy7WUXu",
      "lastMove": "h2g1",
      "name": "Tin, Jingyao - Lashkin, Jegor",
      "players": [
      {
        "clock": 157700,
        "fed": "SGP",
        "fideId": 5804418,
        "name": "Tin, Jingyao",
        "rating": 2583,
        "team": "Singapore",
        "title": "GM"
      },
      {
        "clock": 183000,
        "fed": "MDA",
        "fideId": 13907808,
        "name": "Lashkin, Jegor",
        "rating": 2492,
        "team": "Moldova",
        "title": "IM"
      }
      ],
      "status": "*",
      "thinkTime": 46
    },
    {
      "fen": "r2qr1k1/1p2bppp/1n2p1n1/2pp4/p2PP3/P1NP1NPP/1PQBRP2/2R3K1 w - - 0 24",
      "id": "eksbZuIH",
      "lastMove": "c6c5",
      "name": "Warmerdam, Max - Lalit Babu M R",
      "players": [
      {
        "clock": 202200,
        "fed": "NED",
        "fideId": 1048104,
        "name": "Warmerdam, Max",
        "rating": 2577,
        "team": "Netherlands",
        "title": "GM"
      },
      {
        "clock": 110900,
        "fed": "IND",
        "fideId": 5024595,
        "name": "Lalit Babu M R",
        "rating": 2506,
        "team": "India",
        "title": "GM"
      }
      ],
      "status": "*",
      "thinkTime": 19
    },
    {
      "fen": "r4r2/1p1qbpk1/2n1p3/3pP1pP/p2P1Np1/3Q4/PP1B1PK1/R4R2 w - - 0 22",
      "id": "1HIg5pmV",
      "lastMove": "g6g5",
      "name": "Garcia Pantoja, Roberto - Karthik Venkataraman",
      "players": [
      {
        "clock": 87800,
        "fed": "COL",
        "fideId": 3509265,
        "name": "Garcia Pantoja, Roberto",
        "rating": 2502,
        "team": "Colombia",
        "title": "GM"
      },
      {
        "clock": 219200,
        "fed": "IND",
        "fideId": 25006479,
        "name": "Karthik Venkataraman",
        "rating": 2576,
        "team": "India",
        "title": "GM"
      }
      ],
      "status": "*",
      "thinkTime": 78
    },
    {
      "fen": "r3kb1r/pp6/2p3p1/4Pp1p/Pn5P/4B3/1P1NKPP1/R6R w kq - 2 20",
      "id": "9BeCjl6P",
      "lastMove": "d3b4",
      "name": "Brkic, Ante - Oro, Faustino",
      "players": [
      {
        "clock": 174800,
        "fed": "CRO",
        "fideId": 14506688,
        "name": "Brkic, Ante",
        "rating": 2579,
        "team": "Croatia",
        "title": "GM"
      },
      {
        "clock": 155000,
        "fed": "ARG",
        "fideId": 20000197,
        "name": "Oro, Faustino",
        "rating": 2495,
        "team": "Argentina",
        "title": "IM"
      }
      ],
      "status": "*",
      "thinkTime": 426
    },
    {
      "fen": "2r5/6pp/2nB1p2/2Pk4/1p3P2/3K4/6PP/R7 b - - 0 34",
      "id": "zTOdyJ9Q",
      "lastMove": "f2f4",
      "name": "Parligras, Mircea-Emilian - Fier, Alexandr",
      "players": [
      {
        "clock": 13400,
        "fed": "ROU",
        "fideId": 1204297,
        "name": "Parligras, Mircea-Emilian",
        "rating": 2510,
        "team": "Romania",
        "title": "GM"
      },
      {
        "clock": 360900,
        "fed": "BRA",
        "fideId": 2107139,
        "name": "Fier, Alexandr",
        "rating": 2553,
        "team": "Brazil",
        "title": "GM"
      }
      ],
      "status": "*",
      "thinkTime": 0
    },
    {
      "fen": "3r1bk1/pn3rpp/5p2/q1p1pQ2/2R1N2P/1P1P4/PB1P1PP1/R5K1 b - - 0 24",
      "id": "E52QwMcF",
      "lastMove": "h2h4",
      "name": "Lupulescu, Constantin - Blohberger, Felix",
      "players": [
      {
        "clock": 207400,
        "fed": "ROU",
        "fideId": 1207822,
        "name": "Lupulescu, Constantin",
        "rating": 2592,
        "team": "Romania",
        "title": "GM"
      },
      {
        "clock": 130700,
        "fed": "AUT",
        "fideId": 1632051,
        "name": "Blohberger, Felix",
        "rating": 2510,
        "team": "Austria",
        "title": "GM"
      }
      ],
      "status": "*",
      "thinkTime": 240
    },
    {
      "id": "0Fg4DK3g",
      "name": "Ghazarian, Kirk - Petrov, Nikita",
      "players": [
      {
        "fed": "USA",
        "fideId": 30908604,
        "name": "Ghazarian, Kirk",
        "rating": 2520,
        "team": "USA",
        "title": "GM"
      },
      {
        "fed": "MNE",
        "fideId": 4101286,
        "name": "Petrov, Nikita",
        "rating": 2582,
        "team": "Montenegro",
        "title": "GM"
      }
      ],
      "status": "0-1"
    },
    {
      "fen": "3q2k1/p1p2ppp/QpBb1n2/3p4/P2P4/1P3P1P/2P2P2/2B3K1 b - - 7 26",
      "id": "eZXCBySC",
      "lastMove": "e2a6",
      "name": "Bartel, Mateusz - Aronyak Ghosh",
      "players": [
      {
        "clock": 164800,
        "fed": "POL",
        "fideId": 1112635,
        "name": "Bartel, Mateusz",
        "rating": 2575,
        "team": "Poland",
        "title": "GM"
      },
      {
        "clock": 196800,
        "fed": "IND",
        "fideId": 25072846,
        "name": "Aronyak Ghosh",
        "rating": 2520,
        "team": "India",
        "title": "IM"
      }
      ],
      "status": "*",
      "thinkTime": 354
    },
    {
      "fen": "r4rk1/pp1n2pp/1qp4n/3pp3/1P1P1P2/4BB1P/P5P1/1R1Q1RK1 w - - 0 19",
      "id": "jyJ7qRZm",
      "lastMove": "d8b6",
      "name": "Galaviz Medina, Sion Radamantys - Supi, Luis Paulo",
      "players": [
      {
        "clock": 120500,
        "fed": "MEX",
        "fideId": 5123119,
        "name": "Galaviz Medina, Sion Radamantys",
        "rating": 2512,
        "team": "Mexico",
        "title": "IM"
      },
      {
        "clock": 162000,
        "fed": "BRA",
        "fideId": 2106388,
        "name": "Supi, Luis Paulo",
        "rating": 2575,
        "team": "Brazil",
        "title": "GM"
      }
      ],
      "status": "*",
      "thinkTime": 10
    },
    {
      "fen": "r2k1b1r/pp1npQp1/2pq4/3p2Bp/3p2PP/5P2/PPPRN3/2K4R w - - 0 17",
      "id": "t5CM3TXY",
      "lastMove": "e5d4",
      "name": "Jobava, Baadur - Cardoso Cardoso, Jose Gabriel",
      "players": [
      {
        "clock": 67100,
        "fed": "GEO",
        "fideId": 13601520,
        "name": "Jobava, Baadur",
        "rating": 2577,
        "team": "Georgia",
        "title": "GM"
      },
      {
        "clock": 215500,
        "fed": "COL",
        "fideId": 4430492,
        "name": "Cardoso Cardoso, Jose Gabriel",
        "rating": 2527,
        "team": "Colombia",
        "title": "GM"
      }
      ],
      "status": "*",
      "thinkTime": 131
    },
    {
      "fen": "3qr1k1/1pp2pp1/1p1p3p/1P2r3/PP2P3/3QR2P/5PP1/4R1K1 w - - 1 28",
      "id": "NgFe1oCJ",
      "lastMove": "h4d8",
      "name": "Peng, Xiongjian - Ghosh, Diptayan",
      "players": [
      {
        "clock": 276700,
        "fed": "CHN",
        "fideId": 8610550,
        "name": "Peng, Xiongjian",
        "rating": 2520,
        "team": "China",
        "title": "GM"
      },
      {
        "clock": 81200,
        "fed": "IND",
        "fideId": 5045207,
        "name": "Ghosh, Diptayan",
        "rating": 2573,
        "team": "India",
        "title": "GM"
      }
      ],
      "status": "*",
      "thinkTime": 231
    },
    {
      "fen": "3rr1k1/1p3p1p/p1pBbqpb/8/4P2P/2N3Q1/PPR2PP1/3R2K1 b - - 0 25",
      "id": "lZsygAi0",
      "lastMove": "h2h4",
      "name": "Ganguly, Surya Shekhar - Ahmadzada, Ahmad",
      "players": [
      {
        "clock": 221300,
        "fed": "IND",
        "fideId": 5002150,
        "name": "Ganguly, Surya Shekhar",
        "rating": 2559,
        "team": "India",
        "title": "GM"
      },
      {
        "clock": 115300,
        "fed": "AZE",
        "fideId": 13413007,
        "name": "Ahmadzada, Ahmad",
        "rating": 2530,
        "team": "Azerbaijan",
        "title": "GM"
      }
      ],
      "status": "*",
      "thinkTime": 164
    },
    {
      "fen": "r2q4/1p1nrpk1/2p3p1/p1Rp3p/P2P4/3QP2P/1P1N1PP1/1R4K1 w - - 3 26",
      "id": "2SJGGiA4",
      "lastMove": "f6d7",
      "name": "Samadov, Read - Lodici, Lorenzo",
      "players": [
      {
        "clock": 149700,
        "fed": "AZE",
        "fideId": 13417444,
        "name": "Samadov, Read",
        "rating": 2513,
        "team": "Azerbaijan",
        "title": "IM"
      },
      {
        "clock": 192900,
        "fed": "ITA",
        "fideId": 884189,
        "name": "Lodici, Lorenzo",
        "rating": 2572,
        "team": "Italy",
        "title": "GM"
      }
      ],
      "status": "*",
      "thinkTime": 195
    },
    {
      "fen": "r4rk1/1p1q2bp/pBn1pn2/3p1p2/8/2N3Q1/PPP1BPPP/3R1RK1 b - - 1 18",
      "id": "H9Le8xdC",
      "lastMove": "c7b6",
      "name": "Kantor, Gergely - Rodrigue-Lemieux, Shawn",
      "players": [
      {
        "clock": 132600,
        "fed": "HUN",
        "fideId": 751499,
        "name": "Kantor, Gergely",
        "rating": 2546,
        "team": "Hungary",
        "title": "GM"
      },
      {
        "clock": 159200,
        "fed": "CAN",
        "fideId": 2620049,
        "name": "Rodrigue-Lemieux, Shawn",
        "rating": 2521,
        "team": "Canada",
        "title": "GM"
      }
      ],
      "status": "*",
      "thinkTime": 134
    },
    {
      "fen": "2rr1nk1/pp3ppp/2pbn3/3p1BP1/3P3P/2P1RQ2/PP3P2/4R1K1 b - - 2 27",
      "id": "bx1cB3R9",
      "lastMove": "c2f5",
      "name": "Makhnev, Denis - Flores, Diego",
      "players": [
      {
        "clock": 201000,
        "fed": "KAZ",
        "fideId": 13707647,
        "name": "Makhnev, Denis",
        "rating": 2525,
        "team": "Kazakhstan",
        "title": "GM"
      },
      {
        "clock": 132700,
        "fed": "ARG",
        "fideId": 108049,
        "name": "Flores, Diego",
        "rating": 2563,
        "team": "Argentina",
        "title": "GM"
      }
      ],
      "status": "*",
      "thinkTime": 10
    },
    {
      "fen": "4rrk1/bppb1ppp/p7/3P2q1/1p2RB2/P4Q1P/2BP1PP1/5RK1 b - - 7 20",
      "id": "7QUUFUuL",
      "lastMove": "e5f4",
      "name": "Piorun, Kacper - Lobanov, Sergei",
      "players": [
      {
        "clock": 184800,
        "fed": "POL",
        "fideId": 1130420,
        "name": "Piorun, Kacper",
        "rating": 2557,
        "team": "Poland",
        "title": "GM"
      },
      {
        "clock": 121800,
        "fed": "FID",
        "fideId": 24183750,
        "name": "Lobanov, Sergei",
        "rating": 2526,
        "team": "FIDE",
        "title": "GM"
      }
      ],
      "status": "*",
      "thinkTime": 164
    },
    {
      "fen": "r3k1r1/1b1qb3/2p1p3/1p2B1p1/p1pPP2P/P1N5/1P2Q3/2KR3R w q - 0 24",
      "id": "r77RGApY",
      "lastMove": "f6g5",
      "name": "Velten, Paul - Kovalev, Vladislav",
      "players": [
      {
        "clock": 164200,
        "fed": "FRA",
        "fideId": 681091,
        "name": "Velten, Paul",
        "rating": 2530,
        "team": "France",
        "title": "GM"
      },
      {
        "clock": 169700,
        "fed": "FID",
        "fideId": 13504398,
        "name": "Kovalev, Vladislav",
        "rating": 2557,
        "team": "FIDE",
        "title": "GM"
      }
      ],
      "status": "*",
      "thinkTime": 227
    },
    {
      "check": "+",
      "fen": "3r1rk1/pp4b1/4Q2p/n7/8/q3PN2/P4PPP/3R1RK1 b - - 10 26",
      "id": "w61lNkw5",
      "lastMove": "e4e6",
      "name": "Bogner, Sebastian - Stremavicius, Titas",
      "players": [
      {
        "clock": 339900,
        "fed": "SUI",
        "fideId": 4692055,
        "name": "Bogner, Sebastian",
        "rating": 2552,
        "team": "Switzerland",
        "title": "GM"
      },
      {
        "clock": 492800,
        "fed": "LTU",
        "fideId": 12804444,
        "name": "Stremavicius, Titas",
        "rating": 2544,
        "team": "Lithuania",
        "title": "GM"
      }
      ],
      "status": "½-½"
    },
    {
      "fen": "1r3rk1/4qpb1/2np2pp/p1p1p3/2P5/BPNP2PP/4PPK1/1R1Q1R2 w - - 1 23",
      "id": "ZKip1x3M",
      "lastMove": "b4c6",
      "name": "Maksimovic, Bojan - Can, Emre",
      "players": [
      {
        "clock": 201300,
        "fed": "BIH",
        "fideId": 14408120,
        "name": "Maksimovic, Bojan",
        "rating": 2532,
        "team": "Bosnia & Herzegovina",
        "title": "IM"
      },
      {
        "clock": 138100,
        "fed": "TUR",
        "fideId": 6302181,
        "name": "Can, Emre",
        "rating": 2541,
        "team": "Türkiye",
        "title": "GM"
      }
      ],
      "status": "*",
      "thinkTime": 330
    },
    {
      "fen": "3r2k1/2p1npp1/2n1q2p/3pPb2/Qr3B2/N5P1/PP2PPBP/2RR2K1 w - - 11 24",
      "id": "y4RGvVxj",
      "lastMove": "b6b4",
      "name": "Subelj, Jan - Kuybokarov, Temur",
      "players": [
      {
        "clock": 169600,
        "fed": "SLO",
        "fideId": 14618583,
        "name": "Subelj, Jan",
        "rating": 2532,
        "team": "Slovenia",
        "title": "GM"
      },
      {
        "clock": 179300,
        "fed": "AUS",
        "fideId": 14203049,
        "name": "Kuybokarov, Temur",
        "rating": 2535,
        "team": "Australia",
        "title": "GM"
      }
      ],
      "status": "½-½"
    },
    {
      "fen": "r4k1r/2qn1p2/p2p1bp1/1p1Pp3/PQ3n1p/2P2P2/1P1N1BPP/3RRBK1 b - - 0 21",
      "id": "J6sQAJeg",
      "lastMove": "a2a4",
      "name": "Petrov, Martin - Mekhitarian, Krikor Sevag",
      "players": [
      {
        "clock": 252500,
        "fed": "BUL",
        "fideId": 2911086,
        "name": "Petrov, Martin",
        "rating": 2548,
        "team": "Bulgaria",
        "title": "GM"
      },
      {
        "clock": 73300,
        "fed": "BRA",
        "fideId": 2107660,
        "name": "Mekhitarian, Krikor Sevag",
        "rating": 2545,
        "team": "Brazil",
        "title": "GM"
      }
      ],
      "status": "*",
      "thinkTime": 294
    },
    {
      "fen": "2krrn2/2p3p1/ppb2p2/2p4p/4PP2/P1N4P/1PPBR1P1/4R1K1 w - - 8 22",
      "id": "lnNJMr1W",
      "lastMove": "g6f8",
      "name": "Nogerbek, Kazybek - Raja Rithvik R",
      "players": [
      {
        "clock": 174800,
        "fed": "KAZ",
        "fideId": 13710427,
        "name": "Nogerbek, Kazybek",
        "rating": 2538,
        "team": "Kazakhstan",
        "title": "GM"
      },
      {
        "clock": 125400,
        "fed": "IND",
        "fideId": 35007394,
        "name": "Raja Rithvik R",
        "rating": 2541,
        "team": "India",
        "title": "GM"
      }
      ],
      "status": "*",
      "thinkTime": 10
    }
  ]
}
''';

const _livePlayersResponse = '''
[
  {
    "name": "Carlsen, Magnus",
    "title": "GM",
    "rating": 2890,
    "fideId": 1503014,
    "fed": "NOR",
    "played": 5,
    "score": 3
  },
  {
    "name": "Nepomniachtchi, Ian",
    "title": "GM",
    "rating": 2770,
    "fideId": 4168119,
    "fed": "RUS",
    "played": 4,
    "score": 1
  }
]
''';

const _livePlayersWithoutScoresResponse = '''
[
  {
    "name": "Carlsen, Magnus",
    "title": "GM",
    "rating": 2890,
    "fideId": 1503014,
    "fed": "NOR",
    "played": 5
  },
  {
    "name": "Nepomniachtchi, Ian",
    "title": "GM",
    "rating": 2770,
    "fideId": 4168119,
    "fed": "RUS",
    "played": 4
  }
]
''';

final _liveTeamBroadcastClient = MockClient((request) {
  if (request.url.path == '/api/broadcast/AAAAAAAA') {
    return mockResponse(
      _liveTeamTournamentResponse,
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }
  if (request.url.path == '/api/broadcast/-/-/00000000') {
    return mockResponse(
      _liveRoundResponse,
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }
  if (request.url.path == '/broadcast/AAAAAAAA/players') {
    return mockResponse(
      _livePlayersResponse,
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }
  if (request.url.path == '/broadcast/00000000/teams') {
    return mockResponse(
      _teamMatchesResponse,
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }
  return mockResponse('', 404);
});

const _liveTeamTournamentResponse = '''
{
  "tour": {
    "id": "AAAAAAAA",
    "name": "Test tournament",
    "slug": "test-tournament",
    "dates": [
      1735671720000
    ],
    "image": "",
    "teamTable": true
  },
  "rounds": [
    {
      "id": "00000000",
      "name": "Test round",
      "slug": "test-round",
      "ongoing": "true"
    }
  ],
  "defaultRoundId": "00000000"
}
''';

final _liveTeamBroadcast = Broadcast(
  tour: BroadcastTournamentData(
    id: const BroadcastTournamentId('AAAAAAAA'),
    name: 'Test tournament',
    slug: 'test-tournament',
    imageUrl: '',
    description: null,
    tier: null,
    teamTable: true,
    information: (
      dates: (startsAt: DateTime.fromMillisecondsSinceEpoch(1735671720000), endsAt: null),
      format: null,
      location: null,
      players: null,
      website: null,
      standings: null,
      timeControl: null,
    ),
  ),
  round: const BroadcastRound(
    id: BroadcastRoundId('00000000'),
    name: 'Test round',
    slug: 'test-round',
    status: RoundStatus.live,
    startsAt: null,
    finishedAt: null,
    startsAfterPrevious: false,
  ),
  roundToLinkId: const BroadcastRoundId('00000000'),
  group: null,
);

const _teamMatchesResponse = '''
{
  "table": [
    {
      "teams": [
        {"name": "Team A", "points": 1},
        {"name": "Team B", "points": 0}
      ],
      "games": [
        {"id": "111111", "pov": "white"},
        {"id": "222222", "pov": "black"}
      ]
    },
    {
      "teams": [
        {"name": "Team C", "points": 0.5},
        {"name": "Team D", "points": 1.5}
      ],
      "games": [
        {"id": "3333333", "pov": "white"},
        {"id": "4444444", "pov": "black"}
      ]
    }
  ]
}
''';
