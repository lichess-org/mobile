import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart';

import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/widgets/player.dart';

import '../../settings/ui/is_sound_muted_notifier.dart';
import './tv_stream.dart';
import './featured_game_notifier.dart';

class TvScreen extends ConsumerWidget {
  const TvScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final tvStream = ref.watch(tvStreamProvider);
    final featuredGame = ref.watch(featuredGameProvider);
    final isSoundMuted = ref.watch(isSoundMutedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lichess TV'),
        actions: [
          IconButton(
              icon: isSoundMuted
                  ? const Icon(Icons.volume_off)
                  : const Icon(Icons.volume_up),
              onPressed: () =>
                  ref.read(isSoundMutedProvider.notifier).toggleSound())
        ],
      ),
      body: Center(
        child: tvStream.when(
          data: (position) {
            final topPlayer = featuredGame != null
                ? featuredGame.orientation == Side.white
                    ? featuredGame.black
                    : featuredGame.white
                : null;
            final bottomPlayer = featuredGame != null
                ? featuredGame.orientation == Side.white
                    ? featuredGame.white
                    : featuredGame.black
                : null;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (topPlayer != null)
                  Player(
                      name: topPlayer.name,
                      title: topPlayer.title,
                      rating: topPlayer.rating,
                      clock: Duration(seconds: topPlayer.seconds ?? 0),
                      active: !position.isGameOver &&
                          position.turn == topPlayer.side),
                Board(
                  interactableSide: InteractableSide.none,
                  settings: const Settings(animationDuration: Duration.zero),
                  size: screenWidth,
                  orientation: featuredGame?.orientation.cg ?? Side.white,
                  fen: position.fen,
                  lastMove: position.lastMove?.cg,
                ),
                if (bottomPlayer != null)
                  Player(
                      name: bottomPlayer.name,
                      title: bottomPlayer.title,
                      rating: bottomPlayer.rating,
                      clock: Duration(seconds: bottomPlayer.seconds ?? 0),
                      active: !position.isGameOver &&
                          position.turn == bottomPlayer.side),
              ],
            );
          },
          loading: () => Board(
            interactableSide: InteractableSide.none,
            size: screenWidth,
            orientation: Side.white,
            fen: kEmptyFen,
          ),
          error: (err, stackTrace) {
            debugPrint(
                'SEVERE: [TvScreen] could not load stream; ${err.toString()}\n$stackTrace');
            return const Text('Could not load TV stream.');
          },
        ),
      ),
    );
  }
}
