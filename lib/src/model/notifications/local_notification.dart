import 'dart:async';
import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';

part 'local_notification.g.dart';
part 'local_notification.freezed.dart';

final _logger = Logger('LocalNotification');

final StreamController<(NotificationResponse, NotificationPayload)>
    _responseStreamController = StreamController.broadcast();

/// Stream of locale notification responses (when the user interacts with a notification).
final Stream<(NotificationResponse, NotificationPayload)>
    localNotificationResponseStream = _responseStreamController.stream;

/// Function called by the flutter_local_notifications plugin when a notification is received in the foreground.
void onDidReceiveNotificationResponse(NotificationResponse response) {
  _logger.info('processing response in foreground. id [${response.id}]');

  if (response.id == null || response.payload == null) return;

  try {
    final payload = NotificationPayload.fromJson(
      jsonDecode(response.payload!) as Map<String, dynamic>,
    );
    _responseStreamController.add((response, payload));
  } catch (e) {
    _logger.warning('Failed to parse notification payload: $e');
  }
}

enum PayloadType {
  info,
  challenge,
}

@Freezed(fromJson: true, toJson: true)
class NotificationPayload with _$NotificationPayload {
  factory NotificationPayload({
    required PayloadType type,
    required Map<String, dynamic> data,
  }) = _NotificationPayload;

  factory NotificationPayload.fromJson(Map<String, dynamic> json) =>
      _$NotificationPayloadFromJson(json);
}

/// A local notification that can be shown to the user.
abstract class LocalNotification {
  int get id;
  String get title;
  String? get body;
  NotificationPayload? get payload;
  NotificationDetails get notificationDetails;
}
