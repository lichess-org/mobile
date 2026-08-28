import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/chess960.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/engine_budget.dart';
import 'package:lichess_mobile/src/model/engine/engine_opponent.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_context.dart';
import 'package:lichess_mobile/src/model/engine/position_evaluator.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/model/explorer/opening_explorer.dart';
import 'package:lichess_mobile/src/model/explorer/opening_explorer_preferences.dart';
import 'package:lichess_mobile/src/model/explorer/opening_explorer_repository.dart';
import 'package:lichess_mobile/src/model/explorer/tablebase.dart';
import 'package:lichess_mobile/src/model/explorer/tablebase_repository.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';
import 'package:lichess_mobile/src/model/game/offline_computer_game.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/offline_computer/computer_analysis.dart';
import 'package:lichess_mobile/src/model/offline_computer/offline_computer_game_storage.dart';
import 'package:lichess_mobile/src/model/offline_computer/practice_analyser.dart';
import 'package:lichess_mobile/src/model/offline_computer/practice_comment.dart';
import 'package:lichess_mobile/src/model/offline_computer/tablebase_eval.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:logging/logging.dart';

part 'offline_computer_game_controller.freezed.dart';

final _random = Random();

final _logger = Logger('OfflineComputerGameController');

/// Ply threshold for opening phase. Below this, we check the master database
/// to consider book moves as good regardless of engine evaluation.
const _kOpeningPlyThreshold = 30;

/// How long the player's move waits for the analysis of the position it was played in.
///
/// The analysis has normally been running for as long as the player was thinking, so this only
/// bites when the move came faster than the search did.
const _kPreMoveEvalWait = Duration(seconds: 4);

/// How long the hints wait to become available before the spinner gives up.
final _kHintWait = kPracticeMaxSearchTime + const Duration(seconds: 1);

/// Max search time for a move evaluation in practice mode when the move is not in the pre-move PVs.
///
/// We want a fast feedback here, and since multipv=1 the search should be fast.
const _kMoveEvalMaxSearchTime = Duration(milliseconds: 2000);

/// How long the verdict on such a move waits for that evaluation.
///
/// The search's own [_kMoveEvalMaxSearchTime] limit is what actually ends it; this only has to
/// outlast that, so that giving up is the engine's decision and not a race between two clocks.
final _kMoveEvalWait = _kMoveEvalMaxSearchTime + const Duration(seconds: 1);

/// Extra breathing room after the configured piece animation before starting local engine work.
const _kEngineMoveAnimationBuffer = Duration(milliseconds: 50);

/// Depth threshold for using an engine evaluation for move evaluation in practice mode.
///
/// The search is done with multipv=1 here, so we can reach higher depths.
const _kMoveEvalMinDepth = kDebugMode ? 14 : 18;

final offlineComputerGameControllerProvider =
    NotifierProvider.autoDispose<OfflineComputerGameController, OfflineComputerGameState>(
      OfflineComputerGameController.new,
      name: 'OfflineComputerGameControllerProvider',
    );

class OfflineComputerGameController extends Notifier<OfflineComputerGameState> {
  late SocketClient socketClient;
  StreamSubscription<SocketEvent>? _socketSubscription;

  /// What keeps the evaluator and the opponent — and through them, their engines — alive.
  ///
  /// Acquired lazily rather than watched in [build], because both are keyed by something that
  /// only exists once the state does: the game being played, and the level it is played at.
  ProviderSubscription<EngineEvaluationState>? _evaluatorSubscription;
  EvaluationContext? _evaluatorContext;
  ProviderSubscription<EngineOpponent>? _opponentSubscription;
  OpponentSpec? _opponentSpec;

  /// Stops whatever the engines are doing for this game: the opponent's search, and any hint or
  /// move evaluation in flight.
  void _stopThinking() {
    _opponent.stop();
    _analyser.yieldEngine();
    _evaluator.stop();
  }

  /// How this device's engines share it.
  EngineBudget get _budget => ref.read(engineBudgetProvider);

  /// Whether the evaluator and the opponent are the same engine, and so must be asked for the
  /// same options.
  ///
  /// True on every variant Stockfish cannot play: Fairy-Stockfish is then both the only engine
  /// that can evaluate the position and the one the opponent plays on, and the same [EngineSpec]
  /// is the same [Engine]. False when this game never evaluates at all — the opponent then has
  /// the engine to itself, and a table sized for hints nobody asks for would be held for nothing.
  bool get _sharesOneEngine {
    if (!state.game.casual && !state.game.practiceMode) return false;
    final variant = state.game.meta.variant;
    return state.game.opponentSpec.engineSpec.slot == evaluatorEngineSlotFor(ref, variant);
  }

