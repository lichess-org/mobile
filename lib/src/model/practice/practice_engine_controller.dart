import 'dart:async';
import 'dart:math' as math;

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/engine/engine_budget.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_context.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/position_evaluator.dart';
import 'package:lichess_mobile/src/model/engine/practice_analyser.dart';
import 'package:lichess_mobile/src/model/engine/practice_comment.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/model/practice/practice_goal.dart';
import 'package:lichess_mobile/src/model/practice/practice_progress.dart';
import 'package:lichess_mobile/src/model/practice/practice_structure.dart';
import 'package:logging/logging.dart';

part 'practice_engine_controller.freezed.dart';

final _logger = Logger('PracticeEngineController');

/// How long the engine may take to answer a move, including judging it.
///
/// The search itself stops at [kPracticeMaxSearchTime]; this only has to outlast it, so that the
/// engine's own limit is what ends the wait.
final _kEngineAnswerWait = kPracticeMaxSearchTime + const Duration(seconds: 1);

/// A practice chapter played against the engine.
final practiceEngineControllerProvider = NotifierProvider.autoDispose
    .family<PracticeEngineController, PracticeEngineState, PracticeEngineChapter>(
      PracticeEngineController.new,
      name: 'PracticeEngineControllerProvider',
    );

/// Plays a practice chapter against the engine.
///
/// One analysis serves everything. It runs on the position the player is thinking about, for the
/// hint. Once the player has moved, it runs on the position the move led to: that eval both judges
/// the move, against the eval of the position before, and gives the opponent its move, which is
/// the engine's best move rather than a levelled one.
///
/// Always on Stockfish with its small built-in net, whatever the user's preference.
class PracticeEngineController(final PracticeEngineChapter _chapter)
    extends Notifier<PracticeEngineState> {
  ProviderSubscription<EngineEvaluationState>? _evaluatorSubscription;

  late final PracticeAnalyser _analyser = PracticeAnalyser(
    evaluator: () => _evaluator,
    onEval: _onEval,
  );

  /// Bumped on [retry], so that a move still being answered for the previous attempt is dropped.
  int _attempt = 0;

  late final EvaluationContext _evaluationContext = EvaluationContext(
    id: StringId('practice-${_chapter.id}'),
    variant: Variant.standard,
    initialPosition: _initialPosition,
    enginePref: ChessEnginePref.sfLight,
  );

  late final Position _initialPosition = Chess.fromSetup(Setup.parseFen(_chapter.fen));

  PositionEvaluator get _evaluator {
    final provider = positionEvaluatorProvider(_evaluationContext);
    _evaluatorSubscription ??= ref.listen(provider, (previous, next) {
      // The engine has stopped searching. It may have run out of its search time before saying
      // anything usable about the position — on a slow device the first search can be spent
      // starting the engine — and nothing else would ever start it again.
      if (previous?.isComputing == true && !next.isComputing) {
        _analyser.resumeIfUnfinished();
      }
    });
    return ref.read(provider.notifier);
  }

  @override
  PracticeEngineState build() {
    ref.onDispose(() {
      _analyser.dispose();
      _evaluatorSubscription?.close();
    });
    scheduleMicrotask(_start);
    return PracticeEngineState.initial(_chapter, _initialPosition);
  }

  /// Plays [move] for the player, then the engine's answer unless the move ended the chapter.
  Future<void> onUserMove(NormalMove move) async {
    if (!state.canPlay || !state.position.isLegal(move)) return;

    final attempt = _attempt;
    final positionBefore = state.position;
    final evalBefore = _analyser.evalFor(positionBefore);

    _play(move);
    state = state.copyWith(isEngineThinking: true);

    if (state.position.isGameOver) {
      _judge(eval: null, verdict: null);
      return;
    }

    _analyse();
    // At least as deep as the eval this move is about to be compared against. The position the
    // player was thinking about was analysed for as long as they thought, up to
    // [kPracticeTargetDepth]; the position their move led to has only just been started. Comparing
    // the two would measure the difference in depth as much as the move — an eval drifts by a
    // pawn or more between depth 13 and depth 20 — and a shift large enough to read as a mistake
    // or a blunder fails the chapter outright.
    final evalAfter = await _analyser.usableEval(
      state.position,
      timeout: _kEngineAnswerWait,
      minDepth: math.min(
        math.max(kPracticeUsableDepth, evalBefore?.depth ?? 0),
        kPracticeTargetDepth,
      ),
    );
    if (!ref.mounted || attempt != _attempt) return;

    // Still shallower, because the search ran out of time: no verdict at all is better than one
    // that measures depth. The goal is judged on it all the same — that compares the eval with a
    // target rather than with another eval.
    final feedback = evalBefore != null && evalAfter != null && evalAfter.depth >= evalBefore.depth
        ? _feedback(move, positionBefore, evalBefore, evalAfter)
        : null;
    state = state.copyWith(feedback: feedback);
    _judge(eval: evalAfter, verdict: feedback?.verdict);
    if (state.status != .ongoing) return;

    final answer = evalAfter?.bestMove;
    if (answer == null) {
      _logger.warning('No move from the engine at ply ${state.position.ply}');
      state = state.copyWith(isEngineThinking: false);
      return;
    }
    _playEngineMove(answer);
  }

  /// Shows the piece to move, then the move, then hides the hint again.
  void hint() {
    if (!state.canPlay) return;
    final best = _usableBestMove(state.position);
    if (best == null) return;
    state = state.copyWith(
      hint: switch (state.hint) {
        null => PracticeHint.piece(best.from),
        PracticeHintPiece() => PracticeHint.move(best),
        PracticeHintMove() => null,
      },
    );
  }

  /// Starts the chapter over from its initial position.
  void retry() {
    _attempt++;
    _analyser.yieldEngine();
    state = PracticeEngineState.initial(_chapter, _initialPosition);
    _start();
  }

  /// Stops the analysis while the chapter is out of sight, so that it does not drain the battery.
  void suspendAnalysis() {
    if (!ref.mounted) return;
    _analyser.yieldEngine();
  }

  /// Analyses the position the chapter is at again, when it comes back into view.
  void resumeAnalysis() {
    if (!ref.mounted || state.status != .ongoing) return;
    if (state.isPlayerTurn) _analyse();
  }

  /// Starts the chapter: the player thinks, or the engine moves first in the few chapters that
  /// start with the opponent to move.
  Future<void> _start() async {
    if (!ref.mounted) return;
    _analyse();
    if (state.isPlayerTurn) return;

    final attempt = _attempt;
    state = state.copyWith(isEngineThinking: true);
    final eval = await _analyser.usableEval(state.position, timeout: _kEngineAnswerWait);
    if (!ref.mounted || attempt != _attempt) return;

    final move = eval?.bestMove;
    if (move == null) {
      _logger.warning('No first move from the engine for chapter ${_chapter.id}');
      state = state.copyWith(isEngineThinking: false);
      return;
    }
    _playEngineMove(move);
  }

  void _playEngineMove(Move move) {
    _play(move);
    // The engine's move is judged on the outcome and repetition only: it has no verdict, and the
    // eval that matters was the one the player's move was judged on.
    _judge(eval: null, verdict: null);
    if (state.status != .ongoing) return;
    state = state.copyWith(isEngineThinking: false);
    _analyse();
  }

  /// Adds [move] to the moves played.
  void _play(Move move) {
    final (position, san) = state.position.makeSan(move);
    state = state.copyWith(
      steps: state.steps.add(Step(position: position, sanMove: SanMove(san, move))),
      hint: null,
    );
    ref.read(moveFeedbackServiceProvider).playedMove(san);
  }

  /// Judges the chapter as it stands, and ends it when that is decided.
  ///
  /// A game over that the goal does not decide, such as a dead draw in a chapter to mate, is a
  /// failure: nothing more can be played to reach it.
  void _judge({required ClientEval? eval, required MoveVerdict? verdict}) {
    final judged = _chapter.goal.judge(
      playerSide: state.playerSide,
      position: state.position,
      lastMove: state.steps.lastOrNull?.sanMove.move,
      eval: eval,
      verdict: verdict,
      nbMoves: state.nbMoves,
      threefold: state.isThreefoldRepetition,
    );
    final status = judged == .ongoing && state.position.isGameOver ? PracticeStatus.failed : judged;
    if (status == .ongoing) return;

    _analyser.yieldEngine();
    state = state.copyWith(status: status, isEngineThinking: false);
    if (status == .solved) {
      ref.read(practiceProgressProvider.notifier).complete(_chapter.id, state.nbMoves);
    }
  }

  /// Judges [move] by how much it changed the player's winning chances.
  PracticeMoveFeedback _feedback(
    NormalMove move,
    Position positionBefore,
    ClientEval evalBefore,
    ClientEval evalAfter,
  ) {
    final side = state.playerSide;
    final winningChancesBefore = evalBefore.winningChances(side);
    final winningChancesAfter = evalAfter.winningChances(side);
    final best = evalBefore.bestMove;
    final isBest = best == null || normalizeUci(best.uci) == normalizeUci(move.uci);

    final verdict = MoveVerdict.fromShift(
      winningChancesBefore - winningChancesAfter,
      hasBetterMove: !isBest,
      winningChancesBefore: winningChancesBefore,
      winningChancesAfter: winningChancesAfter,
    );

    final showBest = !isBest && verdict != .goodMove && positionBefore.isLegal(best);
    return PracticeMoveFeedback(
      verdict: verdict,
      bestMove: showBest ? SanMove(positionBefore.makeSan(best).$2, best) : null,
    );
  }

  /// The best move for [position], once the analysis is deep enough to show it.
  NormalMove? _usableBestMove(Position position) => switch (_analyser.evalFor(position)) {
    ClientEval(:final depth, bestMove: final NormalMove best) when depth >= kPracticeUsableDepth =>
      best,
    _ => null,
  };

  void _analyse() {
    _analyser.analyse(
      EvalWork(
        id: _evaluationContext.id,
        variant: Variant.standard,
        threads: ref.read(engineBudgetProvider).offlineEvalThreads,
        searchTime: kPracticeMaxSearchTime,
        // One line: only the best move is ever used, and a single line is the fastest to depth.
        multiPv: 1,
        threatMode: false,
        initialPosition: _initialPosition,
        steps: state.steps,
      ),
    );
  }

  void _onEval(Position position, ClientEval eval) {
    if (!ref.mounted || position != state.position) return;
    state = state.copyWith(
      eval: eval,
      // A deeper search may have changed its mind about the move the hint shows.
      hint: switch ((state.hint, _usableBestMove(position))) {
        (PracticeHintPiece(), NormalMove(:final from)) => PracticeHint.piece(from),
        (PracticeHintMove(), final NormalMove best) => PracticeHint.move(best),
        (final hint, _) => hint,
      },
    );
  }
}

