import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' show ClientException;
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_filter.dart';
import 'package:lichess_mobile/src/model/relation/relation_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/message/conversation_screen.dart';
import 'package:lichess_mobile/src/view/play/challenge_odd_bots_screen.dart';
import 'package:lichess_mobile/src/view/play/create_challenge_bottom_sheet.dart';
import 'package:lichess_mobile/src/view/user/game_history_screen.dart';
import 'package:lichess_mobile/src/view/user/perf_cards.dart';
import 'package:lichess_mobile/src/view/user/recent_games.dart';
import 'package:lichess_mobile/src/view/user/user_activity.dart';
import 'package:lichess_mobile/src/view/user/user_profile.dart';
import 'package:lichess_mobile/src/view/user/user_stats_section.dart';
import 'package:lichess_mobile/src/view/watch/tv_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/haptic_refresh_indicator.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

final _userScreenDataProvider = FutureProvider.autoDispose.family<UserScreenData, UserId>(
  (ref, id) => ref.read(userRepositoryProvider).getUserScreenData(id),
  name: 'UserScreenDataProvider',
);

class const UserScreen({required final LightUser user, super.key}) extends ConsumerStatefulWidget {
  static Route<dynamic> buildRoute(LightUser user) {
    return buildScreenRoute(screen: UserScreen(user: user));
  }

