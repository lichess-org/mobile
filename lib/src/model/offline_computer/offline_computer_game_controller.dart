import 'dart:async';
import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
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

/// Converts king-takes-rook castling notation (from UCI_Chess960 mode) back to standard notation.
/// E.g., 'e1h1' -> 'e1g1' for white kingside castling.
const _castleMovesToStandard = {'e1a1': 'e1c1', 'e1h1': 'e1g1', 'e8a8': 'e8c8', 'e8h8': 'e8g8'};

/// Normalizes a UCI move string by converting king-takes-rook castling to standard notation.
String _normalizeUci(String uci) => _castleMovesToStandard[uci] ?? uci;

/// Computes the multiPv value for a given elo, matching MoveWork.multiPv logic.
int _multiPvForElo(int elo) {
  if (elo <= 1650) {
    return (10 - ((elo - 1320) / (1650 - 1320) * 4)).round().clamp(6, 10);
  } else if (elo >= 2850) {
    return 3;
  } else if (elo >= 1850) {
    return 4;
  } else {
    return 5;
  }
}

/// Computes the search time for a given elo, matching MoveWork.searchTime logic.
Duration _searchTimeForElo(int elo) {
  final int ms;
  if (elo <= 1750) {
    // Levels 1-5: linear from 150ms to 640ms
    ms = (150 + ((elo - 1320) / (1750 - 1320) * 490)).toInt();
  } else {
    // Levels 6-12: linear from 1500ms to 8000ms
    ms = (1500 + ((elo - 1850) / (3190 - 1850) * 6500)).toInt();
  }
  return Duration(milliseconds: ms.clamp(150, 8000));
}

/// The number of CPU cores to use for engine evaluation.
final numberOfCoresForEvaluation = max(1, maxEngineCores - 1);

/// Minimum depth required for a move evaluation in practice mode.
const _kMinEvalDepth = 14;

/// Search time for evaluations in practice mode.
const _kSearchTime = Duration(seconds: 2);

/// Number of multi-PV lines to request for evaluation.
const _kEvaluationMultivpv = 3;

