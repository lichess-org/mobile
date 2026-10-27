import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/model/user/user.dart' show TemporaryBan;
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:lichess_mobile/src/utils/l10n.dart' show relativeDate;
import 'package:meta/meta.dart';

/// A notification channel, shared by one or more [LocalNotification] types and FCM messages.
///
/// On Android, all channels are created when the app starts, so that the FCM notifications
/// displayed by the system don't fall back to the "Miscellaneous" channel.
///
/// The channel id is the enum value [name]. It is shared with the server, which sets it in the FCM
/// messages, so the enum values must never be renamed.
enum NotificationChannel(final Importance importance) {
  playban(.defaultImportance),
  newMessage(.defaultImportance),
  corresGameUpdate(.defaultImportance),
  challenge(.high), // only real time challenges get high importance
  corresChallengeAccept(.defaultImportance),
  corresChallengeCreate(.defaultImportance),
  announce(.defaultImportance),
  broadcast(.defaultImportance),
  recap(.defaultImportance);

  /// The localized name of the channel, shown in the system notification settings.
  String label(AppLocalizations l10n) => switch (this) {
    playban => 'Playban',
    newMessage => l10n.preferencesNotifyDirectMessage,
    corresGameUpdate ||
    corresChallengeAccept ||
    corresChallengeCreate => l10n.preferencesNotifyGameEvent,
    announce => 'Lichess Announcements',
    challenge => l10n.preferencesNotifyChallenge,
    broadcast => l10n.broadcastBroadcasts,
    recap => 'Annual recap',
  };

  /// The notification priority matching the channel [importance].
  ///
  /// Android 8+ only uses the channel importance, the priority is set for consistency.
  Priority get priority => switch (importance) {
    .unspecified || .defaultImportance => .defaultPriority,
    .none || .min => .min,
    .low => .low,
    .high => .high,
    .max => .max,
  };

  /// The Android channel to create on the device.
  AndroidNotificationChannel androidChannel(AppLocalizations l10n) =>
      AndroidNotificationChannel(name, label(l10n), importance: importance);
}

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
sealed class const FcmMessage() {
  RemoteNotification? get notification;

  factory fromRemoteMessage(RemoteMessage message) {
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
            return CorresChallengeCreateFcmMessage(
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
            return CorresChallengeAcceptFcmMessage(
              ChallengeId(challengeId),
              GameFullId(fullId),
              notification: message.notification,
            );
          } else {
            return MalformedFcmMessage(message.data);
          }
        case 'broadcast':
          final rawUrl = message.data['lichess.url'] as String?;
          if (rawUrl == null) return MalformedFcmMessage(message.data);
          final url = Uri.tryParse(rawUrl);
          switch (url) {
            case Uri(pathSegments: ['broadcast', _, _, final roundId]):
              return BroadcastRoundFcmMessage(
                BroadcastRoundId(roundId),
                notification: message.notification,
              );
            case Uri(
              pathSegments: ['broadcast', _, _, final roundId, final gameId],
              queryParameters: {'pov': final pov},
            ):
              final side = Side.values.firstWhereOrNull((s) => s.name == pov);
              if (side == null) {
                return MalformedFcmMessage(message.data);
              }

              return BroadcastPlayerFollowFcmMessage(
                BroadcastRoundId(roundId),
                BroadcastGameId(gameId),
                side,
                notification: message.notification,
              );
            case _:
              return MalformedFcmMessage(message.data);
          }
        case 'recap':
          final rawYear = message.data['lichess.year'] as String?;
          final year = rawYear == null ? null : int.tryParse(rawYear);
          if (year != null) {
            return RecapFcmMessage(year, notification: message.notification);
          } else {
            return MalformedFcmMessage(message.data);
          }
        default:
          return UnhandledFcmMessage(message.data);
      }
    }
  }

  /// The local notification corresponding to this message, if it has one.
  ///
  /// Returns `null` for [UnhandledFcmMessage] and [MalformedFcmMessage], the only types
  /// without a local notification representation.
  ///
  /// Types that display a server-provided title and body fall back to empty strings when
  /// the message carries no platform notification, instead of failing.
  LocalNotification? toLocalNotification() => switch (this) {
    final NewMessageFcmMessage m => NewMessageNotification.fromFcmMessage(m),
    final CorresGameUpdateFcmMessage m => CorresGameUpdateNotification.fromFcmMessage(m),
    final CorresChallengeCreateFcmMessage m => CorresChallengeCreatedNotification.fromFcmMessage(m),
    final CorresChallengeAcceptFcmMessage m => CorresChallengeAcceptedNotification.fromFcmMessage(
      m,
    ),
    final BroadcastRoundFcmMessage m => BroadcastRoundNotification.fromFcmMessage(m),
    final BroadcastPlayerFollowFcmMessage m => BroadcastPlayerFollowNotification.fromFcmMessage(m),
    final RecapFcmMessage m => RecapNotification.fromFcmMessage(m),
    UnhandledFcmMessage() || MalformedFcmMessage() => null,
  };
}

