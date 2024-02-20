import 'package:material_color_utilities/material_color_utilities.dart';

CorePalette? _corePalette;

void setCorePalette(CorePalette? palette) {
  _corePalette = palette;
}

/// Get the core palette if available (android 12+ only).
CorePalette? getCorePalette() {
  return _corePalette;
}
