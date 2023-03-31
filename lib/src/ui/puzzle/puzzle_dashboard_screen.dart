import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/connectivity.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/common/styles.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/ui/puzzle/puzzle_dashboard_widget.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';

import 'puzzle_screen.dart';
import 'puzzle_themes_screen.dart';
import 'puzzle_streak_screen.dart';

final daysProvider = StateProvider<Days>((ref) => Days.month);

class PuzzleDashboardScreen extends StatelessWidget {
  const PuzzleDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(context.l10n.puzzles), actions: [DaysSelector()]),
      body: const Center(child: _Body()),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(context.l10n.puzzles),
            trailing: DaysSelector(),
          ),
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
    const theme = PuzzleTheme.mix;
    final nextPuzzle = ref.watch(nextPuzzleProvider(theme));
    final connectivity = ref.watch(connectivityChangesProvider);
    final session = ref.watch(authSessionProvider);

    final content = [
      Padding(
        padding: Styles.bodySectionPadding,
        child: nextPuzzle.when(
          data: (data) {
            if (data == null) {
              return const _PuzzleButton(
                theme: theme,
                subtitle: 'Could not find any puzzle! Go online to get more.',
              );
            } else {
              return _PuzzleButton(
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
                  });
                },
              );
            }
          },
          loading: () => const _PuzzleButton(theme: theme),
          error: (e, s) {
            debugPrint(
              'SEVERE: [PuzzleScreen] could not load next puzzle; $e\n$s',
            );
            return const _PuzzleButton(theme: theme);
          },
        ),
      ),
      Padding(
        padding: Styles.bodySectionBottomPadding,
        child: CardButton(
          icon: const Icon(LichessIcons.target, size: 44),
          title: Text(context.l10n.puzzlePuzzleThemes),
          subtitle: const Text('Play puzzles from a specific theme.'),
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
        child: CardButton(
          icon: const Icon(LichessIcons.streak, size: 44),
          title: const Text('Puzzle Streak'),
          subtitle: Text(context.l10n.puzzleStreakDescription),
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
        : ListView(children: content);
  }
}

class _PuzzleButton extends StatelessWidget {
  const _PuzzleButton({
    required this.theme,
    this.onTap,
    this.subtitle,
  });

  final PuzzleTheme theme;
  final VoidCallback? onTap;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return CardButton(
      icon: const Icon(LichessIcons.target, size: 44),
      title: Text(
        puzzleThemeL10n(context, theme).name,
        style: Styles.sectionTitle,
      ),
      subtitle: Text(subtitle ?? puzzleThemeL10n(context, theme).description),
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
            onPressed: () => showChoicesPicker(
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
