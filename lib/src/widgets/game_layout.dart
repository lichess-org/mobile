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
  ///
  /// Exactly one of [boardParams] (the screen lets [GameLayout] own the board
  /// controller) or [controllerParams] (the screen owns the controller, for the
  /// high-performance path) must be provided.
  const GameLayout({
    required this.orientation,
    this.boardParams,
    this.controllerParams,
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
    this.moveListBuilder,
    this.boardOverlay,
    this.errorMessage,
    this.boardKey,
    this.zenMode = false,
    this.userActionsBar,
    this.explosionSquares,
    this.isReplaying = false,
    this.onPremove,
    super.key,
  }) : assert(
         (boardParams == null) != (controllerParams == null),
         'Provide exactly one of boardParams or controllerParams',
       );

  /// Creates an empty game layout (useful for loading).
  const GameLayout.empty({this.moves, this.errorMessage})
    : orientation = Side.white,
      boardParams = GameBoardParams.emptyBoard,
      controllerParams = null,
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
      moveListBuilder = null,
      boardOverlay = null,
      boardKey = null,
      zenMode = false,
      userActionsBar = null,
      explosionSquares = null,
      isReplaying = false,
      onPremove = null;

  /// Board parameters for the owned-controller path: [GameLayout] creates and
  /// drives the controller from these, updating it in [didUpdateWidget].
  ///
  /// Null in the [controllerParams] (high-performance) path.
  final GameBoardParams? boardParams;

  /// Board parameters for the high-performance path: the caller owns the
  /// [ChessboardController] and drives it directly. [GameLayout] renders the
  /// board with it but never creates, disposes, or drives it, and does no
  /// position work in [didUpdateWidget].
  ///
  /// Null in the [boardParams] (owned-controller) path.
  final ControllerBoardParams? controllerParams;

  final Side orientation;

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

  /// Optional builder for a self-watching move list (high-performance path).
  ///
  /// When provided, it takes precedence over [moves]/[currentMoveIndex]/[onSelectMove]
  /// and is responsible for rendering a [MoveList] of the requested [MoveListType].
  /// This lets the caller drive the move list from its own provider so that move
  /// updates do not force [GameLayout] to rebuild.
  final Widget Function(MoveListType type)? moveListBuilder;

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
  /// When true, position changes animate and clear the premove (e.g. analysis navigation).
  final bool isReplaying;

  /// Called when a premove is ready to be executed after the opponent moves.
  final void Function(Move)? onPremove;

  @override
  ConsumerState<GameLayout> createState() => _GameLayoutState();
}

class _GameLayoutState extends ConsumerState<GameLayout> {
  /// The controller created and owned by this state, used only in the
  /// [GameBoardParams] path. Null in the [ControllerBoardParams] path.
  ChessboardController? _ownController;

  /// The controller actually rendered by the board: the externally owned one if
  /// provided, otherwise the one we created.
  ChessboardController? get _controller => widget.controllerParams?.controller ?? _ownController;

  @override
  void initState() {
    super.initState();
    if (widget.controllerParams == null) {
      _initController();
    }
    _controller?.premoveNotifier.addListener(_onPremoveChanged);
  }

