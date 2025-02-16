import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_filter.dart';
import 'package:lichess_mobile/src/model/game/game_history.dart';
import 'package:lichess_mobile/src/model/game/game_share_service.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/game/archived_game_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';

/// Opens a game screen for the given [LightArchivedGame].
///
/// Will open [GameScreen] if the game Id is a [GameFullId], otherwise [ArchivedGameScreen].
///
/// If the game is not read supported, a snackbar is shown.
void openGameScreen(
  BuildContext context, {
  required LightArchivedGame game,
  required Side orientation,
  String? loadingFen,
  Move? loadingLastMove,
  DateTime? lastMoveAt,
  (UserId?, GameFilterState)? gameListContext,
}) {
  if (game.variant.isReadSupported) {
    Navigator.of(context, rootNavigator: true).push(
      game.fullId != null
          ? GameScreen.buildRoute(
            context,
            initialGameId: game.fullId,
            loadingOrientation: orientation,
            loadingFen: loadingFen,
            loadingLastMove: loadingLastMove,
            lastMoveAt: lastMoveAt,
            gameListContext: gameListContext,
          )
          : ArchivedGameScreen.buildRoute(
            context,
            gameData: game,
            orientation: orientation,
            gameListContext: gameListContext,
          ),
    );
  } else {
    showPlatformSnackbar(context, 'This variant is not supported yet.', type: SnackBarType.info);
  }
}

class GameBookmarkMenuItemButton extends ConsumerStatefulWidget {
  const GameBookmarkMenuItemButton({
    required this.id,
    required this.bookmarked,
    required this.onToggleBookmark,
    this.gameListContext,
    super.key,
  });

  final GameId id;
  final bool bookmarked;
  final Future<void> Function() onToggleBookmark;

  /// The context of the game list that opened this screen, if available.
  ///
  /// It is used to invalidate the user game history, if the game was loaded from a user's game history.
  /// If the [UserId] is null, it means the game was not loaded from the current logged in user's game history.
  final (UserId?, GameFilterState)? gameListContext;

  @override
  ConsumerState<GameBookmarkMenuItemButton> createState() => _GameBookmarkMenuItemButtonState();
}

class _GameBookmarkMenuItemButtonState extends ConsumerState<GameBookmarkMenuItemButton> {
  Future<void>? _pendingBookmarkAction;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _pendingBookmarkAction,
      builder: (context, snapshot) {
        return MenuItemButton(
          closeOnActivate: false,
          leadingIcon: Icon(
            widget.bookmarked ? Icons.bookmark_remove_outlined : Icons.bookmark_add_outlined,
          ),
          semanticsLabel: widget.bookmarked ? 'Unbookmark' : 'Bookmark',
          onPressed:
              snapshot.connectionState == ConnectionState.waiting
                  ? null
                  : () async {
                    try {
                      await widget.onToggleBookmark();
                      if (context.mounted) {
                        if (widget.gameListContext != null) {
                          final historyProvider = userGameHistoryProvider(
                            widget.gameListContext!.$1,
                            isOnline: true,
                            filter: widget.gameListContext!.$2,
                          );
                          if (ref.exists(historyProvider)) {
                            ref.read(historyProvider.notifier).toggleBookmark(widget.id);
                          }
                        }
                      }
                    } catch (_) {
                      if (context.mounted) {
                        showPlatformSnackbar(
                          context,
                          'Bookmark action failed',
                          type: SnackBarType.error,
                        );
                      }
                    }
                  },
          child: Text(widget.bookmarked ? 'Unbookmark' : 'Bookmark'),
        );
      },
    );
  }
}

/// Makes a list of [MenuItemButton] for game sharing options.
List<Widget> makeFinishedGameShareMenuItemButtons(
  BuildContext context,
  WidgetRef ref, {
  required BaseGame game,
  required Position currentGamePosition,
  required Side orientation,
  Move? lastMove,
}) {
  return game.finished
      ? [
        MenuItemButton(
          leadingIcon: const Icon(Icons.link_outlined),
          onPressed: () {
            launchShareDialog(context, uri: lichessUri('/${game.id}'));
          },
          child: Text(context.l10n.mobileShareGameURL),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.gif_outlined),
          onPressed: () async {
            try {
              final gif = await ref.read(gameShareServiceProvider).gameGif(game.id, orientation);
              if (context.mounted) {
                launchShareDialog(
                  context,
                  files: [gif],
                  subject:
                      '${game.meta.perf.title} • ${context.l10n.resVsX(game.white.fullName(context), game.black.fullName(context))}',
                );
              }
            } catch (e) {
              debugPrint(e.toString());
              if (context.mounted) {
                showPlatformSnackbar(context, 'Failed to get GIF', type: SnackBarType.error);
              }
            }
          },
          child: Text(context.l10n.gameAsGIF),
        ),
        if (lastMove != null)
          MenuItemButton(
            leadingIcon: const Icon(Icons.image_outlined),
            onPressed: () async {
              try {
                final image = await ref
                    .read(gameShareServiceProvider)
                    .screenshotPosition(orientation, currentGamePosition.fen, lastMove);
                if (context.mounted) {
                  launchShareDialog(
                    context,
                    files: [image],
                    subject: context.l10n.puzzleFromGameLink(lichessUri('/${game.id}').toString()),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  showPlatformSnackbar(context, 'Failed to get GIF', type: SnackBarType.error);
                }
              }
            },
            child: Text(context.l10n.screenshotCurrentPosition),
          ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.text_snippet_outlined),
          onPressed: () async {
            try {
              final pgn = await ref.read(gameShareServiceProvider).annotatedPgn(game.id);
              if (context.mounted) {
                launchShareDialog(context, text: pgn);
              }
            } catch (e) {
              if (context.mounted) {
                showPlatformSnackbar(context, 'Failed to get PGN', type: SnackBarType.error);
              }
            }
          },
          child: Text('PGN: ${context.l10n.downloadAnnotated}'),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.description_outlined),
          onPressed: () async {
            try {
              final pgn = await ref.read(gameShareServiceProvider).rawPgn(game.id);
              if (context.mounted) {
                launchShareDialog(context, text: pgn);
              }
            } catch (e) {
              if (context.mounted) {
                showPlatformSnackbar(context, 'Failed to get PGN', type: SnackBarType.error);
              }
            }
          },
          child: Text('PGN: ${context.l10n.downloadRaw}'),
        ),
      ]
      : [];
}
