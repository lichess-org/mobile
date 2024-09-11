import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer_preferences.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer_repository.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_board.dart';
import 'package:lichess_mobile/src/view/game/archived_game_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/move_list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'opening_explorer_settings.dart';

const _kTableRowVerticalPadding = 12.0;
const _kTableRowHorizontalPadding = 8.0;
const _kTableRowPadding = EdgeInsets.symmetric(
  horizontal: _kTableRowHorizontalPadding,
  vertical: _kTableRowVerticalPadding,
);
const _kTabletBoardRadius = BorderRadius.all(Radius.circular(4.0));

Color _whiteBoxColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withOpacity(0.8)
        : Colors.white;

Color _blackBoxColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? Colors.black.withOpacity(0.7)
        : Colors.black;

class OpeningExplorerScreen extends ConsumerStatefulWidget {
  const OpeningExplorerScreen({required this.pgn, required this.options});

  final String pgn;
  final AnalysisOptions options;

  @override
  ConsumerState<OpeningExplorerScreen> createState() => _OpeningExplorerState();
}

class _OpeningExplorerState extends ConsumerState<OpeningExplorerScreen> {
  final Map<OpeningExplorerCacheKey, OpeningExplorerEntry> cache = {};

  /// Last explorer content that was successfully loaded. This is used to
  /// display a loading indicator while the new content is being fetched.
  List<Widget>? lastExplorerWidgets;

