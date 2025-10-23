import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/explorer/tablebase.dart';
import 'package:lichess_mobile/src/model/explorer/tablebase_repository.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/theme.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/explorer/explorer_view.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

class TablebaseView extends ConsumerWidget {
  const TablebaseView({required this.position, this.onMoveSelected, super.key});

  final Position position;
  final void Function(NormalMove)? onMoveSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tablebaseAsync = ref.watch(tablebaseProvider(fen: position.fen));

    switch (tablebaseAsync) {
      case AsyncData(:final value):
        if (value == null) {
          final connectivity = ref.watch(connectivityChangesProvider);
          final message = connectivity.whenIs(
            online: () => 'Position not in tablebase.',
            offline: () => 'Tablebase is not available offline.',
          );
          return Center(
            child: Padding(padding: const EdgeInsets.all(16.0), child: Text(message)),
          );
        }
        final children = <Widget>[];

        final winMoves = <TablebaseMove>[];
        final unknownMoves = <TablebaseMove>[];
        final syzygyWinMoves = <TablebaseMove>[];
        final maybeWinMoves = <TablebaseMove>[];
        final cursedWinMoves = <TablebaseMove>[];
        final drawMoves = <TablebaseMove>[];
        final blessedLossMoves = <TablebaseMove>[];
        final maybeLossMoves = <TablebaseMove>[];
        final syzygyLossMoves = <TablebaseMove>[];
        final lossMoves = <TablebaseMove>[];

        // Classify moves into the categories as the TablebaseCategory send by the server is evaluating the position after the move is made, the Categories need to be inverted.
        for (final move in value.moves) {
          switch (move.category) {
            case TablebaseCategory.loss:
              winMoves.add(move);
            case TablebaseCategory.unknown:
              unknownMoves.add(move);
            case TablebaseCategory.syzygyLoss:
              syzygyWinMoves.add(move);
            case TablebaseCategory.maybeLoss:
              maybeWinMoves.add(move);
            case TablebaseCategory.blessedLoss:
              cursedWinMoves.add(move);
            case TablebaseCategory.draw:
              drawMoves.add(move);
            case TablebaseCategory.cursedWin:
              blessedLossMoves.add(move);
            case TablebaseCategory.maybeWin:
              maybeLossMoves.add(move);
            case TablebaseCategory.syzygyWin:
              syzygyLossMoves.add(move);
            case TablebaseCategory.win:
              lossMoves.add(move);
          }
        }

        void addMoveSection({
          required List<TablebaseMove> moves,
          required String headerKey,
          required Widget headerChild,
          required bool? isWinningForWhite,
          required String moveKeyPrefix,
        }) {
          if (moves.isNotEmpty) {
            children.add(_TablebaseHeaderTile(key: Key(headerKey), child: headerChild));
            children.addAll(
              List.generate(moves.length, (int index) {
                return _TablebaseMoveRow(
                  key: Key('$moveKeyPrefix-${moves[index].uci}'),
                  move: moves[index],
                  color: index.isEven ? context.lichessTheme.rowEven : context.lichessTheme.rowOdd,
                  onMoveSelected: onMoveSelected,
                  isWinningForWhite: isWinningForWhite,
                );
              }, growable: false),
            );
          }
        }

        addMoveSection(
          moves: winMoves,
          headerKey: 'winMovesHeader',
          headerChild: Text(context.l10n.winning),
          isWinningForWhite: position.turn == Side.white,
          moveKeyPrefix: 'win-move',
        );
        addMoveSection(
          moves: unknownMoves,
          headerKey: 'unknownMovesHeader',
          headerChild: Text(context.l10n.unknown),
          isWinningForWhite: null,
          moveKeyPrefix: 'unknown-move',
        );
        addMoveSection(
          moves: syzygyWinMoves,
          headerKey: 'syzygyWinMovesHeader',
          headerChild: Text(context.l10n.unknownDueToRounding),
          isWinningForWhite: position.turn == Side.white,
          moveKeyPrefix: 'syzygy-win-move',
        );
        addMoveSection(
          moves: maybeWinMoves,
          headerKey: 'maybeWinMovesHeader',
          headerChild: const Text('Win or 50 move draw'),
          isWinningForWhite: position.turn == Side.white,
          moveKeyPrefix: 'maybe-win-move',
        );
        addMoveSection(
          moves: cursedWinMoves,
          headerKey: 'cursedWinMovesHeader',
          headerChild: Text(context.l10n.winPreventedBy50MoveRule),
          isWinningForWhite: position.turn == Side.white,
          moveKeyPrefix: 'cursed-win-move',
        );
        addMoveSection(
          moves: drawMoves,
          headerKey: 'drawMovesHeader',
          headerChild: Text(context.l10n.draw),
          isWinningForWhite: null,
          moveKeyPrefix: 'draw-move',
        );
        addMoveSection(
          moves: blessedLossMoves,
          headerKey: 'blessedLossMovesHeader',
          headerChild: Text(context.l10n.lossSavedBy50MoveRule),
          isWinningForWhite: null,
          moveKeyPrefix: 'blessed-loss-move',
        );
        addMoveSection(
          moves: maybeLossMoves,
          headerKey: 'maybeLossMovesHeader',
          headerChild: const Text('Loss or 50 move draw'),
          isWinningForWhite: position.turn != Side.white,
          moveKeyPrefix: 'maybe-loss-move',
        );
        addMoveSection(
          moves: syzygyLossMoves,
          headerKey: 'syzygyLossMovesHeader',
          headerChild: Text(context.l10n.unknownDueToRounding),
          isWinningForWhite: position.turn != Side.white,
          moveKeyPrefix: 'syzygy-loss-move',
        );
        addMoveSection(
          moves: lossMoves,
          headerKey: 'losingMovesHeader',
          headerChild: Text(context.l10n.losing),
          isWinningForWhite: position.turn != Side.white,
          moveKeyPrefix: 'loss-move',
        );

        return _TablebaseListView(isLoading: false, children: children);

      case AsyncError(:final error):
        debugPrint('SEVERE: [TablebaseView] could not load tablebase data; $error');
        final connectivity = ref.watch(connectivityChangesProvider);
        final message = connectivity.whenIs(
          online: () => 'Could not load tablebase data.',
          offline: () => 'Tablebase is not available offline.',
        );
        return Center(
          child: Padding(padding: const EdgeInsets.all(16.0), child: Text(message)),
        );

      case _:
        return _TablebaseListView(
          isLoading: true,
          children: [
            Shimmer(
              child: ShimmerLoading(
                isLoading: true,
                child: _TablebaseLoadingPlaceholder(position: position),
              ),
            ),
          ],
        );
    }
  }
}

