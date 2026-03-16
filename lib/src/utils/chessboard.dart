import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';

/// Computes the set of squares that should have an atomic explosion animation
/// after [move] was played from [positionBefore].
///
/// Returns `null` if [positionBefore] is not an atomic position, [move] is
/// null, or the move was not a capture (no explosion occurs).
ISet<Square>? atomicExplosionSquares(Position positionBefore, Move? move) {
  if (move == null || positionBefore is! Atomic) return null;
  final squareSet = positionBefore.explosionSquares(move);
  return squareSet.isEmpty ? null : squareSet.squares.toISet();
}

/// Preload piece images from the specified [PieceSet] into Chessground's image cache.
///
/// This method clears the cache before loading the images.
Future<void> precachePieceImages(PieceSet pieceSet) async {
  try {
    final devicePixelRatio =
        WidgetsBinding.instance.platformDispatcher.implicitView?.devicePixelRatio ?? 1.0;

    ChessgroundImages.instance.clear();

    for (final asset in pieceSet.assets.values) {
      await ChessgroundImages.instance.load(asset, devicePixelRatio: devicePixelRatio);
      debugPrint('Preloaded piece image: ${asset.assetName}');
    }
  } catch (e) {
    debugPrint('Failed to preload piece images: $e');
  }
}