/// An [FcmMessage] that represents a new message in a private conversation.
@immutable
class const NewMessageFcmMessage(
  final UserId conversationId, {
  @override required final RemoteNotification? notification,
}) extends FcmMessage {
  @override
  String toString() => 'NewMessageFcmMessage(conversationId: $conversationId)';
}

/// An [FcmMessage] that represents a correspondence game update.
@immutable
class const CorresGameUpdateFcmMessage(
  final GameFullId fullId, {
  required final PlayableGame? game,
  @override required final RemoteNotification? notification,
}) extends FcmMessage;

/// An [FcmMessage] sent when a correspondence challenge is created.
///
/// The server sends it for any challenge without a clock (correspondence or unlimited), never for
/// real time challenges.
@immutable
class const CorresChallengeCreateFcmMessage(
  final ChallengeId id, {
  @override required final RemoteNotification? notification,
}) extends FcmMessage;

/// An [FcmMessage] sent when a correspondence challenge is accepted.
///
/// The server sends it for any challenge without a clock (correspondence or unlimited), never for
/// real time challenges, and only when the challenger plays white.
@immutable
class const CorresChallengeAcceptFcmMessage(
  final ChallengeId id,
  final GameFullId fullId, {
  @override required final RemoteNotification? notification,
}) extends FcmMessage;

/// An [FcmMessage] sent when a broadcast round a user subscribed to starts.
@immutable
class const BroadcastRoundFcmMessage(
  final BroadcastRoundId roundId, {
  @override required final RemoteNotification? notification,
}) extends FcmMessage;

/// An [FcmMessage] sent when a followed player starts a broadcast game.
@immutable
class const BroadcastPlayerFollowFcmMessage(
  final BroadcastRoundId roundId,
  final BroadcastGameId gameId,
  final Side pov, {
  @override required final RemoteNotification? notification,
}) extends FcmMessage;

/// An [FcmMessage] sent when the year-end recap is ready.
@immutable
class const RecapFcmMessage(
  final int year, {
  @override required final RemoteNotification? notification,
}) extends FcmMessage;

/// An [FcmMessage] that could not be parsed.
@immutable
class const MalformedFcmMessage(final Map<String, dynamic> data) extends FcmMessage {
  @override
  RemoteNotification? get notification => null;
}

/// An [FcmMessage] that is not handled by the application.
@immutable
class const UnhandledFcmMessage(final Map<String, dynamic> data) extends FcmMessage {
  @override
  RemoteNotification? get notification => null;
}

/// Local Notifications
///////////////////////

/// A notification shown to the user from the platform's notification system.
@immutable
sealed class const LocalNotification() {
  /// The unique identifier of the notification.
  int get id;

  /// The channel of the notification.
  NotificationChannel get channel;

  /// The channel identifier of the notification.
  ///
  /// Corresponds to [AndroidNotificationDetails.channelId] for android and
  /// [DarwinNotificationDetails.threadIdentifier] for iOS.
  String get channelId => channel.name;

  /// The Android details of the notification on its [channel].
  AndroidNotificationDetails _androidDetails(
    AppLocalizations l10n, {
    bool autoCancel = true,
    List<AndroidNotificationAction>? actions,
  }) => AndroidNotificationDetails(
    channel.name,
    channel.label(l10n),
    importance: channel.importance,
    priority: channel.priority,
    autoCancel: autoCancel,
    actions: actions,
  );

  /// The discriminator used to reconstruct the concrete notification type from its payload.
  ///
  /// It is unique to each type, unlike [channel], which can be shared or set by the server.
  ///
  /// See [LocalNotification.fromJson].
  String get payloadType;

  /// The localized title of the notification.
  String title(AppLocalizations l10n);

  /// The localized body of the notification.
  String? body(AppLocalizations l10n);

