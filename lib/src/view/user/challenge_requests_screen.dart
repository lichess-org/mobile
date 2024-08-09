import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/challenge_display.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class ChallengeRequestsScreen extends ConsumerWidget {
  const ChallengeRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.preferencesNotifyChallenge),
      ),
      body: _Body(),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challengeNotifier = ref.read(challengesProvider.notifier);
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

                  final time = challenge.days == null
                      ? '∞'
                      : '${context.l10n.daysPerTurn}: ${challenge.days}';
                  final subtitle = challenge.rated
                      ? '${context.l10n.rated} • $time'
                      : '${context.l10n.casual} • $time';
                  final isMyChallenge =
                      challenge.direction == ChallengeDirection.outward;

                  return ChallengeListItem(
                    challenge: challenge,
                    user: user,
                    subtitle: subtitle,
                    color: isMyChallenge
                        ? LichessColors.green.withOpacity(0.2)
                        : null,
                    onPressed: isMyChallenge
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
                                  onConfirm: (_) {
                                    challengeNotifier
                                        .accept(challenge.id)
                                        .then((id) {
                                      pushPlatformRoute(
                                        ref
                                            .read(currentNavigatorKeyProvider)
                                            .currentContext!,
                                        rootNavigator: true,
                                        builder: (BuildContext context) {
                                          return GameScreen(
                                            initialGameId: id,
                                          );
                                        },
                                      );
                                    });
                                  },
                                );
                              },
                    cancelText: !isMyChallenge ? context.l10n.decline : null,
                    onCancel: isMyChallenge
                        ? () {
                            challengeNotifier.cancel(challenge.id);
                          }
                        : () {
                            ref
                                .read(challengeRepositoryProvider)
                                .decline(challenge.id);
                          },
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
