import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/account/rating_pref_aware.dart';
import 'package:lichess_mobile/src/view/game/game_common_widgets.dart';
import 'package:lichess_mobile/src/view/game/game_list_tile.dart';
import 'package:lichess_mobile/src/view/game/status_l10n.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

/// A list tile that shows more detailed game info than [GameListTile].
class GameListDetailTile extends StatelessWidget {
  const GameListDetailTile({required this.item});

  final LightArchivedGameWithPov item;

  Side get mySide => item.pov;

  @override
  Widget build(BuildContext context) {
    final (game: game, pov: youAre) = item;
    final me = youAre == Side.white ? game.white : game.black;

    final customColors = Theme.of(context).extension<CustomColors>();

    final dateStyle = TextStyle(color: textShade(context, Styles.subtitleOpacity), fontSize: 12);

    return AdaptiveInkWell(
      onLongPress: () {
        showAdaptiveBottomSheet<void>(
          context: context,
          useRootNavigator: true,
          isDismissible: true,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (context) => GameContextMenu(game: game, mySide: mySide, showGameSummary: false),
        );
      },
      onTap: () => openGameScreen(item.game, item.pov, context),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ).add(const EdgeInsets.only(bottom: 8.0)),
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
                          Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    game.perf.icon,
                                    color: dateStyle.color,
                                    size: dateStyle.fontSize,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ${relativeDate(context.l10n, game.lastMoveAt)}',
                                  style: dateStyle,
                                ),
                              ],
                            ),
                          ),
                          _UsersAndRatings(white: game.white, black: game.black),
                          if (game.lastFen != null)
                            Text(
                              gameStatusL10n(
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
                                fontSize: 13,
                                color:
                                    game.winner == null
                                        ? customColors?.brag
                                        : game.winner == mySide
                                        ? customColors?.good
                                        : customColors?.error,
                              ),
                            ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _Opening(opening: game.opening),
                              _ComputerAnalysisResult(analysis: me.analysis),
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

class _RatingAndDiff extends StatelessWidget {
  const _RatingAndDiff({required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 13);

    return RatingPrefAware(
      child: Text.rich(
        TextSpan(
          children: [
            if (player.rating != null) TextSpan(text: player.rating.toString(), style: style),
            if (player.ratingDiff != null)
              TextSpan(
                text:
                    ' ${player.ratingDiff == 0
                        ? '±'
                        : player.ratingDiff! > 0
                        ? '+'
                        : ''}${player.ratingDiff}',
                style: style.copyWith(
                  color:
                      player.ratingDiff! > 0
                          ? LichessColors.green
                          : player.ratingDiff! < 0
                          ? LichessColors.error
                          : style.color,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _User extends StatelessWidget {
  const _User({required this.user});

  final LightUser? user;

  @override
  Widget build(BuildContext context) {
    final longName = user?.name != null && user!.name.length > 10;
    final style = TextStyle(fontSize: longName ? 8 : 15, fontWeight: FontWeight.w600);

    return UserFullNameWidget(user: user, showPatron: false, showFlair: false, style: style);
  }
}

class _UsersAndRatings extends StatelessWidget {
  const _UsersAndRatings({required this.white, required this.black});

  final Player white;

  final Player black;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [_User(user: white.user), _RatingAndDiff(player: white)],
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(LichessIcons.crossed_swords, size: 18),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_User(user: black.user), _RatingAndDiff(player: black)],
        ),
      ],
    );
  }
}

class _Opening extends StatelessWidget {
  const _Opening({required this.opening});

  final LightOpening? opening;

  @override
  Widget build(BuildContext context) {
    return opening != null
        ? Text(
          opening!.name,
          maxLines: 2,
          style: TextStyle(color: textShade(context, Styles.subtitleOpacity), fontSize: 10),
          overflow: TextOverflow.ellipsis,
        )
        : const SizedBox.shrink();
  }
}

class _ComputerAnalysisResult extends StatelessWidget {
  const _ComputerAnalysisResult({required this.analysis});

  final PlayerAnalysis? analysis;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(color: textShade(context, 0.6), fontSize: 9);

    return analysis != null
        ? Row(
          children: [
            Icon(CupertinoIcons.chart_bar_alt_fill, size: 8, color: textShade(context, 0.5)),
            const SizedBox(width: 5),
            Text(
              analysis?.accuracy != null
                  ? 'Accuracy: ${analysis?.accuracy}%'
                  : context.l10n.computerAnalysisAvailable,
              style: textStyle,
            ),
          ],
        )
        : const SizedBox.shrink();
  }
}
