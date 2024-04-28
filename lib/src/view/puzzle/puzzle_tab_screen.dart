import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart'
    hide CupertinoPageScaffold, CupertinoSliverNavigationBar;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/puzzle_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/connectivity.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/layout.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/view/puzzle/dashboard_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_history_screen.dart';
import 'package:lichess_mobile/src/view/settings/settings_button.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/cupertino.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

import 'puzzle_screen.dart';
import 'puzzle_themes_screen.dart';
import 'storm_screen.dart';
import 'streak_screen.dart';

class PuzzleTabScreen extends ConsumerStatefulWidget {
  const PuzzleTabScreen({super.key});

  @override
  ConsumerState<PuzzleTabScreen> createState() => _PuzzleTabScreenState();
}

class _PuzzleTabScreenState extends ConsumerState<PuzzleTabScreen> {
  final _androidRefreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authSessionProvider);
    return PlatformWidget(
      androidBuilder: (context) => _androidBuilder(context, session),
      iosBuilder: (context) => _iosBuilder(context, session),
    );
  }

  Widget _androidBuilder(BuildContext context, AuthSessionState? userSession) {
    final body = Column(
      children: [
        Expanded(
          child: _Body(userSession),
        ),
        const ConnectivityBanner(),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.puzzles),
        actions: const [
          SettingsButton(),
          _DashboardButton(),
        ],
      ),
      body: userSession != null
          ? RefreshIndicator(
              key: _androidRefreshKey,
              onRefresh: _refreshData,
              child: body,
            )
          : body,
    );
  }

  Widget _iosBuilder(BuildContext context, AuthSessionState? userSession) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        controller: puzzlesScrollController,
        slivers: [
          CupertinoSliverNavigationBar(
            padding: const EdgeInsetsDirectional.only(
              start: 16.0,
              end: 8.0,
            ),
            largeTitle: Text(context.l10n.puzzles),
            trailing: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SettingsButton(),
                _DashboardButton(),
              ],
            ),
          ),
          if (userSession != null)
            CupertinoSliverRefreshControl(
              onRefresh: _refreshData,
            ),
          const SliverToBoxAdapter(child: ConnectivityBanner()),
          SliverSafeArea(
            top: false,
            sliver: _Body(userSession),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshData() {
    return Future.wait([
      ref.refresh(puzzleRecentActivityProvider.future),
    ]);
  }
}

class _Body extends ConsumerWidget {
  const _Body(this.session);

  final AuthSessionState? session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityChangesProvider);

    final isTablet = getScreenType(context) == ScreenType.tablet;

    final handsetChildren = [
      const SizedBox(height: 8.0),
      connectivity.when(
        data: (data) => data.isOnline
            ? const _DailyPuzzle()
            : const _OfflinePuzzlePreview(),
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
      if (Theme.of(context).platform == TargetPlatform.android)
        const SizedBox(height: 8.0),
      PuzzleMenu(connectivity: connectivity),
      PuzzleHistoryWidget(),
    ];

    final tabletChildren = [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                connectivity.when(
                  data: (data) => data.isOnline
                      ? const _DailyPuzzle()
                      : const _OfflinePuzzlePreview(),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                PuzzleMenu(connectivity: connectivity),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                PuzzleHistoryWidget(),
              ],
            ),
          ),
        ],
      ),
    ];

    final children = isTablet ? tabletChildren : handsetChildren;

    return Theme.of(context).platform == TargetPlatform.iOS
        ? SliverList(delegate: SliverChildListDelegate.fixed(children))
        : ListView(
            controller: puzzlesScrollController,
            children: children,
          );
  }
}

class PuzzleMenu extends StatelessWidget {
  const PuzzleMenu({required this.connectivity, super.key});

  final AsyncValue<ConnectivityStatus> connectivity;

