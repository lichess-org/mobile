import 'package:lichess_mobile/keys.dart';

import 'module.dart';

final class PuzzleTab extends Module {
  const PuzzleTab(super.$);

  Future<void> openPuzzleThemes() => $(keys.puzzleTab.puzzleThemesTile).tap();
}
