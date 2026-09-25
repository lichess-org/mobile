import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

/// A request from the model layer for something only the view can do.
///
/// Services in `model/` cannot navigate, show dialogs or display snackbars without reaching into
/// the widget tree, which would make the model layer depend on the view layer. They emit these
/// events on the [UiEventBus] instead. The view layer coordinator is their only consumer.
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

/// Shows the action sheet confirming the incoming [challenge].
class const ShowChallengeConfirmEvent(
  final Challenge challenge, {
  final String? title,
  final bool fromLink = false,
}) extends UiEvent;

/// Shows the action sheet for picking a decline reason for [challengeId].
class const ShowChallengeDeclineEvent(final ChallengeId challengeId) extends UiEvent;

/// Opens the incoming and outgoing challenge requests screen, without clearing the stack.
class const OpenChallengeRequestsEvent() extends UiEvent;

/// Shows the dialog explaining why [playban] was applied.
class const ShowPlaybanEvent(final TemporaryBan playban) extends UiEvent;

/// Asks the user whether to carry out the action described by [message].
///
/// The answer is written to [completer]: `true` when the user agrees, `false` when they decline or
/// when there is no widget tree to ask.
class ConfirmActionEvent(final String message) extends UiEvent {
  final Completer<bool> completer = Completer<bool>();
}

/// The channel on which [UiEvent]s travel from the model layer to the view layer.
final uiEventBusProvider = Provider<UiEventBus>((Ref ref) {
  final bus = UiEventBus();
  ref.onDispose(bus.close);
  return bus;
}, name: 'UiEventBusProvider');

class UiEventBus() {
  final StreamController<UiEvent> _controller = StreamController.broadcast();

  Stream<UiEvent> get stream => _controller.stream;

  /// Whether the view layer coordinator is listening.
  bool get hasListeners => _controller.hasListener;

  /// Adds [event] to the bus.
  ///
  /// Returns whether anyone was listening. A broadcast stream silently drops events with no
  /// listener, so callers that wait on a reply must check the return value instead of hanging.
  bool emit(UiEvent event) {
    if (_controller.isClosed) return false;
    final delivered = _controller.hasListener;
    if (delivered) {
      _controller.add(event);
    }
    return delivered;
  }

  void close() {
    _controller.close();
  }
}
