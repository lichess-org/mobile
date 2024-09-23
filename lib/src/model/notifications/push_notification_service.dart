import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/app_initialization.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_service.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/utils/badge_service.dart';
import 'package:lichess_mobile/src/utils/connectivity.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'push_notification_service.g.dart';

@Riverpod(keepAlive: true)
PushNotificationService pushNotificationService(
  PushNotificationServiceRef ref,
) {
  final service = PushNotificationService(
    Logger('PushNotificationService'),
    ref: ref,
  );

  ref.onDispose(() => service._dispose());

  return service;
}

class PushNotificationService {
  PushNotificationService(this._log, {required this.ref});

  final PushNotificationServiceRef ref;
  final Logger _log;

  StreamSubscription<String>? _fcmTokenRefreshSubscription;
  ProviderSubscription<AsyncValue<ConnectivityStatus>>?
      _connectivitySubscription;

  bool _registeredDevice = false;

  /// Starts the push notification service.
  Future<void> start() async {
    _connectivitySubscription =
        ref.listen(connectivityChangesProvider, (prev, current) async {
      // register device once the app is online
      if (current.value?.isOnline == true && !_registeredDevice) {
        try {
          await registerDevice();
          _registeredDevice = true;
        } catch (e, st) {
          debugPrint('Could not setup push notifications; $e\n$st');
        }
      }
    });

    // Listen for incoming messages while the app is in the foreground.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _log.fine('processing message received in foreground: $message');
      _processDataMessage(message, fromBackground: false);
    });

    // Listen for incoming messages while the app is in the background.
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permission to receive notifications. Pop-up will appear only
    // once.
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    // Listen for token refresh and update the token on the server accordingly.
    _fcmTokenRefreshSubscription =
        FirebaseMessaging.instance.onTokenRefresh.listen((String token) {
      _registerToken(token);
    });

    // Get any messages which caused the application to open from
    // a terminated state.
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _dispose() {
    _fcmTokenRefreshSubscription?.cancel();
    _connectivitySubscription?.close();
  }

  /// Handle a message that caused the application to open
  ///
  /// This method must be part of a State object which is a child of [MaterialApp]
  /// otherwise the [Navigator] will not be accessible.
  void _handleMessage(RemoteMessage message) {
    switch (message.data['lichess.type']) {
      // correspondence game message types
      case 'corresAlarm':
      case 'gameTakebackOffer':
      case 'gameDrawOffer':
      case 'gameMove':
      case 'gameFinish':
        final gameFullId = message.data['lichess.fullId'] as String?;
        if (gameFullId != null) {
          ref.read(correspondenceServiceProvider).onNotificationResponse(
                GameFullId(gameFullId),
              );
        }
    }
  }

  /// Register the device for push notifications.
  Future<void> registerDevice() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await _registerToken(token);
    }
  }

  Future<void> _registerToken(String token) async {
    final settings = await FirebaseMessaging.instance.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }
    _log.info('will register fcmToken: $token');
    final session = ref.read(authSessionProvider);
    if (session == null) {
      return;
    }
    try {
      await ref.withClient(
        (client) => client.post(Uri(path: '/mobile/register/firebase/$token')),
      );
    } catch (e, st) {
      _log.severe('could not register device; $e', e, st);
    }
  }

  /// Unregister the device from push notifications.
  Future<void> unregister() async {
    _log.info('will unregister');
    final session = ref.read(authSessionProvider);
    if (session == null) {
      return;
    }
    try {
      await ref.withClient(
        (client) => client.post(Uri(path: '/mobile/unregister')),
      );
    } catch (e, st) {
      _log.severe('could not unregister device; $e', e, st);
    }
  }

  /// Process a message received
  Future<void> _processDataMessage(
    RemoteMessage message, {
    required bool fromBackground,
  }) async {
    final gameFullId = message.data['lichess.fullId'] as String?;
    final round = message.data['lichess.round'] as String?;

    // update correspondence game
    if (gameFullId != null && round != null) {
      final fullId = GameFullId(gameFullId);
      final game = PlayableGame.fromServerJson(
        jsonDecode(round) as Map<String, dynamic>,
      );
      ref.read(correspondenceServiceProvider).updateGame(fullId, game);

      if (!fromBackground) {
        // opponent just played, invalidate ongoing games
        if (game.sideToMove == game.youAre) {
          ref.invalidate(ongoingGamesProvider);
        }
      }
    }

    // update badge
    final badge = message.data['lichess.iosBadge'] as String?;
    if (badge != null) {
      try {
        BadgeService.instance.setBadge(int.parse(badge));
      } catch (e) {
        _log.severe('Could not parse badge: $badge');
      }
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    debugPrint('Handling a fcm background message: ${message.data}');

    // create a new provider scope for the background isolate
    final ref = ProviderContainer();

    ref.listen(
      appInitializationProvider,
      (prev, now) {
        if (!now.hasValue) return;
        try {
          ref.read(pushNotificationServiceProvider)._processDataMessage(
                message,
                fromBackground: true,
              );

          ref.dispose();
        } catch (e) {
          debugPrint('Error processing background message: $e');
          ref.dispose();
        }
      },
    );

    ref.read(appInitializationProvider);
  }
}
