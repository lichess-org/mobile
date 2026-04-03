import 'dart:async';

import 'package:collection/collection.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/ongoing_game.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/lobby/create_game_service.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/notifications/notifications.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart' show currentNavigatorKeyProvider;
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen_providers.dart';
import 'package:lichess_mobile/src/view/user/challenge_requests_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:stream_transform/stream_transform.dart';

/// A provider for [ChallengeService].
final challengeServiceProvider = Provider<ChallengeService>((Ref ref) {
  final service = ChallengeService(ref);
  ref.onDispose(() => service.dispose());
  return service;
}, name: 'ChallengeServiceProvider');

/// A service that listens to challenge events and shows notifications.
class ChallengeService {
  ChallengeService(this.ref);

  final Ref ref;

  ChallengesList? _current;
  ChallengesList? _previous;

  StreamSubscription<ChallengesList>? _socketSubscription;
  StreamSubscription<(NotificationResponse, LocalNotification)>? _notificationResponseSubscription;

  /// The stream of challenge events that are received from the server.
  static Stream<ChallengesList> get stream => socketGlobalStream.map((event) {
    if (event.topic != 'challenges') return null;
    final listPick = pick(event.data).required();
    final inward = listPick('in').asListOrEmpty(Challenge.fromPick);
    final outward = listPick('out').asListOrEmpty(Challenge.fromPick);
    return (inward: inward.lock, outward: outward.lock);
  }).whereNotNull();

  /// Start listening to events.
  void start() {
    _socketSubscription = stream.listen(_onSocketEvent);

    _notificationResponseSubscription = NotificationService.responseStream.listen((data) {
      final (response, notification) = data;
      switch (notification) {
        case ChallengeNotification(:final challenge):
          _onChallengeForegroundNotificationResponse(response.actionId, challenge);
        case ChallengeCreatedNotification(:final challengeId):
          _onChallengeBackgroundNotificationResponse(challengeId);
        case ChallengeAcceptedNotification(:final fullId):
          _onChallengeAccepted(fullId);
        case _:
          break;
      }
    });
  }

  void _onSocketEvent(ChallengesList current) {
    _previous = _current;
    _current = current;

    _sendNotifications();
  }

  Future<void> _sendNotifications() async {
    final notificationService = ref.read(notificationServiceProvider);

    final Iterable<ChallengeId> prevInwardIds =
        _previous?.inward.map((challenge) => challenge.id) ?? [];
    final Iterable<ChallengeId> currentInwardIds =
        _current?.inward.map((challenge) => challenge.id) ?? [];

    // challenges that were canceled by challenger or expired
    await Future.wait(
      prevInwardIds
          .whereNot((challengeId) => currentInwardIds.contains(challengeId))
          .map((id) async => await notificationService.cancel(id.value.hashCode)),
    );

    // new incoming challenges
    await Future.wait(
      _current?.inward.whereNot((challenge) => prevInwardIds.contains(challenge.id)).map((
            challenge,
          ) async {
            return await notificationService.show(ChallengeNotification(challenge));
          }) ??
          <Future<int>>[],
    );
  }

  /// Stop listening to challenge events from the server.
  void dispose() {
    _socketSubscription?.cancel();
    _notificationResponseSubscription?.cancel();
  }

  /// Handle a local notification response when the app is in the foreground.
  Future<void> _onChallengeForegroundNotificationResponse(
    String? actionid,
    Challenge challenge,
  ) async {
    final challengeId = challenge.id;

    switch (actionid) {
      case 'accept':
        await acceptChallenge(challengeId);

      case 'decline':
        final context = ref.read(currentNavigatorKeyProvider).currentContext;
        if (context == null || !context.mounted) break;
        showDeclineDialog(context, challengeId);

      case null:
        final context = ref.read(currentNavigatorKeyProvider).currentContext;
        if (context == null || !context.mounted) break;
        final challenge = _current?.inward.firstWhereOrNull(
          (challenge) => challenge.id == challengeId,
        );
        if (challenge != null) {
          showConfirmDialog(context, challenge);
        } else {
          Navigator.of(context).push(ChallengeRequestsScreen.buildRoute(context));
        }
    }
  }

  /// Handle a local notification response when the app is in the background.
  Future<void> _onChallengeBackgroundNotificationResponse(ChallengeId id) async {
    final challenge = await ref.read(challengeRepositoryProvider).show(id);
    final context = ref.read(currentNavigatorKeyProvider).currentContext;
    if (context == null || !context.mounted) return;
    showConfirmDialog(context, challenge);
  }

  void _onChallengeAccepted(GameFullId fullId) {
    final context = ref.read(currentNavigatorKeyProvider).currentContext;
    if (context == null || !context.mounted) return;

    final rootNavState = Navigator.of(context, rootNavigator: true);
    if (rootNavState.canPop()) {
      rootNavState.popUntil((route) => route.isFirst);
    }

    Navigator.of(
      context,
      rootNavigator: true,
    ).push(GameScreen.buildRoute(context, source: ExistingGameSource(fullId)));
  }

  /// Accept a challenge and open the GameScreen for the created game.
  Future<void> acceptChallenge(ChallengeId id) async {
    // Cancel any pending lobby seek before accepting, to prevent being matched into a new game
    // while accepting a challenge.
    try {
      await ref.read(createGameServiceProvider).cancelSeek();
    } catch (_) {}

    final challengeRepo = ref.read(challengeRepositoryProvider);
    await challengeRepo.accept(id);
    final fullId = await challengeRepo.show(id).then((challenge) => challenge.gameFullId);

    final context = ref.read(currentNavigatorKeyProvider).currentContext;
    if (context == null || !context.mounted) return;

    if (fullId == null) {
      return showSnackBar(context, 'Failed to accept challenge', type: SnackBarType.error);
    }

    ref.invalidate(ongoingGamesProvider);

    _onChallengeAccepted(fullId);
  }

  void showDeclineDialog(BuildContext context, ChallengeId id) {
    showAdaptiveActionSheet<ChallengeDeclineReason>(
      context: context,
      title: Text(context.l10n.decline),
      actions: ChallengeDeclineReason.values
          .map(
            (reason) => BottomSheetAction(
              makeLabel: (context) => Text(reason.label(context.l10n)),
              leading: Icon(Icons.close, color: context.lichessColors.error),
              isDestructiveAction: true,
              onPressed: () {
                ref.read(challengeRepositoryProvider).decline(id, reason: reason);
              },
            ),
          )
          .toList(),
    );
  }

  void showConfirmDialog(
    BuildContext context,
    Challenge challenge, {
    String? title,
    bool fromLink = false,
  }) {
    showAdaptiveActionSheet<void>(
      context: context,
      title: challenge.challenger != null && challenge.variant.isPlaySupported
          ? Text(
              title ??
                  '${challenge.challenger!.user.name} challenges you: ${challenge.description(context.l10n)}',
            )
          : null,
      actions: [
        if (challenge.variant.isPlaySupported)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.accept),
            leading: Icon(Icons.check, color: context.lichessColors.good),
            isDefaultAction: true,
            onPressed: () async => await acceptChallenge(challenge.id),
          ),
        if (fromLink && Theme.of(context).platform != TargetPlatform.iOS)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.cancel),
            leading: const Icon(Icons.close),
            onPressed: () {},
          )
        else if (!fromLink)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.decline),
            leading: Icon(Icons.clear, color: context.lichessColors.error),
            isDestructiveAction: true,
            onPressed: () => showDeclineDialog(context, challenge.id),
          ),
      ],
    );
  }
}
