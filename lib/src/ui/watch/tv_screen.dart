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

import 'package:lichess_mobile/src/model/tv/featured_position.dart';
import 'package:lichess_mobile/src/model/tv/tv_stream.dart';
import 'package:lichess_mobile/src/model/tv/featured_game_notifier.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';

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
        title: InkWell(
          child: const Text('Top Rated 2'),
          onTap: () {
            showAndroidChoices(
              context,
              ['android A', 'android B', 'android C'],
            );
          },
        ),
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
    final tvChannel = ref.watch(tvChannelsProvider);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: tvChannel.when(
          data: (data) {
            return InkWell(
              child: const Text('Top Rated'),
              onTap: () {
                showIosChoices(
                  context,
                  data.channels.entries.map((e) => e.key).toList(),
                );
              },
            );
          },
          loading: () => const Text('Top Rated'),
          error: (err, stackTrace) {
            debugPrint(
              'SEVERE: [TvScreen] could not load stream; $err\n$stackTrace',
            );
          },
        ),
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
    // ensure the stream is closed when offstage
    final tvStream = currentTab == BottomTab.watch
        ? ref.watch(tvStreamProvider(true))
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

// ===========================================================================
// Non-shared code below because different interfaces are shown to prompt
// for a multiple-choice answer.
//
// This is a design choice and you may want to do something different in your
// app.
// ===========================================================================
/// This uses a platform-appropriate mechanism to show users multiple choices.
///
/// On Android, it uses a dialog with radio buttons. On iOS, it uses a picker.
void showAndroidChoices(BuildContext context, List<String> choices) {
  showDialog<void>(
    context: context,
    builder: (context) {
      int? selectedRadio = 1;
      return AlertDialog(
        contentPadding: const EdgeInsets.only(top: 12),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: List<Widget>.generate(choices.length, (index) {
                return RadioListTile<int?>(
                  title: Text(choices[index]),
                  value: index,
                  groupValue: selectedRadio,
                  onChanged: (value) {
                    setState(() => selectedRadio = value);
                  },
                );
              }),
            );
          },
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
  return;
}

void showIosChoices(BuildContext context, List<String> choices) {
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
}
