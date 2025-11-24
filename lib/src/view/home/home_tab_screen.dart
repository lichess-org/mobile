import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/account/home_preferences.dart';
import 'package:lichess_mobile/src/model/account/home_widgets.dart';
import 'package:lichess_mobile/src/model/account/ongoing_game.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/blog/blog.dart';
import 'package:lichess_mobile/src/model/blog/blog_repository.dart';
import 'package:lichess_mobile/src/model/challenge/challenges.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_game_storage.dart';
import 'package:lichess_mobile/src/model/correspondence/offline_correspondence_game.dart';
import 'package:lichess_mobile/src/model/game/game_history.dart';
import 'package:lichess_mobile/src/model/game/game_storage.dart';
import 'package:lichess_mobile/src/model/message/message_repository.dart';
import 'package:lichess_mobile/src/model/tournament/tournament.dart';
import 'package:lichess_mobile/src/model/tournament/tournament_providers.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart';
import 'package:lichess_mobile/src/utils/focus_detector.dart';
import 'package:lichess_mobile/src/utils/image.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/account/account_drawer.dart';
import 'package:lichess_mobile/src/view/account/profile_screen.dart';
import 'package:lichess_mobile/src/view/correspondence/offline_correspondence_game_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen_providers.dart';
import 'package:lichess_mobile/src/view/game/offline_correspondence_games_screen.dart';
import 'package:lichess_mobile/src/view/home/blog_carousel.dart';
import 'package:lichess_mobile/src/view/home/games_carousel.dart';
import 'package:lichess_mobile/src/view/message/conversation_screen.dart';
import 'package:lichess_mobile/src/view/play/ongoing_games_screen.dart';
import 'package:lichess_mobile/src/view/play/play_bottom_sheet.dart';
import 'package:lichess_mobile/src/view/play/play_menu.dart';
import 'package:lichess_mobile/src/view/play/quick_game_matrix.dart';
import 'package:lichess_mobile/src/view/tournament/tournament_list_screen.dart';
import 'package:lichess_mobile/src/view/user/challenge_requests_screen.dart';
import 'package:lichess_mobile/src/view/user/player_screen.dart';
import 'package:lichess_mobile/src/view/user/recent_games.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/haptic_refresh_indicator.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeTabScreen extends ConsumerStatefulWidget {
  const HomeTabScreen({super.key, this.editModeEnabled = false});

  final bool editModeEnabled;

  static Route<dynamic> buildRoute(BuildContext context, {bool editModeEnabled = false}) {
    return buildScreenRoute(context, screen: HomeTabScreen(editModeEnabled: editModeEnabled));
  }

  @override
  ConsumerState<HomeTabScreen> createState() => _HomeScreenState();
}

class _IsEditingHome extends InheritedWidget {
  const _IsEditingHome({required super.child, required this.isEditingWidgets});

  final bool isEditingWidgets;

  @override
  bool updateShouldNotify(_IsEditingHome oldWidget) {
    return isEditingWidgets != oldWidget.isEditingWidgets;
  }

  static _IsEditingHome? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_IsEditingHome>();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isEditingWidgets', isEditingWidgets));
  }
}

class _HomeScreenState extends ConsumerState<HomeTabScreen> {
  ImageColorWorker? _worker;
  bool _imageAreCached = false;
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  DateTime? _focusLostAt;

  bool wasOnline = true;
  bool hasRefreshed = false;

  @override
  void initState() {
    super.initState();
    _precacheImages();

    showWelcomeMessage();
  }

  Future<void> _precacheImages() async {
    final worker = await ref.read(imageWorkerFactoryProvider).spawn();
    if (mounted) {
      setState(() {
        _worker = worker;
      });
      ref.listenManual(blogCarouselProvider, (_, current) async {
        if (current.hasValue && !_imageAreCached) {
          _imageAreCached = true;
          await preCacheBlogImages(context, posts: current.value!, worker: worker);
        }
      });
    }
  }

  Future<bool> shouldDisplayWelcomeMessage() async {
    if (LichessBinding.instance.sharedPreferences.getBool('app_welcome_message_shown') == true) {
      return false;
    }

    if (ref.read(authSessionProvider) != null) {
      return false;
    }

    final hasPlayedGames =
        await (await ref.read(gameStorageProvider.future)).count(userId: null) > 0;

    return !hasPlayedGames;
  }

