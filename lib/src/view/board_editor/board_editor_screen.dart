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
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class BoardEditorScreen extends StatelessWidget {
  const BoardEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.boardEditor),
      ),
      body: const _Body(),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Styles.cupertinoScaffoldColor.resolveFrom(context),
        border: null,
        middle: Text(context.l10n.boardEditor),
      ),
      child: const _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardEditorState = ref.watch(boardEditorControllerProvider);

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
                final remainingHeight =
                    constraints.maxHeight - defaultBoardSize;
                final isSmallScreen =
                    remainingHeight < kSmallRemainingHeightLeftBoardThreshold;
                final boardSize = isTablet || isSmallScreen
                    ? defaultBoardSize - kTabletBoardTableSidePadding * 2
                    : defaultBoardSize;

                final direction =
                    aspectRatio > 1 ? Axis.horizontal : Axis.vertical;

                return Flex(
                  direction: direction,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _PieceMenu(
                      boardSize,
                      direction: flipAxis(direction),
                      side: boardEditorState.orientation.opposite,
                      isTablet: isTablet,
                    ),
                    _BoardEditor(
                      boardSize,
                      orientation: boardEditorState.orientation,
                      isTablet: isTablet,
                      pieces: boardEditorState.pieces.unlock,
                    ),
                    _PieceMenu(
                      boardSize,
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
        const _BottomBar(),
      ],
    );
  }
}

class _BoardEditor extends ConsumerWidget {
  const _BoardEditor(
    this.boardSize, {
    required this.isTablet,
    required this.orientation,
    required this.pieces,
  });

  final double boardSize;
  final bool isTablet;
  final Side orientation;
  final Pieces pieces;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(boardEditorControllerProvider);
    final boardPrefs = ref.watch(boardPreferencesProvider);

    return ChessboardEditor(
      size: boardSize,
      pieces: pieces,
      orientation: orientation,
      settings: ChessboardEditorSettings(
        pieceAssets: boardPrefs.pieceSet.assets,
        colorScheme: boardPrefs.boardTheme.colors,
        enableCoordinates: boardPrefs.coordinates,
        borderRadius: isTablet
            ? const BorderRadius.all(Radius.circular(4.0))
            : BorderRadius.zero,
        boxShadow: isTablet ? boardShadows : const <BoxShadow>[],
      ),
      pointerMode: editorState.editorPointerMode,
      onDiscardedPiece: (Square square) =>
          ref.read(boardEditorControllerProvider.notifier).discardPiece(square),
      onDroppedPiece: (Square? origin, Square dest, Piece piece) => ref
          .read(boardEditorControllerProvider.notifier)
          .movePiece(origin, dest, piece),
      onEditedSquare: (Square square) =>
          ref.read(boardEditorControllerProvider.notifier).editSquare(square),
    );
  }
}

class _PieceMenu extends ConsumerStatefulWidget {
  const _PieceMenu(
    this.boardSize, {
    required this.direction,
    required this.side,
    required this.isTablet,
  });

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
    final editorState = ref.watch(boardEditorControllerProvider);

    final squareSize = widget.boardSize / 8;

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: widget.isTablet
            ? const BorderRadius.all(Radius.circular(4.0))
            : BorderRadius.zero,
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
                color: ref
                            .watch(boardEditorControllerProvider)
                            .editorPointerMode ==
                        EditorPointerMode.drag
                    ? context.lichessColors.good
                    : Colors.transparent,
                child: GestureDetector(
                  onTap: () => ref
                      .read(boardEditorControllerProvider.notifier)
                      .updateMode(EditorPointerMode.drag),
                  child: Icon(
                    CupertinoIcons.hand_draw,
                    size: 0.9 * squareSize,
                  ),
                ),
              ),
            ),
            ...Role.values.map(
              (role) {
                final piece = Piece(role: role, color: widget.side);
                final pieceWidget = PieceWidget(
                  piece: piece,
                  size: squareSize,
                  pieceAssets: boardPrefs.pieceSet.assets,
                );

                return ColoredBox(
                  key: Key(
                    'piece-button-${piece.color.name}-${piece.role.name}',
                  ),
                  color: ref
                              .read(boardEditorControllerProvider)
                              .activePieceOnEdit ==
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
                      onDragEnd: (_) => ref
                          .read(boardEditorControllerProvider.notifier)
                          .updateMode(EditorPointerMode.drag),
                    ),
                    onTap: () => ref
                        .read(boardEditorControllerProvider.notifier)
                        .updateMode(EditorPointerMode.edit, piece),
                  ),
                );
              },
            ),
            SizedBox(
              key: Key('delete-button-${widget.side.name}'),
              width: squareSize,
              height: squareSize,
              child: ColoredBox(
                color: editorState.deletePiecesActive
                    ? context.lichessColors.error
                    : Colors.transparent,
                child: GestureDetector(
                  onTap: () => {
                    ref
                        .read(boardEditorControllerProvider.notifier)
                        .updateMode(EditorPointerMode.edit, null),
                  },
                  child: Icon(
                    CupertinoIcons.delete,
                    size: 0.8 * squareSize,
                  ),
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
  const _BottomBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(boardEditorControllerProvider);

    return Container(
      color: Theme.of(context).platform == TargetPlatform.iOS
          ? CupertinoDynamicColor.resolve(
              CupertinoColors.tertiarySystemGroupedBackground,
              context,
            )
          : Theme.of(context).bottomAppBarTheme.color,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: kBottomBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: BottomBarButton(
                  label: context.l10n.menu,
                  onTap: () => showAdaptiveBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) => const BoardEditorMenu(),
                  ),
                  icon: Icons.tune,
                ),
              ),
              Expanded(
                child: BottomBarButton(
                  key: const Key('flip-button'),
                  label: context.l10n.flipBoard,
                  onTap: ref
                      .read(boardEditorControllerProvider.notifier)
                      .flipBoard,
                  icon: CupertinoIcons.arrow_2_squarepath,
                ),
              ),
              Expanded(
                child: BottomBarButton(
                  label: context.l10n.analysis,
                  key: const Key('analysis-board-button'),
                  onTap: editorState.pgn != null
                      ? () {
                          pushPlatformRoute(
                            context,
                            rootNavigator: true,
                            builder: (context) => AnalysisScreen(
                              pgnOrId: editorState.pgn!,
                              options: AnalysisOptions(
                                isLocalEvaluationAllowed: true,
                                variant: Variant.fromPosition,
                                orientation: editorState.orientation,
                                id: standaloneAnalysisId,
                              ),
                            ),
                          );
                        }
                      : null,
                  icon: Icons.biotech,
                ),
              ),
              Expanded(
                child: BottomBarButton(
                  label: context.l10n.mobileSharePositionAsFEN,
                  onTap: () => launchShareDialog(
                    context,
                    text: editorState.fen,
                  ),
                  icon: Theme.of(context).platform == TargetPlatform.iOS
                      ? CupertinoIcons.share
                      : Icons.share,
                ),
              ),
              const SizedBox(height: 26.0),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