  @override
  Widget build(BuildContext context) {
    final analysisState =
        ref.watch(analysisControllerProvider(widget.pgn, widget.options));

    final opening = analysisState.currentNode.isRoot
        ? LightOpening(
            eco: '',
            name: context.l10n.startPosition,
          )
        : analysisState.currentNode.opening ??
            analysisState.currentBranchOpening ??
            analysisState.contextOpening;

    final Widget openingHeader = Container(
      padding: _kTableRowPadding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      child: opening != null
          ? GestureDetector(
              onTap: opening.name == context.l10n.startPosition
                  ? null
                  : () => launchUrl(
                        Uri.parse(
                          'https://lichess.org/opening/${opening.name}',
                        ),
                      ),
              child: Row(
                children: [
                  Icon(
                    Icons.open_in_browser_outlined,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: 6.0),
                  Expanded(
                    child: Text(
                      '${opening.eco.isEmpty ? "" : "${opening.eco} "}${opening.name}',
                      style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );

    if (analysisState.position.ply >= 50) {
      return _OpeningExplorerView(
        pgn: widget.pgn,
        options: widget.options,
        isLoading: false,
        isIndexing: false,
        children: [
          openingHeader,
          _OpeningExplorerMoveTable.maxDepth(
            pgn: widget.pgn,
            options: widget.options,
          ),
        ],
      );
    }

    final prefs = ref.watch(openingExplorerPreferencesProvider);

    if (prefs.db == OpeningDatabase.player && prefs.playerDb.username == null) {
      return _OpeningExplorerView(
        pgn: widget.pgn,
        options: widget.options,
        isLoading: false,
        isIndexing: false,
        children: [
          openingHeader,
          const Padding(
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
      pgn: widget.pgn,
      options: widget.options,
      isLoading: isLoading,
      isIndexing: openingExplorerAsync.value?.isIndexing ?? false,
      children: openingExplorerAsync.when(
        data: (openingExplorer) {
          if (openingExplorer == null) {
            return lastExplorerWidgets ??
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
                ];
          }

          final topGames = openingExplorer.entry.topGames;
          final recentGames = openingExplorer.entry.recentGames;

          final ply = analysisState.position.ply;

          final children = [
            openingHeader,
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

          return children;
        },
        loading: () =>
            lastExplorerWidgets ??
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
        error: (e, s) {
          debugPrint(
            'SEVERE: [OpeningExplorerScreen] could not load opening explorer data; $e\n$s',
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
    required this.pgn,
    required this.options,
    required this.children,
    required this.isLoading,
    required this.isIndexing,
  });

  final String pgn;
  final AnalysisOptions options;
  final List<Widget> children;
  final bool isLoading;
  final bool isIndexing;

  @override
  Widget build(BuildContext context) {
    final isTablet = isTabletOrLarger(context);
    final loadingOverlayColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        : Colors.white;

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(context.l10n.openingExplorer),
        actions: [
          if (isIndexing) const _IndexingIndicator(),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: isTablet
                  ? const EdgeInsets.symmetric(
                      horizontal: kTabletBoardTableSidePadding,
                    )
                  : EdgeInsets.zero,
              child: _MoveList(pgn: pgn, options: options),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final aspectRatio = constraints.biggest.aspectRatio;
                  final defaultBoardSize = constraints.biggest.shortestSide;
                  final remainingHeight =
                      constraints.maxHeight - defaultBoardSize;
                  final isSmallScreen =
                      remainingHeight < kSmallRemainingHeightLeftBoardThreshold;
                  final boardSize = isTablet || isSmallScreen
                      ? defaultBoardSize - kTabletBoardTableSidePadding * 2
                      : defaultBoardSize;

                  final isLandscape = aspectRatio > 1;

                  final loadingOverlay = Positioned.fill(
                    child: IgnorePointer(
                      ignoring: !isLoading,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn,
                        opacity: isLoading ? 0.3 : 0.0,
                        child: ColoredBox(color: loadingOverlayColor),
                      ),
                    ),
                  );

                  if (isLandscape) {
                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: kTabletBoardTableSidePadding,
                            top: kTabletBoardTableSidePadding,
                            bottom: kTabletBoardTableSidePadding,
                          ),
                          child: AnalysisBoard(
                            pgn,
                            options,
                            boardSize,
                            borderRadius: isTablet ? _kTabletBoardRadius : null,
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: PlatformCard(
                                  clipBehavior: Clip.hardEdge,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(4.0),
                                  ),
                                  margin: const EdgeInsets.all(
                                    kTabletBoardTableSidePadding,
                                  ),
                                  semanticContainer: false,
                                  child: Stack(
                                    children: [
                                      ListView(
                                        padding: EdgeInsets.zero,
                                        children: children,
                                      ),
                                      loadingOverlay,
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Stack(
                      children: [
                        ListView(
                          padding: isTablet
                              ? const EdgeInsets.only(
                                  left: kTabletBoardTableSidePadding,
                                  right: kTabletBoardTableSidePadding,
                                )
                              : EdgeInsets.zero,
                          children: [
                            AnalysisBoard(
                              pgn,
                              options,
                              boardSize,
                              borderRadius:
                                  isTablet ? _kTabletBoardRadius : null,
                              disableDraggingPieces: true,
                            ),
                            ...children,
                          ],
                        ),
                        loadingOverlay,
                      ],
                    );
                  }
                },
              ),
            ),
            _BottomBar(pgn: pgn, options: options),
          ],
        ),
      ),
    );
  }
}

class _IndexingIndicator extends StatefulWidget {
  const _IndexingIndicator();

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
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: SizedBox(
        width: 10,
        height: 10,
        child: CircularProgressIndicator.adaptive(
          value: controller.value,
          // TODO: l10n
          semanticsLabel: 'Indexing',
        ),
      ),
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
  })  : _isLoading = false,
        _maxDepthReached = false;

  const _OpeningExplorerMoveTable.loading({
    required this.pgn,
    required this.options,
  })  : _isLoading = true,
        moves = const IListConst([]),
        whiteWins = 0,
        draws = 0,
        blackWins = 0,
        _maxDepthReached = false;

  const _OpeningExplorerMoveTable.maxDepth({
    required this.pgn,
    required this.options,
  })  : _isLoading = false,
        moves = const IListConst([]),
        whiteWins = 0,
        draws = 0,
        blackWins = 0,
        _maxDepthReached = true;

  final IList<OpeningMove> moves;
  final int whiteWins;
  final int draws;
  final int blackWins;
  final String pgn;
  final AnalysisOptions options;

  final bool _isLoading;
  final bool _maxDepthReached;

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

    const topPadding = EdgeInsets.only(top: _kTableRowVerticalPadding / 2);
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
        if (_maxDepthReached)
          TableRow(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
            ),
            children: [
              Padding(
                padding: _kTableRowPadding,
                child: Text(
                  String.fromCharCode(Icons.not_interested_outlined.codePoint),
                  style: TextStyle(
                    fontFamily: Icons.not_interested_outlined.fontFamily,
                  ),
                ),
              ),
              Padding(
                padding: _kTableRowPadding,
                child: Text(context.l10n.maxDepthReached),
              ),
              const Padding(
                padding: _kTableRowPadding,
                child: SizedBox.shrink(),
              ),
            ],
          )
        else if (moves.isNotEmpty)
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
          )
        else
          TableRow(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
            ),
            children: [
              Padding(
                padding: _kTableRowPadding,
                child: Text(
                  String.fromCharCode(Icons.not_interested_outlined.codePoint),
                  style: TextStyle(
                    fontFamily: Icons.not_interested_outlined.fontFamily,
                  ),
                ),
              ),
              Padding(
                padding: _kTableRowPadding,
                child: Text(context.l10n.noGameFound),
              ),
              const Padding(
                padding: _kTableRowPadding,
                child: SizedBox.shrink(),
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

class _MoveList extends ConsumerWidget {
  const _MoveList({
    required this.pgn,
    required this.options,
  });

  final String pgn;
  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(pgn, options);
    final state = ref.watch(ctrlProvider);
    final slicedMoves = state.root.mainline
        .map((e) => e.sanMove.san)
        .toList()
        .asMap()
        .entries
        .slices(2);
    final currentMoveIndex = state.currentNode.position.ply;

    return MoveList(
      inlineBackgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      inlineColor: Theme.of(context).colorScheme.onSurface,
      type: MoveListType.inline,
      slicedMoves: slicedMoves,
      currentMoveIndex: currentMoveIndex,
      onSelectMove: (index) {
        ref.read(ctrlProvider.notifier).jumpToNthNodeOnMainline(index - 1);
      },
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({
    required this.pgn,
    required this.options,
  });

  final String pgn;
  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref
        .watch(openingExplorerPreferencesProvider.select((value) => value.db));
    final ctrlProvider = analysisControllerProvider(pgn, options);
    final canGoBack =
        ref.watch(ctrlProvider.select((value) => value.canGoBack));
    final canGoNext =
        ref.watch(ctrlProvider.select((value) => value.canGoNext));

    final dbLabel = switch (db) {
      OpeningDatabase.master => 'Masters',
      OpeningDatabase.lichess => 'Lichess',
      OpeningDatabase.player => context.l10n.player,
    };

    return BottomBar(
      children: [
        BottomBarButton(
          label: dbLabel,
          showLabel: true,
          onTap: () => showAdaptiveBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            showDragHandle: true,
            isDismissible: true,
            builder: (_) => OpeningExplorerSettings(pgn, options),
          ),
          icon: Icons.tune,
        ),
        BottomBarButton(
          label: 'Flip',
          tooltip: context.l10n.flipBoard,
          showLabel: true,
          onTap: () => ref.read(ctrlProvider.notifier).toggleBoard(),
          icon: CupertinoIcons.arrow_2_squarepath,
        ),
        RepeatButton(
          onLongPress: canGoBack ? () => _moveBackward(ref) : null,
          child: BottomBarButton(
            onTap: canGoBack ? () => _moveBackward(ref) : null,
            label: 'Previous',
            showLabel: true,
            icon: CupertinoIcons.chevron_back,
            showTooltip: false,
          ),
        ),
        RepeatButton(
          onLongPress: canGoNext ? () => _moveForward(ref) : null,
          child: BottomBarButton(
            icon: CupertinoIcons.chevron_forward,
            label: 'Next',
            showLabel: true,
            onTap: canGoNext ? () => _moveForward(ref) : null,
            showTooltip: false,
          ),
        ),
      ],
    );
  }

  void _moveForward(WidgetRef ref) =>
      ref.read(analysisControllerProvider(pgn, options).notifier).userNext();
  void _moveBackward(WidgetRef ref) => ref
      .read(analysisControllerProvider(pgn, options).notifier)
      .userPrevious();
}
