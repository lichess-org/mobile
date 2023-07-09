import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/connectivity.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/bottom_navigation.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/model/settings/play_preferences.dart';
import 'package:lichess_mobile/src/view/auth/sign_in_widget.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/view/user/leaderboard_widget.dart';
import 'package:lichess_mobile/src/view/play/play_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';

final RouteObserver<PageRoute<void>> homeRouteObserver =
    RouteObserver<PageRoute<void>>();

final isHomeRootProvider = StateProvider<bool>((ref) => true);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with RouteAware {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: const [
          SignInWidget(),
        ],
      ),
      body: RefreshIndicator(
        key: _androidRefreshKey,
        onRefresh: _refreshData,
        child: const _HomeScaffold(
          child: _HomeBody(),
        ),
      ),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      child: _HomeScaffold(
        child: CustomScrollView(
          controller: homeScrollController,
          slivers: [
            const CupertinoSliverNavigationBar(
              largeTitle: Text('Home'),
              trailing: SignInWidget(),
            ),
            CupertinoSliverRefreshControl(
              onRefresh: _refreshData,
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
    return ref.refresh(top1Provider.future);
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
    return SafeArea(
      top: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: child,
          ),
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
              child: FatButton(
                semanticsLabel: context.l10n.play,
                child: Text(context.l10n.play),
                onPressed: () {
                  pushPlatformRoute(
                    context,
                    builder: (_) => const PlayScreen(),
                  );
                },
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
    return SafeArea(
      top: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: child,
          ),
          Material(
            color: navigationBarTheme.backgroundColor ?? colorScheme.surface,
            elevation: navigationBarTheme.elevation ?? 3.0,
            shadowColor: navigationBarTheme.shadowColor ?? Colors.transparent,
            surfaceTintColor:
                navigationBarTheme.surfaceTintColor ?? colorScheme.surfaceTint,
            child: SizedBox(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0)
                    .add(Styles.horizontalBodyPadding),
                child: FilledButton.tonal(
                  child: Text(context.l10n.play),
                  onPressed: () {
                    pushPlatformRoute(
                      context,
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
        if (data.isOnline) {
          return defaultTargetPlatform == TargetPlatform.android
              ? ListView(
                  controller: homeScrollController,
                  children: [
                    const _CreateAGame(),
                    const _DailyPuzzle(),
                    LeaderboardWidget(),
                  ],
                )
              : SliverList(
                  delegate: SliverChildListDelegate([
                    const _CreateAGame(),
                    const _DailyPuzzle(),
                    LeaderboardWidget(),
                  ]),
                );
        } else {
          return defaultTargetPlatform == TargetPlatform.android
              ? ListView(
                  controller: homeScrollController,
                  children: const [
                    _OfflinePuzzlePreview(),
                  ],
                )
              : SliverList(
                  delegate: SliverChildListDelegate([
                    const _OfflinePuzzlePreview(),
                  ]),
                );
        }
      },
      loading: () {
        const child = CenterLoadingIndicator();
        return defaultTargetPlatform == TargetPlatform.android
            ? child
            : const SliverToBoxAdapter(child: child);
      },
      error: (error, stack) {
        const child = SizedBox.shrink();
        return defaultTargetPlatform == TargetPlatform.android
            ? child
            : const SliverToBoxAdapter(child: child);
      },
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

class _CreateAGame extends ConsumerWidget {
  const _CreateAGame();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeControlPref = ref
        .watch(playPreferencesProvider.select((prefs) => prefs.timeIncrement));
    return SmallBoardPreview(
      orientation: Side.white.cg,
      fen: kInitialFEN,
      description: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            context.l10n.createAGame,
            style: Styles.boardPreviewTitle,
          ),
          Row(
            children: [
              Icon(
                timeControlPref.speed.icon,
                size: 20,
                color: DefaultTextStyle.of(context).style.color,
              ),
              const SizedBox(width: 5),
              Text(timeControlPref.display, style: Styles.timeControl),
            ],
          ),
        ],
      ),
      onTap: () {
        pushPlatformRoute(
          context,
          rootNavigator: true,
          builder: (BuildContext context) {
            return const GameScreen();
          },
        );
      },
    );
  }
}

class _DailyPuzzle extends ConsumerWidget {
  const _DailyPuzzle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzle = ref.watch(dailyPuzzleProvider);
    return puzzle.when(
      data: (data) {
        final preview = PuzzlePreview.fromPuzzle(data);
        return SmallBoardPreview(
          orientation: preview.orientation.cg,
          fen: preview.initialFen,
          lastMove: preview.initialMove.cg,
          description: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                context.l10n.puzzlePuzzleOfTheDay,
                style: Styles.boardPreviewTitle,
              ),
              Text(
                context.l10n.puzzlePlayedXTimes(data.puzzle.plays),
              ),
            ],
          ),
          onTap: () {
            final session = ref.read(authSessionProvider);
            pushPlatformRoute(
              context,
              rootNavigator: true,
              title: context.l10n.puzzleDailyPuzzle,
              builder: (context) => PuzzleScreen(
                theme: PuzzleTheme.mix,
                initialPuzzleContext: PuzzleContext(
                  theme: PuzzleTheme.mix,
                  puzzle: data,
                  userId: session?.user.id,
                ),
              ),
            ).then((_) {
              ref.invalidate(nextPuzzleProvider(PuzzleTheme.mix));
            });
          },
        );
      },
      loading: () => SmallBoardPreview(
        orientation: Side.white.cg,
        fen: kEmptyFen,
        description: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              context.l10n.puzzlePuzzleOfTheDay,
              style: Styles.boardPreviewTitle,
            ),
            const Text(''),
          ],
        ),
      ),
      error: (error, stack) => Padding(
        padding: Styles.bodySectionPadding,
        child: const Text('Could not load the daily puzzle.'),
      ),
    );
  }
}

class _OfflinePuzzlePreview extends ConsumerWidget {
  const _OfflinePuzzlePreview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzle = ref.watch(nextPuzzleProvider(PuzzleTheme.mix));
    return puzzle.maybeWhen(
      data: (data) {
        final preview =
            data != null ? PuzzlePreview.fromPuzzle(data.puzzle) : null;
        return SmallBoardPreview(
          orientation: preview?.orientation.cg ?? Side.white.cg,
          fen: preview?.initialFen ?? kEmptyFen,
          lastMove: preview?.initialMove.cg,
          description: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Puzzle training',
                style: Styles.boardPreviewTitle,
              ),
              Text(
                context.l10n.puzzlePlayedXTimes(data?.puzzle.puzzle.plays ?? 0),
              ),
            ],
          ),
          onTap: data != null
              ? () {
                  pushPlatformRoute(
                    context,
                    rootNavigator: true,
                    builder: (context) => PuzzleScreen(
                      theme: PuzzleTheme.mix,
                      initialPuzzleContext: data,
                    ),
                  ).then((_) {
                    ref.invalidate(nextPuzzleProvider(PuzzleTheme.mix));
                  });
                }
              : null,
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
