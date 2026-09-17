import 'package:lichess_mobile/keys.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';

import 'module.dart';

final class BottomTabs extends Module {
  const BottomTabs(super.$);

  Future<void> goToPuzzles() => $(keys.tabScaffold.tabIcon(BottomTab.puzzles)).tap();
}
