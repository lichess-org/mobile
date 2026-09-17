import 'package:patrol/patrol.dart';

import 'bottom_tabs.dart';
import 'puzzle_tab.dart';
import 'puzzle_themes.dart';

final class Modules {
  Modules(this._$);

  final PatrolIntegrationTester _$;

  late final bottomTabs = BottomTabs(_$);
  late final puzzleTab = PuzzleTab(_$);
  late final puzzleThemes = PuzzleThemes(_$);
}
