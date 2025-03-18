import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/account/ongoing_game.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/challenge/challenges.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_game_storage.dart';
import 'package:lichess_mobile/src/model/correspondence/offline_correspondence_game.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:lichess_mobile/src/model/game/game_history.dart';
import 'package:lichess_mobile/src/model/settings/home_preferences.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/account/profile_screen.dart';
import 'package:lichess_mobile/src/view/correspondence/offline_correspondence_game_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/game/offline_correspondence_games_screen.dart';
import 'package:lichess_mobile/src/view/home/games_carousel.dart';
import 'package:lichess_mobile/src/view/play/create_game_options.dart';
import 'package:lichess_mobile/src/view/play/ongoing_games_screen.dart';
import 'package:lichess_mobile/src/view/play/play_screen.dart';
import 'package:lichess_mobile/src/view/play/quick_game_button.dart';
import 'package:lichess_mobile/src/view/play/quick_game_matrix.dart';
import 'package:lichess_mobile/src/view/user/challenge_requests_screen.dart';
import 'package:lichess_mobile/src/view/user/player_screen.dart';
import 'package:lichess_mobile/src/view/user/recent_games.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';
import 'package:url_launcher/url_launcher.dart';

final editModeProvider = StateProvider<bool>((ref) => false);

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
          _refreshData(isOnline: isNowOnline);
        }

        wasOnline = isNowOnline;
      }
    });

    final connectivity = ref.watch(connectivityChangesProvider);
    final isEditing = ref.watch(editModeProvider);

    return connectivity.when(
      skipLoadingOnReload: true,
      data: (status) {
        final session = ref.watch(authSessionProvider);
        final ongoingGames = ref.watch(ongoingGamesProvider);
        final offlineCorresGames = ref.watch(offlineOngoingCorrespondenceGamesProvider);
        final recentGames = ref.watch(myRecentGamesProvider);
        final nbOfGames = ref.watch(userNumberOfGamesProvider(null)).valueOrNull ?? 0;
        final isTablet = isTabletOrLarger(context);

        // Show the welcome screen if not logged in and there are no recent games and no stored games
        // (i.e. first installation, or the user has never played a game)
        final shouldShowWelcomeScreen =
            session == null &&
            recentGames.maybeWhen(data: (data) => data.isEmpty, orElse: () => false);

        final widgets =
            shouldShowWelcomeScreen
                ? _welcomeScreenWidgets(session: session, status: status, isTablet: isTablet)
                : isTablet
                ? _tabletWidgets(
                  session: session,
                  status: status,
                  ongoingGames: ongoingGames,
                  offlineCorresGames: offlineCorresGames,
                  recentGames: recentGames,
                  nbOfGames: nbOfGames,
                )
                : _handsetWidgets(
                  session: session,
                  status: status,
                  ongoingGames: ongoingGames,
                  offlineCorresGames: offlineCorresGames,
                  recentGames: recentGames,
                  nbOfGames: nbOfGames,
                );

        if (Theme.of(context).platform == TargetPlatform.iOS) {
          return CupertinoPageScaffold(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CustomScrollView(
                  controller: homeScrollController,
                  slivers: [
                    CupertinoSliverNavigationBar(
                      padding: const EdgeInsetsDirectional.only(start: 16.0, end: 8.0),
                      largeTitle: Text(context.l10n.mobileHomeTab),
                      leading: CupertinoButton(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          ref.read(editModeProvider.notifier).state = !isEditing;
                        },
                        child: Text(isEditing ? 'Done' : 'Edit'),
                      ),
                      trailing: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [_ChallengeScreenButton(), _PlayerScreenButton()],
                      ),
                    ),
                    CupertinoSliverRefreshControl(
                      onRefresh: () => _refreshData(isOnline: status.isOnline),
                    ),
                    const SliverToBoxAdapter(child: ConnectivityBanner()),
                    SliverSafeArea(
                      top: false,
                      sliver: SliverList(delegate: SliverChildListDelegate(widgets)),
                    ),
                  ],
                ),
                if (getScreenType(context) == ScreenType.handset)
                  Positioned(
                    bottom: MediaQuery.paddingOf(context).bottom + 16.0,
                    right: 8.0,
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.of(context).push(PlayScreen.buildRoute(context));
                      },
                      icon: const Icon(Icons.add),
                      label: Text(context.l10n.play),
                    ),
                  ),
              ],
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('lichess.org'),
              actions: [
                IconButton(
                  onPressed: () {
                    ref.read(editModeProvider.notifier).state = !isEditing;
                  },
                  icon: Icon(isEditing ? Icons.save_outlined : Icons.app_registration),
                  tooltip: isEditing ? 'Save' : 'Edit',
                ),
                const _ChallengeScreenButton(),
                const _PlayerScreenButton(),
              ],
            ),
            body: RefreshIndicator(
              key: _androidRefreshKey,
              onRefresh: () => _refreshData(isOnline: status.isOnline),
              child: Column(
                children: [
                  const ConnectivityBanner(),
                  Expanded(child: ListView(controller: homeScrollController, children: widgets)),
                ],
              ),
            ),
            floatingActionButton:
                isTablet
                    ? null
                    : FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.of(context).push(PlayScreen.buildRoute(context));
                      },
                      icon: const Icon(Icons.add),
                      label: Text(context.l10n.play),
                    ),
          );
        }
      },
      error: (_, _) => const CenterLoadingIndicator(),
      loading: () => const CenterLoadingIndicator(),
    );
  }

  List<Widget> _handsetWidgets({
    required AuthSessionState? session,
    required ConnectivityStatus status,
    required AsyncValue<IList<OngoingGame>> ongoingGames,
    required AsyncValue<IList<(DateTime, OfflineCorrespondenceGame)>> offlineCorresGames,
    required AsyncValue<IList<LightArchivedGameWithPov>> recentGames,
    required int nbOfGames,
  }) {
    final homePrefs = ref.watch(homePreferencesProvider);
    final hasOngoingGames =
        (status.isOnline &&
            ongoingGames.maybeWhen(data: (data) => data.isNotEmpty, orElse: () => false)) ||
        (!status.isOnline &&
            offlineCorresGames.maybeWhen(data: (data) => data.isNotEmpty, orElse: () => false));
    final list = [
      _EditableWidget(
        widget: HomeEditableWidget.hello,
        shouldShow: true,
        index: homePrefs.enabledWidgets.indexOf(HomeEditableWidget.hello),
        child: const _HelloWidget(),
      ),
      _EditableWidget(
        widget: HomeEditableWidget.perfCards,
        shouldShow: session != null && status.isOnline,
        index: homePrefs.enabledWidgets.indexOf(HomeEditableWidget.perfCards),
        child: AccountPerfCards(
          padding: Styles.horizontalBodyPadding.add(Styles.sectionBottomPadding),
        ),
      ),
      _EditableWidget(
        widget: HomeEditableWidget.quickPairing,
        shouldShow: status.isOnline,
        index: homePrefs.enabledWidgets.indexOf(HomeEditableWidget.quickPairing),
        child: const Padding(padding: Styles.bodySectionPadding, child: QuickGameMatrix()),
      ),
      _EditableWidget(
        widget: HomeEditableWidget.ongoingGames,
        shouldShow: hasOngoingGames,
        index: homePrefs.enabledWidgets.indexOf(HomeEditableWidget.ongoingGames),
        child:
            status.isOnline
                ? _OngoingGamesCarousel(ongoingGames, maxGamesToShow: 20)
                : _OfflineCorrespondenceCarousel(offlineCorresGames, maxGamesToShow: 20),
      ),
      _EditableWidget(
        widget: HomeEditableWidget.recentGames,
        index: homePrefs.enabledWidgets.indexOf(HomeEditableWidget.recentGames),
        shouldShow: true,
        child: RecentGamesWidget(recentGames: recentGames, nbOfGames: nbOfGames, user: null),
      ),
    ].sortedBy((_EditableWidget widget) {
      final i = homePrefs.enabledWidgets.indexOf(widget.widget);
      return i != -1 ? i : HomeEditableWidget.values.length;
    });
    return [
      ...list,
      if (Theme.of(context).platform == TargetPlatform.iOS)
        const SizedBox(height: 70.0)
      else
        const SizedBox(height: 54.0),
    ];
  }

  List<Widget> _welcomeScreenWidgets({
    required AuthSessionState? session,
    required ConnectivityStatus status,
    required bool isTablet,
  }) {
    final welcomeWidgets = [
      Padding(
        padding: Styles.horizontalBodyPadding,
        child: LichessMessage(
          style:
              Theme.of(context).platform == TargetPlatform.iOS
                  ? const TextStyle(fontSize: 18)
                  : TextTheme.of(context).bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(height: 24.0),
      if (session == null) ...[const Center(child: _SignInWidget()), const SizedBox(height: 16.0)],
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

    return [
      if (isTablet)
        Row(
          children: [
            const Flexible(child: _TabletCreateAGameSection()),
            Flexible(child: Column(children: welcomeWidgets)),
          ],
        )
      else ...[
        if (status.isOnline)
          const _EditableWidget(
            widget: HomeEditableWidget.quickPairing,
            shouldShow: true,
            child: Padding(padding: Styles.bodySectionPadding, child: QuickGameMatrix()),
          ),
        ...welcomeWidgets,
      ],
    ];
  }

  List<Widget> _tabletWidgets({
    required AuthSessionState? session,
    required ConnectivityStatus status,
    required AsyncValue<IList<OngoingGame>> ongoingGames,
    required AsyncValue<IList<(DateTime, OfflineCorrespondenceGame)>> offlineCorresGames,
    required AsyncValue<IList<LightArchivedGameWithPov>> recentGames,
    required int nbOfGames,
  }) {
    return [
      const _EditableWidget(
        widget: HomeEditableWidget.hello,
        shouldShow: true,
        child: _HelloWidget(),
      ),
      if (status.isOnline)
        _EditableWidget(
          widget: HomeEditableWidget.perfCards,
          shouldShow: session != null,
          child: const AccountPerfCards(padding: Styles.bodySectionPadding),
        ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              children: [
                const SizedBox(height: 8.0),
                const _TabletCreateAGameSection(),
                if (status.isOnline)
                  _OngoingGamesPreview(ongoingGames, maxGamesToShow: 5)
                else
                  _OfflineCorrespondencePreview(offlineCorresGames, maxGamesToShow: 5),
              ],
            ),
          ),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                RecentGamesWidget(recentGames: recentGames, nbOfGames: nbOfGames, user: null),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  Future<void> _refreshData({required bool isOnline}) {
    return Future.wait([
      ref.refresh(myRecentGamesProvider.future),
      if (isOnline) ref.refresh(accountProvider.future),
      if (isOnline) ref.refresh(ongoingGamesProvider.future),
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
      onPressed:
          authController.isLoading
              ? null
              : () => ref.read(authControllerProvider.notifier).signIn(),
      child: Text(context.l10n.signIn),
    );
  }
}

/// A widget that can be enabled or disabled by the user.
///
/// This widget is used to show or hide certain sections of the home screen.
///
/// The [homePreferencesProvider] provides a list of enabled widgets.
///
/// * The [widget] parameter is the widget that can be enabled or disabled.
///
/// * The [shouldShow] parameter is useful when the widget should be shown only
///   when certain conditions are met. For example, we only want to show the quick
///   pairing matrix when the user is online.
///   This parameter is only active when the user is not in edit mode, as we
///   always want to display the widget in edit mode.
class _EditableWidget extends ConsumerWidget {
  const _EditableWidget({
    required this.child,
    required this.widget,
    required this.shouldShow,
    this.index,
  });

  final Widget child;
  final HomeEditableWidget widget;
  final bool shouldShow;
  final int? index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabledWidgets = ref.watch(homePreferencesProvider).enabledWidgets;
    final isEditing = ref.watch(editModeProvider);
    final isEnabled = enabledWidgets.contains(widget);

    if (!shouldShow) {
      return const SizedBox.shrink();
    }

    return isEditing
        ? Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (index != null)
                    IconButton(
                      icon: Icon(Icons.arrow_upward, color: ColorScheme.of(context).outline),
                      onPressed:
                          isEnabled
                              ? () {
                                ref.read(homePreferencesProvider.notifier).moveUp(widget);
                              }
                              : null,
                    ),
                  Checkbox.adaptive(
                    value: isEnabled,
                    onChanged:
                        widget.alwaysEnabled
                            ? null
                            : (_) {
                              ref.read(homePreferencesProvider.notifier).toggleWidget(widget);
                            },
                  ),
                  if (index != null)
                    IconButton(
                      icon: Icon(Icons.arrow_downward, color: ColorScheme.of(context).outline),
                      onPressed:
                          isEnabled
                              ? () {
                                ref.read(homePreferencesProvider.notifier).moveDown(widget);
                              }
                              : null,
                    ),
                ],
              ),
            ),
            Expanded(child: IgnorePointer(ignoring: isEditing, child: child)),
          ],
        )
        : widget.alwaysEnabled || isEnabled
        ? child
        : const SizedBox.shrink();
  }
}