  /// What the evaluator asks its engine for, given whether the opponent is on it too.
  EngineShare get _evaluatorShare =>
      _budget.evaluatorShare(sharesEngineWithOpponent: _sharesOneEngine);

  /// The analysis that runs on the position the game is at, for hints and move feedback.
  late final PracticeAnalyser _analyser = PracticeAnalyser(
    evaluator: () => _evaluator,
    onEval: _onAnalysisEval,
  );

  /// Stops the analysis while the game is out of sight.
  ///
  /// The search now runs for as long as the player thinks, so it would otherwise go on burning the
  /// battery under another screen or with the app in the background — which the old one-burst-per-
  /// move model never could. The opponent's search is left alone: it is bounded, and the move it
  /// is about to play is still wanted.
  void suspendAnalysis() {
    // Called from a widget that may be on its way out, and whose provider may already be gone.
    if (!ref.mounted) return;
    _analyser.yieldEngine();
  }

  /// Starts analysing again when the game comes back into view.
  ///
  /// Deliberately not "restart what was suspended": the game may have moved on while the screen was
  /// away, and what is worth analysing is the position it is at now — which [_analyseCurrentPosition]
  /// works out, and which is nothing at all when it is the opponent's turn.
  void resumeAnalysis() {
    if (!ref.mounted) return;
    _analyseCurrentPosition();
  }

  /// Stores an evaluation the analysis has just improved on the step it belongs to.
  void _onAnalysisEval(Position position, ClientEval eval) {
    if (!ref.mounted) return;
    final index = state.game.steps.lastIndexWhere((step) => step.position == position);
    // A takeback may have removed the step while the search was running.
    if (index == -1) return;
    _setStepEval(index, eval);
  }

  EvaluationContext get _evaluationContext => EvaluationContext(
    id: state.game.id,
    variant: state.game.meta.variant,
    initialPosition: state.game.initialPosition,
  );

  PositionEvaluator get _evaluator {
    final context = _evaluationContext;
    if (_evaluatorContext != context) {
      _evaluatorSubscription?.close();
      _evaluatorContext = context;
      _evaluatorSubscription = ref.listen(positionEvaluatorProvider(context), (_, _) {});
    }
    return ref.read(positionEvaluatorProvider(context).notifier);
  }

  EngineOpponent get _opponent {
    final spec = state.game.opponentSpec;
    if (_opponentSpec != spec) {
      _opponentSubscription?.close();
      _opponentSpec = spec;
      _opponentSubscription = ref.listen(engineOpponentProvider(spec), (_, _) {});
    }
    return ref.read(engineOpponentProvider(spec));
  }

  @override
  OfflineComputerGameState build() {
    socketClient = ref.watch(socketPoolProvider).open(AnalysisController.socketUri);
    _socketSubscription?.cancel();
    _socketSubscription = socketClient.stream.listen(_handleSocketEvent);
    ref.onDispose(() {
      _socketSubscription?.cancel();
      _analyser.dispose();
      _evaluatorSubscription?.close();
      _opponentSubscription?.close();
    });
    return OfflineComputerGameState.initial(
      opponentSpec: const StockfishOpponentSpec(StockfishLevel.defaultLevel),
      playerSide: Side.white,
    );
  }

  void startNewGame({
    required OpponentSpec opponentSpec,
    required Side playerSide,
    required bool casual,
    required bool practiceMode,
    Variant variant = Variant.standard,
    String? initialFen,
  }) {
    _analyser.clear();
    state = OfflineComputerGameState.initial(
      opponentSpec: opponentSpec,
      playerSide: playerSide,
      casual: casual,
      practiceMode: practiceMode,
      variant: variant,
      initialFen: initialFen,
    );

    if (state.turn != playerSide) {
      _playEngineMove();
    } else if (casual || practiceMode) {
      _analyseCurrentPosition();
    }
  }

  /// Load a game from storage.
  void loadGame(SavedOfflineComputerGame savedGame) {
    _analyser.clear();
    final game = savedGame.game;
    state = OfflineComputerGameState(game: game, stepCursor: game.steps.length - 1);

    if (game.playable && state.turn == game.playerSide && (game.casual || game.practiceMode)) {
      _analyseCurrentPosition();
    } else if (game.playable && state.turn != game.playerSide) {
      _playEngineMove();
    }
  }

