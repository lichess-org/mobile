import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/utils/connectivity.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/user_session.dart';
import 'package:lichess_mobile/src/ui/puzzle/puzzle_dashboard_widget.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/bottom_navigation.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';

import 'puzzle_screen.dart';
import 'puzzle_themes_screen.dart';
import 'puzzle_streak_screen.dart';

final daysProvider = StateProvider<Days>((ref) => Days.month);

class PuzzleDashboardScreen extends ConsumerStatefulWidget {
  const PuzzleDashboardScreen({super.key});

  @override
  ConsumerState<PuzzleDashboardScreen> createState() =>
      _PuzzleDashboardScreenState();
}

class _PuzzleDashboardScreenState extends ConsumerState<PuzzleDashboardScreen> {
  final _androidRefreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authSessionProvider);
    return PlatformWidget(
      androidBuilder: (context) => _androidBuilder(context, session),
      iosBuilder: (context) => _iosBuilder(context, session),
    );
  }

  Widget _androidBuilder(BuildContext context, UserSession? userSession) {
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

  Widget _iosBuilder(BuildContext context, UserSession? userSession) {
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
    return ref
        .refresh(puzzleDashboardProvider(ref.read(daysProvider).days).future);
  }
}

class _Body extends ConsumerWidget {
  const _Body(this.session);

  final UserSession? session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const theme = PuzzleTheme.mix;
    final nextPuzzle = ref.watch(nextPuzzleProvider(theme));
    final connectivity = ref.watch(connectivityChangesProvider);

    final content = [
      Padding(
        padding: Styles.bodySectionPadding,
        child: nextPuzzle.when(
          data: (data) {
            if (data == null) {
              return const _ThemedPuzzleButton(
                theme: theme,
                subtitle: 'Could not find any puzzle! Go online to get more.',
              );
            } else {
              return _ThemedPuzzleButton(
                theme: theme,
                onTap: () {
                  pushPlatformRoute(
                    context,
                    rootNavigator: true,
                    builder: (context) => PuzzleScreen(
                      theme: theme,
                      initialPuzzleContext: data,
                    ),
                  ).then((_) {
                    ref.invalidate(nextPuzzleProvider(theme));
                    ref.invalidate(
                      puzzleDashboardProvider(ref.read(daysProvider).days),
                    );
                  });
                },
              );
            }
          },
          loading: () => const _ThemedPuzzleButton(theme: theme),
          error: (e, s) {
            debugPrint(
              'SEVERE: [PuzzleScreen] could not load next puzzle; $e\n$s',
            );
            return const _ThemedPuzzleButton(theme: theme);
          },
        ),
      ),
      Padding(
        padding: Styles.bodySectionBottomPadding,
        child: _PuzzleButton(
          iconData: LichessIcons.target,
          title: context.l10n.puzzlePuzzleThemes,
          subtitle: 'Play puzzles from a specific theme.',
          onTap: () {
            pushPlatformRoute(
              context,
              builder: (context) => const PuzzleThemesScreen(),
            );
          },
        ),
      ),
      Padding(
        padding: Styles.bodySectionBottomPadding,
        child: _PuzzleButton(
          iconData: LichessIcons.streak,
          title: 'Puzzle Streak',
          subtitle: context.l10n.puzzleStreakDescription.characters
                  .takeWhile((c) => c != '.')
                  .toString() +
              (context.l10n.puzzleStreakDescription.contains('.') ? '.' : ''),
          onTap: connectivity.when(
            data: (data) => data.isOnline
                ? () {
                    pushPlatformRoute(
                      context,
                      rootNavigator: true,
                      builder: (context) => const PuzzleStreakScreen(),
                    );
                  }
                : null,
            loading: () => null,
            error: (_, __) => null,
          ),
        ),
      ),
      if (session != null) PuzzleDashboardWidget(),
    ];

    return defaultTargetPlatform == TargetPlatform.iOS
        ? SliverList(delegate: SliverChildListDelegate(content))
        : ListView(
            controller: puzzlesScrollController,
            children: content,
          );
  }
}

class _ThemedPuzzleButton extends StatelessWidget {
  const _ThemedPuzzleButton({
    required this.theme,
    this.onTap,
    this.subtitle,
  });

  final PuzzleTheme theme;
  final VoidCallback? onTap;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return _PuzzleButton(
      iconData: LichessIcons.target,
      title: puzzleThemeL10n(context, theme).name,
      subtitle: subtitle ?? puzzleThemeL10n(context, theme).description,
      onTap: onTap,
    );
  }
}

class _PuzzleButton extends StatelessWidget {
  const _PuzzleButton({
    required this.iconData,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData iconData;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CardButton(
      icon: Icon(iconData, size: 44),
      title: Text(
        title,
        style: Styles.sectionTitle,
      ),
      subtitle: Text(subtitle),
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
