import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart';

import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/widgets/game_board_layout.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/widgets/bottom_navigation.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

import 'package:lichess_mobile/src/model/settings/providers.dart';
import 'package:lichess_mobile/src/model/tv/featured_position.dart';
import 'package:lichess_mobile/src/model/tv/tv_stream.dart';
import 'package:lichess_mobile/src/model/tv/featured_game_notifier.dart';

const _boardSettings = BoardSettings(animationDuration: Duration.zero);

class TvScreen extends ConsumerWidget {
  const TvScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConsumerPlatformWidget(
      ref: ref,
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(
    BuildContext context,
    WidgetRef ref,
  ) {
    final isSoundMuted = ref.watch(muteSoundSettingProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lichess TV'),
        actions: [
          IconButton(
            icon: isSoundMuted
                ? const Icon(Icons.volume_off)
                : const Icon(Icons.volume_up),
            onPressed: () =>
                ref.read(muteSoundSettingProvider.notifier).toggle(),
          )
        ],
      ),
      body: const _Body(),
    );
  }

  Widget _iosBuilder(
    BuildContext context,
    WidgetRef ref,
  ) {
    final isSoundMuted = ref.watch(muteSoundSettingProvider);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: isSoundMuted
              ? const Icon(CupertinoIcons.volume_off)
              : const Icon(CupertinoIcons.volume_up),
          onPressed: () => ref.read(muteSoundSettingProvider.notifier).toggle(),
        ),
      ),
      child: const _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentBottomTabProvider);
    // ensure the stream is closed when offstage
    final tvStream = currentTab == BottomTab.watch
        ? ref.watch(tvStreamProvider)
        : const AsyncLoading<FeaturedPosition>();
    final featuredGame = ref.watch(featuredGameProvider);

    return SafeArea(
      child: Center(
        child: tvStream.when(
          data: (position) {
            final boardData = BoardData(
              interactableSide: InteractableSide.none,
              orientation: featuredGame?.orientation.cg ?? Side.white,
              fen: position.fen,
              lastMove: position.lastMove?.cg,
            );
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
            final topPlayerWidget = topPlayer != null
                ? BoardPlayer(
                    name: topPlayer.name,
                    title: topPlayer.title,
                    rating: topPlayer.rating,
                    clock: Duration(seconds: topPlayer.seconds ?? 0),
                    active:
                        !position.isGameOver && position.turn == topPlayer.side,
                  )
                : kEmptyWidget;
            final bottomPlayerWidget = bottomPlayer != null
                ? BoardPlayer(
                    name: bottomPlayer.name,
                    title: bottomPlayer.title,
                    rating: bottomPlayer.rating,
                    clock: Duration(seconds: bottomPlayer.seconds ?? 0),
                    active: !position.isGameOver &&
                        position.turn == bottomPlayer.side,
                  )
                : kEmptyWidget;
            return GameBoardLayout(
              boardData: boardData,
              boardSettings: _boardSettings,
              topPlayer: topPlayerWidget,
              bottomPlayer: bottomPlayerWidget,
            );
          },
          loading: () => const GameBoardLayout(
            topPlayer: kEmptyWidget,
            bottomPlayer: kEmptyWidget,
            boardData: BoardData(
              interactableSide: InteractableSide.none,
              orientation: Side.white,
              fen: kEmptyFen,
            ),
            boardSettings: _boardSettings,
          ),
          error: (err, stackTrace) {
            debugPrint(
              'SEVERE: [TvScreen] could not load stream; $err\n$stackTrace',
            );
            return const GameBoardLayout(
              topPlayer: kEmptyWidget,
              bottomPlayer: kEmptyWidget,
              boardData: BoardData(
                fen: kEmptyFen,
                interactableSide: InteractableSide.none,
                orientation: Side.white,
              ),
              errorMessage: 'Could not load TV stream.',
            );
          },
        ),
      ),
    );
  }
}
