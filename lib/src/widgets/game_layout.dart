import 'package:chessground/chessground.dart';
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/widgets/board.dart';
import 'package:lichess_mobile/src/widgets/move_list.dart';

typedef InteractiveBoardParams = ({
  Variant variant,
  Position position,
  PlayerSide playerSide,
  NormalMove? promotionMove,
  void Function(NormalMove, {bool? isDrop}) onMove,
  void Function(Role? role) onPromotionSelection,
  Premovable? premovable,
});

/// Layout for game screens that adapts to screen size and aspect ratio
///
/// On portrait mode, the board will be displayed in the middle of the screen,
/// with the table spaces on top and bottom.
/// On landscape mode, the board will be displayed on the left side of the screen,
/// with the table spaces on the right side.
///
/// An optional move list can be displayed above the top table space.
///
/// An optional overlay or error message can be displayed on top of the board.
class GameLayout extends ConsumerStatefulWidget {
  /// Creates a game layout with the given values.
  const GameLayout({
    required this.orientation,
    this.fen,
    this.interactiveBoardParams,
    this.lastMove,
    this.boardSettingsOverrides,
    this.topTable = const SizedBox.shrink(),
    this.bottomTable = const SizedBox.shrink(),
    this.shapes,
    this.moves,
    this.currentMoveIndex = 0,
    this.onSelectMove,
    this.boardOverlay,
    this.errorMessage,
    this.boardKey,
    this.zenMode = false,
    this.userActionsBar,
    super.key,
  }) : assert(
         fen != null || interactiveBoardParams != null,
         'Either a fen or interactiveBoardParams must be provided',
       );

  /// Creates an empty game layout (useful for loading).
  const GameLayout.empty({this.moves, this.errorMessage})
    : orientation = Side.white,
      fen = kEmptyFen,
      interactiveBoardParams = null,
      lastMove = null,
      boardSettingsOverrides = null,
      topTable = const SizedBox.shrink(),
      bottomTable = const SizedBox.shrink(),
      shapes = null,
      currentMoveIndex = 0,
      onSelectMove = null,
      boardOverlay = null,
      boardKey = null,
      zenMode = false,
      userActionsBar = null;

  final String? fen;

  final InteractiveBoardParams? interactiveBoardParams;

  final Side orientation;

  final Move? lastMove;

  final BoardSettingsOverrides? boardSettingsOverrides;

  final ISet<Shape>? shapes;

  /// [GlobalKey] for the board.
  ///
  /// Used to set gestures exclusion on android.
  final GlobalKey? boardKey;

  /// Widget that will appear at the top of the board.
  final Widget topTable;

  /// Widget that will appear at the bottom of the board.
  final Widget bottomTable;

  /// Optional list of moves that will be displayed on top of the board.
  final List<String>? moves;

  /// Index of the current move in the [moves] list.
  final int currentMoveIndex;

  /// Callback that will be called when a move is selected from the [moves] list.
  final void Function(int moveIndex)? onSelectMove;

  /// Optional error message that will be displayed on top of the board.
  final String? errorMessage;

  /// Optional widget that will be displayed on top of the board.
  final Widget? boardOverlay;

  /// If true, the move list will be hidden
  final bool zenMode;

  /// Optional widget that contains various user actions, usually a `BottomBar`.
  /// Displayed below the board, or below the move list if landscape mode is used.
  final Widget? userActionsBar;

  @override
  ConsumerState<GameLayout> createState() => _GameLayoutState();
}

class _GameLayoutState extends ConsumerState<GameLayout> {
  ISet<Shape> userShapes = ISet();

