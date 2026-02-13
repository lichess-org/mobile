import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/model/explorer/opening_explorer.dart';
import 'package:lichess_mobile/src/model/explorer/opening_explorer_preferences.dart';
import 'package:lichess_mobile/src/model/explorer/opening_explorer_repository.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';
import 'package:lichess_mobile/src/model/game/offline_computer_game.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/offline_computer/offline_computer_game_storage.dart';
import 'package:lichess_mobile/src/model/offline_computer/practice_comment.dart';
import 'package:logging/logging.dart';

part 'offline_computer_game_controller.freezed.dart';

final _random = Random();

final _logger = Logger('OfflineComputerGameController');

/// The number of CPU cores to use for engine evaluation.
final numberOfCoresForEvaluation = max(1, maxEngineCores - 1);

/// Minimum depth required for a move evaluation in practice mode.
const _kMinEvalDepth = kDebugMode ? 12 : 15;

/// Search time for evaluations in practice mode.
const _kSearchTime = Duration(seconds: 2);

/// Number of multi-PV lines to request for evaluation.
const _kEvaluationMultivpv = 3;

/// Ply threshold for opening phase. Below this, we check the master database
/// to consider book moves as good regardless of engine evaluation.
const _kOpeningPlyThreshold = 30;

/// Normalizes a UCI move string for comparison by converting alternate castling
/// notations to standard notation.
///
/// This handles the case where moves may use either:
/// - Standard notation: e1g1 (king moves to destination)
/// - Alternate notation: e1h1 (king captures rook, used by engines)
String _normalizeUci(String uci) => altCastles[uci] ?? uci;

final offlineComputerGameControllerProvider =
    NotifierProvider.autoDispose<OfflineComputerGameController, OfflineComputerGameState>(
      OfflineComputerGameController.new,
      name: 'OfflineComputerGameControllerProvider',
    );

class OfflineComputerGameController extends Notifier<OfflineComputerGameState> {
  @override
  OfflineComputerGameState build() {
    final evaluationService = ref.watch(evaluationServiceProvider);
    ref.onDispose(() {
      evaluationService.quit();
    });
    return OfflineComputerGameState.initial(
      stockfishLevel: StockfishLevel.defaultLevel,
      playerSide: Side.white,
    );
  }

  void startNewGame({
    required StockfishLevel stockfishLevel,
    required Side playerSide,
    required bool casual,
    required bool practiceMode,
    String? initialFen,
  }) {
    state = OfflineComputerGameState.initial(
      stockfishLevel: stockfishLevel,
      playerSide: playerSide,
      casual: casual,
      practiceMode: practiceMode,
      initialFen: initialFen,
    );

    // If it's the engine's turn, trigger engine move
    if (state.turn != playerSide) {
      _playEngineMove();
    } else if (casual || practiceMode) {
      // Player plays first, precompute hints (only in casual or practice mode)
      _computeHints();
    }
  }

  /// Load a game from storage.
  void loadGame(SavedOfflineComputerGame savedGame) {
    final game = savedGame.game;
    state = OfflineComputerGameState(
      game: game,
      gameSessionId: StringId(savedGame.gameSessionId),
      stepCursor: game.steps.length - 1,
      practiceComment: savedGame.lastPracticeComment,
      cachedEvalString: savedGame.lastEvalString,
    );

    // If it's the player's turn and game is still playable, precompute hints (only in casual or practice mode)
    if (game.playable && state.turn == game.playerSide && (game.casual || game.practiceMode)) {
      _computeHints();
    }
    // If it's the engine's turn and game is still playable, trigger engine move
    else if (game.playable && state.turn != game.playerSide) {
      _playEngineMove();
    }
  }

  void makeMove(NormalMove move) {
    if (state.isEngineThinking || state.isEvaluatingMove || !state.game.playable) return;

    if (isPromotionPawnMove(state.currentPosition, move)) {
      state = state.copyWith(promotionMove: move);
      return;
    }

    if (state.game.practiceMode) {
      _makeMoveWithEvaluation(move);
    } else {
      _applyMove(move);
      if (state.game.playable) {
        _playEngineMove();
      }
    }
  }

