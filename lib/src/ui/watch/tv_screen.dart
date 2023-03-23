import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart';

import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/table_board_layout.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/widgets/bottom_navigation.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

import 'package:lichess_mobile/src/model/tv/featured_game.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated'),
        actions: [
          ToggleSoundButton(),
        ],
      ),
      body: const _Body(),
    );
  }

  Widget _iosBuilder(
    BuildContext context,
    WidgetRef ref,
  ) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Top Rated'),
        trailing: ToggleSoundButton(),
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
    final featuredGame = currentTab == BottomTab.watch
        ? ref.watch(featuredGameProvider(withSound: true))
        : const AsyncLoading<FeaturedGameState>();

    return SafeArea(
      child: Center(
        child: featuredGame.when(
          data: (game) {
            final boardData = BoardData(
              interactableSide: InteractableSide.none,
              orientation: game.orientation.cg,
              fen: game.position.position.fen,
              lastMove: game.position.lastMove?.cg,
            );
            final topPlayer =
                game.orientation == Side.white ? game.black : game.white;

            final bottomPlayer =
                game.orientation == Side.white ? game.white : game.black;
            final topPlayerWidget = BoardPlayer(
              player: topPlayer.asPlayer,
              clock: Duration(seconds: topPlayer.seconds ?? 0),
              active: !game.position.position.isGameOver &&
                  game.position.position.turn == topPlayer.side,
            );
            final bottomPlayerWidget = BoardPlayer(
              player: bottomPlayer.asPlayer,
              clock: Duration(seconds: bottomPlayer.seconds ?? 0),
              active: !game.position.position.isGameOver &&
                  game.position.position.turn == bottomPlayer.side,
            );
            return TableBoardLayout(
              boardData: boardData,
              boardSettingsOverrides: const BoardSettingsOverrides(
                animationDuration: Duration.zero,
              ),
              topTable: topPlayerWidget,
              bottomTable: bottomPlayerWidget,
            );
          },
          loading: () => const TableBoardLayout(
            topTable: kEmptyWidget,
            bottomTable: kEmptyWidget,
            boardData: BoardData(
              interactableSide: InteractableSide.none,
              orientation: Side.white,
              fen: kEmptyFen,
            ),
          ),
          error: (err, stackTrace) {
            debugPrint(
              'SEVERE: [TvScreen] could not load stream; $err\n$stackTrace',
            );
            return const TableBoardLayout(
              topTable: kEmptyWidget,
              bottomTable: kEmptyWidget,
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
