import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart';

import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/widgets/game_board_layout.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/widgets/bottom_navigation.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

import 'package:lichess_mobile/src/model/settings/is_sound_muted_provider.dart';
import 'package:lichess_mobile/src/model/tv/featured_position.dart';
import 'package:lichess_mobile/src/model/tv/tv_stream.dart';
import 'package:lichess_mobile/src/model/tv/featured_game_notifier.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel_provider.dart';

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
    final isSoundMuted = ref.watch(isSoundMutedProvider);
    final tvChannel = ref.watch(tvChannelProvider);
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () => showChoices(context, ref, TvChannel.getListString()),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(tvChannel.string),
              const Icon(Icons.arrow_drop_down)
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: isSoundMuted
                ? const Icon(Icons.volume_off)
                : const Icon(Icons.volume_up),
            onPressed: () =>
                ref.read(isSoundMutedProvider.notifier).toggleSound(),
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
    final isSoundMuted = ref.watch(isSoundMutedProvider);
    final tvChannel = ref.watch(tvChannelProvider);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [Text(tvChannel.string), const Icon(Icons.arrow_drop_down)],
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: isSoundMuted
              ? const Icon(CupertinoIcons.volume_off)
              : const Icon(CupertinoIcons.volume_up),
          onPressed: () =>
              ref.read(isSoundMutedProvider.notifier).toggleSound(),
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

void showChoices(BuildContext context, WidgetRef ref, List<String> choices) {
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      showDialog<void>(
        context: context,
        builder: (context) {
          int? selectedRadio;
          return AlertDialog(
            contentPadding: const EdgeInsets.only(top: 12),
            content: StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List<Widget>.generate(choices.length, (index) {
                      return RadioListTile<int?>(
                        title: Text(choices[index]),
                        value: index,
                        groupValue: selectedRadio,
                        onChanged: (value) {
                          setState(() => selectedRadio = value);
                          if (value != null) {
                            ref
                                .read(tvChannelProvider.notifier)
                                .toggleChannel(value);
                          }
                          Navigator.of(context).pop();
                        },
                      );
                    }),
                  ),
                );
              },
            ),
          );
        },
      );
      return;
    case TargetPlatform.iOS:
      showCupertinoModalPopup<void>(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 250,
            child: CupertinoPicker(
              backgroundColor: Theme.of(context).canvasColor,
              useMagnifier: true,
              magnification: 1.1,
              itemExtent: 40,
              scrollController: FixedExtentScrollController(initialItem: 1),
              children: List<Widget>.generate(choices.length, (index) {
                return Center(
                  child: Text(
                    choices[index],
                    style: const TextStyle(
                      fontSize: 21,
                    ),
                  ),
                );
              }),
              onSelectedItemChanged: (value) {},
            ),
          );
        },
      );
      return;
    default:
      assert(false, 'Unexpected platform $defaultTargetPlatform');
  }
}
