import 'package:dartchess/dartchess.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/puzzle/streak_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

final client = MockClient((request) {
  if (request.url.path == '/api/streak') {
    return mockResponse('''
      {
        "game": {
          "id": "Xndtxsoa",
          "perf": {
            "key": "blitz",
            "name": "Blitz"
          },
          "rated": true,
          "players": [
            {
              "name": "VincV",
              "id": "vincv",
              "color": "white",
              "rating": 1889
            },
            {
              "name": "Rex9646",
              "id": "rex9646",
              "color": "black",
              "rating": 1881
            }
          ],
          "pgn": "e4 c5 Nf3 e6 d4 cxd4 Nxd4 a6 Be2 Nf6 Nc3 Bb4 e5 Ne4 Bd2 Bxc3 Bxc3 Nxc3 bxc3 Qa5 O-O Qxe5 Re1 O-O Bxa6 Qc5 Bd3 Nc6 Re3 f5 Rh3 h6 Nxc6 bxc6 c4 Ra3 Qh5 Qd4 Rf1 Rxa2 Rg3 Kh8 Rg6 Rf6 Rxf6 Qxf6 Qe8+ Kh7 Qxc8 Qe7 h3 Qf7 Re1 Qe7 Bxf5+ g6 Bd3 Kg7 Qb7 Ra5 Rd1 Re5 Bxg6 Kxg6 Rxd7 Qf6 Qc8",
          "clock": "3+2"
        },
        "puzzle": {
          "id": "MptxK",
          "rating": 1012,
          "plays": 5557,
          "solution": [
            "e5e1",
            "g1h2",
            "f6f4",
            "g2g3",
            "f4f2"
          ],
          "themes": [
            "endgame",
            "long",
            "mateIn3"
          ],
          "initialPly": 66
        },
        "angle": {
          "key": "mix",
          "name": "Puzzle Themes",
          "desc": "A bit of everything. You don't know what to expect, so you remain ready for anything! Just like in real games."
        },
        "streak": "MptxK 4CZxz kcN3a 1I9Ly kOx90 eTrkO G0tpf iwTxQ tg2IU TovLC 0miTI Jpmkf 8VqjS XftoM 70UGG lm8O8 R4Y49 76Llk XZOyq QUgzo dACnQ qFjLp ytKo4 6JIj1 SYz3x kEkib dkvMp Dk0Ln Ok3qk zbRCc fQSVb vmDLx VJw06 3up01 X9aHm EicvD 5lhwD fTJE0 08LZy XAsVO TVB8s VCLTk KH6zc CaByR E2dUi JOxJg Agtzu KwbY9 Rmcf7 k9jGo 0zTgd 5YCx8 BtqDp DQdRO ytwPd sHqWB 1WunB Fovke mmMDN UNcwu isI02 3sIJB mnuzi 4aaRt Jvkvj UsXO2 kLfmz gsC1H TADGH a0Jz6 oUPR2 1IOBO 9PUdj haSH3 wn5by 22fL0 CR3Wu FaBtd DorJu unTls qeu0r xo40H DssQ9 D6s6S hkWx4 GF7s5 rzREu vhsbo s1haw j9ckI ekJnL TvcVB a7T4o 1olwh pydoy rGs3G k5ljZ gowEl UNXOV XkaUw 10lYO 6Ufqg Q45go KxGe3 vgwIt lqoaX nBtOq uAo3e jsbpu JLtdz TGUcX PobG5 ScDAL YPEfv o52sU FV0lM evQzq qAny0 dkDJi 0AUNz uzI6q kh13r Rubxa ecY6Q T9EL2 TmBka DPT5t qmzEf dyo0g MsGbE hPkmk 3wZBI 7kpeT 6EKGn kozHL Vnaiz 6DzDP HQ5RQ 7Ilyn 9n7Pz PwtXo kgMG2 J7gat gXcxs 4YVfC e8jGb m71Kb 9OrKY z530i"
      }
      ''', 200);
  } else if (request.url.path == '/api/puzzle/4CZxz') {
    return mockResponse('''
      {
        "game": {
          "id": "MQOxq7Jl",
          "perf": {
            "key": "blitz",
            "name": "Blitz"
          },
          "rated": true,
          "players": [
            {
              "name": "mikeroh",
              "flair": "nature.t-rex",
              "id": "mikeroh",
              "color": "white",
              "rating": 1600
            },
            {
              "name": "huthayfa78",
              "id": "huthayfa78",
              "color": "black",
              "rating": 1577
            }
          ],
          "pgn": "d4 d5 Bf4 h6 e3 a6 Nf3 Nf6 c3 Nh5 Be5 f6 Bg3 Nxg3 hxg3 Qd6 Bd3 Nc6 Qc2 Be6 Nbd2 O-O-O e4 dxe4 Nxe4 Qd5 O-O-O Qxa2 Nc5 Bf7 Bf5+ e6 Be4 Bxc5 dxc5 Qa1+ Qb1 Rxd1+ Rxd1 Qa4 Nd4 Nxd4 cxd4 Re8 f4 Qc4+ Bc2 Rd8 b3 Qc3 Qb2 Qe3+ Rd2 Qxg3 f5 exf5 Bxf5+ Kb8 Qa3 Qe1+ Rd1 Qe3+ Kb1 Rxd4 Rxd4 Qxd4 c6 Qd1+ Kb2 Qe2+ Bc2 bxc6 Qf8+ Be8 Qb4+ Kc8 Kc3 Qxg2 Bf5+ Kd8 Qb8+ Ke7 Qxc7+ Kf8 Qd6+ Kg8 Qe6+ Bf7",
          "clock": "3+2"
        },
        "puzzle": {
          "id": "4CZxz",
          "rating": 1058,
          "plays": 2060,
          "solution": [
            "e6c8",
            "f7e8",
            "c8e8"
          ],
          "themes": [
            "short",
            "endgame",
            "mateIn2"
          ],
          "initialPly": 87
        }
      }
      ''', 200);
  } else if (request.url.path == '/api/puzzle/kcN3a') {
    return mockResponse('''
      {
        "game": {
          "id": "bEuHKQSa",
          "perf": {
            "key": "rapid",
            "name": "Rapid"
          },
          "rated": true,
          "players": [
            {
              "name": "franpite",
              "id": "franpite",
              "color": "white",
              "rating": 1773
            },
            {
              "name": "cleomarzin777",
              "id": "cleomarzin777",
              "color": "black",
              "rating": 1752
            }
          ],
          "pgn": "e4 c5 Nf3 d6 d4 cxd4 Nxd4 Nf6 Nc3 a6 Be3 e5 Nf3 b5 Be2 Bb7 O-O Nxe4 Nd5 Nf6 Nxf6+ Qxf6 Bg5 Qe6 Re1 Be7 Bxe7 Qxe7 Qd3 O-O Rad1 Rd8 Nd2 Qg5 Ne4 Qg6 Nxd6",
          "clock": "10+0"
        },
        "puzzle": {
          "id": "kcN3a",
          "rating": 1069,
          "plays": 294,
          "solution": [
            "g6g2"
          ],
          "themes": [
            "middlegame",
            "oneMove",
            "mateIn1",
            "kingsideAttack"
          ],
          "initialPly": 36
        }
      }
      ''', 200);
  } else if (request.url.path == '/api/puzzle/1I9Ly') {
    return mockResponse('''
      {
        "game": {
          "id": "DTmg6BsX",
          "perf": {
            "key": "rapid",
            "name": "Rapid"
          },
          "rated": true,
          "players": [
            {
              "name": "Eskozhanov_1_Semey1",
              "id": "eskozhanov_1_semey1",
              "color": "white",
              "rating": 1928
            },
            {
              "name": "sirlancelots",
              "id": "sirlancelots",
              "color": "black",
              "rating": 2124
            }
          ],
          "pgn": "e4 c5 Nc3 e6 Nf3 a6 d4 cxd4 Nxd4 Qc7 g3 Nf6 Bg2 Nc6 a3 d6 O-O Be7 f4 Nxd4 Qxd4 d5 exd5",
          "clock": "10+0"
        },
        "puzzle": {
          "id": "1I9Ly",
          "rating": 1087,
          "plays": 3873,
          "solution": [
            "e7c5",
            "c1e3",
            "c5d4"
          ],
          "themes": [
            "opening",
            "crushing",
            "short",
            "pin"
          ],
          "initialPly": 22
        }
      }
      ''', 200);
  }
  return mockResponse('', 404);
});

