import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart';

import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/table_board_layout.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/widgets/bottom_navigation.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';

import 'package:result_extensions/result_extensions.dart';

import 'package:lichess_mobile/src/model/tv/featured_game.dart';

final _featuredGameWithSoundProvider = featuredGameProvider(withSound: true);

final gameIdStateProvider = StateProvider.autoDispose<String?>((ref) {
  return null;
});

class TvScreen extends ConsumerStatefulWidget {
  const TvScreen({super.key});

  @override
  ConsumerState<TvScreen> createState() => _TvScreenState();
}

class _TvScreenState extends ConsumerState<TvScreen> with RouteAware {
  String selectedValue = "Top Rated";

  @override
  Widget build(BuildContext context) {
    return ConsumerPlatformWidget(
      ref: ref,
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  void showChoicesDialog(
    Future<int?> Function(
      BuildContext context,
      List<String> choices,
      int initialIndex,
    )
        showChoiceDialog,
    WidgetRef ref,
    String? gameId,
  ) {
    final repo = ref.watch(userRepositoryProvider);
    final FutureResult<TvChannels> channelResult = repo.getTvChannels();

    channelResult.then((res) {
      if (res.isValue) {
        final TvChannels data = res.asValue!.value;
        String choiceString;
        if (gameId == null) {
          choiceString = "Top Rated";
        } else {
          choiceString = data.channels.entries
              .where((element) => element.key == selectedValue)
              .first
              .key;
        }
        final List<String> choices =
            data.channels.entries.map((e) => e.key).toList();

        showChoiceDialog(
          context,
          choices,
          choices.indexOf(choiceString),
        ).then((val) {
          if (val == null) return;
          selectedValue = choices[val];
          String? tempGameId = data.channels.entries
              .where((element) => element.key == selectedValue)
              .first
              .value
              .gameId;
          if (selectedValue == "Top Rated") {
            tempGameId = null;
          } else {
            selectedValue = choices[val];
          }
          ref.read(gameIdStateProvider.notifier).state = tempGameId;
          ref.read(_featuredGameWithSoundProvider.notifier).gameId = tempGameId;
        });
      }
    }); // End FR_data.then
  }

  Widget _androidBuilder(
    BuildContext context,
    WidgetRef ref,
  ) {
    final gameId = ref.watch(gameIdStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(selectedValue),
              const Icon(
                Icons.arrow_drop_down,
                size: 34.0,
              ),
            ],
          ),
          onTap: () {
            showChoicesDialog(showAndroidChoices, ref, gameId);
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
    final gameId = ref.watch(gameIdStateProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(selectedValue),
              const Icon(
                Icons.arrow_drop_down,
                size: 34.0,
              ),
            ],
          ),
          onTap: () {
            showChoicesDialog(showIosChoices, ref, gameId);
          },
        ),
        trailing: ToggleSoundButton(),
      ),
      child: const _Body(),
    );
  }

  Future<int?> showIosChoices(
    BuildContext context,
    List<String> choices,
    int initialIndex,
  ) {
    int selectedIndex = initialIndex;

    return showCupertinoModalPopup<int>(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ColoredBox(
                color: Theme.of(context).canvasColor,
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(null);
                      },
                      child: const Text('Cancel'),
                    ),
                    const Spacer(),
                    const Text(
                      "Variant",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(selectedIndex);
                      },
                      child: const Text('Ok'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  backgroundColor: Theme.of(context).canvasColor,
                  useMagnifier: true,
                  magnification: 1.1,
                  itemExtent: 40,
                  scrollController:
                      FixedExtentScrollController(initialItem: initialIndex),
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
                  onSelectedItemChanged: (int selectedItem) {
                    selectedIndex = selectedItem;
                    selectedValue = choices[selectedItem];
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null && route is PageRoute) {
      watchRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    watchRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPushNext() {
    ref.read(_featuredGameWithSoundProvider.notifier).disconnectStream();
    super.didPushNext();
  }

  @override
  void didPopNext() {
    ref.read(_featuredGameWithSoundProvider.notifier).connectStream();
    super.didPopNext();
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentBottomTabProvider);
    final featuredGame = currentTab == BottomTab.watch
        ? ref.watch(_featuredGameWithSoundProvider)
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
Future<int?> showAndroidChoices(
  BuildContext context,
  List<String> choices,
  int initialIndex,
) {
  int? choiceIndex = initialIndex;
  return showDialog<int?>(
    context: context,
    builder: (context) {
      int? selectedRadio = initialIndex;
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
                    choiceIndex = value;
                  },
                );
              }),
            );
          },
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(choiceIndex),
          ),
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () => Navigator.of(context).pop(null),
          ),
        ],
      );
    },
  );
}
