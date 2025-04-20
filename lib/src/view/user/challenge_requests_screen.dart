import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/model/challenge/challenges.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/play/challenge_list_item.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

class ChallengeRequestsScreen extends StatelessWidget {
  const ChallengeRequestsScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const ChallengeRequestsScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.preferencesNotifyChallenge)),
      body: _Body(),
    );
  }
}

class ChallengeRequestsWidget extends ConsumerWidget {
  const ChallengeRequestsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    if (session == null) {
      return const SizedBox.shrink();
    }

    final challenges = ref.watch(challengesProvider);
    switch (challenges) {
      case AsyncData(:final value):
        final list = value.inward.addAll(value.outward);
        if (list.isEmpty) {
          return const SizedBox.shrink();
        }
        return ListSection(
          header: Text(context.l10n.preferencesNotifyChallenge),
          onHeaderTap:
              list.length > 5
                  ? () {
                    Navigator.of(context).push(ChallengeRequestsScreen.buildRoute(context));
                  }
                  : null,
          hasLeading: true,
          children: [
            for (final challenge in list.take(5))
              if (challenge.challenger?.user != null)
                _ChallengeListItem(
                  challenge: challenge,
                  challengerUser: challenge.challenger!.user,
                  session: session,
                ),
          ],
        );
      case AsyncError():
        return const Padding(
          padding: Styles.bodySectionPadding,
          child: Text('Error loading challenges.'),
        );
      case _:
        return Shimmer(
          child: ShimmerLoading(
            isLoading: true,
            child: ListSection.loading(itemsNumber: 5, header: true),
          ),
        );
    }
  }
}

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challenges = ref.watch(challengesProvider);
    final session = ref.watch(authSessionProvider);

    return challenges.when(
      data: (challenges) {
        final list = challenges.inward.addAll(challenges.outward);

        if (list.isEmpty) {
          return Center(child: Text(context.l10n.nothingToSeeHere));
        }

        return ListView.separated(
          itemCount: list.length,
          separatorBuilder:
              (context, index) => const PlatformDivider(height: 1, cupertinoHasLeading: true),
          itemBuilder: (context, index) {
            final challenge = list[index];
            final user = challenge.challenger?.user;

            if (user == null) return null;

            return _ChallengeListItem(challenge: challenge, challengerUser: user, session: session);
          },
        );
      },
      loading: () {
        return const Center(child: CircularProgressIndicator.adaptive());
      },
      error: (error, stack) => const Center(child: Text('Error loading challenges')),
    );
  }
}

class _ChallengeListItem extends ConsumerWidget {
  const _ChallengeListItem({
    required this.challenge,
    required this.challengerUser,
    required this.session,
  });

  final Challenge challenge;
  final LightUser challengerUser;
  final AuthSessionState? session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> acceptChallenge() async {
      final challengeRepo = ref.read(challengeRepositoryProvider);
      await challengeRepo.accept(challenge.id);
      final fullId = await challengeRepo
          .show(challenge.id)
          .then((challenge) => challenge.gameFullId);
      if (!context.mounted) return;
      Navigator.of(
        context,
        rootNavigator: true,
      ).push(GameScreen.buildRoute(context, initialGameId: fullId));
    }

    Future<void> declineChallenge(ChallengeDeclineReason? reason) async {
      ref.read(challengeRepositoryProvider).decline(challenge.id, reason: reason);
      ref.read(notificationServiceProvider).cancel(challenge.id.value.hashCode);
    }

    void confirmDialog() {
      showAdaptiveActionSheet<void>(
        context: context,
        title:
            challenge.variant.isPlaySupported ? const Text('Do you accept the challenge?') : null,
        actions: [
          if (challenge.variant.isPlaySupported)
            BottomSheetAction(
              makeLabel: (context) => Text(context.l10n.accept),
              leading: Icon(Icons.check, color: context.lichessColors.good),
              isDefaultAction: true,
              onPressed: acceptChallenge,
            ),
          ...ChallengeDeclineReason.values.map(
            (reason) => BottomSheetAction(
              makeLabel: (context) => Text(reason.label(context.l10n)),
              leading: Icon(Icons.close, color: context.lichessColors.error),
              isDestructiveAction: true,
              onPressed: () {
                declineChallenge(reason);
              },
            ),
          ),
        ],
      );
    }

    void showMissingAccountMessage() {
      showSnackBar(context, context.l10n.youNeedAnAccountToDoThat);
    }

    return ChallengeListItem(
      challenge: challenge,
      challengerUser: challengerUser,
      onPressed:
          challenge.direction == ChallengeDirection.inward
              ? session == null
                  ? showMissingAccountMessage
                  : confirmDialog
              : null,
      onAccept:
          challenge.direction == ChallengeDirection.outward || !challenge.variant.isPlaySupported
              ? null
              : session == null
              ? showMissingAccountMessage
              : acceptChallenge,
      onCancel:
          challenge.direction == ChallengeDirection.outward
              ? () => ref.read(challengeRepositoryProvider).cancel(challenge.id)
              : null,
      onDecline: challenge.direction == ChallengeDirection.inward ? declineChallenge : null,
    );
  }
}
