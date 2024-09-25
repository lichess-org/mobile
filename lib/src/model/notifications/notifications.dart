import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/id.dart';

/// A notification shown to the user from the platform's notification system.
sealed class LocalNotification {
  /// The unique identifier of the notification.
  int get id;

  /// The localized title of the notification.
  String title(AppLocalizations l10n);

  /// The localized body of the notification.
  String? body(AppLocalizations l10n);

  /// The payload of the notification.
  ///
  /// It must contain a field named 'type' (of type [String]) to identify the
  /// notification.
  Map<String, dynamic>? get payload;

  /// The localized details of the notification for each platform.
  NotificationDetails details(AppLocalizations l10n);

  /// Retrives a local notification from a JSON payload.
  factory LocalNotification.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case 'corresGameUpdate':
        return CorresGameUpdateNotification.fromJson(json);
      case 'challenge':
        return ChallengeNotification.fromJson(json);
      default:
        throw ArgumentError('Unknown notification type: $type');
    }
  }
}

/// A local notification for a correspondence game update.
///
/// This notification is shown when a correspondence game is updated on the server
/// and a FCM message is received and contains itself a notification.
///
/// Fields [title] and [body] are dynamic and part of the payload because they
/// are generated server side and are included in the FCM message's [RemoteMessage.notification] field.
class CorresGameUpdateNotification implements LocalNotification {
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

  @override
  int get id => fullId.hashCode;

  @override
  Map<String, dynamic> get payload => {
        'type': 'corresGameUpdate',
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
          'corresGameUpdate',
          l10n.preferencesNotifyGameEvent,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          autoCancel: true,
        ),
      );
}

/// A local notification for a challenge.
///
/// This notification is shown when a challenge is received from the server through
/// the web socket.
class ChallengeNotification implements LocalNotification {
  const ChallengeNotification(this.challenge);

  final Challenge challenge;

  factory ChallengeNotification.fromJson(Map<String, dynamic> json) {
    final challenge =
        Challenge.fromJson(json['challenge'] as Map<String, dynamic>);
    return ChallengeNotification(challenge);
  }

  @override
  int get id => challenge.id.value.hashCode;

  @override
  Map<String, dynamic> get payload => {
        'type': 'challenge',
        'challenge': challenge.toJson(),
      };

  @override
  String title(AppLocalizations _) =>
      '${challenge.challenger!.user.name} challenges you!';

  @override
  String body(AppLocalizations l10n) => challenge.description(l10n);

  @override
  NotificationDetails details(AppLocalizations l10n) => NotificationDetails(
        android: AndroidNotificationDetails(
          'challenges',
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
          categoryIdentifier: challenge.variant.isPlaySupported
              ? darwinPlayableVariantCategoryId
              : darwinUnplayableVariantCategoryId,
        ),
      );

  static const darwinPlayableVariantCategoryId =
      'challenge-notification-playable-variant';

  static const darwinUnplayableVariantCategoryId =
      'challenge-notification-unplayable-variant';

  static DarwinNotificationCategory darwinPlayableVariantCategory(
    AppLocalizations l10n,
  ) =>
      DarwinNotificationCategory(
        darwinPlayableVariantCategoryId,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain(
            'accept',
            l10n.accept,
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
          DarwinNotificationAction.plain(
            'decline',
            l10n.decline,
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      );

  static DarwinNotificationCategory darwinUnplayableVariantCategory(
    AppLocalizations l10n,
  ) =>
      DarwinNotificationCategory(
        darwinUnplayableVariantCategoryId,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain(
            'decline',
            l10n.decline,
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      );
}
