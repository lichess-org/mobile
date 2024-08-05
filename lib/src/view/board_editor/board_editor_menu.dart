import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/board_editor/board_editor_controller.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class BoardEditorMenu extends ConsumerWidget {
  const BoardEditorMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardEditorController = ref.watch(boardEditorControllerProvider);
    final boardEditorNotifier =
        ref.read(boardEditorControllerProvider.notifier);

    return Container(
      color: Theme.of(context).platform == TargetPlatform.iOS
          ? CupertinoTheme.of(context).barBackgroundColor
          : Theme.of(context).bottomAppBarTheme.color,
      child: SafeArea(
        child: Padding(
          padding: Styles.bodyPadding,
          child: ListView(
            shrinkWrap: true,
            children: [
              SwitchSettingTile(
                title: const Text('White to play'),
                value: boardEditorController.sideToPlay == Side.white,
                onChanged: (white) => boardEditorNotifier.setSideToPlay(
                  white ? Side.white : Side.black,
                ),
              ),
              PlatformListTile(
                title: Text('Castling Rights', style: Styles.sectionTitle),
              ),
              SwitchSettingTile(
                title: const Text('White O-O'),
                value: boardEditorController.canWhiteCastleKingside,
                onChanged: boardEditorNotifier.setWhiteKingsideCastlingAllowed,
              ),
              SwitchSettingTile(
                title: const Text('White O-O-O'),
                value: boardEditorController.canWhiteCastleQueenside,
                onChanged: boardEditorNotifier.setWhiteQueensideCastlingAllowed,
              ),
              SwitchSettingTile(
                title: const Text('Black O-O'),
                value: boardEditorController.canBlackCastleKingside,
                onChanged: boardEditorNotifier.setBlackKingsideCastlingAllowed,
              ),
              SwitchSettingTile(
                title: const Text('Black O-O-O'),
                value: boardEditorController.canBlackCastleQueenside,
                onChanged: boardEditorNotifier.setBlackQueensideCastlingAllowed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
