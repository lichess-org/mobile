import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/board_editor/board_editor_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/board_editor/board_editor_menu.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

class BoardEditorScreen extends StatelessWidget {
  const BoardEditorScreen({super.key, this.initialFen});

  final String? initialFen;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(title: Text(context.l10n.boardEditor)),
      body: _Body(initialFen),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body(this.initialFen);

  final String? initialFen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardEditorState = ref.watch(boardEditorControllerProvider(initialFen));

    return Column(
      children: [
        Expanded(
          child: SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final aspectRatio = constraints.biggest.aspectRatio;

                final defaultBoardSize = constraints.biggest.shortestSide;
                final isTablet = isTabletOrLarger(context);
                final remainingHeight = constraints.maxHeight - defaultBoardSize;
                final isSmallScreen = remainingHeight < kSmallRemainingHeightLeftBoardThreshold;
                final boardSize =
                    isTablet || isSmallScreen
                        ? defaultBoardSize - kTabletBoardTableSidePadding * 2
                        : defaultBoardSize;

                final direction = aspectRatio > 1 ? Axis.horizontal : Axis.vertical;

                return Flex(
                  direction: direction,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _PieceMenu(
                      boardSize,
                      initialFen: initialFen,
                      direction: flipAxis(direction),
                      side: boardEditorState.orientation.opposite,
                      isTablet: isTablet,
                    ),
                    _BoardEditor(
                      boardSize,
                      initialFen: initialFen,
                      orientation: boardEditorState.orientation,
                      isTablet: isTablet,
                      // unlockView is safe because chessground will never modify the pieces
                      pieces: boardEditorState.pieces.unlockView,
                    ),
                    _PieceMenu(
                      boardSize,
                      initialFen: initialFen,
                      direction: flipAxis(direction),
                      side: boardEditorState.orientation,
                      isTablet: isTablet,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        _BottomBar(initialFen),
      ],
    );
  }
}

class _BoardEditor extends ConsumerWidget {
  const _BoardEditor(
    this.boardSize, {
    required this.initialFen,
    required this.isTablet,
    required this.orientation,
    required this.pieces,
  });

  final String? initialFen;
  final double boardSize;
  final bool isTablet;
  final Side orientation;
  final Pieces pieces;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(boardEditorControllerProvider(initialFen));
    final boardPrefs = ref.watch(boardPreferencesProvider);

    return ChessboardEditor(
      size: boardSize,
      pieces: pieces,
      orientation: orientation,
      settings: boardPrefs.toBoardSettings().copyWith(
        borderRadius: isTablet ? const BorderRadius.all(Radius.circular(4.0)) : BorderRadius.zero,
        boxShadow: isTablet ? boardShadows : const <BoxShadow>[],
      ),
      pointerMode: editorState.editorPointerMode,
      onDiscardedPiece:
          (Square square) =>
              ref.read(boardEditorControllerProvider(initialFen).notifier).discardPiece(square),
      onDroppedPiece:
          (Square? origin, Square dest, Piece piece) => ref
              .read(boardEditorControllerProvider(initialFen).notifier)
              .movePiece(origin, dest, piece),
      onEditedSquare:
          (Square square) =>
              ref.read(boardEditorControllerProvider(initialFen).notifier).editSquare(square),
    );
  }
}

class _PieceMenu extends ConsumerStatefulWidget {
  const _PieceMenu(
    this.boardSize, {
    required this.initialFen,
    required this.direction,
    required this.side,
    required this.isTablet,
  });

  final String? initialFen;

  final double boardSize;

  final Axis direction;

  final Side side;

  final bool isTablet;