  @override
  Widget build(BuildContext context) {
    final boardPrefs = ref.watch(boardPreferencesProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final orientation = constraints.maxWidth > constraints.maxHeight
            ? Orientation.landscape
            : Orientation.portrait;
        final isTablet = isTabletOrLarger(context);

        final defaultSettings = boardPrefs.toBoardSettings().copyWith(
          borderRadius: isTablet ? Styles.boardBorderRadius : BorderRadius.zero,
          boxShadow: isTablet ? boardShadows : const <BoxShadow>[],
          drawShape: DrawShapeOptions(
            enable: boardPrefs.enableShapeDrawings,
            onCompleteShape: _onCompleteShape,
            onClearShapes: _onClearShapes,
            newShapeColor: boardPrefs.shapeColor.color,
          ),
        );

        final settings = widget.boardSettingsOverrides != null
            ? widget.boardSettingsOverrides!.merge(defaultSettings)
            : defaultSettings;

        final shapes = userShapes.union(widget.shapes ?? ISet());
        final slicedMoves = widget.moves?.asMap().entries.slices(2);

        final fen = widget.interactiveBoardParams?.position.fen ?? widget.fen!;
        final gameData = widget.interactiveBoardParams != null
            ? boardPrefs.toGameData(
                variant: widget.interactiveBoardParams!.variant,
                position: widget.interactiveBoardParams!.position,
                playerSide: widget.interactiveBoardParams!.playerSide,
                promotionMove: widget.interactiveBoardParams!.promotionMove,
                onMove: widget.interactiveBoardParams!.onMove,
                onPromotionSelection: widget.interactiveBoardParams!.onPromotionSelection,
                premovable: widget.interactiveBoardParams!.premovable,
              )
            : null;

        if (orientation == Orientation.landscape) {
          final defaultBoardSize =
              constraints.biggest.shortestSide - (kTabletBoardTableSidePadding * 2);
          final sideWidth = constraints.biggest.longestSide - defaultBoardSize;
          final boardSize = sideWidth >= 250
              ? defaultBoardSize
              : constraints.biggest.longestSide / kGoldenRatio - (kTabletBoardTableSidePadding * 2);
          return Padding(
            padding: const EdgeInsets.all(kTabletBoardTableSidePadding),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                BoardWidget(
                  size: boardSize,
                  fen: fen,
                  orientation: widget.orientation,
                  gameData: gameData,
                  lastMove: widget.lastMove,
                  shapes: shapes,
                  settings: settings,
                  boardKey: widget.boardKey,
                  boardOverlay: widget.boardOverlay,
                  error: widget.errorMessage,
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      widget.topTable,
                      if (boardPrefs.moveListDisplay && !widget.zenMode && slicedMoves != null)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: MoveList(
                              type: MoveListType.stacked,
                              slicedMoves: slicedMoves,
                              currentMoveIndex: widget.currentMoveIndex,
                              onSelectMove: widget.onSelectMove,
                            ),
                          ),
                        )
                      else
                        const Spacer(),

                      if (widget.userActionsBar != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: widget.userActionsBar,
                        ),

                      widget.bottomTable,
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          final defaultBoardSize = constraints.biggest.shortestSide;
          final double boardSize = isTablet
              ? defaultBoardSize - kTabletBoardTableSidePadding * 2
              : defaultBoardSize;

          // vertical space left on portrait mode to check if we can display the
          // move list
          final verticalSpaceLeftBoardOnPortrait = constraints.biggest.height - boardSize;

          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (boardPrefs.moveListDisplay &&
                  slicedMoves != null &&
                  verticalSpaceLeftBoardOnPortrait >= kSmallHeightMinusBoard)
                if (widget.zenMode)
                  // display empty move list to keep the layout consistent in zen mode
                  const MoveList(type: MoveListType.inline, slicedMoves: [], currentMoveIndex: 0)
                else
                  MoveList(
                    type: MoveListType.inline,
                    slicedMoves: slicedMoves,
                    currentMoveIndex: widget.currentMoveIndex,
                    onSelectMove: widget.onSelectMove,
                  ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? kTabletBoardTableSidePadding : 12.0,
                  ),
                  child: widget.topTable,
                ),
              ),
              Padding(
                padding: isTablet
                    ? const EdgeInsets.symmetric(horizontal: kTabletBoardTableSidePadding)
                    : EdgeInsets.zero,
                child: BoardWidget(
                  size: boardSize,
                  fen: fen,
                  orientation: widget.orientation,
                  gameData: gameData,
                  lastMove: widget.lastMove,
                  shapes: shapes,
                  settings: settings,
                  boardKey: widget.boardKey,
                  boardOverlay: widget.boardOverlay,
                  error: widget.errorMessage,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? kTabletBoardTableSidePadding : 12.0,
                  ),
                  child: widget.bottomTable,
                ),
              ),
              if (widget.userActionsBar != null) widget.userActionsBar!,
            ],
          );
        }
      },
    );
  }

  void _onCompleteShape(Shape shape) {
    if (!mounted) return;

    if (userShapes.any((element) => element == shape)) {
      setState(() {
        userShapes = userShapes.remove(shape);
      });
      return;
    } else {
      setState(() {
        userShapes = userShapes.add(shape);
      });
    }
  }

  void _onClearShapes() {
    if (!mounted) return;

    setState(() {
      userShapes = ISet();
    });
  }
}

class BoardSettingsOverrides {
  const BoardSettingsOverrides({
    this.animationDuration,
    this.autoQueenPromotion,
    this.autoQueenPromotionOnPremove,
    this.blindfoldMode,
    this.drawShape,
    this.pieceOrientationBehavior,
    this.pieceAssets,
  });

  final Duration? animationDuration;
  final bool? autoQueenPromotion;
  final bool? autoQueenPromotionOnPremove;
  final bool? blindfoldMode;
  final DrawShapeOptions? drawShape;
  final PieceOrientationBehavior? pieceOrientationBehavior;
  final PieceAssets? pieceAssets;

  ChessboardSettings merge(ChessboardSettings settings) {
    return settings.copyWith(
      animationDuration: animationDuration,
      autoQueenPromotion: autoQueenPromotion,
      autoQueenPromotionOnPremove: autoQueenPromotionOnPremove,
      blindfoldMode: blindfoldMode,
      drawShape: drawShape,
      pieceOrientationBehavior: pieceOrientationBehavior,
      pieceAssets: pieceAssets,
    );
  }
}
