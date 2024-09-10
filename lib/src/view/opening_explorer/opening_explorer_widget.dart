import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer_preferences.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer_repository.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/archived_game_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

const _kTableRowVerticalPadding = 10.0;
const _kTableRowHorizontalPadding = 8.0;
const _kTableRowPadding = EdgeInsets.symmetric(
  horizontal: _kTableRowHorizontalPadding,
  vertical: _kTableRowVerticalPadding,
);

Color _whiteBoxColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withOpacity(0.8)
        : Colors.white;

Color _blackBoxColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? Colors.black.withOpacity(0.7)
        : Colors.black;

class OpeningExplorerWidget extends ConsumerStatefulWidget {
  const OpeningExplorerWidget({
    required this.pgn,
    required this.options,
    super.key,
  });

  final String pgn;
  final AnalysisOptions options;

  @override
  ConsumerState<OpeningExplorerWidget> createState() => _OpeningExplorerState();
}

class _OpeningExplorerState extends ConsumerState<OpeningExplorerWidget> {
  final Map<OpeningExplorerCacheKey, OpeningExplorerEntry> cache = {};

  /// Last explorer content that was successfully loaded. This is used to
  /// display a loading indicator while the new content is being fetched.
  List<Widget>? lastExplorerWidgets;

  @override
  Widget build(BuildContext context) {
    final analysisState =
        ref.watch(analysisControllerProvider(widget.pgn, widget.options));

    if (analysisState.position.ply >= 50) {
      return Align(
        alignment: Alignment.center,
        child: Text(context.l10n.maxDepthReached),
      );
    }

    final prefs = ref.watch(openingExplorerPreferencesProvider);
    if (prefs.db == OpeningDatabase.player && prefs.playerDb.username == null) {
      return const Align(
        alignment: Alignment.center,
        child: Text('Select a Lichess player in the settings'),
      );
    }

    final opening = analysisState.currentNode.isRoot
        ? LightOpening(
            eco: '',
            name: context.l10n.startPosition,
          )
        : analysisState.currentNode.opening ??
            analysisState.currentBranchOpening ??
            analysisState.contextOpening;

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

    return openingExplorerAsync.when(
      data: (openingExplorer) {
        if (openingExplorer == null) {
          return _OpeningExplorerView.loading(
            children: lastExplorerWidgets ??
                [
                  Shimmer(
                    child: ShimmerLoading(
                      isLoading: true,
                      child: _OpeningExplorerMoveTable.loading(
                        pgn: widget.pgn,
                        options: widget.options,
                      ),
                    ),
                  ),
                ],
          );
        }
        if (openingExplorer.entry.moves.isEmpty) {
          lastExplorerWidgets = null;
          return _OpeningExplorerView.empty(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(context.l10n.noGameFound),
                ),
              ),
            ],
          );
        }

        final topGames = openingExplorer.entry.topGames;
        final recentGames = openingExplorer.entry.recentGames;

        final ply = analysisState.position.ply;

        final children = [
          Container(
            padding: _kTableRowPadding,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (opening != null)
                  Expanded(
                    flex: 75,
                    child: GestureDetector(
                      onTap: opening.name == context.l10n.startPosition
                          ? null
                          : () => launchUrl(
                                Uri.parse(
                                  'https://lichess.org/opening/${opening.name}',
                                ),
                              ),
                      child: Text(
                        '${opening.eco.isEmpty ? "" : "${opening.eco} "}${opening.name}',
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (openingExplorer.isIndexing == true)
                  Expanded(
                    flex: 25,
                    child: _IndexingIndicator(),
                  ),
              ],
            ),
          ),
          _OpeningExplorerMoveTable(
            moves: openingExplorer.entry.moves,
            whiteWins: openingExplorer.entry.white,
            draws: openingExplorer.entry.draws,
            blackWins: openingExplorer.entry.black,
            pgn: widget.pgn,
            options: widget.options,
          ),
          if (topGames != null && topGames.isNotEmpty) ...[
            _OpeningExplorerHeader(
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
            _OpeningExplorerHeader(
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

        return _OpeningExplorerView(
          children: children,
        );
      },
      loading: () => _OpeningExplorerView.loading(
        children: lastExplorerWidgets ??
            [
              Shimmer(
                child: ShimmerLoading(
                  isLoading: true,
                  child: _OpeningExplorerMoveTable.loading(
                    pgn: widget.pgn,
                    options: widget.options,
                  ),
                ),
              ),
            ],
      ),
      error: (e, s) {
        debugPrint(
          'SEVERE: [OpeningExplorerScreen] could not load opening explorer data; $e\n$s',
        );
        return Center(
          child: Text(e.toString()),
        );
      },
    );
  }
}

/// The opening header and the opening explorer move table.
class _OpeningExplorerView extends StatelessWidget {
  const _OpeningExplorerView({
    required this.children,
  })  : loading = false,
        empty = false;

  const _OpeningExplorerView.loading({
    required this.children,
  })  : loading = true,
        empty = false;

  const _OpeningExplorerView.empty({
    required this.children,
  })  : loading = false,
        empty = true;

  final List<Widget> children;
  final bool loading;
  final bool empty;

  @override
  Widget build(BuildContext context) {
    final loadingOverlayColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        : Colors.white;

    return Stack(
      children: [
        if (empty)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          )
        else
          Center(
            child: ListView(padding: EdgeInsets.zero, children: children),
          ),
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !loading,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              opacity: loading ? 0.5 : 0.0,
              child: ColoredBox(color: loadingOverlayColor),
            ),
          ),
        ),
      ],
    );
  }
}