  /// The payload of the notification.
  ///
  /// Implementations must not override this getter, but [_concretePayload] instead.
  ///
  /// See [LocalNotification.fromJson] where the [payloadType] is used to determine the
  /// concrete type of the notification, to be able to deserialize it.
  // The 'channel' key predates [payloadType] and is kept as is, so that notifications posted by
  // a previous version of the app and still sitting in the tray remain readable.
  Map<String, dynamic> get payload => {'channel': payloadType, ..._concretePayload};

  /// The actual payload of the notification.
  ///
  /// Will be merged with the channel:[payloadType] entry to form the final payload.
  Map<String, dynamic> get _concretePayload;

  /// The localized details of the notification for each platform.
  NotificationDetails details(AppLocalizations l10n);

  /// Retrives a local notification from a JSON payload.
  factory fromJson(Map<String, dynamic> json) {
    final type = json['channel'] as String;
    switch (type) {
      case 'corresGameUpdate':
        return CorresGameUpdateNotification.fromJson(json);
      case 'challenge':
        return ChallengeNotification.fromJson(json);
      case 'playban':
        return PlaybanNotification.fromJson(json);
      case 'newMessage':
        return NewMessageNotification.fromJson(json);
      case 'challengeAccept':
        return CorresChallengeAcceptedNotification.fromJson(json);
      case 'challengeCreate':
        return CorresChallengeCreatedNotification.fromJson(json);
      case 'announce':
        return AnnounceNotification.fromJson(json);
      case 'broadcastRound':
        return BroadcastRoundNotification.fromJson(json);
      case 'broadcastPlayerFollow':
        return BroadcastPlayerFollowNotification.fromJson(json);
      case 'recap':
        return RecapNotification.fromJson(json);
      default:
        throw ArgumentError('Unknown notification payload type: $type');
    }
  }
}

/// A notification show to the user when they are banned temporarily from playing.
class const PlaybanNotification(final TemporaryBan playban) extends LocalNotification {
  factory fromJson(Map<String, dynamic> json) {
    final p = pick(json).required();
    final playban = TemporaryBan(
      date: p('date').asDateTimeFromMillisecondsOrThrow(),
      duration: p('minutes').asDurationFromMinutesOrThrow(),
    );
    return PlaybanNotification(playban);
  }

  @override
  NotificationChannel get channel => .playban;

  @override
  String get payloadType => 'playban';

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
    android: _androidDetails(l10n, autoCancel: false),
    iOS: DarwinNotificationDetails(threadIdentifier: channelId),
  );
}

/// A notification for a new message in a private conversation.
///
/// This notification is shown when a new message is received in a private conversation.
/// It is created from a [NewMessageFcmMessage] and contains the conversation ID. The title and
/// message are the same as the title and body of the FCM message's [RemoteNotification].
class const NewMessageNotification(
  final UserId conversationId,
  final String _title,
  final String _message,
) extends LocalNotification {
  factory fromJson(Map<String, dynamic> json) {
    final conversationId = UserId.fromJson(json['conversationId'] as String);
    final title = json['title'] as String;
    final message = json['message'] as String;
    return NewMessageNotification(conversationId, title, message);
  }

  factory fromFcmMessage(NewMessageFcmMessage message) {
    return NewMessageNotification(
      message.conversationId,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
    );
  }

  @override
  NotificationChannel get channel => .newMessage;

  @override
  String get payloadType => 'newMessage';

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
    android: _androidDetails(l10n),
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
class const CorresGameUpdateNotification(
  final GameFullId fullId,
  final String _title,
  final String _body,
) extends LocalNotification {
  factory fromJson(Map<String, dynamic> json) {
    final gameId = GameFullId.fromJson(json['fullId'] as String);
    final title = json['title'] as String;
    final body = json['body'] as String;
    return CorresGameUpdateNotification(gameId, title, body);
  }

  factory fromFcmMessage(CorresGameUpdateFcmMessage message) {
    final title = message.notification?.title ?? '';
    final body = message.notification?.body ?? '';
    return CorresGameUpdateNotification(message.fullId, title, body);
  }

  @override
  NotificationChannel get channel => .corresGameUpdate;

  @override
  String get payloadType => 'corresGameUpdate';

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
    android: _androidDetails(l10n),
    iOS: DarwinNotificationDetails(threadIdentifier: channelId),
  );
}

