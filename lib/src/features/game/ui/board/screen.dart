import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartchess/dartchess.dart';
import 'package:chessground/chessground.dart' as cg;

import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/async_value.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/features/settings/ui/is_sound_muted_notifier.dart';
import 'package:lichess_mobile/src/features/user/domain/user.dart';

import '../../domain/game_status.dart';
import '../../domain/game_state.dart';
import '../../domain/game.dart' hide Player;
import '../play/play_action_notifier.dart';
import '../play/form_providers.dart';
import './game_stream.dart';
import './game_state_notifier.dart';
import './game_action_notifier.dart';

class BoardScreen extends ConsumerStatefulWidget {
  const BoardScreen({required this.game, required this.account, super.key});

  final Game game;
  final User account;

  @override
  ConsumerState<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends ConsumerState<BoardScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final isSoundMuted = ref.watch(isSoundMutedProvider);
    final gameState = ref.watch(gameStateProvider);
    final gameStream = ref.watch(gameStreamProvider(widget.game.id));
    final gameActionAsync = ref.watch(gameActionProvider);
    final playActionAsync = ref.watch(playActionProvider);

    ref.listen<GameState?>(gameStateProvider, (_, state) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (state != null && scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeIn,
          );
        }
      });
    });
    ref.listen<AsyncValue>(
      gameActionProvider,
      (_, state) => state.showSnackbarOnError(context),
    );
    ref.listen<AsyncValue>(playActionProvider, (_, state) {
      state.showSnackbarOnError(context);

      if (state.valueOrNull is Game) {
        ref.invalidate(playActionProvider);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) =>
                  BoardScreen(game: state.value!, account: widget.account)),
        );
      }
    });

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('lichess.org'),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (gameState?.gameOver == true) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                } else {
                  _showExitConfirmDialog(context);
                }
              }),
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
          child: gameStream.when(
            data: (clock) {
              final black = Player(
                name: widget.game.black.name,
                rating: widget.game.black.rating,
                title: widget.game.black.title,
                active: gameState != null &&
                    gameState.status == GameStatus.started &&
                    gameState.position.fullmoves > 1 &&
                    gameState.position.turn == Side.black,
                clock: clock.blackTime,
              );
              final white = Player(
                name: widget.game.white.name,
                rating: widget.game.white.rating,
                title: widget.game.white.title,
                active: gameState != null &&
                    gameState.status == GameStatus.started &&
                    gameState.position.fullmoves > 1 &&
                    gameState.position.turn == Side.white,
                clock: clock.whiteTime,
              );
              final topPlayer =
                  widget.game.orientation == Side.white ? black : white;
              final bottomPlayer =
                  widget.game.orientation == Side.white ? white : black;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (gameState != null)
                    Container(
                      padding: const EdgeInsets.only(left: 5),
                      height: 40,
                      child: ListView.builder(
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: gameState.sanMoves.length,
                        itemBuilder: (_, index) => Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: Text(gameState.sanMoves[index]),
                        ),
                      ),
                    ),
                  topPlayer,
                  cg.Board(
                    size: screenWidth,
                    interactableSide: gameState == null || !gameState.playing
                        ? cg.InteractableSide.none
                        : widget.game.orientation == Side.white
                            ? cg.InteractableSide.white
                            : cg.InteractableSide.black,
                    orientation: widget.game.orientation.cg,
                    fen: gameState?.position.fen ?? widget.game.initialFen,
                    validMoves: gameState?.validMoves,
                    lastMove: gameState?.lastMove?.cg,
                    sideToMove: gameState?.position.turn.cg ??
                        widget.game.orientation.cg,
                    onMove: (cg.Move move, {bool? isPremove}) => ref
                        .read(gameStateProvider.notifier)
                        .onUserMove(widget.game.id, Move.fromUci(move.uci)),
                  ),
                  bottomPlayer,
                ],
              );
            },
            loading: () {
              final black = Player(
                name: widget.game.black.name,
                rating: widget.game.black.rating,
                title: widget.game.black.title,
                active: false,
                clock: const Duration(milliseconds: 0),
              );
              final white = Player(
                name: widget.game.white.name,
                rating: widget.game.white.rating,
                title: widget.game.white.title,
                active: false,
                clock: const Duration(milliseconds: 0),
              );
              final topPlayer =
                  widget.game.orientation == Side.white ? black : white;
              final bottomPlayer =
                  widget.game.orientation == Side.white ? white : black;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  topPlayer,
                  cg.Board(
                    size: screenWidth,
                    interactableSide: cg.InteractableSide.none,
                    orientation: widget.game.orientation.cg,
                    fen: widget.game.initialFen,
                  ),
                  bottomPlayer,
                ],
              );
            },
            error: (err, stackTrace) {
              debugPrint(
                  'SEVERE: [BoardScreen] could not load game; ${err.toString()}\n$stackTrace');
              return const Text('Could not load game stream.');
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  showAdaptiveActionSheet(
                    context: context,
                    actions: [
                      if (gameState?.abortable == true)
                        BottomSheetAction(
                          leading: const Icon(LichessIcons.cancel),
                          label: const Text('Abort'),
                          onPressed: (context) {
                            if (!gameActionAsync.isLoading) {
                              ref
                                  .read(gameActionProvider.notifier)
                                  .abort(widget.game.id);
                            }
                          },
                        ),
                      if (gameState?.resignable == true)
                        BottomSheetAction(
                          leading: const Icon(Icons.flag),
                          label: const Text('Resign'),
                          onPressed: (context) {
                            if (!gameActionAsync.isLoading) {
                              ref
                                  .read(gameActionProvider.notifier)
                                  .resign(widget.game.id);
                            }
                          },
                        ),
                      if (gameState?.gameOver == true)
                        BottomSheetAction(
                            leading: const Icon(Icons.swap_vert),
                            label: playActionAsync.isLoading
                                ? const CircularProgressIndicator.adaptive()
                                : const Text('Rematch'),
                            onPressed: (context) {
                              if (!playActionAsync.isLoading) {
                                // TODO refactor with a service
                                final opponentPref =
                                    ref.read(computerOpponentPrefProvider);
                                final stockfishLevel =
                                    ref.read(stockfishLevelProvider);
                                final timeControlPref =
                                    ref.read(timeControlPrefProvider);
                                ref
                                    .read(playActionProvider.notifier)
                                    .createGame(
                                        account: widget.account,
                                        opponent: opponentPref,
                                        timeControl: timeControlPref.value,
                                        level: stockfishLevel);
                              }
                            }),
                    ],
                  );
                },
                icon: const Icon(Icons.menu),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showExitConfirmDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit.'),
          content: const Text('Are you sure you want to quit the game?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }
}
