import 'package:lichess_mobile/src/model/common/id.dart';

const Map<(BroadcastTournamentId, BroadcastRoundId), String> broadcastRoundMockResponses = {
  (BroadcastTournamentId('RAIoMC7L'), BroadcastRoundId('6VuqTjes')): '''
{
  "socketVersion":1,
  "round": {
    "id": "6VuqTjes",
    "name": "Round 4.1",
    "slug": "round-41",
    "createdAt": 1734081596041,
    "ongoing": true,
    "startsAt": 1734606000000,
    "url": "https://lichess.org/broadcast/turkish-chess-championship-2024/round-41/6VuqTjes"
  },
  "tour": {
    "id": "RAIoMC7L",
    "name": "Turkish Chess Championship 2024",
    "slug": "turkish-chess-championship-2024",
    "info": {
      "website": "http://tr2024.tsf.org.tr/",
      "players": "Yılmaz, Şanal, Daştan, Yılmazyerli",
      "location": "Kemer, Turkey",
      "tc": "90 min + 30 sec / move",
      "fideTc": "standard",
      "timeZone": "Turkey",
      "standings": "https://chess-results.com/tnr1080829.aspx?art=1",
      "format": "16-player knockout"
    },
    "createdAt": 1734081433831,
    "url": "https://lichess.org/broadcast/turkish-chess-championship-2024/RAIoMC7L",
    "tier": 4,
    "dates": [
      1734087600000,
      1734778800000
    ],
    "image": "https://image.lichess1.org/display?fmt=webp&h=400&op=thumbnail&path=relay:RAIoMC7L:7C8IGWzr.webp&w=800&sig=f80b016b5b197796781fac50cce7a774ded9ff38"
  },
  "study": {
    "writeable": false
  },
  "games": [
    {
      "id": "G2LUflKg",
      "name": "Dastan, Muhammed Batuhan - Gokerkan, Cem Kaan",
      "fen": "rnq2rk1/pp2ppbp/5np1/2P1N3/2N5/6P1/PP2PPKP/R1BQ1R2 w - - 1 12",
      "players": [
        {
          "name": "Dastan, Muhammed Batuhan",
          "title": "GM",
          "rating": 2560,
          "fideId": 6300014,
          "fed": "TUR",
          "clock": 415200
        },
        {
          "name": "Gokerkan, Cem Kaan",
          "title": "GM",
          "rating": 2486,
          "fideId": 6336760,
          "fed": "TUR",
          "clock": 345100
        }
      ],
      "lastMove": "d8c8",
      "thinkTime": 355,
      "status": "*"
    },
    {
      "id": "Wf2MqRBR",
      "name": "Yilmazyerli, Mert - Tarhan, Adar",
      "fen": "r3n3/ppp1k2Q/5p2/3qp3/7p/3B4/P1P3PP/4R1K1 b - - 8 27",
      "players": [
        {
          "name": "Yilmazyerli, Mert",
          "title": "GM",
          "rating": 2515,
          "fideId": 6305962,
          "fed": "TUR",
          "clock": 562900
        },
        {
          "name": "Tarhan, Adar",
          "title": "IM",
          "rating": 2483,
          "fideId": 34544712,
          "fed": "TUR",
          "clock": 548600
        }
      ],
      "lastMove": "h6h7",
      "check": "+",
      "status": "½-½"
    },
    {
      "id": "GwfDrsCc",
      "name": "Isik, Alparslan - Gunduz, Umut Erdem",
      "fen": "r4rk1/pbq1bppp/4pn2/2p5/2P5/3BBN1P/PP2QPP1/R4RK1 b - - 2 16",
      "players": [
        {
          "name": "Isik, Alparslan",
          "title": "IM",
          "rating": 2475,
          "fideId": 34506896,
          "fed": "TUR",
          "clock": 336700
        },
        {
          "name": "Gunduz, Umut Erdem",
          "title": "IM",
          "rating": 2287,
          "fideId": 6381383,
          "fed": "TUR",
          "clock": 430100
        }
      ],
      "lastMove": "c2e2",
      "thinkTime": 148,
      "status": "*"
    }
  ]
}
''',
};

