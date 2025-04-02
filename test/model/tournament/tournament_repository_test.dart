import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/tournament/tournament.dart';
import 'package:lichess_mobile/src/model/tournament/tournament_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../test_container.dart';
import '../../test_helpers.dart';

void main() {
  Future<ProviderContainer> makeTestContainer(MockClient mockClient) {
    return makeContainer(
      overrides: [
        lichessClientProvider.overrideWith((ref) {
          return LichessClient(mockClient, ref);
        }),
      ],
    );
  }

  group('TournamentRepository.getStudy', () {
    test('correctly parse tournament JSON', () async {
      // curl -X GET https://lichess.org/study/JbWtuaeK/7OJXp679\?chapters\=1 -H "Accept: application/json" | sed "s/\\\\n/ /g" | jq 'del(.study.chat)'
      const response = '''
          {
  "nbPlayers": 53,
  "duels": [
    {
      "id": "m9HZsaBd",
      "p": [
        {
          "n": "harrylime0",
          "r": 1295,
          "k": 1
        },
        {
          "n": "Joanettp",
          "r": 1282,
          "k": 19
        }
      ]
    },
    {
      "id": "p8N675oI",
      "p": [
        {
          "n": "jacekspolny",
          "r": 1250,
          "k": 12
        },
        {
          "n": "Davidnanito",
          "r": 1294,
          "k": 2
        }
      ]
    },
    {
      "id": "SlXkVkel",
      "p": [
        {
          "n": "onwardknave",
          "r": 1250,
          "k": 2
        },
        {
          "n": "Mkhululi17",
          "r": 1265,
          "k": 6
        }
      ]
    },
    {
      "id": "p3ER5iNk",
      "p": [
        {
          "n": "Garking",
          "r": 1200,
          "k": 24
        },
        {
          "n": "Orko_22",
          "r": 1243,
          "k": 23
        }
      ]
    },
    {
      "id": "LpAH4xoY",
      "p": [
        {
          "n": "PeoncitoPortenio",
          "r": 1251,
          "k": 35
        },
        {
          "n": "kolm_1983_va",
          "r": 1181,
          "k": 36
        }
      ]
    },
    {
      "id": "MtoRlgFQ",
      "p": [
        {
          "n": "dmitrij96",
          "r": 1234,
          "k": 9
        },
        {
          "n": "seba-85",
          "r": 1171,
          "k": 8
        }
      ]
    }
  ],
  "secondsToFinish": 2744,
  "isStarted": true,
  "featured": {
    "id": "SlXkVkel",
    "fen": "r3kb1r/1q4pp/p1b1p3/1pppNnB1/3P4/2P5/PP3PPP/R2QRNK1 w",
    "orientation": "black",
    "color": "black",
    "lastMove": "f7b7",
    "white": {
      "name": "onwardknave",
      "id": "onwardknave",
      "rank": 4,
      "rating": 1250
    },
    "black": {
      "name": "Mkhululi17",
      "id": "mkhululi17",
      "rank": 6,
      "rating": 1265
    },
    "c": {
      "white": 124,
      "black": 136
    }
  },
  "standing": {
    "page": 1,
    "players": [
      {
        "name": "harrylime0",
        "rank": 1,
        "rating": 1295,
        "score": 4,
        "sheet": {
          "scores": "22",
          "fire": true
        }
      },
      {
        "name": "Davidnanito",
        "rank": 2,
        "rating": 1294,
        "score": 4,
        "sheet": {
          "scores": "22",
          "fire": true
        }
      },
      {
        "name": "Max07122024",
        "flair": "people.man-genie",
        "rank": 3,
        "rating": 1178,
        "score": 4,
        "sheet": {
          "scores": "22",
          "fire": true
        }
      },
      {
        "name": "onwardknave",
        "rank": 4,
        "rating": 1250,
        "score": 4,
        "sheet": {
          "scores": "220",
          "fire": true
        }
      },
      {
        "name": "Semester5670_90-7",
        "rank": 5,
        "rating": 1117,
        "score": 4,
        "sheet": {
          "scores": "22",
          "fire": true
        }
      },
      {
        "name": "Mkhululi17",
        "rank": 6,
        "rating": 1265,
        "score": 2,
        "sheet": {
          "scores": "2"
        }
      },
      {
        "name": "toshevnikola",
        "rank": 7,
        "rating": 1210,
        "score": 2,
        "sheet": {
          "scores": "2"
        },
        "withdraw": true
      },
      {
        "name": "Dr-Borya",
        "rank": 8,
        "rating": 1185,
        "score": 2,
        "sheet": {
          "scores": "2"
        }
      },
      {
        "name": "seba-85",
        "rank": 9,
        "rating": 1171,
        "score": 2,
        "sheet": {
          "scores": "2"
        }
      },
      {
        "name": "dmitrij96",
        "rank": 10,
        "rating": 1234,
        "score": 2,
        "sheet": {
          "scores": "2"
        }
      }
    ]
  },
  "id": "82QbxlJb",
  "createdBy": "lichess",
  "startsAt": "2025-04-01T17:00:25Z",
  "system": "arena",
  "fullName": "<=1300 SuperBlitz Arena",
  "minutes": 57,
  "perf": {
    "key": "blitz",
    "name": "Blitz",
    "icon": ")"
  },
  "clock": {
    "limit": 180,
    "increment": 0
  },
  "variant": "standard",
  "rated": true,
  "verdicts": {
    "list": [
      {
        "condition": ">= 20 Blitz rated games",
        "verdict": "ok"
      },
      {
        "condition": "Rated <= 1300 in Blitz for the last week",
        "verdict": "ok"
      }
    ],
    "accepted": true
  },
  "schedule": {
    "freq": "hourly",
    "speed": "superBlitz"
  },
  "maxRating": {
    "rating": 1300
  },
  "minRatedGames": {
    "nb": 20
  },
  "reloadEndpoint": "https://http.lichess.org/tournament/82QbxlJb"
}
''';

      const reloadResponse = '''
{
  "nbPlayers": 87,
  "duels": [
    {
      "id": "CW8jtJJO",
      "p": [
        {
          "n": "PeoncitoPortenio",
          "r": 1278,
          "k": 2
        },
        {
          "n": "Gerogr1231",
          "r": 1261,
          "k": 3
        }
      ]
    },
    {
      "id": "aMBfqqxS",
      "p": [
        {
          "n": "yusufmert0",
          "r": 1262,
          "k": 3
        },
        {
          "n": "IlyaVIvanov",
          "r": 1240,
          "k": 22
        }
      ]
    },
    {
      "id": "NKyiBqPJ",
      "p": [
        {
          "n": "Davidnanito",
          "r": 1342,
          "k": 1
        },
        {
          "n": "FridayKnight",
          "r": 1155,
          "k": 6
        }
      ]
    },
    {
      "id": "9QTkAh8o",
      "p": [
        {
          "n": "Michigian",
          "r": 1214,
          "k": 39
        },
        {
          "n": "LA231",
          "r": 1276,
          "k": 12
        }
      ]
    },
    {
      "id": "H5pEQ5wi",
      "p": [
        {
          "n": "sunshine2331",
          "r": 1227,
          "k": 41
        },
        {
          "n": "PabloLegui",
          "r": 1249,
          "k": 64
        }
      ]
    },
    {
      "id": "0LSBMRcQ",
      "p": [
        {
          "n": "Valik1402",
          "r": 1229,
          "k": 11
        },
        {
          "n": "toshevnikola",
          "r": 1212,
          "k": 18
        }
      ]
    }
  ],
  "secondsToFinish": 1063,
  "isStarted": true,
  "featured": {
    "id": "CW8jtJJO",
    "fen": "r4rk1/pp3p1p/3pq1p1/2p5/3pP3/P2P3P/1PP2PP1/R2Q1RK1 w",
    "orientation": "white",
    "color": "white",
    "lastMove": "e8h8",
    "white": {
      "name": "PeoncitoPortenio",
      "id": "peoncitoportenio",
      "rank": 2,
      "rating": 1278
    },
    "black": {
      "name": "Gerogr1231",
      "id": "gerogr1231",
      "rank": 4,
      "rating": 1261
    },
    "c": {
      "white": 148,
      "black": 151
    }
  },
  "standing": {
    "page": 1,
    "players": [
      {
        "name": "Davidnanito",
        "rank": 1,
        "rating": 1342,
        "score": 24,
        "sheet": {
          "scores": "4444422",
          "fire": true
        }
      },
      {
        "name": "PeoncitoPortenio",
        "rank": 2,
        "rating": 1278,
        "score": 20,
        "sheet": {
          "scores": "4444220",
          "fire": true
        }
      },
      {
        "name": "yusufmert0",
        "flair": "activity.1st-place-medal",
        "rank": 3,
        "rating": 1262,
        "score": 18,
        "sheet": {
          "scores": "24422022"
        }
      },
      {
        "name": "Gerogr1231",
        "rank": 4,
        "rating": 1261,
        "score": 17,
        "sheet": {
          "scores": "210442202"
        }
      },
      {
        "name": "onwardknave",
        "rank": 5,
        "rating": 1249,
        "score": 16,
        "sheet": {
          "scores": "2020044220"
        }
      },
      {
        "name": "Natan221013",
        "flair": "smileys.clown-face",
        "rank": 6,
        "rating": 1078,
        "score": 16,
        "sheet": {
          "scores": "200442202"
        },
        "withdraw": true
      },
      {
        "name": "Semester5670_90-7",
        "rank": 7,
        "rating": 1125,
        "score": 16,
        "sheet": {
          "scores": "0020024422"
        }
      },
      {
        "name": "FridayKnight",
        "rank": 8,
        "rating": 1155,
        "score": 14,
        "sheet": {
          "scores": "0442202"
        }
      },
      {
        "name": "dmitrij96",
        "rank": 9,
        "rating": 1231,
        "score": 13,
        "sheet": {
          "scores": "01004422"
        },
        "withdraw": true
      },
      {
        "name": "RyZe_Random",
        "flair": "smileys.alien",
        "rank": 10,
        "rating": 1280,
        "score": 12,
        "sheet": {
          "scores": "4422",
          "fire": true
        },
        "withdraw": true
      }
    ]
  }
}
''';

      final mockClient = MockClient((request) {
        if (request.url.path == '/api/tournament/82QbxlJb') {
          return mockResponse(response, 200);
        }
        // Should use the reloadEndpoint field to reload the tournament
        if (request.url.path == '/https%253A//http.lichess.org/tournament/82QbxlJb' &&
            request.url.queryParameters['partial'] == 'true') {
          return mockResponse(reloadResponse, 200);
        }
        return mockResponse('', 404);
      });

      final container = await makeTestContainer(mockClient);
      final repo = container.read(tournamentRepositoryProvider);

      final tournament = await repo.getTournament(const TournamentId('82QbxlJb'));

      expect(
        tournament,
        Tournament(
          id: const TournamentId('82QbxlJb'),
          createdBy: 'lichess',
          timeIncrement: const TimeIncrement(180, 0),
          perf: Perf.blitz,
          variant: Variant.standard,
          berserkable: false,
          featuredGame: const FeaturedGame(
            id: GameId('SlXkVkel'),
            white: FeaturedPlayer(
              user: LightUser(id: UserId('onwardknave'), name: 'onwardknave'),
              rank: 4,
              berserk: null,
            ),
            black: FeaturedPlayer(
              user: LightUser(id: UserId('mkhululi17'), name: 'Mkhululi17'),
              rank: 6,
              berserk: null,
            ),
            orientation: Side.black,
            fen: 'r3kb1r/1q4pp/p1b1p3/1pppNnB1/3P4/2P5/PP3PPP/R2QRNK1 w',
            lastMove: NormalMove(from: Square.f7, to: Square.b7),
            finished: null,
            winner: null,
          ),
          fullName: '<=1300 SuperBlitz Arena',
          description: null,
          isFinished: null,
          isStarted: true,
          timeToStart: null,
          timeToFinish: const Duration(seconds: 2744),
          me: null,
          nbPlayers: 53,
          standing: (
            page: 1,
            players:
                [
                  StandingPlayer(
                    user: const LightUser(id: UserId('harrylime0'), name: 'harrylime0'),
                    rating: 1295,
                    provisional: false,
                    score: 4,
                    sheet: (fire: true, scores: [2, 2].toIList()),
                    withdraw: false,
                  ),
                  StandingPlayer(
                    user: const LightUser(id: UserId('davidnanito'), name: 'Davidnanito'),
                    rating: 1294,
                    provisional: false,
                    score: 4,
                    sheet: (fire: true, scores: [2, 2].toIList()),
                    withdraw: false,
                  ),
                  StandingPlayer(
                    user: const LightUser(
                      id: UserId('max07122024'),
                      name: 'Max07122024',
                      flair: 'people.man-genie',
                    ),
                    rating: 1178,
                    provisional: false,
                    score: 4,
                    sheet: (fire: true, scores: [2, 2].toIList()),
                    withdraw: false,
                  ),
                  StandingPlayer(
                    user: const LightUser(id: UserId('onwardknave'), name: 'onwardknave'),
                    rating: 1250,
                    provisional: false,
                    score: 4,
                    sheet: (fire: true, scores: [2, 2, 0].toIList()),
                    withdraw: false,
                  ),
                  StandingPlayer(
                    user: const LightUser(
                      id: UserId('semester5670_90-7'),
                      name: 'Semester5670_90-7',
                    ),
                    rating: 1117,
                    provisional: false,
                    score: 4,
                    sheet: (fire: true, scores: [2, 2].toIList()),
                    withdraw: false,
                  ),
                  StandingPlayer(
                    user: const LightUser(id: UserId('mkhululi17'), name: 'Mkhululi17'),
                    rating: 1265,
                    provisional: false,
                    score: 2,
                    sheet: (fire: false, scores: [2].toIList()),
                    withdraw: false,
                  ),
                  StandingPlayer(
                    user: const LightUser(id: UserId('toshevnikola'), name: 'toshevnikola'),
                    rating: 1210,
                    provisional: false,
                    score: 2,
                    sheet: (fire: false, scores: [2].toIList()),
                    withdraw: true,
                  ),
                  StandingPlayer(
                    user: const LightUser(id: UserId('dr-borya'), name: 'Dr-Borya'),
                    rating: 1185,
                    provisional: false,
                    score: 2,
                    sheet: (fire: false, scores: [2].toIList()),
                    withdraw: false,
                  ),
                  StandingPlayer(
                    user: const LightUser(id: UserId('seba-85'), name: 'seba-85'),
                    rating: 1171,
                    provisional: false,
                    score: 2,
                    sheet: (fire: false, scores: [2].toIList()),
                    withdraw: false,
                  ),
                  StandingPlayer(
                    user: const LightUser(id: UserId('dmitrij96'), name: 'dmitrij96'),
                    rating: 1234,
                    provisional: false,
                    score: 2,
                    sheet: (fire: false, scores: [2].toIList()),
                    withdraw: false,
                  ),
                ].toIList(),
          ),
          verdicts: (
            list:
                [
                  (condition: '>= 20 Blitz rated games', ok: true),
                  (condition: 'Rated <= 1300 in Blitz for the last week', ok: true),
                ].toIList(),
            accepted: true,
          ),
          reloadEndpoint: 'https://http.lichess.org/tournament/82QbxlJb',
        ),
      );

      final updatedTournament = await repo.reload(tournament, standingsPage: 1);

      expect(
        updatedTournament,
        tournament.copyWith(
          featuredGame: const FeaturedGame(
            id: GameId('CW8jtJJO'),
            white: FeaturedPlayer(
              user: LightUser(id: UserId('peoncitoportenio'), name: 'PeoncitoPortenio'),
              rank: 2,
              berserk: null,
            ),
            black: FeaturedPlayer(
              user: LightUser(id: UserId('gerogr1231'), name: 'Gerogr1231'),
              rank: 4,
              berserk: null,
            ),
            orientation: Side.white,
            fen: 'r4rk1/pp3p1p/3pq1p1/2p5/3pP3/P2P3P/1PP2PP1/R2Q1RK1 w',
            lastMove: NormalMove(from: Square.e8, to: Square.h8),
            finished: null,
            winner: null,
          ),
          timeToFinish: const Duration(seconds: 1063),
          nbPlayers: 87,
          standing: (
            page: 1,
            players:
                [
                  StandingPlayer(
                    user: const LightUser(id: UserId('davidnanito'), name: 'Davidnanito'),
                    rating: 1342,
                    provisional: false,
                    score: 24,
                    sheet: (fire: true, scores: [4, 4, 4, 4, 4, 2, 2].toIList()),
                    withdraw: false,
                  ),
                  StandingPlayer(
                    user: const LightUser(id: UserId('peoncitoportenio'), name: 'PeoncitoPortenio'),
                    rating: 1278,
                    provisional: false,
                    score: 20,
                    sheet: (fire: true, scores: [4, 4, 4, 4, 2, 2, 0].toIList()),
                    withdraw: false,
                  ),
                  StandingPlayer(
                    user: const LightUser(
                      id: UserId('yusufmert0'),
                      name: 'yusufmert0',
                      flair: 'activity.1st-place-medal',
                    ),
                    rating: 1262,
                    provisional: false,
                    score: 18,
                    sheet: (fire: false, scores: [2, 4, 4, 2, 2, 0, 2, 2].toIList()),
                    withdraw: false,
                  ),
                  StandingPlayer(
                    user: const LightUser(id: UserId('gerogr1231'), name: 'Gerogr1231'),
                    rating: 1261,
                    provisional: false,
                    score: 17,
                    sheet: (fire: false, scores: [2, 1, 0, 4, 4, 2, 2, 0, 2].toIList()),
                    withdraw: false,
                  ),
                  //{
                  //  "name": "onwardknave",
                  //  "rank": 5,
                  //  "rating": 1249,
                  //  "score": 16,
                  //  "sheet": {
                  //    "scores": "2020044220"
                  //  }
                  //},
                  //{
                  //  "name": "Natan221013",
                  //  "flair": "smileys.clown-face",
                  //  "rank": 6,
                  //  "rating": 1078,
                  //  "score": 16,
                  //  "sheet": {
                  //    "scores": "200442202"
                  //  },
                  //  "withdraw": true
                  //},
                  //{
                  //  "name": "Semester5670_90-7",
                  //  "rank": 7,
                  //  "rating": 1125,
                  //  "score": 16,
                  //  "sheet": {
                  //    "scores": "0020024422"
                  //  }
                  //},
                  //{
                  //  "name": "FridayKnight",
                  //  "rank": 8,
                  //  "rating": 1155,
                  //  "score": 14,
                  //  "sheet": {
                  //    "scores": "0442202"
                  //  }
                  //},
                  //{
                  //  "name": "dmitrij96",
                  //  "rank": 9,
                  //  "rating": 1231,
                  //  "score": 13,
                  //  "sheet": {
                  //    "scores": "01004422"
                  //  },
                  //  "withdraw": true
                  //},
                  //{
                  //  "name": "RyZe_Random",
                  //  "flair": "smileys.alien",
                  //  "rank": 10,
                  //  "rating": 1280,
                  //  "score": 12,
                  //  "sheet": {
                  //    "scores": "4422",
                  //    "fire": true
                  //  },
                  //  "withdraw": true
                  //}
                  StandingPlayer(
                    user: const LightUser(id: UserId('onwardknave'), name: 'onwardknave'),
                    rating: 1249,
                    provisional: false,
                    score: 16,
                    sheet: (fire: false, scores: [2, 0, 2, 0, 0, 4, 4, 2, 2, 0].toIList()),
                    withdraw: false,
                  ),
                  StandingPlayer(
                    user: const LightUser(
                      id: UserId('natan221013'),
                      name: 'Natan221013',
                      flair: 'smileys.clown-face',
                    ),
                    rating: 1078,
                    provisional: false,
                    score: 16,
                    sheet: (fire: false, scores: [2, 0, 0, 4, 4, 2, 2, 0, 2].toIList()),
                    withdraw: true,
                  ),
                  StandingPlayer(
                    user: const LightUser(
                      id: UserId('semester5670_90-7'),
                      name: 'Semester5670_90-7',
                    ),
                    rating: 1125,
                    provisional: false,
                    score: 16,
                    sheet: (fire: false, scores: [0, 0, 2, 0, 0, 2, 4, 4, 2, 2].toIList()),
                    withdraw: false,
                  ),
                  StandingPlayer(
                    user: const LightUser(id: UserId('fridayknight'), name: 'FridayKnight'),
                    rating: 1155,
                    provisional: false,
                    score: 14,
                    sheet: (fire: false, scores: [0, 4, 4, 2, 2, 0, 2].toIList()),
                    withdraw: false,
                  ),
                  StandingPlayer(
                    user: const LightUser(id: UserId('dmitrij96'), name: 'dmitrij96'),
                    rating: 1231,
                    provisional: false,
                    score: 13,
                    sheet: (fire: false, scores: [0, 1, 0, 0, 4, 4, 2, 2].toIList()),
                    withdraw: true,
                  ),
                  StandingPlayer(
                    user: const LightUser(
                      id: UserId('ryze_random'),
                      name: 'RyZe_Random',
                      flair: 'smileys.alien',
                    ),
                    rating: 1280,
                    provisional: false,
                    score: 12,
                    sheet: (fire: true, scores: [4, 4, 2, 2].toIList()),
                    withdraw: true,
                  ),
                ].toIList(),
          ),
        ),
      );
    });
  });
}
