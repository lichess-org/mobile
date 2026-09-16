import 'package:chessground/chessground.dart';
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/widgets/board.dart';
import 'package:lichess_mobile/src/widgets/move_list.dart';
import 'package:material_ui/material_ui.dart';

/// The board of a practice chapter, with what the chapter has to say beside or under it.
///
/// Unlike a game's layout, the [table] takes all the room the board leaves, and scrolls: study
/// authors write long comments.
class const PracticeBoardLayout({
  required final Side orientation,
  required final Position position,
  required final PlayerSide playerSide,
  required final Move? lastMove,
  required final Widget table,
  required final Widget bottomBar,
  final void Function(NormalMove move)? onMove,
  final ISet<Shape> shapes = const ISetConst({}),

  /// The moves played, in SAN, shown as a line above the table.
  final List<String>? moves,

  /// The move the board is at, counted from 1; the last one when null.
  final int? currentMoveIndex,
  final void Function(int moveIndex)? onSelectMove,
}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<PracticeBoardLayout> createState() => _PracticeBoardLayoutState();
}

class _PracticeBoardLayoutState() extends ConsumerState<PracticeBoardLayout> {
  late final ChessboardController _controller = ChessboardController(game: _gameData());

  @override
  void didUpdateWidget(PracticeBoardLayout old) {
    super.didUpdateWidget(old);
    if (old.position != widget.position ||
        old.playerSide != widget.playerSide ||
        old.lastMove != widget.lastMove) {
      _controller.updatePosition(_gameData(), resetPremove: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  GameData _gameData() {
    final boardPrefs = ref.read(boardPreferencesProvider);
    return buildGameData(
      fen: widget.position.fen,
      variant: Variant.standard,
      position: widget.position,
      playerSide: widget.playerSide,
      lastMove: widget.lastMove,
      castlingMethod: boardPrefs.castlingMethod,
      boardHighlights: boardPrefs.boardHighlights,
    );
  }

  @override
  Widget build(BuildContext context) {
    final boardPrefs = ref.watch(boardPreferencesProvider);

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = isTabletOrLarger(context);
          final isLandscape = constraints.biggest.aspectRatio > 1;
          final defaultBoardSize = constraints.biggest.shortestSide;
          final remainingHeight = constraints.maxHeight - defaultBoardSize;
          final isPadded = isTablet || isLandscape || remainingHeight < kSmallHeightMinusBoard;
          final boardSize = isPadded
              ? defaultBoardSize - kTabletBoardTableSidePadding * 2
              : defaultBoardSize;

          final board = Padding(
            padding: isPadded
                ? const EdgeInsets.all(kTabletBoardTableSidePadding)
                : EdgeInsets.zero,
            child: BoardWidget(
              size: boardSize,
              orientation: widget.orientation,
              controller: _controller,
              settings: boardPrefs
                  .toBoardSettings(Variant.standard)
                  .copyWith(
                    enablePremoves: false,
                    borderRadius: isPadded ? Styles.boardBorderRadius : BorderRadius.zero,
                    boxShadow: isPadded ? boardShadows : const <BoxShadow>[],
                  ),
              shapes: widget.shapes.unlock,
              onMove: (move, {viaDragAndDrop}) {
                if (move is NormalMove) widget.onMove?.call(move);
              },
            ),
          );

          final moves = widget.moves;
          final side = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (moves != null && boardPrefs.moveListDisplay)
                MoveList(
                  type: MoveListType.inline,
                  slicedMoves: moves.asMap().entries.slices(2),
                  currentMoveIndex: widget.currentMoveIndex ?? moves.length,
                  onSelectMove: widget.onSelectMove,
                ),
              Expanded(child: widget.table),
              widget.bottomBar,
            ],
          );

          return isLandscape
              ? Row(
                  children: [
                    board,
                    Expanded(child: side),
                  ],
                )
              : Column(
                  children: [
                    board,
                    Expanded(child: side),
                  ],
                );
        },
      ),
    );
  }
}
