import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/notifications/notifications.dart';
import 'package:lichess_mobile/src/model/ui_events.dart';

/// A provider for [BroadcastService].
final broadcastServiceProvider = Provider<BroadcastService>((Ref ref) {
  final service = BroadcastService(ref);
  ref.onDispose(service.dispose);
  return service;
}, name: 'BroadcastServiceProvider');

class BroadcastService(final Ref ref) {
  StreamSubscription<ParsedLocalNotification>? _notificationResponseSubscription;

  void start() {
    _notificationResponseSubscription = NotificationService.responseStream.listen((data) {
      final (_, notification) = data;
      switch (notification) {
        case BroadcastRoundNotification(:final roundId):
          ref.read(uiEventBusProvider).emit(OpenBroadcastRoundEvent(roundId));
        case BroadcastPlayerFollowNotification(:final roundId, :final gameId, :final pov):
          ref.read(uiEventBusProvider).emit(OpenBroadcastFollowEvent(roundId, gameId, pov));
        case _:
          break;
      }
    });
  }

  void dispose() {
    _notificationResponseSubscription?.cancel();
  }
}
