import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:material_ui/material_ui.dart';

/// Visualization of captured pieces in variants like Crazyhouse.
class const PocketsMenu({
  required final Pockets pockets,
  required final Side side,

  /// If this is equal to [side] and matches [playerSide], pieces from the pockets are can be dragged onto the board to make a move.
  required final Side? sideToMove,

  /// Which side can interact with the board. If this matches [side] and [sideToMove], pieces from the pockets can be dragged onto the board to make a move.
  required final PlayerSide playerSide,

  /// Size of a square on the chessboard.
  ///
  /// Pieces in the pockets are rendered at the same size as pieces on the board.
  required final double squareSize,

  /// Whether the menu is currently rendered upside down by the parent widget.
  ///
  /// This is used to also flip the drag feedback widget when dragging a piece onto the board.
  final bool isUpsideDown = false,

  /// If non-null and [side] is the opposite of [sideToMove], the pocket with this role will be highlighted.
  final Role? premoveDropRole,

  /// Optionally overrides pieces assets used to render the pieces in the pockets.
  ///
  /// If null, the piece assets from the current board preferences are used.
  final PieceAssets? pieceAssets,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardPrefs = ref.watch(boardPreferencesProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(borderRadius: Styles.boardBorderRadius),
        child: ColoredBox(
          color: Theme.of(context).disabledColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: Role.values
                .where((role) => role != Role.king)
                .map(
                  (role) => Container(
                    color: side == sideToMove?.opposite && premoveDropRole == role
                        ? ref.watch(
                            boardPreferencesProvider.select(
                              (prefs) => prefs.boardTheme.colors.validPremoves,
                            ),
                          )
                        : null,
                    child: _Pocket(
                      count: pockets.of(side, role),
                      role: role,
                      interactive: switch (playerSide) {
                        PlayerSide.none => false,
                        // If these are the pockets of the user, they are always interactive to allow premoves.
                        PlayerSide.white => side == Side.white,
                        PlayerSide.black => side == Side.black,
                        // In OTB games, premoves are not possible, so pockets are only interactive if it's this player's turn.
                        PlayerSide.both => side == sideToMove,
                      },

                      side: side,
                      squareSize: squareSize,
                      pieceAssets: pieceAssets ?? boardPrefs.pieceSet.assets,
                      isUpsideDown: isUpsideDown,
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ),
      ),
    );
  }
}

class const _Pocket({
  required final Role role,
  required final int count,
  required final bool interactive,
  required final Side side,
  required final double squareSize,
  required final PieceAssets pieceAssets,
  required final bool isUpsideDown,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final piece = Piece(role: role, color: side);

    return IgnorePointer(
      ignoring: !interactive || count == 0,
      child: Draggable(
        key: ValueKey('pocket-${side.name}${role.name}'),
        dragAnchorStrategy: pointerDragAnchorStrategy,
        data: Piece(role: role, color: side),
        feedback: RotatedBox(
          quarterTurns: isUpsideDown ? 2 : 0,
          child: PieceDragFeedback(
            piece: piece,
            squareSize: squareSize,
            pieceAssets: pieceAssets,
            offset: isUpsideDown ? const Offset(1, 0) : const Offset(0, -1),
          ),
        ),
        child: Badge(
          offset: Offset.zero,
          backgroundColor: ColorScheme.of(context).secondary,
          textStyle: TextStyle(
            color: ColorScheme.of(context).onSecondary,
            fontWeight: FontWeight.bold,
          ),
          isLabelVisible: count > 0,
          label: count > 0 ? Text('$count') : null,
          child: PieceWidget(
            piece: piece,
            size: squareSize,
            pieceAssets: pieceAssets,
            opacity: count == 0 ? const AlwaysStoppedAnimation(0.3) : null,
          ),
        ),
      ),
    );
  }
}
