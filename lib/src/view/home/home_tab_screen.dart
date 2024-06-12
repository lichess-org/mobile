import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/account/ongoing_game.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_game_storage.dart';
import 'package:lichess_mobile/src/model/game/game_history.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/connectivity.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/account/profile_screen.dart';
import 'package:lichess_mobile/src/view/correspondence/offline_correspondence_game_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/game/offline_correspondence_games_screen.dart';
import 'package:lichess_mobile/src/view/home/create_game_options.dart';
import 'package:lichess_mobile/src/view/home/quick_game_matrix.dart';
import 'package:lichess_mobile/src/view/play/ongoing_games_screen.dart';
import 'package:lichess_mobile/src/view/play/play_screen.dart';
import 'package:lichess_mobile/src/view/user/player_screen.dart';
import 'package:lichess_mobile/src/view/user/recent_games.dart';
import 'package:lichess_mobile/src/widgets/board_carousel_item.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
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
    final isTablet = isTabletOrLarger(context);
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
      floatingActionButton: isTablet
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                pushPlatformRoute(
                  context,
                  builder: (_) => const PlayScreen(),
                );
              },
              icon: const Icon(LichessIcons.chess_pawn),
              label: Text(context.l10n.play),
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
                largeTitle: Text('Home'),
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
              const SliverSafeArea(top: false, sliver: _HomeBody()),
            ],
          ),
          if (getScreenType(context) == ScreenType.handset)
            Positioned(
              bottom: MediaQuery.paddingOf(context).bottom + 16.0,
              right: 8.0,
              child: FloatingActionButton.extended(
                backgroundColor: CupertinoTheme.of(context).primaryColor,
                foregroundColor:
                    CupertinoTheme.of(context).primaryContrastingColor,
                onPressed: () {
                  pushPlatformRoute(
                    context,
                    title: context.l10n.play,
                    builder: (_) => const PlayScreen(),
                  );
                },
                icon: const Icon(LichessIcons.chess_pawn),
                label: Text(context.l10n.play),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _refreshData() {
    return Future.wait([
      ref.refresh(myRecentGamesProvider.future),
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
    final isOnlineAsync = ref.watch(connectivityChangesProvider);
    return isOnlineAsync.when(
      data: (status) {
        final session = ref.watch(authSessionProvider);
        final isTablet = isTabletOrLarger(context);
        final emptyRecent = ref.watch(myRecentGamesProvider).maybeWhen(
              data: (data) => data.isEmpty,
              orElse: () => false,
            );

        // Show the welcome screen if there are no recent games and no stored games
        // (i.e. first installation, or the user has never played a game)
        if (emptyRecent) {
          final welcomeWidgets = [
            Padding(
              padding: Styles.horizontalBodyPadding,
              child: LichessMessage(
                style: Theme.of(context).platform == TargetPlatform.iOS
                    ? const TextStyle(fontSize: 18)
                    : Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24.0),
            if (session == null) ...[
              const Center(child: _SignInWidget()),
              const SizedBox(height: 16.0),
            ],
            if (Theme.of(context).platform != TargetPlatform.iOS &&
                (session == null || session.user.isPatron != true)) ...[
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

          final emptyScreenWidgets = [
            if (isTablet)
              Row(
                children: [
                  const Flexible(
                    child: _TabletCreateAGameSection(),
                  ),
                  Flexible(
                    child: Column(
                      children: welcomeWidgets,
                    ),
                  ),
                ],
              )
            else
              ...welcomeWidgets,
          ];

          return Theme.of(context).platform == TargetPlatform.android
              ? Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: emptyScreenWidgets,
                  ),
                )
              : SliverFillRemaining(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.viewPaddingOf(context).vertical + 50.0,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: emptyScreenWidgets,
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
                    Flexible(
                      child: Column(
                        children: [
                          const SizedBox(height: 8.0),
                          if (status.isOnline)
                            const _TabletCreateAGameSection(),
                          if (status.isOnline)
                            const _OngoingGamesPreview(maxGamesToShow: 5)
                          else
                            const _OfflineCorrespondencePreview(
                              maxGamesToShow: 5,
                            ),
                        ],
                      ),
                    ),
                    const Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 8.0),
                          RecentGamesWidget(),
                        ],
                      ),
                    ),
                  ],
                ),
              ]
            : [
                const _HelloWidget(),
                if (status.isOnline)
                  const _OngoingGamesCarousel(maxGamesToShow: 20)
                else
                  const _OfflineCorrespondenceCarousel(maxGamesToShow: 20),
                const RecentGamesWidget(),
                if (Theme.of(context).platform == TargetPlatform.iOS)
                  const SizedBox(height: 70.0)
                else
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

    final iconSize =
        Theme.of(context).platform == TargetPlatform.iOS ? 26.0 : 24.0;

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
      child: GestureDetector(
        onTap: () {
          pushPlatformRoute(
            context,
            builder: (context) => const ProfileScreen(),
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wb_sunny,
              size: iconSize,
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
      ),
    );
  }
}

class _TabletCreateAGameSection extends StatelessWidget {
  const _TabletCreateAGameSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: Styles.bodySectionPadding,
          child: const QuickGameMatrix(showMatrixTitle: false),
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
        if (data.isEmpty) {
          return const SizedBox.shrink();
        }
        return _GamesCarousel<OngoingGame>(
          list: data,
          builder: (game) => _GamePreviewCarouselItem(
            game: game,
            onTap: () {
              pushPlatformRoute(
                context,
                rootNavigator: true,
                builder: (context) => GameScreen(
                  initialGameId: game.fullId,
                  loadingFen: game.fen,
                  loadingOrientation: game.orientation,
                  loadingLastMove: game.lastMove,
                ),
              );
            },
          ),
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
        if (data.isEmpty) {
          return const SizedBox.shrink();
        }
        return _GamesCarousel(
          list: data,
          builder: (el) => _GamePreviewCarouselItem(
            game: OngoingGame(
              id: el.$2.id,
              fullId: el.$2.fullId,
              orientation: el.$2.orientation,
              fen: el.$2.lastPosition.fen,
              perf: el.$2.perf,
              speed: el.$2.speed,
              variant: el.$2.variant,
              opponent: el.$2.opponent.user,
              isMyTurn: el.$2.isMyTurn,
              opponentRating: el.$2.opponent.rating,
              opponentAiLevel: el.$2.opponent.aiLevel,
              lastMove: el.$2.lastMove,
              secondsLeft: el.$2.myTimeLeft(el.$1)?.inSeconds,
            ),
            onTap: () {
              pushPlatformRoute(
                context,
                rootNavigator: true,
                builder: (_) => OfflineCorrespondenceGameScreen(
                  initialGame: (el.$1, el.$2),
                ),
              );
            },
          ),
          moreScreenBuilder: (_) => const OfflineCorrespondenceGamesScreen(),
          maxGamesToShow: maxGamesToShow,
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _GamesCarousel<T> extends StatefulWidget {
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
  State<_GamesCarousel<T>> createState() => _GamesCarouselState<T>();
}

class _GamesCarouselState<T> extends State<_GamesCarousel<T>> {
  final _pageController = PageController(viewportFraction: 0.65);

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
                  context.l10n.nbGamesInPlay(widget.list.length),
                  style: Styles.sectionTitle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.list.length > 2) ...[
                const SizedBox(width: 6.0),
                NoPaddingTextButton(
                  onPressed: () {
                    pushPlatformRoute(
                      context,
                      title: context.l10n.nbGamesInPlay(widget.list.length),
                      builder: widget.moreScreenBuilder,
                    );
                  },
                  child: Text(context.l10n.more),
                ),
              ],
            ],
          ),
        ),
        AspectRatio(
          aspectRatio: 1.3,
          child: BoardsPageView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            controller: _pageController,
            pageSnapping: widget.list.length > 2,
            allowImplicitScrolling: true,
            itemCount: widget.list.length,
            itemBuilder: (context, index) {
              return widget.builder(widget.list[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _GamePreviewCarouselItem extends StatelessWidget {
  const _GamePreviewCarouselItem({required this.game, this.onTap});

  final OngoingGame game;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return BoardCarouselItem(
      fen: game.fen,
      orientation: game.orientation.cg,
      lastMove: game.lastMove?.cg,
      description: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Opacity(
                opacity: game.isMyTurn ? 1.0 : 0.6,
                child: Row(
                  children: [
                    Icon(
                      game.isMyTurn ? Icons.timer : Icons.timer_off,
                      size: 16.0,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      game.secondsLeft != null && game.isMyTurn
                          ? timeago.format(
                              DateTime.now().add(
                                Duration(seconds: game.secondsLeft!),
                              ),
                              allowFromNow: true,
                            )
                          : game.isMyTurn
                              ? context.l10n.yourTurn
                              : context.l10n.waitingForOpponent,
                      style: Theme.of(context).platform == TargetPlatform.iOS
                          ? const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            )
                          : TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.fontSize,
                              fontWeight: FontWeight.w500,
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4.0),
              UserFullNameWidget.player(
                user: game.opponent,
                rating: game.opponentRating,
                aiLevel: game.opponentAiLevel,
                style: Styles.boardPreviewTitle,
              ),
            ],
          ),
        ),
      ),
      onTap: onTap,
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
