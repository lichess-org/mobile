import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/notifications/notifications.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_round_screen.dart';

/// A provider for [BroadcastService].
final broadcastServiceProvider = Provider<BroadcastService>((Ref ref) {
  final service = BroadcastService(ref);
  ref.onDispose(service.dispose);
  return service;
}, name: 'BroadcastServiceProvider');

class BroadcastService {
  BroadcastService(this.ref);

  final Ref ref;

  StreamSubscription<ParsedLocalNotification>? _notificationResponseSubscription;

  void start() {
    _notificationResponseSubscription = NotificationService.responseStream.listen((data) {
      final (_, notification) = data;
      switch (notification) {
        case BroadcastPlayerFollowNotification(:final roundId, :final gameId, :final color):
          _onNotificationResponse(roundId, gameId, color);
        case _:
          break;
      }
    });
  }

  /// Handles a notification response that caused the app to open.
  Future<void> _onNotificationResponse(
    BroadcastRoundId roundId,
    BroadcastGameId gameId,
    Side color,
  ) async {
    final context = ref.read(currentNavigatorKeyProvider).currentContext;
    if (context == null || !context.mounted) return;

    final rootNavState = Navigator.of(context, rootNavigator: true);
    if (rootNavState.canPop()) {
      rootNavState.popUntil((route) => route.isFirst);
    }

    final navigator = Navigator.of(context, rootNavigator: true);
    navigator.push(BroadcastRoundScreenLoading.buildRoute(roundId));
    navigator.push(
      BroadcastGameScreen.buildRoute(roundId: roundId, gameId: gameId, initialPov: color),
    );
  }

  void dispose() {
    _notificationResponseSubscription?.cancel();
  }
}
