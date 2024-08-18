import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/app_initialization.dart';
import 'package:lichess_mobile/src/model/notifications/challenge_notification.dart';
import 'package:lichess_mobile/src/model/notifications/info_notification.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
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

class LocalNotificationService {
  LocalNotificationService(this._ref, this._log);

  final LocalNotificationServiceRef _ref;
  final Logger _log;
  final _notificationPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    _updateLocalisations();
    _ref.listen(generalPreferencesProvider, (prev, now) {
      if (prev!.locale == now.locale) return;
      _updateLocalisations();
    });

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
    _log.info('initialized');
  }

  void _updateLocalisations() {
    final l10n = _ref.read(l10nProvider);
    InfoNotificationDetails(l10n.strings);
    ChallengeNotificationDetails(l10n.strings);
  }

  Future<int> show(LocalNotification notification) async {
    final id = notification.id;
    final payload = notification.payload != null
        ? jsonEncode(notification.payload!.toJson())
        : '';

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

  void _handleResponse(int id, String? actionId, NotificationPayload payload) {
    switch (payload.type) {
      case PayloadType.info:
      case PayloadType.challenge:
        _ref.read(challengeServiceProvider).onNotificationResponse(
              id,
              actionId,
              ChallengePayload.fromNotificationPayload(payload),
            );
    }
  }

  void _notificationResponse(NotificationResponse response) {
    _log.info('processing response in foreground. id [${response.id}]');
    if (response.id == null || response.payload == null) return;

    try {
      final payload = NotificationPayload.fromJson(
        jsonDecode(response.payload!) as Map<String, dynamic>,
      );
      _handleResponse(response.id!, response.actionId, payload);
    } catch (e) {
      _log.warning('Failed to parse notification payload: $e');
    }
  }

  @pragma('vm:entry-point')
  static void _notificationBackgroundResponse(
    NotificationResponse response,
  ) {
    final logger = Logger('LocalNotificationService');
    logger.info('processing response in background. id [${response.id}]');

    // create a new provider scope for the background isolate
    final ref = ProviderContainer();

    ref.listen(
      appInitializationProvider,
      (prev, now) {
        if (!now.hasValue) return;

        try {
          final payload = NotificationPayload.fromJson(
            jsonDecode(response.payload!) as Map<String, dynamic>,
          );
          ref
              .read(localNotificationServiceProvider)
              ._handleResponse(response.id!, response.actionId, payload);
        } catch (e) {
          logger.warning('failed to parse notification payload: $e');
        }
      },
    );

    ref.read(appInitializationProvider);
  }
}

enum PayloadType {
  info,
  challenge,
}

@freezed
class LocalnotificationResponse with _$LocalnotificationResponse {
  factory LocalnotificationResponse({
    required int id,
    required String? actionId,
    required NotificationPayload payload,
    String? input,
  }) = _LocalnotificationResponse;
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

abstract class LocalNotification {
  LocalNotification(
    this.title,
    this.notificationDetails, {
    this.body,
    this.payload,
  });

  int get id;

  final String title;
  final String? body;
  final NotificationPayload? payload;
  final NotificationDetails notificationDetails;
}
