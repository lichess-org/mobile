import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:lichess_mobile/src/model/game/game_filter.dart';
import 'package:lichess_mobile/src/model/game/game_history.dart';
import 'package:lichess_mobile/src/model/game/game_share_service.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/game/archived_game_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';

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

class GameBookmarkContextMenuAction extends ConsumerStatefulWidget {
  const GameBookmarkContextMenuAction({
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
  ConsumerState<GameBookmarkContextMenuAction> createState() =>
      _GameBookmarkContextMenuActionState();
}

class _GameBookmarkContextMenuActionState extends ConsumerState<GameBookmarkContextMenuAction> {
  Future<void>? _pendingBookmarkAction;
  late bool _bookmarked;

  @override
  void initState() {
    _bookmarked = widget.bookmarked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _pendingBookmarkAction,
      builder: (context, snapshot) {
        return PlatformContextMenuAction(
          dismissOnPress: false,
          icon: _bookmarked ? Icons.bookmark_remove_outlined : Icons.bookmark_add_outlined,
          label: _bookmarked ? 'Unbookmark' : 'Bookmark',
          onPressed:
              snapshot.connectionState == ConnectionState.waiting
                  ? null
                  : () async {
                    try {
                      final future = widget.onToggleBookmark();
                      setState(() {
                        _pendingBookmarkAction = future;
                      });
                      await future;
                      if (context.mounted) {
                        setState(() {
                          _bookmarked = !_bookmarked;
                        });
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
        );
      },
    );
  }
}

/// Makes a list of [PlatformContextMenuAction] for game sharing options.
List<Widget> makeFinishedGameShareMenuItemButtons(
  BuildContext context,
  WidgetRef ref, {
  required GameId gameId,
  required Side orientation,
}) {
  return [
    PlatformContextMenuAction(
      icon: Theme.of(context).platform == TargetPlatform.iOS ? Icons.ios_share : Icons.share,
      label: context.l10n.mobileShareGameURL,
      onPressed: () {
        launchShareDialog(context, uri: lichessUri('/$gameId/${orientation.name}'));
      },
    ),
    PlatformContextMenuAction(
      icon: Icons.gif_outlined,
      label: context.l10n.gameAsGIF,
      onPressed: () async {
        try {
          final (gif, game) = await ref.read(gameShareServiceProvider).gameGif(gameId, orientation);
          if (context.mounted) {
            launchShareDialog(context, files: [gif], subject: game.shareTitle(context.l10n));
          }
        } catch (e) {
          debugPrint(e.toString());
          if (context.mounted) {
            showPlatformSnackbar(context, 'Failed to get GIF', type: SnackBarType.error);
          }
        }
      },
    ),
    PlatformContextMenuAction(
      icon: Icons.text_snippet_outlined,
      label: 'PGN: ${context.l10n.downloadAnnotated}',
      onPressed: () async {
        try {
          final pgn = await ref.read(gameShareServiceProvider).annotatedPgn(gameId);
          if (context.mounted) {
            launchShareDialog(context, text: pgn);
          }
        } catch (e) {
          if (context.mounted) {
            showPlatformSnackbar(context, 'Failed to get PGN', type: SnackBarType.error);
          }
        }
      },
    ),
    PlatformContextMenuAction(
      icon: Icons.description_outlined,
      label: 'PGN: ${context.l10n.downloadRaw}',
      onPressed: () async {
        try {
          final pgn = await ref.read(gameShareServiceProvider).rawPgn(gameId);
          if (context.mounted) {
            launchShareDialog(context, text: pgn);
          }
        } catch (e) {
          if (context.mounted) {
            showPlatformSnackbar(context, 'Failed to get PGN', type: SnackBarType.error);
          }
        }
      },
    ),
  ];
}
