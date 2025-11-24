import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/user/user_screen.dart';

import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

final client = MockClient((request) {
  if (request.url.path == '/api/mobile/profile/$testUserId') {
    return mockResponse(userProfileResponse, 200);
  }
  return mockResponse('', 404);
});

void main() {
  group('UserScreen', () {
    testWidgets('should see activity and recent games', (WidgetTester tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const UserScreen(user: testUser),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(client, ref),
          ),
        },
      );

      await tester.pumpWidget(app);

      // wait for user request
      await tester.pump(const Duration(milliseconds: 50));

      // full name at the top
      expect(find.text('John Doe'), findsOneWidget);

      // wait for recent games and activity
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Activity'), findsOneWidget);
    }, variant: kPlatformVariant);
  });
}

const testUserName = 'FakeUserName';
const testUserId = UserId('fakeusername');
const testUser = LightUser(id: testUserId, name: testUserName);
const userProfileResponse =
    '''
{
    "activity": [
        {
            "games": {
                "blitz": {
                    "draw": 1,
                    "loss": 5,
                    "rp": {
                        "after": 1382,
                        "before": 1379
                    },
                    "win": 3
                },
                "classical": {
                    "draw": 0,
                    "loss": 1,
                    "rp": {
                        "after": 1599,
                        "before": 1612
                    },
                    "win": 4
                },
                "rapid": {
                    "draw": 1,
                    "loss": 1,
                    "rp": {
                        "after": 1504,
                        "before": 1499
                    },
                    "win": 4
                }
            },
            "interval": {
                "end": 1756425600000,
                "start": 1756339200000
            }
        },
        {
            "follows": {
                "in": {
                    "ids": [
                        "chabrot",
                        "punuworldchamp",
                        "evans_chess_club",
                        "sackel",
                        "carlos2030",
                        "furkankrmblc_5300",
                        "raypenvar",
                        "hado99",
                        "littleeagle789"
                    ]
                }
            },
            "games": {
                "blitz": {
                    "draw": 40,
                    "loss": 280,
                    "rp": {
                        "after": 1385,
                        "before": 1411
                    },
                    "win": 396
                },
                "bullet": {
                    "draw": 12,
                    "loss": 72,
                    "rp": {
                        "after": 1592,
                        "before": 1616
                    },
                    "win": 192
                },
                "classical": {
                    "draw": 12,
                    "loss": 59,
                    "rp": {
                        "after": 1607,
                        "before": 1550
                    },
                    "win": 291
                },
                "rapid": {
                    "draw": 69,
                    "loss": 424,
                    "rp": {
                        "after": 1499,
                        "before": 1494
                    },
                    "win": 955
                }
            },
            "interval": {
                "end": 1756339200000,
                "start": 1756252800000
            }
        },
        {
            "follows": {
                "in": {
                    "ids": [
                        "kernen",
                        "messironaldopelemara",
                        "samarth_gupta",
                        "adrixxkudr",
                        "thomasnew156"
                    ]
                }
            },
            "games": {
                "blitz": {
                    "draw": 65,
                    "loss": 241,
                    "rp": {
                        "after": 1411,
                        "before": 1406
                    },
                    "win": 395
                },
                "bullet": {
                    "draw": 21,
                    "loss": 67,
                    "rp": {
                        "after": 1616,
                        "before": 1630
                    },
                    "win": 153
                },
                "classical": {
                    "draw": 11,
                    "loss": 64,
                    "rp": {
                        "after": 1550,
                        "before": 1564
                    },
                    "win": 229
                },
                "rapid": {
                    "draw": 76,
                    "loss": 411,
                    "rp": {
                        "after": 1495,
                        "before": 1471
                    },
                    "win": 877
                }
            },
            "interval": {
                "end": 1756252800000,
                "start": 1756166400000
            }
        },
        {
            "follows": {
                "in": {
                    "ids": [
                        "adrixxkudr",
                        "chermgkim",
                        "methbaba",
                        "rusty342",
                        "powermetalwarrior",
                        "hulcamanic",
                        "evan2017abc",
                        "kernen",
                        "rogerzanoni"
                    ]
                }
            },
            "games": {
                "blitz": {
                    "draw": 47,
                    "loss": 245,
                    "rp": {
                        "after": 1406,
                        "before": 1367
                    },
                    "win": 403
                },
                "bullet": {
                    "draw": 13,
                    "loss": 96,
                    "rp": {
                        "after": 1630,
                        "before": 1627
                    },
                    "win": 188
                },
                "classical": {
                    "draw": 15,
                    "loss": 68,
                    "rp": {
                        "after": 1561,
                        "before": 1553
                    },
                    "win": 224
                },
                "rapid": {
                    "draw": 73,
                    "loss": 399,
                    "rp": {
                        "after": 1468,
                        "before": 1495
                    },
                    "win": 850
                }
            },
            "interval": {
                "end": 1756166400000,
                "start": 1756080000000
            }
        },
        {
            "follows": {
                "in": {
                    "ids": [
                        "joebananass",
                        "badredinne47",
                        "melu_manolo",
                        "muqqhh",
                        "eloiblt",
                        "evan2017abc",
                        "advik-the-star",
                        "jkh0208",
                        "canary_gambit",
                        "queen888c6"
                    ]
                }
            },
            "games": {
                "blitz": {
                    "draw": 11,
                    "loss": 62,
                    "rp": {
                        "after": 1359,
                        "before": 1366
                    },
                    "win": 118
                },
                "bullet": {
                    "draw": 2,
                    "loss": 12,
                    "rp": {
                        "after": 1627,
                        "before": 1619
                    },
                    "win": 45
                },
                "classical": {
                    "draw": 6,
                    "loss": 18,
                    "rp": {
                        "after": 1553,
                        "before": 1559
                    },
                    "win": 53
                },
                "rapid": {
                    "draw": 17,
                    "loss": 81,
                    "rp": {
                        "after": 1495,
                        "before": 1464
                    },
                    "win": 184
                }
            },
            "interval": {
                "end": 1756080000000,
                "start": 1755993600000
            }
        },
        {
            "follows": {
                "in": {
                    "ids": [
                        "lezepo",
                        "victorcagatay",
                        "prajan2929",
                        "jv2080",
                        "anselborge06",
                        "brothpigeon"
                    ]
                }
            },
            "games": {
                "blitz": {
                    "draw": 50,
                    "loss": 249,
                    "rp": {
                        "after": 1366,
                        "before": 1414
                    },
                    "win": 455
                },
                "bullet": {
                    "draw": 16,
                    "loss": 66,
                    "rp": {
                        "after": 1619,
                        "before": 1678
                    },
                    "win": 128
                },
                "classical": {
                    "draw": 18,
                    "loss": 95,
                    "rp": {
                        "after": 1558,
                        "before": 1602
                    },
                    "win": 293
                },
                "rapid": {
                    "draw": 85,
                    "loss": 380,
                    "rp": {
                        "after": 1465,
                        "before": 1495
                    },
                    "win": 859
                }
            },
            "interval": {
                "end": 1755993600000,
                "start": 1755907200000
            }
        },
        {
            "follows": {
                "in": {
                    "ids": [
                        "robofresh",
                        "adrixxkudr",
                        "kotverteiler1",
                        "quadro_blunder",
                        "hanseo33",
                        "dlclal",
                        "t1za"
                    ]
                }
            },
            "games": {
                "blitz": {
                    "draw": 4,
                    "loss": 29,
                    "rp": {
                        "after": 1414,
                        "before": 1420
                    },
                    "win": 33
                },
                "bullet": {
                    "draw": 2,
                    "loss": 6,
                    "rp": {
                        "after": 1678,
                        "before": 1668
                    },
                    "win": 3
                },
                "classical": {
                    "draw": 1,
                    "loss": 3,
                    "rp": {
                        "after": 1606,
                        "before": 1581
                    },
                    "win": 12
                },
                "rapid": {
                    "draw": 4,
                    "loss": 38,
                    "rp": {
                        "after": 1490,
                        "before": 1494
                    },
                    "win": 57
                }
            },
            "interval": {
                "end": 1755907200000,
                "start": 1755820800000
            }
        }
    ],
    "games": [
        {
            "clock": {
                "increment": 2,
                "initial": 180,
                "totalTime": 260
            },
            "createdAt": 1756339538812,
            "id": "qH0luj6N",
            "lastFen": "1N3rk1/2b2ppp/p3pn2/1p6/8/1P3Q2/PB1P1PPq/R4RK1 w - - 0 1",
            "lastMove": "d6h2",
            "lastMoveAt": 1756339722085,
            "opening": {
                "eco": "B10",
                "name": "Caro-Kann Defense: Hillbilly Attack",
                "ply": 3
            },
            "perf": "blitz",
            "players": {
                "black": {
                    "provisional": true,
                    "rating": 1500,
                    "user": {
                        "id": "fewsa",
                        "name": "fewsa"
                    }
                },
                "white": {
                    "rating": 1385,
                    "user": {
                        "id": "maia1",
                        "name": "maia1",
                        "title": "BOT"
                    }
                }
            },
            "rated": false,
            "source": "friend",
            "speed": "blitz",
            "status": "mate",
            "variant": "standard",
            "winner": "black"
        },
        {
            "clock": {
                "increment": 2,
                "initial": 180,
                "totalTime": 260
            },
            "createdAt": 1756339512962,
            "id": "udkY0LyI",
            "lastFen": "rnbR1k1r/ppN1ppbp/6p1/4P3/5n2/8/PPP2PPP/4KBNR b K - 2 1",
            "lastMove": "d1d8",
            "lastMoveAt": 1756339530512,
            "opening": {
                "eco": "B06",
                "name": "Modern Defense: Standard Defense",
                "ply": 6
            },
            "perf": "blitz",
            "players": {
                "black": {
                    "rating": 1385,
                    "user": {
                        "id": "maia1",
                        "name": "maia1",
                        "title": "BOT"
                    }
                },
                "white": {
                    "provisional": true,
                    "rating": 1500,
                    "user": {
                        "id": "fewsa",
                        "name": "fewsa"
                    }
                }
            },
            "rated": false,
            "source": "friend",
            "speed": "blitz",
            "status": "mate",
            "variant": "standard",
            "winner": "white"
        },
        {
            "clock": {
                "increment": 0,
                "initial": 600,
                "totalTime": 600
            },
            "createdAt": 1756339499082,
            "id": "D5up0PCS",
            "lastFen": "r1bqk1nr/pp1pbpQp/8/2p5/4P3/8/PPP2PPP/RNB1KB1R b KQkq - 0 1",
            "lastMove": "e5g7",
            "lastMoveAt": 1756339534858,
            "opening": {
                "eco": "C44",
                "name": "Scotch Game: Lolli Variation",
                "ply": 9
            },
            "perf": "rapid",
            "players": {
                "black": {
                    "provisional": true,
                    "rating": 1500,
                    "user": {
                        "id": "whatisanight",
                        "name": "WhatIsANight"
                    }
                },
                "white": {
                    "rating": 1512,
                    "user": {
                        "id": "maia1",
                        "name": "maia1",
                        "title": "BOT"
                    }
                }
            },
            "rated": false,
            "source": "friend",
            "speed": "rapid",
            "status": "resign",
            "variant": "standard",
            "winner": "white"
        },
        {
            "clock": {
                "increment": 10,
                "initial": 1800,
                "totalTime": 2200
            },
            "createdAt": 1756339485316,
            "id": "bngnwGpX",
            "lastFen": "r1bq1bnr/ppppk1p1/7p/4Q3/2Bp4/8/PPP2PPP/RNB1K2R b KQ - 0 1",
            "lastMove": "d5e5",
            "lastMoveAt": 1756339586570,
            "opening": {
                "eco": "C44",
                "name": "Scotch Game",
                "ply": 6
            },
            "perf": "classical",
            "players": {
                "black": {
                    "rating": 1610,
                    "ratingDiff": -11,
                    "user": {
                        "id": "maia1",
                        "name": "maia1",
                        "title": "BOT"
                    }
                },
                "white": {
                    "rating": 1152,
                    "ratingDiff": 8,
                    "user": {
                        "id": "msg1988",
                        "name": "msg1988"
                    }
                }
            },
            "rated": true,
            "source": "friend",
            "speed": "classical",
            "status": "mate",
            "variant": "standard",
            "winner": "white"
        },
        {
            "clock": {
                "increment": 3,
                "initial": 300,
                "totalTime": 420
            },
            "createdAt": 1756339462883,
            "id": "GDRtseGM",
            "lastFen": "5rk1/ppp3pn/3B3p/3N4/6Q1/8/PPP3PP/4q2K w - - 0 1",
            "lastMove": "f2e1",
            "lastMoveAt": 1756339737681,
            "opening": {
                "eco": "C50",
                "name": "Italian Game: Hungarian Defense",
                "ply": 6
            },
            "perf": "blitz",
            "players": {
                "black": {
                    "rating": 1575,
                    "ratingDiff": 2,
                    "user": {
                        "flair": "nature.dog",
                        "id": "dwnwrdhvnwrd",
                        "name": "dwnwrdhvnwrd"
                    }
                },
                "white": {
                    "rating": 1385,
                    "ratingDiff": -3,
                    "user": {
                        "id": "maia1",
                        "name": "maia1",
                        "title": "BOT"
                    }
                }
            },
            "rated": true,
            "source": "friend",
            "speed": "blitz",
            "status": "mate",
            "variant": "standard",
            "winner": "black"
        },
        {
            "clock": {
                "increment": 0,
                "initial": 600,
                "totalTime": 600
            },
            "createdAt": 1756339435408,
            "id": "DSpG8iAB",
            "lastFen": "r1b2rk1/pp1p1pQp/6pP/q3P3/2pb4/2N5/PPP2P1P/R1B1KB1R b KQ - 3 1",
            "lastMove": "f6g7",
            "lastMoveAt": 1756339496735,
            "opening": {
                "eco": "C44",
                "name": "Scotch Game: Lolli Variation",
                "ply": 9
            },
            "perf": "rapid",
            "players": {
                "black": {
                    "rating": 1512,
                    "user": {
                        "id": "maia1",
                        "name": "maia1",
                        "title": "BOT"
                    }
                },
                "white": {
                    "provisional": true,
                    "rating": 1500,
                    "user": {
                        "id": "whatisanight",
                        "name": "WhatIsANight"
                    }
                }
            },
            "rated": false,
            "source": "friend",
            "speed": "rapid",
            "status": "mate",
            "variant": "standard",
            "winner": "white"
        },
        {
            "clock": {
                "increment": 0,
                "initial": 300,
                "totalTime": 300
            },
            "createdAt": 1756339419231,
            "id": "9kcJo8OX",
            "lastFen": "1R3r2/p1P2pkp/4p1p1/8/3P3Q/8/2b2PPP/2n2q1K w - - 2 1",
            "lastMove": "d3f1",
            "lastMoveAt": 1756339732310,
            "opening": {
                "eco": "D30",
                "name": "Queen's Gambit Declined",
                "ply": 4
            },
            "perf": "blitz",
            "players": {
                "black": {
                    "rating": 1366,
                    "ratingDiff": 3,
                    "user": {
                        "id": "zekaaaaaaa",
                        "name": "zekaaaaaaa"
                    }
                },
                "white": {
                    "rating": 1385,
                    "ratingDiff": -6,
                    "user": {
                        "id": "maia1",
                        "name": "maia1",
                        "title": "BOT"
                    }
                }
            },
            "rated": true,
            "source": "friend",
            "speed": "blitz",
            "status": "mate",
            "variant": "standard",
            "winner": "black"
        },
        {
            "clock": {
                "increment": 10,
                "initial": 1800,
                "totalTime": 2200
            },
            "createdAt": 1756339413189,
            "id": "p0cvGF7m",
            "lastFen": "rnb1k2r/pppp1ppp/8/2b1p3/2P1P1n1/3B2P1/PP1PNP1q/RNBQ1RK1 w kq - 0 1",
            "lastMove": "h4h2",
            "lastMoveAt": 1756339480532,
            "opening": {
                "eco": "C20",
                "name": "English Opening: The Whale",
                "ply": 3
            },
            "perf": "classical",
            "players": {
                "black": {
                    "rating": 1609,
                    "ratingDiff": 1,
                    "user": {
                        "id": "maia1",
                        "name": "maia1",
                        "title": "BOT"
                    }
                },
                "white": {
                    "rating": 1153,
                    "ratingDiff": -1,
                    "user": {
                        "id": "msg1988",
                        "name": "msg1988"
                    }
                }
            },
            "rated": true,
            "source": "friend",
            "speed": "classical",
            "status": "mate",
            "variant": "standard",
            "winner": "black"
        },
        {
            "clock": {
                "increment": 0,
                "initial": 420,
                "totalTime": 420
            },
            "createdAt": 1756339261062,
            "id": "H5U34b4K",
            "lastFen": "3k4/2p2pp1/4p1p1/8/1P1P4/6b1/1P2Kn2/2B5 b - - 0 1",
            "lastMove": "d2d4",
            "lastMoveAt": 1756339465267,
            "opening": {
                "eco": "B01",
                "name": "Scandinavian Defense: Mieses-Kotroc Variation",
                "ply": 4
            },
            "perf": "blitz",
            "players": {
                "black": {
                    "rating": 1391,
                    "user": {
                        "id": "maia1",
                        "name": "maia1",
                        "title": "BOT"
                    }
                },
                "white": {
                    "rating": 1004,
                    "user": {
                        "flair": "food-drink.egg",
                        "id": "alejocediel",
                        "name": "alejocediel"
                    }
                }
            },
            "rated": false,
            "source": "friend",
            "speed": "blitz",
            "status": "resign",
            "variant": "standard",
            "winner": "black"
        },
        {
            "clock": {
                "increment": 0,
                "initial": 600,
                "totalTime": 600
            },
            "createdAt": 1756339241909,
            "id": "TXUvOubU",
            "lastFen": "r6r/pp1nbk2/b1p1pnp1/q2p4/N2P1B1P/1P3p2/2P2P2/R2K3R w - - 0 1",
            "lastMove": "g4f3",
            "lastMoveAt": 1756339603855,
            "opening": {
                "eco": "D05",
                "name": "Queen's Pawn Game: Colle System",
                "ply": 6
            },
            "perf": "rapid",
            "players": {
                "black": {
                    "rating": 1504,
                    "user": {
                        "id": "maia1",
                        "name": "maia1",
                        "title": "BOT"
                    }
                },
                "white": {
                    "provisional": true,
                    "rating": 1500,
                    "user": {
                        "id": "knboak",
                        "name": "knboak"
                    }
                }
            },
            "rated": false,
            "source": "friend",
            "speed": "rapid",
            "status": "resign",
            "variant": "standard",
            "winner": "black"
        }
    ],
    "profile": {
        "count": {
            "ai": 4,
            "all": 2777418,
            "bookmark": 0,
            "draw": 185052,
            "drawH": 185052,
            "import": 0,
            "loss": 1071305,
            "lossH": 1071301,
            "me": 0,
            "playing": 7,
            "rated": 1084756,
            "win": 1521061,
            "winH": 1521061
        },
        "createdAt": 1582579972726,
        "id": "$testUserId",
        "perfs": {
            "blitz": {
                "games": 349199,
                "prog": -7,
                "rating": 1376,
                "rd": 45
            },
            "bullet": {
                "games": 190385,
                "prog": -34,
                "rating": 1592,
                "rd": 45
            },
            "classical": {
                "games": 115988,
                "prog": 2,
                "rating": 1600,
                "rd": 45
            },
            "correspondence": {
                "games": 265,
                "prog": -18,
                "prov": true,
                "rating": 1527,
                "rd": 204
            },
            "rapid": {
                "games": 393719,
                "prog": 31,
                "rating": 1512,
                "rd": 45
            }
        },
        "playTime": {
            "total": 1058750639,
            "tv": 3015709
        },
        "playing": "https://lichess.org/TQu312e7/black",
        "profile": {
            "realName": "John Doe"
        },
        "seenAt": 1756339410758,
        "url": "https://lichess.org/@/$testUserId",
        "username": "$testUserName",
        "verified": true
    },
    "status": {
        "online": true,
        "playing": {
            "clock": {
                "increment": 0,
                "initial": 720,
                "totalTime": 720
            },
            "clocks": [
                72000,
                72000,
                71757,
                71976,
                71521,
                71774,
                70960,
                71761,
                70170,
                71547,
                70033,
                71229,
                69678,
                70997
            ],
            "createdAt": 1756339822726,
            "id": "RXfOEm1k",
            "lastMoveAt": 1756339863198,
            "moves": "g3 e6 Nh3 d5 Bg2 Nf6 Ng5 h6 Nh3 Nc6 b3 Bd6 Bb2 O-O",
            "opening": {
                "eco": "A00",
                "name": "Hungarian Opening",
                "ply": 1
            },
            "perf": "rapid",
            "players": {
                "black": {
                    "rating": 1512,
                    "user": {
                        "id": "maia1",
                        "name": "maia1",
                        "title": "BOT"
                    }
                },
                "white": {
                    "provisional": true,
                    "rating": 1500,
                    "user": {
                        "id": "zeyad4874896",
                        "name": "zeyad4874896"
                    }
                }
            },
            "rated": false,
            "source": "friend",
            "speed": "rapid",
            "status": "started",
            "variant": "standard"
        }
    }
}
''';
