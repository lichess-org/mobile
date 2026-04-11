import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';

/// Visualization of captured pieces in variants like Crazyhouse.
class PocketsMenu extends ConsumerWidget {
  const PocketsMenu({
    required this.pockets,
    required this.side,
    required this.sideToMove,
    required this.playerSide,
    required this.squareSize,
    this.isUpsideDown = false,
    this.premoveDropRole,
    this.pieceAssets,
  });

  final Pockets pockets;

  final Side side;

  /// If this is equal to [side] and matches [playerSide], pieces from the pockets are can be dragged onto the board to make a move.
  final Side? sideToMove;

  /// Which side can interact with the board. If this matches [side] and [sideToMove], pieces from the pockets can be dragged onto the board to make a move.
  final PlayerSide playerSide;

  /// Size of a square on the chessboard.
  ///
  /// Pieces in the pockets are rendered at the same size as pieces on the board.
  final double squareSize;

  /// Whether the menu is currently rendered upside down by the parent widget.
  ///
  /// This is used to also flip the drag feedback widget when dragging a piece onto the board.
  final bool isUpsideDown;

  /// If non-null and [side] is the opposite of [sideToMove], the pocket with this role will be highlighted.
  final Role? premoveDropRole;

  /// Optionally overrides pieces assets used to render the pieces in the pockets.
  ///
  /// If null, the piece assets from the current board preferences are used.
  final PieceAssets? pieceAssets;

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

class _Pocket extends StatelessWidget {
  const _Pocket({
    required this.role,
    required this.count,
    required this.interactive,
    required this.side,
    required this.squareSize,
    required this.pieceAssets,
    required this.isUpsideDown,
  });

  final Role role;
  final int count;
  final bool interactive;
  final Side side;
  final double squareSize;
  final PieceAssets pieceAssets;
  final bool isUpsideDown;

  @override
  Widget build(BuildContext context) {
    final piece = Piece(role: role, color: side);

    return IgnorePointer(
      ignoring: !interactive || count == 0,
      child: Draggable(
        key: ValueKey('pocket-${side.name}${role.name}'),
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
