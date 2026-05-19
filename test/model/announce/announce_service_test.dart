import 'dart:convert';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/announce/announce_service.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/notifications/notifications.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:mocktail/mocktail.dart';

import '../../network/fake_websocket_channel.dart';
import '../../network/socket_test.dart';
import '../../test_container.dart';

class _NotificationDisplayMock extends Mock implements FlutterLocalNotificationsPlugin {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final notificationDisplayMock = _NotificationDisplayMock();

  setUp(() {
    when(
      () => notificationDisplayMock.show(
        id: any(named: 'id'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        notificationDetails: any(named: 'notificationDetails'),
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) => Future.value());

    when(
      () => notificationDisplayMock.cancel(id: any(named: 'id')),
    ).thenAnswer((_) => Future.value());
  });

  tearDown(() {
    reset(notificationDisplayMock);
  });

  test('shows a notification when an announce is received', () async {
    final container = await makeContainer(
      overrides: {
        notificationDisplayProvider: notificationDisplayProvider.overrideWithValue(
          notificationDisplayMock,
        ),
      },
    );

    fakeAsync((async) {
      final socketClient = makeTestSocketClient();
      socketClient.connect();
      container.read(notificationServiceProvider).start();
      container.read(announceServiceProvider).start();

      async.elapse(const Duration(milliseconds: 100));
      async.flushMicrotasks();

      sendServerSocketMessages(Uri(path: kDefaultSocketRoute), [
        '{"t":"announce","d":{"msg":"Lichess will restart"}}',
      ]);

      async.flushMicrotasks();

      verify(
        () => notificationDisplayMock.show(
          id: AnnounceNotification.notificationId,
          title: 'Lichess will restart',
          body: null,
          notificationDetails: any(named: 'notificationDetails'),
          payload: any(named: 'payload'),
        ),
      ).called(1);

      socketClient.close();
      async.flushTimers();
    });
  });

  test('cancels the notification when an empty announce is received', () async {
    final container = await makeContainer(
      overrides: {
        notificationDisplayProvider: notificationDisplayProvider.overrideWithValue(
          notificationDisplayMock,
        ),
      },
    );

    fakeAsync((async) {
      final socketClient = makeTestSocketClient();
      socketClient.connect();
      container.read(notificationServiceProvider).start();
      container.read(announceServiceProvider).start();

      async.elapse(const Duration(milliseconds: 100));
      async.flushMicrotasks();

      sendServerSocketMessages(Uri(path: kDefaultSocketRoute), [
        '{"t":"announce","d":{"msg":"Lichess will restart"}}',
      ]);

      async.flushMicrotasks();

      verify(
        () => notificationDisplayMock.show(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          notificationDetails: any(named: 'notificationDetails'),
          payload: any(named: 'payload'),
        ),
      ).called(1);

      sendServerSocketMessages(Uri(path: kDefaultSocketRoute), ['{"t":"announce","d":{}}']);

      async.flushMicrotasks();

      verify(
        () => notificationDisplayMock.cancel(id: AnnounceNotification.notificationId),
      ).called(1);

      socketClient.close();
      async.flushTimers();
    });
  });

  test('auto-cancels the notification when the countdown date is reached', () async {
    final container = await makeContainer(
      overrides: {
        notificationDisplayProvider: notificationDisplayProvider.overrideWithValue(
          notificationDisplayMock,
        ),
      },
    );

    fakeAsync((async) {
      final socketClient = makeTestSocketClient();
      socketClient.connect();
      container.read(notificationServiceProvider).start();
      container.read(announceServiceProvider).start();

      async.elapse(const Duration(milliseconds: 100));
      async.flushMicrotasks();

      final date = DateTime.now().add(const Duration(minutes: 5));
      sendServerSocketMessages(Uri(path: kDefaultSocketRoute), [
        '{"t":"announce","d":{"msg":"Lichess will restart","date":"${date.toIso8601String()}"}}',
      ]);

      async.flushMicrotasks();

      verify(
        () => notificationDisplayMock.show(
          id: AnnounceNotification.notificationId,
          title: 'Lichess will restart',
          body: any(named: 'body'),
          notificationDetails: any(named: 'notificationDetails'),
          payload: any(named: 'payload'),
        ),
      ).called(1);

      verifyNever(() => notificationDisplayMock.cancel(id: any(named: 'id')));

      async.elapse(const Duration(minutes: 5, seconds: 1));
      async.flushMicrotasks();

      verify(
        () => notificationDisplayMock.cancel(id: AnnounceNotification.notificationId),
      ).called(1);

      socketClient.close();
      async.flushTimers();
    });
  });

  test('does not show a notification when the announce date is already in the past', () async {
    final container = await makeContainer(
      overrides: {
        notificationDisplayProvider: notificationDisplayProvider.overrideWithValue(
          notificationDisplayMock,
        ),
      },
    );

    fakeAsync((async) {
      final socketClient = makeTestSocketClient();
      socketClient.connect();
      container.read(notificationServiceProvider).start();
      container.read(announceServiceProvider).start();

      async.elapse(const Duration(milliseconds: 100));
      async.flushMicrotasks();

      final expiredDate = DateTime.now().subtract(const Duration(minutes: 1));
      sendServerSocketMessages(Uri(path: kDefaultSocketRoute), [
        '{"t":"announce","d":{"msg":"Lichess will restart","date":"${expiredDate.toIso8601String()}"}}',
      ]);

      async.flushMicrotasks();

      verifyNever(
        () => notificationDisplayMock.show(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          notificationDetails: any(named: 'notificationDetails'),
          payload: any(named: 'payload'),
        ),
      );

      socketClient.close();
      async.flushTimers();
    });
  });

  test('replaces the notification when a new announce is received', () async {
    final container = await makeContainer(
      overrides: {
        notificationDisplayProvider: notificationDisplayProvider.overrideWithValue(
          notificationDisplayMock,
        ),
      },
    );

    fakeAsync((async) {
      final socketClient = makeTestSocketClient();
      socketClient.connect();
      container.read(notificationServiceProvider).start();
      container.read(announceServiceProvider).start();

      async.elapse(const Duration(milliseconds: 100));
      async.flushMicrotasks();

      sendServerSocketMessages(Uri(path: kDefaultSocketRoute), [
        '{"t":"announce","d":{"msg":"First announcement"}}',
      ]);

      async.flushMicrotasks();

      verify(
        () => notificationDisplayMock.show(
          id: AnnounceNotification.notificationId,
          title: 'First announcement',
          body: null,
          notificationDetails: any(named: 'notificationDetails'),
          payload: any(named: 'payload'),
        ),
      ).called(1);

      sendServerSocketMessages(Uri(path: kDefaultSocketRoute), [
        '{"t":"announce","d":{"msg":"Second announcement"}}',
      ]);

      async.flushMicrotasks();

      // second announce shown with the same fixed ID, replacing the first
      verify(
        () => notificationDisplayMock.show(
          id: AnnounceNotification.notificationId,
          title: 'Second announcement',
          body: null,
          notificationDetails: any(named: 'notificationDetails'),
          payload: any(named: 'payload'),
        ),
      ).called(1);

      socketClient.close();
      async.flushTimers();
    });
  });

  test('cancels the previous timer when a new announce is received', () async {
    final container = await makeContainer(
      overrides: {
        notificationDisplayProvider: notificationDisplayProvider.overrideWithValue(
          notificationDisplayMock,
        ),
      },
    );

    fakeAsync((async) {
      final socketClient = makeTestSocketClient();
      socketClient.connect();
      container.read(notificationServiceProvider).start();
      container.read(announceServiceProvider).start();

      async.elapse(const Duration(milliseconds: 100));
      async.flushMicrotasks();

      // first announce with a 5-minute countdown
      final firstDate = DateTime.now().add(const Duration(minutes: 5));
      sendServerSocketMessages(Uri(path: kDefaultSocketRoute), [
        '{"t":"announce","d":{"msg":"First","date":"${firstDate.toIso8601String()}"}}',
      ]);

      async.flushMicrotasks();

      // second announce with no date replaces the first and cancels its timer
      sendServerSocketMessages(Uri(path: kDefaultSocketRoute), [
        '{"t":"announce","d":{"msg":"Second"}}',
      ]);

      async.flushMicrotasks();

      // advance past the first countdown — the old timer must not fire
      async.elapse(const Duration(minutes: 5, seconds: 1));
      async.flushMicrotasks();

      verifyNever(() => notificationDisplayMock.cancel(id: any(named: 'id')));

      socketClient.close();
      async.flushTimers();
    });
  });

  test('cancels the notification when the user taps the dismiss action', () async {
    final container = await makeContainer(
      overrides: {
        notificationDisplayProvider: notificationDisplayProvider.overrideWithValue(
          notificationDisplayMock,
        ),
      },
    );

    fakeAsync((async) {
      final socketClient = makeTestSocketClient();
      socketClient.connect();
      container.read(notificationServiceProvider).start();
      container.read(announceServiceProvider).start();

      async.elapse(const Duration(milliseconds: 100));
      async.flushMicrotasks();

      sendServerSocketMessages(Uri(path: kDefaultSocketRoute), [
        '{"t":"announce","d":{"msg":"Lichess will restart"}}',
      ]);

      async.flushMicrotasks();

      verify(
        () => notificationDisplayMock.show(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          notificationDetails: any(named: 'notificationDetails'),
          payload: any(named: 'payload'),
        ),
      ).called(1);

      // simulate the user tapping the dismiss action button
      const notification = AnnounceNotification('Lichess will restart');
      NotificationService.onDidReceiveNotificationResponse(
        NotificationResponse(
          notificationResponseType: NotificationResponseType.selectedNotificationAction,
          id: AnnounceNotification.notificationId,
          actionId: AnnounceNotification.dismissActionId,
          payload: jsonEncode(notification.payload),
        ),
      );

      async.flushMicrotasks();

      verify(
        () => notificationDisplayMock.cancel(id: AnnounceNotification.notificationId),
      ).called(1);

      socketClient.close();
      async.flushTimers();
    });
  });
}
