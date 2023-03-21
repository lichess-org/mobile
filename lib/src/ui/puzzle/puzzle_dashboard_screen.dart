import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/common/styles.dart';
import 'package:lichess_mobile/src/model/auth/user_session.dart';
import 'package:lichess_mobile/src/ui/puzzle/puzzle_dashboard_widget.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/ui/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';

import 'puzzle_themes_screen.dart';

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
    final session = ref.watch(userSessionStateProvider);
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
          title: Text(context.l10n.puzzleThemes),
          subtitle: const Text('Play puzzles from a specific theme.'),
          onTap: () {
            pushPlatformRoute(
              context,
              builder: (context) => const PuzzleThemesScreen(),
            );
          },
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
    final session = ref.watch(userSessionStateProvider);
    final day = ref.watch(daysProvider);
    return session != null
        ? InkWell(
            onTap: () => showChoicesPicker(
              context,
              choices: Days.values,
              selectedItem: day,
              labelBuilder: (t) => Text(t.toString()),
              onSelectedItemChanged: (newDay) {
                ref.read(daysProvider.notifier).state = newDay;
              },
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(day.toString()),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}

enum Days {
  oneday,
  twodays,
  week,
  twoweeks,
  month,
  twomonths,
  threemonths;

  @override
  String toString() {
    switch (this) {
      case Days.oneday:
        return '1 day';
      case Days.twodays:
        return '2 days';
      case Days.week:
        return '1 week';
      case Days.twoweeks:
        return '2 weeks';
      case Days.month:
        return '1 month';
      case Days.twomonths:
        return '2 months';
      case Days.threemonths:
        return '3 months';
    }
  }

  int toInteger() {
    switch (this) {
      case Days.oneday:
        return 1;
      case Days.twodays:
        return 2;
      case Days.week:
        return 7;
      case Days.twoweeks:
        return 14;
      case Days.month:
        return 30;
      case Days.twomonths:
        return 60;
      case Days.threemonths:
        return 90;
    }
  }
}
