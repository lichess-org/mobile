import 'package:lichess_mobile/src/styles/puzzle_icons.dart';

import 'module.dart';

final class const PuzzleTab(super.$) extends Module {
  Future<void> openPuzzleThemes() => $(PuzzleIcons.opening).tap();
}