  void makeMove(Move move) {
    if (state.isEngineThinking || state.isEvaluatingMove || !state.game.playable) return;

    if (state.game.practiceMode) {
      _makeMoveWithEvaluation(move);
    } else {
      _applyMove(move);
      if (state.game.playable) {
        _playEngineMoveAfterPlayerAnimation();
      }
    }
  }

  SanMove _applyMove(Move move) {
    final (newPos, newSan) = state.currentPosition.makeSan(Move.parse(move.uci)!);
    final sanMove = SanMove(newSan, move);
    final newStep = GameStep(
      position: newPos,
      sanMove: sanMove,
      diff: MaterialDiff.fromPosition(newPos),
    );

    state = state.copyWith(
      game: state.game.copyWith(steps: state.game.steps.add(newStep)),
      stepCursor: state.stepCursor + 1,
      hintIndex: null,
      // Whatever the analysis was about to unlock, it was for the position before this move.
      isLoadingHint: false,
      showingSuggestedMove: null,
    );

    if (state.game.steps.count((p) => p.position.board == newStep.position.board) == 3) {
      state = state.copyWith(game: state.game.copyWith(isThreefoldRepetition: true));
    } else {
      state = state.copyWith(game: state.game.copyWith(isThreefoldRepetition: false));
    }

    if (state.currentPosition.isCheckmate) {
      state = state.copyWith(
        game: state.game.copyWith(status: GameStatus.mate, winner: state.turn.opposite),
      );
    } else if (state.currentPosition.isVariantEnd) {
      state = state.copyWith(
        game: state.game.copyWith(
          status: GameStatus.variantEnd,
          winner: state.currentPosition.variantOutcome?.winner,
        ),
      );
    } else if (state.currentPosition.isStalemate) {
      state = state.copyWith(game: state.game.copyWith(status: GameStatus.stalemate));
    } else if (state.currentPosition.isInsufficientMaterial) {
      state = state.copyWith(game: state.game.copyWith(status: GameStatus.draw));
    }

    _moveFeedback(sanMove);

    return sanMove;
  }

  /// Make a player move with practice mode evaluation.
  ///
  /// The "before" state is the analysis that has been running on the position the player was
  /// thinking in; the move is judged against it, either from the lines it already holds or, when
  /// the move was not one of them, from an evaluation of the position it leads to.
  ///
  /// In the opening phase (before [_kOpeningPlyThreshold]), also fetches the master
  /// database to consider book moves as good regardless of engine evaluation.
  Future<void> _makeMoveWithEvaluation(Move move) async {
    if (!state.game.practiceMode || !state.game.playable) return;

    final positionBefore = state.currentPosition;
    final plyBeforeMove = positionBefore.ply;

    state = state.copyWith(isEvaluatingMove: true);

    final sanMove = _applyMove(move);

    final stepCursorAfterMove = state.stepCursor;

    if (!state.game.playable) {
      _analyser.yieldEngine();
      state = state.copyWith(isEvaluatingMove: false);
      return;
    }

    // Normally already in hand: the analysis has been running on this position for as long as the
    // player was thinking. It only waits when the move came faster than the search.
    final preMoveEval = await _analyser.usableEval(positionBefore, timeout: _kPreMoveEvalWait);

    if (!ref.mounted) return;

    // Without a pre-move evaluation there is nothing to judge the move against.
    if (preMoveEval == null || preMoveEval.pvs.isEmpty) {
      state = state.copyWith(isEvaluatingMove: false);
      if (state.turn != state.game.playerSide) {
        _playEngineMoveAfterPlayerAnimation();
      }
      return;
    }

    final playerSide = state.game.playerSide;
    final normalizedMoveUci = sanMove.isCastles ? normalizeUci(move.uci) : move.uci;
    final matchingPv = preMoveEval.pvs.firstWhereOrNull(
      (pv) => pv.moves.isNotEmpty && pv.moves.first == normalizedMoveUci,
    );

    // Makes or updates the comment verdict to goodMove if the move is a known book move.
    // The server will reject us unless we are logged in. Only ask then.
    if (ref.read(isLoggedInProvider) &&
        state.game.meta.variant == Variant.standard &&
        plyBeforeMove < _kOpeningPlyThreshold) {
      _makeCommentFromOpeningDb(
        sanMove,
        stepCursor: stepCursorAfterMove,
        positionBefore: positionBefore,
        fromPosition: state.currentPosition,
      );
    }

    // Fast path: move was in the pre-move PVs.
    if (matchingPv != null) {
      final comment = _createPracticeComment(
        sanMove: sanMove,
        preMoveEval: preMoveEval,
        winningChancesAfter: matchingPv.winningChances(playerSide),
        evalAfterString: matchingPv.evalString,
        playerSide: playerSide,
      );

      _setComment(stepCursorAfterMove, comment);
      state = state.copyWith(isEvaluatingMove: false);

      if (state.game.playable && state.turn != state.game.playerSide) {
        _playEngineMoveAfterPlayerAnimation();
      }
      return;
    }

    // Slow path: the move was not one of the analysed lines, so the position it leads to has to be
    // evaluated on its own.
    _logger.info('Move not in computed hints PVs, evaluating: ${move.uci}');

    try {
      final stepsAfter = state.game.steps
          .skip(1)
          .map((s) => Step(position: s.position, sanMove: s.sanMove!))
          .toIList();

      final workAfter = _makeMoveEvalWork(stepsAfter);

      final positionAfterMove = state.currentPosition;

      // The same three sources the analysis always runs against — the engine, a cloud eval, a
      // tablebase lookup — asked for the position the move led to. [PracticeAnalyser.analyse]
      // takes the engine over from whatever it was searching, so no hand-off is needed here.
      _analyser.analyse(workAfter);
      _raceTheSearch(workAfter);

      final evalAfter = await _analyser.usableEval(
        positionAfterMove,
        minDepth: _kMoveEvalMinDepth,
        timeout: _kMoveEvalWait,
      );

      if (!ref.mounted) return;

      if (evalAfter != null) {
        _logger.info(
          'Move eval computed for ply=${workAfter.position.ply} depth=${evalAfter.depth}, searchTime=${evalAfter is LocalEval ? evalAfter.searchTime : null} nodes=${evalAfter.nodes} score=${evalAfter.evalString}',
        );

        final comment = _createPracticeComment(
          sanMove: sanMove,
          preMoveEval: preMoveEval,
          winningChancesAfter: -evalAfter.winningChances(playerSide.opposite),
          evalAfterString: evalAfter.evalString,
          playerSide: playerSide,
        );

        _setComment(stepCursorAfterMove, comment);
      }

      state = state.copyWith(isEvaluatingMove: false);

      if (state.game.playable && state.turn != state.game.playerSide) {
        _playEngineMoveAfterPlayerAnimation();
      }
    } catch (e, st) {
      _logger.warning('Error evaluating move:', e, st);
      if (ref.mounted) {
        state = state.copyWith(isEvaluatingMove: false);
        if (state.game.playable && state.turn != state.game.playerSide) {
          _playEngineMoveAfterPlayerAnimation();
        }
      }
    }
  }

