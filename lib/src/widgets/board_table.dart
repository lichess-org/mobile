import 'package:chessground/chessground.dart';
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/widgets/move_list.dart';

/// Board layout that adapts to screen size and aspect ratio.
///
/// On portrait mode, the board will be displayed in the middle of the screen,
/// with the table spaces on top and bottom.
/// On landscape mode, the board will be displayed on the left side of the screen,
/// with the table spaces on the right side.
///
/// An optional move list can be displayed above the top table space.
///
/// An optional overlay or error message can be displayed on top of the board.
class BoardTable extends ConsumerStatefulWidget {
  /// Creates a board table with the given values.
  const BoardTable({
    required this.fen,
    required this.orientation,
    this.gameData,
    this.lastMove,
    this.boardSettingsOverrides,
    this.topTable = const SizedBox.shrink(),
    this.bottomTable = const SizedBox.shrink(),
    this.shapes,
    this.engineGauge,
    this.moves,
    this.currentMoveIndex,
    this.onSelectMove,
    this.boardOverlay,
    this.errorMessage,
    this.showMoveListPlaceholder = false,
    this.showEngineGaugePlaceholder = false,
    this.boardKey,
    this.zenMode = false,
    super.key,
  }) : assert(
         moves == null || currentMoveIndex != null,
         'You must provide `currentMoveIndex` along with `moves`',
       );

  /// Creates an empty board table (useful for loading).
  const BoardTable.empty({
    this.showMoveListPlaceholder = false,
    this.showEngineGaugePlaceholder = false,
    this.errorMessage,
  }) : fen = kEmptyBoardFEN,
       orientation = Side.white,
       gameData = null,
       lastMove = null,
       boardSettingsOverrides = null,
       topTable = const SizedBox.shrink(),
       bottomTable = const SizedBox.shrink(),
       shapes = null,
       engineGauge = null,
       moves = null,
       currentMoveIndex = null,
       onSelectMove = null,
       boardOverlay = null,
       boardKey = null,
       zenMode = false;

  final String fen;

  final Side orientation;

  final GameData? gameData;

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

  /// Optional engine gauge that will be displayed next to the board.
  final EngineGaugeParams? engineGauge;

  /// Optional list of moves that will be displayed on top of the board.
  final List<String>? moves;

  /// Index of the current move in the [moves] list. Must be provided if [moves] is provided.
  final int? currentMoveIndex;

  /// Callback that will be called when a move is selected from the [moves] list.
  final void Function(int moveIndex)? onSelectMove;

  /// Optional error message that will be displayed on top of the board.
  final String? errorMessage;

  /// Optional widget that will be displayed on top of the board.
  final Widget? boardOverlay;

  /// Whether to show the move list placeholder. Useful when loading.
  final bool showMoveListPlaceholder;

  /// Whether to show the engine gauge placeholder.
  final bool showEngineGaugePlaceholder;

  /// If true, the move list will be hidden
  final bool zenMode;

  @override
  ConsumerState<BoardTable> createState() => _BoardTableState();
}

class _BoardTableState extends ConsumerState<BoardTable> {
  ISet<Shape> userShapes = ISet();

