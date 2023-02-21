import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/common/styles.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/ui/puzzle/puzzle_screen.dart';

part 'puzzle_dashboard_screen.g.dart';

@riverpod
Future<Puzzle?> nextPuzzle(NextPuzzleRef ref, PuzzleTheme theme) async {
  final session = await ref.watch(authControllerProvider.future);
  final puzzleService = ref.watch(puzzleServiceProvider);
  return puzzleService.nextPuzzle(
    userId: session?.user.id,
    angle: theme,
  );
}

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
    final authController = ref.watch(authControllerProvider);
    final theme = ref.watch(puzzleThemePrefProvider);
    return authController.when(
      data: (session) {
        return SafeArea(
          child: ListView(
            padding: Styles.bodyPadding,
            children: [
              Padding(
                padding: Styles.sectionBottomPadding,
                child: PuzzleTabButton(
                  icon: const Icon(LichessIcons.target, size: 44),
                  title: Text(context.l10n.puzzles, style: Styles.sectionTitle),
                  subtitle: Text(puzzleThemeL10n(context, theme).description),
                  onTap: () async {
                    // TODO handle loading state
                    final puzzleService = ref.read(puzzleServiceProvider);
                    final puzzle = await puzzleService.nextPuzzle(
                      userId: session?.user.id,
                      angle: theme,
                    );
                    if (puzzle != null && context.mounted) {
                      Navigator.of(context, rootNavigator: true).push<void>(
                        MaterialPageRoute(
                          builder: (context) => PuzzlesScreen(puzzle: puzzle),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
      error: (err, st) {
        debugPrint(
          'SEVERE: [PuzzleDashboardScreen] error: $err\n$st',
        );
        return const SizedBox.shrink();
      },
      loading: () => const CircularProgressIndicator.adaptive(),
    );
  }
}

class PuzzleTabButton extends StatefulWidget {
  const PuzzleTabButton({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Widget icon;
  final Widget title;
  final Widget subtitle;
  final VoidCallback onTap;

  @override
  State<PuzzleTabButton> createState() => _PuzzleTabButtonState();
}

class _PuzzleTabButtonState extends State<PuzzleTabButton> {
  double scale = 1.0;

  void _onTapDown() {
    setState(() => scale = 0.97);
  }

  void _onTapCancel() {
    setState(() => scale = 1.00);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _onTapDown(),
      onTapCancel: _onTapCancel,
      onTapUp: (_) => _onTapCancel(),
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 100),
        child: PlatformCard(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: ListTile(
              leading: widget.icon,
              title: widget.title,
              subtitle: widget.subtitle,
            ),
          ),
        ),
      ),
    );
  }
}
