import 'package:lichess_mobile/keys.dart';

import 'module.dart';

final class PuzzleThemes extends Module {
  const PuzzleThemes(super.$);

  Future<void> waitUntilVisible() => $(keys.puzzleThemesScreen.screen).waitUntilVisible();
}