  void onPromotionSelection(Role? role) {
    if (role == null) {
      state = state.copyWith(promotionMove: null);
      return;
    }
    final promotionMove = state.promotionMove;
    if (promotionMove != null) {
      final move = promotionMove.withPromotion(role);
      state = state.copyWith(promotionMove: null);

      if (state.game.practiceMode) {
        _makeMoveWithEvaluation(move);
      } else {
        _applyMove(move);
        if (state.game.playable) {
          _playEngineMove();
        }
      }
    }
  }

  void _applyMove(NormalMove move) {
    final (newPos, newSan) = state.currentPosition.makeSan(Move.parse(move.uci)!);
    final sanMove = SanMove(newSan, move);
    final newStep = GameStep(
      position: newPos,
      sanMove: sanMove,
      diff: MaterialDiff.fromBoard(newPos.board),
    );

    _clearHints();

    state = state.copyWith(
      game: state.game.copyWith(steps: state.game.steps.add(newStep)),
      stepCursor: state.stepCursor + 1,
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
    } else if (state.currentPosition.isStalemate) {
      state = state.copyWith(game: state.game.copyWith(status: GameStatus.stalemate));
    } else if (state.currentPosition.isInsufficientMaterial) {
      state = state.copyWith(game: state.game.copyWith(status: GameStatus.draw));
    }

    _moveFeedback(sanMove);
  }

