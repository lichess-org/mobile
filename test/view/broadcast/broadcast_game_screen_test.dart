import 'package:chessground/chessground.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_screen.dart';

import '../../network/fake_websocket_channel.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

final client = MockClient((request) {
  if (request.url.path == '/api/broadcast/-/-/$_roundId') {
    return mockResponse(
      _roundResponse,
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }
  if (request.url.path == '/api/study/$_roundId/$_gameId.pgn') {
    return mockResponse(_gameResponse, 200, headers: {'content-type': 'application/x-chess-pgn'});
  }
  return mockResponse('', 404);
});

void main() {
  group('Broadcast game screen', () {
    testWidgets('Displays broadcast game screen', variant: kPlatformVariant, (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const BroadcastGameScreen(
          tournamentId: _tournamentId,
          roundId: _roundId,
          gameId: _gameId,
        ),
        overrides: [lichessClientProvider.overrideWith((ref) => LichessClient(client, ref))],
      );

      await tester.pumpWidget(app);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump();

      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.text('Dastan, Muhammed Batuhan'), findsOne);
      expect(find.text('Gokerkan, Cem Kaan'), findsOne);
    });

    testWidgets('Receives a new move of the game', variant: kPlatformVariant, (tester) async {
      final fakeSocket = FakeWebSocketChannel();
      final app = await makeTestProviderScopeApp(
        tester,
        home: const BroadcastGameScreen(
          tournamentId: _tournamentId,
          roundId: _roundId,
          gameId: _gameId,
        ),
        overrides: [
          lichessClientProvider.overrideWith((ref) => LichessClient(client, ref)),
          webSocketChannelFactoryProvider.overrideWith((ref) {
            return FakeWebSocketChannelFactory((_) => fakeSocket);
          }),
        ],
      );

      await tester.pumpWidget(app);

      await tester.pump();
      // await tester.pump(); It might be interesting to know why it breaks the test

      expect(find.byKey(const Key('c1-whitebishop')), findsOneWidget);

      await addSocketMessage(
        tester,
        fakeSocket,
        r'''{"v":151,"t":"addNode","d":{"n":{"ply":23,"fen":"rnq2rk1/pp2ppbp/5np1/2P1N3/2N5/4B1P1/PP2PPKP/R2Q1R2 b - - 2 12","id":"%7","uci":"c1e3","san":"Be3","clock":359500},"p":{"chapterId":"G2LUflKg","path":")8aP19YQ(1`Y'*_b.>VF-=F=$3UE3=]O8GOF>EF1)1^]"},"d":"0S 978 TCEJNZ8 WGO 3NV 6xEILQSYZ78 !? UM 5OQZ 2V? XHP","s":false,"relayPath":"!"}}''',
      );

      // The controller process the message
      await tester.pump();

      expect(find.byKey(const Key('e3-whitebishop')), findsOneWidget);
    });
  });
}

Future<void> addSocketMessage(
  WidgetTester tester,
  FakeWebSocketChannel fakeSocket,
  String message,
) async {
  fakeSocket.addIncomingMessages([message]);

  // Send message to the socket
  await tester.pump();
}

const _tournamentId = BroadcastTournamentId('RAIoMC7L');
const _roundId = BroadcastRoundId('6VuqTjes');
const _gameId = BroadcastGameId('G2LUflKg');
const _roundResponse =
    '''{"round":{"id":"6VuqTjes","name":"Round 4.1","slug":"round-41","createdAt":1734081596041,"ongoing":true,"startsAt":1734606000000,"url":"https://lichess.org/broadcast/turkish-chess-championship-2024/round-41/6VuqTjes"},"tour":{"id":"RAIoMC7L","name":"Turkish Chess Championship 2024","slug":"turkish-chess-championship-2024","info":{"website":"http://tr2024.tsf.org.tr/","players":"Yılmaz, Şanal, Daştan, Yılmazyerli","location":"Kemer, Turkey","tc":"90 min + 30 sec / move","fideTc":"standard","timeZone":"Turkey","standings":"https://chess-results.com/tnr1080829.aspx?art=1","format":"16-player knockout"},"createdAt":1734081433831,"url":"https://lichess.org/broadcast/turkish-chess-championship-2024/RAIoMC7L","tier":4,"dates":[1734087600000,1734778800000],"image":"https://image.lichess1.org/display?fmt=webp&h=400&op=thumbnail&path=relay:RAIoMC7L:7C8IGWzr.webp&w=800&sig=f80b016b5b197796781fac50cce7a774ded9ff38"},"study":{"writeable":false},"games":[{"id":"G2LUflKg","name":"Dastan, Muhammed Batuhan - Gokerkan, Cem Kaan","fen":"rnq2rk1/pp2ppbp/5np1/2P1N3/2N5/6P1/PP2PPKP/R1BQ1R2 w - - 1 12","players":[{"name":"Dastan, Muhammed Batuhan","title":"GM","rating":2560,"fideId":6300014,"fed":"TUR","clock":415200},{"name":"Gokerkan, Cem Kaan","title":"GM","rating":2486,"fideId":6336760,"fed":"TUR","clock":345100}],"lastMove":"d8c8","thinkTime":355,"status":"*"},{"id":"Wf2MqRBR","name":"Yilmazyerli, Mert - Tarhan, Adar","fen":"r3n3/ppp1k2Q/5p2/3qp3/7p/3B4/P1P3PP/4R1K1 b - - 8 27","players":[{"name":"Yilmazyerli, Mert","title":"GM","rating":2515,"fideId":6305962,"fed":"TUR","clock":562900},{"name":"Tarhan, Adar","title":"IM","rating":2483,"fideId":34544712,"fed":"TUR","clock":548600}],"lastMove":"h6h7","check":"+","status":"½-½"},{"id":"GwfDrsCc","name":"Isik, Alparslan - Gunduz, Umut Erdem","fen":"r4rk1/pbq1bppp/4pn2/2p5/2P5/3BBN1P/PP2QPP1/R4RK1 b - - 2 16","players":[{"name":"Isik, Alparslan","title":"IM","rating":2475,"fideId":34506896,"fed":"TUR","clock":336700},{"name":"Gunduz, Umut Erdem","title":"IM","rating":2287,"fideId":6381383,"fed":"TUR","clock":430100}],"lastMove":"c2e2","thinkTime":148,"status":"*"}]}''';
const _gameResponse = '''
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
''';
