import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import 'package:lichess_mobile/src/common/styles.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';

import 'puzzle_screen.dart';

class PuzzleThemesScreen extends StatelessWidget {
  const PuzzleThemesScreen({super.key});

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
        title: Text(context.l10n.puzzleThemes),
      ),
      body: const _Body(),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context.l10n.puzzleThemes),
      ),
      child: const _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // skip recommended category since we display it on the puzzle tab screen
    final list = ref.watch(puzzleThemeCategoriesProvider).skip(1).toList();

    return SafeArea(
      child: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount =
                math.min(3, (constraints.maxWidth / 300).floor());
            return LayoutGrid(
              columnSizes: List.generate(
                crossAxisCount,
                (_) => 1.fr,
              ),
              rowSizes: List.generate(
                (list.length / crossAxisCount).ceil(),
                (_) => auto,
              ),
              children: [
                for (final category in list) _Category(category: category),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Category extends ConsumerWidget {
  const _Category({required this.category});

  final PuzzleThemeCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListSection(
      header: Text(category.item1, style: Styles.sectionTitle),
      showDivider: true,
      children: [
        for (final theme in category.item2)
          Tooltip(
            message: puzzleThemeL10n(context, theme).description,
            triggerMode: TooltipTriggerMode.longPress,
            showDuration: const Duration(seconds: 7),
            child: PlatformListTile(
              title: Text(puzzleThemeL10n(context, theme).name),
              subtitle: Text(
                puzzleThemeL10n(context, theme).description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              isThreeLine:
                  puzzleThemeL10n(context, theme).description.length > 60,
              onTap: () {
                Navigator.of(context, rootNavigator: true).push<void>(
                  MaterialPageRoute(
                    builder: (context) => PuzzlesScreen(theme: theme),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
