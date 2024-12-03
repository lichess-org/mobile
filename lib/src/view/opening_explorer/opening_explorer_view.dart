import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer_preferences.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer_repository.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/opening_explorer/opening_explorer_widgets.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

const _kTableRowVerticalPadding = 12.0;
const _kTableRowHorizontalPadding = 8.0;
const _kTableRowPadding = EdgeInsets.symmetric(
  horizontal: _kTableRowHorizontalPadding,
  vertical: _kTableRowVerticalPadding,
);

/// Displays an opening explorer for the given position.
///
/// It shows the top moves, games, and recent games for the given position in a list view.
/// By default, the view is scrollable, but it can be disabled by setting [scrollable] to false.
///
/// This widget is meant to be embedded in the analysis, broadcast, and study screens.
///
/// Network requests are debounced and cached to avoid unnecessary requests.
class OpeningExplorerView extends ConsumerStatefulWidget {
  const OpeningExplorerView({
    required this.position,
    required this.onMoveSelected,
    this.scrollable = true,
  });

  final Position position;
  final void Function(NormalMove) onMoveSelected;
  final bool scrollable;

  @override
  ConsumerState<OpeningExplorerView> createState() => _OpeningExplorerState();
}

class _OpeningExplorerState extends ConsumerState<OpeningExplorerView> {
  final Map<OpeningExplorerCacheKey, OpeningExplorerEntry> cache = {};

  /// Last explorer content that was successfully loaded. This is used to
  /// display a loading indicator while the new content is being fetched.
  List<Widget>? lastExplorerWidgets;

  @override
  Widget build(BuildContext context) {
    final connectivity = ref.watch(connectivityChangesProvider);
    return connectivity.whenIsLoading(
      loading: () => const CenterLoadingIndicator(),
      offline: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          // TODO l10n
          child: Text('Opening explorer is not available offline.'),
        ),
      ),
      online: () {
        if (widget.position.ply >= 50) {
          return _ExplorerListView(
            scrollable: widget.scrollable,
            isLoading: false,
            children: const [
              OpeningExplorerMoveTable.maxDepth(),
            ],
          );
        }

        final prefs = ref.watch(openingExplorerPreferencesProvider);

        if (prefs.db == OpeningDatabase.player &&
            prefs.playerDb.username == null) {
          return _ExplorerListView(
            scrollable: widget.scrollable,
            isLoading: false,
            children: const [
              Padding(
                padding: _kTableRowPadding,
                child: Center(
                  // TODO: l10n
                  child: Text('Select a Lichess player in the settings.'),
                ),
              ),
            ],
          );
        }

        final cacheKey = OpeningExplorerCacheKey(
          fen: widget.position.fen,
          prefs: prefs,
        );
        final cacheOpeningExplorer = cache[cacheKey];
        final openingExplorerAsync = cacheOpeningExplorer != null
            ? AsyncValue.data(
                (entry: cacheOpeningExplorer, isIndexing: false),
              )
            : ref.watch(
                openingExplorerProvider(fen: widget.position.fen),
              );

        if (cacheOpeningExplorer == null) {
          ref.listen(openingExplorerProvider(fen: widget.position.fen),
              (_, curAsync) {
            curAsync.whenData((cur) {
              if (cur != null && !cur.isIndexing) {
                cache[cacheKey] = cur.entry;
              }
            });
          });
        }

        final isLoading = openingExplorerAsync.isLoading ||
            openingExplorerAsync.value == null;

        return _ExplorerListView(
          scrollable: widget.scrollable,
          isLoading: isLoading,
          children: openingExplorerAsync.when(
            data: (openingExplorer) {
              if (openingExplorer == null) {
                return lastExplorerWidgets ??
                    [
                      const Shimmer(
                        child: ShimmerLoading(
                          isLoading: true,
                          child: OpeningExplorerMoveTable.loading(),
                        ),
                      ),
                    ];
              }

              final topGames = openingExplorer.entry.topGames;
              final recentGames = openingExplorer.entry.recentGames;

              final ply = widget.position.ply;

              final children = [
                OpeningExplorerMoveTable(
                  moves: openingExplorer.entry.moves,
                  whiteWins: openingExplorer.entry.white,
                  draws: openingExplorer.entry.draws,
                  blackWins: openingExplorer.entry.black,
                  onMoveSelected: widget.onMoveSelected,
                  isIndexing: openingExplorer.isIndexing,
                ),
                if (topGames != null && topGames.isNotEmpty) ...[
                  OpeningExplorerHeaderTile(
                    key: const Key('topGamesHeader'),
                    child: Text(context.l10n.topGames),
                  ),
                  ...List.generate(
                    topGames.length,
                    (int index) {
                      return OpeningExplorerGameTile(
                        key: Key('top-game-${topGames.get(index).id}'),
                        game: topGames.get(index),
                        color: index.isEven
                            ? Theme.of(context).colorScheme.surfaceContainerLow
                            : Theme.of(context)
                                .colorScheme
                                .surfaceContainerHigh,
                        ply: ply,
                      );
                    },
                    growable: false,
                  ),
                ],
                if (recentGames != null && recentGames.isNotEmpty) ...[
                  OpeningExplorerHeaderTile(
                    key: const Key('recentGamesHeader'),
                    child: Text(context.l10n.recentGames),
                  ),
                  ...List.generate(
                    recentGames.length,
                    (int index) {
                      return OpeningExplorerGameTile(
                        key: Key('recent-game-${recentGames.get(index).id}'),
                        game: recentGames.get(index),
                        color: index.isEven
                            ? Theme.of(context).colorScheme.surfaceContainerLow
                            : Theme.of(context)
                                .colorScheme
                                .surfaceContainerHigh,
                        ply: ply,
                      );
                    },
                    growable: false,
                  ),
                ],
              ];

              lastExplorerWidgets = children;

              return children;
            },
            loading: () =>
                lastExplorerWidgets ??
                [
                  const Shimmer(
                    child: ShimmerLoading(
                      isLoading: true,
                      child: OpeningExplorerMoveTable.loading(),
                    ),
                  ),
                ],
            error: (e, s) {
              debugPrint(
                'SEVERE: [OpeningExplorerView] could not load opening explorer data; $e\n$s',
              );
              return [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(e.toString()),
                  ),
                ),
              ];
            },
          ),
        );
      },
    );
  }
}

class _ExplorerListView extends StatelessWidget {
  const _ExplorerListView({
    required this.children,
    required this.isLoading,
    required this.scrollable,
  });

  final List<Widget> children;
  final bool isLoading;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final loadingOverlay = Positioned.fill(
      child: IgnorePointer(
        ignoring: !isLoading,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn,
          opacity: isLoading ? 0.20 : 0.0,
          child: ColoredBox(
            color: brightness == Brightness.dark ? Colors.black : Colors.white,
          ),
        ),
      ),
    );

    return Stack(
      children: [
        if (scrollable)
          ListView(padding: EdgeInsets.zero, children: children)
        else
          ListBody(children: children),
        loadingOverlay,
      ],
    );
  }
}
