import 'package:fake_async/fake_async.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_service.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:mocktail/mocktail.dart';

import '../../network/fake_websocket_channel.dart';
import '../../network/socket_test.dart';
import '../../test_container.dart';
import '../auth/fake_session_storage.dart';

class NotificationDisplayMock extends Mock
    implements FlutterLocalNotificationsPlugin {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final notificationDisplayMock = NotificationDisplayMock();

  tearDown(() {
    reset(notificationDisplayMock);
  });

  test('exposes a challenges stream', () async {
    final fakeChannel = FakeWebSocketChannel();
    final socketClient =
        makeTestSocketClient(FakeWebSocketChannelFactory((_) => fakeChannel));
    await socketClient.connect();
    await socketClient.firstConnection;

    fakeChannel.addIncomingMessages([
      '''
{"t": "challenges", "d": {"in": [ { "socketVersion": 0, "id": "H9fIRZUk", "url": "https://lichess.org/H9fIRZUk", "status": "created", "challenger": { "id": "bot1", "name": "Bot1", "rating": 1500, "title": "BOT", "provisional": true, "online": true, "lag": 4 }, "destUser": { "id": "bobby", "name": "Bobby", "rating": 1635, "title": "GM", "provisional": true, "online": true, "lag": 4 }, "variant": { "key": "standard", "name": "Standard", "short": "Std" }, "rated": true, "speed": "rapid", "timeControl": { "type": "clock", "limit": 600, "increment": 0, "show": "10+0" }, "color": "random", "finalColor": "black", "perf": { "icon": "", "name": "Rapid" }, "direction": "in" } ] }, "v": 0 }
'''
    ]);

    await expectLater(
      ChallengeService.stream,
      emitsInOrder([
        const (
          inward: IListConst<Challenge>([
            Challenge(
              socketVersion: 0,
              id: ChallengeId('H9fIRZUk'),
              status: ChallengeStatus.created,
              challenger: (
                user: LightUser(
                  id: UserId('bot1'),
                  name: 'Bot1',
                  title: 'BOT',
                  isOnline: true,
                ),
                rating: 1500,
                provisionalRating: true,
                lagRating: 4,
              ),
              destUser: (
                user: LightUser(
                  id: UserId('bobby'),
                  name: 'Bobby',
                  title: 'GM',
                  isOnline: true,
                ),
                rating: 1635,
                provisionalRating: true,
                lagRating: 4,
              ),
              variant: Variant.standard,
              rated: true,
              speed: Speed.rapid,
              timeControl: ChallengeTimeControlType.clock,
              clock: (
                time: Duration(seconds: 600),
                increment: Duration.zero,
              ),
              sideChoice: SideChoice.random,
              direction: ChallengeDirection.inward,
            ),
          ]),
          outward: IListConst<Challenge>([]),
        ),
      ]),
    );

    socketClient.close();
  });

  test('Listen to socket and show a notification for any new challenge',
      () async {
    when(
      () => notificationDisplayMock.show(
        any(),
        any(),
        any(),
        any(),
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) => Future.value());

    final container = await makeContainer(
      userSession: fakeSession,
      overrides: [
        notificationDisplayProvider.overrideWithValue(notificationDisplayMock),
      ],
    );

    final notificationService = container.read(notificationServiceProvider);
    final challengeService = container.read(challengeServiceProvider);

    fakeAsync((async) {
      final fakeChannel = FakeWebSocketChannel();
      final socketClient =
          makeTestSocketClient(FakeWebSocketChannelFactory((_) => fakeChannel));
      socketClient.connect();
      notificationService.start();
      challengeService.start();

      // wait for the socket to connect
      async.elapse(const Duration(milliseconds: 100));
      async.flushMicrotasks();

      fakeChannel.addIncomingMessages([
        '''
{"t": "challenges", "d": {"in": [ { "socketVersion": 0, "id": "H9fIRZUk", "url": "https://lichess.org/H9fIRZUk", "status": "created", "challenger": { "id": "bot1", "name": "Bot1", "rating": 1500, "title": "BOT", "provisional": true, "online": true, "lag": 4 }, "destUser": { "id": "bobby", "name": "Bobby", "rating": 1635, "title": "GM", "provisional": true, "online": true, "lag": 4 }, "variant": { "key": "standard", "name": "Standard", "short": "Std" }, "rated": true, "speed": "rapid", "timeControl": { "type": "clock", "limit": 600, "increment": 0, "show": "10+0" }, "color": "random", "finalColor": "black", "perf": { "icon": "", "name": "Rapid" }, "direction": "in" } ] }, "v": 0 }
'''
      ]);

      async.flushMicrotasks();

      final result = verify(
        () => notificationDisplayMock.show(
          const ChallengeId('H9fIRZUk').hashCode,
          'Bot1 challenges you!',
          'Random side • Rated • 10+0',
          captureAny(),
          payload: any(named: 'payload'),
        ),
      );

      expectLater(result.callCount, 1);
      expectLater(
        result.captured[0],
        isA<NotificationDetails>()
            .having(
              (details) => details.android?.channelId,
              'channelId',
              'challenge',
            )
            .having(
              (d) => d.android?.importance,
              'importance',
              Importance.max,
            )
            .having(
              (d) => d.android?.priority,
              'priority',
              Priority.high,
            ),
      );

      fakeChannel.addIncomingMessages([
        '''
{"t": "challenges", "d": {"in": [ { "socketVersion": 0, "id": "H9fIRZUk", "url": "https://lichess.org/H9fIRZUk", "status": "created", "challenger": { "id": "bot1", "name": "Bot1", "rating": 1500, "title": "BOT", "provisional": true, "online": true, "lag": 4 }, "destUser": { "id": "bobby", "name": "Bobby", "rating": 1635, "title": "GM", "provisional": true, "online": true, "lag": 4 }, "variant": { "key": "standard", "name": "Standard", "short": "Std" }, "rated": true, "speed": "rapid", "timeControl": { "type": "clock", "limit": 600, "increment": 0, "show": "10+0" }, "color": "random", "finalColor": "black", "perf": { "icon": "", "name": "Rapid" }, "direction": "in" } ] }, "v": 0 }
'''
      ]);

      async.flushMicrotasks();

      // same notification should not be shown again
      verifyNever(
        () => notificationDisplayMock.show(
          any(),
          any(),
          any(),
          any(),
          payload: any(named: 'payload'),
        ),
      );

      // closing the socket client to be able to flush the timers
      socketClient.close();
      async.flushTimers();
    });
  });

  test('Cancels the notification for any missing challenge', () async {
    when(
      () => notificationDisplayMock.show(
        any(),
        any(),
        any(),
        any(),
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) => Future.value());

    when(
      () => notificationDisplayMock.cancel(
        any(),
      ),
    ).thenAnswer((_) => Future.value());

    final container = await makeContainer(
      userSession: fakeSession,
      overrides: [
        notificationDisplayProvider.overrideWithValue(notificationDisplayMock),
      ],
    );

    final notificationService = container.read(notificationServiceProvider);
    final challengeService = container.read(challengeServiceProvider);

    fakeAsync((async) {
      final fakeChannel = FakeWebSocketChannel();
      final socketClient =
          makeTestSocketClient(FakeWebSocketChannelFactory((_) => fakeChannel));
      socketClient.connect();
      notificationService.start();
      challengeService.start();

      // wait for the socket to connect
      async.elapse(const Duration(milliseconds: 100));
      async.flushMicrotasks();

      fakeChannel.addIncomingMessages([
        '''
{"t": "challenges", "d": {"in": [ { "socketVersion": 0, "id": "H9fIRZUk", "url": "https://lichess.org/H9fIRZUk", "status": "created", "challenger": { "id": "bot1", "name": "Bot1", "rating": 1500, "title": "BOT", "provisional": true, "online": true, "lag": 4 }, "destUser": { "id": "bobby", "name": "Bobby", "rating": 1635, "title": "GM", "provisional": true, "online": true, "lag": 4 }, "variant": { "key": "standard", "name": "Standard", "short": "Std" }, "rated": true, "speed": "rapid", "timeControl": { "type": "clock", "limit": 600, "increment": 0, "show": "10+0" }, "color": "random", "finalColor": "black", "perf": { "icon": "", "name": "Rapid" }, "direction": "in" } ] }, "v": 0 }
'''
      ]);

      async.flushMicrotasks();

      verify(
        () => notificationDisplayMock.show(
          any(),
          any(),
          any(),
          captureAny(),
          payload: any(named: 'payload'),
        ),
      );

      fakeChannel.addIncomingMessages([
        '''
{"t": "challenges", "d": {"in": [] }, "v": 0 }
'''
      ]);

      async.flushMicrotasks();

      verify(
        () => notificationDisplayMock.cancel(
          const ChallengeId('H9fIRZUk').hashCode,
        ),
      ).called(1);

      // closing the socket client to be able to flush the timers
      socketClient.close();
      async.flushTimers();
    });
  });
}
