import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' show ClientException;
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/exported_game.dart';
import 'package:lichess_mobile/src/model/game/game_history.dart';
import 'package:lichess_mobile/src/model/relation/relation_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/play/challenge_odd_bots_screen.dart';
import 'package:lichess_mobile/src/view/play/create_challenge_bottom_sheet.dart';
import 'package:lichess_mobile/src/view/user/perf_cards.dart';
import 'package:lichess_mobile/src/view/user/recent_games.dart';
import 'package:lichess_mobile/src/view/user/user_activity.dart';
import 'package:lichess_mobile/src/view/user/user_profile.dart';
import 'package:lichess_mobile/src/view/watch/tv_screen.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/text_badge.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';
import 'package:url_launcher/url_launcher.dart';

class UserScreen extends ConsumerStatefulWidget {
  const UserScreen({required this.user, super.key});

  final LightUser user;

  static Route<dynamic> buildRoute(BuildContext context, LightUser user) {
    return buildScreenRoute(context, screen: UserScreen(user: user));
  }

  static void challengeUser(User user, {required BuildContext context, required WidgetRef ref}) {
    final session = ref.read(authSessionProvider);
    if (session == null) {
      showSnackBar(
        context,
        context.l10n.challengeRegisterToSendChallenges,
        type: SnackBarType.error,
      );
      return;
    }
    final isOddBot = oddBots.contains(user.lightUser.name.toLowerCase());
    if (isOddBot) {
      Navigator.of(context).push(ChallengeOddBotsScreen.buildRoute(context, user.lightUser));
    } else {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) {
          return CreateChallengeBottomSheet(user.lightUser);
        },
      );
    }
  }

  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends ConsumerState<UserScreen> {
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
    final asyncUser = ref.watch(userAndStatusProvider(id: widget.user.id));
    final updatedLightUser = asyncUser.maybeWhen(
      data: (data) => data.$1.lightUser.copyWith(isOnline: data.$2.online),
      orElse: () => null,
    );
    return Scaffold(
      appBar: AppBar(
        title: UserFullNameWidget(
          user: updatedLightUser ?? widget.user,
          shouldShowOnline: updatedLightUser != null,
        ),
        actions: [if (isLoading) const PlatformAppBarLoadingIndicator()],
      ),
      body: asyncUser.when(
        data: (data) => _UserProfileListView(data.$1, isLoading, setIsLoading),
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
            onRetry: () => ref.invalidate(userProvider(id: widget.user.id)),
          );
        },
      ),
    );
  }
}

final _userActivityProvider = FutureProvider.autoDispose.family<IList<UserActivity>, UserId>(
  (ref, id) => ref.withClient((client) => UserRepository(client).getActivity(id)),
  name: 'userActivityProvider',
);

final _currentGameProvider = FutureProvider.autoDispose.family<ExportedGame, UserId>(
  (ref, id) => ref.withClient((client) => UserRepository(client).getCurrentGame(id)),
  name: 'currentGameProvider',
);

class _UserProfileListView extends ConsumerWidget {
  const _UserProfileListView(this.user, this.isLoading, this.setIsLoading);

  final User user;
  final bool isLoading;

  final void Function(bool value) setIsLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentGames = ref.watch(userRecentGamesProvider(userId: user.id));
    final activity = ref.watch(_userActivityProvider(user.id));
    final nbOfGames = ref.watch(userNumberOfGamesProvider(user.lightUser)).valueOrNull ?? 0;
    final session = ref.watch(authSessionProvider);
    final isLive = ref.watch(
      _currentGameProvider(user.id).select((game) => game.valueOrNull?.playable ?? false),
    );

    if (user.disabled == true) {
      return Center(child: Text(context.l10n.settingsThisAccountIsClosed, style: Styles.bold));
    }

    Future<void> userAction(Future<void> Function(LichessClient client) action) async {
      setIsLoading(true);
      try {
        await ref
            .withClient(action)
            .then((_) => ref.invalidate(userAndStatusProvider(id: user.id)));
      } finally {
        setIsLoading(false);
      }
    }

    return ListView(
      children: [
        UserProfileWidget(user: user),
        PerfCards(user: user, isMe: false),
        if (session != null)
          ListSection(
            hasLeading: true,
            children: [
              ListTile(
                title: Text(context.l10n.watchGames),
                leading: const Icon(Icons.live_tv_outlined),
                trailing: isLive ? const TextBadge(text: 'LIVE') : null,
                onTap: () {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).push(TvScreen.buildRoute(context, user: user.lightUser));
                },
              ),
              if (user.canChallenge == true)
                ListTile(
                  title: Text(context.l10n.challengeChallengeToPlay),
                  leading: const Icon(LichessIcons.crossed_swords),
                  onTap: () => UserScreen.challengeUser(user, context: context, ref: ref),
                ),
              if (user.followable == true && user.following != true)
                ListTile(
                  leading: const Icon(Icons.person_add),
                  title: Text(context.l10n.follow),
                  onTap: isLoading
                      ? null
                      : () => userAction((client) => RelationRepository(client).follow(user.id)),
                )
              else if (user.following == true)
                ListTile(
                  leading: const Icon(Icons.person_remove),
                  title: Text(context.l10n.unfollow),
                  onTap: isLoading
                      ? null
                      : () => userAction((client) => RelationRepository(client).unfollow(user.id)),
                ),
              if (user.following != true && user.blocking != true)
                ListTile(
                  leading: const Icon(Icons.block),
                  title: Text(context.l10n.block),
                  onTap: isLoading
                      ? null
                      : () => userAction((client) => RelationRepository(client).block(user.id)),
                )
              else if (user.blocking == true)
                ListTile(
                  leading: const Icon(Icons.block),
                  title: Text(context.l10n.unblock),
                  onTap: isLoading
                      ? null
                      : () => userAction((client) => RelationRepository(client).unblock(user.id)),
                ),
              ListTile(
                leading: const Icon(Icons.report_problem),
                title: Text(context.l10n.reportXToModerators(user.username)),
                onTap: () {
                  launchUrl(lichessUri('/report', {'username': user.id, 'login': session.user.id}));
                },
              ),
            ],
          ),
        UserActivityWidget(activity: activity),
        RecentGamesWidget(recentGames: recentGames, nbOfGames: nbOfGames, user: user.lightUser),
      ],
    );
  }
}
