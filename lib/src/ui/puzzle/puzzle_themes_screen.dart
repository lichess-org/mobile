import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    hide Tuple2;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuple/tuple.dart';

import 'package:lichess_mobile/src/common/connectivity.dart';
import 'package:lichess_mobile/src/common/styles.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';

import 'puzzle_screen.dart';

part 'puzzle_themes_screen.g.dart';

@riverpod
Future<Tuple2<bool, ISet<PuzzleTheme>>> _savedThemesConnectivity(
  _SavedThemesConnectivityRef ref,
) async {
  final connectivity = await ref.watch(connectivityProvider.future);
  final themes = await ref.watch(savedThemesProvider.future);
  return Tuple2(connectivity.isOnline, themes);
}

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
        title: Text(context.l10n.puzzlePuzzleThemes),
      ),
      body: const _Body(),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context.l10n.puzzlePuzzleThemes),
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
    final savedThemesConnectivity = ref.watch(_savedThemesConnectivityProvider);

    return SafeArea(
      child: savedThemesConnectivity.when(
        data: (data) {
          return SingleChildScrollView(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount =
                    math.min(3, (constraints.maxWidth / 300).floor());
                return savedThemesConnectivity.when(
                  data: (data) {
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
                        for (final category in list)
                          _Category(
                            category: category,
                            savedThemes: data.item2,
                            isOnline: data.item1,
                          ),
                      ],
                    );
                  },
                  loading: () => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Center(child: CircularProgressIndicator.adaptive()),
                    ],
                  ),
                  error: (error, stack) =>
                      const Center(child: Text('Could not load saved themes.')),
                );
              },
            ),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, stack) =>
            const Center(child: Text('Could not load saved themes.')),
      ),
    );
  }
}

class _Category extends ConsumerWidget {
  const _Category({
    required this.category,
    required this.savedThemes,
    required this.isOnline,
  });

  final PuzzleThemeCategory category;
  final ISet<PuzzleTheme> savedThemes;
  final bool isOnline;

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
              title: Text(
                puzzleThemeL10n(context, theme).name,
                style: TextStyle(
                  color: textShade(
                    context,
                    isOnline || savedThemes.contains(theme) ? 1 : 0.3,
                  ),
                ),
              ),
              subtitle: Text(
                puzzleThemeL10n(context, theme).description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textShade(
                    context,
                    isOnline || savedThemes.contains(theme)
                        ? Styles.subtitleOpacity
                        : 0.3,
                  ),
                ),
              ),
              isThreeLine:
                  puzzleThemeL10n(context, theme).description.length > 60,
              onTap: isOnline || savedThemes.contains(theme)
                  ? () {
                      pushPlatformRoute(
                        context,
                        rootNavigator: true,
                        builder: (context) => PuzzleScreen(
                          theme: theme,
                        ),
                      );
                    }
                  : null,
            ),
          ),
      ],
    );
  }
}
