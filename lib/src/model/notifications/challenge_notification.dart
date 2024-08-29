import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/l10n/l10n_en.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/model/challenge/challenges.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/notifications/local_notification_service.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/user/challenge_requests_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'challenge_notification.g.dart';

@Riverpod(keepAlive: true)
ChallengeService challengeService(ChallengeServiceRef ref) {
  return ChallengeService(ref);
}

class ChallengeService {
  ChallengeService(this.ref);

  final ChallengeServiceRef ref;

  void init() {
    ref.listen(challengesProvider, (prev, current) {
      if (prev == null || !prev.hasValue || !current.hasValue) return;
      final prevIds = prev.value!.inward.map((challenge) => challenge.id);
      final inward = current.value!.inward;
      final l10n = ref.read(l10nProvider).strings;

      // if a challenge was cancelled by the challenger
      prevIds
          .where((id) => !inward.map((challenge) => challenge.id).contains(id))
          .forEach(
            (id) => ref
                .read(localNotificationServiceProvider)
                .cancel(id.value.hashCode),
          );

      // if there is a new challenge
      inward.where((challenge) => !prevIds.contains(challenge.id)).forEach(
            (challenge) => ref
                .read(localNotificationServiceProvider)
                .show(ChallengeNotification(challenge, l10n)),
          );
    });
  }

  Future<void> onNotificationResponse(
    int id,
    String? actionid,
    ChallengePayload payload,
  ) async {
    switch (actionid) {
      case 'accept':
        final repo = ref.read(challengeRepositoryProvider);
        await repo.accept(payload.id);

        final fullId = await repo
            .show(payload.id)
            .then((challenge) => challenge.gameFullId);

        final context = ref.read(currentNavigatorKeyProvider).currentContext!;
        if (!context.mounted) break;

        final navState = Navigator.of(context);
        if (navState.canPop()) {
          navState.popUntil((route) => route.isFirst);
        }

        pushPlatformRoute(
          context,
          rootNavigator: true,
          builder: (BuildContext context) => GameScreen(initialGameId: fullId),
        );

      case null:
        final context = ref.read(currentNavigatorKeyProvider).currentContext!;
        final navState = Navigator.of(context);
        if (navState.canPop()) {
          navState.popUntil((route) => route.isFirst);
        }
        pushPlatformRoute(
          context,
          builder: (BuildContext context) => const ChallengeRequestsScreen(),
        );
      case 'decline':
        final repo = ref.read(challengeRepositoryProvider);
        repo.decline(payload.id);
    }
  }
}

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
      ChallengePayload(_challenge.id).notificationPayload;

  @override
  String get body => _body();

  String _body() {
    final time = switch (_challenge.timeControl) {
      ChallengeTimeControlType.clock => () {
          final clock = _challenge.clock!;
          final minutes = switch (clock.time.inSeconds) {
            15 => '¼',
            30 => '½',
            45 => '¾',
            90 => '1.5',
            _ => clock.time.inMinutes,
          };
          return '$minutes+${clock.increment.inSeconds}';
        }(),
      ChallengeTimeControlType.correspondence =>
        '${_l10n.daysPerTurn}: ${_challenge.days}',
      ChallengeTimeControlType.unlimited => '∞',
    };

    return _challenge.rated
        ? '${_l10n.rated} • $time'
        : '${_l10n.casual} • $time';
  }
}

class ChallengePayload {
  const ChallengePayload(this.id);

  final ChallengeId id;

  NotificationPayload get notificationPayload => NotificationPayload(
        type: PayloadType.challenge,
        data: {
          'id': id.value,
        },
      );

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