void main() {
  group('StreakScreen', () {
    testWidgets('meets accessibility guidelines', (tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();

      final app = await makeTestProviderScopeApp(
        tester,
        home: const StreakScreen(),
        overrides: [lichessClientProvider.overrideWith((ref) => LichessClient(client, ref))],
      );

      await tester.pumpWidget(app);

      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    }, variant: kPlatformVariant);

    testWidgets('Score is saved when exiting screen', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: Builder(
          builder:
              (context) => PlatformScaffold(
                appBar: const PlatformAppBar(title: Text('Test Streak Screen')),
                body: FatButton(
                  semanticsLabel: 'Start Streak',
                  child: const Text('Start Streak'),
                  onPressed:
                      () => Navigator.of(
                        context,
                        rootNavigator: true,
                      ).push(buildScreenRoute<void>(context, screen: const StreakScreen())),
                ),
              ),
        ),
        overrides: [lichessClientProvider.overrideWith((ref) => LichessClient(client, ref))],
      );
      await tester.pumpWidget(app);

      await tester.tap(find.text('Start Streak'));

      // wait for puzzle to load from api and opponent move to be played
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.textContaining(RegExp('0\$')), findsOneWidget);

      await playMove(tester, 'e5', 'e1', orientation: Side.black);
      // Wait for opponent move to be played
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      await playMove(tester, 'f6', 'f4', orientation: Side.black);
      // Wait for opponent move to be played
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      await playMove(tester, 'f4', 'f2', orientation: Side.black);

      // Wait for next puzzle to load and score to be updated
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.textContaining(RegExp('1\$')), findsOneWidget);

      // Exit screen -> score should be saved
      await tester.pageBack();
      await tester.pump();
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();

      // Enter streak screen again -> previous score should be loaded
      await tester.tap(find.text('Start Streak'));
      // Wait for puzzle to load from api and opponent move to be played
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.textContaining(RegExp('1\$')), findsOneWidget);

      await playMove(tester, 'e6', 'c8', orientation: Side.white);
      // Wait for opponent move to be played
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      await playMove(tester, 'f7', 'e8', orientation: Side.white);
      // Wait for opponent move to be played
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      await playMove(tester, 'c8', 'e8', orientation: Side.white);

      // Wait for next puzzle to load and score to be updated
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.textContaining(RegExp('2\$')), findsOneWidget);

      // Play a wrong move
      await playMove(tester, 'd8', 'd7', orientation: Side.black);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('GAME OVER'), findsOneWidget);

      // Exit screen and enter screen again
      // -> local score should be cleared, so score should be 0 again
      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start Streak'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.textContaining(RegExp('0\$')), findsOneWidget);
    });
  });
}
