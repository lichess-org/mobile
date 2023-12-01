import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_activity.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/puzzle_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/connectivity.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/puzzle/history_boards.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_dashboard_widget.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_history_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

import 'puzzle_screen.dart';
import 'puzzle_themes_screen.dart';
import 'storm_screen.dart';
import 'streak_screen.dart';

final daysProvider = StateProvider<Days>((ref) => Days.month);

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
    return Scaffold(
      appBar:
          AppBar(title: Text(context.l10n.puzzles), actions: [DaysSelector()]),
      body: userSession != null
          ? RefreshIndicator(
              key: _androidRefreshKey,
              onRefresh: _refreshData,
              child: Center(child: _Body(userSession)),
            )
          : Center(child: _Body(userSession)),
    );
  }

  Widget _iosBuilder(BuildContext context, AuthSessionState? userSession) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        controller: puzzlesScrollController,
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(context.l10n.puzzles),
            trailing: DaysSelector(),
          ),
          if (userSession != null)
            CupertinoSliverRefreshControl(
              onRefresh: _refreshData,
            ),
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
      ref.refresh(puzzleDashboardProvider(ref.read(daysProvider).days).future),
    ]);
  }
}

class _Body extends ConsumerWidget {
  const _Body(this.session);

  final AuthSessionState? session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const angle = PuzzleTheme(PuzzleThemeKey.mix);
    final nextPuzzle = ref.watch(nextPuzzleProvider(angle));
    final connectivity = ref.watch(connectivityChangesProvider);

    final expansionTileColor = defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoColors.secondaryLabel.resolveFrom(context)
        : null;

    final content = [
      const SizedBox(height: 8.0),
      connectivity.when(
        data: (data) => data.isOnline
            ? const _DailyPuzzle()
            : const _OfflinePuzzlePreview(),
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
      Padding(
        padding:
            Styles.horizontalBodyPadding.add(const EdgeInsets.only(top: 8.0)),
        child: nextPuzzle.when(
          data: (data) {
            if (data == null) {
              return const _PuzzleButton(
                subtitle: 'Could not find any puzzle! Go online to get more.',
              );
            } else {
              return _PuzzleButton(
                onTap: () {
                  pushPlatformRoute(
                    context,
                    title: context.l10n.puzzleDesc,
                    rootNavigator: true,
                    builder: (context) => PuzzleScreen(
                      angle: angle,
                      initialPuzzleContext: data,
                    ),
                  ).then((_) {
                    ref.invalidate(nextPuzzleProvider(angle));
                  });
                },
              );
            }
          },
          loading: () => const _PuzzleButton(),
          error: (e, s) {
            debugPrint(
              'SEVERE: [PuzzleScreen] could not load next puzzle; $e\n$s',
            );
            return const _PuzzleButton();
          },
        ),
      ),
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
            Padding(
              padding: Styles.bodySectionBottomPadding,
              child: CardButton(
                icon: const Icon(
                  LichessIcons.streak,
                  size: 44,
                ),
                title: Text(
                  'Puzzle Streak',
                  style: Styles.sectionTitle,
                ),
                subtitle: Text(
                  context.l10n.puzzleStreakDescription.characters
                          .takeWhile((c) => c != '.')
                          .toString() +
                      (context.l10n.puzzleStreakDescription.contains('.')
                          ? '.'
                          : ''),
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
            ),
            Padding(
              padding: Styles.bodySectionBottomPadding,
              child: CardButton(
                icon: const Icon(
                  LichessIcons.storm,
                  size: 44,
                ),
                title: Text(
                  'Puzzle Storm',
                  style: Styles.sectionTitle,
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
            ),
            Padding(
              padding: Styles.bodySectionBottomPadding,
              child: CardButton(
                icon: const Icon(PuzzleIcons.mix, size: 44),
                title: Text(
                  context.l10n.puzzlePuzzleThemes,
                  style: Styles.sectionTitle,
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
            ),
          ],
        ),
      ),
      if (session != null) ...[PuzzleDashboardWidget(), PuzzleHistoryWidget()],
    ];

    return defaultTargetPlatform == TargetPlatform.iOS
        ? SliverList(delegate: SliverChildListDelegate(content))
        : ListView(
            controller: puzzlesScrollController,
            children: content,
          );
  }
}

class PuzzleHistoryWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(puzzleRecentActivityProvider);
    return history.when(
      data: (data) {
        if (data.isEmpty) {
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
              child: PuzzleHistoryBoards(data),
            ),
          ],
        );
      },
      error: (e, s) {
        debugPrint(
          'SEVERE: [PuzzleHistoryWidget] could not load puzzle history',
        );
        return const Center(child: Text('Could not load Puzzle History'));
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
  const _PuzzleButton({
    this.onTap,
    this.subtitle,
  });

  final VoidCallback? onTap;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return CardButton(
      icon: Icon(
        PuzzleIcons.mix,
        size: 44,
        color: defaultTargetPlatform == TargetPlatform.iOS
            ? LichessColors.brag
            : Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        context.l10n.puzzles,
        style: Styles.sectionTitle,
      ),
      subtitle: Text(
        subtitle ?? context.l10n.puzzleDesc,
      ),
      onTap: onTap,
    );
  }
}

class DaysSelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    final day = ref.watch(daysProvider);
    return session != null
        ? AppBarTextButton(
            onPressed: () => showChoicePicker(
              context,
              choices: Days.values,
              selectedItem: day,
              labelBuilder: (t) => Text(_daysL10n(context, t)),
              onSelectedItemChanged: (newDay) {
                ref.read(daysProvider.notifier).state = newDay;
              },
            ),
            child: Text(_daysL10n(context, day)),
          )
        : const SizedBox.shrink();
  }
}

enum Days {
  oneday(1),
  twodays(2),
  week(7),
  twoweeks(14),
  month(30),
  twomonths(60),
  threemonths(90);

  const Days(this.days);
  final int days;
}

String _daysL10n(BuildContext context, Days day) {
  switch (day) {
    case Days.oneday:
      return context.l10n.nbDays(1);
    case Days.twodays:
      return context.l10n.nbDays(2);
    case Days.week:
      return context.l10n.nbDays(7);
    case Days.twoweeks:
      return context.l10n.nbDays(14);
    case Days.month:
      return context.l10n.nbDays(30);
    case Days.twomonths:
      return context.l10n.nbDays(60);
    case Days.threemonths:
      return context.l10n.nbDays(90);
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
              builder: (context) => PuzzleScreen(
                angle: const PuzzleTheme(PuzzleThemeKey.mix),
                initialPuzzleContext: PuzzleContext(
                  angle: const PuzzleTheme(PuzzleThemeKey.mix),
                  puzzle: data,
                  userId: session?.user.id,
                ),
              ),
            ).then((_) {
              ref.invalidate(
                nextPuzzleProvider(const PuzzleTheme(PuzzleThemeKey.mix)),
              );
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
                      angle: const PuzzleTheme(PuzzleThemeKey.mix),
                      initialPuzzleContext: data,
                    ),
                  ).then((_) {
                    ref.invalidate(
                      nextPuzzleProvider(const PuzzleTheme(PuzzleThemeKey.mix)),
                    );
                  });
                }
              : null,
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
