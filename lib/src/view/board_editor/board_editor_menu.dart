import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/board_editor/board_editor_controller.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

class BoardEditorMenu extends ConsumerWidget {
  const BoardEditorMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(boardEditorControllerProvider);
    final boardEditorNotifier =
        ref.read(boardEditorControllerProvider.notifier);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: Styles.horizontalBodyPadding,
                child: Wrap(
                  spacing: 8.0,
                  children: Side.values.map((side) {
                    return ChoiceChip(
                      label: Text(
                        side == Side.white
                            ? context.l10n.whitePlays
                            : context.l10n.blackPlays,
                      ),
                      selected: editorState.sideToPlay == side,
                      onSelected: (selected) {
                        if (selected) {
                          boardEditorNotifier.setSideToPlay(side);
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: Styles.bodySectionPadding,
                child: Text(context.l10n.castling, style: Styles.subtitle),
              ),
              ...Side.values.map((side) {
                return Padding(
                  padding: Styles.horizontalBodyPadding,
                  child: Wrap(
                    spacing: 8.0,
                    children: [CastlingSide.king, CastlingSide.queen]
                        .map((castlingSide) {
                      return ChoiceChip(
                        label: Text(
                          castlingSide == CastlingSide.king
                              ? side == Side.white
                                  ? context.l10n.whiteCastlingKingside
                                  : context.l10n.blackCastlingKingside
                              : 'O-O-O',
                        ),
                        selected:
                            editorState.isCastlingAllowed(side, castlingSide),
                        onSelected: (selected) {
                          boardEditorNotifier.setCastling(
                            side,
                            castlingSide,
                            selected,
                          );
                        },
                      );
                    }).toList(),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
