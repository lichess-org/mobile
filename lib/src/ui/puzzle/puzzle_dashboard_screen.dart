import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/common/styles.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/ui/puzzle/puzzle_screen.dart';

import 'puzzle_themes_screen.dart';

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
      appBar: AppBar(
        title: const Text('Puzzles'),
      ),
      body: const Center(child: _Body()),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      child: Center(child: _Body()),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const theme = PuzzleTheme.mix;
    final nextPuzzle = ref.watch(nextPuzzleProvider(theme));

    return SafeArea(
      child: ListView(
        padding: Styles.bodyPadding,
        children: [
          Padding(
            padding: Styles.sectionBottomPadding,
            child: nextPuzzle.when(
              data: (data) {
                if (data == null) {
                  return const _PuzzleButton(
                    theme: theme,
                    subtitle:
                        'Could not find any puzzle! Go online to get more.',
                  );
                } else {
                  return _PuzzleButton(
                    theme: theme,
                    onTap: () {
                      pushPlatformRoute(
                        context,
                        rootNavigator: true,
                        builder: (context) => PuzzlesScreen(
                          theme: theme,
                          puzzleContext: data,
                        ),
                      );
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
            padding: Styles.sectionBottomPadding,
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
        ],
      ),
    );
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