  /// Make a player move with practice mode evaluation.
  ///
  /// Uses the cached evaluation from _computeHints as the "before" state,
  /// then evaluates the position after the move to determine how good the move was.
  /// If hint computation is still in progress, waits for it to complete first.
  ///
  /// In the opening phase (before [_kOpeningPlyThreshold]), also fetches the master
  /// database to consider book moves as good regardless of engine evaluation.
  Future<void> _makeMoveWithEvaluation(NormalMove move) async {
    if (!state.game.practiceMode || !state.game.playable) return;

    var cachedBestMoves = state.cachedBestMoves;
    var cachedWinningChances = state.cachedWinningChances;
    final wasLoadingHint = state.isLoadingHint;

    final positionBeforeFen = state.currentPosition.fen;
    final plyBeforeMove = state.currentPosition.ply;

    state = state.copyWith(isEvaluatingMove: true, practiceComment: null);

    _applyMove(move);

    if (!state.game.playable) {
      state = state.copyWith(isEvaluatingMove: false);
      return;
    }

    // If hints were still loading when we made the move, wait for them to complete
    // so we can get the "before" evaluation for comparison.
    // Wait time must be longer than _kSearchTime to account for engine startup overhead.
    if (wasLoadingHint || cachedBestMoves == null || cachedWinningChances == null) {
      const maxWaitTime = Duration(seconds: 3);
      final deadline = DateTime.now().add(maxWaitTime);
      while (state.isLoadingHint && ref.mounted && DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }

      if (!ref.mounted) return;

      cachedBestMoves = state.cachedBestMoves;
      cachedWinningChances = state.cachedWinningChances;
    }

    // If we still don't have cached evaluation, proceed without practice comment
    if (cachedBestMoves == null || cachedWinningChances == null || cachedBestMoves.isEmpty) {
      state = state.copyWith(isEvaluatingMove: false);
      if (state.turn != state.game.playerSide) {
        _playEngineMove();
      }
      return;
    }

    final playerSide = state.game.playerSide;
    final normalizedMoveUci = _normalizeUci(move.uci);

    // Check if the player's move is in the cached best moves list.
    // If so, we can use the cached winning chances to show a comment immediately.
    final cachedMoveData = cachedBestMoves.firstWhereOrNull(
      (m) => _normalizeUci(m.move.uci) == normalizedMoveUci,
    );

    // Fetch master database upfront (only in opening phase) - needed in both paths
    final masterEntry = plyBeforeMove < _kOpeningPlyThreshold
        ? await _fetchMasterDatabase(positionBeforeFen)
        : null;

    if (!ref.mounted) return;

    // Fast path: move was in the analysis, show comment immediately from cached data
    if (cachedMoveData != null) {
      _logger.info('Using cached eval for move: ${move.uci}');

      final comment = _createPracticeComment(
        move: move,
        normalizedMoveUci: normalizedMoveUci,
        cachedBestMoves: cachedBestMoves,
        winningChancesBefore: cachedWinningChances,
        winningChancesAfter: cachedMoveData.winningChances,
        evalAfterString: null, // Will be updated when eval completes
        masterEntry: masterEntry,
        playerSide: playerSide,
      );

      state = state.copyWith(isEvaluatingMove: false, practiceComment: comment);
    } else {
      _logger.info('Move not in cache, evaluating: ${move.uci}');
    }

    // Always run the eval to get the eval string (and for the slow path, the full comment)
    try {
      final evaluationService = ref.read(evaluationServiceProvider);
      final enginePrefs = ref.read(engineEvaluationPreferencesProvider);

      final stepsAfter = state.game.steps
          .skip(1)
          .map((s) => Step(position: s.position, sanMove: s.sanMove!))
          .toIList();

      final workAfter = EvalWork(
        id: state.gameSessionId,
        enginePref: enginePrefs.enginePref,
        variant: Variant.standard,
        threads: numberOfCoresForEvaluation,
        hashSize: evaluationService.maxMemory,
        searchTime: _kSearchTime,
        multiPv: _kEvaluationMultivpv,
        threatMode: false,
        initialPosition: state.game.initialPosition,
        steps: stepsAfter,
      );

      final evalAfter = await evaluationService.findEval(workAfter, minDepth: _kMinEvalDepth);

      if (!ref.mounted) return;

      if (evalAfter != null) {
        _logger.info('Move eval: depth=${evalAfter.depth}, score=${evalAfter.evalString}');
      }

      if (state.practiceComment != null) {
        // Fast path follow-up: update existing comment with eval string
        if (evalAfter != null) {
          state = state.copyWith(
            practiceComment: state.practiceComment!.copyWith(evalAfter: evalAfter.evalString),
          );
        }
      } else if (evalAfter != null) {
        // Slow path: create full comment with eval
        final winningChancesAfter = -evalAfter.winningChances(playerSide.opposite);

        final comment = _createPracticeComment(
          move: move,
          normalizedMoveUci: normalizedMoveUci,
          cachedBestMoves: cachedBestMoves,
          winningChancesBefore: cachedWinningChances,
          winningChancesAfter: winningChancesAfter,
          evalAfterString: evalAfter.evalString,
          masterEntry: masterEntry,
          playerSide: playerSide,
        );

        state = state.copyWith(isEvaluatingMove: false, practiceComment: comment);
      } else {
        state = state.copyWith(isEvaluatingMove: false);
      }

      if (state.game.playable && state.turn != state.game.playerSide) {
        _playEngineMove();
      }
    } catch (e) {
      _logger.warning('Error evaluating move: $e');
      if (ref.mounted) {
        state = state.copyWith(isEvaluatingMove: false);
        if (state.game.playable && state.turn != state.game.playerSide) {
          _playEngineMove();
        }
      }
    }
  }

