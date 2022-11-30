import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart';

import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/features/settings/ui/is_sound_muted_notifier.dart';

class BoardScreen extends ConsumerWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final isSoundMuted = ref.watch(isSoundMutedProvider);

    final Widget board = Board(
      size: screenWidth,
      interactableSide: InteractableSide.none,
      orientation: Side.white,
      fen: '8/8/8/8/8/8/8/8 w - - 0 1',
    );
    const Widget topPlayer = Player(
      name: 'Black',
      rating: 1850,
      title: 'FM',
      active: false,
      clock: Duration(milliseconds: 10000),
    );
    const Widget bottomPlayer = Player(
      name: 'White',
      rating: 2030,
      title: 'GM',
      active: false,
      clock: Duration(milliseconds: 10000),
    );
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
