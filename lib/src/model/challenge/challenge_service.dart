import 'dart:async';

import 'package:collection/collection.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/notifications/notifications.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/user/challenge_requests_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
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

  /// The stream of challenge events that are received from the server.
  static Stream<ChallengesList> get stream =>
      socketGlobalStream.map((event) {
        if (event.topic != 'challenges') return null;
        final listPick = pick(event.data).required();
        final inward = listPick('in').asListOrEmpty(Challenge.fromPick);
        final outward = listPick('out').asListOrEmpty(Challenge.fromPick);
        return (inward: inward.lock, outward: outward.lock);
      }).whereNotNull();

  /// Start listening to challenge events from the server.
  void start() {
    _socketSubscription = stream.listen(_onSocketEvent);
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
  }

  /// Handle a local notification response when the app is in the foreground.
  Future<void> onNotificationResponse(String? actionid, Challenge challenge) async {
    final challengeId = challenge.id;

    switch (actionid) {
      case 'accept':
        final repo = ref.read(challengeRepositoryProvider);
        await repo.accept(challengeId);

        final fullId = await repo.show(challengeId).then((challenge) => challenge.gameFullId);

        final context = ref.read(currentNavigatorKeyProvider).currentContext;
        if (context == null || !context.mounted) break;

        final rootNavState = Navigator.of(context, rootNavigator: true);
        if (rootNavState.canPop()) {
          rootNavState.popUntil((route) => route.isFirst);
        }

        Navigator.of(
          context,
          rootNavigator: true,
        ).push(GameScreen.buildRoute(context, initialGameId: fullId));

      case 'decline':
        final context = ref.read(currentNavigatorKeyProvider).currentContext;
        if (context == null || !context.mounted) break;
        showAdaptiveActionSheet<void>(
          context: context,
          actions:
              ChallengeDeclineReason.values
                  .map(
                    (reason) => BottomSheetAction(
                      makeLabel: (context) => Text(reason.label(context.l10n)),
                      onPressed: (_) {
                        final repo = ref.read(challengeRepositoryProvider);
                        repo.decline(challengeId, reason: reason);
                      },
                    ),
                  )
                  .toList(),
        );

      case null:
        final context = ref.read(currentNavigatorKeyProvider).currentContext;
        if (context == null || !context.mounted) break;
        final navState = Navigator.of(context);
        if (navState.canPop()) {
          navState.popUntil((route) => route.isFirst);
        }
        Navigator.of(context).push(ChallengeRequestsScreen.buildRoute(context));
    }
  }
}
