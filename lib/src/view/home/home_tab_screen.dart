import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_game_storage.dart';
import 'package:lichess_mobile/src/model/game/game_storage.dart';
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
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';
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
          final messageWidget = Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
              ],
            ),
          );

          return Theme.of(context).platform == TargetPlatform.android
              ? messageWidget
              : SliverFillRemaining(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 72.0 + 50.0),
                    child: messageWidget,
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
                  const _OngoingGamesPreview(maxGamesToShow: 5)
                else
                  const _OfflineCorrespondencePreview(maxGamesToShow: 5),
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
    const style = TextStyle(fontSize: 22);

    // fetch the account user to be sure we have the latest data (flair, etc.)
    final accountUser = ref.watch(accountProvider).maybeWhen(
          data: (data) => data?.lightUser,
          orElse: () => null,
        );

    final user = accountUser ?? session?.user;

    return Padding(
      padding: Styles.bodySectionPadding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wb_sunny,
            size: 28,
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
