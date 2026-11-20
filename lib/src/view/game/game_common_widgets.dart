import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/exported_game.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/service/game_share_service.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen_providers.dart';
import 'package:lichess_mobile/src/view/game/gif_export_dialog.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';
import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';

/// Opens a game screen for the given [LightExportedGame].
///
/// Will open [GameScreen] if the game Id is a [GameFullId], otherwise [AnalysisScreen].
///
/// If the game is not read supported, a snackbar is shown.
void openGameScreen(
  BuildContext context, {
  required LightExportedGame game,
  required Side orientation,
  String? loadingFen,
  Move? loadingLastMove,
  DateTime? lastMoveAt,
}) {
  if (game.variant.isReadSupported) {
    Navigator.of(context).pushHidingTabBar(
      game.fullId != null
          ? GameScreen.buildRoute(
              source: ExistingGameSource(game.fullId!),
              loadingPosition: (
                variant: game.variant,
                fen: loadingFen,
                lastMove: loadingLastMove,
                orientation: orientation,
              ),
              lastMoveAt: lastMoveAt,
            )
          : AnalysisScreen.buildRoute(
              AnalysisOptions.archivedGame(
                orientation: orientation,
                gameId: game.id,
                initialMoveCursor: 0,
              ),
            ),
    );
  } else {
    showSnackBar(context, 'This variant is not supported yet.', type: SnackBarType.info);
  }
}

/// Makes the game sharing actions of a "Share & export" submenu.
///
/// The game URL can always be shared; the GIF and PGN exports are only available once the game is
/// [finished].
List<ContextMenuAction> makeFinishedGameShareMenuActions(
  BuildContext context,
  WidgetRef ref, {
  required GameId gameId,
  required Side orientation,
  required bool finished,
}) {
  return [
    ContextMenuAction(
      label: context.l10n.mobileShareGameURL,
      onPressed: () {
        launchShareDialog(
          context,
          ShareParams(uri: lichessGameUri(gameId, orientation: orientation)),
        );
      },
    ),
    if (finished) ...[
      ContextMenuAction(
        label: context.l10n.gameAsGIF,
        onPressed: () => showAdaptiveBottomSheet<void>(
          context: context,
          builder: (_) => GifExport(gameId: gameId, orientation: orientation),
        ),
      ),
      ContextMenuAction(
        label: context.l10n.downloadAnnotated,
        onPressed: () async {
          try {
            final pgn = await ref.read(gameShareServiceProvider).annotatedPgn(gameId);
            if (context.mounted) {
              launchShareDialog(context, ShareParams(text: pgn));
            }
          } catch (e) {
            if (context.mounted) {
              showSnackBar(context, 'Failed to get PGN', type: SnackBarType.error);
            }
          }
        },
      ),
      ContextMenuAction(
        label: context.l10n.downloadRaw,
        onPressed: () async {
          try {
            final pgn = await ref.read(gameShareServiceProvider).rawPgn(gameId);
            if (context.mounted) {
              launchShareDialog(context, ShareParams(text: pgn));
            }
          } catch (e) {
            if (context.mounted) {
              showSnackBar(context, 'Failed to get PGN', type: SnackBarType.error);
            }
          }
        },
      ),
    ],
  ];
}
