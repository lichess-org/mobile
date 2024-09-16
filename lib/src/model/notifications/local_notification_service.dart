import 'dart:async';
import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lichess_mobile/src/model/notifications/local_notification.dart';
import 'package:logging/logging.dart';

final _notificationPlugin = FlutterLocalNotificationsPlugin();

class LocalNotificationService {
  const LocalNotificationService._(this._log);

  static final instance =
      LocalNotificationService._(Logger('LocalNotificationService'));

  final Logger _log;

  Future<int> show(LocalNotification notification) async {
    final id = notification.id;
    final payload = notification.payload != null
        ? jsonEncode(notification.payload!.toJson())
        : null;

    await _notificationPlugin.show(
      id,
      notification.title,
      notification.body,
      notification.notificationDetails,
      payload: payload,
    );
    _log.info(
      'Sent notification: ($id | ${notification.title}) ${notification.body} (Payload: ${notification.payload})',
    );

    return id;
  }

  Future<void> cancel(int id) async {
    _log.info('canceled notification id: [$id]');
    return _notificationPlugin.cancel(id);
  }
}
