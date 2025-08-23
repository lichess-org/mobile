import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_service.dart';
import 'package:lichess_mobile/src/model/challenge/challenges.dart';
import 'package:lichess_mobile/src/model/lobby/create_game_service.dart';
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
  const ChallengeRequestsScreen({required this.incomingChallenge, super.key});

  final Challenge? incomingChallenge;

  static Route<dynamic> buildRoute(BuildContext context, {Challenge? incomingChallenge}) {
    return buildScreenRoute(
      context,
      screen: ChallengeRequestsScreen(incomingChallenge: incomingChallenge),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.preferencesNotifyChallenge)),
      body: _Body(incomingChallenge: incomingChallenge),
    );
  }
}

void _showConfirmDialog(WidgetRef ref, BuildContext context, Challenge challenge) {
  showAdaptiveActionSheet<void>(
    context: context,
    title: challenge.variant.isPlaySupported ? const Text('Do you accept the challenge?') : null,
    actions: [
      if (challenge.variant.isPlaySupported)
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.accept),
          leading: Icon(Icons.check, color: context.lichessColors.good),
          isDefaultAction: true,
          onPressed: () => _acceptChallenge(ref, context, challenge),
        ),
      BottomSheetAction(
        makeLabel: (context) => Text(context.l10n.decline),
        leading: Icon(Icons.clear, color: context.lichessColors.error),
        isDestructiveAction: true,
        onPressed: () => _showDeclineDialog(ref, context, challenge),
      ),
    ],
  );
}

Future<void> _declineChallenge(
  WidgetRef ref,
  Challenge challenge,
  ChallengeDeclineReason? reason,
) async {
  ref.read(challengeRepositoryProvider).decline(challenge.id, reason: reason);
  ref.read(notificationServiceProvider).cancel(challenge.id.value.hashCode);
}

void _showDeclineDialog(WidgetRef ref, BuildContext context, Challenge challenge) {
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
              _declineChallenge(ref, challenge, reason);
            },
          ),
        )
        .toList(),
  );
}

Future<void> _acceptChallenge(WidgetRef ref, BuildContext context, Challenge challenge) async {
  // Cancel any pending lobby seek before accepting, to prevent being matched into a new game
  // while accepting a challenge.
  try {
    await ref.read(createGameServiceProvider).cancelSeek();
  } catch (_) {}
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

class _Body extends ConsumerStatefulWidget {
  const _Body({required this.incomingChallenge});

  final Challenge? incomingChallenge;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  @override
  void initState() {
    super.initState();
    if (widget.incomingChallenge != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Correspondence games are currently not supported when not logged in,
        // so only allow real time challenges.
        if (widget.incomingChallenge!.timeControl == ChallengeTimeControlType.clock) {
          _showConfirmDialog(ref, context, widget.incomingChallenge!);
        } else {
          showSnackBar(context, context.l10n.youNeedAnAccountToDoThat);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final challengesAsync = ref.watch(challengesProvider);
    final authUser = ref.watch(authControllerProvider);

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

            return _ChallengeListItem(
              challenge: challenge,
              challengerUser: user,
              authUser: authUser,
            );
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
    required this.authUser,
  });

  final Challenge challenge;
  final LightUser challengerUser;
  final AuthUser? authUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ChallengeListItem(
      challenge: challenge,
      challengerUser: challengerUser,
      onPressed: challenge.direction == ChallengeDirection.inward
          ? () => _showConfirmDialog(ref, context, challenge)
          : null,
      onAccept:
          // TODO if outward challenge, can we press it to take us to the game screen?
          challenge.direction == ChallengeDirection.outward || !challenge.variant.isPlaySupported
          ? null
          : () => _acceptChallenge(ref, context, challenge),
      onCancel: challenge.direction == ChallengeDirection.outward
          ? () => ref.read(challengeRepositoryProvider).cancel(challenge.id)
          : null,
      onDecline: challenge.direction == ChallengeDirection.inward
          ? (reason) => _declineChallenge(ref, challenge, reason)
          : null,
    );
  }
}
