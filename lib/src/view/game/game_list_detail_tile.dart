import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:lichess_mobile/src/model/game/game_filter.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/game/game_common_widgets.dart';
import 'package:lichess_mobile/src/view/game/game_list_tile.dart';
import 'package:lichess_mobile/src/view/game/status_l10n.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

/// A list tile that shows more detailed game info than [GameListTile].
class GameListDetailTile extends StatelessWidget {
  const GameListDetailTile({required this.item, this.onPressedBookmark, this.gameListContext});

  final LightArchivedGameWithPov item;
  final Future<void> Function(BuildContext context)? onPressedBookmark;

  /// The context of the game list that opened this screen, if available.
  final (UserId?, GameFilterState)? gameListContext;

  Side get mySide => item.pov;

  @override
  Widget build(BuildContext context) {
    final (game: game, pov: youAre) = item;
    final me = youAre == Side.white ? game.white : game.black;
    final opponent = youAre == Side.white ? game.black : game.white;

    final customColors = Theme.of(context).extension<CustomColors>();

    final dateStyle = TextStyle(
      color: textShade(context, 0.5),
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      height: 1,
    );

    return AdaptiveInkWell(
      onLongPress: () {
        showAdaptiveBottomSheet<void>(
          context: context,
          useRootNavigator: true,
          isDismissible: true,
          isScrollControlled: true,
          showDragHandle: true,
          builder:
              (context) => GameContextMenu(
                opponentTitle: UserFullNameWidget.player(
                  user: opponent.user,
                  aiLevel: opponent.aiLevel,
                  rating: opponent.rating,
                ),
                game: game,
                mySide: mySide,
                showGameSummary: false,
                onPressedBookmark: onPressedBookmark,
              ),
        );
      },
      onTap:
          () => openGameScreen(
            context,
            game: item.game,
            orientation: item.pov,
            loadingLastMove: game.lastMove,
            lastMoveAt: game.lastMoveAt,
            gameListContext: gameListContext,
          ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final boardSize = constraints.maxWidth / 3;
            return Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (game.lastFen != null)
                  BoardThumbnail(
                    size: boardSize,
                    fen: game.lastFen!,
                    orientation: mySide,
                    lastMove: game.lastMove,
                  ),
                Expanded(
                  child: SizedBox(
                    height: boardSize,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    relativeDate(context.l10n, game.lastMoveAt).toUpperCase(),
                                    style: dateStyle,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (me.analysis != null) ...[
                                        Icon(
                                          CupertinoIcons.chart_bar_alt_fill,
                                          size: 15,
                                          color: dateStyle.color,
                                        ),
                                        const SizedBox(width: 2),
                                      ],
                                      Icon(game.perf.icon, size: 15, color: dateStyle.color),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              UserFullNameWidget(
                                user: opponent.user,
                                rating: opponent.rating,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          if (game.lastFen != null)
                            Consumer(
                              builder: (context, ref, child) {
                                final showRatingAsync = ref.watch(showRatingsPrefProvider);
                                return Text.rich(
                                  TextSpan(
                                    text: gameStatusL10n(
                                      context,
                                      variant: game.variant,
                                      status: game.status,
                                      lastPosition: Position.setupPosition(
                                        game.variant.rule,
                                        Setup.parseFen(game.lastFen!),
                                      ),
                                      winner: game.winner,
                                    ),
                                    style: TextStyle(
                                      color:
                                          game.winner == null
                                              ? customColors?.brag
                                              : game.winner == mySide
                                              ? customColors?.good
                                              : customColors?.error,
                                    ),
                                    children: [
                                      if (me.ratingDiff != null)
                                        switch (showRatingAsync) {
                                          AsyncData(value: ShowRatings.yes) => TextSpan(
                                            text:
                                                ' (${me.ratingDiff == 0
                                                    ? '±'
                                                    : me.ratingDiff! > 0
                                                    ? '+'
                                                    : ''}${me.ratingDiff})',
                                          ),

                                          _ => const TextSpan(),
                                        },
                                    ],
                                  ),
                                );
                              },
                            ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [_Opening(opening: game.opening)],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

const _kSubtitleFontSize = 12.0;

class _Opening extends StatelessWidget {
  const _Opening({required this.opening});

  final LightOpening? opening;

  @override
  Widget build(BuildContext context) {
    return opening != null
        ? Text(
          opening!.name,
          maxLines: 3,
          style: TextStyle(
            color: textShade(context, Styles.subtitleOpacity),
            fontSize: _kSubtitleFontSize,
            height: 1.1,
          ),
          overflow: TextOverflow.ellipsis,
        )
        : const SizedBox.shrink();
  }
}