  @override
  Widget build(BuildContext context) {
    final boardPrefs = ref.watch(boardPreferencesProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final orientation =
            constraints.maxWidth > constraints.maxHeight
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

        final settings =
            widget.boardSettingsOverrides != null
                ? widget.boardSettingsOverrides!.merge(defaultSettings)
                : defaultSettings;

        final shapes = userShapes.union(widget.shapes ?? ISet());
        final slicedMoves = widget.moves?.asMap().entries.slices(2);

        if (orientation == Orientation.landscape) {
          final defaultBoardSize =
              constraints.biggest.shortestSide - (kTabletBoardTableSidePadding * 2);
          final sideWidth = constraints.biggest.longestSide - defaultBoardSize;
          final boardSize =
              sideWidth >= 250
                  ? defaultBoardSize
                  : constraints.biggest.longestSide / kGoldenRatio -
                      (kTabletBoardTableSidePadding * 2);
          return Padding(
            padding: const EdgeInsets.all(kTabletBoardTableSidePadding),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                _BoardWidget(
                  size: boardSize,
                  boardPrefs: boardPrefs,
                  fen: widget.fen,
                  orientation: widget.orientation,
                  gameData: widget.gameData,
                  lastMove: widget.lastMove,
                  shapes: shapes,
                  settings: settings,
                  boardKey: widget.boardKey,
                  boardOverlay: widget.boardOverlay,
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
                      if (!widget.zenMode && slicedMoves != null)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: MoveList(
                              type: MoveListType.stacked,
                              slicedMoves: slicedMoves,
                              currentMoveIndex: widget.currentMoveIndex ?? 0,
                              onSelectMove: widget.onSelectMove,
                            ),
                          ),
                        )
                      else
                        const Spacer(),
                      widget.bottomTable,
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          final defaultBoardSize = constraints.biggest.shortestSide;
          final double boardSize =
              isTablet ? defaultBoardSize - kTabletBoardTableSidePadding * 2 : defaultBoardSize;

          // vertical space left on portrait mode to check if we can display the
          // move list
          final verticalSpaceLeftBoardOnPortrait = constraints.biggest.height - boardSize;

          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!widget.zenMode && slicedMoves != null && verticalSpaceLeftBoardOnPortrait >= 130)
                MoveList(
                  type: MoveListType.inline,
                  slicedMoves: slicedMoves,
                  currentMoveIndex: widget.currentMoveIndex ?? 0,
                  onSelectMove: widget.onSelectMove,
                )
              else if (widget.showMoveListPlaceholder && verticalSpaceLeftBoardOnPortrait >= 130)
                const SizedBox(height: 40),
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
                  padding:
                      isTablet
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
                padding:
                    isTablet
                        ? const EdgeInsets.symmetric(horizontal: kTabletBoardTableSidePadding)
                        : EdgeInsets.zero,
                child: _BoardWidget(
                  size: boardSize,
                  boardPrefs: boardPrefs,
                  fen: widget.fen,
                  orientation: widget.orientation,
                  gameData: widget.gameData,
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
            ],
          );
        }
      },
    );
  }

  void _onCompleteShape(Shape shape) {
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
    setState(() {
      userShapes = ISet();
    });
  }
}

class _BoardWidget extends StatelessWidget {
  const _BoardWidget({
    required this.size,
    required this.boardPrefs,
    required this.fen,
    required this.orientation,
    required this.gameData,
    required this.lastMove,
    required this.shapes,
    required this.settings,
    required this.boardOverlay,
    required this.error,
    this.boardKey,
  });

  final double size;
  final BoardPrefs boardPrefs;
  final String fen;
  final Side orientation;
  final GameData? gameData;
  final Move? lastMove;
  final ISet<Shape> shapes;
  final ChessboardSettings settings;
  final String? error;
  final Widget? boardOverlay;
  final GlobalKey? boardKey;

  @override
  Widget build(BuildContext context) {
    final board = Chessboard(
      key: boardKey,
      size: size,
      fen: fen,
      orientation: orientation,
      game: gameData,
      lastMove: lastMove,
      shapes: shapes,
      settings: settings,
    );

    if (boardOverlay != null) {
      return SizedBox.square(
        dimension: size,
        child: Stack(
          children: [
            board,
            SizedBox.square(
              dimension: size,
              child: Center(
                child: SizedBox(
                  width: (size / 8) * 6.6,
                  height: (size / 8) * 4.6,
                  child: boardOverlay,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (error != null) {
      return SizedBox.square(
        dimension: size,
        child: Stack(children: [board, _ErrorWidget(errorMessage: error!, boardSize: size)]),
      );
    }

    return board;
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({required this.errorMessage, required this.boardSize});
  final double boardSize;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: boardSize,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color:
                  Theme.of(context).platform == TargetPlatform.iOS
                      ? CupertinoColors.secondarySystemBackground.resolveFrom(context)
                      : ColorScheme.of(context).surface,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Padding(padding: const EdgeInsets.all(10.0), child: Text(errorMessage)),
          ),
        ),
      ),
    );
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
