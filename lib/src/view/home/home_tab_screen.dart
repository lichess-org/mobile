import 'dart:ui';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_game_storage.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/connectivity.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/layout.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/home/create_a_game_screen.dart';
import 'package:lichess_mobile/src/view/home/create_game_options.dart';
import 'package:lichess_mobile/src/view/home/quick_game_button.dart';
import 'package:lichess_mobile/src/view/play/offline_correspondence_games_screen.dart';
import 'package:lichess_mobile/src/view/play/ongoing_games_screen.dart';
import 'package:lichess_mobile/src/view/user/player_screen.dart';
import 'package:lichess_mobile/src/view/user/recent_games.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('lichess.org'),
        actions: const [
          _PlayerScreenButton(),
        ],
      ),
      body: RefreshIndicator(
        key: _androidRefreshKey,
        onRefresh: () => _refreshData(),
        child: const Column(
          children: [
            ConnectivityBanner(),
            Expanded(child: _HomeBody()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          pushPlatformRoute(
            context,
            builder: (_) => const CreateAGameScreen(),
          );
        },
        icon: const Icon(Icons.add),
        label: Text(context.l10n.createAGame),
      ),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomScrollView(
            controller: homeScrollController,
            slivers: [
              const CupertinoSliverNavigationBar(
                padding: EdgeInsetsDirectional.only(
                  start: 16.0,
                  end: 8.0,
                ),
                largeTitle: Text('lichess.org'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _PlayerScreenButton(),
                  ],
                ),
              ),
              CupertinoSliverRefreshControl(
                onRefresh: () => _refreshData(),
              ),
              const SliverToBoxAdapter(child: ConnectivityBanner()),
              const _HomeBody(),
            ],
          ),
          if (getScreenType(context) == ScreenType.handset)
            Positioned(
              bottom: MediaQuery.paddingOf(context).bottom,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 72.0,
                    decoration: BoxDecoration(
                      color: CupertinoDynamicColor.resolve(
                        CupertinoTheme.of(context).barBackgroundColor,
                        context,
                      ),
                      border: Border(
                        top: BorderSide(
                          color: Styles.cupertinoDefaultTabBarBorderColor
                              .resolveFrom(context),
                          width: 0.0,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: CupertinoDynamicColor.resolve(
                              CupertinoTheme.of(context).barBackgroundColor,
                              context,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 14.0,
                              ),
                            ],
                          ),
                          child: FatButton(
                            semanticsLabel: context.l10n.createAGame,
                            onPressed: () {
                              pushPlatformRoute(
                                context,
                                title: context.l10n.createAGame,
                                builder: (_) => const CreateAGameScreen(),
                              );
                            },
                            child: Text(
                              context.l10n.createAGame,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
          final onlineWidgets = _onlineWidgets(context, isTablet);

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

  List<Widget> _onlineWidgets(BuildContext context, bool isTablet) {
    if (isTablet) {
      return [
        const _HelloWidget(),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 8.0),
                  _CreateAGameSection(),
                  _OngoingGamesPreview(maxGamesToShow: 5),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 8.0),
                  RecentGames(),
                ],
              ),
            ),
          ],
        ),
      ];
    } else {
      return [
        const _HelloWidget(),
        const _OngoingGamesPreview(maxGamesToShow: 5),
        const SafeArea(top: false, child: RecentGames()),
        if (Theme.of(context).platform == TargetPlatform.iOS)
          const SizedBox(height: 70.0)
        else
          const SizedBox(height: 54.0),
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
                  _OfflineCorrespondencePreview(maxGamesToShow: 5),
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
        _OfflineCorrespondencePreview(maxGamesToShow: 5),
      ];
    }
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
            padding: Styles.bodySectionPadding,
            child: Row(
              children: [
                Icon(
                  Icons.wb_sunny,
                  size: 28,
                  color: context.lichessColors.brag,
                ),
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

class _CreateAGameSection extends StatelessWidget {
  const _CreateAGameSection();

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform != TargetPlatform.iOS) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListSection(
          header: Text(context.l10n.createAGame),
          children: [
            Padding(
              padding: Theme.of(context).platform == TargetPlatform.android
                  ? const EdgeInsets.symmetric(horizontal: 16.0)
                  : const EdgeInsets.only(right: 2.0),
              child: const QuickGameButton(),
            ),
          ],
        ),
        const CreateGameOptions(),
      ],
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

class _PlayerScreenButton extends ConsumerWidget {
  const _PlayerScreenButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityChangesProvider);

    return connectivity.maybeWhen(
      data: (connectivity) => AppBarIconButton(
        icon: const Icon(Icons.group),
        semanticsLabel: context.l10n.players,
        onPressed: !connectivity.isOnline
            ? null
            : () {
                pushPlatformRoute(
                  context,
                  title: context.l10n.players,
                  builder: (_) => const PlayerScreen(),
                );
              },
      ),
      orElse: () => AppBarIconButton(
        icon: const Icon(Icons.group),
        semanticsLabel: context.l10n.players,
        onPressed: null,
      ),
    );
  }
}