const Map<BroadcastGameId, String> broadcastGamePgnResponses = {
  BroadcastGameId('G2LUflKg'): '''
[Event "Round 4.1: Dastan, Muhammed Batuhan - Gokerkan, Cem Kaan"]
[Site "https://lichess.org/study/6VuqTjes/G2LUflKg"]
[Date "2024-12-19"]
[Round "7.1"]
[White "Dastan, Muhammed Batuhan"]
[Black "Gokerkan, Cem Kaan"]
[Result "*"]
[WhiteElo "2560"]
[WhiteTitle "GM"]
[WhiteFideId "6300014"]
[BlackElo "2486"]
[BlackTitle "GM"]
[BlackFideId "6336760"]
[Variant "Standard"]
[ECO "D77"]
[Opening "Neo-Grünfeld Defense: Classical Variation, Modern Defense"]
[Annotator "https://lichess.org/broadcast/-/-/6VuqTjes"]
[StudyName "Round 4.1"]
[ChapterName "Dastan, Muhammed Batuhan - Gokerkan, Cem Kaan"]

1. Nf3 { [%clk 1:30:32] } 1... Nf6 { [%clk 1:30:05] } 2. g3 { [%clk 1:30:47] } 2... g6 { [%clk 1:29:44] } 3. Bg2 { [%clk 1:30:58] } 3... Bg7 { [%clk 1:30:07] } 4. O-O { [%clk 1:31:12] } 4... O-O { [%clk 1:30:27] } 5. d4 { [%clk 1:30:11] } 5... d5 { [%clk 1:29:40] } 6. c4 { [%clk 1:30:17] } 6... dxc4 { [%clk 1:22:10] } 7. Na3 { [%clk 1:29:35] } 7... c5 { [%clk 1:22:30] } 8. Nxc4 { [%clk 1:23:58] } 8... Be6 { [%clk 1:22:23] } 9. Nfe5 { [%clk 1:13:51] } 9... Bd5 { [%clk 0:56:58] } 10. dxc5 { [%clk 1:12:39] } 10... Bxg2 { [%clk 0:57:21] } 11. Kxg2 { [%clk 1:09:12] } 11... Qc8 { [%clk 0:57:31] } *
''',
  BroadcastGameId('Wf2MqRBR'): '''
[Event "Round 4.1: Yilmazyerli, Mert - Tarhan, Adar"]
[Site "https://lichess.org/study/6VuqTjes/Wf2MqRBR"]
[Date "2024-12-19"]
[Round "7.2"]
[White "Yilmazyerli, Mert"]
[Black "Tarhan, Adar"]
[Result "1/2-1/2"]
[WhiteElo "2515"]
[WhiteTitle "GM"]
[WhiteFideId "6305962"]
[BlackElo "2483"]
[BlackTitle "IM"]
[BlackFideId "34544712"]
[Variant "Standard"]
[ECO "C67"]
[Opening "Ruy Lopez: Berlin Defense, Rio Gambit Accepted"]
[Annotator "https://lichess.org/broadcast/-/-/6VuqTjes"]
[StudyName "Round 4.1"]
[ChapterName "Yilmazyerli, Mert - Tarhan, Adar"]

1. e4 { [%eval 0.18] [%clk 1:30:54] } 1... e5 { [%eval 0.21] [%clk 1:30:54] } 2. Nf3 { [%eval 0.13] [%clk 1:31:20] } 2... Nc6 { [%eval 0.17] [%clk 1:31:20] } 3. Bb5 { [%eval 0.08] [%clk 1:31:42] } 3... Nf6 { [%eval 0.17] [%clk 1:31:46] } 4. O-O { [%eval 0.06] [%clk 1:32:02] } 4... Nxe4 { [%eval 0.23] [%clk 1:31:20] } 5. Re1 { [%eval 0.15] [%clk 1:31:54] } 5... Nd6 { [%eval 0.18] [%clk 1:31:44] } 6. Nxe5 { [%eval 0.14] [%clk 1:32:10] } 6... Be7 { [%eval 0.17] [%clk 1:32:08] } 7. Bf1 { [%eval 0.13] [%clk 1:32:27] } 7... Nxe5 { [%eval 0.1] [%clk 1:32:33] } 8. Rxe5 { [%eval 0.15] [%clk 1:32:52] } 8... O-O { [%eval 0.15] [%clk 1:32:55] } 9. d4 { [%eval 0.18] [%clk 1:32:31] } 9... Bf6 { [%eval 0.17] [%clk 1:33:11] } 10. Re1 { [%eval 0.13] [%clk 1:32:19] } 10... Re8 { [%eval 0.13] [%clk 1:32:08] } 11. Bf4 { [%eval 0.11] [%clk 1:32:15] } 11... Rxe1 { [%eval 0.13] [%clk 1:32:30] } 12. Qxe1 { [%eval 0.11] [%clk 1:32:41] } 12... Ne8 { [%eval 0.18] [%clk 1:32:51] } 13. Nc3 { [%eval 0.0] [%clk 1:31:51] } 13... Bxd4 { [%eval 0.01] [%clk 1:32:44] } 14. Nd5 { [%eval 0.07] [%clk 1:32:08] } 14... d6 { [%eval 0.09] [%clk 1:31:57] } 15. Bg5 { [%eval 0.08] [%clk 1:29:59] } 15... f6 { [%eval 0.08] [%clk 1:30:41] } 16. Bh4 { [%eval 0.0] [%clk 1:30:16] } 16... g5 { [%eval 0.0] [%clk 1:30:45] } 17. Qe4 { [%eval 0.0] [%clk 1:30:26] } 17... Bxb2 { [%eval 0.0] [%clk 1:31:01] } 18. Re1 { [%eval 0.0] [%clk 1:30:47] } 18... Be5 { [%eval 0.0] [%clk 1:31:10] } 19. f4 { [%eval 0.0] [%clk 1:31:08] } 19... gxh4 { [%eval 0.0] [%clk 1:31:09] } 20. fxe5 { [%eval 0.0] [%clk 1:31:31] } 20... dxe5 { [%eval 0.0] [%clk 1:31:28] } 21. Bd3 { [%eval -0.03] [%clk 1:31:56] } 21... Bf5 { [%eval 0.0] [%clk 1:29:28] } 22. Qxf5 { [%eval 0.0] [%clk 1:32:19] } 22... Qxd5 { [%eval 0.0] [%clk 1:29:54] } 23. Qxh7+ { [%eval 0.0] [%clk 1:32:41] } 23... Kf8 { [%eval 0.0] [%clk 1:30:18] } 24. Qh6+ { [%eval 0.0] [%clk 1:32:33] } 24... Ke7 { [%eval 0.0] [%clk 1:30:35] } 25. Qh7+ { [%eval 0.0] [%clk 1:32:57] } 25... Kf8 { [%eval 0.0] [%clk 1:31:00] } 26. Qh6+ { [%eval 0.0] [%clk 1:33:23] } 26... Ke7 { [%eval 0.0] [%clk 1:31:26] } 27. Qh7+ { [%eval 0.0] [%clk 1:33:49] } 1/2-1/2
''',
};
