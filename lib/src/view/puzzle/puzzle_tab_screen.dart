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
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.puzzles),
        actions: const [
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
    final connectivity = ref.watch(connectivityProvider);

    final isTablet = isTabletOrLarger(context);

    final handsetChildren = [
      connectivity.when(
        data: (data) => data.isOnline
            ? const _DailyPuzzle()
            : const _OfflinePuzzlePreview(),
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
      if (Theme.of(context).platform == TargetPlatform.android)
        const SizedBox(height: 8.0),
      _PuzzleMenu(connectivity: connectivity),
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
        color: Theme.of(context).colorScheme.primary,
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
          icon: PuzzleIcons.mix,
          title: context.l10n.puzzlePuzzles,
          subtitle: context.l10n.puzzleDesc,
          onTap: () {
            pushPlatformRoute(
              context,
              title: context.l10n.puzzleDesc,
              rootNavigator: true,
              builder: (context) => const PuzzleScreen(
                angle: PuzzleTheme(PuzzleThemeKey.mix),
              ),
            );
          },
        ),
        _PuzzleMenuListTile(
          icon: PuzzleIcons.opening,
          title: context.l10n.puzzlePuzzleThemes,
          subtitle:
              'Play puzzles from your favorite openings, or choose a theme.',
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
            subtitle: 'Solve as many puzzles as possible in 3 minutes.',
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
                child: Text(context.l10n.puzzleNoPuzzlesToShow),
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
              builder: (context) => PuzzleHistoryScreen(),
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
              child:
                  PuzzleHistoryPreview(recentActivity.take(maxItems).toIList()),
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
                    builder: (context) => const PuzzleScreen(
                      angle: PuzzleTheme(PuzzleThemeKey.mix),
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
