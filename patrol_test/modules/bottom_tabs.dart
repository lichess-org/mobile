import 'package:lichess_mobile/keys.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';

import 'module.dart';

final class const BottomTabs(super.$) extends Module {
  Future<void> goToPuzzles() => $(keys.tabScaffold.tabIcon(BottomTab.puzzles)).tap();
}
