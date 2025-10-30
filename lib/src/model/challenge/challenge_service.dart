import 'dart:async';

import 'package:collection/collection.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/notifications/notifications.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart'
    show currentNavigatorKeyProvider;
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen_providers.dart';
import 'package:lichess_mobile/src/view/user/challenge_requests_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_transform/stream_transform.dart';

part 'challenge_service.g.dart';

@Riverpod(keepAlive: true)
ChallengeService challengeService(Ref ref) {
  final service = ChallengeService(ref);
  ref.onDispose(() => service.dispose());
  return service;
}

/// A service that listens to challenge events and shows notifications.
class ChallengeService {
  ChallengeService(this.ref);

  final Ref ref;

  ChallengesList? _current;
  ChallengesList? _previous;

  StreamSubscription<ChallengesList>? _socketSubscription;
  StreamSubscription<(NotificationResponse, LocalNotification)>?
  _notificationResponseSubscription;

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

    _notificationResponseSubscription = NotificationService.responseStream
        .listen((data) {
          final (response, notification) = data;
          switch (notification) {
            case ChallengeNotification(:final challenge):
              _onNotificationResponse(response.actionId, challenge);
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
          .map(
            (id) async => await notificationService.cancel(id.value.hashCode),
          ),
    );

    // new incoming challenges
    await Future.wait(
      _current?.inward
              .whereNot((challenge) => prevInwardIds.contains(challenge.id))
              .map((challenge) async {
                return await notificationService.show(
                  ChallengeNotification(challenge),
                );
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
  Future<void> _onNotificationResponse(
    String? actionid,
    Challenge challenge,
  ) async {
    final challengeId = challenge.id;

    switch (actionid) {
      case 'accept':
        await _acceptChallenge(challengeId);

      case 'decline':
        final context = ref.read(currentNavigatorKeyProvider).currentContext;
        if (context == null || !context.mounted) break;
        _showDeclineDialog(context, challengeId);

      case null:
        final context = ref.read(currentNavigatorKeyProvider).currentContext;
        if (context == null || !context.mounted) break;
        final challenge = _current?.inward.firstWhereOrNull(
          (challenge) => challenge.id == challengeId,
        );
        if (challenge != null) {
          _showConfirmDialog(context, challenge);
        } else {
          Navigator.of(
            context,
          ).push(ChallengeRequestsScreen.buildRoute(context));
        }
    }
  }

  Future<GameFullId?> acceptChallenge(ChallengeId id) async {
    final challengeRepo = ref.read(challengeRepositoryProvider);
    await challengeRepo.accept(id);
    return await challengeRepo
        .show(id)
        .then((challenge) => challenge.gameFullId);
  }

  Future<void> _acceptChallenge(ChallengeId id) async {
    final fullId = await acceptChallenge(id);

    final context = ref.read(currentNavigatorKeyProvider).currentContext;
    if (context == null || !context.mounted) return;

    if (fullId == null) {
      return showSnackBar(
        context,
        'Failed to accept challenge',
        type: SnackBarType.error,
      );
    }

    final rootNavState = Navigator.of(context, rootNavigator: true);
    if (rootNavState.canPop()) {
      rootNavState.popUntil((route) => route.isFirst);
    }

    Navigator.of(
      context,
      rootNavigator: true,
    ).push(GameScreen.buildRoute(context, source: ExistingGameSource(fullId)));
  }

  void _showDeclineDialog(BuildContext context, ChallengeId id) {
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
                ref
                    .read(challengeRepositoryProvider)
                    .decline(id, reason: reason);
              },
            ),
          )
          .toList(),
    );
  }

  void _showConfirmDialog(BuildContext context, Challenge challenge) {
    showAdaptiveActionSheet<void>(
      context: context,
      title: challenge.variant.isPlaySupported
          ? Text(
              '${challenge.challenger!.user.name} challenges you: ${challenge.description(context.l10n)}',
            )
          : null,
      actions: [
        if (challenge.variant.isPlaySupported)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.accept),
            leading: Icon(Icons.check, color: context.lichessColors.good),
            isDefaultAction: true,
            onPressed: () async => await _acceptChallenge(challenge.id),
          ),
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.decline),
          leading: Icon(Icons.clear, color: context.lichessColors.error),
          isDestructiveAction: true,
          onPressed: () => _showDeclineDialog(context, challenge.id),
        ),
      ],
    );
  }
}