  @override
  Widget build(BuildContext context) {
    final topPadding = Theme.of(context).platform == TargetPlatform.iOS
        ? const EdgeInsets.only(top: 8.0)
        : EdgeInsets.zero;

    final titleStyle = Theme.of(context).platform == TargetPlatform.iOS
        ? null
        : Theme.of(context).textTheme.titleMedium;

    return ListSection(
      hasLeading: true,
      children: [
        PlatformListTile(
          leading: Icon(
            LichessIcons.target,
            size: 32,
            color: context.lichessColors.good,
          ),
          title: Padding(
            padding: topPadding,
            child: Text(context.l10n.puzzlePuzzles, style: titleStyle),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(context.l10n.puzzleDesc, maxLines: 3),
          ),
          trailing: Theme.of(context).platform == TargetPlatform.iOS
              ? const CupertinoListTileChevron()
              : null,
          onTap: () {
            pushPlatformRoute(
              context,
              title: context.l10n.puzzleDesc,
              rootNavigator: true,
              builder: (context) =>
                  const PuzzleScreen(angle: PuzzleTheme(PuzzleThemeKey.mix)),
            );
          },
        ),
        PlatformListTile(
          leading: Icon(
            PuzzleIcons.opening,
            size: 32,
            color: context.lichessColors.primary,
          ),
          title: Padding(
            padding: topPadding,
            child: Text(context.l10n.puzzlePuzzleThemes, style: titleStyle),
          ),
          subtitle: const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Play puzzles from your favorite openings, or choose a theme.',
              maxLines: 3,
            ),
          ),
          trailing: Theme.of(context).platform == TargetPlatform.iOS
              ? const CupertinoListTileChevron()
              : null,
          isThreeLine: true,
          onTap: () {
            pushPlatformRoute(
              context,
              title: context.l10n.puzzlePuzzleThemes,
              rootNavigator: true,
              builder: (context) => const PuzzleThemesScreen(),
            );
          },
        ),
        PlatformListTile(
          leading: Icon(
            LichessIcons.streak,
            size: 32,
            color: context.lichessColors.fancy,
          ),
          title: Padding(
            padding: topPadding,
            child: Text('Puzzle Streak', style: titleStyle),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              context.l10n.puzzleStreakDescription.characters
                      .takeWhile((c) => c != '.')
                      .toString() +
                  (context.l10n.puzzleStreakDescription.contains('.')
                      ? '.'
                      : ''),
              maxLines: 3,
            ),
          ),
          trailing: Theme.of(context).platform == TargetPlatform.iOS
              ? const CupertinoListTileChevron()
              : null,
          isThreeLine: true,
          onTap: connectivity.when(
            data: (data) => data.isOnline
                ? () {
                    pushPlatformRoute(
                      context,
                      rootNavigator: true,
                      builder: (context) => const StreakScreen(),
                    );
                  }
                : null,
            loading: () => null,
            error: (_, __) => null,
          ),
        ),
        PlatformListTile(
          leading: Icon(
            LichessIcons.storm,
            size: 32,
            color: context.lichessColors.purple,
          ),
          title: Padding(
            padding: topPadding,
            child: Text('Puzzle Storm', style: titleStyle),
          ),
          subtitle: const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Solve as many puzzles as possible in 3 minutes.',
              maxLines: 3,
            ),
          ),
          trailing: Theme.of(context).platform == TargetPlatform.iOS
              ? const CupertinoListTileChevron()
              : null,
          isThreeLine: true,
          onTap: connectivity.when(
            data: (data) => data.isOnline
                ? () {
                    pushPlatformRoute(
                      context,
                      rootNavigator: true,
                      builder: (context) => const StormScreen(),
                    );
                  }
                : null,
            loading: () => null,
            error: (_, __) => null,
          ),
        ),
      ],
    );
  }
}

class PuzzleHistoryWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(puzzleRecentActivityProvider);
    return asyncData.when(
      data: (recentActivity) {
        if (recentActivity == null) {
          return const SizedBox.shrink();
        }
        if (recentActivity.isEmpty) {
          return ListSection(
            header: Text(context.l10n.puzzleHistory),
            children: [
              Center(
                child: Text(context.l10n.puzzleNoPuzzlesToShow),
              ),
            ],
          );
        }

        return ListSection(
          header: Text(context.l10n.puzzleHistory),
          headerTrailing: NoPaddingTextButton(
            onPressed: () => pushPlatformRoute(
              context,
              builder: (context) => PuzzleHistoryScreen(),
            ),
            child: Text(
              context.l10n.more,
            ),
          ),
          children: [
            Padding(
              padding: Styles.bodySectionPadding,
              child: PuzzleHistoryPreview(recentActivity.take(8).toIList()),
            ),
          ],
        );
      },
      error: (e, s) {
        debugPrint(
          'SEVERE: [PuzzleHistoryWidget] could not load puzzle history',
        );
        return Padding(
          padding: Styles.bodySectionPadding,
          child: const Text('Could not load Puzzle history.'),
        );
      },
      loading: () => Shimmer(
        child: ShimmerLoading(
          isLoading: true,
          child: ListSection.loading(
            itemsNumber: 5,
            header: true,
          ),
        ),
      ),
    );
  }
}

class _DashboardButton extends ConsumerWidget {
  const _DashboardButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    if (session != null) {
      switch (Theme.of(context).platform) {
        case TargetPlatform.iOS:
          return CupertinoIconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              ref.invalidate(puzzleDashboardProvider);
              _showDashboard(context, session);
            },
            semanticsLabel: context.l10n.puzzlePuzzleDashboard,
            icon: const Icon(Icons.history),
          );
        case TargetPlatform.android:
          return IconButton(
            tooltip: context.l10n.puzzlePuzzleDashboard,
            onPressed: () {
              ref.invalidate(puzzleDashboardProvider);
              _showDashboard(context, session);
            },
            icon: const Icon(Icons.history),
          );
        default:
          assert(false, 'Unexpected platform $Theme.of(context).platform');
          return const SizedBox.shrink();
      }
    }
    return const SizedBox.shrink();
  }

  void _showDashboard(BuildContext context, AuthSessionState session) =>
      pushPlatformRoute(
        context,
        title: context.l10n.puzzlePuzzleDashboard,
        builder: (_) => const PuzzleDashboardScreen(),
      );
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.puzzlePuzzleOfTheDay,
                    style: Styles.boardPreviewTitle,
                  ),
                  Text(
                    context.l10n
                        .puzzlePlayedXTimes(data.puzzle.plays)
                        .localizeNumbers(),
                  ),
                ],
              ),
              Icon(
                Icons.today,
                size: 34,
                color:
                    DefaultTextStyle.of(context).style.color?.withOpacity(0.6),
              ),
              Text(
                data.puzzle.initialPly.isOdd
                    ? context.l10n.whitePlays
                    : context.l10n.blackPlays,
              ),
            ],
          ),
          onTap: () {
            if (!context.mounted) return;
            final session = ref.read(authSessionProvider);
            pushPlatformRoute(
              context,
              rootNavigator: true,
              builder: (context) => PuzzleScreen(
                angle: const PuzzleTheme(PuzzleThemeKey.mix),
                initialPuzzleContext: PuzzleContext(
                  angle: const PuzzleTheme(PuzzleThemeKey.mix),
                  puzzle: data,
                  userId: session?.user.id,
                ),
              ),
            );
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
    final puzzle =
        ref.watch(nextPuzzleProvider(const PuzzleTheme(PuzzleThemeKey.mix)));
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
              Text(
                context.l10n.puzzleDesc,
                style: Styles.boardPreviewTitle,
              ),
              Text(
                context.l10n
                    .puzzlePlayedXTimes(data?.puzzle.puzzle.plays ?? 0)
                    .localizeNumbers(),
              ),
            ],
          ),
          onTap: data != null
              ? () {
                  pushPlatformRoute(
                    context,
                    rootNavigator: true,
                    builder: (context) => PuzzleScreen(
                      angle: const PuzzleTheme(PuzzleThemeKey.mix),
                      initialPuzzleContext: data,
                    ),
                  ).then((_) {
                    if (context.mounted) {
                      ref.invalidate(
                        nextPuzzleProvider(
                          const PuzzleTheme(PuzzleThemeKey.mix),
                        ),
                      );
                    }
                  });
                }
              : null,
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
