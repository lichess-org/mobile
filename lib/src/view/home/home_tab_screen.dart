import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_game_storage.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/connectivity.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/layout.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/account/profile_screen.dart';
import 'package:lichess_mobile/src/view/account/rating_pref_aware.dart';
import 'package:lichess_mobile/src/view/auth/sign_in_widget.dart';
import 'package:lichess_mobile/src/view/game/lobby_screen.dart';
import 'package:lichess_mobile/src/view/home/search_screen.dart';
import 'package:lichess_mobile/src/view/play/create_correspondence_game_screen.dart';
import 'package:lichess_mobile/src/view/play/create_custom_game_screen.dart';
import 'package:lichess_mobile/src/view/play/offline_correspondence_games_screen.dart';
import 'package:lichess_mobile/src/view/play/ongoing_games_screen.dart';
import 'package:lichess_mobile/src/view/play/time_control_modal.dart';
import 'package:lichess_mobile/src/view/relation/relation_screen.dart';
import 'package:lichess_mobile/src/view/settings/settings_screen.dart';
import 'package:lichess_mobile/src/view/user/leaderboard_widget.dart';
import 'package:lichess_mobile/src/view/user/recent_games.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

class HomeTabScreen extends ConsumerStatefulWidget {
  const HomeTabScreen({super.key});

  @override
  ConsumerState<HomeTabScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeTabScreen> {
  final _androidRefreshKey = GlobalKey<RefreshIndicatorState>();

  bool wasOnline = true;
  bool hasRefreshed = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(connectivityChangesProvider, (_, connectivity) {
      // Refresh the data only once if it was offline and is now online
      if (!connectivity.isRefreshing && connectivity.hasValue) {
        final isNowOnline = connectivity.value!.isOnline;

        if (!hasRefreshed && !wasOnline && isNowOnline) {
          hasRefreshed = true;
          _refreshData();
        }

        wasOnline = isNowOnline;
      }
    });

    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    final session = ref.watch(authSessionProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('lichess.org'),
        leading: session == null
            ? null
            : IconButton(
                icon: const Icon(Icons.person),
                tooltip: context.l10n.profile,
                onPressed: () {
                  ref.invalidate(accountProvider);
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
              ),
        actions: [
          const _SearchButton(),
          const _SettingsButton(),
          if (session != null)
            const _RelationButton()
          else
            const SignInWidget(),
        ],
      ),
      body: RefreshIndicator(
        key: _androidRefreshKey,
        onRefresh: () => _refreshData(),
        child: const _HomeBody(),
      ),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    final session = ref.watch(authSessionProvider);
    return CupertinoPageScaffold(
      child: CustomScrollView(
        controller: homeScrollController,
        slivers: [
          CupertinoSliverNavigationBar(
            padding: EdgeInsetsDirectional.only(
              start: session == null ? 16.0 : 8.0,
              end: 8.0,
            ),
            leading: session == null
                ? const SignInWidget()
                : AppBarIconButton(
                    semanticsLabel: context.l10n.profile,
                    onPressed: () {
                      ref.invalidate(accountProvider);
                      Navigator.of(context).push(
                        CupertinoPageRoute<void>(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                    icon: const Icon(CupertinoIcons.profile_circled),
                  ),
            largeTitle: Text(context.l10n.play),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _SearchButton(),
                const _SettingsButton(),
                if (session != null) const _RelationButton(),
              ],
            ),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () => _refreshData(),
          ),
          const SliverToBoxAdapter(child: _ConnectivityBanner()),
          const SliverSafeArea(
            top: false,
            sliver: _HomeBody(),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshData() {
    return Future.wait([
      ref.refresh(accountRecentGamesProvider.future),
      ref.refresh(ongoingGamesProvider.future),
    ]);
  }
}

class _HomeBody extends ConsumerWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityChangesProvider);
    return connectivity.when(
      data: (data) {
        final isTablet = getScreenType(context) == ScreenType.tablet;
        if (data.isOnline) {
          final onlineWidgets = _onlineWidgets(isTablet);

          return Theme.of(context).platform == TargetPlatform.android
              ? ListView(
                  controller: homeScrollController,
                  children: onlineWidgets,
                )
              : SliverList(
                  delegate: SliverChildListDelegate(onlineWidgets),
                );
        } else {
          final offlineWidgets = _offlineWidgets(isTablet);
          return Theme.of(context).platform == TargetPlatform.android
              ? ListView(
                  controller: homeScrollController,
                  children: offlineWidgets,
                )
              : SliverList(
                  delegate: SliverChildListDelegate.fixed(offlineWidgets),
                );
        }
      },
      loading: () {
        const child = CenterLoadingIndicator();
        return Theme.of(context).platform == TargetPlatform.android
            ? child
            : const SliverFillRemaining(child: child);
      },
      error: (error, stack) {
        const child = SizedBox.shrink();
        return Theme.of(context).platform == TargetPlatform.android
            ? child
            : const SliverFillRemaining(child: child);
      },
    );
  }

  List<Widget> _onlineWidgets(bool isTablet) {
    if (isTablet) {
      return [
        const _HelloWidget(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Column(
                children: [
                  SizedBox(height: 8.0),
                  _CreateAGameSection(isExpanded: true),
                  _OngoingGamesPreview(maxGamesToShow: 4),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),
                  const RecentGames(),
                  RatingPrefAware(child: LeaderboardWidget()),
                ],
              ),
            ),
          ],
        ),
      ];
    } else {
      return [
        const SizedBox(height: 8.0),
        const _HelloWidget(),
        const _CreateAGameSection(isExpanded: false),
        const _OngoingGamesPreview(maxGamesToShow: 1),
        const RecentGames(),
        RatingPrefAware(child: LeaderboardWidget()),
      ];
    }
  }

  List<Widget> _offlineWidgets(bool isTablet) {
    if (isTablet) {
      return const [
        _HelloWidget(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 8.0),
                  _OfflineCorrespondencePreview(maxGamesToShow: 4),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 8.0),
                ],
              ),
            ),
          ],
        ),
      ];
    } else {
      return const [
        SizedBox(height: 8.0),
        _HelloWidget(),
        _OfflineCorrespondencePreview(maxGamesToShow: 2),
      ];
    }
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton();

  @override
  Widget build(BuildContext context) {
    return AppBarIconButton(
      icon: const Icon(Icons.search),
      semanticsLabel: 'Search Lichess',
      onPressed: () {
        pushPlatformRoute(
          context,
          fullscreenDialog: true,
          builder: (_) => const SearchScreen(),
        );
      },
    );
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton();

  @override
  Widget build(BuildContext context) {
    return SettingsButton(
      onPressed: () => pushPlatformRoute(
        context,
        title: context.l10n.settingsSettings,
        builder: (_) => const SettingsScreen(),
      ),
    );
  }
}

