import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/model/relation/online_friends.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/focus_detector.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/account/rating_pref_aware.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/relation/following_screen.dart';
import 'package:lichess_mobile/src/view/user/leaderboard_widget.dart';
import 'package:lichess_mobile/src/view/user/search_screen.dart';
import 'package:lichess_mobile/src/view/user/user_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/challenge_display.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

enum _ViewMode { players, challenges }

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FocusDetector(
      onFocusRegained: () {
        ref.read(onlineFriendsProvider.notifier).startWatchingFriends();
      },
      onFocusLost: () {
        if (context.mounted) {
          ref.read(onlineFriendsProvider.notifier).stopWatchingFriends();
        }
      },
      child: PlatformWidget(
        androidBuilder: _androidBuilder,
        iosBuilder: _iosBuilder,
      ),
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return const Scaffold(
      body: _AndroidBody(),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      child: _CupertinoBody(),
    );
  }
}

class _AndroidBody extends StatefulWidget {
  const _AndroidBody();

  @override
  State<_AndroidBody> createState() => _AndriodBodyState();
}

class _AndriodBodyState extends State<_AndroidBody>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.players),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(text: context.l10n.friends),
            Tab(text: context.l10n.preferencesNotifyChallenge),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _PlayersBody(),
          _ChallengesBody(),
        ],
      ),
    );
  }
}

class _CupertinoBody extends StatefulWidget {
  const _CupertinoBody();

  @override
  _CupertinoBodyState createState() => _CupertinoBodyState();
}

class _CupertinoBodyState extends State<_CupertinoBody> {
  _ViewMode _selectedSegment = _ViewMode.players;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: Styles.bodyPadding,
            child: CupertinoSlidingSegmentedControl<_ViewMode>(
              groupValue: _selectedSegment,
              children: {
                _ViewMode.players: Text(context.l10n.players),
                _ViewMode.challenges:
                    Text(context.l10n.preferencesNotifyChallenge),
              },
              onValueChanged: (_ViewMode? view) {
                if (view != null) {
                  setState(() {
                    _selectedSegment = view;
                  });
                }
              },
            ),
          ),
          Expanded(
            child: _selectedSegment == _ViewMode.players
                ? _PlayersBody()
                : _ChallengesBody(),
          ),
        ],
      ),
    );
  }
}

class _PlayersBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);

    return SafeArea(
      child: ListView(
        children: [
          Padding(
            padding: Styles.bodySectionPadding,
            child: const _SearchButton(),
          ),
          if (session != null) _OnlineFriendsWidget(),
          RatingPrefAware(child: LeaderboardWidget()),
        ],
      ),
    );
  }
}

class _ChallengesBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challengeNotifier = ref.read(challengesProvider.notifier);
    final challenges = ref.watch(challengesProvider);
    final session = ref.watch(authSessionProvider);

    return challenges.when(
      data: (challenges) {
        final list = challenges.inward.addAll(challenges.outward);

        return ListView.separated(
          itemCount: list.length,
          separatorBuilder: (context, index) =>
              const PlatformDivider(height: 1, cupertinoHasLeading: true),
          itemBuilder: (context, index) {
            final challenge = list[index];
            final user = challenge.challenger?.user;
            if (user == null) {
              return null; // not sure why there wouldn't be a challenger
            }

            final time = challenge.days == null
                ? '∞'
                : '${context.l10n.daysPerTurn}: ${challenge.days}';
            final subtitle = challenge.rated
                ? '${context.l10n.rated} • $time'
                : '${context.l10n.casual} • $time';
            final isMyChallenge =
                challenge.direction == ChallengeDirection.outward;

            return ChallengeDisplay(
              challenge: challenge,
              user: user,
              subtitle: subtitle,
              color:
                  isMyChallenge ? LichessColors.green.withOpacity(0.2) : null,
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
                              challengeNotifier.accept(challenge.id).then((id) {
                                if (!context.mounted) return;
                                pushPlatformRoute(
                                  context,
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
              onCancel: isMyChallenge
                  ? () {
                      challengeNotifier.cancel(challenge.id);
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

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class _SearchButton extends StatelessWidget {
  const _SearchButton();

  @override
  Widget build(BuildContext context) {
    void onUserTap(LightUser user) => pushPlatformRoute(
          context,
          builder: (ctx) => UserScreen(user: user),
        );

    return PlatformWidget(
      androidBuilder: (context) => SearchBar(
        leading: const Icon(Icons.search),
        hintText: context.l10n.searchSearch,
        focusNode: AlwaysDisabledFocusNode(),
        onTap: () => pushPlatformRoute(
          context,
          fullscreenDialog: true,
          builder: (_) => SearchScreen(onUserTap: onUserTap),
        ),
      ),
      iosBuilder: (context) => CupertinoSearchTextField(
        placeholder: context.l10n.searchSearch,
        focusNode: AlwaysDisabledFocusNode(),
        onTap: () => pushPlatformRoute(
          context,
          fullscreenDialog: true,
          builder: (_) => SearchScreen(onUserTap: onUserTap),
        ),
      ),
    );
  }
}

class _OnlineFriendsWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncFriends = ref.watch(onlineFriendsProvider);

    return asyncFriends.when(
      data: (data) {
        return ListSection(
          header: Text(context.l10n.nbFriendsOnline(data.length)),
          headerTrailing: data.isEmpty
              ? null
              : NoPaddingTextButton(
                  onPressed: () => _handleTap(context, data),
                  child: Text(
                    context.l10n.more,
                  ),
                ),
          children: [
            if (data.isEmpty)
              PlatformListTile(
                title: Text(context.l10n.friends),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () => _handleTap(context, data),
              ),
            for (final user in data)
              PlatformListTile(
                title: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: UserFullNameWidget(user: user),
                ),
                onTap: () => pushPlatformRoute(
                  context,
                  title: user.name,
                  builder: (_) => UserScreen(
                    user: user,
                  ),
                ),
              ),
          ],
        );
      },
      error: (error, stackTrace) {
        debugPrint(
          'SEVERE: [PlayerScreen] could not load following online users; $error\n $stackTrace',
        );
        return const Center(
          child: Text('Could not load online friends'),
        );
      },
      loading: () => Shimmer(
        child: ShimmerLoading(
          isLoading: true,
          child: ListSection.loading(
            itemsNumber: 3,
            header: true,
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, IList<LightUser> followingOnlines) {
    pushPlatformRoute(
      context,
      title: context.l10n.friends,
      builder: (_) => const FollowingScreen(),
    );
  }
}