  EvalWork _makeMoveEvalWork(IList<Step> steps) {
    final share = _evaluatorShare;
    return EvalWork(
      id: state.game.id,
      variant: state.game.meta.variant,
      threads: share.threads,
      hashSize: share.hash,
      searchTime: _kMoveEvalMaxSearchTime,
      // We want the fastest search here and we only need the eval
      multiPv: 1,
      threatMode: false,
      initialPosition: state.game.initialPosition,
      steps: steps,
    );
  }

  void _handleSocketEvent(SocketEvent event) {
    // not handling any events for now, but we keep the connection open
    _logger.finer('Received socket event: ${event.topic}');
  }

  Future<CloudEval?> _getCloudEval(EvalWork work, {required int numEvalLines}) async {
    CloudEval? eval;
    try {
      final uciPath = UciPath.fromUciMoves(
        work.steps.map((s) => s.sanMove.normalizeUci(state.game.meta.variant)),
      );

      _logger.fine(
        'Requesting cloud eval for ply ${work.position.ply} and fen ${work.position.fen}',
      );

      socketClient.send('evalGet', {
        'fen': work.position.fen,
        'path': uciPath.value,
        if (work.position.rule != Rule.chess) 'variant': Variant.fromRule(work.position.rule).name,
        'mpv': numEvalLines,
      });
      await for (final event
          in socketClient.stream
              .where((e) => e.topic == 'evalHit')
              .timeout(const Duration(seconds: 2))) {
        final path = pick(event.data, 'path').asStringOrThrow();
        if (path != uciPath.value) {
          continue;
        }
        final nodes = pick(event.data, 'knodes').asIntOrThrow() * 1000;
        final depth = pick(event.data, 'depth').asIntOrThrow();
        final pvs = pick(event.data, 'pvs')
            .asListOrThrow(
              (pv) => PvData(
                moves: pv('moves').asStringOrThrow().split(' ').toIList(),
                cp: pv('cp').asIntOrNull(),
                mate: pv('mate').asIntOrNull(),
              ),
            )
            .toIList();

        _logger.fine('Got a cloud eval at ply ${work.position.ply} with depth $depth');

        eval = CloudEval(depth: depth, nodes: nodes, pvs: pvs, position: work.position);
        break;
      }
    } catch (e, st) {
      _logger.fine('Could not get cloud eval:', e, st);
    }

    return eval;
  }

