import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_round_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_screen.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:lichess_mobile/src/widgets/clock.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

// height of 1.0 is important because we need to determine the height of the text
// to calculate the height of the header and footer of the board
const _kPlayerWidgetTextStyle = TextStyle(fontSize: 13, height: 1.0);

const _kPlayerWidgetPadding = EdgeInsets.symmetric(vertical: 5.0);

/// A tab that displays the live games of a broadcast round.
class BroadcastBoardsTab extends ConsumerWidget {
  final BroadcastRoundId roundId;

  const BroadcastBoardsTab(this.roundId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final round = ref.watch(broadcastRoundControllerProvider(roundId));

    return SafeArea(
      bottom: false,
      child: switch (round) {
        AsyncData(:final value) => (value.games.isEmpty)
            ? const Padding(
                padding: Styles.bodyPadding,
                child: Text('No boards to show for now'),
              )
            : BroadcastPreview(
                games: value.games.values.toIList(),
                roundId: roundId,
                title: value.round.name,
              ),
        AsyncError(:final error) => Center(
            child: Text(error.toString()),
          ),
        _ => const Shimmer(
            child: ShimmerLoading(
              isLoading: true,
              child: BroadcastPreview(
                roundId: BroadcastRoundId(''),
                title: '',
              ),
            ),
          ),
      },
    );
  }
}

class BroadcastPreview extends StatelessWidget {
  final BroadcastRoundId roundId;
  final IList<BroadcastGame>? games;
  final String title;

  const BroadcastPreview({
    required this.roundId,
    this.games,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    const numberLoadingBoards = 12;
    const boardSpacing = 10.0;
    // height of the text based on the font size
    // since the TextStyle is defined with an height at 1.0, this is the real height
    // see: https://api.flutter.dev/flutter/painting/TextStyle/height.html
    final textHeight = _kPlayerWidgetTextStyle.fontSize!;
    final headerAndFooterHeight = textHeight + _kPlayerWidgetPadding.vertical;
    final numberOfBoardsByRow = isTabletOrLarger(context) ? 4 : 2;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final boardWidth = (screenWidth -
            Styles.horizontalBodyPadding.horizontal -
            (numberOfBoardsByRow - 1) * boardSpacing) /
        numberOfBoardsByRow;

    return GridView.builder(
      padding: Styles.bodyPadding,
      itemCount: games == null ? numberLoadingBoards : games!.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: numberOfBoardsByRow,
        crossAxisSpacing: boardSpacing,
        mainAxisSpacing: boardSpacing,
        mainAxisExtent: boardWidth + 2 * headerAndFooterHeight,
      ),
      itemBuilder: (context, index) {
        if (games == null) {
          return BoardThumbnail.loading(
            size: boardWidth,
            header: _PlayerWidgetLoading(width: boardWidth),
            footer: _PlayerWidgetLoading(width: boardWidth),
          );
        }

        final game = games![index];
        final playingSide = Setup.parseFen(game.fen).turn;

        return BoardThumbnail(
          animationDuration: const Duration(milliseconds: 150),
          onTap: () {
            pushPlatformRoute(
              context,
              builder: (context) => BroadcastGameScreen(
                roundId: roundId,
                gameId: game.id,
                title: title,
              ),
            );
          },
          orientation: Side.white,
          fen: game.fen,
          lastMove: game.lastMove,
          size: boardWidth,
          header: _PlayerWidget(
            width: boardWidth,
            game: game,
            side: Side.black,
            playingSide: playingSide,
          ),
          footer: _PlayerWidget(
            width: boardWidth,
            game: game,
            side: Side.white,
            playingSide: playingSide,
          ),
        );
      },
    );
  }
}

class _PlayerWidgetLoading extends StatelessWidget {
  const _PlayerWidgetLoading({
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: _kPlayerWidgetPadding,
        child: Container(
          height: _kPlayerWidgetTextStyle.fontSize,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}

class _PlayerWidget extends StatelessWidget {
  const _PlayerWidget({
    required this.width,
    required this.game,
    required this.side,
    required this.playingSide,
  });

  final BroadcastGame game;
  final Side side;
  final Side playingSide;
  final double width;

  @override
  Widget build(BuildContext context) {
    final player = game.players[side]!;
    final gameStatus = game.status;

    return SizedBox(
      width: width,
      child: Padding(
        padding: _kPlayerWidgetPadding,
        child: DefaultTextStyle.merge(
          style: _kPlayerWidgetTextStyle,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (player.federation != null) ...[
                      Consumer(
                        builder: (context, widgetRef, _) {
                          return SvgPicture.network(
                            lichessFideFedSrc(player.federation!),
                            height: 12,
                            httpClient: widgetRef.read(defaultClientProvider),
                          );
                        },
                      ),
                    ],
                    const SizedBox(width: 5),
                    if (player.title != null) ...[
                      Text(
                        player.title!,
                        style: const TextStyle().copyWith(
                          color: context.lichessColors.brag,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                    Flexible(
                      child: Text(
                        player.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              if (game.isOver)
                Text(
                  (gameStatus == BroadcastResult.draw)
                      ? '½'
                      : (gameStatus == BroadcastResult.whiteWins)
                          ? side == Side.white
                              ? '1'
                              : '0'
                          : side == Side.black
                              ? '1'
                              : '0',
                  style:
                      const TextStyle().copyWith(fontWeight: FontWeight.bold),
                )
              else if (player.clock != null)
                CountdownClockBuilder(
                  timeLeft: player.clock!,
                  active: side == playingSide,
                  builder: (context, timeLeft) => Text(
                    timeLeft.toHoursMinutesSeconds(),
                    style: TextStyle(
                      color: (side == playingSide) ? Colors.orange[900] : null,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  tickInterval: const Duration(seconds: 1),
                  clockUpdatedAt: game.updatedClockAt,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
