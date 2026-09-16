import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/practice/practice_progress.dart';
import 'package:lichess_mobile/src/model/practice/practice_structure.dart';

part 'practice_gamebook_controller.freezed.dart';

/// How long an uncommented opponent move waits before it is played.
const kGamebookOpponentMoveDelay = Duration(milliseconds: 1000);

/// How long the opponent waits to play first, when the chapter starts with its move.
const kGamebookFirstMoveDelay = Duration(milliseconds: 300);

/// How long an uncommented wrong move stays on the board before it is taken back.
const kGamebookRetryDelay = Duration(milliseconds: 800);

/// A practice gamebook chapter being played.
final practiceGamebookControllerProvider = NotifierProvider.autoDispose
    .family<PracticeGamebookController, PracticeGamebookState, PracticeGamebookChapter>(
      PracticeGamebookController.new,
      name: 'PracticeGamebookControllerProvider',
    );

/// Plays a gamebook chapter: the player finds the authored moves, one at a time.
///
/// The authored opponent moves play themselves unless there is a comment to read first, a wrong
/// move is taken back the same way, and reaching the end of the mainline completes the chapter.
class PracticeGamebookController(final PracticeGamebookChapter _chapter)
    extends Notifier<PracticeGamebookState> {
  Timer? _autoPlay;

  @override
  PracticeGamebookState build() {
    ref.onDispose(() => _autoPlay?.cancel());
    final game = PgnGame.parsePgn(_chapter.pgn);
    final root = Root.fromPgnGame(game).view;
    scheduleMicrotask(_onChange);
    return PracticeGamebookState(
      chapter: _chapter,
      root: root,
      rootComments: game.comments.map(PgnComment.fromPgn).toIList(),
      mainline: root.mainline.toIList(),
      ply: 0,
    );
  }

  /// Plays [move] for the player: the next authored move, or a wrong one to be taken back.
  void onUserMove(NormalMove move) {
    if (state.feedback != .play || !state.position.isLegal(move)) return;

    final position = state.position.play(move);
    // Compared by position, which castling notations cannot tell apart.
    final authored = state.node.children.firstWhereOrNull((child) => child.position == position);
    // The first child is the mainline: the others are wrong moves the author anticipated.
    if (authored != null && identical(authored, state.node.children.first)) {
      _update(state.copyWith(ply: state.ply + 1));
    } else {
      _update(
        state.copyWith(
          wrongMove: PracticeGamebookWrongMove(
            sanMove: SanMove(state.position.makeSan(move).$2, move),
            position: position,
            comments: authored?.comments ?? const IListConst([]),
          ),
        ),
      );
    }
  }

  /// Moves on: plays the opponent's authored move, or takes back a wrong move.
  void next() {
    switch (state.feedback) {
      case .good:
        _update(state.copyWith(ply: state.ply + 1));
      case .bad:
        retry();
      case .play || .end:
        break;
    }
  }

  /// Takes back the wrong move, to try again.
  void retry() {
    if (state.wrongMove == null) return;
    _update(state.copyWith(wrongMove: null));
  }

  /// Starts the chapter over.
  void restart() => _update(state.copyWith(ply: 0, wrongMove: null));

  void toggleHint() {
    if (state.hint == null) return;
    state = state.copyWith(isHintShown: !state.isHintShown);
  }

  /// Shows or hides the move to play, as an arrow.
  void toggleSolution() {
    if (state.feedback != .play) return;
    state = state.copyWith(isSolutionShown: !state.isSolutionShown);
  }

  void _update(PracticeGamebookState newState) {
    state = newState.copyWith(isHintShown: false, isSolutionShown: false);
    _onChange();
  }

  /// Plays what follows on its own, and completes the chapter at the end of the mainline.
  void _onChange() {
    if (!ref.mounted) return;
    _autoPlay?.cancel();

    switch (state.feedback) {
      case .end:
        ref.read(practiceProgressProvider.notifier).complete(_chapter.id, state.nbMoves);
      // A comment is there to be read: moving on waits for the player.
      case .good when state.comment == null:
        final delay = state.ply == 0 ? kGamebookFirstMoveDelay : kGamebookOpponentMoveDelay;
        _autoPlay = Timer(delay, next);
      case .bad when state.comment == null:
        _autoPlay = Timer(kGamebookRetryDelay, retry);
      case _:
        break;
    }
  }
}

/// Where the player stands in a gamebook, as lichess.org names it.
enum PracticeGamebookFeedback() {
  /// The player has to find the next move.
  play,

  /// The player's move was right, or the chapter starts with the opponent: the opponent plays
  /// next.
  good,

  /// The player's move was wrong, and is to be taken back.
  bad,

  /// The mainline is over: the chapter is complete.
  end,
}

@freezed
sealed class const PracticeGamebookState._() with _$PracticeGamebookState {
  const factory({
    required PracticeGamebookChapter chapter,

    /// The authored tree.
    required ViewRoot root,

    /// The comments before the first move.
    required IList<PgnComment> rootComments,

    /// The authored moves to find, and the opponent's answers.
    required IList<ViewBranch> mainline,

    /// How far along [mainline] the player is.
    required int ply,

    /// The move the player just played, if it was not the authored one.
    PracticeGamebookWrongMove? wrongMove,
    @Default(false) bool isHintShown,
    @Default(false) bool isSolutionShown,
  }) = _PracticeGamebookState;

  /// The node of [mainline] the player is at.
  ViewNode get node => ply == 0 ? root : mainline[ply - 1];

  /// The position on the board, the wrong move included.
  Position get position => wrongMove?.position ?? node.position;

  /// The last move on the board, the wrong move included.
  Move? get lastMove => wrongMove?.sanMove.move ?? node.sanMove?.move;

  PracticeGamebookFeedback get feedback {
    if (wrongMove != null) return .bad;
    if (ply == mainline.length) return .end;
    return node.position.turn == chapter.orientation ? .play : .good;
  }

  /// The comment to show: the author's on the current move, or on why a wrong move is wrong.
  String? get comment {
    final authored = _currentComments.map((comment) => comment.text).nonNulls.join('\n');
    if (authored.isNotEmpty) return authored;
    if (wrongMove == null) return null;
    // A deviation comment is kept on the authored move the wrong one was played instead of.
    return chapter.deviations.elementAtOrNull(ply + 1);
  }

  /// The hint for the move to find, if the author wrote one.
  String? get hint => feedback == .play ? chapter.hints.elementAtOrNull(ply) : null;

  /// The move to find, when the solution is shown.
  Move? get solution => isSolutionShown && feedback == .play ? mainline[ply].sanMove.move : null;

  /// The shapes the author drew for the current move.
  IList<PgnCommentShape> get shapes =>
      _currentComments.expand((comment) => comment.shapes).toIList();

  /// The number of authored moves the player has found.
  int get nbMoves =>
      mainline.take(ply).where((branch) => branch.position.turn != chapter.orientation).length;

  /// The author's comments on what is on the board.
  Iterable<PgnComment> get _currentComments =>
      wrongMove?.comments ?? (ply == 0 ? rootComments : node.comments) ?? const [];
}

/// A move the player played instead of the authored one.
@freezed
sealed class const PracticeGamebookWrongMove._() with _$PracticeGamebookWrongMove {
  const factory({
    required SanMove sanMove,
    required Position position,

    /// The author's comments, when the move is one they anticipated as a variation.
    required IList<PgnComment> comments,
  }) = _PracticeGamebookWrongMove;
}
