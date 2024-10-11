import 'package:collection/collection.dart';
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
    final savedThemes = ref.watch(savedThemeBatchesProvider);
    final savedOpenings = ref.watch(savedOpeningBatchesProvider);

    final isTablet = isTabletOrLarger(context);

    final dailyWidgets = connectivity.whenIs(
      online: () => const [
        DailyPuzzle(),
        SizedBox(height: 4.0),
      ],
      offline: () => <Widget>[],
    );

    final previewDescriptionStyle = TextStyle(
      height: 1.2,
      fontSize: 12.0,
      color: DefaultTextStyle.of(context).style.color?.withValues(alpha: 0.6),
    );

    // we always show the healthy mix theme
    final healthyMixPreview = PuzzleAnglePreview(
      angle: const PuzzleTheme(PuzzleThemeKey.mix),
      icon: PuzzleIcons.mix,
      description: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            PuzzleThemeKey.mix.l10n(context.l10n).name,
            style: Styles.boardPreviewTitle,
          ),
          Text(
            PuzzleThemeKey.mix.l10n(context.l10n).description,
            style: previewDescriptionStyle,
          ),
        ],
      ),
    );

    final savedThemesPreview = savedThemes.maybeWhen(
      data: (themes) {
        return themes.entries
            .whereNot((e) => e.key == PuzzleThemeKey.mix)
            .map((entry) {
          final theme = entry.key;
          return PuzzleAnglePreview(
            angle: PuzzleTheme(theme),
            icon: theme.icon,
            description: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  theme.l10n(context.l10n).name,
                  style: Styles.boardPreviewTitle,
                ),
                Text(
                  theme.l10n(context.l10n).description,
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
          );
        }).toList();
      },
      orElse: () => <Widget>[],
    );

    final savedOpeningsPreview = savedOpenings.maybeWhen(
      data: (openings) {
        return openings.entries.map((entry) {
          final opening = entry.key;
          return PuzzleAnglePreview(
            angle: PuzzleOpening(opening),
            icon: PuzzleIcons.opening,
            description: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  opening,
                  style: Styles.boardPreviewTitle,
                ),
              ],
            ),
          );
        }).toList();
      },
      orElse: () => <Widget>[],
    );

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
      ...dailyWidgets,
      healthyMixPreview,
      ...savedThemesPreview,
      ...savedOpeningsPreview,
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
                ...dailyWidgets,
                healthyMixPreview,
                ...savedThemesPreview,
                ...savedOpeningsPreview,
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

/// A widget that displays a preview of a puzzle angle.
class PuzzleAnglePreview extends ConsumerWidget {
  const PuzzleAnglePreview({
    required this.angle,
    required this.icon,
    required this.description,
  });

  final PuzzleAngle angle;
  final IconData icon;
  final Widget description;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzle = ref.watch(nextPuzzleProvider(angle));

    Widget buildPuzzlePreview(Puzzle? puzzle, {bool loading = false}) {
      final preview = puzzle != null ? PuzzlePreview.fromPuzzle(puzzle) : null;
      return loading
          ? const Shimmer(
              child: ShimmerLoading(
                isLoading: true,
                child: SmallBoardPreview.loading(),
              ),
            )
          : SmallBoardPreview(
              orientation: preview?.orientation ?? Side.white,
              fen: preview?.initialFen ?? kEmptyFen,
              lastMove: preview?.initialMove,
              description: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  description,
                  Icon(
                    icon,
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
              onTap: puzzle != null
                  ? () {
                      pushPlatformRoute(
                        context,
                        rootNavigator: true,
                        builder: (context) => PuzzleScreen(angle: angle),
                      ).then((_) {
                        if (context.mounted) {
                          ref.invalidate(nextPuzzleProvider(angle));
                          ref.invalidate(savedThemeBatchesProvider);
                          ref.invalidate(savedOpeningBatchesProvider);
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
