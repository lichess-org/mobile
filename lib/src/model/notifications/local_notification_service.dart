import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lichess_mobile/src/model/notifications/challenge_notification.dart';
import 'package:lichess_mobile/src/model/notifications/info_notification.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_notification_service.g.dart';

@Riverpod(keepAlive: true)
LocalNotificationService localNotificationService(
  LocalNotificationServiceRef ref,
) {
  return LocalNotificationService(ref, Logger('LocalNotificationService'));
}

class LocalNotificationService {
  LocalNotificationService(this._ref, this._log);

  static LocalNotificationService? instance;
  final LocalNotificationServiceRef _ref;
  final Logger _log;
  final Map<int, void Function(String?, String?)> _callbacks = {};
  final _notificationPlugin = FlutterLocalNotificationsPlugin();
  final _receivePort = ReceivePort();

  int currentId = 0;

  Future<void> init() async {
    instance = this;
    final l10n = _ref.watch(l10nProvider);

    // update localizations
    InfoNotificationDetails(l10n.strings);
    ChallengeNotificationDetails(l10n.strings);

    // hot reloading doesnt remove the port so we just make sure it doesnt exist before registering it
    IsolateNameServer.removePortNameMapping('localNotificationServicePort');
    IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      'localNotificationServicePort',
    );
    _receivePort.listen(_onReceivePortMessage);

    await _notificationPlugin.initialize(
      InitializationSettings(
        android: const AndroidInitializationSettings('logo_black'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          notificationCategories: <DarwinNotificationCategory>[
            ChallengeNotificationDetails.instance.darwinNotificationCategory,
          ],
        ),
      ),
      onDidReceiveNotificationResponse: _notificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          _notificationBackgroundResponse,
    );
    _log.info('[Local Notifications] initialized');
  }

  Future<int> show(LocalNotification notification) async {
    final id = currentId++;
    await _notificationPlugin.show(
      id,
      notification.title,
      notification.body,
      notification.notificationDetails,
      payload: notification.payload,
    );
    _log.info(
      '[Local Notifications] Sent notification: ($id | ${notification.title}) ${notification.body} (Payload: ${notification.payload})',
    );

    // if the notification implements LocalNotificaitonCallback
    if (notification is LocalNotificationCallback) {
      _callbacks[id] = (notification as LocalNotificationCallback).callback;
      _log.info('[Local Notifications] registered callback for id [$id]');
    }

    return id;
  }

  Future<void> cancel(int id) async {
    _log.info('[Local Notifications] canceled notification id: [$id]');
    return _notificationPlugin.cancel(id);
  }

  void _onReceivePortMessage(dynamic message) {
    try {
      final data = message as Map<String, Object?>;
      final response = NotificationResponse(
        notificationResponseType:
            NotificationResponseType.values[data['index']! as int],
        id: data['id'] as int?,
        actionId: data['actionId'] as String?,
        input: data['input'] as String?,
        payload: data['payload'] as String?,
      );
      _notificationResponse(response);
    } catch (e) {
      _log.severe(
        '[Local Notifications] failed to parse message from background isoalte',
      );
    }
  }

  void _notificationResponse(NotificationResponse response) {
    final callback = _callbacks[response.id];
    if (callback != null) callback(response.actionId, response.payload);
  }

  @pragma('vm:entry-point')
  static void _notificationBackgroundResponse(NotificationResponse response) {
    final sendPort =
        IsolateNameServer.lookupPortByName('localNotificationServicePort');
    sendPort!.send(
      {
        'index': response.notificationResponseType.index,
        'id': response.id,
        'actionId': response.actionId,
        'input': response.input,
        'payload': response.payload,
      },
    );
  }
}

abstract class LocalNotification {
  LocalNotification(
    this.title,
    this.notificationDetails, {
    this.body,
    this.payload,
  });

  final String title;
  final String? body;
  final String? payload;
  final NotificationDetails notificationDetails;
}

abstract class LocalNotificationCallback {
  void callback(String? actionId, String? payload);
}
