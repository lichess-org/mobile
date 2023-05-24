import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart' as cg;

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/settings/play_preferences.dart';
import 'package:lichess_mobile/src/ui/settings/toggle_sound_button.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/table_board_layout.dart';

class OnlineGameScreen extends ConsumerWidget {
  const OnlineGameScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async => false,
      child: PlatformWidget(
        androidBuilder: (context) => _androidBuilder(context, ref),
        iosBuilder: (context) => _iosBuilder(context, ref),
      ),
    );
  }

  Widget _androidBuilder(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _showExitConfirmDialog(context);
          },
        ),
        actions: [
          ToggleSoundButton(),
        ],
      ),
      body: const _GameLoader(),
      // bottomNavigationBar: _BottomBar(game: game),
    );
  }

  Widget _iosBuilder(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        padding: const EdgeInsetsDirectional.only(end: 16.0),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            _showExitConfirmDialog(context);
          },
          child: const Icon(CupertinoIcons.back),
        ),
        trailing: ToggleSoundButton(),
      ),
      child: const SafeArea(
        child: Column(
          children: [
            Expanded(child: _GameLoader()),
            // _BottomBar(game: game),
          ],
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
          content: const Text('Are you sure you want to quit?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(context.l10n.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(context.l10n.accept),
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

class _GameLoader extends ConsumerWidget {
  const _GameLoader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeControlPref = ref
        .watch(playPreferencesProvider.select((prefs) => prefs.timeIncrement));

    return TableBoardLayout(
      boardData: const cg.BoardData(
        interactableSide: cg.InteractableSide.none,
        orientation: cg.Side.white,
        fen: kEmptyFen,
      ),
      topTable: const SizedBox.shrink(),
      bottomTable: const SizedBox.shrink(),
      showMoveListPlaceholder: true,
      boardOverlay: PlatformCard(
        borderRadius: BorderRadius.zero,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(timeControlPref.speed.icon),
                  const SizedBox(width: 8.0),
                  Text(
                    timeControlPref.display,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 36.0),
              const CircularProgressIndicator.adaptive(),
            ],
          ),
        ),
      ),
    );
  }
}
