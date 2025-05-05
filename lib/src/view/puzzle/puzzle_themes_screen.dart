import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/puzzle/opening_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
final _themesProvider = FutureProvider.autoDispose<
  (bool, IMap<PuzzleThemeKey, int>, IMap<PuzzleThemeKey, PuzzleThemeData>?, bool)
>((ref) async {
  final connectivity = await ref.watch(connectivityChangesProvider.future);
  final savedThemes = await ref.watch(savedThemeBatchesProvider.future);
  IMap<PuzzleThemeKey, PuzzleThemeData>? onlineThemes;
  try {
    onlineThemes = await ref.watch(puzzleThemesProvider.future);
  } catch (e) {
    onlineThemes = null;
  }
  final savedOpenings = await ref.watch(savedOpeningBatchesProvider.future);
  return (connectivity.isOnline, savedThemes, onlineThemes, savedOpenings.isNotEmpty);
});

class PuzzleThemesScreen extends StatelessWidget {
  const PuzzleThemesScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const PuzzleThemesScreen());
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(title: Text(context.l10n.puzzlePuzzleThemes)),
      body: const _Body(),
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

    return themes.when(
      data: (data) {
        final (hasConnectivity, savedThemes, onlineThemes, hasSavedOpenings) = data;

        final openingsAvailable = hasConnectivity || hasSavedOpenings;
        return ListView(
          children: [
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: Opacity(
                opacity: openingsAvailable ? 1 : 0.5,
                child: ExpansionTile(
                  title: Text(context.l10n.puzzleByOpenings),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onExpansionChanged:
                      openingsAvailable
                          ? (expanded) {
                            Navigator.of(context).push(OpeningThemeScreen.buildRoute(context));
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
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (error, stack) => const Center(child: Text('Could not load themes.')),
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
    final themeCountStyle = TextStyle(
      fontSize: 12,
      color: textShade(context, Styles.subtitleOpacity),
    );

    final (categoryName, themes) = category;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(categoryName),
        children: [
          ListSection(
            hasLeading: true,
            children:
                themes.map((theme) {
                  final isThemeAvailable = hasConnectivity || savedThemes.containsKey(theme);

                  return Opacity(
                    opacity: isThemeAvailable ? 1 : 0.5,
                    child: ListTile(
                      leading: Icon(theme.icon),
                      trailing:
                          hasConnectivity && onlineThemes?.containsKey(theme) == true
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
                                child: Text('${savedThemes[theme]!}', style: themeCountStyle),
                              )
                              : null,
                      title: Text(theme.l10n(context.l10n).name),
                      subtitle: Text(
                        theme.l10n(context.l10n).description,
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: textShade(context, Styles.subtitleOpacity)),
                      ),
                      onTap:
                          isThemeAvailable
                              ? () {
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).push(PuzzleScreen.buildRoute(context, angle: PuzzleTheme(theme)));
                              }
                              : null,
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
