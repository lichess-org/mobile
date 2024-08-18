import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/l10n/l10n_en.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/notifications/local_notification_service.dart';
class ChallengeNotification extends LocalNotification {
  ChallengeNotification(this._challenge, this._l10n)
      : super(
          '${_challenge.challenger!.user.name} challenges you!',
          ChallengeNotificationDetails.instance.notificationDetails,
        );

  final Challenge _challenge;
  final AppLocalizations _l10n;

  @override
  int get id => _challenge.id.value.hashCode;

  @override
  NotificationPayload get payload =>
      ChallengePayload(_challenge.id).toNotifiationPayload();

  @override
  String get body => _body();

  String _body() {
    final time = _challenge.days == null
        ? '∞'
        : '${_l10n.daysPerTurn}: ${_challenge.days}';
    return _challenge.rated
        ? '${_l10n.rated} • $time'
        : '${_l10n.casual} • $time';
  }
}

class ChallengePayload {
  const ChallengePayload(this.id);

  final ChallengeId id;

  NotificationPayload toNotifiationPayload() {
    return NotificationPayload(
      type: PayloadType.challenge,
      data: {
        'id': id.value,
      },
    );
  }

  factory ChallengePayload.fromNotificationPayload(
    NotificationPayload payload,
  ) {
    assert(payload.type == PayloadType.challenge);
    final id = payload.data['id'] as String;
    return ChallengePayload(ChallengeId(id));
  }
}

class ChallengeNotificationDetails {
  ChallengeNotificationDetails(this._l10n) {
    ChallengeNotificationDetails.instance = this;
  }

  // the default instance is set to english but this is overridden in LocalNotificationService.init()
  static ChallengeNotificationDetails instance =
      ChallengeNotificationDetails(AppLocalizationsEn());

  final AppLocalizations _l10n;

  NotificationDetails get notificationDetails => NotificationDetails(
        android: AndroidNotificationDetails(
          'challenges',
          _l10n.preferencesNotifyChallenge,
          importance: Importance.max,
          priority: Priority.high,
          autoCancel: false,
          actions: <AndroidNotificationAction>[
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
          categoryIdentifier: 'challenge-notification',
        ),
      );

  DarwinNotificationCategory get darwinNotificationCategory =>
      DarwinNotificationCategory(
        'challenge-notification',
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain(
            'accept',
            _l10n.accept,
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
          DarwinNotificationAction.plain(
            'decline',
            _l10n.decline,
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