  /// Creates a practice comment based on pre-move PV data and the post-move eval.
  PracticeComment _createPracticeComment({
    required SanMove sanMove,
    required ClientEval preMoveEval,
    required double winningChancesAfter,
    required String? evalAfterString,
    required Side playerSide,
  }) {
    final winningChancesBefore = preMoveEval.winningChances(playerSide);
    final shift = winningChancesBefore - winningChancesAfter;

    final bestPv = preMoveEval.pvs.first;
    final bestMove = bestPv.moves.isNotEmpty ? Move.parse(bestPv.moves.first) : null;
    final playedMoveIsBest =
        bestMove != null && bestMove.uci == sanMove.normalizeUci(state.game.meta.variant);

    final isGoodMove = shift < kGoodMoveThreshold;

    // Find alternative good move if the played move was good
    Move? alternativeGoodMove;
    if (isGoodMove && preMoveEval.pvs.length > 1) {
      for (final pv in preMoveEval.pvs.skip(1)) {
        if (pv.moves.isEmpty) continue;
        if (winningChancesBefore - pv.winningChances(playerSide) < kGoodMoveThreshold &&
            pv.moves.first != sanMove.normalizeUci(state.game.meta.variant)) {
          alternativeGoodMove = Move.parse(pv.moves.first);
          break;
        }
      }
    }

    final verdict = MoveVerdict.fromShift(
      shift,
      hasBetterMove: !playedMoveIsBest,
      winningChancesBefore: winningChancesBefore,
      winningChancesAfter: winningChancesAfter,
    );

    final positionBeforeMove = state.game.stepAt(state.stepCursor - 1).position;

    SanMove? bestMoveSan;
    if (!playedMoveIsBest && bestMove != null) {
      if (positionBeforeMove.isLegal(bestMove)) {
        final (_, san) = positionBeforeMove.makeSan(bestMove);
        bestMoveSan = SanMove(san, bestMove);
      }
    }

    SanMove? alternativeGoodMoveSan;
    if (alternativeGoodMove != null) {
      if (positionBeforeMove.isLegal(alternativeGoodMove)) {
        final (_, san) = positionBeforeMove.makeSan(alternativeGoodMove);
        alternativeGoodMoveSan = SanMove(san, alternativeGoodMove);
      }
    }

    return PracticeComment(
      verdict: verdict,
      moveSuggestion: bestMoveSan ?? alternativeGoodMoveSan,
      evalAfter: evalAfterString,
      isBookMove: false,
    );
  }

  Future<void> _makeCommentFromOpeningDb(
    SanMove sanMove, {
    required int stepCursor,
    required Position positionBefore,
    required Position fromPosition,
  }) async {
    final masterEntry = await _fetchMasterDatabase(positionBefore.fen);
    if (!ref.mounted || masterEntry == null) return;
    if (state.currentPosition != fromPosition) return;
    final currentComment = state.game.steps[stepCursor].computerAnalysis?.practiceComment;
    if (currentComment?.isBookMove == true) return;
    final isBookMove = masterEntry.moves.any(
      (m) => m.uci == sanMove.normalizeUci(state.game.meta.variant) && m.games > 1,
    );
    if (!isBookMove) return;
    if (currentComment != null) {
      final updatedComment = currentComment.copyWith(
        verdict: MoveVerdict.goodMove,
        isBookMove: true,
      );
      _setComment(stepCursor, updatedComment);
    } else {
      _setComment(
        stepCursor,
        const PracticeComment(verdict: MoveVerdict.goodMove, isBookMove: true),
      );
    }
  }

  /// Fetch the master database for the given FEN.
  ///
  /// Returns null if the request fails (e.g., no connectivity) or times out.
  Future<OpeningExplorerEntry?> _fetchMasterDatabase(String fen) async {
    try {
      final repository = ref.read(openingExplorerRepositoryProvider);
      return await repository
          .getMasterDatabase(fen, since: MasterDb.kEarliestYear)
          .timeout(const Duration(seconds: 2));
    } catch (e, st) {
      _logger.fine('Failed to fetch master database:', e, st);
      return null;
    }
  }