/// A notification for the acceptance of a correspondence challenge.
///
/// Shown from a [CorresChallengeAcceptFcmMessage]. The server only sends it for challenges without
/// a clock (correspondence or unlimited), and only when the challenger plays white: otherwise the
/// opponent moves first and the challenger gets a [CorresGameUpdateNotification] instead.
class const CorresChallengeAcceptedNotification(
  final GameFullId fullId,
  final String _title,
  final String _body,
) extends LocalNotification {
  factory fromJson(Map<String, dynamic> json) {
    final gameId = GameFullId.fromJson(json['fullId'] as String);
    final title = json['title'] as String;
    final body = json['body'] as String;
    return CorresChallengeAcceptedNotification(gameId, title, body);
  }

  factory fromFcmMessage(CorresChallengeAcceptFcmMessage message) {
    final title = message.notification?.title ?? '';
    final body = message.notification?.body ?? '';
    return CorresChallengeAcceptedNotification(message.fullId, title, body);
  }

  @override
  NotificationChannel get channel => .corresChallengeAccept;

  @override
  String get payloadType => 'challengeAccept';

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
    android: _androidDetails(l10n),
    iOS: DarwinNotificationDetails(threadIdentifier: channelId),
  );
}

/// A notification for the creation of a correspondence challenge.
///
/// Shown from a [CorresChallengeCreateFcmMessage] received while the app is in the background. The
/// server only sends it for challenges without a clock (correspondence or unlimited). In the
/// foreground, incoming challenges of any kind come through the socket and a
/// [ChallengeNotification] is shown instead.
class const CorresChallengeCreatedNotification(
  final ChallengeId challengeId,
  final String _title,
  final String _body,
) extends LocalNotification {
  factory fromJson(Map<String, dynamic> json) {
    final challengeId = ChallengeId.fromJson(json['challengeId'] as String);
    final title = json['title'] as String;
    final body = json['body'] as String;
    return CorresChallengeCreatedNotification(challengeId, title, body);
  }

  factory fromFcmMessage(CorresChallengeCreateFcmMessage message) {
    final title = message.notification?.title ?? '';
    final body = message.notification?.body ?? '';
    return CorresChallengeCreatedNotification(message.id, title, body);
  }

  @override
  NotificationChannel get channel => .corresChallengeCreate;

  @override
  String get payloadType => 'challengeCreate';

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
    android: _androidDetails(l10n),
    iOS: DarwinNotificationDetails(threadIdentifier: channelId),
  );
}

/// A notification for a server-wide announcement.
///
/// There can only be one announce notification at a time. It is shown when the server
/// sends an announce message through the WebSocket, and cancelled when the server
/// clears it or the optional countdown date is reached.
class const AnnounceNotification(
  final String message, {

  /// Optional date shown as a relative time in the notification body.
  final DateTime? date,
}) extends LocalNotification {
  static final int notificationId = 'announce'.hashCode;

  static const dismissActionId = 'dismiss';

  static const darwinCategoryId = 'announce-notification';

  factory fromJson(Map<String, dynamic> json) {
    final dateStr = json['date'] as String?;
    return AnnounceNotification(
      json['message'] as String,
      date: dateStr != null ? DateTime.parse(dateStr) : null,
    );
  }

  static DarwinNotificationCategory darwinCategory(AppLocalizations l10n) =>
      DarwinNotificationCategory(
        darwinCategoryId,
        actions: [
          DarwinNotificationAction.plain(dismissActionId, l10n.mobileCustomizeHomeTipDismiss),
        ],
      );

  @override
  int get id => notificationId;

  @override
  NotificationChannel get channel => .announce;

  @override
  String get payloadType => 'announce';

  @override
  Map<String, dynamic> get _concretePayload => {
    'message': message,
    if (date != null) 'date': date!.toIso8601String(),
  };

  @override
  String title(AppLocalizations _) => message;

  @override
  String? body(AppLocalizations l10n) => date != null ? relativeDate(l10n, date!) : null;

  @override
  NotificationDetails details(AppLocalizations l10n) => NotificationDetails(
    android: _androidDetails(
      l10n,
      autoCancel: false,
      actions: [
        AndroidNotificationAction(
          dismissActionId,
          l10n.mobileCustomizeHomeTipDismiss,
          showsUserInterface: false,
        ),
      ],
    ),
    iOS: DarwinNotificationDetails(
      threadIdentifier: channelId,
      categoryIdentifier: darwinCategoryId,
    ),
  );
}

