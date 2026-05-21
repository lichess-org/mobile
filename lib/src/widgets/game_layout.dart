import 'dart:async';

import 'package:chessground/chessground.dart';
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/game/game_board_params.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/widgets/board.dart';
import 'package:lichess_mobile/src/widgets/move_list.dart';
import 'package:lichess_mobile/src/widgets/pockets.dart';

/// In crazyhouse, when displaying pockets above/below the board, add this much additional side padding to make the board smaller and avoid overflows.
const _kAdditionalBoardSidePaddingForPockets = 70.0;

Side variantBoardOrientation({
  required Variant variant,
  required Side youAre,
  required bool isBoardTurned,
}) {
  // In racing kings, both side's pieces move in the same direction,
  // so always orient the board as "white" regardless of who is playing, unless the board is explicitly turned.
  if (variant == Variant.racingKings) {
    return isBoardTurned ? Side.black : Side.white;
  }

  return isBoardTurned ? youAre.opposite : youAre;
}

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
    required this.boardParams,
    this.lastMove,
    this.boardSettingsOverrides,
    this.topTable = const SizedBox.shrink(),
    this.bottomTable = const SizedBox.shrink(),
    this.topTableUpsideDown = false,
    this.bottomTableUpsideDown = false,
    this.topTableFlex = 1,
    this.bottomTableFlex = 1,
    this.shapes,
    this.moves,
    this.currentMoveIndex = 0,
    this.onSelectMove,
    this.boardOverlay,
    this.errorMessage,
    this.boardKey,
    this.zenMode = false,
    this.userActionsBar,
    this.explosionSquares,
    this.isReplaying = false,
    this.onPremove,
    super.key,
  });

  /// Creates an empty game layout (useful for loading).
  const GameLayout.empty({this.moves, this.errorMessage})
    : orientation = Side.white,
      boardParams = GameBoardParams.emptyBoard,
      lastMove = null,
      boardSettingsOverrides = null,
      topTable = const SizedBox.shrink(),
      bottomTable = const SizedBox.shrink(),
      topTableUpsideDown = false,
      bottomTableUpsideDown = false,
      topTableFlex = 1,
      bottomTableFlex = 1,
      shapes = null,
      currentMoveIndex = 0,
      onSelectMove = null,
      boardOverlay = null,
      boardKey = null,
      zenMode = false,
      userActionsBar = null,
      explosionSquares = null,
      isReplaying = false,
      onPremove = null;

  final GameBoardParams boardParams;

  final Side orientation;

  /// Last move highlight for readonly boards. For interactive boards, use [InteractiveBoardParams.lastMove].
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

  /// Whether to render the [topTable] upside down. Used for OTB games.
  final bool topTableUpsideDown;

  /// Whether to render the [bottomTable] upside down. Used for OTB games.
  final bool bottomTableUpsideDown;

  /// Flex factor for the top table in portrait mode (default: 1).
  final int topTableFlex;

  /// Flex factor for the bottom table in portrait mode (default: 1).
  final int bottomTableFlex;

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

  /// Squares on which an atomic chess explosion should be shown.
  final Set<Square>? explosionSquares;

  /// Whether the board is currently replaying move history (e.g. analysis navigation).
  ///
  /// When true, position changes use [ChessboardController.jumpToPosition] instead of
  /// [ChessboardController.updatePosition], skipping animation and clearing the premove.
  final bool isReplaying;

  /// Called when a premove is ready to be executed after the opponent moves.
  final void Function(Move)? onPremove;

  @override
  ConsumerState<GameLayout> createState() => _GameLayoutState();
}

class _GameLayoutState extends ConsumerState<GameLayout> {
  ChessboardController? _controller;

