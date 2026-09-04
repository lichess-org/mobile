import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/widgets.dart';

/// Computes the set of squares that should have an atomic explosion animation
/// after [move] was played from [positionBefore].
///
/// Returns `null` if [positionBefore] is not an atomic position, [move] is
/// null, or the move was not a capture (no explosion occurs).
Set<Square>? atomicExplosionSquares(Position positionBefore, Move? move) {
  if (move == null || positionBefore is! Atomic) return null;
  final squareSet = positionBefore.explosionSquares(move);
  return squareSet.isEmpty ? null : squareSet.squares.toSet();
}

PieceSet? _lastCachedPieceSet;

/// Preload piece images from the specified [PieceSet] into Chessground's image cache.
///
/// This method clears the cache before loading the images. Subsequent calls
/// with the same [pieceSet] are skipped to avoid flash and redundant work.
Future<void> precachePieceImages(PieceSet pieceSet) async {
  if (_lastCachedPieceSet == pieceSet) return;
  _lastCachedPieceSet = pieceSet;

  try {
    final devicePixelRatio =
        WidgetsBinding.instance.platformDispatcher.implicitView?.devicePixelRatio ?? 1.0;

    ChessgroundImages.instance.clear();

    await Future.wait([
      for (final asset in pieceSet.assets.values)
        ChessgroundImages.instance.load(asset, devicePixelRatio: devicePixelRatio),
    ]);
  } catch (e) {
    debugPrint('Failed to preload piece images: $e');
  }
}
