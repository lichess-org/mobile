import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/study/study.dart';
import 'package:lichess_mobile/src/model/study/study_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../test_container.dart';
import '../../test_helpers.dart';

void main() {
  Future<ProviderContainer> makeTestContainer(MockClient mockClient) async {
    return makeContainer(
      overrides: [
        lichessClientProvider.overrideWith((ref) {
          return LichessClient(mockClient, ref);
        }),
      ],
    );
  }

  group('StudyRepository.getStudy', () {
    test('correctly parse study JSON', () async {
      // curl -X GET https://lichess.org/study/JbWtuaeK/7OJXp679\?chapters\=1 -H "Accept: application/json" | sed "s/\\\\n/ /g" | jq 'del(.study.chat)'
      const response = '''
{
  "study": {
    "id": "JbWtuaeK",
    "name": "How to Solve Puzzles Correctly",
    "members": {
      "kyle-and-jess": {
        "user": {
          "name": "Kyle-and-Jess",
          "flair": "nature.chipmunk",
          "id": "kyle-and-jess"
        },
        "role": "w"
      },
      "jessieu726": {
        "user": {
          "name": "jessieu726",
          "flair": "nature.duck",
          "id": "jessieu726"
        },
        "role": "w"
      },
      "kyle11878": {
        "user": {
          "name": "kyle11878",
          "flair": "activity.lichess-horsey",
          "id": "kyle11878"
        },
        "role": "w"
      }
    },
    "position": {
      "chapterId": "EgqyeQIp",
      "path": ""
    },
    "ownerId": "kyle-and-jess",
    "settings": {
      "explorer": "contributor",
      "description": false,
      "computer": "contributor",
      "chat": "everyone",
      "sticky": false,
      "shareable": "contributor",
      "cloneable": "contributor"
    },
    "visibility": "public",
    "createdAt": 1729286237789,
    "secondsSinceUpdate": 4116,
    "from": "scratch",
    "likes": 29,
    "flair": "activity.puzzle-piece",
    "liked": false,
    "features": {
      "cloneable": false,
      "shareable": false,
      "chat": true
    },
    "topics": [],
    "chapter": {
      "id": "7OJXp679",
      "ownerId": "kyle-and-jess",
      "setup": {
        "variant": {
          "key": "standard",
          "name": "Standard"
        },
        "orientation": "black",
        "fromFen": true
      },
      "tags": [],
      "features": {
        "computer": false,
        "explorer": false
      },
      "gamebook": true
    },
    "chapters": [
      {
        "id": "EgqyeQIp",
        "name": "Introduction"
      },
      {
        "id": "z6tGV47W",
        "name": "Practice Your Thought Process",
        "fen": "2k4r/p1p2p2/1p2b2p/1Pqn2r1/2B5/B1PP4/P4PPP/RN2Q1K1 b - - 6 20",
        "orientation": "black"
      },
      {
        "id": "dTfxbccx",
        "name": "Practice Strategic Thinking",
        "fen": "r3r1k1/1b2b2p/pq4pB/1p3pN1/2p5/2P5/PPn1QPPP/3RR1K1 w - - 0 23"
      },
      {
        "id": "B1U4pFdG",
        "name": "Calculate Fully",
        "fen": "3r3r/1Rpk1p2/2p2q1p/Q2pp3/P2PP1n1/2P1B1Pp/5P2/1N3RK1 b - - 2 26",
        "orientation": "black"
      },
      {
        "id": "NJLW7jil",
        "name": "Calculate Freely",
        "fen": "4k3/8/6p1/R1p1r1n1/P3Pp2/2N2r2/1PP1K1R1/8 b - - 2 39",
        "orientation": "black"
      },
      {
        "id": "7OJXp679",
        "name": "Use a Timer",
        "fen": "r5k1/ppp2ppp/7r/4Nb2/3P4/1QN1PPq1/PP2B1P1/R4RK1 b - - 1 20",
        "orientation": "black"
      },
      {
        "id": "Rgk6UlTP",
        "name": "Understand Your Mistakes",
        "fen": "r4rk1/1R3pb1/pR2N1p1/2q5/4p3/2P1P1Pp/Q2P1P1P/6K1 b - - 1 26",
        "orientation": "black"
      },
      {
        "id": "VsdxmjCf",
        "name": "Adjusting Difficulty",
        "fen": "3r4/k1pq1p1r/pp1p2p1/8/3P4/P1P2BP1/1P1N1Pp1/R3R1K1 b - - 0 1",
        "orientation": "black"
      },
      {
        "id": "FHU6xhYs",
        "name": "Using Themes",
        "fen": "r2k3N/pbpp1Bpp/1p6/2b1p3/3n3q/P7/1PPP1RPP/RNB2QK1 b - - 3 12",
        "orientation": "black"
      },
      {
        "id": "8FhO455h",
        "name": "Endurance Training",
        "fen": "8/1p5k/2qPQ2p/p5p1/5r1n/2B4P/5P2/4R1K1 w - - 3 41"
      },
      {
        "id": "jWUEWsEf",
        "name": "Final Thoughts",
        "fen": "8/1PP2PP1/PppPPppP/Pp1pp1pP/Pp4pP/1Pp2pP1/2PppP2/3PP3 w - - 0 1"
      }
    ],
    "federations": {}
  },
  "analysis": {
    "game": {
      "id": "synthetic",
      "variant": {
        "key": "standard",
        "name": "Standard",
        "short": "Std"
      },
      "opening": null,
      "fen": "r5k1/ppp2ppp/7r/4Nb2/3P4/1QN1PPq1/PP2B1P1/R4RK1 b - - 1 20",
      "turns": 39,
      "player": "black",
      "status": {
        "id": 10,
        "name": "created"
      },
      "initialFen": "r5k1/ppp2ppp/7r/4Nb2/3P4/1QN1PPq1/PP2B1P1/R4RK1 b - - 1 20"
    },
    "player": {
      "id": null,
      "color": "black"
    },
    "opponent": {
      "color": "white",
      "ai": null
    },
    "orientation": "black",
    "pref": {
      "animationDuration": 300,
      "coords": 1,
      "moveEvent": 2,
      "showCaptured": true,
      "keyboardMove": false,
      "rookCastle": true,
      "highlight": true,
      "destination": true
    },
    "userAnalysis": true,
    "treeParts": [
      {
        "ply": 39,
        "fen": "r5k1/ppp2ppp/7r/4Nb2/3P4/1QN1PPq1/PP2B1P1/R4RK1 b - - 1 20",
        "comments": [
          {
            "id": "4nZ6",
            "text": "Using a timer can be great during puzzle solving, and I don't mean timing yourself to solve quickly. What I mean is setting a timer that restricts when you're allowed to play a move. Start with a minute or two (for more difficult puzzles; if you're solving easy puzzles, you don't need the timer) and calculate the entire time. When you're solving even harder puzzles, set an even longer timer (5-10 minutes maybe). Practice pushing calculations further and looking at different lines during that time (for very difficult puzzles, you should have plenty to calculate). This is to train yourself to take time during important moments, instead of rushing through the position. Set a timer for one to two minutes and calculate this position as black as fully as you can.",
            "by": {
              "id": "kyle-and-jess",
              "name": "Kyle-and-Jess"
            }
          }
        ],
        "gamebook": {
          "hint": "The white king is not very safe. Can black increase the pressure on the king?"
        },
        "dests": "456789 LbktxCESUZ6 wenopvxDEFKMU WGO YIQ 2MU XHP VhpxFNOPQRSTU !9?"
      },
      {
        "ply": 40,
        "fen": "r5k1/ppp2ppp/8/4Nb2/3P4/1QN1PPq1/PP2B1Pr/R4RK1 w - - 2 21",
        "id": "R2",
        "uci": "h6h2",
        "san": "Rh2",
        "gamebook": {
          "deviation": "Black has to be quick to jump on the initiative of white's king being vulnerable."
        }
      },
      {
        "ply": 41,
        "fen": "r5k1/ppp2Qpp/8/4Nb2/3P4/2N1PPq1/PP2B1Pr/R4RK1 b - - 0 21",
        "id": "4X",
        "uci": "b3f7",
        "san": "Qxf7+",
        "check": true
      },
      {
        "ply": 42,
        "fen": "r6k/ppp2Qpp/8/4Nb2/3P4/2N1PPq1/PP2B1Pr/R4RK1 w - - 1 22",
        "id": "ab",
        "uci": "g8h8",
        "san": "Kh8"
      },
      {
        "ply": 43,
        "fen": "r6k/ppp2Qpp/8/4Nb2/3P4/2N1PPq1/PP2BRPr/R5K1 b - - 2 22",
        "id": "(0",
        "uci": "f1f2",
        "san": "Rf2"
      },
      {
        "ply": 44,
        "fen": "r6k/ppp2Qpp/8/4Nb2/3P3q/2N1PP2/PP2BRPr/R5K1 w - - 3 23",
        "id": "9B",
        "uci": "g3h4",
        "san": "Qh4",
        "gamebook": {
          "deviation": "Keep the initiative going! Go for the king!"
        }
      },
      {
        "ply": 45,
        "fen": "r5Qk/ppp3pp/8/4Nb2/3P3q/2N1PP2/PP2BRPr/R5K1 b - - 4 23",
        "id": "Xa",
        "uci": "f7g8",
        "san": "Qg8+",
        "check": true,
        "children": [
          {
            "ply": 46,
            "fen": "6rk/ppp3pp/8/4Nb2/3P3q/2N1PP2/PP2BRPr/R5K1 w - - 0 24",
            "id": "[a",
            "uci": "a8g8",
            "san": "Rxg8",
            "comments": [
              {
                "id": "lq80",
                "text": "This allows for Nf7#",
                "by": {
                  "id": "kyle-and-jess",
                  "name": "Kyle-and-Jess"
                }
              }
            ],
            "glyphs": [
              {
                "id": 4,
                "symbol": "??",
                "name": "Blunder"
              }
            ],
            "children": []
          }
        ]
      },
      {
        "ply": 46,
        "fen": "r5k1/ppp3pp/8/4Nb2/3P3q/2N1PP2/PP2BRPr/R5K1 w - - 0 24",
        "id": "ba",
        "uci": "h8g8",
        "san": "Kxg8",
        "comments": [
          {
            "id": "sAXm",
            "text": "Good job avoiding the smothered mate!",
            "by": {
              "id": "kyle-and-jess",
              "name": "Kyle-and-Jess"
            }
          }
        ]
      }
    ]
  }
}
''';

      final mockClient = MockClient((request) {
        if (request.url.path == '/study/JbWtuaeK/7OJXp679') {
          expect(request.url.queryParameters['chapters'], '1');
          return mockResponse(
            response,
            200,
          );
        } else if (request.url.path == '/api/study/JbWtuaeK/7OJXp679.pgn') {
          return mockResponse(
            'pgn',
            200,
          );
        }
        return mockResponse('', 404);
      });

      final container = await makeTestContainer(mockClient);
      final repo = container.read(studyRepositoryProvider);

      final (study, pgn) = await repo.getStudy(
        id: const StudyId('JbWtuaeK'),
        chapterId: const StudyChapterId('7OJXp679'),
      );

      expect(pgn, 'pgn');

      expect(
        study,
        Study(
          id: const StudyId('JbWtuaeK'),
          name: 'How to Solve Puzzles Correctly',
          liked: false,
          likes: 29,
          ownerId: const UserId('kyle-and-jess'),
          features: (
            cloneable: false,
            chat: true,
            sticky: false,
          ),
          topics: const IList.empty(),
          chapters: IList(
            const [
              StudyChapterMeta(
                id: StudyChapterId('EgqyeQIp'),
                name: 'Introduction',
                fen: null,
              ),
              StudyChapterMeta(
                id: StudyChapterId('z6tGV47W'),
                name: 'Practice Your Thought Process',
                fen:
                    '2k4r/p1p2p2/1p2b2p/1Pqn2r1/2B5/B1PP4/P4PPP/RN2Q1K1 b - - 6 20',
              ),
              StudyChapterMeta(
                id: StudyChapterId('dTfxbccx'),
                name: 'Practice Strategic Thinking',
                fen:
                    'r3r1k1/1b2b2p/pq4pB/1p3pN1/2p5/2P5/PPn1QPPP/3RR1K1 w - - 0 23',
              ),
              StudyChapterMeta(
                id: StudyChapterId('B1U4pFdG'),
                name: 'Calculate Fully',
                fen:
                    '3r3r/1Rpk1p2/2p2q1p/Q2pp3/P2PP1n1/2P1B1Pp/5P2/1N3RK1 b - - 2 26',
              ),
              StudyChapterMeta(
                id: StudyChapterId('NJLW7jil'),
                name: 'Calculate Freely',
                fen: '4k3/8/6p1/R1p1r1n1/P3Pp2/2N2r2/1PP1K1R1/8 b - - 2 39',
              ),
              StudyChapterMeta(
                id: StudyChapterId('7OJXp679'),
                name: 'Use a Timer',
                fen:
                    'r5k1/ppp2ppp/7r/4Nb2/3P4/1QN1PPq1/PP2B1P1/R4RK1 b - - 1 20',
              ),
              StudyChapterMeta(
                id: StudyChapterId('Rgk6UlTP'),
                name: 'Understand Your Mistakes',
                fen:
                    'r4rk1/1R3pb1/pR2N1p1/2q5/4p3/2P1P1Pp/Q2P1P1P/6K1 b - - 1 26',
              ),
              StudyChapterMeta(
                id: StudyChapterId('VsdxmjCf'),
                name: 'Adjusting Difficulty',
                fen:
                    '3r4/k1pq1p1r/pp1p2p1/8/3P4/P1P2BP1/1P1N1Pp1/R3R1K1 b - - 0 1',
              ),
              StudyChapterMeta(
                id: StudyChapterId('FHU6xhYs'),
                name: 'Using Themes',
                fen:
                    'r2k3N/pbpp1Bpp/1p6/2b1p3/3n3q/P7/1PPP1RPP/RNB2QK1 b - - 3 12',
              ),
              StudyChapterMeta(
                id: StudyChapterId('8FhO455h'),
                name: 'Endurance Training',
                fen: '8/1p5k/2qPQ2p/p5p1/5r1n/2B4P/5P2/4R1K1 w - - 3 41',
              ),
              StudyChapterMeta(
                id: StudyChapterId('jWUEWsEf'),
                name: 'Final Thoughts',
                fen:
                    '8/1PP2PP1/PppPPppP/Pp1pp1pP/Pp4pP/1Pp2pP1/2PppP2/3PP3 w - - 0 1',
              ),
            ],
          ),
          chapter: const StudyChapter(
            id: StudyChapterId('7OJXp679'),
            setup: StudyChapterSetup(
              id: null,
              orientation: Side.black,
              variant: Variant.standard,
              fromFen: true,
            ),
            practise: false,
            conceal: null,
            gamebook: true,
            features: (
              computer: false,
              explorer: false,
            ),
          ),
          hints: [
            'The white king is not very safe. Can black increase the pressure on the king?',
            null,
            null,
            null,
            null,
            null,
            null,
            null,
          ].lock,
          deviationComments: [
            null,
            "Black has to be quick to jump on the initiative of white's king being vulnerable.",
            null,
            null,
            null,
            'Keep the initiative going! Go for the king!',
            null,
            null,
          ].lock,
        ),
      );
    });
  });
}