  /// Fetches the tablebase eval for the given position.
  ///
  /// Returns null if the network request fails or the entry is not conclusive.
  Future<ClientEval?> _fetchTablebaseEval(Position position) async {
    try {
      final entry = await ref
          .read(tablebaseRepositoryProvider)
          .getTablebaseEntry(position.fen, Variant.fromRule(position.rule));
      return tablebaseEntryToCloudEval(entry, position);
    } catch (e, st) {
      _logger.fine('Could not get tablebase eval:', e, st);
      return null;
    }
  }

  Future<void> _playEngineMove() async {
    if (!state.game.playable) return;

    // The opponent has the floor: on a variant it plays on the very engine the analysis runs on,
    // and even when it does not, only one engine searches at a time (see [EngineBudget]).
    _analyser.yieldEngine();

    state = state.copyWith(isEngineThinking: true);

    try {
      final variant = state.game.meta.variant;
      final uciMove = await _opponent.findMove(
        initialPosition: state.game.initialPosition,
        moves: state.game.steps.skip(1).map((s) => s.sanMove!.normalizeUci(variant)).toIList(),
        variant: variant,
        sharesEngineWithEvaluator: _sharesOneEngine,
      );
      final move = Move.parse(uciMove);

      if (state.game.playable) {
        _applyMove(move!);
        // After engine move, precompute hints for player's turn (in casual or practice mode)
        // Wait for the engine move animation to complete before computing hints to avoid stuttering.
        if (state.game.playable && (state.game.casual || state.game.practiceMode)) {
          await _waitForPlayerMoveAnimation();
          if (ref.mounted && state.game.playable) _analyseCurrentPosition();
        }
      }
    } on MoveSearchCancelled {
      // Expected when the search is superseded or stopped; ignore.
      return;
    } catch (e, st) {
      // Unexpected engine error occurred.
      _logger.warning('Failed to play engine move!', e, st);
    } finally {
      if (state.game.playable || state.game.finished) {
        state = state.copyWith(isEngineThinking: false);
      }
    }
  }

  Future<void> _playEngineMoveAfterPlayerAnimation() async {
    await _waitForPlayerMoveAnimation();
    if (!ref.mounted) return;
    if (!state.game.playable || state.turn == state.game.playerSide) return;
    await _playEngineMove();
  }

  Future<void> _waitForPlayerMoveAnimation() {
    final animationDuration = ref.read(boardPreferencesProvider).pieceAnimationDuration;
    if (animationDuration <= Duration.zero) {
      return Future<void>.value();
    }
    return Future<void>.delayed(animationDuration + _kEngineMoveAnimationBuffer);
  }

  void resign() {
    if (!state.game.resignable) return;
    state = state.copyWith(
      game: state.game.copyWith(status: GameStatus.resign, winner: state.game.playerSide.opposite),
      isEngineThinking: false,
    );
  }

  /// Claim a draw due to threefold repetition.
  void claimThreefoldDraw() {
    if (!state.game.playable || state.game.isThreefoldRepetition != true) return;
    _stopThinking();
    state = state.copyWith(
      game: state.game.copyWith(status: GameStatus.draw, isThreefoldRepetition: false),
      isEngineThinking: false,
    );
  }

  void takeback() {
    if (!state.canTakeback) return;
    if (!state.game.casual && !state.game.practiceMode) return;

    _stopThinking();

    int stepsToRemove = 1;
    if (state.game.steps.length > 2 && state.turn == state.game.playerSide) {
      // If it's the player's turn, remove both moves
      stepsToRemove = 2;
    }

    final newSteps = state.game.steps.removeLast();
    final finalSteps = stepsToRemove == 2 && newSteps.length > 1 ? newSteps.removeLast() : newSteps;

    state = state.copyWith(
      game: state.game.copyWith(steps: finalSteps, isThreefoldRepetition: false),
      stepCursor: finalSteps.length - 1,
      isEngineThinking: false,
      isEvaluatingMove: false,
      hintIndex: null,
      showingSuggestedMove: null,
    );

    if (state.turn != state.game.playerSide && state.game.playable) {
      _playEngineMove();
    } else if (state.game.playable && (state.game.casual || state.game.practiceMode)) {
      _analyseCurrentPosition();
    }
  }

  void goForward() {
    if (state.canGoForward) {
      state = state.copyWith(stepCursor: state.stepCursor + 1);
    }
  }

  void goBack() {
    if (state.canGoBack) {
      state = state.copyWith(stepCursor: state.stepCursor - 1);
    }
  }

