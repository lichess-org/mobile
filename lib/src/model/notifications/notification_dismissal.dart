import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/notifications/notification_key.dart';

/// A domain fact meaning the notification for this subject is no longer relevant.
///
/// Facts carry domain ids only. They never carry a platform id or a plugin object.
sealed class const NotificationDismissal() {
  NotificationKey get key;
}

class const ConversationRead(final UserId conversationId) extends NotificationDismissal {
  @override
  NotificationKey get key => ConversationKey(conversationId);
}

class const GameNoLongerRelevant(final GameFullId fullId) extends NotificationDismissal {
  @override
  NotificationKey get key => GameKey(fullId);
}

class const ChallengeSettled(final ChallengeId challengeId) extends NotificationDismissal {
  @override
  NotificationKey get key => ChallengeKey(challengeId);
}

/// One-way channel from domain transitions to the notification owner.
final notificationDismissalBusProvider = Provider<NotificationDismissalBus>((Ref ref) {
  final bus = NotificationDismissalBus();
  ref.onDispose(bus.dispose);
  return bus;
});

class NotificationDismissalBus() {
  final StreamController<NotificationDismissal> _controller =
      StreamController<NotificationDismissal>.broadcast();

  Stream<NotificationDismissal> get stream => _controller.stream;

  void emit(NotificationDismissal fact) {
    if (!_controller.isClosed) _controller.add(fact);
  }

  void dispose() {
    _controller.close();
  }
}
