import 'package:flutter/widgets.dart';

class const _PuzzleTabKey(String value) extends ValueKey<String> {
  this : super('puzzleTab_$value');
}

class PuzzleTabKeys() {
  final puzzleThemesTile = const _PuzzleTabKey('puzzleThemesTile');
}

class const _PuzzleThemesScreenKey(String value) extends ValueKey<String> {
  this : super('puzzleThemesScreen_$value');
}

class PuzzleThemesScreenKeys() {
  final screen = const _PuzzleThemesScreenKey('screen');
}
