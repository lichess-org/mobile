import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';

/// Widget that provides a screen reader-friendly interface to a chess board
class NonVisualBoard extends StatefulWidget {
  const NonVisualBoard({
    required this.position,
    required this.lastSanMove,
    required this.handleCommand,
    super.key,
  });

  final Position position;

  final String lastSanMove;

  /// Callback called when a command is submitted.
  ///
  /// Optionally returns a message to be announced.
  final String? Function(String command) handleCommand;

  @override
  State<NonVisualBoard> createState() => _NonVisualBoardState();
}

class _NonVisualBoardState extends State<NonVisualBoard> {
  final textController = TextEditingController();

  // Is this necessary? _GameBoardLayoutState doesn't override dispose.
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void announce(String msg) {
      final snackBar = SnackBar(content: Text(msg));
      // TODO: do snackbars still get read if identical ones get read twice in a row?
      // might need to delete the current snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return ListView(
      children: <Widget>[
        const Text('Current position'),
        Semantics(
          liveRegion: true,
          // TODO: decide on a set of parameters
          child: Text(renderCurrentPos(widget.lastSanMove, widget.position)),
        ),
        TextField(
          decoration: const InputDecoration(
            labelText: 'move input',
          ),
          controller: textController,
          onSubmitted: (input) {
            final message = widget.handleCommand(input);
            if (message != null) {
              announce(message);
            }
            textController.clear();
          },
        ),
      ],
    );
  }
}

String renderCurrentPos(String? lastSanMove, Position position) {
  if (lastSanMove == null) {
    return 'Initial position';
  }
  final moveNum = position.fullmoves;
  // Disambiguate odd and even plies with whitespace so that consecutive
  // moves with the same textual representation still get announced.
  final plyWhitepsace = position.halfmoves.isOdd ? '' : ' ';
  return '$moveNum $lastSanMove$plyWhitepsace';
}

String? handlePieceCommand(String command, Board board) {
  if (command.toLowerCase().startsWith('p ')) {
    final rawPiece = command.substring(2);
    final piece = Piece.fromChar(rawPiece);
    if (piece != null) {
      return _renderLocationOfPieces(board, piece);
    } else {
      return 'Invalid piece command: $rawPiece is not a piece';
    }
  } else {
    return null;
  }
}

String? handleScanCommand(String lowercaseCommand, Board board) {
  if (lowercaseCommand.startsWith('s ')) {
    final rankOrFile = lowercaseCommand.substring(2);
    if (_rowOrFileRegExp.hasMatch(rankOrFile)) {
      return _renderPiecesByLocation(board, rankOrFile);
    } else {
      return 'Invalid scan command: $rankOrFile is not a rank nor a file';
    }
  } else {
    return null;
  }
}

String _renderLocationOfPieces(Board board, Piece piece) {
  bool isCorrectPiece(Piece other) {
    return piece.role == other.role && piece.color == other.color;
  }

  final locations = board.pieces
      .where((tuple) => isCorrectPiece(tuple.item2))
      .map((tuple) => toAlgebraic(tuple.item1))
      .join(', ');
  final explicitLocations = locations.isNotEmpty ? locations : 'none';
  return '${_colorName(piece.color)} ${_roleName(piece.role)}: $explicitLocations';
}

String _renderPiecesByLocation(Board board, String rankOrFile) {
  String renderPiece(Tuple2<int, Piece> tuple) {
    final square = tuple.item1;
    final piece = tuple.item2;
    return '${toAlgebraic(square)} ${_colorName(piece.color)} ${_roleName(piece.role)}';
  }

  final pieces = board.pieces
      .where((tuple) => toAlgebraic(tuple.item1).contains(rankOrFile))
      .map(renderPiece)
      .join(', ');
  return pieces.isNotEmpty ? pieces : 'blank';
}

final _rowOrFileRegExp = RegExp(r'^[a-h1-8]$');

String _colorName(Side side) {
  switch (side) {
    case Side.black:
      return 'black';
    case Side.white:
      return 'white';
  }
}

String _roleName(Role role) {
  switch (role) {
    case Role.pawn:
      return 'pawn';
    case Role.knight:
      return 'knight';
    case Role.bishop:
      return 'bishop';
    case Role.rook:
      return 'rook';
    case Role.queen:
      return 'queen';
    case Role.king:
      return 'king';
  }
}