  Future<void> showWelcomeMessage() async {
    final prefs = LichessBinding.instance.sharedPreferences;
    if (await shouldDisplayWelcomeMessage()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final context = ref.read(currentNavigatorKeyProvider).currentContext;
        if (context == null || !context.mounted) return;
        showDialog<void>(
          context: context,
          builder: (context) => AlertDialog.adaptive(
            content: Container(
              color:
                  DialogTheme.of(context).backgroundColor ??
                  ColorScheme.of(context).surfaceContainerHigh,
              padding: const EdgeInsets.all(8.0),
              child: Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${context.l10n.mobileWelcomeToLichessApp}\n\n',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextSpan(
                      text: context.l10n.mobileNotAllFeaturesAreAvailable,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              PlatformDialogAction(
                child: Text(context.l10n.ok),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ).then((_) {
          prefs.setBool('app_welcome_message_shown', true);
        });
      });
    }
  }

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

    return connectivity.when(
      skipLoadingOnReload: true,
      data: (status) {
        final session = ref.watch(authSessionProvider);
        final unreadLichessMessage = ref.watch(unreadMessagesProvider).value?.lichess == true;
        final ongoingGames = ref.watch(ongoingGamesProvider);
        final offlineCorresGames = ref.watch(offlineOngoingCorrespondenceGamesProvider);
        final recentGames = ref.watch(myRecentGamesProvider);
        final nbOfGames = ref.watch(userNumberOfGamesProvider(null)).value ?? 0;
        final isTablet = isTabletOrLarger(context);
        final featuredTournaments = status.isOnline
            ? ref.watch(featuredTournamentsProvider)
            : const AsyncValue.data(IListConst<LightTournament>([]));
        final blogPosts = status.isOnline
            ? ref.watch(blogCarouselProvider)
            : const AsyncValue.data(IListConst<BlogPost>([]));

        // Show the welcome screen if not logged in and there are no recent games and no stored games
        // (i.e. first installation, or the user has never played a game)
        final shouldShowWelcomeScreen =
            session == null &&
            recentGames.maybeWhen(data: (data) => data.isEmpty, orElse: () => false);

        List<Widget> widgets;

        if (shouldShowWelcomeScreen) {
          final welcomeWidgets = [
            const _GreetingWidget(),
            Padding(
              padding: Styles.bodySectionPadding,
              child: LichessMessage(style: TextTheme.of(context).bodyLarge),
            ),
            const SizedBox(height: 8.0),
            if (session == null) ...[
              const Center(child: _SignInWidget()),
              const SizedBox(height: 16.0),
            ],
            if (Theme.of(context).platform != TargetPlatform.iOS &&
                (session == null || session.user.isPatron != true)) ...[
              Center(
                child: FilledButton.tonal(
                  onPressed: () {
                    launchUrl(Uri.parse('https://lichess.org/patron'));
                  },
                  child: Text(context.l10n.patronDonate),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
            Center(
              child: FilledButton.tonal(
                onPressed: () {
                  launchUrl(Uri.parse('https://lichess.org/about'));
                },
                child: Text(context.l10n.aboutX('Lichess...')),
              ),
            ),
          ];

          widgets = [
            if (isTablet)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...welcomeWidgets,
                        const SizedBox(height: 32.0),
                        const _TabletCreateAGameSection(),
                      ],
                    ),
                  ),
                  Expanded(child: FeaturedTournamentsWidget(featured: featuredTournaments)),
                ],
              )
            else ...[
              ...welcomeWidgets,
              if (status.isOnline)
                const _EditableWidget(
                  widget: HomeEditableWidget.quickPairing,
                  shouldShow: true,
                  child: Padding(padding: Styles.bodySectionPadding, child: QuickGameMatrix()),
                ),
              _EditableWidget(
                widget: HomeEditableWidget.featuredTournaments,
                shouldShow: status.isOnline,
                child: FeaturedTournamentsWidget(featured: featuredTournaments),
              ),
              if (_worker != null)
                _EditableWidget(
                  widget: HomeEditableWidget.blogCarousel,
                  shouldShow: status.isOnline,
                  child: _BlogCarouselWidget(blogPosts, _worker!),
                ),
            ],
          ];
        } else if (isTablet) {
          widgets = [
            const _EditableWidget(
              widget: HomeEditableWidget.hello,
              shouldShow: true,
              child: _GreetingWidget(),
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
                      FeaturedTournamentsWidget(featured: featuredTournaments),
                      if (_worker != null)
                        _EditableWidget(
                          widget: HomeEditableWidget.blogCarousel,
                          shouldShow: status.isOnline,
                          child: _BlogCarouselWidget(blogPosts, _worker!),
                        ),
                      RecentGamesWidget(recentGames: recentGames, nbOfGames: nbOfGames, user: null),
                    ],
                  ),
                ),
              ],
            ),
          ];
        } else {
          final hasOngoingGames =
              (status.isOnline &&
                  ongoingGames.maybeWhen(data: (data) => data.isNotEmpty, orElse: () => false)) ||
              (!status.isOnline &&
                  offlineCorresGames.maybeWhen(
                    data: (data) => data.isNotEmpty,
                    orElse: () => false,
                  ));
          widgets = [
            const _EditableWidget(
              widget: HomeEditableWidget.hello,
              shouldShow: true,
              child: _GreetingWidget(),
            ),
            _EditableWidget(
              widget: HomeEditableWidget.perfCards,
              shouldShow: session != null && status.isOnline,
              child: AccountPerfCards(
                padding: Styles.horizontalBodyPadding.add(Styles.sectionBottomPadding),
              ),
            ),
            _EditableWidget(
              widget: HomeEditableWidget.quickPairing,
              shouldShow: status.isOnline,
              child: const Padding(padding: Styles.bodySectionPadding, child: QuickGameMatrix()),
            ),
            _EditableWidget(
              widget: HomeEditableWidget.ongoingGames,
              shouldShow: hasOngoingGames,
              child: status.isOnline
                  ? _OngoingGamesCarousel(ongoingGames, maxGamesToShow: 20)
                  : _OfflineCorrespondenceCarousel(offlineCorresGames, maxGamesToShow: 20),
            ),
            _EditableWidget(
              widget: HomeEditableWidget.featuredTournaments,
              shouldShow: status.isOnline,
              child: FeaturedTournamentsWidget(featured: featuredTournaments),
            ),
            if (_worker != null)
              _EditableWidget(
                widget: HomeEditableWidget.blogCarousel,
                shouldShow: status.isOnline,
                child: _BlogCarouselWidget(blogPosts, _worker!),
              ),
            _EditableWidget(
              widget: HomeEditableWidget.recentGames,
              shouldShow: true,
              child: RecentGamesWidget(recentGames: recentGames, nbOfGames: nbOfGames, user: null),
            ),
          ];
        }

        final content = ListView(
          controller: homeScrollController,
          children: [if (unreadLichessMessage) const _LichessMessageBanner(), ...widgets],
        );

        return FocusDetector(
          onFocusLost: () {
            _focusLostAt = DateTime.now();
          },
          onFocusRegained: () {
            if (context.mounted && _focusLostAt != null) {
              final duration = DateTime.now().difference(_focusLostAt!);
              if (duration.inSeconds < 10) {
                return;
              }
              _refreshData(isOnline: status.isOnline);
            }
          },
          child: _IsEditingHome(
            isEditingWidgets: widget.editModeEnabled,
            child: PlatformScaffold(
              appBar: widget.editModeEnabled
                  ? PlatformAppBar(
                      title: Text(context.l10n.mobileSettingsHomeWidgets),
                      leading: const BackButton(),
                      automaticallyImplyLeading: false,
                    )
                  : PlatformAppBar(
                      title: const AppBarLichessTitle(),
                      centerTitle: true,
                      leading: const AccountDrawerIconButton(),
                      actions: const [_ChallengeScreenButton(), _PlayerScreenButton()],
                    ),
              drawer: const AccountDrawer(),
              body: widget.editModeEnabled
                  ? content
                  : HapticRefreshIndicator(
                      edgeOffset: Theme.of(context).platform == TargetPlatform.iOS
                          ? MediaQuery.paddingOf(context).top + kToolbarHeight
                          : 0.0,
                      key: _refreshKey,
                      onRefresh: () => _refreshData(isOnline: status.isOnline),
                      child: content,
                    ),
              bottomNavigationBar: widget.editModeEnabled
                  ? BottomAppBar(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    )
                  : null,
              floatingActionButton: widget.editModeEnabled || isTablet
                  ? null
                  : const FloatingPlayButton(),
              bottomSheet: widget.editModeEnabled ? null : const OfflineBanner(),
            ),
          ),
        );
      },
      error: (_, _) => const CenterLoadingIndicator(),
      loading: () => const CenterLoadingIndicator(),
    );
  }

  Future<void> _refreshData({required bool isOnline}) {
    return Future.wait([
      ref.refresh(myRecentGamesProvider.future),
      if (isOnline) ref.refresh(challengesProvider.future),
      if (isOnline) ref.refresh(unreadMessagesProvider.future),
      if (isOnline) ref.refresh(accountProvider.future),
      if (isOnline) ref.refresh(ongoingGamesProvider.future),
      if (isOnline) ref.refresh(featuredTournamentsProvider.future),
    ]);
  }
}

