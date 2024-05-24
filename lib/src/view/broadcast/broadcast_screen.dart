import 'package:chessground/chessground.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:lichess_mobile/src/widgets/layout_board.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

class BroadcastScreen extends ConsumerWidget {
  final String roundId;

  const BroadcastScreen({super.key, required this.roundId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        title: const Text('Broadcast'),
      ),
      body: _Body(roundId),
    );
  }

  Widget _iosBuilder(
    BuildContext context,
  ) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Broadcast'),
      ),
      child: _Body(roundId),
    );
  }
}

class _Body extends ConsumerWidget {
  final String roundId;

  const _Body(this.roundId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(roundProvider(roundId));
    return games.when(
      data: (games) => BroadcastPreview(games: games),
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
    const numberLoadingBoardThumbnails = 16;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBoard(
          builder: (crossAxisCount, boardWidth) => (games == null)
              ? List.generate(
                  numberLoadingBoardThumbnails,
                  (index) => BoardThumbnail.loading(size: boardWidth),
                )
              : games!
                  .map(
                    (game) => BoardThumbnail(
                      orientation: Side.white,
                      fen: game.fen,
                      lastMove: game.lastMove.cg,
                      size: boardWidth,
                      header: UserFullNameWidget.player(
                        user: game.players[0].user,
                        rating: game.players[0].rating,
                        aiLevel: null,
                      ),
                      footer: UserFullNameWidget.player(
                        user: game.players[1].user,
                        rating: game.players[1].rating,
                        aiLevel: null,
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
