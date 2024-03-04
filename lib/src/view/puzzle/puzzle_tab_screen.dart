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
import 'package:lichess_mobile/src/view/puzzle/history_boards.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_dashboard_widget.dart';
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
      appBar: AppBar(title: Text(context.l10n.puzzles)),
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
            largeTitle: Text(context.l10n.puzzles),
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
      ref.refresh(puzzleDashboardProvider.future),
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

    final expansionTileColor = Styles.expansionTileColor(context);

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
      PuzzleButton(),
      Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            context.l10n.more,
          ),
          tilePadding: Styles.horizontalBodyPadding,
          iconColor: expansionTileColor,
          collapsedIconColor: expansionTileColor,
          textColor: expansionTileColor,
          collapsedTextColor: expansionTileColor,
          controlAffinity: ListTileControlAffinity.leading,
          children: [
            const PuzzleThemeButton(),
            StreakButton(connectivity: connectivity),
            StormButton(connectivity: connectivity),
          ],
        ),
      ),
      PuzzleDashboardWidget(),
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
                PuzzleButton(),
                const SizedBox(height: 16.0),
                const PuzzleThemeButton(),
                StreakButton(connectivity: connectivity),
                StormButton(connectivity: connectivity),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                PuzzleDashboardWidget(),
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

class PuzzleButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const angle = PuzzleTheme(PuzzleThemeKey.mix);
    return Padding(
      padding:
          Styles.horizontalBodyPadding.add(const EdgeInsets.only(top: 8.0)),
      child: _PuzzleButton(
        onTap: () {
          pushPlatformRoute(
            context,
            title: context.l10n.puzzleDesc,
            rootNavigator: true,
            builder: (context) => const PuzzleScreen(angle: angle),
          );
        },
      ),
    );
  }
}

class StreakButton extends StatelessWidget {
  const StreakButton({required this.connectivity, super.key});

  final AsyncValue<ConnectivityStatus> connectivity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.bodySectionBottomPadding,
      child: CardButton(
        icon: const Icon(
          LichessIcons.streak,
          size: 44,
        ),
        title: const Text(
          'Puzzle Streak',
          style: Styles.callout,
        ),
        subtitle: Text(
          context.l10n.puzzleStreakDescription.characters
                  .takeWhile((c) => c != '.')
                  .toString() +
              (context.l10n.puzzleStreakDescription.contains('.') ? '.' : ''),
        ),
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
    );
  }
}

class StormButton extends StatelessWidget {
  const StormButton({required this.connectivity, super.key});

  final AsyncValue<ConnectivityStatus> connectivity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.bodySectionBottomPadding,
      child: CardButton(
        icon: const Icon(
          LichessIcons.storm,
          size: 44,
        ),
        title: const Text(
          'Puzzle Storm',
          style: Styles.callout,
        ),
        subtitle: const Text(
          'Solve as many puzzles as possible in 3 minutes.',
        ),
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
    );
  }
}

class PuzzleThemeButton extends StatelessWidget {
  const PuzzleThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.bodySectionBottomPadding,
      child: CardButton(
        icon: const Icon(PuzzleIcons.mix, size: 44),
        title: Text(
          context.l10n.puzzlePuzzleThemes,
          style: Styles.callout,
        ),
        subtitle: const Text(
          'Choose puzzles by theme or opening.',
        ),
        onTap: () {
          pushPlatformRoute(
            context,
            builder: (context) => const PuzzleThemesScreen(),
          );
        },
      ),
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
              child: PuzzleHistoryBoards(recentActivity.take(8).toIList()),
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

class _PuzzleButton extends StatelessWidget {
  const _PuzzleButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CardButton(
      icon: Icon(
        PuzzleIcons.mix,
        size: 44,
        color: context.lichessColors.brag,
      ),
      title: Text(
        context.l10n.puzzles,
        style: Styles.sectionTitle,
      ),
      subtitle: Text(context.l10n.puzzleDesc),
      onTap: onTap,
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
                context.l10n
                    .puzzlePlayedXTimes(data.puzzle.plays)
                    .localizeNumbers(),
              ),
            ],
          ),
          onTap: () {
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
