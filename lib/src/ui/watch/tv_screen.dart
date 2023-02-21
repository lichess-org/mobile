import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart';

import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/game_board_layout.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/widgets/bottom_navigation.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';

import 'package:lichess_mobile/src/model/settings/providers.dart';
import 'package:lichess_mobile/src/model/tv/featured_position.dart';
import 'package:lichess_mobile/src/model/tv/tv_stream.dart';
import 'package:lichess_mobile/src/model/tv/featured_game_notifier.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel_provider.dart';

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
    final tvChannel = ref.watch(tvChannelNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () => showChoicesPicker<TvChannel>(
            context,
            selectedItem: TvChannel.top,
            labelBuilder: (TvChannel channel) => Text(channel.string),
            onSelectedItemChanged: (channel) =>
                ref.read(tvChannelNotifierProvider.notifier).channel = channel,
            choices: TvChannel.values,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(tvChannel.string),
              const Icon(Icons.arrow_drop_down)
            ],
          ),
        ),
        actions: [
          SoundButton(),
        ],
      ),
      body: const _Body(),
    );
  }

  Widget _iosBuilder(
    BuildContext context,
    WidgetRef ref,
  ) {
    final tvChannel = ref.watch(tvChannelNotifierProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: InkWell(
          onTap: () => showChoicesPicker(
            context,
            choices: TvChannel.values,
            selectedItem: TvChannel.top,
            labelBuilder: (e) => Text(e.string),
            onSelectedItemChanged: (channel) =>
                ref.read(tvChannelNotifierProvider.notifier).channel = channel,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(tvChannel.string),
              const Icon(Icons.arrow_drop_down)
            ],
          ),
        ),
        trailing: SoundButton(),
      ),
      child: const _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pieceSet = ref.watch(pieceSetPrefProvider);
    final boardTheme = ref.watch(boardThemePrefProvider);
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
                    player: topPlayer.asPlayer,
                    clock: Duration(seconds: topPlayer.seconds ?? 0),
                    active:
                        !position.isGameOver && position.turn == topPlayer.side,
                  )
                : kEmptyWidget;
            final bottomPlayerWidget = bottomPlayer != null
                ? BoardPlayer(
                    player: bottomPlayer.asPlayer,
                    clock: Duration(seconds: bottomPlayer.seconds ?? 0),
                    active: !position.isGameOver &&
                        position.turn == bottomPlayer.side,
                  )
                : kEmptyWidget;
            return GameBoardLayout(
              boardData: boardData,
              boardSettings: BoardSettings(
                animationDuration: Duration.zero,
                pieceAssets: pieceSet.assets,
                colorScheme: boardTheme.colors,
              ),
              topPlayer: topPlayerWidget,
              bottomPlayer: bottomPlayerWidget,
            );
          },
          loading: () => GameBoardLayout(
            topPlayer: kEmptyWidget,
            bottomPlayer: kEmptyWidget,
            boardSettings: BoardSettings(
              colorScheme: boardTheme.colors,
            ),
            boardData: const BoardData(
              interactableSide: InteractableSide.none,
              orientation: Side.white,
              fen: kEmptyFen,
            ),
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