/// Ply threshold for opening phase. Below this, we check the master database
/// to consider book moves as good regardless of engine evaluation.
const _kOpeningPlyThreshold = 30;

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

    // Try to get cached values before applying move (they might be available already)
    var cachedBestMoves = state.cachedBestMoves;
    var cachedWinningChances = state.cachedWinningChances;
    final wasLoadingHint = state.isLoadingHint;

    // Get position FEN before applying the move for opening database lookup
    final positionBeforeFen = state.currentPosition.fen;
    final plyBeforeMove = state.currentPosition.ply;

    // Clear previous practice comment and set evaluating state
    state = state.copyWith(isEvaluatingMove: true, practiceComment: null);

    // Apply the move immediately for responsive UI
    _applyMove(move);

    if (!state.game.playable) {
      // Game ended (checkmate, stalemate, etc.) - no need to evaluate further
      state = state.copyWith(isEvaluatingMove: false);
      return;
    }

    // If hints were still loading when we made the move, wait for them to complete
    // so we can get the "before" evaluation for comparison
    if (wasLoadingHint || cachedBestMoves == null || cachedWinningChances == null) {
      const maxWaitTime = Duration(seconds: 2);
      final deadline = DateTime.now().add(maxWaitTime);
      while (state.isLoadingHint && ref.mounted && DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }

      if (!ref.mounted) return;

      // Now get the cached values (should be available after hints complete)
      cachedBestMoves = state.cachedBestMoves;
      cachedWinningChances = state.cachedWinningChances;
    }

    // If we still don't have cached evaluation, proceed without practice comment
    if (cachedBestMoves == null || cachedWinningChances == null || cachedBestMoves.isEmpty) {
      state = state.copyWith(isEvaluatingMove: false);
      _playEngineMove();
      return;
    }

    try {
      final evaluationService = ref.read(evaluationServiceProvider);
      final enginePrefs = ref.read(engineEvaluationPreferencesProvider);
      final playerSide = state.game.playerSide;

      // Build steps for the position AFTER the player's move
      final stepsAfter = state.game.steps
          .skip(1)
          .map((s) => Step(position: s.position, sanMove: s.sanMove!))
          .toIList();

      final elo = state.game.stockfishLevel.elo;

      // Create reference MoveWork to get elo-based parameters
      final moveWorkForEngine = MoveWork(
        id: state.gameSessionId,
        enginePref: enginePrefs.enginePref,
        variant: Variant.standard,
        threads: 1,
        hashSize: evaluationService.maxMemory,
        initialPosition: state.game.initialPosition,
        steps: stepsAfter,
        elo: elo,
      );

      // Check if this is a lower level (search time < 2s, i.e., elo ≤ 1750)
      final isLowerLevel = moveWorkForEngine.searchTime < _kSearchTime;

      // Start master DB fetch (same for both paths)
      final masterDbFuture = plyBeforeMove < _kOpeningPlyThreshold
          ? _fetchMasterDatabase(positionBeforeFen)
          : Future.value(null);

      LocalEval? evalAfter;
      String engineMoveUci;
      OpeningExplorerEntry? masterEntry;

      if (isLowerLevel) {
        // Lower levels: separate eval and move searches.
        // This ensures weak engine play while still getting accurate evaluations.
        // 1. Accurate eval with multiple cores
        final evalWork = EvalWork(
          id: state.gameSessionId,
          enginePref: enginePrefs.enginePref,
          variant: Variant.standard,
          threads: numberOfCoresForEvaluation,
          hashSize: evaluationService.maxMemory,
          searchTime: _kSearchTime,
          multiPv: _multiPvForElo(elo),
          threatMode: false,
          initialPosition: state.game.initialPosition,
          steps: stepsAfter,
        );

        // Eval search and master DB can run in parallel
        (evalAfter, masterEntry) = await (
          evaluationService.findEval(evalWork, minDepth: _kMinEvalDepth),
          masterDbFuture,
        ).wait;

        if (!ref.mounted) return;

        // 2. Weak move search with 1 core (sequential, after eval)
        engineMoveUci = await evaluationService.findMove(moveWorkForEngine);

        _logger.info(
          'Practice mode (lower level): eval depth=${evalAfter?.depth}, '
          'score=${evalAfter?.evalString}, engine move=$engineMoveUci',
        );
      } else {
        // Higher levels: combined search (engine is strong enough anyway).
        // Use MoveWork to get both evaluation and engine move in a single search.
        final work = MoveWork(
          id: state.gameSessionId,
          enginePref: enginePrefs.enginePref,
          variant: Variant.standard,
          threads: numberOfCoresForEvaluation,
          hashSize: evaluationService.maxMemory,
          initialPosition: state.game.initialPosition,
          steps: stepsAfter,
          elo: elo,
        );

        final ((eval, move), entry) = await (
          evaluationService.findMoveWithEval(work),
          masterDbFuture,
        ).wait;
        evalAfter = eval;
        engineMoveUci = move;
        masterEntry = entry;

        _logger.info(
          'Practice mode (higher level): eval depth=${evalAfter?.depth}, '
          'score=${evalAfter?.evalString}, engine move=$engineMoveUci',
        );
      }

      if (!ref.mounted) return;

      // Check if the played move is in the master database (played more than once)
      final isBookMove =
          masterEntry != null && masterEntry.moves.any((m) => m.uci == move.uci && m.games > 1);

      // Create practice comment if we have the after evaluation
      PracticeComment? comment;
      if (evalAfter != null) {
        final winningChancesBefore = cachedWinningChances;
        // After the move, it's opponent's turn, so we need to flip the perspective
        final winningChancesAfter = -evalAfter.winningChances(playerSide.opposite);

        // Calculate shift (how much the position deteriorated)
        final shift = winningChancesBefore - winningChancesAfter;

        // Get best move from cached evaluation
        final bestMoveData = cachedBestMoves.firstOrNull;
        final bestMove = bestMoveData?.move;

        // Check if the played move was the best move.
        // Normalize UCI to handle castling notation differences (UCI_Chess960 uses king-takes-rook).
        final playedMoveIsBest = bestMove != null && _normalizeUci(bestMove.uci) == move.uci;

        // If the move is a book move, consider it a good move regardless of eval
        final isGoodMove = isBookMove || shift < 0.025;

        // Find alternative good move if the played move was good
        Move? alternativeGoodMove;
        if (isGoodMove && cachedBestMoves.length > 1) {
          // Find another good move that's not the one played
          for (final m in cachedBestMoves.skip(1)) {
            if (winningChancesBefore - m.winningChances < 0.025 &&
                _normalizeUci(m.move.uci) != move.uci) {
              alternativeGoodMove = m.move;
              break;
            }
          }
        }

        // If it's a book move, force good move verdict
        final verdict = isBookMove
            ? MoveVerdict.goodMove
            : MoveVerdict.fromShift(shift, hasBetterMove: !playedMoveIsBest);

        // Get the position BEFORE the player's move to format the suggested moves as SAN
        // The stepCursor was incremented by _applyMove, so we need to go back 1 step
        final positionBeforeMove = state.game.stepAt(state.stepCursor - 1).position;

        // Format best move as SAN (only if not a good move and there was a better move)
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

        comment = PracticeComment(
          verdict: verdict,
          bestMove: bestMoveSan,
          alternativeGoodMove: alternativeGoodMoveSan,
          winningChancesBefore: winningChancesBefore,
          winningChancesAfter: winningChancesAfter,
          evalAfter: evalAfter.evalString,
          isBookMove: isBookMove,
        );
      }

      state = state.copyWith(isEvaluatingMove: false, practiceComment: comment);

      // Apply engine move directly (we already have it from the combined search)
      if (state.game.playable) {
        final engineMove = NormalMove.fromUci(engineMoveUci);
        _applyMove(engineMove);
        // After engine move, precompute hints for player's turn
        if (state.game.playable) {
          _computeHints();
        }
      }
    } catch (e) {
      _logger.warning('Error evaluating move: $e');
      if (ref.mounted) {
        state = state.copyWith(isEvaluatingMove: false);
        // Still play engine move even if evaluation failed
        if (state.game.playable) {
          _playEngineMove();
        }
      }
    }
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
        threads: 1,
        hashSize: evaluationService.maxMemory,
        initialPosition: state.game.initialPosition,
        steps: steps,
        elo: state.game.stockfishLevel.elo,
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

      // Use EvalWork for hints. Parameters match those used in _makeMoveWithEvaluation
      // for consistent evaluation comparison in practice mode.
      final LocalEval? finalEval;
      if (state.game.practiceMode) {
        final elo = state.game.stockfishLevel.elo;
        // Use elo-based search time for higher levels, minimum 2s for lower levels.
        // This matches the search time used in _makeMoveWithEvaluation.
        final eloBasedSearchTime = _searchTimeForElo(elo);
        final searchTime = eloBasedSearchTime < _kSearchTime ? _kSearchTime : eloBasedSearchTime;
        final work = EvalWork(
          id: state.gameSessionId,
          enginePref: enginePrefs.enginePref,
          variant: Variant.standard,
          threads: numberOfCoresForEvaluation,
          hashSize: evaluationService.maxMemory,
          searchTime: searchTime,
          multiPv: _multiPvForElo(elo),
          threatMode: false,
          initialPosition: state.game.initialPosition,
          steps: steps,
        );
        finalEval = await evaluationService.findEval(work, minDepth: _kMinEvalDepth);
      } else {
        // In casual mode, use EvalWork for hints only (no comparison needed)
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

        finalEval = await evaluationService.findEval(work, minDepth: _kMinEvalDepth);
      }

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

      _logger.info(
        'Found ${hintMoves.length} hints with eval '
        'depth=${finalEval.depth}, score=${finalEval.evalString}',
      );

      // In practice mode, also cache the evaluation for later comparison
      if (state.game.practiceMode) {
        final playerSide = state.game.playerSide;
        final winningChances = finalEval.winningChances(playerSide);
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
  bool get canTakeback => game.playable && game.steps.length > 1 && !isEngineThinking;

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
