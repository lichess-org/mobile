import 'package:dartchess/dartchess.dart' as dartchess;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

// height of 1.0 is important because we need to determine the height of the text
// to calculate the height of the header and footer of the board
const _kPlayerWidgetTextStyle = TextStyle(fontSize: 13, height: 1.0);

const _kPlayerWidgetPadding = EdgeInsets.symmetric(vertical: 5.0);

class BroadcastScreen extends StatelessWidget {
  final String broadCastTitle;
  final BroadcastRoundId roundId;

  const BroadcastScreen({
    super.key,
    required this.broadCastTitle,
    required this.roundId,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(broadCastTitle),
      ),
      body: _Body(roundId),
    );
  }

  Widget _iosBuilder(
    BuildContext context,
  ) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(broadCastTitle),
      ),
      child: _Body(roundId),
    );
  }
}

class _Body extends ConsumerWidget {
  final BroadcastRoundId roundId;

  const _Body(this.roundId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(broadcastRoundProvider(roundId));

    return games.when(
      data: (games) => (games.isEmpty)
          ? const Text('No games to show for now')
          : BroadcastPreview(games: games),
      loading: () => const Shimmer(
        child: ShimmerLoading(
          isLoading: true,
          child: BroadcastPreview(),
        ),
      ),
      error: (error, stackTrace) => Center(
        child: Text(error.toString()),
      ),
    );
  }
}

class BroadcastPreview extends StatelessWidget {
  final IList<BroadcastGameSnapshot>? games;

  const BroadcastPreview({super.key, this.games});

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

    return SafeArea(
      child: Padding(
        padding: Styles.horizontalBodyPadding,
        child: GridView.builder(
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
                header: _PlayerWidget.loading(width: boardWidth),
                footer: _PlayerWidget.loading(width: boardWidth),
              );
            }

            final game = games![index];
            final playingSide = dartchess.Setup.parseFen(game.fen).turn;

            return BoardThumbnail(
              orientation: dartchess.Side.white,
              fen: game.fen,
              lastMove: game.lastMove?.cg,
              size: boardWidth,
              header: _PlayerWidget(
                width: boardWidth,
                player: game.players[1],
                gameStatus: game.status,
                side: dartchess.Side.black,
                playingSide: playingSide,
              ),
              footer: _PlayerWidget(
                width: boardWidth,
                player: game.players[0],
                gameStatus: game.status,
                side: dartchess.Side.white,
                playingSide: playingSide,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PlayerWidget extends StatelessWidget {
  const _PlayerWidget({
    required this.width,
    required this.player,
    required this.gameStatus,
    required this.side,
    required this.playingSide,
  }) : _displayShimmerPlaceholder = false;

  const _PlayerWidget.loading({
    required this.width,
  })  : player = const BroadcastPlayer(
          name: '',
          title: null,
          rating: null,
          clock: null,
          federation: null,
        ),
        gameStatus = '*',
        side = dartchess.Side.white,
        playingSide = dartchess.Side.white,
        _displayShimmerPlaceholder = true;

  final BroadcastPlayer player;
  final String gameStatus;
  final dartchess.Side side;
  final dartchess.Side playingSide;
  final double width;

  final bool _displayShimmerPlaceholder;

  @override
  Widget build(BuildContext context) {
    if (_displayShimmerPlaceholder) {
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
                      SvgPicture.network(
                        lichessFideFedSrc(player.federation!),
                        height: 12,
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
              if (gameStatus != '*')
                Text(
                  (gameStatus == '½-½')
                      ? '½'
                      : (gameStatus == '1-0')
                          ? side == dartchess.Side.white
                              ? '1'
                              : '0'
                          : side == dartchess.Side.black
                              ? '1'
                              : '0',
                  style:
                      const TextStyle().copyWith(fontWeight: FontWeight.bold),
                )
              else if (player.clock != null)
                Text(
                  player.clock!.toHoursMinutesSeconds(),
                  style: side == playingSide
                      ? const TextStyle().copyWith(color: Colors.orange[900])
                      : null,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
