import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/ui_events.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_round_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen_providers.dart';
import 'package:lichess_mobile/src/view/message/conversation_screen.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';

final uiEventCoordinatorProvider = Provider<UiEventCoordinator>((Ref ref) {
  final coordinator = UiEventCoordinator(ref);
  ref.onDispose(coordinator.dispose);
  return coordinator;
}, name: 'UiEventCoordinatorProvider');

/// The view layer's half of the model/view split: listens to the [uiEventBusProvider] and performs
/// the navigation, dialogs and snackbars that the model layer asks for.
///
/// Started from `_AppState.initState` before any service, so that no event is emitted before
/// someone is listening.
class UiEventCoordinator(final Ref ref) {
  StreamSubscription<UiEvent>? _subscription;

  void start() {
    _subscription = ref.read(uiEventBusProvider).stream.listen(_handle);
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }

  void _handle(UiEvent event) {
    switch (event) {
      case ShowErrorEvent(:final message):
        final context = _currentContext;
        if (context != null) {
          showSnackBar(context, message, type: SnackBarType.error);
        }
      case OpenGameEvent(:final fullId):
        _resetToRootNavigator()?.push(GameScreen.buildRoute(source: ExistingGameSource(fullId)));
      case OpenConversationEvent(:final user):
        _resetToRootNavigator()?.push(ConversationScreen.buildRoute(user: user));
      case OpenBroadcastRoundEvent(:final roundId):
        _resetToRootNavigator()?.push(
          BroadcastRoundScreenLoading.buildRoute(roundId, initialTab: BroadcastRoundTab.boards),
        );
      case OpenBroadcastFollowEvent(:final roundId, :final gameId, :final pov):
        final navigator = _resetToRootNavigator();
        if (navigator != null) {
          navigator.push(
            BroadcastRoundScreenLoading.buildRoute(roundId, initialTab: BroadcastRoundTab.boards),
          );
          navigator.push(
            BroadcastGameScreen.buildRoute(roundId: roundId, gameId: gameId, initialPov: pov),
          );
        }
    }
  }

  /// The root navigator, popped back to its first route so that new screens are pushed on a clean
  /// stack. `null` when there is no widget tree to navigate in.
  NavigatorState? _resetToRootNavigator() {
    final context = _currentContext;
    if (context == null) return null;

    final rootNavigator = Navigator.of(context, rootNavigator: true);
    if (rootNavigator.canPop()) {
      rootNavigator.popUntil((route) => route.isFirst);
    }
    return rootNavigator;
  }

  /// The context of the navigator for the tab the user is currently on, or `null` when there is no
  /// widget tree to show anything in.
  BuildContext? get _currentContext {
    final context = ref.read(currentNavigatorKeyProvider).currentContext;
    return context != null && context.mounted ? context : null;
  }
}
