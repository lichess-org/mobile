import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

/// A request from the model layer for something only the view can do.
///
/// Services in `model/` cannot navigate, show dialogs or display snackbars without reaching into
/// the widget tree, which would make the model layer depend on the view layer. They emit these
/// events on the [UiEventBus] instead. [UiEventCoordinator] is their only consumer.
sealed class const UiEvent();

/// Shows [message] in a snackbar.
class const ShowErrorEvent(final String message) extends UiEvent;

/// Pops the root navigator back to its first route, then opens the game with [fullId].
class const OpenGameEvent(final GameFullId fullId) extends UiEvent;

/// Pops the root navigator back to its first route, then opens the conversation with [user].
class const OpenConversationEvent(final LightUser user) extends UiEvent;

/// Pops the root navigator back to its first route, then opens the broadcast [roundId].
class const OpenBroadcastRoundEvent(final BroadcastRoundId roundId) extends UiEvent;

/// Pops the root navigator back to its first route, then opens the broadcast [roundId] and follows
/// [gameId] from [pov]'s point of view.
class const OpenBroadcastFollowEvent(
  final BroadcastRoundId roundId,
  final BroadcastGameId gameId,
  final Side pov,
) extends UiEvent;

/// The channel on which [UiEvent]s travel from the model layer to the view layer.
final uiEventBusProvider = Provider<UiEventBus>((Ref ref) {
  final bus = UiEventBus();
  ref.onDispose(bus.close);
  return bus;
}, name: 'UiEventBusProvider');

class UiEventBus() {
  final StreamController<UiEvent> _controller = StreamController.broadcast();

  Stream<UiEvent> get stream => _controller.stream;

  void emit(UiEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  void close() {
    _controller.close();
  }
}
