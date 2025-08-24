import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_service.dart';
import 'package:lichess_mobile/src/model/challenge/challenges.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen_providers.dart';
import 'package:lichess_mobile/src/view/play/challenge_list_item.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';

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

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challengesAsync = ref.watch(challengesProvider);
    final session = ref.watch(authSessionProvider);

    switch (challengesAsync) {
      case AsyncError():
        return const SafeArea(child: Center(child: Text('Error loading challenges.')));
      case AsyncData(value: final challenges):
        final list = challenges.inward.addAll(challenges.outward);

        if (list.isEmpty) {
          return SafeArea(
            child: Center(child: Text(context.l10n.noChallenges, style: Styles.noResultTextStyle)),
          );
        }

        return ListView.separated(
          itemCount: list.length,
          separatorBuilder: (context, index) =>
              const PlatformDivider(height: 1, cupertinoHasLeading: true),
          itemBuilder: (context, index) {
            final challenge = list[index];
            final user = challenge.challenger?.user;

            if (user == null) return null;

            return _ChallengeListItem(challenge: challenge, challengerUser: user, session: session);
          },
        );
      case _:
        return const SafeArea(child: Center(child: CircularProgressIndicator.adaptive()));
    }
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
      final fullId = await ref.read(challengeServiceProvider).acceptChallenge(challenge.id);
      if (!context.mounted) return;
      if (fullId == null) {
        return showSnackBar(context, 'Failed to accept challenge', type: SnackBarType.error);
      }
      Navigator.of(
        context,
        rootNavigator: true,
      ).push(GameScreen.buildRoute(context, source: ExistingGameSource(fullId)));
    }

    Future<void> declineChallenge(ChallengeDeclineReason? reason) async {
      ref.read(challengeRepositoryProvider).decline(challenge.id, reason: reason);
      ref.read(notificationServiceProvider).cancel(challenge.id.value.hashCode);
    }

    void showDeclineDialog() {
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
                  declineChallenge(reason);
                },
              ),
            )
            .toList(),
      );
    }

    void showConfirmDialog() {
      showAdaptiveActionSheet<void>(
        context: context,
        title: challenge.variant.isPlaySupported
            ? const Text('Do you accept the challenge?')
            : null,
        actions: [
          if (challenge.variant.isPlaySupported)
            BottomSheetAction(
              makeLabel: (context) => Text(context.l10n.accept),
              leading: Icon(Icons.check, color: context.lichessColors.good),
              isDefaultAction: true,
              onPressed: acceptChallenge,
            ),
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.decline),
            leading: Icon(Icons.clear, color: context.lichessColors.error),
            isDestructiveAction: true,
            onPressed: showDeclineDialog,
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
      onPressed: challenge.direction == ChallengeDirection.inward
          ? session == null
                ? showMissingAccountMessage
                : showConfirmDialog
          : null,
      onAccept:
          challenge.direction == ChallengeDirection.outward || !challenge.variant.isPlaySupported
          ? null
          : session == null
          ? showMissingAccountMessage
          : acceptChallenge,
      onCancel: challenge.direction == ChallengeDirection.outward
          ? () => ref.read(challengeRepositoryProvider).cancel(challenge.id)
          : null,
      onDecline: challenge.direction == ChallengeDirection.inward ? declineChallenge : null,
    );
  }
}
