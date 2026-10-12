import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/notifications/notifications.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/service/notification_service/notification_service.dart';
import 'package:unifiedpush/unifiedpush.dart' hide PushMessage;
import 'package:unifiedpush/unifiedpush.dart' as unifiedpush show PushMessage;

/// Notification service implementation using UnifiedPush
class UnifiedPushService(super.ref) extends NotificationService {
  @override
  Future<bool> register() async {
    notificationLogger.info('register device for the first time');
    final canRegister = await UnifiedPush.tryUseCurrentOrDefaultDistributor();
    if (canRegister) {
      await UnifiedPush.register(vapid: kLichessVapidPublicKey);
      return true;
    } else {
      notificationLogger.info('could not find a distributor');
      return false;
    }
  }

  @override
  Future<void> unregister() async {
    notificationLogger.info('will unregister');
    await UnifiedPush.unregister();
  }

  @override
  Future<void> start() async {
    startAuthEventListener();

    try {
      await ref
          .read(notificationDisplayProvider)
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } catch (e, st) {
      notificationLogger.warning('notification permission request failed with error:', e, st);
    }

    final isRegistered = await UnifiedPush.initialize(
      onNewEndpoint: onNewEndpoint,
      onMessage: onMessage,
    );
    if (isRegistered) {
      UnifiedPush.register(vapid: kLichessVapidPublicKey);
    } else {
      if (ref.read(isLoggedInProvider)) {
        register();
      }
    }
  }

  @override
  bool shouldShow(ParsedPushMessage message, {required bool fromBackground}) {
    if (message is ChallengeCreatePushMessage && !fromBackground) return false;
    return message.hasDisplayableNotification;
  }

  void onNewEndpoint(PushEndpoint endpoint, String instance) {
    final pubKeySet = endpoint.pubKeySet;
    if (pubKeySet == null) {
      notificationLogger.warning('no public key found');
      return;
    }

    final body = {
      'endpoint': endpoint.url,
      'keys': {'auth': pubKeySet.auth, 'p256dh': pubKeySet.pubKey},
    };

    ref
        .withClient(
          (client) => client.post(
            Uri(path: '/push/subscribe'),
            body: jsonEncode(body),
            headers: {'Content-Type': 'application/json'},
          ),
        )
        .then((response) {
          final statusCode = response.statusCode;
          if (200 <= statusCode && statusCode < 300) {
            notificationLogger.info('new endpoint sent successfully');
          } else {
            notificationLogger.warning(
              'new endpoint sent but request failed with status code $statusCode',
            );
          }
        })
        .catchError((Object err) {
          notificationLogger.warning('sending new endpoint failed with error $err');
        });
  }

  void onMessage(unifiedpush.PushMessage message, String instance) {
    notificationLogger.info('received a push message');
    final pushMessage = message.toPushMessage();

    final AppLifecycleState? appState = WidgetsBinding.instance.lifecycleState;
    if (appState == null) {
      notificationLogger.warning('could not detect app lifecycle state');
    }
    final inForeground = appState == AppLifecycleState.resumed;

    processPushMessage(pushMessage, fromBackground: !inForeground);
  }
}

extension on unifiedpush.PushMessage {
  PushMessage toPushMessage() {
    final json = jsonDecode(utf8.decode(content)) as Map<String, dynamic>;
    final data = json['data'] as Map<String, dynamic>;
    final notification = json['notification'] as Map<String, dynamic>?;
    final pushNotification = notification != null
        ? PushNotification(
            title: notification['title'] as String,
            body: notification['body'] as String,
          )
        : null;
    return PushMessage(data: data, notification: pushNotification);
  }
}
