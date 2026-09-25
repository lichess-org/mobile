import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_share_service.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';

/// Options for exporting a game as a GIF.
///
/// A plain immutable class on purpose: `build.yaml` only runs code generation for
/// `lib/src/model/**`, `*_models.dart` and `*_providers.dart`, so a `@freezed` class here would
/// have no generated part file in CI.
class const GifExportOptions({
  required final bool playerNames,
  required final bool showPlayerRatings,
  required final bool moveAnnotations,
  required final bool chessClock,
});

/// Fetches GIF using the given [options] and launches the share dialog.
Future<void> shareGameGif(
  BuildContext context,
  WidgetRef ref,
  GameId gameId,
  Side orientation,
  GifExportOptions options,
) async {
  try {
    final (gif, game) = await ref
        .read(gameShareServiceProvider)
        .gameGif(
          gameId,
          orientation,
          playerNames: options.playerNames,
          showPlayerRatings: options.showPlayerRatings,
          moveAnnotations: options.moveAnnotations,
          chessClock: options.chessClock,
        );
    if (context.mounted) {
      launchShareDialog(
        context,
        ShareParams(
          fileNameOverrides: ['$gameId.gif'],
          files: [gif],
          subject: game.shareTitle(context.l10n),
        ),
      );
    }
  } catch (e) {
    debugPrint(e.toString());
    if (context.mounted) {
      showSnackBar(context, 'Failed to get GIF', type: SnackBarType.error);
    }
  }
}