  /// Creates a practice comment based on evaluation data.
  PracticeComment _createPracticeComment({
    required NormalMove move,
    required String normalizedMoveUci,
    required IList<MoveWithWinningChances> cachedBestMoves,
    required double winningChancesBefore,
    required double winningChancesAfter,
    required String? evalAfterString,
    required OpeningExplorerEntry? masterEntry,
    required Side playerSide,
  }) {
    final isBookMove =
        masterEntry != null &&
        masterEntry.moves.any((m) => _normalizeUci(m.uci) == normalizedMoveUci && m.games > 1);

    final shift = winningChancesBefore - winningChancesAfter;

    final bestMoveData = cachedBestMoves.firstOrNull;
    final bestMove = bestMoveData?.move;
    final playedMoveIsBest = bestMove != null && _normalizeUci(bestMove.uci) == normalizedMoveUci;

    final isGoodMove = isBookMove || shift < kGoodMoveThreshold;

    // Find alternative good move if the played move was good
    Move? alternativeGoodMove;
    if (isGoodMove && cachedBestMoves.length > 1) {
      for (final m in cachedBestMoves.skip(1)) {
        if (winningChancesBefore - m.winningChances < kGoodMoveThreshold &&
            _normalizeUci(m.move.uci) != normalizedMoveUci) {
          alternativeGoodMove = m.move;
          break;
        }
      }
    }

    final verdict = isBookMove
        ? MoveVerdict.goodMove
        : MoveVerdict.fromShift(
            shift,
            hasBetterMove: !playedMoveIsBest,
            winningChancesBefore: winningChancesBefore,
            winningChancesAfter: winningChancesAfter,
          );

    // Get the position BEFORE the player's move to format the suggested moves as SAN
    final positionBeforeMove = state.game.stepAt(state.stepCursor - 1).position;

    // Format best move as SAN (if not a good move and there was a better move)
    SanMove? bestMoveSan;
    if (!isGoodMove && !playedMoveIsBest && bestMove != null) {
      final parsed = Move.parse(bestMove.uci);
      if (parsed != null && positionBeforeMove.isLegal(parsed)) {
        final (_, san) = positionBeforeMove.makeSan(parsed);
        bestMoveSan = SanMove(san, parsed);
      }
    }

    // Format alternative good move as SAN
    SanMove? alternativeGoodMoveSan;
    if (alternativeGoodMove != null) {
      final parsed = Move.parse(alternativeGoodMove.uci);
      if (parsed != null && positionBeforeMove.isLegal(parsed)) {
        final (_, san) = positionBeforeMove.makeSan(parsed);
        alternativeGoodMoveSan = SanMove(san, parsed);
      }
    }

    return PracticeComment(
      verdict: verdict,
      bestMove: bestMoveSan,
      alternativeGoodMove: alternativeGoodMoveSan,
      winningChancesBefore: winningChancesBefore,
      winningChancesAfter: winningChancesAfter,
      evalAfter: evalAfterString,
      isBookMove: isBookMove,
    );
  }

  /// Fetch the master database for the given FEN.
  /// Returns null if the request fails (e.g., no connectivity) or times out.
  Future<OpeningExplorerEntry?> _fetchMasterDatabase(String fen) async {
    try {
      final repository = ref.read(openingExplorerRepositoryProvider);
      return await repository
          .getMasterDatabase(fen, since: MasterDb.kEarliestYear)
          .timeout(const Duration(seconds: 2));
    } catch (e) {
      _logger.fine('Failed to fetch master database: $e');
      return null;
    }
  }

  Future<void> _playEngineMove() async {
    if (!state.game.playable) return;

    state = state.copyWith(isEngineThinking: true);

    try {
      final evaluationService = ref.read(evaluationServiceProvider);
      final enginePrefs = ref.read(engineEvaluationPreferencesProvider);

      final steps = state.game.steps
          .skip(1)
          .map((s) => Step(position: s.position, sanMove: s.sanMove!))
          .toIList();

      final work = MoveWork(
        id: state.gameSessionId,
        enginePref: enginePrefs.enginePref,
        variant: Variant.standard,
        hashSize: evaluationService.maxMemory,
        initialPosition: state.game.initialPosition,
        steps: steps,
        level: state.game.stockfishLevel,
      );

      final uciMove = await evaluationService.findMove(work);
      final move = NormalMove.fromUci(uciMove);

      if (state.game.playable) {
        _applyMove(move);
        // After engine move, precompute hints for player's turn (in casual or practice mode)
        if (state.game.playable && (state.game.casual || state.game.practiceMode)) {
          _computeHints();
        }
      }
    } catch (e) {
      // Engine was stopped or error occurred, ignore
    } finally {
      if (state.game.playable || state.game.finished) {
        state = state.copyWith(isEngineThinking: false);
      }
    }
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
    ref.read(evaluationServiceProvider).stop();
    state = state.copyWith(
      game: state.game.copyWith(status: GameStatus.draw, isThreefoldRepetition: false),
      isEngineThinking: false,
    );
  }

