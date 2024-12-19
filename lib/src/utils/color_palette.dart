import 'dart:ui';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

CorePalette? _corePalette;

ChessboardColorScheme? _boardColorScheme;

/// Set the system core palette if available (android 12+ only).
///
/// It also defines the system board colors based on the core palette.
void setCorePalette(CorePalette? palette) {
  _corePalette = palette;

  if (palette != null) {
    final darkSquare = Color(palette.secondary.get(60));
    final lightSquare = Color(palette.primary.get(95));

    _boardColorScheme = ChessboardColorScheme(
      darkSquare: darkSquare,
      lightSquare: lightSquare,
      background: SolidColorChessboardBackground(lightSquare: lightSquare, darkSquare: darkSquare),
      whiteCoordBackground: SolidColorChessboardBackground(
        lightSquare: lightSquare,
        darkSquare: darkSquare,
        coordinates: true,
      ),
      blackCoordBackground: SolidColorChessboardBackground(
        lightSquare: lightSquare,
        darkSquare: darkSquare,
        coordinates: true,
        orientation: Side.black,
      ),
      lastMove: HighlightDetails(
        solidColor: Color(palette.tertiary.get(80)).withValues(alpha: 0.6),
      ),
      selected: HighlightDetails(
        solidColor: Color(palette.neutral.get(40)).withValues(alpha: 0.80),
      ),
      validMoves: Color(palette.neutral.get(40)).withValues(alpha: 0.40),
      validPremoves: Color(palette.error.get(40)).withValues(alpha: 0.30),
    );
  }
}

Color? getCorePalettePrimary() {
  return _corePalette?.primary != null ? Color(_corePalette!.primary.get(50)) : null;
}

/// Get the core palette if available (android 12+ only).
CorePalette? getCorePalette() {
  return _corePalette;
}

/// Get the board colors based on the core palette, if available (android 12+).
ChessboardColorScheme? getBoardColorScheme() {
  return _boardColorScheme;
}
