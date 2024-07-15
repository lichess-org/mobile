import 'package:chessground/chessground.dart';
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
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:lichess_mobile/src/widgets/grid_board.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

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
    const numberLoadingBoardThumbnails = 6;
    final fakeHeaderAndFooter = Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        width: double.infinity,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: GridBoard(
          rowGap: 5,
          builder: (crossAxisCount, boardWidth) => (games == null)
              ? List.generate(
                  numberLoadingBoardThumbnails,
                  (index) => BoardThumbnail.loading(
                    size: boardWidth,
                    header: fakeHeaderAndFooter,
                    footer: fakeHeaderAndFooter,
                  ),
                )
              : games!.map(
                  (game) {
                    final playingSide =
                        dartchess.Setup.parseFen(game.fen).turn.cg;

                    return BoardThumbnail(
                      orientation: Side.white,
                      fen: game.fen,
                      lastMove: game.lastMove?.cg,
                      size: boardWidth,
                      header: PlayerWidget(
                        player: game.players[1],
                        gameStatus: game.status,
                        side: Side.black,
                        playingSide: playingSide,
                      ),
                      footer: PlayerWidget(
                        player: game.players[0],
                        gameStatus: game.status,
                        side: Side.white,
                        playingSide: playingSide,
                      ),
                    );
                  },
                ).toList(),
        ),
      ),
    );
  }
}

class PlayerWidget extends StatelessWidget {
  final BroadcastPlayer player;
  final String gameStatus;
  final Side side;
  final Side playingSide;

  const PlayerWidget({
    super.key,
    required this.player,
    required this.gameStatus,
    required this.side,
    required this.playingSide,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
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
                      ? side == Side.white
                          ? '1'
                          : '0'
                      : side == Side.black
                          ? '1'
                          : '0',
              style: const TextStyle().copyWith(fontWeight: FontWeight.bold),
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
    );
  }
}
