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
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';

final _themesProvider =
    FutureProvider.autoDispose<
      (bool, IMap<PuzzleThemeKey, int>, IMap<PuzzleThemeKey, PuzzleThemeData>?, bool)
    >((ref) async {
      final isOnline = await ref.watch(onlineStatusProvider.future);
      final savedThemes = await ref.watch(savedThemeBatchesProvider.future);
      IMap<PuzzleThemeKey, PuzzleThemeData>? onlineThemes;
      if (isOnline) {
        try {
          onlineThemes = await ref.watch(puzzleThemesProvider.future);
        } catch (e) {
          onlineThemes = null;
        }
      }
      final savedOpenings = await ref.watch(savedOpeningBatchesProvider.future);
      return (isOnline, savedThemes, onlineThemes, savedOpenings.isNotEmpty);
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

class _Body extends ConsumerStatefulWidget {
  const _Body();

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // skip recommended category since we display it on the puzzle tab screen
    final list = ref.watch(puzzleThemeCategoriesProvider).skip(1).toList();
    final themes = ref.watch(_themesProvider);

    return themes.when(
      data: (data) {
        final (hasConnectivity, savedThemes, onlineThemes, hasSavedOpenings) = data;

        final openingsAvailable = hasConnectivity || hasSavedOpenings;
        final searchBar = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: PlatformSearchBar(
            controller: _searchController,
            hintText: context.l10n.search,
            onChanged: (String query) => setState(() => _searchQuery = query),
            onClear: () {
              _searchController.clear();
              setState(() => _searchQuery = '');
            },
          ),
        );

        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          final matched = [
            for (final (_, categoryThemes) in list)
              for (final theme in categoryThemes)
                if (theme.l10n(context.l10n).name.toLowerCase().contains(query) ||
                    theme.l10n(context.l10n).description.toLowerCase().contains(query))
                  theme,
          ];

          return ListView(
            children: [
              searchBar,
              ListSection(
                hasLeading: true,
                children: matched.map((theme) {
                  final isThemeAvailable = hasConnectivity || savedThemes.containsKey(theme);
                  return _ThemeTile(
                    theme: theme,
                    isThemeAvailable: isThemeAvailable,
                    hasConnectivity: hasConnectivity,
                    onlineThemes: onlineThemes,
                    savedThemes: savedThemes,
                  );
                }).toList(),
              ),
            ],
          );
        }

        return ListView(
          children: [
            searchBar,
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                enabled: openingsAvailable,
                title: Text(context.l10n.puzzleByOpenings),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onExpansionChanged: openingsAvailable
                    ? (expanded) {
                        Navigator.of(context).push(OpeningThemeScreen.buildRoute(context));
                      }
                    : null,
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

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({
    required this.theme,
    required this.isThemeAvailable,
    required this.hasConnectivity,
    required this.onlineThemes,
    required this.savedThemes,
  });

  final PuzzleThemeKey theme;
  final bool isThemeAvailable;
  final bool hasConnectivity;
  final IMap<PuzzleThemeKey, PuzzleThemeData>? onlineThemes;
  final IMap<PuzzleThemeKey, int> savedThemes;

  @override
  Widget build(BuildContext context) {
    final themeCountStyle = TextStyle(
      fontSize: 12,
      color: textShade(context, Styles.subtitleOpacity),
    );

    return ListTile(
      enabled: isThemeAvailable,
      leading: Icon(theme.icon),
      trailing: hasConnectivity && onlineThemes?.containsKey(theme) == true
          ? Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: Text('${onlineThemes![theme]!.count}', style: themeCountStyle),
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
      onTap: isThemeAvailable
          ? () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).push(PuzzleScreen.buildRoute(context, angle: PuzzleTheme(theme)));
            }
          : null,
    );
  }
}

class _Category extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final (categoryName, themes) = category;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(categoryName),
        children: [
          ListSection(
            hasLeading: true,
            children: themes.map((theme) {
              final isThemeAvailable = hasConnectivity || savedThemes.containsKey(theme);
              return _ThemeTile(
                theme: theme,
                isThemeAvailable: isThemeAvailable,
                hasConnectivity: hasConnectivity,
                onlineThemes: onlineThemes,
                savedThemes: savedThemes,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