class _LichessMessageBanner extends ConsumerWidget {
  const _LichessMessageBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(
              ConversationScreen.buildRoute(
                context,
                user: const LightUser(id: UserId('lichess'), name: 'lichess'),
              ),
            )
            .then((_) => ref.invalidate(unreadMessagesProvider));
      },
      child: ColoredBox(
        color: theme.colorScheme.tertiaryContainer,
        child: Padding(
          padding: Styles.bodyPadding,
          child: Column(
            children: [
              Text(
                context.l10n.showUnreadLichessMessage,
                style: TextStyle(
                  color: theme.colorScheme.onTertiaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                context.l10n.clickHereToReadIt,
                style: TextStyle(color: theme.colorScheme.onTertiaryContainer),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignInWidget extends ConsumerWidget {
  const _SignInWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(authControllerProvider);

    return FilledButton(
      onPressed: authController.isLoading
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
  const _EditableWidget({required this.child, required this.widget, required this.shouldShow});

  final Widget child;
  final HomeEditableWidget widget;
  final bool shouldShow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final disabledWidgets = ref.watch(homePreferencesProvider).disabledWidgets;
    final isEditing = _IsEditingHome.maybeOf(context)?.isEditingWidgets ?? false;
    final isEnabled = !disabledWidgets.contains(widget);

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
                    Checkbox.adaptive(
                      value: isEnabled,
                      onChanged: widget.alwaysEnabled
                          ? null
                          : (_) {
                              ref.read(homePreferencesProvider.notifier).toggleWidget(widget);
                            },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: IgnorePointer(ignoring: isEditing, child: child),
              ),
            ],
          )
        : widget.alwaysEnabled || isEnabled
        ? child
        : const SizedBox.shrink();
  }
}

class _IsDayTimeNotifier extends Notifier<bool> {
  Timer? _timer;

  @override
  bool build() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      ref.invalidateSelf();
    });

    ref.onDispose(() {
      _timer?.cancel();
    });

    final hour = DateTime.now().hour;
    return hour >= 6 && hour < 18; // Daytime is between 6 AM and 6 PM
  }
}

final _isDayTimeProvider = NotifierProvider.autoDispose<_IsDayTimeNotifier, bool>(
  _IsDayTimeNotifier.new,
  name: '_isDayTimeProvider',
);

class _GreetingWidget extends ConsumerWidget {
  const _GreetingWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    final isDayTime = ref.watch(_isDayTimeProvider);
    final style = TextTheme.of(context).bodyLarge;

    const iconSize = 24.0;

    final user = session?.user;

    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.3,
      child: Padding(
        padding: Styles.bodyPadding,
        child: GestureDetector(
          onTap: () {
            ref.invalidate(accountProvider);
            Navigator.of(context).push(ProfileScreen.buildRoute(context));
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isDayTime ? '☀️' : '🌙',
                style: const TextStyle(fontSize: iconSize, height: 1.0),
              ),
              const SizedBox(width: 5.0),
              if (user != null)
                Flexible(
                  child: l10nWithWidget(
                    isDayTime ? context.l10n.mobileGoodDay : context.l10n.mobileGoodEvening,
                    Text(user.name, style: style),
                    textStyle: style,
                  ),
                )
              else
                Flexible(
                  child: Text(
                    isDayTime
                        ? context.l10n.mobileGoodDayWithoutName
                        : context.l10n.mobileGoodEveningWithoutName,
                    style: style,
                  ),
                ),
            ],
          ),
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
        PlayMenu(),
      ],
    );
  }
}

