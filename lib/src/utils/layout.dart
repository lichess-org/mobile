import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

final _appBarHeight = defaultTargetPlatform == TargetPlatform.iOS ? 44.0 : 56.0;

// bottom bar height in board screens
const _bottomBarHeight = 50.0;

/// Returns the estimated height of screen left the board
double estimateRemainingHeightLeftBoard(BuildContext context) {
  final size = MediaQuery.sizeOf(context);
  final padding = MediaQuery.paddingOf(context);
  final safeViewportHeight = size.height - padding.top - padding.bottom;
  final boardSize = size.width;

  return safeViewportHeight - boardSize - _appBarHeight - _bottomBarHeight;
}
