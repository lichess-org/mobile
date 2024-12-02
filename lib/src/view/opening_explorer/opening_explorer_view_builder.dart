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

/// A view that displays the opening explorer for the given position.
///
/// All the required data is fetched from the [OpeningExplorerRepository] and
/// displayed in a table view. Responses are cached to avoid unnecessary
/// network requests.
class OpeningExplorerViewBuilder extends ConsumerStatefulWidget {
  const OpeningExplorerViewBuilder({
    required this.ply,
    required this.fen,
    required this.builder,
    this.onMoveSelected,
  });

  final int ply;
  final String fen;
  final void Function(NormalMove)? onMoveSelected;
  final Widget Function(
    BuildContext context,
    List<Widget> children, {
    required bool isLoading,
    required bool isIndexing,
  }) builder;

  @override
  ConsumerState<OpeningExplorerViewBuilder> createState() =>
      _OpeningExplorerState();
}

class _OpeningExplorerState extends ConsumerState<OpeningExplorerViewBuilder> {
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
        if (widget.ply >= 50) {
          return widget.builder(
            context,
            [
              const OpeningExplorerMoveTable.maxDepth(),
            ],
            isLoading: false,
            isIndexing: false,
          );
        }

        final prefs = ref.watch(openingExplorerPreferencesProvider);

        if (prefs.db == OpeningDatabase.player &&
            prefs.playerDb.username == null) {
          return widget.builder(
            context,
            [
              const Padding(
                padding: _kTableRowPadding,
                child: Center(
                  // TODO: l10n
                  child: Text('Select a Lichess player in the settings.'),
                ),
              ),
            ],
            isLoading: false,
            isIndexing: false,
          );
        }

        final cacheKey = OpeningExplorerCacheKey(
          fen: widget.fen,
          prefs: prefs,
        );
        final cacheOpeningExplorer = cache[cacheKey];
        final openingExplorerAsync = cacheOpeningExplorer != null
            ? AsyncValue.data(
                (entry: cacheOpeningExplorer, isIndexing: false),
              )
            : ref.watch(
                openingExplorerProvider(fen: widget.fen),
              );

        if (cacheOpeningExplorer == null) {
          ref.listen(openingExplorerProvider(fen: widget.fen), (_, curAsync) {
            curAsync.whenData((cur) {
              if (cur != null && !cur.isIndexing) {
                cache[cacheKey] = cur.entry;
              }
            });
          });
        }

        final isLoading = openingExplorerAsync.isLoading ||
            openingExplorerAsync.value == null;

        return widget.builder(
          context,
          openingExplorerAsync.when(
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

              final ply = widget.ply;

              final children = [
                OpeningExplorerMoveTable(
                  moves: openingExplorer.entry.moves,
                  whiteWins: openingExplorer.entry.white,
                  draws: openingExplorer.entry.draws,
                  blackWins: openingExplorer.entry.black,
                  onMoveSelected: widget.onMoveSelected,
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
          isLoading: isLoading,
          isIndexing: openingExplorerAsync.value?.isIndexing ?? false,
        );
      },
    );
  }
}
