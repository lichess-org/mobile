import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_service.dart';
import 'package:lichess_mobile/src/model/challenge/challenges.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/play/challenge_list_item.dart';
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

            return _ChallengeListItem(challenge: challenge, challengerUser: user);
          },
        );
      case _:
        return const SafeArea(child: Center(child: CircularProgressIndicator.adaptive()));
    }
  }
}

class _ChallengeListItem extends ConsumerWidget {
  const _ChallengeListItem({required this.challenge, required this.challengerUser});

  final Challenge challenge;
  final LightUser challengerUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challengeService = ref.read(challengeServiceProvider);
    return ChallengeListItem(
      challenge: challenge,
      challengerUser: challengerUser,
      onPressed: challenge.direction == ChallengeDirection.inward
          ? () => challengeService.showConfirmDialog(
              context,
              challenge,
              // TODO l10n
              title: 'Do you accept the challenge?',
            )
          : null,
      onAccept:
          challenge.direction == ChallengeDirection.outward || !challenge.variant.isPlaySupported
          ? null
          : () async => await challengeService.acceptChallenge(challenge.id),
      onCancel: challenge.direction == ChallengeDirection.outward
          ? () => ref.read(challengeRepositoryProvider).cancel(challenge.id)
          : null,
      onDecline: challenge.direction == ChallengeDirection.inward
          ? (reason) => challengeService.showDeclineDialog(context, challenge.id)
          : null,
    );
  }
}
