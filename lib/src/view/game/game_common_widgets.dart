import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_filter.dart';
import 'package:lichess_mobile/src/model/game/game_history.dart';
import 'package:lichess_mobile/src/model/game/game_share_service.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';

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

/// A bottom sheet that shows the share options for a game.
class GameShareBottomSheet extends ConsumerWidget {
  const GameShareBottomSheet({
    required this.game,
    required this.currentGamePosition,
    required this.orientation,
    this.lastMove,
    super.key,
  });

  final BaseGame game;
  final Position currentGamePosition;
  final Side orientation;
  final Move? lastMove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomSheetScrollableContainer(
      children: [
        BottomSheetContextMenuAction(
          icon: CupertinoIcons.link,
          closeOnPressed: false,
          onPressed: () {
            launchShareDialog(context, uri: lichessUri('/${game.id}'));
          },
          child: Text(context.l10n.mobileShareGameURL),
        ),
        if (game.finished) ...[
          // Builder is used to retrieve the context immediately surrounding the
          // BottomSheetContextMenuAction
          // This is necessary to get the correct context for the iPad share dialog
          // which needs the position of the action to display the share dialog
          Builder(
            builder: (context) {
              return BottomSheetContextMenuAction(
                icon: Icons.gif,
                closeOnPressed: false, // needed for the share dialog on iPad
                child: Text(context.l10n.gameAsGIF),
                onPressed: () async {
                  try {
                    final gif = await ref
                        .read(gameShareServiceProvider)
                        .gameGif(game.id, orientation);
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
              );
            },
          ),
          if (lastMove != null)
            // Builder is used to retrieve the context immediately surrounding the
            // BottomSheetContextMenuAction
            // This is necessary to get the correct context for the iPad share dialog
            // which needs the position of the action to display the share dialog
            Builder(
              builder: (context) {
                return BottomSheetContextMenuAction(
                  icon: Icons.image,
                  closeOnPressed: false, // needed for the share dialog on iPad
                  child: Text(context.l10n.screenshotCurrentPosition),
                  onPressed: () async {
                    try {
                      final image = await ref
                          .read(gameShareServiceProvider)
                          .screenshotPosition(orientation, currentGamePosition.fen, lastMove);
                      if (context.mounted) {
                        launchShareDialog(
                          context,
                          files: [image],
                          subject: context.l10n.puzzleFromGameLink(
                            lichessUri('/${game.id}').toString(),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        showPlatformSnackbar(
                          context,
                          'Failed to get GIF',
                          type: SnackBarType.error,
                        );
                      }
                    }
                  },
                );
              },
            ),
          // Builder is used to retrieve the context immediately surrounding the
          // BottomSheetContextMenuAction
          // This is necessary to get the correct context for the iPad share dialog
          // which needs the position of the action to display the share dialog
          Builder(
            builder: (context) {
              return BottomSheetContextMenuAction(
                icon: Icons.text_snippet,
                closeOnPressed: false, // needed for the share dialog on iPad
                child: Text('PGN: ${context.l10n.downloadAnnotated}'),
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
              );
            },
          ),
          // Builder is used to retrieve the context immediately surrounding the
          // BottomSheetContextMenuAction
          // This is necessary to get the correct context for the iPad share dialog
          // which needs the position of the action to display the share dialog
          Builder(
            builder: (context) {
              return BottomSheetContextMenuAction(
                icon: Icons.text_snippet,
                closeOnPressed: false, // needed for the share dialog on iPad
                // TODO improve translation
                child: Text('PGN: ${context.l10n.downloadRaw}'),
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
              );
            },
          ),
        ],
      ],
    );
  }
}
