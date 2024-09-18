import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/notifications/local_notification.dart';

class ChallengeNotification implements LocalNotification {
  ChallengeNotification(this._challenge, this._l10n);

  final Challenge _challenge;
  final AppLocalizations _l10n;

  @override
  int get id => _challenge.id.value.hashCode;

  @override
  NotificationPayload get payload =>
      ChallengePayload(_challenge.id).notificationPayload;

  @override
  String get title => '${_challenge.challenger!.user.name} challenges you!';

  @override
  String get body => _challenge.description(_l10n);

  @override
  NotificationDetails get details => NotificationDetails(
        android: AndroidNotificationDetails(
          'challenges',
          _l10n.preferencesNotifyChallenge,
          importance: Importance.max,
          priority: Priority.high,
          autoCancel: false,
          actions: <AndroidNotificationAction>[
            if (_challenge.variant.isPlaySupported)
              AndroidNotificationAction(
                'accept',
                _l10n.accept,
                icon: const DrawableResourceAndroidBitmap('tick'),
                showsUserInterface: true,
                contextual: true,
              ),
            AndroidNotificationAction(
              'decline',
              _l10n.decline,
              icon: const DrawableResourceAndroidBitmap('cross'),
              contextual: true,
            ),
          ],
        ),
        iOS: const DarwinNotificationDetails(
          categoryIdentifier: darwinCategoryId,
        ),
      );

  static const darwinCategoryId = 'challenge-notification-category';

  static DarwinNotificationCategory darwinNotificationCategory(
    AppLocalizations l10n,
  ) =>
      DarwinNotificationCategory(
        darwinCategoryId,
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
              DarwinNotificationActionOption.destructive,
            },
          ),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      );
}

class ChallengePayload {
  const ChallengePayload(this.id);

  final ChallengeId id;

  NotificationPayload get notificationPayload => NotificationPayload(
        type: NotificationType.challenge,
        data: {
          'id': id.value,
        },
      );

  factory ChallengePayload.fromNotification(
    NotificationPayload payload,
  ) {
    assert(payload.type == NotificationType.challenge);
    final id = payload.data['id'] as String;
    return ChallengePayload(ChallengeId(id));
  }
}
