import '../common/lichess_test_wrapper.dart';
import '../common/open_app.dart';

void main() {
  lichessTest('Open puzzle themes from the puzzles tab', ($, modules, system) async {
    await openApp($);
    await system.grantNotificationsPermission();
    await modules.bottomTabs.goToPuzzles();
    await modules.puzzleTab.openPuzzleThemes();
    await modules.puzzleThemes.waitUntilVisible();
  });
}
