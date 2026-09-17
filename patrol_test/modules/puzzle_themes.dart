import 'package:lichess_mobile/keys.dart';

import 'module.dart';

final class const PuzzleThemes(super.$) extends Module {
  Future<void> waitUntilVisible() => $(keys.puzzleThemesScreen.screen).waitUntilVisible();
}
