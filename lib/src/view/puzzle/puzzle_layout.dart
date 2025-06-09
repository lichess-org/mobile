import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/widgets/board.dart';

typedef InteractiveBoardParams = ({
  Variant variant,
  Position position,
  PlayerSide playerSide,
  NormalMove? promotionMove,
  void Function(NormalMove, {bool? isDrop}) onMove,
  void Function(Role? role) onPromotionSelection,
  Premovable? premovable,
});

/// Layout for puzzle screens that adapts to screen size and aspect ratio
class PuzzleLayout extends ConsumerStatefulWidget {
  /// Creates a puzzle layout with the given values.
  const PuzzleLayout({
    required this.orientation,
    this.fen,
    this.interactiveBoardParams,
    this.lastMove,
    this.topTable = const SizedBox.shrink(),
    this.bottomTable = const SizedBox.shrink(),
    this.landscapeMoveList = const SizedBox.shrink(),
    this.shapes,
    this.engineGauge,
    this.errorMessage,
    this.boardKey,
    this.showEngineGaugePlaceholder = false,
    this.userActionsBar,
    super.key,
  }) : assert(
         fen != null || interactiveBoardParams != null,
         'Either a fen or interactiveBoardParams must be provided',
       );

  /// Creates an empty puzzle layout (useful for loading).
  const PuzzleLayout.empty({this.showEngineGaugePlaceholder = false, this.errorMessage})
    : orientation = Side.white,
      fen = kEmptyFen,
      interactiveBoardParams = null,
      lastMove = null,
      landscapeMoveList = const SizedBox.shrink(),
      topTable = const SizedBox.shrink(),
      bottomTable = const SizedBox.shrink(),
      shapes = null,
      boardKey = null,
      engineGauge = null,
      userActionsBar = null;

  final String? fen;

  final InteractiveBoardParams? interactiveBoardParams;

  final Side orientation;

  final Move? lastMove;

  final ISet<Shape>? shapes;

  /// Widget that will appear at the top of the board.
  final Widget topTable;

  /// Widget that will appear at the bottom of the board.
  final Widget bottomTable;

  /// Widget that will be displayed on the right side of the board on landscape mode.
  final Widget landscapeMoveList;

  /// Optional engine gauge that will be displayed next to the board.
  final EngineGaugeParams? engineGauge;

  /// Optional error message that will be displayed on top of the board.
  final String? errorMessage;

  /// [GlobalKey] for the board.
  ///
  /// Used to set gestures exclusion on android.
  final GlobalKey? boardKey;

  /// Whether to show the engine gauge placeholder.
  final bool showEngineGaugePlaceholder;

  /// Optional widget that contains various user actions, usually a `BottomBar`.
  /// Displayed below the board, or below the move list if landscape mode is used.
  final Widget? userActionsBar;

  @override
  ConsumerState<PuzzleLayout> createState() => _PuzzleLayoutState();
}

class _PuzzleLayoutState extends ConsumerState<PuzzleLayout> {
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

        final shapes = userShapes.union(widget.shapes ?? ISet());

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
                  settings: defaultSettings,
                  error: widget.errorMessage,
                ),
                if (widget.engineGauge != null) ...[
                  const SizedBox(width: 4.0),
                  EngineGauge(
                    params: widget.engineGauge!,
                    displayMode: EngineGaugeDisplayMode.vertical,
                  ),
                ] else if (widget.showEngineGaugePlaceholder) ...[
                  const SizedBox(width: kEvalGaugeSize + 4.0),
                ],
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      widget.topTable,
                      widget.bottomTable,
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: widget.landscapeMoveList,
                        ),
                      ),

                      if (widget.userActionsBar != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: widget.userActionsBar,
                        ),
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

          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? kTabletBoardTableSidePadding : 12.0,
                  ),
                  child: widget.topTable,
                ),
              ),
              if (widget.engineGauge != null)
                Padding(
                  padding: isTablet
                      ? const EdgeInsets.symmetric(horizontal: kTabletBoardTableSidePadding)
                      : EdgeInsets.zero,
                  child: EngineGauge(
                    params: widget.engineGauge!,
                    displayMode: EngineGaugeDisplayMode.horizontal,
                  ),
                )
              else if (widget.showEngineGaugePlaceholder)
                const SizedBox(height: kEvalGaugeSize),
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
                  settings: defaultSettings,
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
