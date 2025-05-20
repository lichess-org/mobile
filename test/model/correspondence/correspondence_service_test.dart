import 'package:fake_async/fake_async.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_game_storage.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_service.dart';
import 'package:lichess_mobile/src/model/correspondence/offline_correspondence_game.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:mocktail/mocktail.dart';

import '../../binding.dart';
import '../../example_data.dart';
import '../../test_container.dart';
import '../auth/fake_session_storage.dart';

class NotificationDisplayMock extends Mock implements FlutterLocalNotificationsPlugin {}

class CorrespondenceGameStorageMock extends Mock implements CorrespondenceGameStorage {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final notificationDisplayMock = NotificationDisplayMock();
  final correspondenceGameStorageMock = CorrespondenceGameStorageMock();

  setUpAll(() {
    registerFallbackValue(offlineCorrespondenceGame);
  });

  tearDown(() {
    reset(notificationDisplayMock);
    reset(correspondenceGameStorageMock);
  });

  const fullId = GameFullId('Fn9UvVKFsopx');

  test('FCM game data message will update the game', () async {
    when(
      () =>
          notificationDisplayMock.show(any(), any(), any(), any(), payload: any(named: 'payload')),
    ).thenAnswer((_) => Future.value());

    when(() => correspondenceGameStorageMock.save(any())).thenAnswer((_) => Future.value());

    final container = await makeContainer(
      userSession: fakeSession,
      overrides: [
        correspondenceGameStorageProvider.overrideWith((_) => correspondenceGameStorageMock),
        notificationDisplayProvider.overrideWithValue(notificationDisplayMock),
      ],
    );

    final notificationService = container.read(notificationServiceProvider);
    final correspondenceService = container.read(correspondenceServiceProvider);

    fakeAsync((async) {
      notificationService.start();
      correspondenceService.start();
      async.flushMicrotasks();

      testBinding.firebaseMessaging.onMessage.add(
        const RemoteMessage(
          data: {
            'lichess.type': 'gameMove',
            'lichess.fullId': 'Fn9UvVKFsopx',
            'lichess.round':
                '{"game":{"id":"Fn9UvVKF","variant":{"key":"standard","name":"Standard","short":"Std"},"speed":"bullet","perf":"bullet","rated":true,"fen":"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1","turns":0,"source":"lobby","status":{"id":20,"name":"started"},"createdAt":1706204482969,"pgn":""},"white":{"user":{"name":"chabrot","id":"chabrot"},"rating":1801},"black":{"user":{"name":"veloce","id":"veloce"},"rating":1798},"socket":0,"expiration":{"idleMillis":67,"millisToMove":20000},"clock":{"running":false,"initial":120,"increment":1,"white":120,"black":120,"emerg":15,"moretime":15},"takebackable":true,"youAre":"black","prefs":{"autoQueen":2,"zen":2,"confirmResign":true,"enablePremove":true},"chat":{"lines":[]}}',
          },
          notification: RemoteNotification(
            title: 'It is your turn!',
            body: 'Dr-Alaakour played a move',
          ),
        ),
      );

      async.flushMicrotasks();

      verify(
        () => notificationDisplayMock.show(
          any(),
          any(),
          any(),
          any(),
          payload: any(named: 'payload'),
        ),
      ).called(1);

      verify(
        () => correspondenceGameStorageMock.save(
          any(that: isA<OfflineCorrespondenceGame>().having((g) => g.fullId, 'fullId', fullId)),
        ),
      ).called(1);
    });
  });

  test('FCM game data message without notification', () async {
    when(() => correspondenceGameStorageMock.save(any())).thenAnswer((_) => Future.value());

    final container = await makeContainer(
      userSession: fakeSession,
      overrides: [
        correspondenceGameStorageProvider.overrideWith((_) => correspondenceGameStorageMock),
        notificationDisplayProvider.overrideWith((_) => notificationDisplayMock),
      ],
    );

    final notificationService = container.read(notificationServiceProvider);
    final correspondenceService = container.read(correspondenceServiceProvider);

    FakeAsync().run((async) {
      notificationService.start();
      correspondenceService.start();

      async.flushMicrotasks();

      testBinding.firebaseMessaging.onMessage.add(
        const RemoteMessage(
          data: {
            'lichess.type': 'gameMove',
            'lichess.fullId': 'Fn9UvVKFsopx',
            'lichess.round':
                '{"game":{"id":"Fn9UvVKF","variant":{"key":"standard","name":"Standard","short":"Std"},"speed":"bullet","perf":"bullet","rated":true,"fen":"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1","turns":0,"source":"lobby","status":{"id":20,"name":"started"},"createdAt":1706204482969,"pgn":""},"white":{"user":{"name":"chabrot","id":"chabrot"},"rating":1801},"black":{"user":{"name":"veloce","id":"veloce"},"rating":1798},"socket":0,"expiration":{"idleMillis":67,"millisToMove":20000},"clock":{"running":false,"initial":120,"increment":1,"white":120,"black":120,"emerg":15,"moretime":15},"takebackable":true,"youAre":"black","prefs":{"autoQueen":2,"zen":2,"confirmResign":true,"enablePremove":true},"chat":{"lines":[]}}',
          },
        ),
      );

      async.flushMicrotasks();

      verify(
        () => correspondenceGameStorageMock.save(
          any(that: isA<OfflineCorrespondenceGame>().having((g) => g.fullId, 'fullId', fullId)),
        ),
      ).called(1);

      verifyNever(
        () => notificationDisplayMock.show(
          any(),
          any(),
          any(),
          any(),
          payload: any(named: 'payload'),
        ),
      );
    });
  });
}
