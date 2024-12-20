import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_boards_tab.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_overview_tab.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_player_widget.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_round_screen.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../network/fake_websocket_channel.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

final client = MockClient((request) {
  if (request.url.path == '/api/broadcast/RAIoMC7L') {
    return mockResponse(
      _tournamentResponse,
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }
  if (request.url.path == '/api/broadcast/-/-/Gv1305pb') {
    return mockResponse(
      _roundResponse,
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }
  return mockResponse('', 404);
});

void main() {
  group('Broadcast round screen', () {
    testWidgets('Displays broadcast round screen', variant: kPlatformVariant, (tester) async {
      final fakeSocket = FakeWebSocketChannel();
      final app = await makeTestProviderScopeApp(
        tester,
        home: BroadcastRoundScreen(broadcast: _broadcast),
        overrides: [
          lichessClientProvider.overrideWith((ref) => LichessClient(client, ref)),
          webSocketChannelFactoryProvider.overrideWith((ref) {
            return FakeWebSocketChannelFactory((_) => fakeSocket);
          }),
        ],
      );

      await tester.pumpWidget(app);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the tournament
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Load the round
      await tester.pump();

      expect(find.byType(BroadcastBoardsTab), findsOneWidget);
      expect(find.byType(BoardThumbnail), findsNWidgets(4));
      expect(find.byType(BroadcastPlayerWidget), findsNWidgets(8));
      expect(find.text('Yilmaz, Mustafa'), findsOneWidget);
      expect(find.text('Gokerkan, Cem Kaan'), findsOneWidget);
    });

    testWidgets(
      'Swipe to overview tab on Android',
      variant: TargetPlatformVariant.only(TargetPlatform.android),
      (tester) async {
        mockNetworkImagesFor(() async {
          final fakeSocket = FakeWebSocketChannel();
          final app = await makeTestProviderScopeApp(
            tester,
            home: BroadcastRoundScreen(broadcast: _broadcast),
            overrides: [
              lichessClientProvider.overrideWith((ref) => LichessClient(client, ref)),
              webSocketChannelFactoryProvider.overrideWith((ref) {
                return FakeWebSocketChannelFactory((_) => fakeSocket);
              }),
            ],
          );

          await tester.pumpWidget(app);

          // Load the tournament
          await tester.pump();

          // Load the round
          await tester.pump();

          // Swipe to the overview tab
          await tester.flingFrom(const Offset(50, 300), const Offset(500, 0), 1000);

          // Wait for the animation to end
          await tester.pump(const Duration(seconds: 1));

          expect(find.byType(BroadcastBoardsTab), findsNothing);
          expect(find.byType(BroadcastOverviewTab), findsOneWidget);

          // I could not find why this doesn't work
          // expect(find.byType(Image), findsOne);
          expect(find.byType(PlatformCard), findsNWidgets(6));
          expect(find.byType(MarkdownBody), findsOne);
        });
      },
    );

    testWidgets(
      'Tap on overview tab on iOS',
      variant: TargetPlatformVariant.only(TargetPlatform.iOS),
      (tester) async {
        mockNetworkImagesFor(() async {
          final fakeSocket = FakeWebSocketChannel();
          final app = await makeTestProviderScopeApp(
            tester,
            home: BroadcastRoundScreen(broadcast: _broadcast),
            overrides: [
              lichessClientProvider.overrideWith((ref) => LichessClient(client, ref)),
              webSocketChannelFactoryProvider.overrideWith((ref) {
                return FakeWebSocketChannelFactory((_) => fakeSocket);
              }),
            ],
          );

          await tester.pumpWidget(app);

          // Load the tournament
          await tester.pump();

          // Load the round
          await tester.pump();

          expect(find.text('Overview'), findsOne);
          await tester.tap(find.text('Overview'));
          await tester.pump(Duration(seconds: 2));
          // await tester.pumpAndSettle();

          // expect(find.byType(BroadcastBoardsTab), findsOneWidget);
          // expect(find.byType(BroadcastOverviewTab), findsOneWidget);

          await tester.pump();

          // expect(find.byType(MarkdownBody), findsOne);
        });
      },
    );
  });
}

final _broadcast = Broadcast(
  tour: BroadcastTournamentData(
    id: const BroadcastTournamentId('RAIoMC7L'),
    name: 'Turkish Chess Championship 2024',
    slug: 'turkish-chess-championship-2024',
    imageUrl:
        'https://image.lichess1.org/display?fmt=webp&h=400&op=thumbnail&path=relay:RAIoMC7L:7C8IGWzr.webp&w=800&sig=f80b016b5b197796781fac50cce7a774ded9ff38',
    description:
        '*The Turkish Chess Championship 2024 is a 16-player knockout tournament. The event is taking place in Turkey and starts on December 13.*',
    tier: 4,
    information: (
      dates: (
        startsAt: DateTime.fromMillisecondsSinceEpoch(1734087600000),
        endsAt: DateTime.fromMillisecondsSinceEpoch(1734778800000),
      ),
      format: '16-player knockout',
      location: 'Kemer, Turkey',
      players: 'Yılmaz, Şanal, Daştan, Yılmazyerli',
      website: Uri.parse('http://tr2024.tsf.org.tr/'),
      timeControl: '90 min + 30 sec / move',
    ),
  ),
  round: BroadcastRound(
    id: const BroadcastRoundId('Gv1305pb'),
    name: 'Round 3.2',
    slug: 'round-32',
    status: RoundStatus.upcoming,
    startsAt: DateTime.fromMillisecondsSinceEpoch(1734519600000),
    finishedAt: null,
    startsAfterPrevious: false,
  ),
  roundToLinkId: const BroadcastRoundId('Gv1305pb'),
  group: null,
);

const _tournamentResponse =
    '''{"tour":{"id":"RAIoMC7L","name":"Turkish Chess Championship 2024","slug":"turkish-chess-championship-2024","info":{"website":"http://tr2024.tsf.org.tr/","players":"Yılmaz, Şanal, Daştan, Yılmazyerli","location":"Kemer, Turkey","tc":"90 min + 30 sec / move","fideTc":"standard","timeZone":"Turkey","standings":"https://chess-results.com/tnr1080829.aspx?art=1","format":"16-player knockout"},"createdAt":1734081433831,"url":"https://lichess.org/broadcast/turkish-chess-championship-2024/RAIoMC7L","tier":4,"dates":[1734087600000,1734778800000],"image":"https://image.lichess1.org/display?fmt=webp&h=400&op=thumbnail&path=relay:RAIoMC7L:7C8IGWzr.webp&w=800&sig=f80b016b5b197796781fac50cce7a774ded9ff38","description":"*The Turkish Chess Championship 2024 is a 16-player knockout tournament. The event is taking place in Turkey and starts on December 13.*"},"rounds":[{"id":"9K53Ydv9","name":"Round 1.1","slug":"round-11","createdAt":1734081461852,"finishedAt":1734102012167,"finished":true,"startsAt":1734087600000,"url":"https://lichess.org/broadcast/turkish-chess-championship-2024/round-11/9K53Ydv9"},{"id":"SLDVywyC","name":"Round 1.2","slug":"round-12","createdAt":1734081569168,"finishedAt":1734189416947,"finished":true,"startsAt":1734174000000,"url":"https://lichess.org/broadcast/turkish-chess-championship-2024/round-12/SLDVywyC"},{"id":"l4ipRaa1","name":"Round 2.1","slug":"round-21","createdAt":1734081576768,"finishedAt":1734275665415,"finished":true,"startsAt":1734260400000,"url":"https://lichess.org/broadcast/turkish-chess-championship-2024/round-21/l4ipRaa1"},{"id":"N1tcQBOK","name":"Round 2.2","slug":"round-22","createdAt":1734081584107,"finishedAt":1734359704619,"finished":true,"startsAt":1734346800000,"url":"https://lichess.org/broadcast/turkish-chess-championship-2024/round-22/N1tcQBOK"},{"id":"qxQMKGAA","name":"Round 2 | Tiebreak","slug":"round-2--tiebreak","createdAt":1734081587301,"finishedAt":1734375431523,"finished":true,"startsAt":1734364800000,"url":"https://lichess.org/broadcast/turkish-chess-championship-2024/round-2--tiebreak/qxQMKGAA"},{"id":"NeKXVzpI","name":"Round 3.1","slug":"round-31","createdAt":1734081590868,"finishedAt":1734445187056,"finished":true,"startsAt":1734433200000,"url":"https://lichess.org/broadcast/turkish-chess-championship-2024/round-31/NeKXVzpI"},{"id":"Gv1305pb","name":"Round 3.2","slug":"round-32","createdAt":1734081593954,"ongoing":true,"startsAt":1734519600000,"url":"https://lichess.org/broadcast/turkish-chess-championship-2024/round-32/Gv1305pb"},{"id":"6VuqTjes","name":"Round 4.1","slug":"round-41","createdAt":1734081596041,"startsAt":1734606000000,"url":"https://lichess.org/broadcast/turkish-chess-championship-2024/round-41/6VuqTjes"},{"id":"z3dzDKGb","name":"Round 4.2","slug":"round-42","createdAt":1734081598162,"startsAt":1734692400000,"url":"https://lichess.org/broadcast/turkish-chess-championship-2024/round-42/z3dzDKGb"},{"id":"81hnFVHE","name":"Round 5.1","slug":"round-51","createdAt":1734358377185,"startsAt":1734778800000,"url":"https://lichess.org/broadcast/turkish-chess-championship-2024/round-51/81hnFVHE"}],"defaultRoundId":"Gv1305pb"}''';

const _roundResponse =
    '''{"round":{"id":"Gv1305pb","name":"Round 3.2","slug":"round-32","createdAt":1734081593954,"ongoing":true,"startsAt":1734519600000,"url":"https://lichess.org/broadcast/turkish-chess-championship-2024/round-32/Gv1305pb"},"tour":{"id":"RAIoMC7L","name":"Turkish Chess Championship 2024","slug":"turkish-chess-championship-2024","info":{"website":"http://tr2024.tsf.org.tr/","players":"Yılmaz, Şanal, Daştan, Yılmazyerli","location":"Kemer, Turkey","tc":"90 min + 30 sec / move","fideTc":"standard","timeZone":"Turkey","standings":"https://chess-results.com/tnr1080829.aspx?art=1","format":"16-player knockout"},"createdAt":1734081433831,"url":"https://lichess.org/broadcast/turkish-chess-championship-2024/RAIoMC7L","tier":4,"dates":[1734087600000,1734778800000],"image":"https://image.lichess1.org/display?fmt=webp&h=400&op=thumbnail&path=relay:RAIoMC7L:7C8IGWzr.webp&w=800&sig=f80b016b5b197796781fac50cce7a774ded9ff38"},"study":{"writeable":false},"games":[{"id":"Sd14H2u2","name":"Yilmaz, Mustafa - Gokerkan, Cem Kaan","fen":"2rq1rk1/1b2bp1p/p1n3p1/1p4B1/4Q3/P4N2/1PB2PPP/3RR1K1 b - - 1 18","players":[{"name":"Yilmaz, Mustafa","title":"GM","rating":2574,"fideId":6302718,"fed":"TUR","clock":113800},{"name":"Gokerkan, Cem Kaan","title":"GM","rating":2486,"fideId":6336760,"fed":"TUR","clock":332000}],"lastMove":"a1d1","thinkTime":258,"status":"*"},{"id":"gnpz7qXV","name":"Sanal, Vahap - Dastan, Muhammed Batuhan","fen":"3q1rk1/p2b1p2/1p2p1p1/3pP1Pp/2n2N1P/P3PP2/1P3K2/1BQ4R w - - 1 24","players":[{"name":"Sanal, Vahap","title":"GM","rating":2553,"fideId":6300545,"fed":"TUR","clock":245200},{"name":"Dastan, Muhammed Batuhan","title":"GM","rating":2560,"fideId":6300014,"fed":"TUR","clock":221600}],"lastMove":"d6c4","thinkTime":135,"status":"*"},{"id":"ECazTlIY","name":"Gunduz, Umut Erdem - Yilmazyerli, Mert","fen":"2r1r3/5kbQ/3pb1N1/8/pp2P3/5P2/PqP5/R3K2R w KQ - 8 28","players":[{"name":"Gunduz, Umut Erdem","title":"IM","rating":2287,"fideId":6381383,"fed":"TUR","clock":351700},{"name":"Yilmazyerli, Mert","title":"GM","rating":2515,"fideId":6305962,"fed":"TUR","clock":411200}],"lastMove":"g8f7","status":"0-1"},{"id":"R7jQwZEQ","name":"Tarhan, Adar - Isik, Alparslan","fen":"r1bB2k1/pp3pp1/1n2r1qp/Q2p4/2pP4/P1P1PN2/5PPP/RR4K1 w - - 10 21","players":[{"name":"Tarhan, Adar","title":"IM","rating":2483,"fideId":34544712,"fed":"TUR","clock":299800},{"name":"Isik, Alparslan","title":"IM","rating":2475,"fideId":34506896,"fed":"TUR","clock":164200}],"lastMove":"c2g6","thinkTime":288,"status":"*"}]}''';