/// A notification for a received challenge.
///
/// Shown when a challenge, real time or correspondence, is received from the server through the
/// socket while the app is in the foreground. It is the only notification for real time
/// challenges: the server sends no FCM message for them.
class const ChallengeNotification(final Challenge challenge) extends LocalNotification {
  factory fromJson(Map<String, dynamic> json) {
    final challenge = Challenge.fromJson(json['challenge'] as Map<String, dynamic>);
    return ChallengeNotification(challenge);
  }

  @override
  NotificationChannel get channel => .challenge;

  @override
  String get payloadType => 'challenge';

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
    android: _androidDetails(
      l10n,
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

/// A notification for when a broadcast round starts.
///
/// This notification is shown when a broadcast round the user subscribed to starts.
class const BroadcastRoundNotification(
  final BroadcastRoundId roundId,
  final String _title,
  final String _body,
) extends LocalNotification {
  factory fromJson(Map<String, dynamic> json) {
    final roundId = BroadcastRoundId(json['roundId'] as String);
    final title = json['title'] as String;
    final body = json['body'] as String;
    return BroadcastRoundNotification(roundId, title, body);
  }

  factory fromFcmMessage(BroadcastRoundFcmMessage broadcast) {
    return BroadcastRoundNotification(
      broadcast.roundId,
      broadcast.notification?.title ?? '',
      broadcast.notification?.body ?? '',
    );
  }

  @override
  NotificationChannel get channel => .broadcast;

  @override
  String get payloadType => 'broadcastRound';

  @override
  int get id => roundId.hashCode;

  @override
  Map<String, dynamic> get _concretePayload => {
    'roundId': roundId.value,
    'title': _title,
    'body': _body,
  };

  @override
  String title(_) => _title;

  @override
  String? body(_) => _body;

  @override
  NotificationDetails details(AppLocalizations l10n) => NotificationDetails(
    android: _androidDetails(l10n),
    iOS: DarwinNotificationDetails(threadIdentifier: channelId),
  );
}

/// A notification for when a followed player starts a broadcast game.
///
/// This notification is shown when a FIDE player followed by the user begins a game in a broadcast.
class const BroadcastPlayerFollowNotification(
  final BroadcastRoundId roundId,
  final BroadcastGameId gameId,
  final Side pov,
  final String _title,
  final String _body,
) extends LocalNotification {
  factory fromJson(Map<String, dynamic> json) {
    final roundId = BroadcastRoundId(json['roundId'] as String);
    final gameId = BroadcastGameId(json['gameId'] as String);
    final pov = Side.values.byName(json['pov'] as String);
    final title = json['title'] as String;
    final body = json['body'] as String;
    return BroadcastPlayerFollowNotification(roundId, gameId, pov, title, body);
  }

  factory fromFcmMessage(BroadcastPlayerFollowFcmMessage broadcast) {
    return BroadcastPlayerFollowNotification(
      broadcast.roundId,
      broadcast.gameId,
      broadcast.pov,
      broadcast.notification?.title ?? '',
      broadcast.notification?.body ?? '',
    );
  }

  @override
  NotificationChannel get channel => .broadcast;

  @override
  String get payloadType => 'broadcastPlayerFollow';

  @override
  int get id => gameId.hashCode;

  @override
  Map<String, dynamic> get _concretePayload => {
    'roundId': roundId.value,
    'gameId': gameId.value,
    'pov': pov.name,
    'title': _title,
    'body': _body,
  };

  @override
  String title(_) => _title;

  @override
  String? body(_) => _body;

  @override
  NotificationDetails details(AppLocalizations l10n) => NotificationDetails(
    android: _androidDetails(l10n),
    iOS: DarwinNotificationDetails(threadIdentifier: channelId),
  );
}

/// A notification for the year-end recap
///
/// This notification is shown when the year-end recap is received from the server
class const RecapNotification(final int year) extends LocalNotification {
  factory fromJson(Map<String, dynamic> json) {
    final year = json['year'] as int;
    return RecapNotification(year);
  }

  factory fromFcmMessage(RecapFcmMessage message) {
    return RecapNotification(message.year);
  }

  @override
  NotificationChannel get channel => .recap;

  @override
  String get payloadType => 'recap';

  @override
  int get id => year.hashCode;

  @override
  Map<String, dynamic> get _concretePayload => {'year': year};

  @override
  String title(AppLocalizations l10n) => l10n.recapRecapReady(year.toString());

  @override
  String body(AppLocalizations l10n) => l10n.recapAwaitQuestion;

  @override
  NotificationDetails details(AppLocalizations l10n) =>
      NotificationDetails(android: _androidDetails(l10n));
}
