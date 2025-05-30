import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer.dart';
import 'package:lichess_mobile/src/theme.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:url_launcher/url_launcher.dart';

const _kTableRowVerticalPadding = 10.0;
const _kTableRowHorizontalPadding = 8.0;
const _kTableRowPadding = EdgeInsets.symmetric(
  horizontal: _kTableRowHorizontalPadding,
  vertical: _kTableRowVerticalPadding,
);
const _kHeaderTextStyle = TextStyle(fontSize: 12);

Color _whiteBoxColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark
    ? Colors.white.withValues(alpha: 0.8)
    : Colors.white;

Color _blackBoxColor(BuildContext context) => Theme.of(context).brightness == Brightness.light
    ? Colors.black.withValues(alpha: 0.7)
    : Colors.black;

class OpeningNameHeader extends StatelessWidget {
  const OpeningNameHeader({required this.opening, super.key});

  final Opening opening;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _kTableRowPadding,
      decoration: BoxDecoration(color: ColorScheme.of(context).surfaceDim),
      child: GestureDetector(
        onTap: opening.name == context.l10n.startPosition
            ? null
            : () => launchUrl(Uri.parse('https://lichess.org/opening/${opening.name}')),
        child: Row(
          children: [
            if (opening.name != context.l10n.startPosition) ...[
              Icon(Icons.open_in_browser_outlined, color: ColorScheme.of(context).onSurface),
              const SizedBox(width: 6.0),
            ],
            Expanded(
              child: Text(
                opening.name,
                style: TextStyle(
                  color: ColorScheme.of(context).onSurface,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
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
    this.onMoveSelected,
    this.isIndexing = false,
  }) : _isLoading = false;

  const OpeningExplorerMoveTable.loading()
    : _isLoading = true,
      moves = const IListConst([]),
      whiteWins = 0,
      draws = 0,
      blackWins = 0,
      isIndexing = false,
      onMoveSelected = null;

  final IList<OpeningMove> moves;
  final int whiteWins;
  final int draws;
  final int blackWins;
  final void Function(NormalMove)? onMoveSelected;
  final bool isIndexing;

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

    return Table(
      columnWidths: columnWidths,
      children: [
        TableRow(
          decoration: BoxDecoration(color: ColorScheme.of(context).surfaceDim),
          children: [
            Padding(
              padding: _kTableRowPadding,
              child: Text(context.l10n.move, style: _kHeaderTextStyle),
            ),
            Padding(
              padding: _kTableRowPadding,
              child: Text(context.l10n.games, style: _kHeaderTextStyle),
            ),
            Padding(
              padding: _kTableRowPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      context.l10n.whiteDrawBlack,
                      style: _kHeaderTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isIndexing) const IndexingIndicator(),
                ],
              ),
            ),
          ],
        ),
        ...List.generate(moves.length, (int index) {
          final move = moves.get(index);
          final percentGames = ((move.games / games) * 100).round();
          return TableRow(
            decoration: BoxDecoration(
              color: index.isEven ? context.lichessTheme.rowEven : context.lichessTheme.rowOdd,
            ),
            children: [
              TableRowInkWell(
                onTap: () => onMoveSelected?.call(NormalMove.fromUci(move.uci)),
                child: Padding(padding: _kTableRowPadding, child: Text(move.san)),
              ),
              TableRowInkWell(
                onTap: () => onMoveSelected?.call(NormalMove.fromUci(move.uci)),
                child: Padding(
                  padding: _kTableRowPadding,
                  child: Text('${formatNum(move.games)} ($percentGames%)'),
                ),
              ),
              TableRowInkWell(
                onTap: () => onMoveSelected?.call(NormalMove.fromUci(move.uci)),
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
        }),
        if (moves.isNotEmpty)
          TableRow(
            decoration: BoxDecoration(
              color: moves.length.isEven
                  ? context.lichessTheme.rowEven
                  : context.lichessTheme.rowOdd,
            ),
            children: [
              Container(
                padding: _kTableRowPadding,
                alignment: Alignment.centerLeft,
                child: const Icon(Icons.functions),
              ),
              Padding(padding: _kTableRowPadding, child: Text('${formatNum(games)} (100%)')),
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
            decoration: BoxDecoration(color: ColorScheme.of(context).surfaceContainerLow),
            children: [
              Padding(
                padding: _kTableRowPadding,
                child: Text(
                  String.fromCharCode(Icons.not_interested_outlined.codePoint),
                  style: TextStyle(fontFamily: Icons.not_interested_outlined.fontFamily),
                ),
              ),
              Padding(padding: _kTableRowPadding, child: Text(context.l10n.noGameFound)),
              const Padding(padding: _kTableRowPadding, child: SizedBox.shrink()),
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

class IndexingIndicator extends StatefulWidget {
  const IndexingIndicator();

  @override
  State<IndexingIndicator> createState() => _IndexingIndicatorState();
}

class _IndexingIndicatorState extends State<IndexingIndicator> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..addListener(() {
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
    return SizedBox(
      width: 12.0,
      height: 12.0,
      child: CircularProgressIndicator(
        strokeWidth: 1.5,
        value: controller.value,
        // TODO: l10n
        semanticsLabel: 'Indexing',
      ),
    );
  }
}

class OpeningExplorerHeaderTile extends StatelessWidget {
  const OpeningExplorerHeaderTile({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: _kTableRowPadding,
      decoration: BoxDecoration(color: ColorScheme.of(context).surfaceDim),
      child: child,
    );
  }
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
  ConsumerState<OpeningExplorerGameTile> createState() => _OpeningExplorerGameTileState();
}

class _OpeningExplorerGameTileState extends ConsumerState<OpeningExplorerGameTile> {
  @override
  Widget build(BuildContext context) {
    const widthResultBox = 50.0;
    const paddingResultBox = EdgeInsets.all(5);

    return Container(
      padding: _kTableRowPadding,
      color: widget.color,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            AnalysisScreen.buildRoute(
              context,
              AnalysisOptions(
                orientation: Side.white,
                gameId: widget.game.id,
                initialMoveCursor: widget.ply,
              ),
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
                  Text(widget.game.white.name, overflow: TextOverflow.ellipsis),
                  Text(widget.game.black.name, overflow: TextOverflow.ellipsis),
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
                      style: TextStyle(color: Colors.black),
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
                      style: TextStyle(color: Colors.white),
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
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                if (widget.game.month != null) ...[
                  const SizedBox(width: 10.0),
                  Text(
                    widget.game.month!,
                    style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
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

class _WinPercentageChart extends StatelessWidget {
  const _WinPercentageChart({
    required this.whiteWins,
    required this.draws,
    required this.blackWins,
  });

  final int whiteWins;
  final int draws;
  final int blackWins;

  int percentGames(int games) => ((games / (whiteWins + draws + blackWins)) * 100).round();
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
