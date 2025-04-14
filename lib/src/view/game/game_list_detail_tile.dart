import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:lichess_mobile/src/model/game/game_filter.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/game/game_common_widgets.dart';
import 'package:lichess_mobile/src/view/game/game_list_tile.dart';
import 'package:lichess_mobile/src/view/game/status_l10n.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
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
    final isTablet = isTabletOrLarger(context);

    final titleFontSize = isTablet ? 24.0 : 16.0;
    final subtitleFontSize = isTablet ? 18.0 : 12.0;

    final customColors = Theme.of(context).extension<CustomColors>();

    final moveList = game.moves?.split(' ');

    final dateStyle = TextStyle(
      color: textShade(context, 0.5),
      fontSize: subtitleFontSize,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      height: 1,
    );

    final scaledTitleFontSize = MediaQuery.of(context).textScaler.scale(titleFontSize);

    return InkWell(
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
                      padding: const EdgeInsets.only(left: 8.0),
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
                                          size: subtitleFontSize + 3,
                                          color: textShade(context, 0.7),
                                        ),
                                        const SizedBox(width: 2),
                                      ],
                                      Icon(
                                        game.perf.icon,
                                        size: subtitleFontSize + 3,
                                        color: textShade(context, 0.7),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              UserFullNameWidget(
                                user: opponent.user,
                                rating: opponent.rating,
                                style: TextStyle(
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.w600,
                                ),
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
                                      fontSize: subtitleFontSize,
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
                          if (isTablet || scaledTitleFontSize <= 26)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (game.opening != null || moveList?.isNotEmpty == true)
                                  Text.rich(
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: textShade(context, Styles.subtitleOpacity),
                                      fontSize: subtitleFontSize,
                                    ),
                                    TextSpan(
                                      text: game.opening?.name,
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                      children: [
                                        if (moveList != null && moveList.length > 1) ...[
                                          const TextSpan(text: '\n'),
                                          ...moveList
                                              .take(isTablet ? 6 : 4)
                                              .toList()
                                              .asMap()
                                              .entries
                                              .slices(2)
                                              .mapIndexed((index, moves) {
                                                return TextSpan(
                                                  text:
                                                      '${index + 1}. ${moves.map((e) => '${e.value} ').join()}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                );
                                              }),
                                          TextSpan(
                                            text: '\u2026 ${(moveList.length / 2).ceil()} moves',
                                            style: const TextStyle(fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                              ],
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
