import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/view/puzzle/opening_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lichess_mobile/src/utils/connectivity.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';

import 'puzzle_screen.dart';

part 'puzzle_themes_screen.g.dart';

@riverpod
Future<(bool, ISet<PuzzleTheme>)> _savedThemesConnectivity(
  _SavedThemesConnectivityRef ref,
) async {
  final connectivity = await ref.watch(connectivityProvider.future);
  final themes = await ref.watch(savedThemesProvider.future);
  return (connectivity.isOnline, themes);
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
    final onlineThemes = ref.watch(puzzleThemeProvider);
    final expansionTileColor = defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoColors.secondaryLabel.resolveFrom(context)
        : null;

    // show online themes if online otherwise show offline themes
    return SafeArea(
      child: savedThemesConnectivity.when(
        data: (data) {
          return SingleChildScrollView(
            child: onlineThemes.when(
              data: (oThemes) {
                if (data.$1) {
                  return Column(
                    children: [
                      Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          iconColor: expansionTileColor,
                          collapsedIconColor: expansionTileColor,
                          title: const Text('By game opening'),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                          onExpansionChanged: (expanded) {
                            pushPlatformRoute(
                              context,
                              builder: (ctx) => const OpeningThemeScreen(),
                            );
                          },
                        ),
                      ),
                      for (final category in oThemes.skip(1))
                        _CategoryOnline(
                          category: category,
                        ),
                    ],
                  );
                }
                return _OfflineThemeBuilder(list, data.$2);
              },
              loading: () => const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(child: CircularProgressIndicator.adaptive()),
                ],
              ),
              // show offline themes if error in fetching themes
              error: (_, __) => _OfflineThemeBuilder(list, data.$2),
            ),
          );
        },
        loading: () => const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: CircularProgressIndicator.adaptive()),
          ],
        ),
        error: (error, stack) =>
            const Center(child: Text('Could not load saved themes.')),
      ),
    );
  }
}

class _OfflineThemeBuilder extends StatelessWidget {
  const _OfflineThemeBuilder(
    this.themeList,
    this.savedThemes,
  );
  final ISet<PuzzleTheme> savedThemes;
  final List<(String, List<PuzzleTheme>)> themeList;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount =
            math.min(3, (constraints.maxWidth / 300).floor());
        return LayoutGrid(
          columnSizes: List.generate(
            crossAxisCount,
            (_) => 1.fr,
          ),
          rowSizes: List.generate(
            (themeList.length / crossAxisCount).ceil(),
            (_) => auto,
          ),
          children: [
            for (final category in themeList)
              _CategoryOffline(
                category: category,
                savedThemes: savedThemes,
              ),
          ],
        );
      },
    );
  }
}

class _CategoryOffline extends ConsumerWidget {
  const _CategoryOffline({
    required this.category,
    required this.savedThemes,
  });

  final PuzzleThemeCategory category;
  final ISet<PuzzleTheme> savedThemes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (categoryTitle, themes) = category;
    return ListSection(
      header: Text(categoryTitle, style: Styles.sectionTitle),
      showDivider: true,
      children: [
        for (final theme in themes)
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
                    savedThemes.contains(theme) ? Styles.subtitleOpacity : 0.3,
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
                    savedThemes.contains(theme) ? Styles.subtitleOpacity : 0.3,
                  ),
                ),
              ),
              isThreeLine: true,
              onTap: savedThemes.contains(theme)
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

class _CategoryOnline extends ConsumerWidget {
  const _CategoryOnline({
    required this.category,
  });

  final PuzzleThemeFamily category;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collapsedIconColor = defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoColors.secondaryLabel.resolveFrom(context)
        : null;
    final tileColor = defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoColors.systemBlue.resolveFrom(context)
        : null;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        iconColor: tileColor,
        collapsedIconColor: collapsedIconColor,
        title: Text(category.name),
        children: [
          ListSection(
            children: category.themes
                .map(
                  (theme) => PlatformListTile(
                    leading: Icon(puzzleThemeIcon(theme.key)),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          puzzleThemeL10n(context, theme.key).name,
                          style: defaultTargetPlatform == TargetPlatform.iOS
                              ? TextStyle(
                                  color: CupertinoTheme.of(context)
                                      .textTheme
                                      .textStyle
                                      .color,
                                )
                              : null,
                        ),
                        Text(
                          '${theme.count}',
                          style: TextStyle(
                            color: textShade(context, 0.5),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      puzzleThemeL10n(context, theme.key).description,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textShade(
                          context,
                          Styles.subtitleOpacity,
                        ),
                      ),
                    ),
                    isThreeLine: true,
                    onTap: () {
                      pushPlatformRoute(
                        context,
                        rootNavigator: true,
                        builder: (context) => PuzzleScreen(
                          theme: theme.key,
                        ),
                      );
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
