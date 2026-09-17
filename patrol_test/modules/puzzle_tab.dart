import 'package:lichess_mobile/keys.dart';

import 'module.dart';

final class const PuzzleTab(super.$) extends Module {
  Future<void> openPuzzleThemes() => $(keys.puzzleTab.puzzleThemesTile).tap();
}
