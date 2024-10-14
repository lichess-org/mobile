import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_opening.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
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

final savedAnglesProvider =
    FutureProvider.autoDispose<IMap<PuzzleAngle, int>>((ref) async {
  final savedThemes = await ref.watch(savedThemeBatchesProvider.future);
  final savedOpenings = await ref.watch(savedOpeningBatchesProvider.future);
  return IMap<PuzzleAngle, int>.fromEntries([
    ...savedThemes
        .remove(PuzzleThemeKey.mix)
        .map((themeKey, v) => MapEntry(PuzzleTheme(themeKey), v))
        .entries,
    ...savedOpenings
        .map((openingKey, v) => MapEntry(PuzzleOpening(openingKey), v))
        .entries,
  ]);
});

class PuzzleTabScreen extends ConsumerWidget {
  const PuzzleTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConsumerPlatformWidget(
      ref: ref,
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context, WidgetRef ref) {
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
          actions: const [
            _DashboardButton(),
            _HistoryButton(),
          ],
        ),
        body: const Column(
          children: [
            ConnectivityBanner(),
            Expanded(
              child: _Body(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iosBuilder(BuildContext context, WidgetRef ref) {
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
                SizedBox(width: 6.0),
                _HistoryButton(),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: ConnectivityBanner()),
          const SliverSafeArea(
            top: false,
            sliver: _Body(),
          ),
        ],
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityChangesProvider);
    final savedAnglesAsync = ref.watch(savedAnglesProvider);

    final isTablet = isTabletOrLarger(context);

    final dailyPuzzleWidget = connectivity.whenIs(
      online: () => const [
        DailyPuzzle(),
      ],
      offline: () => <Widget>[],
    );

    // we always show the healthy mix theme
    final healthyMixPreview = PuzzleAnglePreview(
      angle: const PuzzleTheme(PuzzleThemeKey.mix),
      onTap: () {
        pushPlatformRoute(
          context,
          rootNavigator: true,
          builder: (context) => const PuzzleScreen(
            angle: PuzzleTheme(PuzzleThemeKey.mix),
          ),
        );
      },
    );

    final savedAngles = savedAnglesAsync.valueOrNull;

    final tacticalTrainerTitle = Padding(
      padding: Styles.horizontalBodyPadding.add(
        Theme.of(context).platform == TargetPlatform.iOS
            ? Styles.sectionTopPadding
            : EdgeInsets.zero,
      ),
      child: Text(
        context.l10n.puzzleDesc,
        style: Styles.sectionTitle,
      ),
    );

    final handsetChildren = [
      _PuzzleMenu(connectivity: connectivity),
      tacticalTrainerTitle,
      ...dailyPuzzleWidget,
      healthyMixPreview,
      if (savedAngles != null) _SavedAnglesPreviewList(savedAngles),
      const SizedBox(height: 8.0),
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
                _PuzzleMenu(connectivity: connectivity),
                tacticalTrainerTitle,
                ...dailyPuzzleWidget,
                healthyMixPreview,
                if (savedAngles != null) _SavedAnglesPreviewList(savedAngles),
                const SizedBox(height: 8.0),
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

class _SavedAnglesPreviewList extends StatefulWidget {
  const _SavedAnglesPreviewList(this.savedAngles);

  final IMap<PuzzleAngle, int> savedAngles;

  @override
  State<_SavedAnglesPreviewList> createState() =>
      _SavedAnglesPreviewListState();
}

class _SavedAnglesPreviewListState extends State<_SavedAnglesPreviewList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late final AnimatedListModel<PuzzleAngle> _angles;

  @override
  void initState() {
    super.initState();
    _angles = AnimatedListModel<PuzzleAngle>(
      listKey: _listKey,
      removedItemBuilder: _buildRemovedItem,
      initialItems: widget.savedAngles.keys,
    );
  }

  @override
  void didUpdateWidget(covariant _SavedAnglesPreviewList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldKeys = oldWidget.savedAngles.toKeyISet();
    final newKeys = widget.savedAngles.toKeyISet();

    if (oldKeys != newKeys) {
      final missings = oldKeys.difference(newKeys);
      if (missings.isNotEmpty) {
        for (final missing in missings) {
          final index = _angles.indexOf(missing);
          if (index != -1) {
            _angles.removeAt(index);
          }
        }
      }

      final additions = newKeys.difference(oldKeys);
      if (additions.isNotEmpty) {
        for (final addition in additions) {
          final index = _angles.length;
          _angles.insert(index, addition);
        }
      }
    }
  }

  Widget _buildItem(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    final angle = _angles[index];
    return PuzzleAnglePreview(
      angle: angle,
      onTap: () {
        pushPlatformRoute(
          context,
          rootNavigator: true,
          builder: (context) => PuzzleScreen(angle: angle),
        );
      },
    );
  }

  Widget _buildRemovedItem(
    PuzzleAngle angle,
    BuildContext context,
    Animation<double> animation,
  ) {
    return SizeTransition(
      sizeFactor: animation,
      child: PuzzleAnglePreview(angle: angle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      key: _listKey,
      initialItemCount: _angles.length,
      itemBuilder: _buildItem,
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

class _PuzzleMenu extends ConsumerWidget {
  const _PuzzleMenu({required this.connectivity});

  final AsyncValue<ConnectivityStatus> connectivity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    if (session == null) {
      return const SizedBox.shrink();
    }
    final onPressed = ref.watch(connectivityChangesProvider).whenIs(
          online: () => () {
            pushPlatformRoute(
              context,
              title: context.l10n.puzzlePuzzleDashboard,
              builder: (_) => const PuzzleDashboardScreen(),
            );
          },
          offline: () => null,
        );

    return AppBarIconButton(
      icon: const Icon(Icons.assessment_outlined),
      semanticsLabel: context.l10n.puzzlePuzzleDashboard,
      onPressed: onPressed,
    );
  }
}

class _HistoryButton extends ConsumerWidget {
  const _HistoryButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    if (session == null) {
      return const SizedBox.shrink();
    }
    final onPressed = ref.watch(connectivityChangesProvider).whenIs(
          online: () => () {
            pushPlatformRoute(
              context,
              title: context.l10n.puzzleHistory,
              builder: (_) => const PuzzleHistoryScreen(),
            );
          },
          offline: () => null,
        );
    return AppBarIconButton(
      icon: const Icon(Icons.history_outlined),
      semanticsLabel: context.l10n.puzzleHistory,
      onPressed: onPressed,
    );
  }
}

TextStyle _puzzlePreviewSubtitleStyle(BuildContext context) {
  return TextStyle(
    fontSize: 14.0,
    color: DefaultTextStyle.of(context).style.color?.withValues(alpha: 0.6),
  );
}

/// A widget that displays the daily puzzle.
class DailyPuzzle extends ConsumerWidget {
  const DailyPuzzle();

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
      loading: () => const Shimmer(
        child: ShimmerLoading(
          isLoading: true,
          child: SmallBoardPreview.loading(),
        ),
      ),
      error: (error, _) {
        return const Padding(
          padding: Styles.bodySectionPadding,
          child: Text('Could not load the daily puzzle.'),
        );
      },
    );
  }
}

/// A widget that displays a preview of a puzzle angle batch.
class PuzzleAnglePreview extends ConsumerWidget {
  const PuzzleAnglePreview({required this.angle, this.onTap});

  final PuzzleAngle angle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzle = ref.watch(nextPuzzleProvider(angle));
    final flatOpenings = ref.watch(flatOpeningsListProvider);

    Widget buildPuzzlePreview(Puzzle? puzzle, {bool loading = false}) {
      final preview = puzzle != null ? PuzzlePreview.fromPuzzle(puzzle) : null;

      return loading
          ? const Shimmer(
              child: ShimmerLoading(
                isLoading: true,
                child: SmallBoardPreview.loading(),
              ),
            )
          : Slidable(
              enabled: angle != const PuzzleTheme(PuzzleThemeKey.mix),
              endActionPane: ActionPane(
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    icon: Icons.delete,
                    onPressed: (context) async {
                      final service =
                          await ref.read(puzzleServiceProvider.future);
                      if (context.mounted) {
                        service.deleteBatch(
                          userId: ref.read(authSessionProvider)?.user.id,
                          angle: angle,
                        );
                      }
                    },
                    spacing: 8.0,
                    backgroundColor: context.lichessColors.error,
                    foregroundColor: Colors.white,
                    label: context.l10n.delete,
                  ),
                ],
              ),
              child: SmallBoardPreview(
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
                      children: switch (angle) {
                        PuzzleTheme(themeKey: final themeKey) => [
                            Text(
                              themeKey.l10n(context.l10n).name,
                              style: Styles.boardPreviewTitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              themeKey.l10n(context.l10n).description,
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
                        PuzzleOpening(key: final openingKey) => [
                            Text(
                              flatOpenings.valueOrNull
                                      ?.firstWhere((o) => o.key == openingKey)
                                      .name ??
                                  openingKey.replaceAll('_', ' '),
                              style: Styles.boardPreviewTitle,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                      },
                    ),
                    Icon(
                      switch (angle) {
                        PuzzleTheme(themeKey: final themeKey) => themeKey.icon,
                        PuzzleOpening() => PuzzleIcons.opening,
                      },
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
                    else
                      const Text(
                        'No puzzles available, please go online to fetch them.',
                      ),
                  ],
                ),
                onTap: puzzle != null ? onTap : null,
              ),
            );
    }

    return puzzle.maybeWhen(
      data: (data) => buildPuzzlePreview(data?.puzzle),
      orElse: () => buildPuzzlePreview(null, loading: true),
    );
  }
}
