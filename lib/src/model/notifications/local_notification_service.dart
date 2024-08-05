import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/notifications/challenge_notification.dart';
import 'package:lichess_mobile/src/model/notifications/info_notification.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_notification_service.g.dart';
part 'local_notification_service.freezed.dart';

@Riverpod(keepAlive: true)
LocalNotificationService localNotificationService(
  LocalNotificationServiceRef ref,
) {
  return LocalNotificationService(ref, Logger('LocalNotificationService'));
}

typedef NotificationCallback = void Function(
  String?,
  LocalNotificationServiceRef,
);

class LocalNotificationService {
  LocalNotificationService(this._ref, this._log);

  static LocalNotificationService? instance;
  final _notificationPlugin = FlutterLocalNotificationsPlugin();
  final LocalNotificationServiceRef _ref;
  final Logger _log;
  int currentId = 0;

  Future<void> init() async {
    instance = this;
    final l10n = _ref.watch(l10nProvider);

    // update localizations
    InfoNotificationDetails(l10n.strings);
    ChallengeNotificationDetails(l10n.strings);

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
      onDidReceiveNotificationResponse: _notificationRespsonse,
      onDidReceiveBackgroundNotificationResponse: _notificationRespsonse,
    );
    _log.info(
      '[Local Notifications] initialized',
    );
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
    return id;
  }

  Future<void> cancel(int id) async {
    _log.info(
      '[Local Notifications] canceled notification (id: $id)',
    );
    return _notificationPlugin.cancel(id);
  }

  void call(NotificationCallback callback, String? actionId) =>
      callback(actionId, _ref);

  @pragma('vm:entry-point')
  static void _notificationRespsonse(NotificationResponse response) {
    if (response.payload == null) return;

    final service = LocalNotificationService.instance;
    if (service == null) return;

    try {
      final splits = response.payload!.split(':');

      final id = splits[0];
      final payload = splits[1];
      switch (id) {
        case 'challenge-notification':
          final notification = ChallengeNotification(ChallengeId(payload));
          service.call(notification.callback, response.actionId);
      }
    } catch (error) {
      Logger('LocalNotificationService').warning(
        'Malformed notification payload: [ID: ${response.id}] ${response.payload}',
      );
    }
  }
}

@freezed
class LocalNotification with _$LocalNotification {
  factory LocalNotification({
    required String title,
    String? body,
    String? payload,
    required NotificationDetails notificationDetails,
  }) = _LocalNotification;
}
