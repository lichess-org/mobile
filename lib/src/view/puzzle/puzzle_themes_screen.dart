import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/view/puzzle/opening_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lichess_mobile/src/utils/connectivity.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';

import 'puzzle_screen.dart';

part 'puzzle_themes_screen.g.dart';

@riverpod
Future<
    (
      bool,
      IMap<PuzzleThemeKey, int>,
      IMap<PuzzleThemeKey, PuzzleThemeData>?,
      bool,
    )> _themes(
  _ThemesRef ref,
) async {
  final connectivity = await ref.watch(connectivityProvider.future);
  final savedThemes = await ref.watch(savedThemeBatchesProvider.future);
  IMap<PuzzleThemeKey, PuzzleThemeData>? onlineThemes;
  try {
    onlineThemes = await ref.watch(puzzleThemesProvider.future);
  } catch (e) {
    onlineThemes = null;
  }
  final savedOpenings = await ref.watch(savedOpeningBatchesProvider.future);
  return (
    connectivity.isOnline,
    savedThemes,
    onlineThemes,
    savedOpenings.isNotEmpty
  );
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
    final themes = ref.watch(_themesProvider);
    final expansionTileColor = defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoColors.secondaryLabel.resolveFrom(context)
        : null;

    return SafeArea(
      child: themes.when(
        data: (data) {
          final (hasConnectivity, savedThemes, onlineThemes, hasSavedOpenings) =
              data;
          return ListView(
            children: [
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: Opacity(
                  opacity: hasSavedOpenings ? 1 : 0.5,
                  child: ExpansionTile(
                    iconColor: expansionTileColor,
                    collapsedIconColor: expansionTileColor,
                    title: Text(context.l10n.puzzleByOpenings),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onExpansionChanged: hasSavedOpenings
                        ? (expanded) {
                            pushPlatformRoute(
                              context,
                              builder: (ctx) => const OpeningThemeScreen(),
                            );
                          }
                        : null,
                  ),
                ),
              ),
              for (final category in list)
                _Category(
                  hasConnectivity: hasConnectivity,
                  category: category,
                  onlineThemes: onlineThemes,
                  savedThemes: savedThemes,
                ),
            ],
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, stack) =>
            const Center(child: Text('Could not load themes.')),
      ),
    );
  }
}

class _Category extends ConsumerWidget {
  const _Category({
    required this.hasConnectivity,
    required this.category,
    required this.onlineThemes,
    required this.savedThemes,
  });

  final bool hasConnectivity;
  final PuzzleThemeCategory category;
  final IMap<PuzzleThemeKey, PuzzleThemeData>? onlineThemes;
  final IMap<PuzzleThemeKey, int> savedThemes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collapsedIconColor = defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoColors.secondaryLabel.resolveFrom(context)
        : null;
    final tileColor = defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoColors.systemBlue.resolveFrom(context)
        : null;

    final themeCountStyle = TextStyle(
      fontSize: 12,
      color: textShade(
        context,
        Styles.subtitleOpacity,
      ),
    );

    final (categoryName, themes) = category;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        iconColor: tileColor,
        collapsedIconColor: collapsedIconColor,
        title: Text(categoryName),
        children: [
          ListSection(
            children: themes.map(
              (theme) {
                final isThemeAvailable =
                    hasConnectivity || savedThemes.containsKey(theme);

                return Opacity(
                  opacity: isThemeAvailable ? 1 : 0.5,
                  child: PlatformListTile(
                    leading: Icon(puzzleThemeIcon(theme)),
                    trailing: hasConnectivity &&
                            onlineThemes?.containsKey(theme) == true
                        ? Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Text(
                              '${onlineThemes![theme]!.count}',
                              style: themeCountStyle,
                            ),
                          )
                        : savedThemes.containsKey(theme)
                            ? Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Text(
                                  '${savedThemes[theme]!}',
                                  style: themeCountStyle,
                                ),
                              )
                            : null,
                    title: Padding(
                      padding: defaultTargetPlatform == TargetPlatform.iOS
                          ? const EdgeInsets.only(top: 6.0)
                          : EdgeInsets.zero,
                      child: Text(
                        puzzleThemeL10n(context, theme).name,
                        style: defaultTargetPlatform == TargetPlatform.iOS
                            ? TextStyle(
                                color: CupertinoTheme.of(context)
                                    .textTheme
                                    .textStyle
                                    .color,
                              )
                            : null,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Text(
                        puzzleThemeL10n(context, theme).description,
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textShade(
                            context,
                            Styles.subtitleOpacity,
                          ),
                        ),
                      ),
                    ),
                    isThreeLine: true,
                    onTap: isThemeAvailable
                        ? () {
                            pushPlatformRoute(
                              context,
                              rootNavigator: true,
                              builder: (context) => PuzzleScreen(
                                angle: PuzzleTheme(theme),
                              ),
                            );
                          }
                        : null,
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