class _IndexingIndicator extends StatefulWidget {
  @override
  State<_IndexingIndicator> createState() => _IndexingIndicatorState();
}

class _IndexingIndicatorState extends State<_IndexingIndicator>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 10,
          height: 10,
          child: CircularProgressIndicator.adaptive(
            value: controller.value,
            semanticsLabel: 'Indexing...',
          ),
        ),
        const SizedBox(width: 10),
        const Text('Indexing...'),
      ],
    );
  }
}

/// Table of moves for the opening explorer.
class _OpeningExplorerMoveTable extends ConsumerWidget {
  const _OpeningExplorerMoveTable({
    required this.moves,
    required this.whiteWins,
    required this.draws,
    required this.blackWins,
    required this.pgn,
    required this.options,
  }) : _isLoading = false;

  const _OpeningExplorerMoveTable.loading({
    required this.pgn,
    required this.options,
  })  : _isLoading = true,
        moves = const IListConst([]),
        whiteWins = 0,
        draws = 0,
        blackWins = 0;

  final IList<OpeningMove> moves;
  final int whiteWins;
  final int draws;
  final int blackWins;
  final String pgn;
  final AnalysisOptions options;

  final bool _isLoading;

  String formatNum(int num) => NumberFormat.decimalPatternDigits().format(num);

