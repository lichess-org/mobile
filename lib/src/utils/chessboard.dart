import 'package:chessground/chessground.dart';
import 'package:flutter/widgets.dart';

/// Preload piece images from the specified [PieceSet] into Chessground's image cache.
///
/// This method clears the cache before loading the images.
Future<void> precachePieceImages(PieceSet pieceSet) async {
  try {
    final devicePixelRatio =
        WidgetsBinding
            .instance
            .platformDispatcher
            .implicitView
            ?.devicePixelRatio ??
        1.0;

    ChessgroundImages.instance.clear();

    for (final asset in pieceSet.assets.values) {
      await ChessgroundImages.instance.load(
        asset,
        devicePixelRatio: devicePixelRatio,
      );
      debugPrint('Preloaded piece image: ${asset.assetName}');
    }
  } catch (e) {
    debugPrint('Failed to preload piece images: $e');
  }
}