class _BlogCarouselWidget extends ConsumerWidget {
  const _BlogCarouselWidget(this.posts, this.worker);

  final AsyncValue<IList<BlogPost>> posts;
  final ImageColorWorker worker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: Styles.verticalBodyPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: Styles.horizontalBodyPadding,
            child: ListSectionHeader(title: Text(context.l10n.blog)),
          ),
          switch (posts) {
            AsyncData(:final value) => BlogCarousel(posts: value, worker: worker),
            AsyncError() => const Padding(
              padding: Styles.bodySectionPadding,
              child: Text('Could not load blog posts.'),
            ),
            _ => Shimmer(
              child: ShimmerLoading(isLoading: true, child: BlogCarousel.loading(worker: worker)),
            ),
          },
        ],
      ),
    );
  }
}

class _OngoingGamesCarousel extends ConsumerWidget {
  const _OngoingGamesCarousel(this.games, {required this.maxGamesToShow});

  final AsyncValue<IList<OngoingGame>> games;

  final int maxGamesToShow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (games) {
      case AsyncData(:final value):
        if (value.isEmpty) {
          return const SizedBox.shrink();
        }
        final realTime = value.where((game) => game.isRealTime);
        final correspondence = value.where((game) => !game.isRealTime);
        final list = [...realTime, ...correspondence].lock;
        return GamesCarousel<OngoingGame>(
          list: list,
          onTap: (index) {
            final game = list[index];
            Navigator.of(context, rootNavigator: true).push(
              GameScreen.buildRoute(
                context,
                source: ExistingGameSource(game.fullId),
                loadingPosition: (
                  fen: game.fen,
                  orientation: game.orientation,
                  lastMove: game.lastMove,
                ),
              ),
            );
          },
          builder: (game) => OngoingGameCarouselItem(game: game),
          moreScreenRouteBuilder: OngoingGamesScreen.buildRoute,
          maxGamesToShow: maxGamesToShow,
        );
      case _:
        return const SizedBox.shrink();
    }
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
          builder: (el) => OngoingGameCarouselItem(
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
    switch (games) {
      case AsyncData(:final value):
        if (value.isEmpty) {
          return const SizedBox.shrink();
        }
        final realTime = value.where((game) => game.isRealTime);
        final correspondence = value.where((game) => !game.isRealTime);
        final list = [...realTime, ...correspondence].lock;

        return PreviewGameList(
          list: list,
          maxGamesToShow: maxGamesToShow,
          builder: (el) =>
              OngoingGamePreview(game: el, padding: const EdgeInsets.symmetric(vertical: 8.0)),
          moreScreenRouteBuilder: OngoingGamesScreen.buildRoute,
        );
      case _:
        return const SizedBox.shrink();
    }
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

    return Padding(
      padding: Styles.horizontalBodyPadding.add(Styles.sectionTopPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListSectionHeader(
            title: Text(context.l10n.nbGamesInPlay(list.length)),
            onTap: list.length > maxGamesToShow
                ? () {
                    Navigator.of(context).push(moreScreenRouteBuilder(context));
                  }
                : null,
          ),
          for (final data in list.take(maxGamesToShow)) builder(data),
        ],
      ),
    );
  }
}