  @override
  ConsumerState<_PieceMenu> createState() => _PieceMenuState();
}

class _PieceMenuState extends ConsumerState<_PieceMenu> {
  @override
  Widget build(BuildContext context) {
    final boardPrefs = ref.watch(boardPreferencesProvider);
    final editorController = boardEditorControllerProvider(widget.initialFen);
    final editorState = ref.watch(editorController);

    final squareSize = widget.boardSize / 8;

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius:
            widget.isTablet ? const BorderRadius.all(Radius.circular(4.0)) : BorderRadius.zero,
        boxShadow: widget.isTablet ? boardShadows : const <BoxShadow>[],
      ),
      child: ColoredBox(
        color: Theme.of(context).disabledColor,
        child: Flex(
          direction: widget.direction,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: squareSize,
              height: squareSize,
              child: ColoredBox(
                key: Key('drag-button-${widget.side.name}'),
                color:
                    editorState.editorPointerMode == EditorPointerMode.drag
                        ? context.lichessColors.good
                        : Colors.transparent,
                child: GestureDetector(
                  onTap:
                      () => ref.read(editorController.notifier).updateMode(EditorPointerMode.drag),
                  child: Icon(CupertinoIcons.hand_draw, size: 0.9 * squareSize),
                ),
              ),
            ),
            ...Role.values.map((role) {
              final piece = Piece(role: role, color: widget.side);
              final pieceWidget = PieceWidget(
                piece: piece,
                size: squareSize,
                pieceAssets: boardPrefs.pieceSet.assets,
              );

              return ColoredBox(
                key: Key('piece-button-${piece.color.name}-${piece.role.name}'),
                color:
                    ref.read(boardEditorControllerProvider(widget.initialFen)).activePieceOnEdit ==
                            piece
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                child: GestureDetector(
                  child: Draggable(
                    data: Piece(role: role, color: widget.side),
                    feedback: PieceDragFeedback(
                      piece: piece,
                      squareSize: squareSize,
                      pieceAssets: boardPrefs.pieceSet.assets,
                    ),
                    child: pieceWidget,
                    onDragEnd:
                        (_) =>
                            ref.read(editorController.notifier).updateMode(EditorPointerMode.drag),
                  ),
                  onTap:
                      () => ref
                          .read(editorController.notifier)
                          .updateMode(EditorPointerMode.edit, piece),
                ),
              );
            }),
            SizedBox(
              key: Key('delete-button-${widget.side.name}'),
              width: squareSize,
              height: squareSize,
              child: ColoredBox(
                color:
                    editorState.deletePiecesActive
                        ? context.lichessColors.error
                        : Colors.transparent,
                child: GestureDetector(
                  onTap:
                      () => {
                        ref
                            .read(editorController.notifier)
                            .updateMode(EditorPointerMode.edit, null),
                      },
                  child: Icon(CupertinoIcons.delete, size: 0.8 * squareSize),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar(this.initialFen);

  final String? initialFen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(boardEditorControllerProvider(initialFen));
    final pieceCount = editorState.pieces.length;

    return BottomBar(
      children: [
        BottomBarButton(
          label: context.l10n.menu,
          onTap:
              () => showAdaptiveBottomSheet<void>(
                context: context,
                builder: (BuildContext context) => BoardEditorMenu(initialFen: initialFen),
                showDragHandle: true,
                constraints: BoxConstraints(minHeight: MediaQuery.sizeOf(context).height * 0.5),
              ),
          icon: Icons.tune,
        ),
        BottomBarButton(
          key: const Key('flip-button'),
          label: context.l10n.flipBoard,
          onTap: ref.read(boardEditorControllerProvider(initialFen).notifier).flipBoard,
          icon: CupertinoIcons.arrow_2_squarepath,
        ),
        BottomBarButton(
          label: context.l10n.analysis,
          key: const Key('analysis-board-button'),
          onTap:
              editorState.pgn != null &&
                      // 1 condition (of many) where stockfish segfaults
                      pieceCount > 0 &&
                      pieceCount <= 32
                  ? () {
                    pushPlatformRoute(
                      context,
                      rootNavigator: true,
                      builder:
                          (context) => AnalysisScreen(
                            options: AnalysisOptions(
                              orientation: editorState.orientation,
                              standalone: (
                                pgn: editorState.pgn!,
                                isComputerAnalysisAllowed: true,
                                variant: Variant.fromPosition,
                              ),
                            ),
                          ),
                    );
                  }
                  : null,
          icon: Icons.biotech,
        ),
        BottomBarButton(
          label: context.l10n.mobileSharePositionAsFEN,
          onTap: () => launchShareDialog(context, text: editorState.fen),
          icon:
              Theme.of(context).platform == TargetPlatform.iOS ? CupertinoIcons.share : Icons.share,
        ),
      ],
    );
  }
}