  /// Show or cycle through hints.
  ///
  /// Hints are precomputed when it's the player's turn (in casual or practice mode).
  /// This method just cycles through the available hints.
  void hint() {
    if (!state.game.casual && !state.game.practiceMode) return;
    if (!state.game.playable || state.isEngineThinking || state.isLoadingHint) return;
    if (state.turn != state.game.playerSide) return;

    final existingHints = state.hintMoves;
    if (existingHints == null || existingHints.isEmpty) return;

    final currentIndex = state.hintIndex;
    // Show the first hint, or cycle to the next one
    if (currentIndex == null) {
      state = state.copyWith(hintIndex: 0);
    } else {
      state = state.copyWith(hintIndex: (currentIndex + 1) % existingHints.length);
    }
  }

  /// Analyses the position the player is thinking about, and unlocks the hints once it is deep
  /// enough to be worth showing.
  ///
  /// Called whenever it becomes the player's turn (in casual or practice mode). The analysis runs
  /// on past that point, deepening the evaluation for as long as the player thinks — it is ended
  /// by the opponent taking the engine, not by this returning.
  Future<void> _analyseCurrentPosition() async {
    if (!state.game.casual && !state.game.practiceMode) return;
    if (!state.game.playable || state.turn != state.game.playerSide) return;

    final position = state.currentPosition;
    _analysePosition();

    if (state.currentAnalysis?.eval case final eval? when eval.depth >= kPracticeUsableDepth) {
      return;
    }

    state = state.copyWith(isLoadingHint: true, hintIndex: null);
    await _analyser.usableEval(position, timeout: _kHintWait);
    // The wait may have outlived the position it was for, and the hints for the position the game
    // is at now are somebody else's to unlock.
    if (!ref.mounted || state.currentPosition != position) return;
    state = state.copyWith(isLoadingHint: false);
  }

  /// Starts the continuous analysis of the position the game is at.
  void _analysePosition() {
    final share = _evaluatorShare;
    final steps = state.game.steps
        .skip(1)
        .map((s) => Step(position: s.position, sanMove: s.sanMove!))
        .toIList();

    final work = EvalWork(
      id: state.game.id,
      variant: state.game.meta.variant,
      threads: share.threads,
      hashSize: share.hash,
      searchTime: kPracticeMaxSearchTime,
      multiPv: 2, // a second line, for the alternative move a hint offers
      threatMode: false,
      initialPosition: state.game.initialPosition,
      steps: steps,
    );

    _analyser.analyse(work);
    _raceTheSearch(work);
  }

  /// Asks the network for the evaluations that would beat the search: a cloud eval in the opening,
  /// a tablebase lookup in an endgame. Whatever comes back is offered to the analysis.
  void _raceTheSearch(EvalWork work) {
    final position = work.position;

    // Nothing to beat: this position has already been analysed as deeply as it is going to be.
    if (_analyser.evalFor(position) case final known? when known.depth >= kPracticeTargetDepth) {
      return;
    }

    if (state.game.meta.variant == Variant.standard && position.ply < _kOpeningPlyThreshold) {
      _getCloudEval(work, numEvalLines: work.multiPv).then((cloudEval) {
        if (ref.mounted && cloudEval != null) _analyser.offer(position, cloudEval);
      });
    }

    if (isTablebaseRelevant(position)) {
      _fetchTablebaseEval(position).then((tablebaseEval) {
        if (ref.mounted && tablebaseEval != null) _analyser.offer(position, tablebaseEval);
      });
    }
  }

  /// Toggle showing a suggested move on the board.
  void toggleSuggestedMove(NormalMove? move) {
    if (state.showingSuggestedMove == move) {
      state = state.copyWith(showingSuggestedMove: null);
    } else {
      state = state.copyWith(showingSuggestedMove: move);
    }
  }

  void _moveFeedback(SanMove sanMove) {
    final isCheck = sanMove.san.contains('+');
    if (sanMove.san.contains('x')) {
      ref
          .read(moveFeedbackServiceProvider)
          .captureFeedback(state.game.meta.variant, check: isCheck);
    } else {
      ref.read(moveFeedbackServiceProvider).moveFeedback(check: isCheck);
    }
  }

  /// Updates the computer analysis on the game step at [stepIndex].
  void _setStepAnalysis(int stepIndex, ComputerAnalysis analysis) {
    final updatedStep = state.game.steps[stepIndex].copyWith(computerAnalysis: analysis);
    state = state.copyWith(
      game: state.game.copyWith(steps: state.game.steps.put(stepIndex, updatedStep)),
    );
  }

  /// Stores an evaluation on the game step at [stepIndex], keeping whatever else is on it.
  void _setStepEval(int stepIndex, ClientEval eval) {
    final analysis = state.game.steps[stepIndex].computerAnalysis ?? const ComputerAnalysis();
    _setStepAnalysis(stepIndex, analysis.copyWith(eval: eval));
  }