  void takeback() {
    if (!state.canTakeback) return;
    if (!state.game.casual && !state.game.practiceMode) return;

    // Cancel any pending engine move
    ref.read(evaluationServiceProvider).stop();

    // Remove last two moves (player's move and engine's response if any)
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
      practiceComment: null,
    );

    // If after takeback it's engine's turn, play engine move
    // Otherwise precompute hints for player's turn (in casual or practice mode)
    if (state.turn != state.game.playerSide && state.game.playable) {
      _playEngineMove();
    } else if (state.game.playable && (state.game.casual || state.game.practiceMode)) {
      _computeHints();
    }
  }

  void goForward() {
    if (state.canGoForward) {
      state = state.copyWith(stepCursor: state.stepCursor + 1, promotionMove: null);
    }
  }

  void goBack() {
    if (state.canGoBack) {
      state = state.copyWith(stepCursor: state.stepCursor - 1, promotionMove: null);
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

  /// Precompute hints for the current position.
  ///
  /// Called automatically when it's the player's turn (in casual or practice mode).
  /// In practice mode, also caches the evaluation for later comparison.
  Future<void> _computeHints() async {
    if (!state.game.casual && !state.game.practiceMode) return;
    if (!state.game.playable || state.turn != state.game.playerSide) return;

    state = state.copyWith(
      isLoadingHint: true,
      hintMoves: null,
      hintIndex: null,
      cachedBestMoves: null,
      cachedWinningChances: null,
    );

    try {
      final evaluationService = ref.read(evaluationServiceProvider);
      final enginePrefs = ref.read(engineEvaluationPreferencesProvider);

      final steps = state.game.steps
          .skip(1)
          .map((s) => Step(position: s.position, sanMove: s.sanMove!))
          .toIList();

      final work = EvalWork(
        id: state.gameSessionId,
        enginePref: enginePrefs.enginePref,
        variant: Variant.standard,
        threads: numberOfCoresForEvaluation,
        hashSize: evaluationService.maxMemory,
        searchTime: _kSearchTime,
        multiPv: _kEvaluationMultivpv,
        threatMode: false,
        initialPosition: state.game.initialPosition,
        steps: steps,
      );

      final finalEval = await evaluationService.findEval(work, minDepth: _kMinEvalDepth);

      if (!ref.mounted) return;

      if (finalEval == null || !state.game.playable) {
        state = state.copyWith(isLoadingHint: false);
        return;
      }

      // Get best moves and filter out those that significantly drop the eval
      final bestMoves = finalEval.bestMoves;
      if (bestMoves.isEmpty) {
        state = state.copyWith(isLoadingHint: false);
        return;
      }

      final topWinningChances = bestMoves.first.winningChances;
      // Filter moves that don't drop eval by more than 0.1 (10% winning chances)
      // and keep only one move per origin square so hints cycle through different pieces
      final seenOrigins = <Square>{};
      final goodMoves = <Move>[];
      for (final m in bestMoves) {
        if (topWinningChances - m.winningChances > 0.1) continue;
        final origin = switch (m.move) {
          NormalMove(:final from) => from,
          DropMove() => null,
        };
        if (origin != null && !seenOrigins.contains(origin)) {
          seenOrigins.add(origin);
          goodMoves.add(m.move);
        }
      }

      // Shuffle to randomize the order, then convert to IList
      goodMoves.shuffle(_random);
      final hintMoves = goodMoves.toIList();

      // In practice mode, also cache the evaluation for later comparison
      if (state.game.practiceMode) {
        final playerSide = state.game.playerSide;
        final winningChances = finalEval.winningChances(playerSide);
        _logger.info(
          'Hints computed: depth=${finalEval.depth}, score=${finalEval.evalString}, '
          'hints=${hintMoves.map((m) => m.uci).join(', ')}',
        );
        state = state.copyWith(
          isLoadingHint: false,
          hintMoves: hintMoves,
          cachedBestMoves: bestMoves,
          cachedWinningChances: winningChances,
          cachedEvalString: finalEval.evalString,
        );
      } else {
        state = state.copyWith(isLoadingHint: false, hintMoves: hintMoves);
      }
    } catch (e) {
      if (ref.mounted) {
        state = state.copyWith(isLoadingHint: false);
      }
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

  /// Clear the current hints and cached evaluation (called when a move is made).
  void _clearHints() {
    if (state.hintMoves != null ||
        state.hintIndex != null ||
        state.cachedBestMoves != null ||
        state.cachedWinningChances != null ||
        state.cachedEvalString != null ||
        state.showingSuggestedMove != null) {
      state = state.copyWith(
        hintMoves: null,
        hintIndex: null,
        cachedBestMoves: null,
        cachedWinningChances: null,
        cachedEvalString: null,
        showingSuggestedMove: null,
      );
    }
  }

  void _moveFeedback(SanMove sanMove) {
    final isCheck = sanMove.san.contains('+');
    if (sanMove.san.contains('x')) {
      ref.read(moveFeedbackServiceProvider).captureFeedback(check: isCheck);
    } else {
      ref.read(moveFeedbackServiceProvider).moveFeedback(check: isCheck);
    }
  }
}

@freezed
sealed class OfflineComputerGameState with _$OfflineComputerGameState {
  const OfflineComputerGameState._();

  const factory OfflineComputerGameState({
    required OfflineComputerGame game,
    required StringId gameSessionId,
    @Default(0) int stepCursor,
    @Default(null) NormalMove? promotionMove,
    @Default(false) bool isEngineThinking,
    @Default(false) bool isLoadingHint,

    /// The list of hint moves (up to 5), randomly ordered once computed.
    @Default(null) IList<Move>? hintMoves,

    /// Current hint index for cycling through hints. Null means no hint is shown yet.
    @Default(null) int? hintIndex,

    /// Whether the engine is evaluating the player's move in practice mode.
    @Default(false) bool isEvaluatingMove,

    /// The practice comment for the last player move (only in practice mode).
    @Default(null) PracticeComment? practiceComment,

    /// The cached evaluation before the player's move (computed with hints in practice mode).
    /// Contains the best moves and winning chances from the player's perspective.
    @Default(null) IList<MoveWithWinningChances>? cachedBestMoves,

    /// The suggested move to show on the board (when user taps on "Best was X" in practice mode).
    @Default(null) NormalMove? showingSuggestedMove,

    /// The winning chances before the player's move (from player's perspective).
    @Default(null) double? cachedWinningChances,

    /// The cached evaluation string for the current position (e.g., "+0.5", "-1.2", "#3").
    @Default(null) String? cachedEvalString,
  }) = _OfflineComputerGameState;

  factory OfflineComputerGameState.initial({
    required StockfishLevel stockfishLevel,
    required Side playerSide,
    bool casual = true,
    bool practiceMode = false,
    String? initialFen,
  }) {
    final position = initialFen != null
        ? Chess.fromSetup(Setup.parseFen(initialFen))
        : Chess.initial;
    final sessionId = StringId('ocg_${_random.nextInt(1 << 32).toRadixString(16).padLeft(8, '0')}');
    return OfflineComputerGameState(
      game: OfflineComputerGame(
        steps: [GameStep(position: position)].lock,
        status: GameStatus.started,
        initialFen: initialFen ?? kInitialFEN,
        meta: GameMeta(
          createdAt: DateTime.now(),
          rated: false,
          variant: initialFen != null ? Variant.fromPosition : Variant.standard,
          speed: Speed.classical,
          perf: Perf.classical,
        ),
        playerSide: playerSide,
        stockfishLevel: stockfishLevel,
        casual: casual,
        practiceMode: practiceMode,
        humanPlayer: const Player(onGame: true),
        enginePlayer: stockfishPlayer(),
      ),
      gameSessionId: sessionId,
    );
  }

  Position get currentPosition => game.stepAt(stepCursor).position;
  Side get turn => currentPosition.turn;
  bool get finished => game.finished;

  NormalMove? get lastMove =>
      stepCursor > 0 ? NormalMove.fromUci(game.steps[stepCursor].sanMove!.move.uci) : null;

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
