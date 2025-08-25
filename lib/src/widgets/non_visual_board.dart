import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

/// A non-visual chessboard for blind players using screen readers
class NonVisualBoard extends StatefulWidget {
  const NonVisualBoard({
    super.key,
    required this.size,
    required this.fen,
    required this.orientation,
    required this.gameData,
    this.lastMove,
    this.shapes,
    required this.settings,
  });

  final double size;
  final String fen;
  final Side orientation;
  final GameData? gameData;
  final Move? lastMove;
  final ISet<Shape>? shapes;
  final ChessboardSettings settings;

  @override
  State<NonVisualBoard> createState() => _NonVisualBoardState();
}

class _NonVisualBoardState extends State<NonVisualBoard> {
  Square? _selectedSquare;
  Position? _position;
  bool _isSelecting = false;

  @override
  void initState() {
    super.initState();
    _updatePosition();
  }

  @override
  void didUpdateWidget(NonVisualBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fen != widget.fen) {
      _updatePosition();
    }
  }

  void _updatePosition() {
    try {
      _position = Chess.fromSetup(Setup.parseFen(widget.fen));
    } catch (e) {
      debugPrint('Error parsing FEN: $e');
      _position = null;
    }
  }

  String _getPieceName(Piece? piece) {
    if (piece == null) return '';
    
    final role = piece.role;
    final color = piece.color == chess.Color.white ? 'white' : 'black';
    
    switch (role) {
      case Role.pawn:
        return '$color pawn';
      case Role.knight:
        return '$color knight';
      case Role.bishop:
        return '$color bishop';
      case Role.rook:
        return '$color rook';
      case Role.queen:
        return '$color queen';
      case Role.king:
        return '$color king';
      default:
        return '';
    }
  }

  String _getSquareDescription(Square square) {
    final file = 'abcdefgh'[square.file];
    final rank = square.rank + 1;
    final piece = _position?.pieceAt(square);
    final pieceName = _getPieceName(piece);
    
    if (pieceName.isEmpty) {
      return '$file$rank, empty';
    } else {
      return '$file$rank, $pieceName';
    }
  }

  String _getMoveDescription(Square from, Square to) {
    final piece = _position?.pieceAt(from);
    if (piece == null) return '';
    
    final pieceName = _getPieceName(piece);
    final fromCoord = 'abcdefgh'[from.file] + (from.rank + 1).toString();
    final toCoord = 'abcdefgh'[to.file] + (to.rank + 1).toString();
    
    final targetPiece = _position?.pieceAt(to);
    if (targetPiece != null) {
      final targetPieceName = _getPieceName(targetPiece);
      return '$pieceName $fromCoord takes $targetPieceName on $toCoord';
    } else {
      return '$pieceName $fromCoord to $toCoord';
    }
  }

  void _onSquareTap(Square square) {
    if (_position == null || widget.gameData == null) return;
    
    if (_selectedSquare == null) {
      // First selection
      final piece = _position!.pieceAt(square);
      if (piece != null && 
          (widget.gameData!.playerSide == PlayerSide.none || 
           (piece.color == chess.Color.white && widget.gameData!.playerSide == PlayerSide.white) ||
           (piece.color == chess.Color.black && widget.gameData!.playerSide == PlayerSide.black))) {
        setState(() {
          _selectedSquare = square;
          _isSelecting = true;
        });
        // Announce selection
        SemanticsService.announce(
          '${_getPieceName(piece)} on ${_getSquareDescription(square)} selected. Drag to select destination.',
          TextDirection.ltr,
        );
      }
    } else {
      // Second selection - attempt to make a move
      final from = _selectedSquare!;
      final to = square;
      
      if (from == to) {
        // Cancel selection if tapping the same square
        setState(() {
          _selectedSquare = null;
          _isSelecting = false;
        });
        SemanticsService.announce('Selection canceled', TextDirection.ltr);
        return;
      }
      
      try {
        final move = NormalMove(from: from, to: to);
        widget.gameData?.onMove(move);
        setState(() {
          _selectedSquare = null;
          _isSelecting = false;
        });
      } catch (e) {
        SemanticsService.announce('Invalid move', TextDirection.ltr);
      }
    }
  }

  void _cancelSelection() {
    if (_selectedSquare != null) {
      setState(() {
        _selectedSquare = null;
        _isSelecting = false;
      });
      SemanticsService.announce('Selection canceled', TextDirection.ltr);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_position == null) {
      return SizedBox.square(
        dimension: widget.size,
        child: Center(
          child: Text(context.l10n.invalidFen),
        ),
      );
    }

    final boardSize = widget.size;
    final squareSize = boardSize / 8;

    return SizedBox.square(
      dimension: boardSize,
      child: Column(
        children: [
          // Instructions for screen reader users
          Semantics(
            label: 'Non-visual chess board. Tap on squares to select and move pieces.',
            excludeSemantics: true,
            child: const SizedBox(height: 0),
          ),
          // Board representation
          for (int rank = 7; rank >= 0; rank--)
            Row(
              children: [
                for (int file = 0; file < 8; file++)
                  GestureDetector(
                    onTap: () {
                      final square = Square.fromFileRank(file, rank);
                      _onSquareTap(square);
                    },
                    child: Semantics(
                      label: _getSquareDescription(Square.fromFileRank(file, rank)),
                      onTap: () {
                        final square = Square.fromFileRank(file, rank);
                        _onSquareTap(square);
                      },
                      onTapHint: _isSelecting && _selectedSquare != null
                          ? 'Select as destination'
                          : 'Select piece',
                      child: Container(
                        width: squareSize,
                        height: squareSize,
                        color: (file + rank) % 2 == 0
                            ? Colors.grey[300]
                            : Colors.grey[600],
                        child: _selectedSquare?.file == file && _selectedSquare?.rank == rank
                            ? Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 3,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
              ],
            ),
          // Cancel selection button
          if (_selectedSquare != null)
            Semantics(
              button: true,
              label: 'Cancel selection',
              onTap: _cancelSelection,
              child: GestureDetector(
                onTap: _cancelSelection,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.red[200],
                  child: const Center(
                    child: Text(
                      'Cancel selection',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}