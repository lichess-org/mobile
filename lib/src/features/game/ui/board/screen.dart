import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartchess/dartchess.dart';
import 'package:chessground/chessground.dart' as cg;

import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/features/settings/ui/is_sound_muted_notifier.dart';

import '../../domain/game.dart' hide Player;

class BoardScreen extends ConsumerWidget {
  const BoardScreen({required this.game, super.key});

  final Game game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final isSoundMuted = ref.watch(isSoundMutedProvider);

    final Widget board = cg.Board(
      size: screenWidth,
      interactableSide: cg.InteractableSide.none,
      orientation: game.orientation.cg,
      fen: game.initialFen,
    );
    final black = Player(
      name: game.black.name,
      rating: game.black.rating,
      title: game.black.title,
      active: false,
      clock: const Duration(milliseconds: 0),
    );
    final white = Player(
      name: game.white.name,
      rating: game.white.rating,
      title: game.white.title,
      active: false,
      clock: const Duration(milliseconds: 0),
    );
    final topPlayer = game.orientation == Side.white ? black : white;
    final bottomPlayer = game.orientation == Side.white ? white : black;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('lichess.org'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _showExitConfirmDialog(context),
          ),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              topPlayer,
              board,
              bottomPlayer,
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [],
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
          title: const Text('Exit the game.'),
          content: const Text('Are you sure you want to quit the game?\n'
              'You won\'t be able to get back after.'),
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
                Navigator.of(context).pop();
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
