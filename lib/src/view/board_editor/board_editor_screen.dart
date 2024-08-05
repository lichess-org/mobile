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
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
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
    ref.read(boardEditorControllerProvider.notifier);

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
      pointerMode: ref.watch(boardEditorControllerProvider).editorPointerMode,
      onDiscardedPiece:
          ref.read(boardEditorControllerProvider.notifier).discardPiece,
      onDroppedPiece:
          ref.read(boardEditorControllerProvider.notifier).movePiece,
      onEditedSquare:
          ref.read(boardEditorControllerProvider.notifier).editSquare,
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
                    ? Theme.of(context).colorScheme.tertiary
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
                color:
                    ref.read(boardEditorControllerProvider).deletePiecesActive
                        ? Theme.of(context).colorScheme.error
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
    final pgn = ref.watch(boardEditorControllerProvider).pgn;
    final orientation = ref.read(boardEditorControllerProvider).orientation;

    return Container(
      color: Theme.of(context).platform == TargetPlatform.iOS
          ? CupertinoTheme.of(context).barBackgroundColor
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
                    isScrollControlled: true,
                    showDragHandle: true,
                    builder: (BuildContext context) => const BoardEditorMenu(),
                  ),
                  icon: Icons.menu,
                ),
              ),
              Expanded(
                child: BottomBarButton(
                  key: const Key('flip-button'),
                  label: context.l10n.flipBoard,
                  onTap: ref
                      .read(boardEditorControllerProvider.notifier)
                      .flipBoard,
                  icon: Icons.flip,
                ),
              ),
              Expanded(
                child: BottomBarButton(
                  label: context.l10n.analysis,
                  key: const Key('analysis-board-button'),
                  onTap: pgn != null
                      ? () {
                          pushPlatformRoute(
                            context,
                            rootNavigator: true,
                            builder: (context) => AnalysisScreen(
                              pgnOrId: pgn,
                              options: AnalysisOptions(
                                isLocalEvaluationAllowed: true,
                                variant: Variant.fromPosition,
                                orientation: orientation,
                                id: standaloneAnalysisId,
                              ),
                            ),
                          );
                        }
                      : null,
                  icon: LichessIcons.microscope,
                ),
              ),
              Expanded(
                child: BottomBarButton(
                  label: context.l10n.mobileSharePositionAsFEN,
                  onTap: () => launchShareDialog(
                    context,
                    text: ref.read(boardEditorControllerProvider).fen,
                  ),
                  icon: Icons.share,
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
