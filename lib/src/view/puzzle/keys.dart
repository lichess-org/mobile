import 'package:flutter/widgets.dart';

class _PuzzleTabKey extends ValueKey<String> {
  const _PuzzleTabKey(String value) : super('puzzleTab_$value');
}

class PuzzleTabKeys {
  final puzzleThemesTile = const _PuzzleTabKey('puzzleThemesTile');
}

class _PuzzleThemesScreenKey extends ValueKey<String> {
  const _PuzzleThemesScreenKey(String value) : super('puzzleThemesScreen_$value');
}

class PuzzleThemesScreenKeys {
  final screen = const _PuzzleThemesScreenKey('screen');
}
