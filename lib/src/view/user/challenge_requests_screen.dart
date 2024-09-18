import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/model/challenge/challenges.dart';
import 'package:lichess_mobile/src/model/notifications/local_notification_service.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/play/challenge_list_item.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

class ChallengeRequestsScreen extends StatelessWidget {
  const ChallengeRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(context.l10n.preferencesNotifyChallenge),
      ),
      body: _Body(),
    );
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

        return list.isEmpty
            ? Center(child: Text(context.l10n.nothingToSeeHere))
            : ListView.separated(
                itemCount: list.length,
                separatorBuilder: (context, index) =>
                    const PlatformDivider(height: 1, cupertinoHasLeading: true),
                itemBuilder: (context, index) {
                  final challenge = list[index];

                  // not sure why there wouldn't be a challenger
                  final user = challenge.challenger?.user;
                  if (user == null) return null;

                  return ChallengeListItem(
                    challenge: challenge,
                    user: user,
                    onAccept: challenge.direction ==
                                ChallengeDirection.outward ||
                            !challenge.variant.isPlaySupported
                        ? null
                        : session == null
                            ? () {
                                showPlatformSnackbar(
                                  context,
                                  context.l10n.youNeedAnAccountToDoThat,
                                );
                              }
                            : () {
                                showConfirmDialog<void>(
                                  context,
                                  title: Text(context.l10n.accept),
                                  isDestructiveAction: true,
                                  onConfirm: (_) async {
                                    final challengeRepo =
                                        ref.read(challengeRepositoryProvider);
                                    await challengeRepo.accept(challenge.id);
                                    final fullId = await challengeRepo
                                        .show(challenge.id)
                                        .then(
                                          (challenge) => challenge.gameFullId,
                                        );
                                    pushPlatformRoute(
                                      ref
                                          .read(currentNavigatorKeyProvider)
                                          .currentContext!,
                                      rootNavigator: true,
                                      builder: (BuildContext context) {
                                        return GameScreen(
                                          initialGameId: fullId,
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                    onCancel: challenge.direction == ChallengeDirection.outward
                        ? () => ref
                            .read(challengeRepositoryProvider)
                            .cancel(challenge.id)
                        : null,
                    onDecline: challenge.direction == ChallengeDirection.inward
                        ? (ChallengeDeclineReason reason) {
                            ref
                                .read(challengeRepositoryProvider)
                                .decline(challenge.id, reason: reason);
                            LocalNotificationService.instance
                                .cancel(challenge.id.value.hashCode);
                          }
                        : null,
                  );
                },
              );
      },
      loading: () {
        return const Center(child: CircularProgressIndicator.adaptive());
      },
      error: (error, stack) =>
          const Center(child: Text('Error loading challenges')),
    );
  }
}
