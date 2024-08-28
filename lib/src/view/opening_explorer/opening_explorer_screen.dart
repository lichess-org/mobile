import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer_preferences.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer_repository.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_board.dart';
import 'package:lichess_mobile/src/view/game/archived_game_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'opening_explorer_settings.dart';

class OpeningExplorerScreen extends StatelessWidget {
  const OpeningExplorerScreen({required this.pgn, required this.options});

  final String pgn;
  final AnalysisOptions options;

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
        title: Text(context.l10n.openingExplorer),
        actions: [
          AppBarIconButton(
            onPressed: () => showAdaptiveBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              isDismissible: true,
              builder: (_) => OpeningExplorerSettings(pgn, options),
            ),
            semanticsLabel: context.l10n.settingsSettings,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: _Body(pgn: pgn, options: options),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Styles.cupertinoScaffoldColor.resolveFrom(context),
        padding: Styles.cupertinoAppBarTrailingWidgetPadding,
        middle: Text(context.l10n.openingExplorer),
        trailing: AppBarIconButton(
          onPressed: () => showAdaptiveBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            showDragHandle: true,
            isDismissible: true,
            builder: (_) => OpeningExplorerSettings(pgn, options),
          ),
          semanticsLabel: context.l10n.settingsSettings,
          icon: const Icon(Icons.settings),
        ),
      ),
      child: _Body(pgn: pgn, options: options),
    );
  }
}

class _Body extends ConsumerWidget {
  final String pgn;

  final AnalysisOptions options;
  const _Body({required this.pgn, required this.options});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Expanded(
          child: SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final aspectRatio = constraints.biggest.aspectRatio;
                final defaultBoardSize = constraints.biggest.shortestSide;
                final isTablet = isTabletOrLarger(context);
                final remainingHeight =
                    constraints.maxHeight - defaultBoardSize;
                final isSmallScreen =
                    remainingHeight < kSmallRemainingHeightLeftBoardThreshold;
                final boardSize = isTablet || isSmallScreen
                    ? defaultBoardSize - kTabletBoardTableSidePadding * 2
                    : defaultBoardSize;

                return aspectRatio > 1
                    ? Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: kTabletBoardTableSidePadding,
                              top: kTabletBoardTableSidePadding,
                              bottom: kTabletBoardTableSidePadding,
                            ),
                            child: Row(
                              children: [
                                AnalysisBoard(
                                  pgn,
                                  options,
                                  boardSize,
                                  isTablet: isTablet,
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: PlatformCard(
                                    margin: const EdgeInsets.all(
                                      kTabletBoardTableSidePadding,
                                    ),
                                    semanticContainer: false,
                                    child: _OpeningExplorer(
                                      pgn: pgn,
                                      options: options,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isTablet)
                            Padding(
                              padding: const EdgeInsets.all(
                                kTabletBoardTableSidePadding,
                              ),
                              child: AnalysisBoard(
                                pgn,
                                options,
                                boardSize,
                                isTablet: isTablet,
                              ),
                            )
                          else
                            AnalysisBoard(
                              pgn,
                              options,
                              boardSize,
                              isTablet: isTablet,
                            ),
                          Expanded(
                            child: _OpeningExplorer(pgn: pgn, options: options),
                          ),
                        ],
                      );
              },
            ),
          ),
        ),
        _BottomBar(pgn: pgn, options: options),
      ],
    );
  }
}

class _OpeningExplorer extends ConsumerStatefulWidget {
  const _OpeningExplorer({
    required this.pgn,
    required this.options,
  });

  final String pgn;
  final AnalysisOptions options;

  @override
  ConsumerState<_OpeningExplorer> createState() => _OpeningExplorerState();
}

class _OpeningExplorerState extends ConsumerState<_OpeningExplorer> {
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
            pgn: widget.pgn,
            options: widget.options,
            opening: opening,
            wikiBooksUrl: analysisState.wikiBooksUrl,
            explorerContent: lastExplorerWidgets ??
                [
                  Shimmer(
                    child: ShimmerLoading(
                      isLoading: true,
                      child: OpeningExplorerMoveTable.loading(
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
          return _OpeningExplorerView(
            pgn: widget.pgn,
            options: widget.options,
            opening: opening,
            openingExplorer: openingExplorer,
            wikiBooksUrl: analysisState.wikiBooksUrl,
            explorerContent: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(context.l10n.noGameFound),
                ),
              ),
            ],
          );
        }

        final explorerContent = [
          OpeningExplorerMoveTable(
            moves: openingExplorer.entry.moves,
            whiteWins: openingExplorer.entry.white,
            draws: openingExplorer.entry.draws,
            blackWins: openingExplorer.entry.black,
            pgn: widget.pgn,
            options: widget.options,
          ),
          if (openingExplorer.entry.topGames != null &&
              openingExplorer.entry.topGames!.isNotEmpty)
            OpeningExplorerGameList(
              title: context.l10n.topGames,
              games: openingExplorer.entry.topGames!,
            ),
          if (openingExplorer.entry.recentGames != null &&
              openingExplorer.entry.recentGames!.isNotEmpty)
            OpeningExplorerGameList(
              title: context.l10n.recentGames,
              games: openingExplorer.entry.recentGames!,
            ),
        ];

