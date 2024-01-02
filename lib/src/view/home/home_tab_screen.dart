import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_game_storage.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/settings/play_preferences.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/connectivity.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/layout.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/account/profile_screen.dart';
import 'package:lichess_mobile/src/view/account/rating_pref_aware.dart';
import 'package:lichess_mobile/src/view/auth/sign_in_widget.dart';
import 'package:lichess_mobile/src/view/lobby/lobby_screen.dart';
import 'package:lichess_mobile/src/view/play/offline_correspondence_games_screen.dart';
import 'package:lichess_mobile/src/view/play/ongoing_games_screen.dart';
import 'package:lichess_mobile/src/view/play/play_screen.dart';
import 'package:lichess_mobile/src/view/relation/relation_screen.dart';
import 'package:lichess_mobile/src/view/settings/settings_screen.dart';
import 'package:lichess_mobile/src/view/user/leaderboard_widget.dart';
import 'package:lichess_mobile/src/view/user/recent_games.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

final isHomeRootProvider = StateProvider<bool>((ref) => true);

class HomeTabScreen extends ConsumerStatefulWidget {
  const HomeTabScreen({super.key});

  @override
  ConsumerState<HomeTabScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeTabScreen> with RouteAware {
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null && route is PageRoute) {
      homeRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    homeRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPushNext() {
    ref.read(isHomeRootProvider.notifier).state = false;
    super.didPushNext();
  }

  @override
  void didPopNext() {
    ref.read(isHomeRootProvider.notifier).state = true;
    super.didPopNext();
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
          if (session != null)
            const _RelationButton()
          else
            const SignInWidget(),
          const _SettingsButton(),
        ],
      ),
      body: RefreshIndicator(
        key: _androidRefreshKey,
        onRefresh: () => _refreshData(),
        child: const _HomeScaffold(
          child: _HomeBody(),
        ),
      ),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    final session = ref.watch(authSessionProvider);
    return CupertinoPageScaffold(
      child: _HomeScaffold(
        child: CustomScrollView(
          controller: homeScrollController,
          slivers: [
            CupertinoSliverNavigationBar(
              padding: const EdgeInsetsDirectional.only(start: 16.0, end: 8.0),
              largeTitle: Text(context.l10n.play),
              leading: session == null
                  ? const SignInWidget()
                  : AppBarTextButton(
                      onPressed: () {
                        ref.invalidate(accountProvider);
                        Navigator.of(context).push(
                          CupertinoPageRoute<void>(
                            builder: (context) => const ProfileScreen(),
                          ),
                        );
                      },
                      child: Text(session.user.name),
                    ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (session != null) const _RelationButton(),
                  const _SettingsButton(),
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

/// Scaffold with a sticky Create Game button at the bottom
class _HomeScaffold extends StatelessWidget {
  const _HomeScaffold({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _iosBuilder(BuildContext context) {
    final isHandset = getScreenType(context) == ScreenType.handset;
    return SafeArea(
      top: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: child,
          ),
          if (isHandset)
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: CupertinoTheme.of(context).barBackgroundColor,
                border: const Border(
                  top: BorderSide(
                    color: Styles.cupertinoDefaultTabBarBorderColor,
                    width: 0.0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0)
                    .add(Styles.horizontalBodyPadding),
                child: MediaQuery.withClampedTextScaling(
                  maxScaleFactor: 1.1,
                  child: CupertinoButton.filled(
                    child: DefaultTextStyle.merge(
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      child: Text(context.l10n.createAGame),
                    ),
                    onPressed: () {
                      pushPlatformRoute(
                        context,
                        title: context.l10n.createAGame,
                        builder: (_) => const PlayScreen(),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _androidBuilder(BuildContext context) {
    final navigationBarTheme = NavigationBarTheme.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isHandset = getScreenType(context) == ScreenType.handset;
    return SafeArea(
      top: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: child,
          ),
          if (isHandset)
            Material(
              color: navigationBarTheme.backgroundColor ?? colorScheme.surface,
              elevation: navigationBarTheme.elevation ?? 3.0,
              shadowColor: navigationBarTheme.shadowColor ?? Colors.transparent,
              surfaceTintColor: navigationBarTheme.surfaceTintColor ??
                  colorScheme.surfaceTint,
              child: SizedBox(
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0)
                      .add(Styles.horizontalBodyPadding),
                  child: FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text(context.l10n.createAGame),
                    onPressed: () {
                      pushPlatformRoute(
                        context,
                        title: context.l10n.createAGame,
                        builder: (_) => const PlayScreen(),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
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

          return defaultTargetPlatform == TargetPlatform.android
              ? ListView(
                  controller: homeScrollController,
                  children: onlineWidgets,
                )
              : SliverList(
                  delegate: SliverChildListDelegate(onlineWidgets),
                );
        } else {
          final offlineWidgets = _offlineWidgets(isTablet);
          return defaultTargetPlatform == TargetPlatform.android
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
        return defaultTargetPlatform == TargetPlatform.android
            ? child
            : const SliverFillRemaining(child: child);
      },
      error: (error, stack) {
        const child = SizedBox.shrink();
        return defaultTargetPlatform == TargetPlatform.android
            ? child
            : const SliverFillRemaining(child: child);
      },
    );
  }

  List<Widget> _onlineWidgets(bool isTablet) {
    if (isTablet) {
      return [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              flex: 3,
              child: Column(
                children: [
                  SizedBox(height: 16.0),
                  PlayScreenBody(),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),
                  const _PreferredSetup(),
                  const _MostRecentOngoingGamePreview(),
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
        const _PreferredSetup(),
        const _MostRecentOngoingGamePreview(),
        const RecentGames(),
        RatingPrefAware(child: LeaderboardWidget()),
      ];
    }
  }

  List<Widget> _offlineWidgets(bool isTablet) {
    if (isTablet) {
      return const [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  SizedBox(height: 16.0),
                  PlayScreenBody(),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 8.0),
                  _OfflineCorrespondencePreview(),
                ],
              ),
            ),
          ],
        ),
      ];
    } else {
      return const [
        SizedBox(height: 8.0),
        _OfflineCorrespondencePreview(),
      ];
    }
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

class _PreferredSetup extends ConsumerWidget {
  const _PreferredSetup();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playPrefs = ref.watch(playPreferencesProvider);
    final session = ref.watch(authSessionProvider);

    GameSeek seek = GameSeek.fastPairingFromPrefs(playPrefs, session);

    if (playPrefs.seekMode == SeekMode.custom) {
      final account = ref.watch(accountProvider);
      final UserPerf? userPerf = account.maybeWhen(
        data: (data) {
          if (data == null) {
            return null;
          }
          return data.perfs[playPrefs.perfFromCustom];
        },
        orElse: () => null,
      );
      seek = GameSeek.customFromPrefs(playPrefs, session, userPerf);
    }

    final timeControl = seek.timeIncrement?.display ??
        '${context.l10n.daysPerTurn}: ${seek.days}';
    final mode =
        seek.rated ? ' • ${context.l10n.rated}' : ' • ${context.l10n.casual}';

    return SmallBoardPreview(
      orientation: seek.side?.cg ?? Side.white.cg,
      fen: kInitialFEN,
      description: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
            'Play online',
            style: Styles.boardPreviewTitle,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                seek.side == null
                    ? context.l10n.randomColor
                    : seek.side == Side.white
                        ? context.l10n.white
                        : context.l10n.black,
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(
                    seek.perf.icon,
                    size: 20,
                    color: DefaultTextStyle.of(context).style.color,
                  ),
                  const SizedBox(width: 5),
                  Text('$timeControl$mode'),
                ],
              ),
              if (seek.ratingRange != null) ...[
                const SizedBox(height: 8.0),
                Text(
                  '${seek.ratingRange!.$1}-${seek.ratingRange!.$2}',
                ),
              ],
            ],
          ),
        ],
      ),
      onTap: () {
        pushPlatformRoute(
          context,
          rootNavigator: true,
          builder: (BuildContext context) {
            return LobbyScreen(
              seek: seek,
            );
          },
        );
      },
    );
  }
}

class _MostRecentOngoingGamePreview extends ConsumerWidget {
  const _MostRecentOngoingGamePreview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ongoingGames = ref.watch(ongoingGamesProvider);
    return ongoingGames.maybeWhen(
      data: (data) {
        final game = data.firstOrNull;
        if (game == null) {
          return const SizedBox.shrink();
        }

        return _OngoingGamePreview(
          data: data,
          child: OngoingGamePreview(game: game),
          moreScreenBuilder: (_) => const OngoingGamesScreen(),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _OfflineCorrespondencePreview extends ConsumerWidget {
  const _OfflineCorrespondencePreview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offlineCorresGames =
        ref.watch(offlineOngoingCorrespondenceGamesProvider);
    return offlineCorresGames.maybeWhen(
      data: (data) {
        final first = data.firstOrNull;
        if (first == null) {
          return const SizedBox.shrink();
        }

        return _OngoingGamePreview(
          data: data.map((e) => e.$2).toIList(),
          child: OfflineCorrespondenceGamePreview(
            game: first.$2,
            lastModified: first.$1,
          ),
          moreScreenBuilder: (_) => const OfflineCorrespondenceGamesScreen(),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _OngoingGamePreview<T> extends StatelessWidget {
  const _OngoingGamePreview({
    required this.data,
    required this.child,
    required this.moreScreenBuilder,
  });
  final IList<T> data;
  final Widget child;
  final Widget Function(BuildContext) moreScreenBuilder;

  @override
  Widget build(BuildContext context) {
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
                  context.l10n.nbGamesInPlay(data.length),
                  style: Styles.sectionTitle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (data.length > 1) ...[
                const SizedBox(width: 6.0),
                NoPaddingTextButton(
                  onPressed: () {
                    pushPlatformRoute(
                      context,
                      title: context.l10n.nbGamesInPlay(data.length),
                      builder: moreScreenBuilder,
                    );
                  },
                  child: Text(context.l10n.more),
                ),
              ],
            ],
          ),
        ),
        child,
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
