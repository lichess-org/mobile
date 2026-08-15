import 'package:dartchess/dartchess.dart';
import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/board_editor/board_editor_screen.dart';
import 'package:lichess_mobile/src/view/offline_computer/offline_computer_game_screen.dart';
import 'package:lichess_mobile/src/view/over_the_board/over_the_board_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';

void openBoardEditor(BuildContext context, Variant variant, String fen, Side orientation) {
  Navigator.of(context).push(
    BoardEditorScreen.buildRoute((
      initialVariant: variant,
      initialFen: fen,
      initialOrientation: orientation,
    )),
  );
}

Future<void> showContinueFromHereMenu(BuildContext context, Variant variant, String fen) {
  return showAdaptiveActionSheet(
    context: context,
    actions: [
      BottomSheetAction(
        makeLabel: (context) => Text(context.l10n.playAgainstComputer),
        onPressed: () => Navigator.of(
          context,
        ).push(OfflineComputerGameScreen.buildRoute(initialVariant: variant, initialFen: fen)),
      ),
      BottomSheetAction(
        makeLabel: (context) => Text(context.l10n.mobileOverTheBoard),
        onPressed: () => Navigator.of(
          context,
        ).push(OverTheBoardScreen.buildRoute(initialVariant: variant, initialFen: fen)),
      ),
    ],
  );
}
