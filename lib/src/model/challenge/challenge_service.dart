import 'dart:async';

import 'package:collection/collection.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/notifications/notifications.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/user/challenge_requests_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'challenge_service.g.dart';

@Riverpod(keepAlive: true)
ChallengeService challengeService(ChallengeServiceRef ref) {
  final service = ChallengeService(ref);
  ref.onDispose(() => service.dispose());
  return service;
}

final _challengeStreamController = StreamController<ChallengesList>.broadcast();

/// The stream of challenge events that are received from the server.
final Stream<ChallengesList> challengeStream =
    _challengeStreamController.stream;

/// A service that listens to challenge events and shows notifications.
class ChallengeService {
  ChallengeService(this.ref);

  final ChallengeServiceRef ref;

  ChallengesList? _current;
  ChallengesList? _previous;

  StreamSubscription<SocketEvent>? _socketSubscription;

  /// Start listening to challenge events from the server.
  void start() {
    _socketSubscription = socketGlobalStream.listen(_onSocketEvent);
  }

  void _onSocketEvent(SocketEvent event) {
    if (event.topic != 'challenges') return;

    final listPick = pick(event.data).required();
    final inward = listPick('in').asListOrEmpty(Challenge.fromPick);
    final outward = listPick('out').asListOrEmpty(Challenge.fromPick);

    _previous = _current;
    _current = (inward: inward.lock, outward: outward.lock);
    _challengeStreamController.add(_current!);

    final Iterable<ChallengeId> prevInwardIds =
        _previous?.inward.map((challenge) => challenge.id) ?? [];
    final Iterable<ChallengeId> currentInwardIds =
        inward.map((challenge) => challenge.id);

    // challenges that were canceled by challenger or expired
    prevInwardIds
        .whereNot((challengeId) => currentInwardIds.contains(challengeId))
        .forEach(
          (id) =>
              ref.read(notificationServiceProvider).cancel(id.value.hashCode),
        );

    // new incoming challenges
    inward
        .whereNot((challenge) => prevInwardIds.contains(challenge.id))
        .forEach(
      (challenge) {
        ref
            .read(notificationServiceProvider)
            .show(ChallengeNotification(challenge));
      },
    );
  }

  /// Stop listening to challenge events from the server.
  void dispose() {
    _socketSubscription?.cancel();
  }

  /// Handle a local notification response when the app is in the foreground.
  Future<void> onNotificationResponse(
    String? actionid,
    Challenge challenge,
  ) async {
    final challengeId = challenge.id;

    switch (actionid) {
      case 'accept':
        final repo = ref.read(challengeRepositoryProvider);
        await repo.accept(challengeId);

        final fullId = await repo
            .show(challengeId)
            .then((challenge) => challenge.gameFullId);

        final context = ref.read(currentNavigatorKeyProvider).currentContext;
        if (context == null || !context.mounted) break;

        final rootNavState = Navigator.of(context, rootNavigator: true);
        if (rootNavState.canPop()) {
          rootNavState.popUntil((route) => route.isFirst);
        }

        pushPlatformRoute(
          context,
          rootNavigator: true,
          builder: (BuildContext context) => GameScreen(initialGameId: fullId),
        );

      case 'decline':
        final context = ref.read(currentNavigatorKeyProvider).currentContext;
        if (context == null || !context.mounted) break;
        showAdaptiveActionSheet<void>(
          context: context,
          actions: ChallengeDeclineReason.values
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
        pushPlatformRoute(
          context,
          builder: (BuildContext context) => const ChallengeRequestsScreen(),
        );
    }
  }
}