class _PlayerScreenButton extends ConsumerWidget {
  const _PlayerScreenButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityChangesProvider);

    return connectivity.maybeWhen(
      data: (connectivity) => SemanticIconButton(
        icon: const Icon(Icons.group_outlined),
        semanticsLabel: context.l10n.players,
        onPressed: !connectivity.isOnline
            ? null
            : () {
                Navigator.of(context).push(PlayerScreen.buildRoute(context));
              },
      ),
      orElse: () => SemanticIconButton(
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

    final inwardCount = challenges.value?.inward.length ?? 0;
    final outwardCount = challenges.value?.outward.length ?? 0;

    if (inwardCount == 0 && outwardCount == 0) {
      return const SizedBox.shrink();
    }

    return switch (connectivity) {
      AsyncData(:final value) => SemanticIconButton(
        icon: Badge.count(
          count: inwardCount,
          isLabelVisible: inwardCount > 0,
          child: const Icon(LichessIcons.crossed_swords, size: 18.0),
        ),
        semanticsLabel: context.l10n.preferencesNotifyChallenge,
        onPressed: !value.isOnline
            ? null
            : () {
                ref.invalidate(challengesProvider);
                Navigator.of(context).push(ChallengeRequestsScreen.buildRoute(context));
              },
      ),
      _ => SemanticIconButton(
        icon: const Icon(LichessIcons.crossed_swords, size: 18.0),
        semanticsLabel: context.l10n.preferencesNotifyChallenge,
        onPressed: null,
      ),
    };
  }
}
