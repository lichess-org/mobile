import 'package:lichess_mobile/src/model/common/id.dart';

/// The identity of a platform notification, derived from a domain id in one place.
///
/// The [id] is the value passed to the platform plugin. It must stay equal to the
/// historical hash-based id so notifications posted by the OS remain clearable.
sealed class const NotificationKey() {
  int get id;
}

class const ConversationKey(final UserId conversationId) extends NotificationKey {
  @override
  int get id => conversationId.hashCode;
}

class const GameKey(final GameFullId fullId) extends NotificationKey {
  @override
  int get id => fullId.hashCode;
}

class const ChallengeKey(final ChallengeId challengeId) extends NotificationKey {
  @override
  int get id => challengeId.value.hashCode;
}

class const AnnounceKey() extends NotificationKey {
  @override
  int get id => 'announce'.hashCode;
}

class const PlaybanKey(final DateTime date) extends NotificationKey {
  @override
  int get id => date.toIso8601String().hashCode;
}
