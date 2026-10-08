import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/notifications/notifications.dart';
import 'package:lichess_mobile/src/service/notification_service.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_round_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';

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
          _onBroadcastRoundNotification(roundId);
        case BroadcastPlayerFollowNotification(:final roundId, :final gameId, :final pov):
          _onBroadcastPlayerFollowNotification(roundId, gameId, pov);
        case _:
          break;
      }
    });
  }

  /// Returns the root navigator, popped back to its first route so that broadcast screens are
  /// pushed on a clean stack, or null if the user chose to stay on the real time game they are
  /// playing.
  Future<NavigatorState?> _resetToRootNavigator() async {
    final context = ref.read(currentNavigatorKeyProvider).currentContext;
    if (context == null || !context.mounted) return null;
    if (!await confirmLeavingRealTimeGame(context, ref) || !context.mounted) return null;

    final navigator = Navigator.of(context, rootNavigator: true);

    if (navigator.canPop()) {
      navigator.popUntil((route) => route.isFirst);
    }

    return navigator;
  }

  Future<void> _onBroadcastRoundNotification(BroadcastRoundId roundId) async {
    final navigator = await _resetToRootNavigator();
    if (navigator == null) return;
    navigator.push(
      BroadcastRoundScreenLoading.buildRoute(roundId, initialTab: BroadcastRoundTab.boards),
    );
  }

  Future<void> _onBroadcastPlayerFollowNotification(
    BroadcastRoundId roundId,
    BroadcastGameId gameId,
    Side pov,
  ) async {
    final navigator = await _resetToRootNavigator();
    if (navigator == null) return;
    navigator.push(
      BroadcastRoundScreenLoading.buildRoute(roundId, initialTab: BroadcastRoundTab.boards),
    );
    navigator.push(
      BroadcastGameScreen.buildRoute(roundId: roundId, gameId: gameId, initialPov: pov),
    );
  }

  void dispose() {
    _notificationResponseSubscription?.cancel();
  }
}