class _HelloWidget extends ConsumerWidget {
  const _HelloWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    const style = TextStyle(fontSize: 22);

    // fetch the account user to be sure we have the latest data (flair, etc.)
    final accountUser = ref.watch(accountProvider).maybeWhen(
          data: (data) => data?.lightUser,
          orElse: () => null,
        );

    return session != null
        ? Padding(
            padding: Styles.bodyPadding.add(const EdgeInsets.only(top: 8.0)),
            child: Row(
              children: [
                const Icon(Icons.wb_sunny, size: 28, color: LichessColors.brag),
                const SizedBox(width: 5.0),
                const Text(
                  'Hello, ',
                  style: style,
                ),
                UserFullNameWidget(
                  user: accountUser ?? session.user,
                  style: style,
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}

class _ConnectivityBanner extends ConsumerWidget {
  const _ConnectivityBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityChangesProvider);
    final themeData = CupertinoTheme.of(context);
    return connectivity.when(
      data: (data) {
        if (data.isOnline) {
          return const SizedBox.shrink();
        }
        return Container(
          height: 45,
          color: themeData.barBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.report, color: themeData.textTheme.textStyle.color),
                const SizedBox(width: 5),
                const Flexible(
                  child: Text(
                    'Network connectivity unavailable.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}

class _CreateAGameSection extends ConsumerWidget {
  const _CreateAGameSection({this.isExpanded = false});

  final bool isExpanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expansionTileColor = Styles.expansionTileColor(context);

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: Styles.horizontalBodyPadding,
            child: Text(context.l10n.createAGame, style: Styles.sectionTitle),
          ),
          const _QuickGameButton(),
          if (isExpanded) ...const [
            SizedBox(height: 16.0),
            _CustomGameButton(),
            _CorrespondenceGameButton(),
          ] else
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text(
                  context.l10n.more,
                ),
                tilePadding: Styles.horizontalBodyPadding,
                iconColor: expansionTileColor,
                collapsedIconColor: expansionTileColor,
                textColor: expansionTileColor,
                collapsedTextColor: expansionTileColor,
                controlAffinity: ListTileControlAffinity.leading,
                children: const [
                  _CustomGameButton(),
                  _CorrespondenceGameButton(),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CustomGameButton extends StatelessWidget {
  const _CustomGameButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.bodySectionBottomPadding,
      child: CardButton(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.tune,
              size: 28,
            ),
            const SizedBox(width: 8.0),
            Text(context.l10n.custom, style: Styles.callout),
          ],
        ),
        onTap: () {
          pushPlatformRoute(
            context,
            title: context.l10n.custom,
            builder: (_) => const CreateCustomGameScreen(),
          );
        },
      ),
    );
  }
}

class _CorrespondenceGameButton extends StatelessWidget {
  const _CorrespondenceGameButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.bodySectionBottomPadding,
      child: CardButton(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              LichessIcons.correspondence,
              size: 28,
            ),
            const SizedBox(width: 8.0),
            Text(
              context.l10n.correspondence,
              style: Styles.callout,
            ),
          ],
        ),
        onTap: () {
          pushPlatformRoute(
            context,
            title: context.l10n.correspondence,
            builder: (_) => const CreateCorrespondenceGameScreen(),
          );
        },
      ),
    );
  }
}

