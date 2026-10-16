import 'package:dartchess/dartchess.dart' hide Position;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/board_editor/board_editor_controller.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/filter.dart';
import 'package:lichess_mobile/src/widgets/platform_choice_chip.dart';
import 'package:material_ui/material_ui.dart';

class const BoardEditorFilters({required final BoardEditorControllerParams? params, super.key})
    extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorController = boardEditorControllerProvider(params);
    final editorState = ref.watch(editorController);

    final castlingSides = Side.values
        .where((side) => editorState.variant.sideCanCastle(side))
        .toIList();

    return BottomSheetScrollableContainer(
      // With the groups' own padding, 16 around the content and between the groups.
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      children: [
        Padding(
          padding: _kGroupPadding,
          child: Filter<Side>(
            filterType: FilterType.singleChoice,
            choices: Side.values,
            choiceLabel: (side) =>
                Text(side == Side.white ? context.l10n.whitePlays : context.l10n.blackPlays),
            choiceSelected: (side) => editorState.sideToPlay == side,
            onSelected: (side, selected) {
              if (selected) {
                ref.read(editorController.notifier).setSideToPlay(side);
              }
            },
          ),
        ),
        if (castlingSides.isNotEmpty)
          Padding(
            padding: _kGroupPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FilterTitle(context.l10n.castling),
                for (final (i, side) in castlingSides.indexed) ...[
                  // The same space between the rows as between wrapped chips (see [Filter]).
                  if (i > 0 && Theme.of(context).platform == TargetPlatform.iOS)
                    const SizedBox(height: 8.0),
                  Row(
                    spacing: 8.0,
                    children: [
                      SizedBox(
                        width: 100.0,
                        child: Text(
                          side == Side.white ? context.l10n.white : context.l10n.black,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ...[CastlingSide.king, CastlingSide.queen].map((castlingSide) {
                        final isPossible = editorState.isCastlingPossible(side, castlingSide);
                        return PlatformChoiceChip(
                          label: Text(castlingSide == CastlingSide.king ? 'O-O' : 'O-O-O'),
                          selected: isPossible && editorState.isCastlingAllowed(side, castlingSide),
                          onSelected: isPossible
                              ? (selected) {
                                  ref
                                      .read(editorController.notifier)
                                      .setCastling(side, castlingSide, selected);
                                }
                              : null,
                        );
                      }),
                    ],
                  ),
                ],
              ],
            ),
          ),
        if (editorState.variant.hasEnPassant && editorState.enPassantOptions.isNotEmpty)
          Padding(
            padding: _kGroupPadding,
            child: Filter<Square>(
              filterName: context.l10n.enPassant,
              filterType: FilterType.singleChoice,
              choices: editorState.enPassantOptions.squares,
              choiceLabel: (square) => Text(square.name),
              choiceSelected: (square) => editorState.enPassantSquare == square,
              onSelected: (square, _) =>
                  ref.read(editorController.notifier).toggleEnPassantSquare(square),
            ),
          ),
      ],
    );
  }
}

/// The padding of each group of chips.
const _kGroupPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
