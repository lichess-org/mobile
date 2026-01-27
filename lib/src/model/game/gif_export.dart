import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_share_service.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:share_plus/share_plus.dart';

part 'gif_export.freezed.dart';

@freezed
sealed class GifExportOptions with _$GifExportOptions {
  const factory GifExportOptions({
    required bool playerNames,
    required bool showPlayerRatings,
    required bool moveAnnotations,
    required bool chessClock,
  }) = _GifExportOptions;
}

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