        lastExplorerWidgets = explorerContent;

        return _OpeningExplorerView(
          pgn: widget.pgn,
          options: widget.options,
          opening: opening,
          openingExplorer: openingExplorer,
          wikiBooksUrl: analysisState.wikiBooksUrl,
          explorerContent: explorerContent,
        );
      },
      loading: () => _OpeningExplorerView.loading(
        pgn: widget.pgn,
        options: widget.options,
        opening: opening,
        wikiBooksUrl: analysisState.wikiBooksUrl,
        explorerContent: lastExplorerWidgets ??
            [
              Shimmer(
                child: ShimmerLoading(
                  isLoading: true,
                  child: OpeningExplorerMoveTable.loading(
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
    required this.pgn,
    required this.options,
    required this.opening,
    required this.openingExplorer,
    required this.wikiBooksUrl,
    required this.explorerContent,
  }) : loading = false;

  const _OpeningExplorerView.loading({
    required this.pgn,
    required this.options,
    required this.opening,
    required this.wikiBooksUrl,
    required this.explorerContent,
  })  : loading = true,
        openingExplorer = null;

  final String pgn;
  final AnalysisOptions options;
  final Opening? opening;
  final ({OpeningExplorerEntry entry, bool isIndexing})? openingExplorer;
  final String? wikiBooksUrl;
  final List<Widget> explorerContent;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (opening != null)
                Expanded(
                  flex: 75,
                  child: _Opening(
                    opening: opening!,
                    wikiBooksUrl: wikiBooksUrl,
                  ),
                ),
              if (openingExplorer?.isIndexing == true)
                Expanded(
                  flex: 25,
                  child: _IndexingIndicator(),
                ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Stack(
              children: [
                ListView(children: explorerContent),
                Positioned.fill(
                  child: IgnorePointer(
                    ignoring: !loading,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.fastOutSlowIn,
                      opacity: loading ? 0.5 : 0.0,
                      child: const ColoredBox(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Opening extends ConsumerWidget {
  const _Opening({
    required this.opening,
    required this.wikiBooksUrl,
  });

  final Opening opening;
  final String? wikiBooksUrl;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openingWidget = Text(
      '${opening.eco.isEmpty ? "" : "${opening.eco} "}${opening.name}',
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    );

    return wikiBooksUrl == null
        ? openingWidget
        : ref.watch(wikiBooksPageExistsProvider(url: wikiBooksUrl!)).when(
              data: (wikiBooksPageExists) => wikiBooksPageExists
                  ? GestureDetector(
                      onTap: () => launchUrl(Uri.parse(wikiBooksUrl!)),
                      child: openingWidget,
                    )
                  : openingWidget,
              loading: () => openingWidget,
              error: (e, s) => openingWidget,
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
class OpeningExplorerMoveTable extends ConsumerWidget {
  const OpeningExplorerMoveTable({
    required this.moves,
    required this.whiteWins,
    required this.draws,
    required this.blackWins,
    required this.pgn,
    required this.options,
  }) : _isLoading = false;

  const OpeningExplorerMoveTable.loading({
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const rowPadding = EdgeInsets.all(6.0);
    const columnWidths = {
      0: FractionColumnWidth(0.15),
      1: FractionColumnWidth(0.35),
      2: FractionColumnWidth(0.50),
    };

    if (_isLoading) {
      return Table(
        columnWidths: columnWidths,
        children: List.generate(
          10,
          (int index) => TableRow(
            children: [
              Padding(
                padding: rowPadding,
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
                padding: rowPadding,
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
                padding: rowPadding,
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

    final games = whiteWins + draws + blackWins;
    final ctrlProvider = analysisControllerProvider(pgn, options);

    return Table(
      columnWidths: columnWidths,
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          children: [
            Padding(
              padding: rowPadding.subtract(const EdgeInsets.only(top: 6.0)),
              child: Text(context.l10n.move),
            ),
            Padding(
              padding: rowPadding.subtract(const EdgeInsets.only(top: 6.0)),
              child: Text(context.l10n.games),
            ),
            Padding(
              padding: rowPadding.subtract(const EdgeInsets.only(top: 6.0)),
              child: Text(context.l10n.whiteDrawBlack),
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
                      .onUserMove(Move.parse(move.uci)!),
                  child: Padding(
                    padding: rowPadding,
                    child: Text(move.san),
                  ),
                ),
                TableRowInkWell(
                  onTap: () => ref
                      .read(ctrlProvider.notifier)
                      .onUserMove(Move.parse(move.uci)!),
                  child: Padding(
                    padding: rowPadding,
                    child: Text('${formatNum(move.games)} ($percentGames%)'),
                  ),
                ),
                TableRowInkWell(
                  onTap: () => ref
                      .read(ctrlProvider.notifier)
                      .onUserMove(Move.parse(move.uci)!),
                  child: Padding(
                    padding: rowPadding,
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
              padding: rowPadding,
              alignment: Alignment.centerLeft,
              child: const Icon(Icons.functions),
            ),
            Padding(
              padding: rowPadding,
              child: Text('${formatNum(games)} (100%)'),
            ),
            Padding(
              padding: rowPadding,
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
}

/// List of games for the opening explorer.
class OpeningExplorerGameList extends StatelessWidget {
  const OpeningExplorerGameList({
    required this.title,
    required this.games,
  });

  final String title;
  final IList<OpeningExplorerGame> games;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6.0),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Row(
            children: [Text(title)],
          ),
        ),
        ...List.generate(games.length, (int index) {
          return OpeningExplorerGameTile(
            game: games.get(index),
            color: index.isEven
                ? Theme.of(context).colorScheme.surfaceContainerLow
                : Theme.of(context).colorScheme.surfaceContainerHigh,
          );
        }),
      ],
    );
  }
}

/// A game tile for the opening explorer.
class OpeningExplorerGameTile extends ConsumerWidget {
  const OpeningExplorerGameTile({
    required this.game,
    required this.color,
  });

  final OpeningExplorerGame game;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const widthResultBox = 50.0;
    const paddingResultBox = EdgeInsets.all(5);

    return Container(
      padding: const EdgeInsets.all(6.0),
      color: color,
      child: AdaptiveInkWell(
        onTap: () async {
          final gameId = GameId(game.id);
          final archivedGame = await ref.read(
            archivedGameProvider(id: gameId).future,
          );
          if (context.mounted) {
            pushPlatformRoute(
              context,
              builder: (_) => ArchivedGameScreen(
                gameData: archivedGame.data,
                orientation: Side.white,
              ),
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(game.white.rating.toString()),
                Text(game.black.rating.toString()),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(game.white.name, overflow: TextOverflow.ellipsis),
                  Text(game.black.name, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Row(
              children: [
                if (game.winner == 'white')
                  Container(
                    width: widthResultBox,
                    padding: paddingResultBox,
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                else if (game.winner == 'black')
                  Container(
                    width: widthResultBox,
                    padding: paddingResultBox,
                    decoration: BoxDecoration(
                      color: Colors.black,
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
                if (game.month != null) ...[
                  const SizedBox(width: 10.0),
                  Text(game.month!),
                ],
                if (game.speed != null) ...[
                  const SizedBox(width: 10.0),
                  Icon(game.speed!.icon, size: 20),
                ],
              ],
            ),
          ],
        ),
      ),
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
              color: Colors.white,
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
              color: Colors.black,
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

class _BottomBar extends ConsumerWidget {
  const _BottomBar({
    required this.pgn,
    required this.options,
  });

  final String pgn;
  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(pgn, options);
    final canGoBack =
        ref.watch(ctrlProvider.select((value) => value.canGoBack));
    final canGoNext =
        ref.watch(ctrlProvider.select((value) => value.canGoNext));

    return Container(
      color: Theme.of(context).platform == TargetPlatform.iOS
          ? CupertinoTheme.of(context).barBackgroundColor
          : Theme.of(context).bottomAppBarTheme.color,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: kBottomBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: BottomBarButton(
                  label: context.l10n.flipBoard,
                  onTap: () => ref.read(ctrlProvider.notifier).toggleBoard(),
                  icon: CupertinoIcons.arrow_2_squarepath,
                ),
              ),
              Expanded(
                child: RepeatButton(
                  onLongPress: canGoBack ? () => _moveBackward(ref) : null,
                  child: BottomBarButton(
                    key: const ValueKey('goto-previous'),
                    onTap: canGoBack ? () => _moveBackward(ref) : null,
                    label: 'Previous',
                    icon: CupertinoIcons.chevron_back,
                    showTooltip: false,
                  ),
                ),
              ),
              Expanded(
                child: RepeatButton(
                  onLongPress: canGoNext ? () => _moveForward(ref) : null,
                  child: BottomBarButton(
                    key: const ValueKey('goto-next'),
                    icon: CupertinoIcons.chevron_forward,
                    label: context.l10n.next,
                    onTap: canGoNext ? () => _moveForward(ref) : null,
                    showTooltip: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _moveForward(WidgetRef ref) =>
      ref.read(analysisControllerProvider(pgn, options).notifier).userNext();
  void _moveBackward(WidgetRef ref) => ref
      .read(analysisControllerProvider(pgn, options).notifier)
      .userPrevious();
}
