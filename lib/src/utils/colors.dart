import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/brightness.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'colors.g.dart';

/// A [ColorScheme] according to the current board theme and brightness, independant of the system theme.
@Riverpod(keepAlive: true)
ColorScheme boardColors(BoardColorsRef ref) {
  final brightness = ref.watch(currentBrightnessProvider);
  final boardTheme = ref.watch(
    boardPreferencesProvider.select((state) => state.boardTheme),
  );
  return ColorScheme.fromSeed(
    seedColor: boardTheme.colors.darkSquare,
    brightness: brightness,
  );
}
