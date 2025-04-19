import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/account/rating_pref_aware.dart';
import 'package:lichess_mobile/src/view/play/challenge_odd_bots_screen.dart';
import 'package:lichess_mobile/src/view/play/create_challenge_screen.dart';
import 'package:lichess_mobile/src/view/user/user_context_menu.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

class OnlineBotsScreen extends StatelessWidget {
  const OnlineBotsScreen();

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const OnlineBotsScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(context.l10n.onlineBots)), body: _Body());
  }
}

class OnlineBotsWidget extends ConsumerWidget {
  const OnlineBotsWidget({required this.onlineBots, super.key});

  final AsyncValue<IList<User>> onlineBots;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (onlineBots) {
      case AsyncData(:final value):
        if (value.isEmpty) {
          return const SizedBox.shrink();
        }
        return ListSection(
          header: Text(context.l10n.onlineBots),
          headerTrailing: NoPaddingTextButton(
            onPressed: () {
              Navigator.of(context).push(OnlineBotsScreen.buildRoute(context));
            },
            child: Text(context.l10n.more),
          ),
          children: [
            for (final bot in value.where((bot) => bot.verified == true))
              ListTile(
                title: UserFullNameWidget(user: bot.lightUser),
                subtitle: (bot.perfs[Perf.blitz]?.games ?? 0) > 0 ? _BotRatings(bot: bot) : null,
                onTap: () => _challengeBot(bot, context: context, ref: ref),
                onLongPress: () {
                  showAdaptiveBottomSheet<void>(
                    context: context,
                    useRootNavigator: true,
                    isDismissible: true,
                    isScrollControlled: true,
                    showDragHandle: true,
                    builder: (context) => UserContextMenu(user: bot),
                  );
                },
              ),
          ],
        );
      case AsyncError(:final error):
        return Padding(
          padding: Styles.bodySectionPadding,
          child: Text('Could not load online bots: $error'),
        );
      case _:
        return const Center(child: CircularProgressIndicator.adaptive());
    }
  }
}

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onlineBots = ref.watch(onlineBotsProvider);

    return onlineBots.when(
      data:
          (data) => ListView.separated(
            itemCount: data.length,
            separatorBuilder:
                (context, index) =>
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? const PlatformDivider()
                        : const SizedBox.shrink(),
            itemBuilder: (context, index) {
              final bot = data[index];
              return ListTile(
                isThreeLine: true,
                trailing:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (bot.verified == true) ...[
                              const Icon(Icons.verified_outlined),
                              const SizedBox(width: 5),
                            ],
                            const Icon(Icons.chevron_right),
                          ],
                        )
                        : bot.verified == true
                        ? const Icon(Icons.verified_outlined)
                        : null,
                title: UserFullNameWidget(
                  user: bot.lightUser,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _BotRatings(bot: bot),
                    Text(bot.profile?.bio ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
                onTap: () {
                  _challengeBot(bot, context: context, ref: ref);
                },
                onLongPress: () {
                  showAdaptiveBottomSheet<void>(
                    context: context,
                    useRootNavigator: true,
                    isDismissible: true,
                    isScrollControlled: true,
                    showDragHandle: true,
                    builder: (context) => UserContextMenu(user: bot),
                  );
                },
              );
            },
          ),
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, s) {
        debugPrint('Could not load bots: $e');
        return FullScreenRetryRequest(onRetry: () => ref.refresh(onlineBotsProvider));
      },
    );
  }
}

void _challengeBot(User bot, {required BuildContext context, required WidgetRef ref}) {
  final session = ref.read(authSessionProvider);
  if (session == null) {
    showSnackBar(context, context.l10n.challengeRegisterToSendChallenges, type: SnackBarType.error);
    return;
  }
  final isOddBot = oddBots.contains(bot.lightUser.name.toLowerCase());
  Navigator.of(context).push(
    isOddBot
        ? ChallengeOddBotsScreen.buildRoute(context, bot.lightUser)
        : CreateChallengeScreen.buildRoute(context, bot.lightUser),
  );
}

class _BotRatings extends StatelessWidget {
  const _BotRatings({required this.bot});

  final User bot;

  @override
  Widget build(BuildContext context) {
    return RatingPrefAware(
      orElse: const SizedBox.shrink(),
      child: Row(
        children:
            [Perf.blitz, Perf.rapid, Perf.classical].map((perf) {
              final rating = bot.perfs[perf]?.rating;
              final nbGames = bot.perfs[perf]?.games ?? 0;
              return Padding(
                padding: const EdgeInsets.only(right: 16.0, top: 4.0, bottom: 4.0),
                child: Row(
                  children: [
                    Icon(perf.icon, size: 16),
                    const SizedBox(width: 4.0),
                    if (rating != null && nbGames > 0)
                      Text(
                        '$rating',
                        style: TextStyle(color: textShade(context, Styles.subtitleOpacity)),
                      )
                    else
                      const Text('  -  '),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }
}
