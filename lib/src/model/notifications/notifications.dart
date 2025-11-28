import 'dart:convert';

import 'package:deep_pick/deep_pick.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lichess_mobile/firebase_stubs.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/model/user/user.dart' show TemporaryBan;
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:meta/meta.dart';

/// FCM Messages
///////////////

/// Parsed data from an FCM message.
///
/// Messages received from Firebase Cloud Messaging (FCM) service support different
/// kind of use cases, depending on the message content:
///
/// * when no [RemoteMessage.notification] is present, the message is a data message,
///   and the application can handle it in the foreground or background; It typically
///   serves to update the application state silently.
///
/// * when a [RemoteMessage.notification] is present, the message is a notification message.
///   If the application is in the background, the system displays the notification to the user.
///   If the application is in the foreground, the system does not display the notification
///   automatically, but we might want to display it ourselves.
///   A notification message can contain additional data in the [RemoteMessage.data] field,
///   which can also be used to update the application state.
@immutable
sealed class FcmMessage {
  const FcmMessage();

  RemoteNotification? get notification;

  factory FcmMessage.fromRemoteMessage(RemoteMessage message) {
    final messageType = message.data['lichess.type'] as String?;

    if (messageType == null) {
      return UnhandledFcmMessage(message.data);
    } else {
      switch (messageType) {
        case 'corresAlarm':
        case 'gameTakebackOffer':
        case 'gameDrawOffer':
        case 'gameMove':
        case 'gameFinish':
          final gameFullId = message.data['lichess.fullId'] as String?;
          final round = message.data['lichess.round'] as String?;
          if (gameFullId != null) {
            final fullId = GameFullId(gameFullId);
            final game = round != null
                ? PlayableGame.fromServerJson(jsonDecode(round) as Map<String, dynamic>)
                : null;
            return CorresGameUpdateFcmMessage(
              fullId,
              game: game,
              notification: message.notification,
            );
          } else {
            return MalformedFcmMessage(message.data);
          }
        case 'newMessage':
          final conversationId = message.data['lichess.threadId'] as String?;
          if (conversationId != null) {
            return NewMessageFcmMessage(UserId(conversationId), notification: message.notification);
          } else {
            return MalformedFcmMessage(message.data);
          }
        case 'challengeCreate':
          final challengeId = message.data['lichess.challengeId'] as String?;
          if (challengeId != null) {
            return ChallengeCreateFcmMessage(
              ChallengeId(challengeId),
              notification: message.notification,
            );
          } else {
            return MalformedFcmMessage(message.data);
          }
        case 'challengeAccept':
          final challengeId = message.data['lichess.challengeId'] as String?;
          final fullId = message.data['lichess.fullId'] as String?;
          if (challengeId != null && fullId != null) {
            return ChallengeAcceptFcmMessage(
              ChallengeId(challengeId),
              GameFullId(fullId),
              notification: message.notification,
            );
          } else {
            return MalformedFcmMessage(message.data);
          }
        default:
          return UnhandledFcmMessage(message.data);
      }
    }
  }
}

/// An [FcmMessage] that represents a new message in a private conversation.
@immutable
class NewMessageFcmMessage extends FcmMessage {
  const NewMessageFcmMessage(this.conversationId, {required this.notification});

  final UserId conversationId;

  @override
  final RemoteNotification? notification;

  @override
  String toString() => 'NewMessageFcmMessage(conversationId: $conversationId)';
}

/// An [FcmMessage] that represents a correspondence game update.
@immutable
class CorresGameUpdateFcmMessage extends FcmMessage {
  const CorresGameUpdateFcmMessage(this.fullId, {required this.game, required this.notification});

  final GameFullId fullId;
  final PlayableGame? game;

  @override
  final RemoteNotification? notification;
}

/// An [FcmMessage] sent when a challenge is created.
@immutable
class ChallengeCreateFcmMessage extends FcmMessage {
  const ChallengeCreateFcmMessage(this.id, {required this.notification});

  final ChallengeId id;

  @override
  final RemoteNotification? notification;
}

/// An [FcmMessage] sent when a challenge is accepted.
@immutable
class ChallengeAcceptFcmMessage extends FcmMessage {
  const ChallengeAcceptFcmMessage(this.id, this.fullId, {required this.notification});

  final ChallengeId id;
  final GameFullId fullId;

  @override
  final RemoteNotification? notification;
}

/// An [FcmMessage] that could not be parsed.
@immutable
class MalformedFcmMessage extends FcmMessage {
  const MalformedFcmMessage(this.data);

