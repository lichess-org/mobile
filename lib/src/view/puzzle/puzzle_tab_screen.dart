import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/puzzle_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/connectivity.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/view/puzzle/dashboard_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_history_screen.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

import 'puzzle_screen.dart';
import 'puzzle_themes_screen.dart';
import 'storm_screen.dart';
import 'streak_screen.dart';

const _kNumberOfHistoryItemsOnHandset = 8;
const _kNumberOfHistoryItemsOnTablet = 16;

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
        const ConnectivityBanner(),
        Expanded(
          child: _Body(userSession),
        ),
      ],
    );

    final isTablet = isTabletOrLarger(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) {
        if (!didPop) {
          ref.read(currentBottomTabProvider.notifier).state = BottomTab.home;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.puzzles),
          actions: [
            const _DashboardButton(),
            if (!isTablet) const _HistoryButton(),
          ],
        ),
        body: userSession != null
            ? RefreshIndicator(
                key: _androidRefreshKey,
                onRefresh: _refreshData,
                child: body,
              )
            : body,
      ),
    );
  }

  Widget _iosBuilder(BuildContext context, AuthSessionState? userSession) {
    final isTablet = isTabletOrLarger(context);

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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _DashboardButton(),
                if (!isTablet) ...[
                  const SizedBox(width: 6.0),
                  const _HistoryButton(),
                ],
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

    final isTablet = isTabletOrLarger(context);

    final handsetChildren = [
      connectivity.whenOnline(
        online: () => const _DailyPuzzle(),
        offline: () => const SizedBox.shrink(),
      ),
      const SizedBox(height: 4.0),
      const _PuzzlePreview(),
      if (Theme.of(context).platform == TargetPlatform.android)
        const SizedBox(height: 8.0),
      _PuzzleMenu(connectivity: connectivity),
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
                connectivity.whenOnline(
                  online: () => const _DailyPuzzle(),
                  offline: () => const SizedBox.shrink(),
                ),
                _PuzzleMenu(connectivity: connectivity),
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

class _PuzzleMenuListTile extends StatelessWidget {
  const _PuzzleMenuListTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PlatformListTile(
      padding: Theme.of(context).platform == TargetPlatform.iOS
          ? const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0)
          : null,
      leading: Icon(
        icon,
        size: Styles.mainListTileIconSize,
        color: Theme.of(context).platform == TargetPlatform.iOS
            ? CupertinoTheme.of(context).primaryColor
            : Theme.of(context).colorScheme.primary,
      ),
      title: Text(title, style: Styles.mainListTileTitle),
      subtitle: Text(subtitle, maxLines: 3),
      trailing: Theme.of(context).platform == TargetPlatform.iOS
          ? const CupertinoListTileChevron()
          : null,
      onTap: onTap,
    );
  }
}

class _PuzzleMenu extends StatelessWidget {
  const _PuzzleMenu({required this.connectivity});

  final AsyncValue<ConnectivityStatus> connectivity;

