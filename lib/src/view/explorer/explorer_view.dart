import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/explorer/opening_explorer_view.dart';
import 'package:lichess_mobile/src/view/explorer/tablebase_view.dart';

/// Unified explorer view that shows either opening explorer or tablebase
/// based on the position state (opening vs endgame)

const kExplorerTableRowVerticalPadding = 10.0;
const kExplorerTableRowHorizontalPadding = 8.0;
const kExplorerTableRowPadding = EdgeInsets.symmetric(
  horizontal: kExplorerTableRowHorizontalPadding,
  vertical: kExplorerTableRowVerticalPadding,
);
const kHeaderTextStyle = TextStyle(fontSize: 12);

Color whiteBoxColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark
    ? Colors.white.withValues(alpha: 0.8)
    : Colors.white;

Color blackBoxColor(BuildContext context) => Theme.of(context).brightness == Brightness.light
    ? Colors.black.withValues(alpha: 0.7)
    : Colors.black;

class ExplorerView extends ConsumerWidget {
  const ExplorerView({
    required this.position,
    required this.onMoveSelected,
    required this.isComputerAnalysisAllowed,
    this.opening,
  });

  final Position position;
  final bool isComputerAnalysisAllowed;
  final Opening? opening;
  final void Function(NormalMove) onMoveSelected;

  bool get tablebaseRelevant {
    final pieceCount = position.board.pieces.length;
    return pieceCount <= 9;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (position.isCheckmate) {
      return Center(child: Text(context.l10n.checkmate));
    }
    if (position.isStalemate) {
      return Center(child: Text(context.l10n.stalemate));
    }
    if (position.isInsufficientMaterial) {
      return Center(child: Text(context.l10n.insufficientMaterial));
    }
    // Tablebase is only relevant for positions with 9 or fewer pieces and not allowed for Correspondence games.
    if (tablebaseRelevant && isComputerAnalysisAllowed) {
      return TablebaseView(position: position, onMoveSelected: onMoveSelected);
    }

    return OpeningExplorerView(
      shouldDisplayGames: isComputerAnalysisAllowed,
      position: position,
      opening: opening,
      onMoveSelected: onMoveSelected,
    );
  }
}