  final Map<String, dynamic> data;

  @override
  RemoteNotification? get notification => null;
}

/// An [FcmMessage] that is not handled by the application.
@immutable
class UnhandledFcmMessage extends FcmMessage {
  const UnhandledFcmMessage(this.data);

  final Map<String, dynamic> data;

  @override
  RemoteNotification? get notification => null;
}

/// Local Notifications
///////////////////////

/// A notification shown to the user from the platform's notification system.
@immutable
sealed class LocalNotification {
  const LocalNotification();

  /// The unique identifier of the notification.
  int get id;

  /// The channel identifier of the notification.
  ///
  /// Corresponds to [AndroidNotificationDetails.channelId] for android and
  /// [DarwinNotificationDetails.threadIdentifier] for iOS.
  ///
  /// It must match the channel identifier of the notification details.
  String get channelId;

  /// The localized title of the notification.
  String title(AppLocalizations l10n);

  /// The localized body of the notification.
  String? body(AppLocalizations l10n);

  /// The payload of the notification.
  ///
  /// Implementations must not override this getter, but [_concretePayload] instead.
  ///
  /// See [LocalNotification.fromJson] where the [channelId] is used to determine the
  /// concrete type of the notification, to be able to deserialize it.
  Map<String, dynamic> get payload => {'channel': channelId, ..._concretePayload};

  /// The actual payload of the notification.
  ///
  /// Will be merged with the channel:[channelId] entry to form the final payload.
  Map<String, dynamic> get _concretePayload;

  /// The localized details of the notification for each platform.
  NotificationDetails details(AppLocalizations l10n);

  /// Retrives a local notification from a JSON payload.
  factory LocalNotification.fromJson(Map<String, dynamic> json) {
    final channel = json['channel'] as String;
    switch (channel) {
      case 'corresGameUpdate':
        return CorresGameUpdateNotification.fromJson(json);
      case 'challenge':
        return ChallengeNotification.fromJson(json);
      case 'playban':
        return PlaybanNotification.fromJson(json);
      case 'newMessage':
        return NewMessageNotification.fromJson(json);
      case 'challengeAccept':
        return ChallengeAcceptedNotification.fromJson(json);
      case 'challengeCreate':
        return ChallengeCreatedNotification.fromJson(json);
      default:
        throw ArgumentError('Unknown notification channel: $channel');
    }
  }
}

/// A notification show to the user when they are banned temporarily from playing.
class PlaybanNotification extends LocalNotification {
  const PlaybanNotification(this.playban);

  final TemporaryBan playban;

  factory PlaybanNotification.fromJson(Map<String, dynamic> json) {
    final p = pick(json).required();
    final playban = TemporaryBan(
      date: p('date').asDateTimeFromMillisecondsOrThrow(),
      duration: p('minutes').asDurationFromMinutesOrThrow(),
    );
    return PlaybanNotification(playban);
  }

  @override
  String get channelId => 'playban';

  @override
  int get id => playban.date.toIso8601String().hashCode;

  @override
  Map<String, dynamic> get _concretePayload => {
    'minutes': playban.duration.inMinutes,
    'date': playban.date.millisecondsSinceEpoch,
  };

  @override
  String title(AppLocalizations l10n) => l10n.sorry;

  @override
  String body(AppLocalizations l10n) => l10n.weHadToTimeYouOutForAWhile;

  @override
  NotificationDetails details(AppLocalizations l10n) => NotificationDetails(
    android: AndroidNotificationDetails(
      channelId,
      'playban',
      importance: Importance.max,
      priority: Priority.max,
      autoCancel: false,
    ),
    iOS: DarwinNotificationDetails(threadIdentifier: channelId),
  );
}

/// A notification for a new message in a private conversation.
///
/// This notification is shown when a new message is received in a private conversation.
/// It is created from a [NewMessageFcmMessage] and contains the conversation ID. The title and
/// message are the same as the title and body of the FCM message's [RemoteNotification].
class NewMessageNotification extends LocalNotification {
  const NewMessageNotification(this.conversationId, String title, String message)
    : _title = title,
      _message = message;

  final UserId conversationId;
  final String _title;
  final String _message;

  factory NewMessageNotification.fromJson(Map<String, dynamic> json) {
    final conversationId = UserId.fromJson(json['conversationId'] as String);
    final title = json['title'] as String;
    final message = json['message'] as String;
    return NewMessageNotification(conversationId, title, message);
  }