  static const columnWidths = {
    0: FractionColumnWidth(0.15),
    1: FractionColumnWidth(0.35),
    2: FractionColumnWidth(0.50),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (_isLoading) {
      return loadingTable;
    }

    final games = whiteWins + draws + blackWins;
    final ctrlProvider = analysisControllerProvider(pgn, options);

    const topPadding = EdgeInsets.only(top: _kTableRowVerticalPadding);
    const headerTextStyle = TextStyle(fontSize: 12);

    return Table(
      columnWidths: columnWidths,
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
          children: [
            Padding(
              padding: _kTableRowPadding.subtract(topPadding),
              child: Text(context.l10n.move, style: headerTextStyle),
            ),
            Padding(
              padding: _kTableRowPadding.subtract(topPadding),
              child: Text(context.l10n.games, style: headerTextStyle),
            ),
            Padding(
              padding: _kTableRowPadding.subtract(topPadding),
              child: Text(context.l10n.whiteDrawBlack, style: headerTextStyle),
            ),
          ],
        ),
        ...List.generate(
          moves.length,
          (int index) {
            final move = moves.get(index);
            final percentGames = ((move.games / games) * 100).round();
            return TableRow(
              decoration: BoxDecoration(
                color: index.isEven
                    ? Theme.of(context).colorScheme.surfaceContainerLow
                    : Theme.of(context).colorScheme.surfaceContainerHigh,
              ),
              children: [
                TableRowInkWell(
                  onTap: () => ref
                      .read(ctrlProvider.notifier)
                      .onUserMove(NormalMove.fromUci(move.uci)),
                  child: Padding(
                    padding: _kTableRowPadding,
                    child: Text(move.san),
                  ),
                ),
                TableRowInkWell(
                  onTap: () => ref
                      .read(ctrlProvider.notifier)
                      .onUserMove(NormalMove.fromUci(move.uci)),
                  child: Padding(
                    padding: _kTableRowPadding,
                    child: Text('${formatNum(move.games)} ($percentGames%)'),
                  ),
                ),
                TableRowInkWell(
                  onTap: () => ref
                      .read(ctrlProvider.notifier)
                      .onUserMove(NormalMove.fromUci(move.uci)),
                  child: Padding(
                    padding: _kTableRowPadding,
                    child: _WinPercentageChart(
                      whiteWins: move.white,
                      draws: move.draws,
                      blackWins: move.black,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        TableRow(
          decoration: BoxDecoration(
            color: moves.length.isEven
                ? Theme.of(context).colorScheme.surfaceContainerLow
                : Theme.of(context).colorScheme.surfaceContainerHigh,
          ),
          children: [
            Container(
              padding: _kTableRowPadding,
              alignment: Alignment.centerLeft,
              child: const Icon(Icons.functions),
            ),
            Padding(
              padding: _kTableRowPadding,
              child: Text('${formatNum(games)} (100%)'),
            ),
            Padding(
              padding: _kTableRowPadding,
              child: _WinPercentageChart(
                whiteWins: whiteWins,
                draws: draws,
                blackWins: blackWins,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static final loadingTable = Table(
    columnWidths: columnWidths,
    children: List.generate(
      10,
      (int index) => TableRow(
        children: [
          Padding(
            padding: _kTableRowPadding,
            child: Container(
              height: 20,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          Padding(
            padding: _kTableRowPadding,
            child: Container(
              height: 20,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          Padding(
            padding: _kTableRowPadding,
            child: Container(
              height: 20,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/// A game tile for the opening explorer.
class OpeningExplorerGameTile extends ConsumerStatefulWidget {
  const OpeningExplorerGameTile({
    required this.game,
    required this.color,
    required this.ply,
    super.key,
  });

  final OpeningExplorerGame game;
  final Color color;
  final int ply;

  @override
  ConsumerState<OpeningExplorerGameTile> createState() =>
      _OpeningExplorerGameTileState();
}

class _OpeningExplorerGameTileState
    extends ConsumerState<OpeningExplorerGameTile> {
  @override
  Widget build(BuildContext context) {
    const widthResultBox = 50.0;
    const paddingResultBox = EdgeInsets.all(5);

    return Container(
      padding: _kTableRowPadding,
      color: widget.color,
      child: AdaptiveInkWell(
        onTap: () {
          pushPlatformRoute(
            context,
            builder: (_) => ArchivedGameScreen(
              gameId: widget.game.id,
              orientation: Side.white,
              initialCursor: widget.ply,
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.game.white.rating.toString()),
                Text(widget.game.black.rating.toString()),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.game.white.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.game.black.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                if (widget.game.winner == 'white')
                  Container(
                    width: widthResultBox,
                    padding: paddingResultBox,
                    decoration: BoxDecoration(
                      color: _whiteBoxColor(context),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      '1-0',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  )
                else if (widget.game.winner == 'black')
                  Container(
                    width: widthResultBox,
                    padding: paddingResultBox,
                    decoration: BoxDecoration(
                      color: _blackBoxColor(context),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      '0-1',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                else
                  Container(
                    width: widthResultBox,
                    padding: paddingResultBox,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      '½-½',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                if (widget.game.month != null) ...[
                  const SizedBox(width: 10.0),
                  Text(
                    widget.game.month!,
                    style: const TextStyle(
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
                if (widget.game.speed != null) ...[
                  const SizedBox(width: 10.0),
                  Icon(widget.game.speed!.icon, size: 20),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OpeningExplorerHeader extends StatelessWidget {
  const _OpeningExplorerHeader({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: _kTableRowPadding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      child: child,
    );
  }
}

class _WinPercentageChart extends StatelessWidget {
  const _WinPercentageChart({
    required this.whiteWins,
    required this.draws,
    required this.blackWins,
  });

  final int whiteWins;
  final int draws;
  final int blackWins;

  int percentGames(int games) =>
      ((games / (whiteWins + draws + blackWins)) * 100).round();
  String label(int percent) => percent < 20 ? '' : '$percent%';

  @override
  Widget build(BuildContext context) {
    final percentWhite = percentGames(whiteWins);
    final percentDraws = percentGames(draws);
    final percentBlack = percentGames(blackWins);

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Row(
        children: [
          Expanded(
            flex: percentWhite,
            child: ColoredBox(
              color: _whiteBoxColor(context),
              child: Text(
                label(percentWhite),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          Expanded(
            flex: percentDraws,
            child: ColoredBox(
              color: Colors.grey,
              child: Text(
                label(percentDraws),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            flex: percentBlack,
            child: ColoredBox(
              color: _blackBoxColor(context),
              child: Text(
                label(percentBlack),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