  /// Tracks the last move that was made via drag-and-drop so we can pass it as
  /// [lastDrop] to [ChessboardController.updatePosition], which suppresses the
  /// redundant translation animation for the already-dragged piece.
  Move? _lastDragMove;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void dispose() {
    _controller?.premoveNotifier.removeListener(_onPremoveChanged);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(GameLayout old) {
    super.didUpdateWidget(old);
    final ctrl = _controller;
    if (ctrl == null) return;

    final oldParams = old.boardParams;
    final newParams = widget.boardParams;
    if (newParams is! InteractiveBoardParams) return;

    final newGameData = _buildGameData(newParams);

    if (oldParams is InteractiveBoardParams) {
      final fenChanged = oldParams.position.fen != newParams.position.fen;
      if (fenChanged) {
        final lastDrop = _lastDragMove;
        _lastDragMove = null;
        if (widget.isReplaying) {
          ctrl.jumpToPosition(
            newParams.position.fen,
            game: newGameData,
            lastMove: newParams.lastMove,
          );
        } else {
          ctrl.updatePosition(
            newParams.position.fen,
            game: newGameData,
            lastMove: newParams.lastMove,
            lastDrop: lastDrop,
          );
          if (widget.explosionSquares != null) {
            ctrl.triggerExplosion(widget.explosionSquares!);
          }
          _tryExecutePremove(newParams);
        }
      } else {
        // Only game metadata changed (e.g. playerSide, validMoves) — update without animation.
        ctrl.updatePosition(newParams.position.fen, game: newGameData);
      }
    }
  }

  void _initController() {
    final params = widget.boardParams;
    if (params is InteractiveBoardParams) {
      final boardPrefs = ref.read(boardPreferencesProvider);
      _controller = ChessboardController(
        fen: params.position.fen,
        game: buildGameData(
          variant: params.variant,
          position: params.position,
          playerSide: params.playerSide,
          lastMove: params.lastMove,
          castlingMethod: boardPrefs.castlingMethod,
          boardHighlights: boardPrefs.boardHighlights,
        ),
      );
      _controller!.premoveNotifier.addListener(_onPremoveChanged);
    }
  }

  void _onPremoveChanged() {
    if (mounted) setState(() {});
  }

  void _tryExecutePremove(InteractiveBoardParams params) {
    final ctrl = _controller;
    final onPremove = widget.onPremove;
    if (ctrl == null || onPremove == null) return;
    final premove = ctrl.premove;
    if (premove == null) return;
    if (params.position.isLegal(premove)) {
      if (premove is NormalMove && isPromotionPawnMove(params.position, premove)) {
        ctrl.premove = null;
        ctrl.pendingPromotion = premove;
      } else {
        ctrl.premove = null;
        // Defer to avoid modifying a Riverpod provider inside didUpdateWidget.
        scheduleMicrotask(() => onPremove(premove));
      }
    } else {
      // Premove became illegal (e.g. after a takeback) — clear it.
      ctrl.premove = null;
    }
  }

  GameData _buildGameData(InteractiveBoardParams params) {
    final boardPrefs = ref.read(boardPreferencesProvider);
    return buildGameData(
      variant: params.variant,
      position: params.position,
      playerSide: params.playerSide,
      lastMove: params.lastMove,
      castlingMethod: boardPrefs.castlingMethod,
      boardHighlights: boardPrefs.boardHighlights,
    );
  }

  @override
  Widget build(BuildContext context) {
    final boardPrefs = ref.watch(boardPreferencesProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final orientation = constraints.maxWidth > constraints.maxHeight
            ? Orientation.landscape
            : Orientation.portrait;
        final isTablet = isTabletOrLarger(context);

        final defaultSettings = boardPrefs
            .toBoardSettings(widget.boardParams.variant)
            .copyWith(
              borderRadius: isTablet ? Styles.boardBorderRadius : BorderRadius.zero,
              boxShadow: isTablet ? boardShadows : const <BoxShadow>[],
            );

        final settings = widget.boardSettingsOverrides != null
            ? widget.boardSettingsOverrides!.merge(defaultSettings)
            : defaultSettings;

        final shapes = widget.shapes?.unlock ?? const <Shape>{};
        final slicedMoves = widget.moves?.asMap().entries.slices(2);

        final sideToMove = switch (widget.boardParams) {
          ReadonlyBoardParams() => null,
          InteractiveBoardParams(:final position, :final playerSide) =>
            playerSide == PlayerSide.none ? null : position.turn,
        };

        final pockets = widget.boardParams.pockets;
        final premoveDropRole = switch (_controller?.premove) {
          DropMove(:final role) => role,
          _ => null,
        };

        // Wrap onMove to capture drag moves for animation suppression via lastDrop.
        final void Function(Move, {bool? viaDragAndDrop})? wrappedOnMove =
            switch (widget.boardParams) {
              final InteractiveBoardParams params => (Move move, {bool? viaDragAndDrop}) {
                if (viaDragAndDrop == true) {
                  _lastDragMove = move;
                }
                params.onMove(move, viaDragAndDrop: viaDragAndDrop);
              },
              _ => null,
            };

        Widget topTable({required double boardSize}) => RotatedBox(
          quarterTurns: widget.topTableUpsideDown ? 2 : 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            verticalDirection: widget.topTableUpsideDown
                ? VerticalDirection.up
                : VerticalDirection.down,
            children: [
              if (pockets != null)
                PocketsMenu(
                  side: widget.orientation.opposite,
                  sideToMove: sideToMove,
                  playerSide: widget.boardParams.playerSide,
                  pockets: pockets,
                  squareSize: pocketSquareSize(boardSize: boardSize, isTablet: isTablet),
                  isUpsideDown: widget.topTableUpsideDown,
                  premoveDropRole: premoveDropRole,
                ),
              widget.topTable,
            ],
          ),
        );

        Widget bottomTable({required double boardSize}) => RotatedBox(
          quarterTurns: widget.bottomTableUpsideDown ? 2 : 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            verticalDirection: widget.bottomTableUpsideDown
                ? VerticalDirection.up
                : VerticalDirection.down,
            children: [
              widget.bottomTable,
              if (pockets != null)
                PocketsMenu(
                  side: widget.orientation,
                  sideToMove: sideToMove,
                  playerSide: widget.boardParams.playerSide,
                  pockets: pockets,
                  squareSize: pocketSquareSize(boardSize: boardSize, isTablet: isTablet),
                  isUpsideDown: widget.bottomTableUpsideDown,
                  premoveDropRole: premoveDropRole,
                ),
            ],
          ),
        );

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
              textDirection: switch (boardPrefs.landscapeBoardPosition) {
                .left => TextDirection.ltr,
                .right => TextDirection.rtl,
              },
              mainAxisSize: MainAxisSize.max,
              children: [
                BoardWidget(
                  size: boardSize,
                  orientation: widget.orientation,
                  controller: _controller,
                  onMove: wrappedOnMove,
                  fen: _controller == null ? widget.boardParams.fen : null,
                  lastMove: _controller == null ? widget.lastMove : null,
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
                      topTable(boardSize: boardSize),
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

                      bottomTable(boardSize: boardSize),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          final defaultBoardSize = constraints.biggest.shortestSide;

          final isShortScreen = isShortVerticalScreen(context);

          final pocketsPadding = (pockets != null && (isTablet || isShortScreen))
              ? _kAdditionalBoardSidePaddingForPockets
              : 0;

          double effectiveBoardSize =
              (isTablet ? defaultBoardSize - kTabletBoardTableSidePadding * 2 : defaultBoardSize) -
              pocketsPadding;

          if (isShortScreen) {
            effectiveBoardSize -= 16;
          }

          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (boardPrefs.moveListDisplay &&
                  slicedMoves != null &&
                  !isShortScreen &&
                  !(isTablet && pockets != null))
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
                flex: widget.topTableFlex,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? kTabletBoardTableSidePadding : 12.0,
                  ),
                  child: topTable(boardSize: effectiveBoardSize),
                ),
              ),
              Padding(
                padding: isTablet
                    ? const EdgeInsets.symmetric(horizontal: kTabletBoardTableSidePadding)
                    : EdgeInsets.zero,
                child: BoardWidget(
                  size: effectiveBoardSize,
                  orientation: widget.orientation,
                  controller: _controller,
                  onMove: wrappedOnMove,
                  fen: _controller == null ? widget.boardParams.fen : null,
                  lastMove: _controller == null ? widget.lastMove : null,
                  shapes: shapes,
                  settings: settings,
                  boardKey: widget.boardKey,
                  boardOverlay: widget.boardOverlay,
                  error: widget.errorMessage,
                ),
              ),
              Expanded(
                flex: widget.bottomTableFlex,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? kTabletBoardTableSidePadding : 12.0,
                  ),
                  child: bottomTable(boardSize: effectiveBoardSize),
                ),
              ),
              if (widget.userActionsBar != null) widget.userActionsBar!,
            ],
          );
        }
      },
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
    this.enablePremoves,
  });

  final Duration? animationDuration;
  final bool? autoQueenPromotion;
  final bool? autoQueenPromotionOnPremove;
  final bool? blindfoldMode;
  final DrawShapeOptions? drawShape;
  final PieceOrientationBehavior? pieceOrientationBehavior;
  final PieceAssets? pieceAssets;
  final bool? enablePremoves;

  ChessboardSettings merge(ChessboardSettings settings) {
    return settings.copyWith(
      animationDuration: animationDuration,
      autoQueenPromotion: autoQueenPromotion,
      autoQueenPromotionOnPremove: autoQueenPromotionOnPremove,
      blindfoldMode: blindfoldMode,
      drawShape: drawShape,
      pieceOrientationBehavior: pieceOrientationBehavior,
      pieceAssets: pieceAssets,
      enablePremoves: enablePremoves,
    );
  }
}