  @override
  Widget build(BuildContext context) {
    final bool isOnline = connectivity.value?.isOnline ?? false;

    return ListSection(
      hasLeading: true,
      children: [
        _PuzzleMenuListTile(
          icon: PuzzleIcons.opening,
          title: context.l10n.puzzlePuzzleThemes,
          subtitle: context.l10n.mobilePuzzleThemesSubtitle,
          onTap: () {
            pushPlatformRoute(
              context,
              title: context.l10n.puzzlePuzzleThemes,
              rootNavigator: true,
              builder: (context) => const PuzzleThemesScreen(),
            );
          },
        ),
        Opacity(
          opacity: isOnline ? 1 : 0.5,
          child: _PuzzleMenuListTile(
            icon: LichessIcons.streak,
            title: 'Puzzle Streak',
            subtitle: context.l10n.puzzleStreakDescription.characters
                    .takeWhile((c) => c != '.')
                    .toString() +
                (context.l10n.puzzleStreakDescription.contains('.') ? '.' : ''),
            onTap: isOnline
                ? () {
                    pushPlatformRoute(
                      context,
                      rootNavigator: true,
                      builder: (context) => const StreakScreen(),
                    );
                  }
                : null,
          ),
        ),
        Opacity(
          opacity: isOnline ? 1 : 0.5,
          child: _PuzzleMenuListTile(
            icon: LichessIcons.storm,
            title: 'Puzzle Storm',
            subtitle: context.l10n.mobilePuzzleStormSubtitle,
            onTap: isOnline
                ? () {
                    pushPlatformRoute(
                      context,
                      rootNavigator: true,
                      builder: (context) => const StormScreen(),
                    );
                  }
                : null,
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
    final isTablet = isTabletOrLarger(context);
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 8.0,
                  ),
                  child: Text(context.l10n.puzzleNoPuzzlesToShow),
                ),
              ),
            ],
          );
        }

        final maxItems = isTablet
            ? _kNumberOfHistoryItemsOnTablet
            : _kNumberOfHistoryItemsOnHandset;

        return ListSection(
          cupertinoBackgroundColor:
              CupertinoTheme.of(context).scaffoldBackgroundColor,
          cupertinoClipBehavior: Clip.none,
          header: Text(context.l10n.puzzleHistory),
          headerTrailing: NoPaddingTextButton(
            onPressed: () => pushPlatformRoute(
              context,
              builder: (context) => const PuzzleHistoryScreen(),
            ),
            child: Text(
              context.l10n.more,
            ),
          ),
          children: [
            Padding(
              padding: Theme.of(context).platform == TargetPlatform.iOS
                  ? EdgeInsets.zero
                  : Styles.horizontalBodyPadding,
              child: PuzzleHistoryPreview(
                recentActivity.take(maxItems).toIList(),
                maxRows: 5,
              ),
            ),
          ],
        );
      },
      error: (e, s) {
        debugPrint(
          'SEVERE: [PuzzleHistoryWidget] could not load puzzle history',
        );
        return const Padding(
          padding: Styles.bodySectionPadding,
          child: Text('Could not load Puzzle history.'),
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
      return AppBarIconButton(
        icon: const Icon(Icons.assessment_outlined),
        semanticsLabel: context.l10n.puzzlePuzzleDashboard,
        onPressed: () {
          ref.invalidate(puzzleDashboardProvider);
          pushPlatformRoute(
            context,
            title: context.l10n.puzzlePuzzleDashboard,
            builder: (_) => const PuzzleDashboardScreen(),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }
}

class _HistoryButton extends ConsumerWidget {
  const _HistoryButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(puzzleRecentActivityProvider);
    return AppBarIconButton(
      icon: const Icon(Icons.history_outlined),
      semanticsLabel: context.l10n.puzzleHistory,
      onPressed: asyncData.maybeWhen(
        data: (_) => () {
          pushPlatformRoute(
            context,
            title: context.l10n.puzzleHistory,
            builder: (_) => const PuzzleHistoryScreen(),
          );
        },
        orElse: () => null,
      ),
    );
  }
}

TextStyle _puzzlePreviewSubtitleStyle(BuildContext context) {
  return TextStyle(
    fontSize: 14.0,
    color: DefaultTextStyle.of(context).style.color?.withValues(alpha: 0.6),
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
          orientation: preview.orientation,
          fen: preview.initialFen,
          lastMove: preview.initialMove,
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
                    style: _puzzlePreviewSubtitleStyle(context),
                  ),
                ],
              ),
              Icon(
                Icons.today,
                size: 34,
                color: DefaultTextStyle.of(context)
                    .style
                    .color
                    ?.withValues(alpha: 0.6),
              ),
              Text(
                data.puzzle.sideToMove == Side.white
                    ? context.l10n.whitePlays
                    : context.l10n.blackPlays,
              ),
            ],
          ),
          onTap: () {
            if (!context.mounted) return;
            pushPlatformRoute(
              context,
              rootNavigator: true,
              builder: (context) => PuzzleScreen(
                angle: const PuzzleTheme(PuzzleThemeKey.mix),
                puzzleId: data.puzzle.id,
              ),
            );
          },
        );
      },
      loading: () => SmallBoardPreview(
        orientation: Side.white,
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
      error: (error, stack) => const Padding(
        padding: Styles.bodySectionPadding,
        child: Text('Could not load the daily puzzle.'),
      ),
    );
  }
}

class _PuzzlePreview extends ConsumerWidget {
  const _PuzzlePreview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzle =
        ref.watch(nextPuzzleProvider(const PuzzleTheme(PuzzleThemeKey.mix)));

    Widget buildPuzzlePreview(Puzzle? puzzle, {bool loading = false}) {
      final preview = puzzle != null ? PuzzlePreview.fromPuzzle(puzzle) : null;
      return SmallBoardPreview(
        orientation: preview?.orientation ?? Side.white,
        fen: preview?.initialFen ?? kEmptyFen,
        lastMove: preview?.initialMove,
        description: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.puzzleDesc,
                  style: Styles.boardPreviewTitle,
                ),
                Text(
                  context.l10n.puzzleThemeHealthyMixDescription,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    height: 1.2,
                    fontSize: 12.0,
                    color: DefaultTextStyle.of(context)
                        .style
                        .color
                        ?.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            Icon(
              PuzzleIcons.mix,
              size: 34,
              color: DefaultTextStyle.of(context)
                  .style
                  .color
                  ?.withValues(alpha: 0.6),
            ),
            if (puzzle != null)
              Text(
                puzzle.puzzle.sideToMove == Side.white
                    ? context.l10n.whitePlays
                    : context.l10n.blackPlays,
              )
            else if (!loading)
              const Text(
                'No puzzles available, please go online to fetch them.',
              ),
          ],
        ),
        onTap: puzzle != null
            ? () {
                pushPlatformRoute(
                  context,
                  rootNavigator: true,
                  builder: (context) => const PuzzleScreen(
                    angle: PuzzleTheme(PuzzleThemeKey.mix),
                  ),
                ).then((_) {
                  if (context.mounted) {
                    ref.invalidate(
                      nextPuzzleProvider(const PuzzleTheme(PuzzleThemeKey.mix)),
                    );
                  }
                });
              }
            : null,
      );
    }

    return puzzle.maybeWhen(
      data: (data) => buildPuzzlePreview(data?.puzzle),
      orElse: () => buildPuzzlePreview(null, loading: true),
    );
  }
}
