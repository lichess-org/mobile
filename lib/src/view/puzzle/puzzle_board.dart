import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_controller.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/service/puzzle_service.dart';
import 'package:lichess_mobile/src/widgets/board.dart';
import 'package:material_ui/material_ui.dart';

/// The board of a puzzle screen, driven by the [PuzzleController] of [initialPuzzleContext].
///
/// Owns the [ChessboardController] and keeps it in sync with the puzzle state and the board
/// preferences without rebuilding the board, and plays a premove once the opponent has replied.
/// Give it a [GlobalKey] when the layout can move it around, so that the board state survives.
class const PuzzleBoard({
  required final PuzzleContext initialPuzzleContext,
  required final double size,
  required final Side orientation,
  required final ChessboardSettings settings,

  /// External shapes to draw on the board (e.g. the hint circle).
  final Set<Shape> shapes = const {},
  super.key,
}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<PuzzleBoard> createState() => _PuzzleBoardState();
}

class _PuzzleBoardState() extends ConsumerState<PuzzleBoard> {
  late final ChessboardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ChessboardController(game: _buildGameData());
  }

  @override
  void didUpdateWidget(PuzzleBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The streak feeds new puzzles by swapping the puzzle context (and thus the controller
    // provider), so push the new puzzle onto the board.
    if (oldWidget.initialPuzzleContext != widget.initialPuzzleContext) {
      _applyBoardUpdate(resetPremove: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  PlayerSide _playerSide(PuzzleState state) {
    return state.mode == PuzzleMode.load ||
            state.currentPosition.isGameOver ||
            (state.mode == PuzzleMode.play && state.canGoNext)
        ? PlayerSide.none
        : state.mode == PuzzleMode.view
        ? PlayerSide.both
        : state.pov == Side.white
        ? PlayerSide.white
        : PlayerSide.black;
  }

  GameData _buildGameData() {
    final state = ref.read(puzzleControllerProvider(widget.initialPuzzleContext));
    final boardPreferences = ref.read(boardPreferencesProvider);
    return buildGameData(
      fen: state.currentPosition.fen,
      variant: Variant.standard,
      position: state.currentPosition,
      playerSide: _playerSide(state),
      lastMove: state.lastMove,
      castlingMethod: boardPreferences.castlingMethod,
      boardHighlights: boardPreferences.boardHighlights,
    );
  }

  /// Pushes the latest puzzle position to the board controller without rebuilding it.
  void _applyBoardUpdate({bool resetPremove = false}) {
    _controller.updatePosition(_buildGameData(), resetPremove: resetPremove);
  }

  /// Plays the queued premove, if any, once the opponent has replied and it is the user's turn.
  void _tryExecutePremove() {
    final ctrlProvider = puzzleControllerProvider(widget.initialPuzzleContext);
    final state = ref.read(ctrlProvider);
    if (state.mode != PuzzleMode.play || state.currentPosition.turn != state.pov) return;
    tryExecutePremove(
      _controller,
      state.currentPosition,
      (move) => ref.read(ctrlProvider.notifier).onUserMove(move),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrlProvider = puzzleControllerProvider(widget.initialPuzzleContext);

    // Drive the board on position/interactivity changes without rebuilding it.
    ref.listen(
      ctrlProvider.select(
        (s) => (
          puzzleId: s.puzzle.puzzle.id,
          fen: s.currentPosition.fen,
          lastMoveUci: s.lastMove?.uci,
          side: _playerSide(s),
          ply: s.currentPosition.ply,
        ),
      ),
      (previous, next) {
        // A forward ply in the same puzzle is a new move (ours or the reply): keep the premove and
        // try it. Anything else (takeback, solution, history, next puzzle) clears it.
        final isForwardMove =
            previous != null && previous.puzzleId == next.puzzleId && next.ply > previous.ply;
        _applyBoardUpdate(resetPremove: !isForwardMove);
        if (isForwardMove) _tryExecutePremove();
      },
    );
    ref.listen(
      boardPreferencesProvider.select((p) => (p.castlingMethod, p.boardHighlights)),
      (_, _) => _applyBoardUpdate(),
    );

    // Clear drawn shapes when puzzle or position changes.
    ref.listen(ctrlProvider.select((state) => state.puzzle.puzzle.id), (previous, next) {
      if (previous != null && previous != next) {
        _controller.clearDrawnShapes();
      }
    });
    ref.listen(ctrlProvider.select((state) => state.currentPath), (previous, next) {
      if (previous != null && previous != next) {
        _controller.clearDrawnShapes();
      }
    });

    return BoardWidget(
      size: widget.size,
      controller: _controller,
      onMove: (move, {viaDragAndDrop}) {
        ref.read(ctrlProvider.notifier).onUserMove(move);
      },
      orientation: widget.orientation,
      shapes: widget.shapes,
      settings: widget.settings,
    );
  }
}