class _QuickGameButton extends ConsumerWidget {
  const _QuickGameButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playPrefs = ref.watch(gameSetupPreferencesProvider);
    final session = ref.watch(authSessionProvider);
    const buttonHeight = 55.0;

    final timeControl = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              playPrefs.timeIncrement.speed.icon,
              size: 28,
            ),
            const SizedBox(width: 6.0),
            Text(
              playPrefs.timeIncrement.display,
              style: Styles.timeControl.copyWith(fontSize: 16),
            ),
          ],
        ),
        const Icon(Icons.keyboard_arrow_down, size: 28.0),
      ],
    );

    return Padding(
      padding:
          Styles.horizontalBodyPadding.add(const EdgeInsets.only(top: 6.0)),
      child: PlatformCard(
        elevation:
            Theme.of(context).platform == TargetPlatform.iOS ? 0.2 : null,
        child: Row(
          children: [
            SizedBox(
              width: 162.0,
              height: buttonHeight,
              child: AdaptiveInkWell(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                child: Center(child: timeControl),
                onTap: () {
                  final double screenHeight = MediaQuery.sizeOf(context).height;
                  showAdaptiveBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    showDragHandle: true,
                    constraints: BoxConstraints(
                      maxHeight: screenHeight - (screenHeight / 10),
                    ),
                    builder: (BuildContext context) {
                      return TimeControlModal(
                        value: playPrefs.timeIncrement,
                        onSelected: (choice) {
                          ref
                              .read(gameSetupPreferencesProvider.notifier)
                              .setTimeControl(choice);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: SizedBox(
                height: buttonHeight,
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoButton.filled(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                        ),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        onPressed: () {
                          pushPlatformRoute(
                            context,
                            rootNavigator: true,
                            builder: (_) => LobbyScreen(
                              seek: GameSeek.fastPairing(playPrefs, session),
                            ),
                          );
                        },
                        child: Text(
                          context.l10n.studyStart,
                          style: Styles.bold,
                        ),
                      )
                    : FilledButtonTheme(
                        data: FilledButtonThemeData(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                        child: FilledButton(
                          onPressed: () {
                            pushPlatformRoute(
                              context,
                              rootNavigator: true,
                              builder: (_) => LobbyScreen(
                                seek: GameSeek.fastPairing(playPrefs, session),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              context.l10n.studyStart,
                              style: Styles.callout,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OngoingGamesPreview extends ConsumerWidget {
  const _OngoingGamesPreview({required this.maxGamesToShow});

  final int maxGamesToShow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ongoingGames = ref.watch(ongoingGamesProvider);
    return ongoingGames.maybeWhen(
      data: (data) {
        return _GamePreview(
          list: data,
          maxGamesToShow: maxGamesToShow,
          builder: (el) => OngoingGamePreview(game: el),
          moreScreenBuilder: (_) => const OngoingGamesScreen(),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _OfflineCorrespondencePreview extends ConsumerWidget {
  const _OfflineCorrespondencePreview({required this.maxGamesToShow});

  final int maxGamesToShow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offlineCorresGames =
        ref.watch(offlineOngoingCorrespondenceGamesProvider);
    return offlineCorresGames.maybeWhen(
      data: (data) {
        return _GamePreview(
          list: data,
          maxGamesToShow: maxGamesToShow,
          builder: (el) => OfflineCorrespondenceGamePreview(
            game: el.$2,
            lastModified: el.$1,
          ),
          moreScreenBuilder: (_) => const OfflineCorrespondenceGamesScreen(),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _GamePreview<T> extends StatelessWidget {
  const _GamePreview({
    required this.list,
    required this.builder,
    required this.moreScreenBuilder,
    required this.maxGamesToShow,
  });
  final IList<T> list;
  final Widget Function(T data) builder;
  final Widget Function(BuildContext) moreScreenBuilder;
  final int maxGamesToShow;

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: Styles.horizontalBodyPadding.add(
            const EdgeInsets.only(top: 16.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  context.l10n.nbGamesInPlay(list.length),
                  style: Styles.sectionTitle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (list.length > maxGamesToShow) ...[
                const SizedBox(width: 6.0),
                NoPaddingTextButton(
                  onPressed: () {
                    pushPlatformRoute(
                      context,
                      title: context.l10n.nbGamesInPlay(list.length),
                      builder: moreScreenBuilder,
                    );
                  },
                  child: Text(context.l10n.more),
                ),
              ],
            ],
          ),
        ),
        for (final data in list.take(maxGamesToShow)) builder(data),
      ],
    );
  }
}

class _RelationButton extends ConsumerWidget {
  const _RelationButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBarIconButton(
      icon: const Icon(Icons.people),
      semanticsLabel: context.l10n.friends,
      onPressed: () {
        pushPlatformRoute(
          context,
          title: context.l10n.friends,
          builder: (_) => const RelationScreen(),
          fullscreenDialog: true,
        );
      },
    );
  }
}