  factory NewMessageNotification.fromFcmMessage(NewMessageFcmMessage message) {
    return NewMessageNotification(
      message.conversationId,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
    );
  }

  @override
  String get channelId => 'newMessage';

  @override
  int get id => conversationId.hashCode;

  @override
  Map<String, dynamic> get _concretePayload => {
    'conversationId': conversationId.toJson(),
    'title': _title,
    'message': _message,
  };

  @override
  String title(AppLocalizations l10n) => _title;

  @override
  String body(AppLocalizations _) => _message;

  @override
  NotificationDetails details(AppLocalizations l10n) => NotificationDetails(
    android: AndroidNotificationDetails(
      channelId,
      l10n.preferencesNotifyInboxMsg,
      importance: Importance.max,
      priority: Priority.high,
      autoCancel: true,
    ),
    iOS: DarwinNotificationDetails(threadIdentifier: channelId),
  );
}

/// A notification for a correspondence game update.
///
/// This notification is shown when a correspondence game is updated on the server
/// and a FCM message is received and contains itself a notification.
///
/// Fields [title] and [body] are dynamic and part of the payload because they
/// are generated server side and are included in the FCM message's [RemoteMessage.notification] field.
class CorresGameUpdateNotification extends LocalNotification {
  const CorresGameUpdateNotification(this.fullId, String title, String body)
    : _title = title,
      _body = body;

  final GameFullId fullId;

  final String _title;
  final String _body;

  factory CorresGameUpdateNotification.fromJson(Map<String, dynamic> json) {
    final gameId = GameFullId.fromJson(json['fullId'] as String);
    final title = json['title'] as String;
    final body = json['body'] as String;
    return CorresGameUpdateNotification(gameId, title, body);
  }

  factory CorresGameUpdateNotification.fromFcmMessage(CorresGameUpdateFcmMessage message) {
    final title = message.notification?.title ?? '';
    final body = message.notification?.body ?? '';
    return CorresGameUpdateNotification(message.fullId, title, body);
  }

  @override
  String get channelId => 'corresGameUpdate';

  @override
  int get id => fullId.hashCode;

  @override
  Map<String, dynamic> get _concretePayload => {
    'fullId': fullId.toJson(),
    'title': _title,
    'body': _body,
  };

  @override
  String title(_) => _title;

  @override
  String? body(_) => _body;

  @override
  NotificationDetails details(AppLocalizations l10n) => NotificationDetails(
    android: AndroidNotificationDetails(
      channelId,
      l10n.preferencesNotifyGameEvent,
      importance: Importance.high,
      priority: Priority.defaultPriority,
      autoCancel: true,
    ),
    iOS: DarwinNotificationDetails(threadIdentifier: channelId),
  );
}

/// A notification for a challenge acceptance.
///
/// This notification is shown when a challenge is accepted on the server.
class ChallengeAcceptedNotification extends LocalNotification {
  const ChallengeAcceptedNotification(this.fullId, String title, String body)
    : _title = title,
      _body = body;

  final GameFullId fullId;

  final String _title;
  final String _body;

  factory ChallengeAcceptedNotification.fromJson(Map<String, dynamic> json) {
    final gameId = GameFullId.fromJson(json['fullId'] as String);
    final title = json['title'] as String;
    final body = json['body'] as String;
    return ChallengeAcceptedNotification(gameId, title, body);
  }

  factory ChallengeAcceptedNotification.fromFcmMessage(ChallengeAcceptFcmMessage message) {
    final title = message.notification?.title ?? '';
    final body = message.notification?.body ?? '';
    return ChallengeAcceptedNotification(message.fullId, title, body);
  }

  @override
  String get channelId => 'challengeAccept';

  @override
  int get id => fullId.hashCode;

  @override
  Map<String, dynamic> get _concretePayload => {
    'fullId': fullId.toJson(),
    'title': _title,
    'body': _body,
  };

  @override
  String title(_) => _title;

  @override
  String? body(_) => _body;

  @override
  NotificationDetails details(AppLocalizations l10n) => NotificationDetails(
    android: AndroidNotificationDetails(
      channelId,
      l10n.preferencesNotifyGameEvent,
      importance: Importance.high,
      priority: Priority.defaultPriority,
      autoCancel: true,
    ),
    iOS: DarwinNotificationDetails(threadIdentifier: channelId),
  );
}

