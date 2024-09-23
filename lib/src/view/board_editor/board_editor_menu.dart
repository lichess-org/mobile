import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/board_editor/board_editor_controller.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';

class BoardEditorMenu extends ConsumerWidget {
  const BoardEditorMenu({required this.initialFen, super.key});

  final String? initialFen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorController = boardEditorControllerProvider(initialFen);
    final editorState = ref.watch(editorController);

    return BottomSheetScrollableContainer(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      children: [
        Padding(
          padding: Styles.horizontalBodyPadding,
          child: Wrap(
            spacing: 8.0,
            children: [
              ChoiceChip(
                onSelected: (_) {
                  ref.read(editorController.notifier).loadFen(
                        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq',
                        loadCastling: true,
                        loadSideToPlay: true,
                      );
                },
                selected: false,
                label: const Text('Starting Position'),
              ),
              ChoiceChip(
                onSelected: (_) {
                  ref.read(editorController.notifier).loadFen(
                        '8/8/8/8/8/8/8/8',
                        loadCastling: true,
                        loadSideToPlay: true,
                      );
                },
                label: const Text('Clear Board'),
                selected: false,
              ),
            ],
          ),
        ),
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
                    ref.read(editorController.notifier).setSideToPlay(side);
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
              children:
                  [CastlingSide.king, CastlingSide.queen].map((castlingSide) {
                return ChoiceChip(
                  label: Text(
                    castlingSide == CastlingSide.king
                        ? side == Side.white
                            ? context.l10n.whiteCastlingKingside
                            : context.l10n.blackCastlingKingside
                        : 'O-O-O',
                  ),
                  selected: editorState.isCastlingAllowed(side, castlingSide),
                  onSelected: (selected) {
                    ref.read(editorController.notifier).setCastling(
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
        if (editorState.enPassantOptions.isNotEmpty) ...[
          const Padding(
            padding: Styles.bodySectionPadding,
            child: Text('En passant', style: Styles.subtitle),
          ),
          Wrap(
            spacing: 8.0,
            children: editorState.enPassantOptions.squares.map((square) {
              return ChoiceChip(
                label: Text(square.name),
                selected: editorState.enPassantSquare == square,
                onSelected: (selected) {
                  ref
                      .read(editorController.notifier)
                      .toggleEnPassantSquare(square);
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