class _HelloWidget extends ConsumerWidget {
  const _HelloWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    final style =
        Theme.of(context).platform == TargetPlatform.iOS
            ? const TextStyle(fontSize: 20)
            : TextTheme.of(context).bodyLarge;

    final iconSize = Theme.of(context).platform == TargetPlatform.iOS ? 26.0 : 24.0;

    // fetch the account user to be sure we have the latest data (flair, etc.)
    final accountUser = ref
        .watch(accountProvider)
        .maybeWhen(data: (data) => data?.lightUser, orElse: () => null);

    final user = accountUser ?? session?.user;

    return Padding(
      padding: Styles.horizontalBodyPadding
          .add(Styles.sectionBottomPadding)
          .add(const EdgeInsets.only(top: 8.0)),
      child: GestureDetector(
        onTap: () {
          ref.invalidate(accountActivityProvider);
          Navigator.of(context).push(ProfileScreen.buildRoute(context));
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wb_sunny, size: iconSize, color: context.lichessColors.brag),
            const SizedBox(width: 5.0),
            if (user != null)
              l10nWithWidget(
                context.l10n.mobileGreeting,
                UserFullNameWidget(user: user, style: style),
                textStyle: style,
              )
            else
              Text(context.l10n.mobileGreetingWithoutName, style: style),
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
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _EditableWidget(
          widget: HomeEditableWidget.quickPairing,
          shouldShow: true,
          child: Padding(padding: Styles.bodySectionPadding, child: QuickGameMatrix()),
        ),
        Padding(padding: Styles.bodySectionPadding, child: QuickGameButton()),
        CreateGameOptions(),
      ],
    );
  }
}

