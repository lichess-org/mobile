import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/l10n/l10n_en.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/notifications/local_notification_service.dart';

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

enum ChallengeNotificationAction { accept, decline, pressed }

class ChallengeNotification extends LocalNotification {
  ChallengeNotification(this._challenge, this._l10n, {this.onPressed})
      : super(
          '${_challenge.challenger!.user.name} challenges you!',
          ChallengeNotificationDetails.instance.notificationDetails,
        );

  final Challenge _challenge;
  final AppLocalizations _l10n;
  final void Function(ChallengeNotificationAction action, ChallengeId id)?
      onPressed;

  @override
  int get id => _challenge.id.value.hashCode;

  @override
  String get payload => _challenge.id.value;

  @override
  String get body => _body();

  @override
  void Function(String? actionId, String? payload) get callback => _callback;

  String _body() {
    final time = _challenge.days == null
        ? '∞'
        : '${_l10n.daysPerTurn}: ${_challenge.days}';
    return _challenge.rated
        ? '${_l10n.rated} • $time'
        : '${_l10n.casual} • $time';
  }

  void _callback(String? actionId, String? payload) {
    final action = switch (actionId) {
      'accept' => ChallengeNotificationAction.accept,
      'decline' => ChallengeNotificationAction.decline,
      null || String() => ChallengeNotificationAction.pressed,
    };
    final id = ChallengeId(payload!);
    onPressed?.call(action, id);
  }
}
