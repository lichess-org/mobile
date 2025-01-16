import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_round_screen.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

final client = MockClient((request) {
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

void main() {
  group('Broadcast round screen', () {
    testWidgets('Check that all tabs are present', variant: kPlatformVariant, (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: BroadcastRoundScreen(broadcast: _finishedBroadcast),
        overrides: [lichessClientProvider.overrideWith((ref) => LichessClient(client, ref))],
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
    });

    testWidgets('Test boards tab with a finished tournament', variant: kPlatformVariant, (
      tester,
    ) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: BroadcastRoundScreen(broadcast: _finishedBroadcast),
        overrides: [lichessClientProvider.overrideWith((ref) => LichessClient(client, ref))],
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

    testWidgets('Test overview tab with an upcoming tournament', variant: kPlatformVariant, (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        final client = MockClient((request) {
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

        final app = await makeTestProviderScopeApp(
          tester,
          home: BroadcastRoundScreen(broadcast: _upcomingBroadcast),
          overrides: [lichessClientProvider.overrideWith((ref) => LichessClient(client, ref))],
        );

        await tester.pumpWidget(app);

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Load the tournament
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Load the overview
        await tester.pump();

        final startsAt = DateTime.fromMillisecondsSinceEpoch(1736526600000);
        final endsAt = DateTime.fromMillisecondsSinceEpoch(1737189000000);
        final f = DateFormat.MMMd();

        expect(find.text('${f.format(startsAt)} - ${f.format(endsAt)}'), findsOneWidget);
        expect(find.text('9-round Swiss'), findsOneWidget);
        expect(find.text('90 min + 30 sec / move'), findsOneWidget);
        expect(find.text('Seville, Spain'), findsOneWidget);
        expect(find.text('Xu, Bonelli, Jacobson'), findsOneWidget);
        expect(find.text('Official website'), findsOneWidget);
        expect(find.text('Standings'), findsOneWidget);
      });
    });

    testWidgets('Test clocks are ticking with a live round', variant: kPlatformVariant, (
      tester,
    ) async {
      final client = MockClient((request) {
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
        return mockResponse('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: BroadcastRoundScreen(broadcast: _liveBroadcast),
        overrides: [lichessClientProvider.overrideWith((ref) => LichessClient(client, ref))],
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
  });
}

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
      "status": "*"
    }
  ]
}
''';
