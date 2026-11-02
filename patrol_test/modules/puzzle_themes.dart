import 'package:lichess_mobile/src/view/puzzle/puzzle_themes_screen.dart';

import 'module.dart';

final class const PuzzleThemes(super.$) extends Module {
  Future<void> waitUntilVisible() => $(PuzzleThemesScreen).waitUntilVisible();
}
