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
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';

import 'package:result_extensions/result_extensions.dart';
import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/utils/json.dart';
//import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';

class TvScreen extends ConsumerStatefulWidget {
  const TvScreen({super.key});

  @override
  _TvScreenState createState() => _TvScreenState();
}

class _TvScreenState extends ConsumerState<TvScreen> {
  String selectedValue = "Top Rated";

  @override
  Widget build(BuildContext context) {
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
                color: Colors.white,
                size: 34.0,
              ),
            ],
          ),
          onTap: () {
            final repo = ref.watch(userRepositoryProvider);
            final FutureResult<TvChannels> FR_data = repo.getTvChannels();

            FR_data.then((res) {
              if (res.isValue) {
                TvChannels data = res.asValue!.value;
                String titleText;
                String choiceString;
                if (gameId == null) {
                  titleText = "Top Rated";
                  choiceString = "Top Rated";
                } else {
                  titleText = data.channels.entries
                      .where((element) => element.value.gameId == gameId)
                      .first
                      .key;
                  choiceString = titleText;
                  titleText =
                      "$titleText | ${data.channels.entries.where((element) => element.value.gameId == gameId).first.value.gameId}";
                }
                final List<String> choices =
                    data.channels.entries.map((e) => e.key).toList();

                showAndroidChoices(
                  context,
                  choices,
                  choices.indexOf(choiceString),
                ).then((val) {
                  if (val == null) return;
                  print("****** Android then val: $val");
                  print("****** Android entries: ${data.channels.entries}");
                  selectedValue = choices[val!];
                  print("***** selectedvalue: $selectedValue");
                  String? tempGameId = data.channels.entries
                      .where((element) => element.key == selectedValue)
                      .first
                      .value
                      .gameId;
                  print("****** Android 1 tempGameId: $tempGameId");
                  if (selectedValue == "Top Rated") {
                    tempGameId = null;
                  } else {
                    selectedValue = choices[val!];
                  }

                  print("****** Android 2 tempGameId: $tempGameId");

                  ref.read(gameIdStateProvider.notifier).state = tempGameId;
                });
              }
            }); // End FR_data.then

            /*showAndroidChoices(
                  context,
                  choices,
                  choices.indexOf(choiceString),
                ).then((val) {
                  print("****** android then val: $val");
                  if (val != null) {
                    selectedValue = data.channels.entries.elementAt(val).key;
                    String? tempGameId =
                        data.channels.entries.elementAt(val).value.gameId;
                    if (selectedValue == "Top Rated") tempGameId = null;

                    print("****** android tempGameId: $tempGameId");

                    ref.read(gameIdStateProvider.notifier).state = tempGameId;
                  }
                });*/
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
              Text("Top Rated"),
              const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
                size: 34.0,
              ),
            ],
          ),
          onTap: () {
            final repo = ref.watch(userRepositoryProvider);
            final FutureResult<TvChannels> FR_data = repo.getTvChannels();

            FR_data.then((res) {
              if (res.isValue) {
                TvChannels data = res.asValue!.value;
                String titleText;
                String choiceString;
                if (gameId == null) {
                  titleText = "Top Rated";
                  choiceString = "Top Rated";
                } else {
                  titleText = data.channels.entries
                      .where((element) => element.value.gameId == gameId)
                      .first
                      .key;
                  choiceString = titleText;
                  titleText =
                      "$titleText | ${data.channels.entries.where((element) => element.value.gameId == gameId).first.value.gameId}";
                }
                final List<String> choices =
                    data.channels.entries.map((e) => e.key).toList();

                showIosChoices(
                  context,
                  choices,
                  choices.indexOf(choiceString),
                ).then((val) {
                  if (val == null) return;
                  print("****** iOS then val: $val");
                  print("****** iOS entries: ${data.channels.entries}");
                  selectedValue = choices[val!];
                  print("***** selectedvalue: $selectedValue");
                  String? tempGameId = data.channels.entries
                      .where((element) => element.key == selectedValue)
                      .first
                      .value
                      .gameId;
                  print("****** iOS 1 tempGameId: $tempGameId");
                  if (selectedValue == "Top Rated") {
                    tempGameId = null;
                  } else {
                    selectedValue = choices[val!];
                  }

                  print("****** iOs 2 tempGameId: $tempGameId");

                  ref.read(gameIdStateProvider.notifier).state = tempGameId;
                });
              }
            }); // End FR_data.then
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
              //Container(
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
/*
              SizedBox(
                width: double.infinity,
                child: CupertinoActionSheetAction(
                  //backgroundColor: Theme.of(context).canvasColor,
                  child: const Text('Cancel'),
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                ),
              ),
              */

              Row(
                children: [
                  CupertinoButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(null);
                    },
                  ),
                  const Spacer(),
                  CupertinoButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop(selectedIndex);
                    },
                  ),
                ],
              ),

/*
              Container(
                  color: Colors.white,
                  child: CupertinoActionSheetAction(
                    //backgroundColor: Theme.of(context).canvasColor,
                    child: const Text('Cancel'),
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context, 'Cancel');
                    },
                  )),
*/
/*
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(50), // NEW
                ),
                onPressed: () {},
                child: const Text('Button 2'),
                //color: Colors.blue,
              ),
              */

              //SizedBox(height: 35),
              /*ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(-2); //pasing value on pop is -2
                  },
                  child: Text("Close ")),
                  */
              //),
            ],
          ),
        );
      },
    );
  }
}

//final watchedGameId = Provider<String>((ref) => "");

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentBottomTabProvider);
    //final wGameId = ref.watch(watchedGameId);
    final gameId = ref.watch(gameIdStateProvider);

    // ensure the stream is closed when offstage
    final tvStream = currentTab == BottomTab.watch
        ? ref.watch(
            tvGameStreamProvider(
              WatchParameter(withSound: true, gameId: gameId),
            ),
          )
        : const AsyncLoading<FeaturedPosition>();
    final featuredGame = ref.watch(featuredGameProvider);
    //final tvChannel = ref.watch(tvChannelsProvider);
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
  //return;
}

//final _variationIndex = Provider<int>((ref) => throw UnimplementedError());
/*
Future<int?> showIosChoices(BuildContext context, List<String> choices) {
  return showCupertinoModalPopup<int>(
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
          onSelectedItemChanged: (int selectedItem) {
            //Navigator.pop(context);
          },
        ),
      );
    },
  );
}*/
