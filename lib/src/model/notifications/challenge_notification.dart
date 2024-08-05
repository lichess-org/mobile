import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/l10n/l10n_en.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/notifications/local_notification_service.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/user/challenge_requests_screen.dart';

class ChallengeNotificationDetails {
  ChallengeNotificationDetails(this._locale) {
    ChallengeNotificationDetails.instance = this;
  }

  // the default instance is set to english but this is overridden in LocalNotificationService.init()
  static ChallengeNotificationDetails instance =
      ChallengeNotificationDetails(AppLocalizationsEn());

  final AppLocalizations _locale;

  NotificationDetails get notificationDetails => NotificationDetails(
        android: AndroidNotificationDetails(
          'challenges',
          _locale.preferencesNotifyChallenge,
          importance: Importance.max,
          priority: Priority.high,
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction(
              'accept',
              _locale.accept,
              icon: const DrawableResourceAndroidBitmap('tick'),
              showsUserInterface: true,
              contextual: true,
            ),
            AndroidNotificationAction(
              'decline',
              _locale.decline,
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
            _locale.accept,
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
          DarwinNotificationAction.plain(
            'decline',
            _locale.decline,
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

class ChallengeNotification {
  ChallengeNotification(this.id);

  final ChallengeId id;

  void _callback(String? actionId, LocalNotificationServiceRef ref) {
    switch (actionId) {
      case 'accept': // accept the game and open board
        final repo = ref.read(challengesProvider.notifier);
        repo.accept(id).then((fullId) {
          pushPlatformRoute(
            ref.read(currentNavigatorKeyProvider).currentContext!,
            builder: (BuildContext context) =>
                GameScreen(initialGameId: fullId),
          );
        });
      case null: // open the challenge screen
        pushPlatformRoute(
          ref.read(currentNavigatorKeyProvider).currentContext!,
          builder: (BuildContext context) => const ChallengeRequestsScreen(),
        );
      case 'decline':
        ref.read(challengeRepositoryProvider).decline(id);
    }
  }

  NotificationCallback get callback => _callback;

  LocalNotification build(String title, {String? body}) {
    return LocalNotification(
      title: title,
      body: body,
      payload: 'challenge-notification:${id.value}',
      notificationDetails:
          ChallengeNotificationDetails.instance.notificationDetails,
    );
  }
}
