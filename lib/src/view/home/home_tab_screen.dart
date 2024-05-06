import 'package:carousel_slider/carousel_slider.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/account/ongoing_game.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_game_storage.dart';
import 'package:lichess_mobile/src/model/correspondence/offline_correspondence_game.dart';
import 'package:lichess_mobile/src/model/game/game_storage.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/connectivity.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/layout.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/correspondence/offline_correspondence_game_screen.dart';
import 'package:lichess_mobile/src/view/game/standalone_game_screen.dart';
import 'package:lichess_mobile/src/view/home/create_a_game_screen.dart';
import 'package:lichess_mobile/src/view/home/create_game_options.dart';
import 'package:lichess_mobile/src/view/home/quick_game_button.dart';
import 'package:lichess_mobile/src/view/play/offline_correspondence_games_screen.dart';
import 'package:lichess_mobile/src/view/play/ongoing_games_screen.dart';
import 'package:lichess_mobile/src/view/user/player_screen.dart';
import 'package:lichess_mobile/src/view/user/recent_games.dart';
import 'package:lichess_mobile/src/widgets/board_carousel_item.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

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
            fullscreenDialog: true,
            builder: (_) => const CreateAGameScreen(),
          );
        },
        icon: const Icon(Icons.add),
        label: Text(context.l10n.createAGame),
      ),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    final isHandset = getScreenType(context) == ScreenType.handset;
    return CupertinoPageScaffold(
      child: CustomScrollView(
        controller: homeScrollController,
        slivers: [
          CupertinoSliverNavigationBar(
            padding: const EdgeInsetsDirectional.only(
              start: 16.0,
              end: 8.0,
            ),
            largeTitle: const Text('Home'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _PlayerScreenButton(),
                if (isHandset) ...[
                  const SizedBox(width: 6.0),
                  AppBarIconButton(
                    semanticsLabel: context.l10n.createAGame,
                    icon: const Icon(CupertinoIcons.plus_circle_fill),
                    onPressed: () {
                      pushPlatformRoute(
                        context,
                        fullscreenDialog: true,
                        title: context.l10n.createAGame,
                        builder: (_) => const CreateAGameScreen(),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () => _refreshData(),
          ),
          const SliverToBoxAdapter(child: ConnectivityBanner()),
          const SliverSafeArea(top: false, sliver: _HomeBody()),
        ],
      ),
    );
  }

  Future<void> _refreshData() {
    return Future.wait([
      ref.refresh(accountRecentGamesProvider.future),
      ref.refresh(recentStoredGamesProvider.future),
      ref.refresh(ongoingGamesProvider.future),
    ]);
  }
}

class _SignInWidget extends ConsumerWidget {
  const _SignInWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(authControllerProvider);

    return SecondaryButton(
      semanticsLabel: context.l10n.signIn,
      onPressed: authController.isLoading
          ? null
          : () => ref.read(authControllerProvider.notifier).signIn(),
      child: Text(context.l10n.signIn),
    );
  }
}

class _HomeBody extends ConsumerWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnlineAsync = ref.watch(isOnlineProvider);
    return isOnlineAsync.when(
      data: (isOnline) {
        final session = ref.watch(authSessionProvider);
        final isTablet = getScreenType(context) == ScreenType.tablet;
        final emptyRecent = ref.watch(accountRecentGamesProvider).maybeWhen(
              data: (data) => data.isEmpty,
              orElse: () => false,
            );
        final emptyStored = ref.watch(recentStoredGamesProvider).maybeWhen(
              data: (data) => data.isEmpty,
              orElse: () => false,
            );

        if (emptyRecent && emptyStored) {
          final messageWidget = [
            const _HelloWidget(),
            const Padding(
              padding: Styles.bodyPadding,
              child: LichessMessage(style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 16.0),
            if (session == null) ...[
              const Center(child: _SignInWidget()),
              const SizedBox(height: 16.0),
            ],
            if (session == null || session.user.isPatron != true) ...[
              Center(
                child: SecondaryButton(
                  semanticsLabel: context.l10n.patronDonate,
                  onPressed: () {
                    launchUrl(Uri.parse('https://lichess.org/patron'));
                  },
                  child: Text(context.l10n.patronDonate),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
            Center(
              child: SecondaryButton(
                semanticsLabel: context.l10n.aboutX('Lichess...'),
                onPressed: () {
                  launchUrl(Uri.parse('https://lichess.org/about'));
                },
                child: Text(context.l10n.aboutX('Lichess...')),
              ),
            ),
          ];

          return Theme.of(context).platform == TargetPlatform.android
              ? ListView(
                  shrinkWrap: true,
                  children: messageWidget,
                )
              : SliverFillRemaining(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.viewPaddingOf(context).vertical + 50.0,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: messageWidget,
                      ),
                    ),
                  ),
                );
        }

        final widgets = isTablet
            ? [
                const _HelloWidget(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(height: 8.0),
                          if (isOnline) const _CreateAGameSection(),
                          if (isOnline)
                            const _OngoingGamesPreview(maxGamesToShow: 5)
                          else
                            const _OfflineCorrespondencePreview(
                              maxGamesToShow: 5,
                            ),
                        ],
                      ),
                    ),
                    const Expanded(
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
              ]
            : [
                const _HelloWidget(),
                if (isOnline)
                  const _OngoingGamesCarousel(maxGamesToShow: 20)
                else
                  const _OfflineCorrespondenceCarousel(maxGamesToShow: 20),
                const SafeArea(top: false, child: RecentGames()),
                if (Theme.of(context).platform == TargetPlatform.android)
                  const SizedBox(height: 54.0),
              ];

        return Theme.of(context).platform == TargetPlatform.android
            ? ListView(
                controller: homeScrollController,
                children: widgets,
              )
            : SliverList(
                delegate: SliverChildListDelegate(widgets),
              );
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
}

class _HelloWidget extends ConsumerWidget {
  const _HelloWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    final style = Theme.of(context).platform == TargetPlatform.iOS
        ? const TextStyle(fontSize: 20)
        : Theme.of(context).textTheme.bodyLarge;

    // fetch the account user to be sure we have the latest data (flair, etc.)
    final accountUser = ref.watch(accountProvider).maybeWhen(
          data: (data) => data?.lightUser,
          orElse: () => null,
        );

    final user = accountUser ?? session?.user;

    return Padding(
      padding:
          Styles.horizontalBodyPadding.add(Styles.sectionBottomPadding).add(
                const EdgeInsets.only(top: 8.0),
              ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wb_sunny,
            size: 26,
            color: context.lichessColors.brag,
          ),
          const SizedBox(width: 5.0),
          Text(
            'Hello${user != null ? ', ' : ''}',
            style: style,
          ),
          if (user != null) UserFullNameWidget(user: user, style: style),
        ],
      ),
    );
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

class _OngoingGamesCarousel extends ConsumerWidget {
  const _OngoingGamesCarousel({required this.maxGamesToShow});

  final int maxGamesToShow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ongoingGames = ref.watch(ongoingGamesProvider);
    return ongoingGames.maybeWhen(
      data: (data) {
        return _GamesCarousel<OngoingGame>(
          list: data,
          builder: (game) => _GamePreviewCarouselItem(game: game),
          moreScreenBuilder: (_) => const OngoingGamesScreen(),
          maxGamesToShow: maxGamesToShow,
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _OfflineCorrespondenceCarousel extends ConsumerWidget {
  const _OfflineCorrespondenceCarousel({required this.maxGamesToShow});

  final int maxGamesToShow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offlineCorresGames =
        ref.watch(offlineOngoingCorrespondenceGamesProvider);
    return offlineCorresGames.maybeWhen(
      data: (data) {
        return _GamesCarousel(
          list: data,
          builder: (el) => _OfflineCorrespondenceCarouselItem(
            game: el.$2,
            lastModified: el.$1,
          ),
          moreScreenBuilder: (_) => const OfflineCorrespondenceGamesScreen(),
          maxGamesToShow: maxGamesToShow,
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _GamesCarousel<T> extends StatelessWidget {
  const _GamesCarousel({
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: Styles.horizontalBodyPadding.add(Styles.sectionTopPadding),
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
              const SizedBox(width: 6.0),
              NoPaddingTextButton(
                onPressed: () {
                  pushPlatformRoute(
                    context,
                    title: context.l10n.nbGamesInPlay(list.length),
                    builder: (_) => const OngoingGamesScreen(),
                  );
                },
                child: Text(context.l10n.more),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CarouselSlider.builder(
            options: CarouselOptions(
              aspectRatio: 1.04,
              viewportFraction: 0.65,
              enableInfiniteScroll: false,
              padEnds: false,
            ),
            itemCount: list.length,
            itemBuilder: (context, index, _) {
              return builder(list[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _GamePreviewCarouselItem extends StatelessWidget {
  const _GamePreviewCarouselItem({required this.game});

  final OngoingGame game;

  @override
  Widget build(BuildContext context) {
    return BoardCarouselItem(
      fen: game.fen,
      orientation: game.orientation.cg,
      lastMove: game.lastMove?.cg,
      description: Expanded(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (game.secondsLeft != null && game.secondsLeft! > 0)
                  Text(
                    game.isMyTurn
                        ? context.l10n.yourTurn
                        : context.l10n.waitingForOpponent,
                    style: TextStyle(color: textShade(context, 0.6)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                UserFullNameWidget.player(
                  user: game.opponent,
                  rating: game.opponentRating,
                  aiLevel: game.opponentAiLevel,
                  style: Styles.boardPreviewTitle,
                ),
                const SizedBox(height: 2.0),
                if (game.secondsLeft != null)
                  Opacity(
                    opacity: game.isMyTurn ? 1.0 : 0.5,
                    child: Chip(
                      avatar: Icon(
                        game.isMyTurn
                            ? Icons.timer_outlined
                            : Icons.timer_off_outlined,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      side: BorderSide.none,
                      label: Text(
                        game.isMyTurn
                            ? timeago.format(
                                DateTime.now()
                                    .add(Duration(seconds: game.secondsLeft!)),
                                allowFromNow: true,
                              )
                            : context.l10n.nbDays(
                                Duration(seconds: game.secondsLeft!).inDays,
                              ),
                      ),
                      labelStyle:
                          Theme.of(context).platform == TargetPlatform.iOS
                              ? const TextStyle(fontSize: 12)
                              : Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        pushPlatformRoute(
          context,
          rootNavigator: true,
          builder: (context) => StandaloneGameScreen(
            params: InitialStandaloneGameParams(
              id: game.fullId,
              fen: game.fen,
              orientation: game.orientation,
              lastMove: game.lastMove,
            ),
          ),
        );
      },
    );
  }
}

class _OfflineCorrespondenceCarouselItem extends ConsumerWidget {
  const _OfflineCorrespondenceCarouselItem({
    required this.game,
    required this.lastModified,
  });

  final DateTime lastModified;
  final OfflineCorrespondenceGame game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BoardCarouselItem(
      fen: game.lastPosition.fen,
      orientation: game.orientation.cg,
      lastMove: game.lastMove?.cg,
      description: Expanded(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (game.myTimeLeft(lastModified) != null &&
                    game.myTimeLeft(lastModified)! > Duration.zero)
                  Text(
                    game.isMyTurn
                        ? context.l10n.yourTurn
                        : context.l10n.waitingForOpponent,
                    style: TextStyle(color: textShade(context, 0.6)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                UserFullNameWidget.player(
                  user: game.opponent.user,
                  aiLevel: game.opponent.aiLevel,
                  rating: game.opponent.rating,
                  style: Styles.boardPreviewTitle,
                ),
                const SizedBox(height: 2.0),
                if (game.myTimeLeft(lastModified) != null)
                  Opacity(
                    opacity: game.isMyTurn ? 1.0 : 0.5,
                    child: Chip(
                      avatar: Icon(
                        game.isMyTurn
                            ? Icons.timer_outlined
                            : Icons.timer_off_outlined,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      side: BorderSide.none,
                      label: Text(
                        game.isMyTurn
                            ? timeago.format(
                                DateTime.now()
                                    .add(game.myTimeLeft(lastModified)!),
                                allowFromNow: true,
                              )
                            : game.daysPerTurn != null
                                ? context.l10n.nbDays(
                                    game.daysPerTurn!,
                                  )
                                : context.l10n.unlimited,
                      ),
                      labelStyle:
                          Theme.of(context).platform == TargetPlatform.iOS
                              ? const TextStyle(fontSize: 12)
                              : Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        pushPlatformRoute(
          context,
          rootNavigator: true,
          builder: (_) => OfflineCorrespondenceGameScreen(
            initialGame: (lastModified, game),
          ),
        );
      },
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
        return PreviewGameList(
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
        return PreviewGameList(
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

class PreviewGameList<T> extends StatelessWidget {
  const PreviewGameList({
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
    final icon = Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoIcons.person_2
        : Icons.group;

    return connectivity.maybeWhen(
      data: (connectivity) => AppBarIconButton(
        icon: Icon(icon),
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
        icon: Icon(icon),
        semanticsLabel: context.l10n.players,
        onPressed: null,
      ),
    );
  }
}