  @override
  void dispose() {
    _controller?.premoveNotifier.removeListener(_onPremoveChanged);
    _ownController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(GameLayout old) {
    super.didUpdateWidget(old);

    // If the externally owned controller instance changed, move the premove
    // listener from the old controller to the new one.
    final oldController = old.controllerParams?.controller ?? _ownController;
    if (oldController != _controller) {
      oldController?.premoveNotifier.removeListener(_onPremoveChanged);
      _controller?.premoveNotifier.addListener(_onPremoveChanged);
    }

    // External-controller path: the owner drives position updates.
    if (widget.controllerParams != null) return;

    final ctrl = _ownController;
    if (ctrl == null) return;

    final newParams = widget.boardParams!;
    final newFen = newParams.fen;
    final fenChanged = old.boardParams?.fen != newFen;
    final newGameData = _gameDataFor(newParams);

    if (!fenChanged) {
      // Only game metadata changed (e.g. playerSide, validMoves) — update without animation.
      ctrl.updatePosition(newGameData);
      return;
    }

    if (widget.isReplaying) {
      ctrl.updatePosition(newGameData, resetPremove: true);
      return;
    }

    // A revert (e.g. takeback) rolls the line back to a lower ply. A premove
    // must never be played in that case — clear it instead.
    final oldParams = old.boardParams;
    final isRevert =
        newParams is InteractiveBoardParams &&
        oldParams is InteractiveBoardParams &&
        newParams.position.ply < oldParams.position.ply;
    if (isRevert) {
      ctrl.updatePosition(newGameData, resetPremove: true);
      return;
    }

    ctrl.updatePosition(newGameData);
    if (widget.explosionSquares != null) {
      ctrl.triggerExplosion(widget.explosionSquares!);
    }
    if (newParams is InteractiveBoardParams) {
      final onPremove = widget.onPremove;
      if (onPremove != null) {
        tryExecutePremove(ctrl, newParams.position, onPremove);
      }
    }
  }

  void _initController() {
    final params = widget.boardParams;
    if (params == null) return;
    _ownController = ChessboardController(game: _gameDataFor(params));
  }

  void _onPremoveChanged() {
    if (mounted) setState(() {});
  }

  /// Whether a move list can be rendered (either inline moves or a builder).
  bool get _hasMoveList => widget.moves != null || widget.moveListBuilder != null;

  /// Builds the move list content for [type], using the [GameLayout.moveListBuilder]
  /// when provided, otherwise the inline [GameLayout.moves]. Must only be called
  /// when [_hasMoveList] is true. Does not apply zen-mode handling — callers do.
  Widget _moveListContent(MoveListType type) {
    final builder = widget.moveListBuilder;
    if (builder != null) return builder(type);
    return MoveList(
      type: type,
      slicedMoves: widget.moves!.asMap().entries.slices(2),
      currentMoveIndex: widget.currentMoveIndex,
      onSelectMove: widget.onSelectMove,
    );
  }

  /// Builds the [GameData] driving the owned controller.
  ///
  /// Readonly boards are still controller-backed; they are made non-interactive
  /// by using [PlayerSide.none] (so the user cannot move) with no valid moves.
  GameData _gameDataFor(GameBoardParams params) {
    final boardPrefs = ref.read(boardPreferencesProvider);
    return switch (params) {
      InteractiveBoardParams(:final variant, :final position, :final playerSide, :final lastMove) =>
        buildGameData(
          fen: position.fen,
          variant: variant,
          position: position,
          playerSide: playerSide,
          lastMove: lastMove,
          castlingMethod: boardPrefs.castlingMethod,
          boardHighlights: boardPrefs.boardHighlights,
        ),
      ReadonlyBoardParams(:final fen, :final lastMove) => GameData(
        fen: fen,
        playerSide: PlayerSide.none,
        sideToMove: _sideToMoveFromFen(fen),
        validMoves: const <Square, Set<Square>>{},
        lastMove: lastMove,
      ),
    };
  }

  Side _sideToMoveFromFen(String fen) {
    final parts = fen.split(' ');
    return parts.length > 1 && parts[1] == 'b' ? Side.black : Side.white;
  }

  @override
  Widget build(BuildContext context) {
    final boardPrefs = ref.watch(boardPreferencesProvider);

    // Board info needed for the layout, derived from whichever path is active.
    // In the controller path, playerSide/sideToMove come from the controller's
    // game data; in the owned path they come from the board params.
    final cp = widget.controllerParams;
    final variant = cp?.variant ?? widget.boardParams!.variant;
    final pockets = cp != null ? cp.pockets : widget.boardParams!.pockets;
    final playerSide = cp != null
        ? (_controller?.game.playerSide ?? PlayerSide.none)
        : widget.boardParams!.playerSide;
    final sideToMove = cp != null
        ? (playerSide == PlayerSide.none ? null : _controller?.game.sideToMove)
        : switch (widget.boardParams!) {
            ReadonlyBoardParams() => null,
            InteractiveBoardParams(:final position, :final playerSide) =>
              playerSide == PlayerSide.none ? null : position.turn,
          };
    final void Function(Move, {bool? viaDragAndDrop})? rawOnMove = cp != null
        ? cp.onMove
        : switch (widget.boardParams!) {
            InteractiveBoardParams(:final onMove) => onMove,
            _ => null,
          };

    return LayoutBuilder(
      builder: (context, constraints) {
        final orientation = constraints.maxWidth > constraints.maxHeight
            ? Orientation.landscape
            : Orientation.portrait;
        final isTablet = isTabletOrLarger(context);

        final defaultSettings = boardPrefs
            .toBoardSettings(variant)
            .copyWith(
              borderRadius: isTablet ? Styles.boardBorderRadius : BorderRadius.zero,
              boxShadow: isTablet ? boardShadows : const <BoxShadow>[],
            );

        final settings = widget.boardSettingsOverrides != null
            ? widget.boardSettingsOverrides!.merge(defaultSettings)
            : defaultSettings;

        final shapes = widget.shapes?.unlock ?? const <Shape>{};

        final premoveDropRole = switch (_controller?.premove) {
          DropMove(:final role) => role,
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
                  playerSide: playerSide,
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
                  playerSide: playerSide,
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
                  controller: _controller!,
                  onMove: rawOnMove,
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
                      if (boardPrefs.moveListDisplay && !widget.zenMode && _hasMoveList)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: _moveListContent(MoveListType.stacked),
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
                  _hasMoveList &&
                  !isShortScreen &&
                  !(isTablet && pockets != null))
                if (widget.zenMode)
                  // display empty move list to keep the layout consistent in zen mode
                  const MoveList(type: MoveListType.inline, slicedMoves: [], currentMoveIndex: 0)
                else
                  _moveListContent(MoveListType.inline),
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
                  controller: _controller!,
                  onMove: rawOnMove,
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