class _OngoingGamesCarousel extends ConsumerWidget {
  const _OngoingGamesCarousel(this.games, {required this.maxGamesToShow});

  final AsyncValue<IList<OngoingGame>> games;

  final int maxGamesToShow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return games.maybeWhen(
      data: (data) {
        if (data.isEmpty) {
          return const SizedBox.shrink();
        }
        return GamesCarousel<OngoingGame>(
          list: data,
          onTap: (index) {
            final game = data[index];
            Navigator.of(context, rootNavigator: true).push(
              GameScreen.buildRoute(
                context,
                initialGameId: game.fullId,
                loadingFen: game.fen,
                loadingOrientation: game.orientation,
                loadingLastMove: game.lastMove,
              ),
            );
          },
          builder: (game) => OngoingGameCarouselItem(game: game),
          moreScreenRouteBuilder: OngoingGamesScreen.buildRoute,
          maxGamesToShow: maxGamesToShow,
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _OfflineCorrespondenceCarousel extends ConsumerWidget {
  const _OfflineCorrespondenceCarousel(this.offlineCorresGames, {required this.maxGamesToShow});

  final int maxGamesToShow;

  final AsyncValue<IList<(DateTime, OfflineCorrespondenceGame)>> offlineCorresGames;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return offlineCorresGames.maybeWhen(
      data: (data) {
        if (data.isEmpty) {
          return const SizedBox.shrink();
        }
        return GamesCarousel(
          list: data,
          onTap: (index) {
            final el = data[index];
            Navigator.of(context, rootNavigator: true).push(
              OfflineCorrespondenceGameScreen.buildRoute(context, initialGame: (el.$1, el.$2)),
            );
          },
          builder:
              (el) => OngoingGameCarouselItem(
                game: OngoingGame(
                  id: el.$2.id,
                  fullId: el.$2.fullId,
                  orientation: el.$2.orientation,
                  fen: el.$2.lastPosition.fen,
                  perf: el.$2.perf,
                  speed: el.$2.speed,
                  variant: el.$2.variant,
                  opponent: el.$2.opponent!.user,
                  isMyTurn: el.$2.isMyTurn,
                  opponentRating: el.$2.opponent!.rating,
                  opponentAiLevel: el.$2.opponent!.aiLevel,
                  lastMove: el.$2.lastMove,
                  secondsLeft: el.$2.myTimeLeft(el.$1)?.inSeconds,
                ),
              ),
          moreScreenRouteBuilder: OfflineCorrespondenceGamesScreen.buildRoute,
          maxGamesToShow: maxGamesToShow,
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _OngoingGamesPreview extends ConsumerWidget {
  const _OngoingGamesPreview(this.games, {required this.maxGamesToShow});

  final AsyncValue<IList<OngoingGame>> games;
  final int maxGamesToShow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return games.maybeWhen(
      data: (data) {
        return PreviewGameList(
          list: data,
          maxGamesToShow: maxGamesToShow,
          builder: (el) => OngoingGamePreview(game: el),
          moreScreenRouteBuilder: OngoingGamesScreen.buildRoute,
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _OfflineCorrespondencePreview extends ConsumerWidget {
  const _OfflineCorrespondencePreview(this.offlineCorresGames, {required this.maxGamesToShow});

  final int maxGamesToShow;

  final AsyncValue<IList<(DateTime, OfflineCorrespondenceGame)>> offlineCorresGames;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return offlineCorresGames.maybeWhen(
      data: (data) {
        return PreviewGameList(
          list: data,
          maxGamesToShow: maxGamesToShow,
          builder: (el) => OfflineCorrespondenceGamePreview(game: el.$2, lastModified: el.$1),
          moreScreenRouteBuilder: OfflineCorrespondenceGamesScreen.buildRoute,
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
    required this.moreScreenRouteBuilder,
    required this.maxGamesToShow,
  });
  final IList<T> list;
  final Widget Function(T data) builder;
  final Route<dynamic> Function(BuildContext) moreScreenRouteBuilder;
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
          padding: Styles.horizontalBodyPadding.add(const EdgeInsets.only(top: 16.0)),
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
                    Navigator.of(context).push(moreScreenRouteBuilder(context));
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
      data:
          (connectivity) => AppBarIconButton(
            icon: const Icon(Icons.group_outlined),
            semanticsLabel: context.l10n.players,
            onPressed:
                !connectivity.isOnline
                    ? null
                    : () {
                      Navigator.of(context).push(PlayerScreen.buildRoute(context));
                    },
          ),
      orElse:
          () => AppBarIconButton(
            icon: const Icon(Icons.group_outlined),
            semanticsLabel: context.l10n.players,
            onPressed: null,
          ),
    );
  }
}

class _ChallengeScreenButton extends ConsumerWidget {
  const _ChallengeScreenButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);

    if (session == null) {
      return const SizedBox.shrink();
    }

    final connectivity = ref.watch(connectivityChangesProvider);
    final challenges = ref.watch(challengesProvider);
    final count = challenges.valueOrNull?.inward.length;

    return connectivity.maybeWhen(
      data:
          (connectivity) => AppBarNotificationIconButton(
            icon: const Icon(LichessIcons.crossed_swords, size: 18.0),
            semanticsLabel: context.l10n.preferencesNotifyChallenge,
            onPressed:
                !connectivity.isOnline
                    ? null
                    : () {
                      ref.invalidate(challengesProvider);
                      Navigator.of(context).push(ChallengeRequestsScreen.buildRoute(context));
                    },
            count: count ?? 0,
          ),
      orElse:
          () => AppBarIconButton(
            icon: const Icon(LichessIcons.crossed_swords, size: 18.0),
            semanticsLabel: context.l10n.preferencesNotifyChallenge,
            onPressed: null,
          ),
    );
  }
}