  static void challengeUser(
    LightUser user, {
    required BuildContext context,
    required WidgetRef ref,
  }) {
    final authUser = ref.read(authControllerProvider);
    if (authUser == null) {
      showSnackBar(
        context,
        context.l10n.challengeRegisterToSendChallenges,
        type: SnackBarType.error,
      );
      return;
    }
    final isOddBot = oddBots.contains(user.name.toLowerCase());
    if (isOddBot) {
      Navigator.of(context).push(ChallengeOddBotsScreen.buildRoute(user));
    } else {
      showAdaptiveBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (_) => CreateChallengeBottomSheet(user: user, navigator: Navigator.of(context)),
      );
    }
  }

  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState() extends ConsumerState<UserScreen> {
  bool isLoading = false;

  void setIsLoading(bool value) {
    if (mounted) {
      setState(() {
        isLoading = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userScreenData = ref.watch(_userScreenDataProvider(widget.user.id));
    final updatedLightUser = userScreenData.maybeWhen(
      data: (data) => data.user.lightUser.copyWith(isOnline: data.isOnline),
      orElse: () => null,
    );
    final seenAt = userScreenData.maybeWhen(data: (data) => data.user.seenAt, orElse: () => null);
    return PlatformScaffold(
      appBar: PlatformAppBar(
        centerTitle: false, // user name can be long
        titleSpacing: 0,
        title: UserAppBarTitleWidget(
          user: updatedLightUser ?? widget.user,
          isOnline: updatedLightUser?.isOnline == true,
          seenAt: seenAt,
        ),
        actions: [
          if (isLoading) const PlatformAppBarLoadingIndicator(),
          SemanticIconButton(
            icon: const PlatformShareIcon(),
            semanticsLabel: 'Share profile',
            onPressed: () =>
                launchShareDialog(context, ShareParams(uri: lichessUri('/@/${widget.user.name}'))),
          ),
        ],
      ),
      body: userScreenData.when(
        data: (data) => _UserProfileListView(
          data,
          isLoading,
          setIsLoading,
          onRefresh: () => ref.refresh(_userScreenDataProvider(widget.user.id).future),
        ),
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) {
          if (error is ClientException && error.message.contains('404')) {
            return Center(
              child: Text(
                textAlign: TextAlign.center,
                context.l10n.usernameNotFound(widget.user.name),
                style: Styles.bold,
              ),
            );
          }
          return FullScreenRetryRequest(
            onRetry: () => ref.invalidate(_userScreenDataProvider(widget.user.id)),
          );
        },
      ),
    );
  }
}

class const _UserProfileListView(
  final UserScreenData data,
  final bool isLoading,
  final void Function(bool value) setIsLoading, {
  required final RefreshCallback onRefresh,
}) extends ConsumerWidget {
  String _scoreDisplay(double score) {
    final integerPart = score.truncate();
    final decimalPart = score - integerPart;

    return integerPart == 0 && decimalPart == 0.5
        ? '½'
        : '$integerPart${decimalPart == 0.5 ? '½' : ''}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserScreenData(:user, :recentGames, :activity, :isPlayingLive, :crosstable) = data;

    final isOnline = ref.watch(isDeviceOnlineProvider);
    final nbOfGames = user.count?.all ?? 0;
    final authUser = ref.watch(authControllerProvider);
    final kidMode = ref.watch(kidModeProvider);

    if (user.disabled == true) {
      return Center(child: Text(context.l10n.settingsThisAccountIsClosed, style: Styles.bold));
    }

    Future<void> userAction(Future<void> Function() action) async {
      setIsLoading(true);
      try {
        await action.call().then((_) => ref.invalidate(_userScreenDataProvider(user.id)));
      } finally {
        setIsLoading(false);
      }
    }

    return HapticRefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        children: [
          UserProfileWidget(user: user),
          Card(
            margin: Styles.horizontalBodyPadding.add(Styles.sectionTopPadding),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
                  child: Row(
                    crossAxisAlignment: .start,
                    children: [
                      Expanded(
                        child: _UserActionButton(
                          icon: Icons.live_tv_outlined,
                          label: context.l10n.watch,
                          isLive: isPlayingLive == true,
                          onPressed: () {
                            Navigator.of(context)
                                .pushHidingTabBar(TvScreen.buildRoute(user: user.lightUser));
                          },
                        ),
                      ),
                      if (authUser != null) ...[
                        if (user.canChallenge != null)
                          Expanded(
                            child: _UserActionButton(
                              icon: LichessIcons.crossed_swords,
                              label: context.l10n.challengeChallengeToPlay,
                              onPressed: user.canChallenge == true
                                  ? () => UserScreen.challengeUser(
                                      user.lightUser,
                                      context: context,
                                      ref: ref,
                                    )
                                  : () => showSnackBar(
                                      context,
                                      context.l10n.challengeXDoesNotAcceptChallenges(user.username),
                                    ),
                            ),
                          ),
                        if (user.blocking != true && !user.isBot && kidMode.value == false)
                          Expanded(
                            child: _UserActionButton(
                              icon: Icons.chat_bubble_outline,
                              label: context.l10n.composeMessage,
                              onPressed: () {
                                Navigator.of(context).pushHidingTabBar(
                                  ConversationScreen.buildRoute(
                                    user: user.lightUser.copyWith(isOnline: data.isOnline),
                                  ),
                                );
                              },
                            ),
                          ),
                        if (user.followable == true && user.following != true)
                          Expanded(
                            child: _UserActionButton(
                              icon: Icons.person_add_outlined,
                              label: context.l10n.follow,
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      await userAction(
                                        () => ref.read(relationRepositoryProvider).follow(user.id),
                                      );
                                      ref.invalidate(followingProvider);
                                    },
                            ),
                          )
                        else if (user.following == true)
                          Expanded(
                            child: _UserActionButton(
                              icon: Icons.person_remove_outlined,
                              label: context.l10n.unfollow,
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      await userAction(
                                        () =>
                                            ref.read(relationRepositoryProvider).unfollow(user.id),
                                      );
                                      ref.invalidate(followingProvider);
                                    },
                            ),
                          ),
                        Expanded(
                          child: ContextMenuButton(
                            semanticsLabel: context.l10n.more,
                            consumeOutsideTap: true,
                            actions: [
                              if (user.following != true && user.blocking != true)
                                ContextMenuAction(
                                  icon: Icons.block_outlined,
                                  label: context.l10n.block,
                                  onPressed: isLoading
                                      ? null
                                      : () => userAction(
                                          () => ref.read(relationRepositoryProvider).block(user.id),
                                        ),
                                )
                              else if (user.blocking == true)
                                ContextMenuAction(
                                  icon: Icons.block_outlined,
                                  label: context.l10n.unblock,
                                  onPressed: isLoading
                                      ? null
                                      : () => userAction(
                                          () =>
                                              ref.read(relationRepositoryProvider).unblock(user.id),
                                        ),
                                ),
                              ContextMenuAction(
                                icon: Icons.report_problem_outlined,
                                label: context.l10n.reportXToModerators(user.username),
                                onPressed: () {
                                  launchUrl(
                                    lichessUri('/report', {
                                      'username': user.id,
                                      'login': authUser.user.id,
                                    }),
                                  );
                                },
                              ),
                            ],
                            builder: (context, onPressed) => _UserActionButton(
                              icon: Icons.more_horiz,
                              label: context.l10n.more,
                              onPressed: onPressed,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (authUser != null && crosstable != null && crosstable.nbGames > 0) ...[
                  const PlatformDivider(height: 1),
                  ListTile(
                    title: Text(
                      context.l10n.yourScore(
                        '${_scoreDisplay(crosstable.users[authUser.user.id] ?? 0)} - '
                        '${_scoreDisplay(crosstable.users[user.id] ?? 0)}',
                      ),
                    ),
                    leading: const Icon(Icons.scoreboard_outlined),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        GameHistoryScreen.buildRoute(
                          user: authUser.user,
                          isOnline: isOnline,
                          gameFilter: GameFilterState(opponent: user),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
          PerfCards(user: user, isMe: false),
          UserStatsSection(user: user, isMe: false),
          UserActivityWidget(activity: AsyncData(activity), user: user.lightUser),
          RecentGamesWidget(
            recentGames: AsyncData(recentGames),
            nbOfGames: nbOfGames,
            user: user.lightUser,
          ),
        ],
      ),
    );
  }
}

/// An action of the user screen: an icon in a tinted circle, above its label.
class const _UserActionButton({
  required final IconData icon,
  required final String label,
  required final VoidCallback? onPressed,
  final bool isLive = false,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final enabled = onPressed != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onPressed,
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 2.0),
          child: Column(
            spacing: 6.0,
            children: [
              Badge(
                isLabelVisible: isLive,
                label: const Text('LIVE'),
                backgroundColor: LichessColors.red,
                offset: const Offset(-4, -4),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer.withValues(alpha: enabled ? 1 : 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(
                      icon,
                      size: 22.0,
                      color: colorScheme.onSecondaryContainer.withValues(alpha: enabled ? 1 : 0.5),
                    ),
                  ),
                ),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 12.0),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