/// A notification for a challenge creation.
///
/// This notification is shown when a challenge is created on the server while the user is not connected to lichess (e.g., app is in background).
/// If the user is connected, challenges are handled by Websocket and a [ChallengeNotification] is shown instead.
class ChallengeCreatedNotification extends LocalNotification {
  const ChallengeCreatedNotification(this.challengeId, String title, String body)
    : _title = title,
      _body = body;

  final ChallengeId challengeId;

  final String _title;
  final String _body;

  factory ChallengeCreatedNotification.fromJson(Map<String, dynamic> json) {
    final challengeId = ChallengeId.fromJson(json['challengeId'] as String);
    final title = json['title'] as String;
    final body = json['body'] as String;
    return ChallengeCreatedNotification(challengeId, title, body);
  }

  factory ChallengeCreatedNotification.fromFcmMessage(ChallengeCreateFcmMessage message) {
    final title = message.notification?.title ?? '';
    final body = message.notification?.body ?? '';
    return ChallengeCreatedNotification(message.id, title, body);
  }

  @override
  String get channelId => 'challengeAccept';

  @override
  int get id => challengeId.hashCode;

  @override
  Map<String, dynamic> get _concretePayload => {
    'challengeId': challengeId.toJson(),
    'title': _title,
    'body': _body,
  };

  @override
  String title(_) => _title;

  @override
  String? body(_) => _body;

  @override
  NotificationDetails details(AppLocalizations l10n) => NotificationDetails(
    android: AndroidNotificationDetails(
      channelId,
      l10n.preferencesNotifyGameEvent,
      importance: Importance.high,
      priority: Priority.defaultPriority,
      autoCancel: true,
    ),
    iOS: DarwinNotificationDetails(threadIdentifier: channelId),
  );
}

/// A notification for a received challenge.
///
/// This notification is shown when a challenge is received from the server through
/// the web socket.
class ChallengeNotification extends LocalNotification {
  const ChallengeNotification(this.challenge);

  final Challenge challenge;

  factory ChallengeNotification.fromJson(Map<String, dynamic> json) {
    final challenge = Challenge.fromJson(json['challenge'] as Map<String, dynamic>);
    return ChallengeNotification(challenge);
  }

  @override
  String get channelId => 'challenge';

  @override
  int get id => challenge.id.value.hashCode;

  @override
  Map<String, dynamic> get _concretePayload => {'challenge': challenge.toJson()};

  @override
  String title(AppLocalizations _) => '${challenge.challenger!.user.name} challenges you!';

  @override
  String body(AppLocalizations l10n) => challenge.description(l10n);

  @override
  NotificationDetails details(AppLocalizations l10n) => NotificationDetails(
    android: AndroidNotificationDetails(
      channelId,
      l10n.preferencesNotifyChallenge,
      importance: Importance.max,
      priority: Priority.high,
      autoCancel: false,
      actions: <AndroidNotificationAction>[
        if (challenge.variant.isPlaySupported)
          AndroidNotificationAction(
            'accept',
            l10n.accept,
            icon: const DrawableResourceAndroidBitmap('tick'),
            showsUserInterface: true,
            contextual: true,
          ),
        AndroidNotificationAction(
          'decline',
          l10n.decline,
          icon: const DrawableResourceAndroidBitmap('cross'),
          showsUserInterface: true,
          contextual: true,
        ),
      ],
    ),
    iOS: DarwinNotificationDetails(
      threadIdentifier: channelId,
      categoryIdentifier: challenge.variant.isPlaySupported
          ? darwinPlayableVariantCategoryId
          : darwinUnplayableVariantCategoryId,
    ),
  );

  static const darwinPlayableVariantCategoryId = 'challenge-notification-playable-variant';

  static const darwinUnplayableVariantCategoryId = 'challenge-notification-unplayable-variant';

  static DarwinNotificationCategory darwinPlayableVariantCategory(AppLocalizations l10n) =>
      DarwinNotificationCategory(
        darwinPlayableVariantCategoryId,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain(
            'accept',
            l10n.accept,
            options: <DarwinNotificationActionOption>{DarwinNotificationActionOption.foreground},
          ),
          DarwinNotificationAction.plain(
            'decline',
            l10n.decline,
            options: <DarwinNotificationActionOption>{DarwinNotificationActionOption.foreground},
          ),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      );

  static DarwinNotificationCategory darwinUnplayableVariantCategory(AppLocalizations l10n) =>
      DarwinNotificationCategory(
        darwinUnplayableVariantCategoryId,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain(
            'decline',
            l10n.decline,
            options: <DarwinNotificationActionOption>{DarwinNotificationActionOption.foreground},
          ),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      );
}