  /// Saves a practice comment on the game step at [stepIndex], keeping whatever else is on it.
  void _setComment(int stepIndex, PracticeComment comment) {
    final analysis = state.game.steps[stepIndex].computerAnalysis ?? const ComputerAnalysis();
    _setStepAnalysis(stepIndex, analysis.copyWith(practiceComment: comment));
  }
}

@freezed
sealed class OfflineComputerGameState with _$OfflineComputerGameState {
  const OfflineComputerGameState._();

  const factory OfflineComputerGameState({
    required OfflineComputerGame game,
    @Default(0) int stepCursor,
    @Default(false) bool isEngineThinking,
    @Default(false) bool isLoadingHint,

    /// Current hint index for cycling through hints. Null means no hint is shown yet.
    @Default(null) int? hintIndex,

    /// Whether the engine is evaluating the player's move in practice mode.
    @Default(false) bool isEvaluatingMove,

    /// The suggested move to show on the board (when user taps on "Best was X" in practice mode).
    @Default(null) NormalMove? showingSuggestedMove,
  }) = _OfflineComputerGameState;

  factory OfflineComputerGameState.initial({
    required OpponentSpec opponentSpec,
    required Side playerSide,
    Variant variant = Variant.standard,
    bool casual = true,
    bool practiceMode = false,
    String? initialFen,
  }) {
    final Position position;
    final Variant effectiveVariant;
    final String? effectiveInitialFen;

    if (initialFen != null) {
      effectiveVariant = variant == Variant.standard ? Variant.fromPosition : variant;
      position = Position.setupPosition(effectiveVariant.rule, Setup.parseFen(initialFen));
      effectiveInitialFen = initialFen;
    } else if (variant == Variant.chess960) {
      position = randomChess960Position();
      effectiveVariant = Variant.chess960;
      effectiveInitialFen = position.fen;
    } else {
      position = variant.initialPosition;
      effectiveVariant = variant;
      effectiveInitialFen = null;
    }

    final sessionId = StringId('ocg_${_random.nextInt(1 << 32).toRadixString(16).padLeft(8, '0')}');
    return OfflineComputerGameState(
      game: OfflineComputerGame(
        id: sessionId,
        steps: [GameStep(position: position)].lock,
        status: GameStatus.started,
        initialFen: effectiveInitialFen,
        meta: GameMeta(
          createdAt: DateTime.now(),
          rated: false,
          variant: effectiveVariant,
          speed: Speed.classical,
          perf: Perf.fromVariantAndSpeed(effectiveVariant, Speed.classical),
        ),
        playerSide: playerSide,
        opponentSpec: opponentSpec,
        casual: casual,
        practiceMode: practiceMode,
        humanPlayer: const Player(onGame: true),
        enginePlayer: enginePlayerFor(opponentSpec),
      ),
    );
  }

  /// The computer analysis for the current step.
  ComputerAnalysis? get currentAnalysis => game.steps[stepCursor].computerAnalysis;

  /// The practice comment which can be on the last step or the previous step (after computer played a move).
  PracticeComment? get practiceComment =>
      game.steps.last.computerAnalysis?.practiceComment ??
      (game.steps.length >= 2
          ? game.steps[game.steps.length - 2].computerAnalysis?.practiceComment
          : null);

  /// The hint moves for the current position.
  IList<Move>? get hintMoves => currentAnalysis?.hintMoves;

  Position get currentPosition => game.stepAt(stepCursor).position;
  Side get turn => currentPosition.turn;
  bool get finished => game.finished;

  Move? get lastMove =>
      stepCursor > 0 ? Move.parse(game.steps[stepCursor].sanMove!.move.uci) : null;

  MaterialDiffSide? currentMaterialDiff(Side side) {
    return game.steps[stepCursor].diff?.bySide(side);
  }

  List<String> get moves => game.steps.skip(1).map((e) => e.sanMove!.san).toList(growable: false);

  bool get canGoForward => stepCursor < game.steps.length - 1;
  bool get canGoBack => stepCursor > 0;

  /// Player can take back if it's their turn and there are moves to take back.
  bool get canTakeback =>
      game.playable && game.steps.length > 1 && !isEngineThinking && !isEvaluatingMove;

  /// The square to highlight for the current hint.
  Square? get hintSquare {
    final moves = hintMoves;
    final index = hintIndex;
    if (moves == null || moves.isEmpty || index == null) return null;
    final move = moves[index];
    return switch (move) {
      NormalMove(:final from) => from,
      DropMove() => null,
    };
  }
}