class _TablebaseListView extends StatelessWidget {
  const _TablebaseListView({required this.children, required this.isLoading});

  final List<Widget> children;
  final bool isLoading;

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
          child: ColoredBox(color: brightness == Brightness.dark ? Colors.black : Colors.white),
        ),
      ),
    );

    return Stack(
      children: [
        ListView(padding: EdgeInsets.zero, children: children),
        loadingOverlay,
      ],
    );
  }
}

class _TablebaseHeaderTile extends StatelessWidget {
  const _TablebaseHeaderTile({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: ColorScheme.of(context).surfaceDim,
      padding: kExplorerTableRowPadding,
      child: DefaultTextStyle.merge(
        style: const TextStyle(fontWeight: FontWeight.bold),
        child: child,
      ),
    );
  }
}

class _TablebaseMoveRow extends StatelessWidget {
  const _TablebaseMoveRow({
    required this.move,
    required this.color,
    required this.isWinningForWhite,
    this.onMoveSelected,
    super.key,
  });

  final TablebaseMove move;
  final Color color;
  final bool? isWinningForWhite;
  final void Function(NormalMove)? onMoveSelected;

  @override
  Widget build(BuildContext context) {
    final metrics = <String>[];

    if (move.checkmate) {
      metrics.add(context.l10n.checkmate);
    } else if (move.stalemate) {
      metrics.add(context.l10n.stalemate);
    } else if (move.insufficientMaterial) {
      metrics.add(context.l10n.insufficientMaterial);
    } else if (move.category == TablebaseCategory.draw) {
      metrics.add(context.l10n.draw);
    } else {
      if ((move.dtm != null || move.dtc != null) && move.zeroing) {
        move.san.contains('x')
            ? metrics.add(context.l10n.capture)
            : metrics.add(context.l10n.pawnMove);
      } else if (move.dtz != null) {
        metrics.add('DTZ ${move.dtz!.abs()}');
      }
      if (move.dtm != null) metrics.add('DTM ${move.dtm!.abs()}');
      if (move.dtc != null) metrics.add('DTC ${move.dtc!.abs()}');
    }

    Widget metricsWidget = const SizedBox.shrink();

    if (metrics.isNotEmpty) {
      final List<Widget> metricBoxes = metrics.map((metric) {
        final Widget metricText = Text(metric, style: const TextStyle(fontSize: 12));

        if (isWinningForWhite == true) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: whiteBoxColor(context),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DefaultTextStyle.merge(
              style: const TextStyle(color: Colors.black),
              child: metricText,
            ),
          );
        } else if (isWinningForWhite == false) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: blackBoxColor(context),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DefaultTextStyle.merge(
              style: const TextStyle(color: Colors.white),
              child: metricText,
            ),
          );
        } else {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),
            child: DefaultTextStyle.merge(
              style: const TextStyle(color: Colors.white),
              child: metricText,
            ),
          );
        }
      }).toList();
      metricsWidget = Wrap(spacing: 8.0, runSpacing: 4.0, children: metricBoxes);
    }
    return InkWell(
      onTap: onMoveSelected != null ? () => onMoveSelected!(NormalMove.fromUci(move.uci)) : null,
      child: Container(
        color: color,
        padding: kExplorerTableRowPadding,
        child: Row(
          children: [
            Expanded(
              child: Text(move.san, style: const TextStyle(fontWeight: FontWeight.w500)),
            ),
            metricsWidget,
          ],
        ),
      ),
    );
  }
}

class _TablebaseLoadingPlaceholder extends StatelessWidget {
  const _TablebaseLoadingPlaceholder({required this.position});

  final Position position;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 20 + (kExplorerTableRowVerticalPadding * 2),
          color: Colors.grey[300],
          margin: const EdgeInsets.only(bottom: 8),
        ),
        ...List.generate(
          position.legalMoves.length,
          (index) => Container(
            height: 20 + (kExplorerTableRowVerticalPadding * 2),
            color: Colors.grey[200],
            margin: const EdgeInsets.only(bottom: 1),
          ),
        ),
      ],
    );
  }
}
