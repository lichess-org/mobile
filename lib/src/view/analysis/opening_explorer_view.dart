import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer_preferences.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer_repository.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/opening_explorer/opening_explorer_widgets.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

const _kTableRowVerticalPadding = 12.0;
const _kTableRowHorizontalPadding = 8.0;
const _kTableRowPadding = EdgeInsets.symmetric(
  horizontal: _kTableRowHorizontalPadding,
  vertical: _kTableRowVerticalPadding,
);

class OpeningExplorerView extends ConsumerStatefulWidget {
  const OpeningExplorerView({required this.options});

  final AnalysisOptions options;

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
    final analysisState = ref.watch(analysisControllerProvider(widget.options));

    if (analysisState.position.ply >= 50) {
      return _OpeningExplorerView(
        isLoading: false,
        children: [
          OpeningExplorerMoveTable.maxDepth(
            options: widget.options,
          ),
        ],
      );
    }

    final prefs = ref.watch(openingExplorerPreferencesProvider);

    if (prefs.db == OpeningDatabase.player && prefs.playerDb.username == null) {
      return const _OpeningExplorerView(
        isLoading: false,
        children: [
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
      fen: analysisState.position.fen,
      prefs: prefs,
    );
    final cacheOpeningExplorer = cache[cacheKey];
    final openingExplorerAsync = cacheOpeningExplorer != null
        ? AsyncValue.data(
            (entry: cacheOpeningExplorer, isIndexing: false),
          )
        : ref.watch(openingExplorerProvider(fen: analysisState.position.fen));

    if (cacheOpeningExplorer == null) {
      ref.listen(openingExplorerProvider(fen: analysisState.position.fen),
          (_, curAsync) {
        curAsync.whenData((cur) {
          if (cur != null && !cur.isIndexing) {
            cache[cacheKey] = cur.entry;
          }
        });
      });
    }

    final isLoading =
        openingExplorerAsync.isLoading || openingExplorerAsync.value == null;

    return _OpeningExplorerView(
      isLoading: isLoading,
      children: openingExplorerAsync.when(
        data: (openingExplorer) {
          if (openingExplorer == null) {
            return lastExplorerWidgets ??
                [
                  Shimmer(
                    child: ShimmerLoading(
                      isLoading: true,
                      child: OpeningExplorerMoveTable.loading(
                        options: widget.options,
                      ),
                    ),
                  ),
                ];
          }

          final topGames = openingExplorer.entry.topGames;
          final recentGames = openingExplorer.entry.recentGames;

          final ply = analysisState.position.ply;

          final children = [
            OpeningExplorerMoveTable(
              moves: openingExplorer.entry.moves,
              whiteWins: openingExplorer.entry.white,
              draws: openingExplorer.entry.draws,
              blackWins: openingExplorer.entry.black,
              options: widget.options,
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
                        : Theme.of(context).colorScheme.surfaceContainerHigh,
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
                        : Theme.of(context).colorScheme.surfaceContainerHigh,
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
              Shimmer(
                child: ShimmerLoading(
                  isLoading: true,
                  child: OpeningExplorerMoveTable.loading(
                    options: widget.options,
                  ),
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
  }
}

class _OpeningExplorerView extends StatelessWidget {
  const _OpeningExplorerView({
    required this.children,
    required this.isLoading,
  });

  final List<Widget> children;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isTablet = isTabletOrLarger(context);
    final loadingOverlay = Positioned.fill(
      child: IgnorePointer(ignoring: !isLoading),
    );

    return Stack(
      children: [
        ListView(
          padding: isTablet
              ? const EdgeInsets.symmetric(
                  horizontal: kTabletBoardTableSidePadding,
                )
              : EdgeInsets.zero,
          children: children,
        ),
        loadingOverlay,
      ],
    );
  }
}