@freezed
sealed class const PracticeEngineState._() with _$PracticeEngineState {
  const factory({
    required PracticeEngineChapter chapter,
    required Position initialPosition,

    /// The moves played since [initialPosition], by both sides.
    required IList<Step> steps,
    required PracticeStatus status,

    /// Whether the engine is answering the player's move, or making the first move.
    required bool isEngineThinking,

    /// The verdict on the player's last move, once it has been judged.
    PracticeMoveFeedback? feedback,

    /// The hint shown for the position the player is thinking about.
    PracticeHint? hint,

    /// The best evaluation so far of [position].
    ClientEval? eval,
  }) = _PracticeEngineState;

  factory initial(PracticeEngineChapter chapter, Position initialPosition) => PracticeEngineState(
    chapter: chapter,
    initialPosition: initialPosition,
    steps: const IListConst([]),
    status: .ongoing,
    isEngineThinking: false,
  );

  Position get position => steps.lastOrNull?.position ?? initialPosition;

  Side get playerSide => chapter.orientation;

  bool get isPlayerTurn => position.turn == playerSide;

  /// Whether the player can move now.
  bool get canPlay => status == .ongoing && isPlayerTurn && !isEngineThinking;

  /// The number of moves the player has played, which the goal counts.
  int get nbMoves => steps.where((step) => step.position.turn != playerSide).length;

  /// Whether [position] has occurred three times, counting the initial position.
  bool get isThreefoldRepetition {
    String key(Position position) => position.fen.split(' ').take(4).join(' ');
    final current = key(position);
    final positions = [initialPosition, ...steps.map((step) => step.position)];
    return positions.where((p) => key(p) == current).length >= 3;
  }
}

/// The verdict on a move the player made.
@freezed
sealed class const PracticeMoveFeedback._() with _$PracticeMoveFeedback {
  const factory({
    required MoveVerdict verdict,

    /// The move that was better, when the one played was not good enough.
    SanMove? bestMove,
  }) = _PracticeMoveFeedback;
}

/// A hint on the move to play, revealed in two steps.
@freezed
sealed class const PracticeHint._() with _$PracticeHint {
  /// The piece to move, from the square it stands on.
  const factory piece(Square square) = PracticeHintPiece;

  /// The whole move.
  const factory move(NormalMove move) = PracticeHintMove;
}
