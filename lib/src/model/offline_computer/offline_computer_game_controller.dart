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
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
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
import 'package:lichess_mobile/src/model/offline_computer/practice_comment.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:logging/logging.dart';
import 'package:multistockfish/multistockfish.dart';

part 'offline_computer_game_controller.freezed.dart';

final _random = Random();

final _logger = Logger('OfflineComputerGameController');

/// The number of CPU cores to use for engine evaluation.
final numberOfCoresForEvaluation = max(1, maxEngineCores - 1);

/// Max search time for hints evaluation.
const _kHintsMaxSearchTime = Duration(milliseconds: 3000);

/// Ply threshold for opening phase. Below this, we check the master database
/// to consider book moves as good regardless of engine evaluation.
const _kOpeningPlyThreshold = 30;

/// Minimum depth for which we consider the practice mode evaluation usable.
const _kEvalMinDepth = kDebugMode ? 12 : 16;

/// Stockfish flavor to use for the engine opponent and hint generation.
///
/// We use Fairy-Stockfish here for the negative skill levels and variant support.
const _kComputerStockfishFlavor = StockfishFlavor.variant;

final offlineComputerGameControllerProvider =
    NotifierProvider.autoDispose<OfflineComputerGameController, OfflineComputerGameState>(
      OfflineComputerGameController.new,
      name: 'OfflineComputerGameControllerProvider',
    );

class OfflineComputerGameController extends Notifier<OfflineComputerGameState> {
  late SocketClient socketClient;
  StreamSubscription<SocketEvent>? _socketSubscription;
  Timer? _getEvalTimer;

  @override
  OfflineComputerGameState build() {
    socketClient = ref.watch(socketPoolProvider).open(AnalysisController.socketUri);
    _socketSubscription?.cancel();
    _socketSubscription = socketClient.stream.listen(_handleSocketEvent);
    final evaluationService = ref.watch(evaluationServiceProvider);
    ref.onDispose(() {
      evaluationService.quit();
      _socketSubscription?.cancel();
      _getEvalTimer?.cancel();
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

    if (state.turn != playerSide) {
      _playEngineMove();
    } else if (casual || practiceMode) {
      _computeHints();
    }
  }

  /// Load a game from storage.
  void loadGame(SavedOfflineComputerGame savedGame) {
    final game = savedGame.game;
    state = OfflineComputerGameState(game: game, stepCursor: game.steps.length - 1);

    if (game.playable && state.turn == game.playerSide && (game.casual || game.practiceMode)) {
      _computeHints();
    } else if (game.playable && state.turn != game.playerSide) {
      _playEngineMove();
    }
  }

  void makeMove(Move move) {
    if (state.isEngineThinking || state.isEvaluatingMove || !state.game.playable) return;

    if (move case NormalMove() when isPromotionPawnMove(state.currentPosition, move)) {
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
  /// Uses the cached PV data from _computeHints as the "before" state,
  /// then evaluates the position after the move to determine how good the move was.
  /// If hint computation is still in progress, waits for it to complete first.
  ///
  /// In the opening phase (before [_kOpeningPlyThreshold]), also fetches the master
  /// database to consider book moves as good regardless of engine evaluation.
  Future<void> _makeMoveWithEvaluation(Move move) async {
    if (!state.game.practiceMode || !state.game.playable) return;

    var preMoveAnalysis = state.currentAnalysis;
    final positionBefore = state.currentPosition;
    final plyBeforeMove = state.currentPosition.ply;

    state = state.copyWith(isEvaluatingMove: true);

    final sanMove = _applyMove(move);

    final stepCursorAfterMove = state.stepCursor;

    if (!state.game.playable) {
      state = state.copyWith(isEvaluatingMove: false);
      return;
    }

    // If hints were still loading when we made the move, wait for them to complete
    // so we can get the "before" evaluation for comparison.
    // Wait time must be longer than _kHintsMaxSearchTime to account for engine startup overhead.
    if (preMoveAnalysis?.eval == null) {
      final maxWaitTime = _kHintsMaxSearchTime + const Duration(milliseconds: 1000);
      final deadline = DateTime.now().add(maxWaitTime);
      while (state.isLoadingHint && ref.mounted && DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }

      if (!ref.mounted) return;

      preMoveAnalysis = state.game.steps[stepCursorAfterMove - 1].computerAnalysis;
    }

    final preMoveEval = preMoveAnalysis?.eval;

    // If we still don't have cached evaluation, proceed without practice comment
    if (preMoveEval == null || preMoveEval.pvs.isEmpty) {
      state = state.copyWith(isEvaluatingMove: false);
      if (state.turn != state.game.playerSide) {
        _playEngineMove();
      }
      return;
    }

    final playerSide = state.game.playerSide;
    final normalizedMoveUci = sanMove.isCastles ? normalizeUci(move.uci) : move.uci;
    final matchingPv = preMoveEval.pvs.firstWhereOrNull(
      (pv) => pv.moves.isNotEmpty && pv.moves.first == normalizedMoveUci,
    );

    // Makes or updates the comment verdict to goodMove if the move is a known book move.
    if (state.game.meta.variant == Variant.standard && plyBeforeMove < _kOpeningPlyThreshold) {
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
        _playEngineMove();
      }
      return;
    }

    // Slow path: move not in computed hints PVs, evaluate the resulting position.
    _logger.info('Move not in computed hints PVs, evaluating: ${move.uci}');

    try {
      final evaluationService = ref.read(evaluationServiceProvider);

      final stepsAfter = state.game.steps
          .skip(1)
          .map((s) => Step(position: s.position, sanMove: s.sanMove!))
          .toIList();

      final workAfter = EvalWork(
        id: state.game.id,
        stockfishFlavor: _kComputerStockfishFlavor,
        variant: Variant.standard,
        threads: numberOfCoresForEvaluation,
        hashSize: evaluationService.maxMemory,
        searchTime: const Duration(milliseconds: 2000),
        // We want the fastest search here and we only need the eval
        multiPv: 1,
        threatMode: false,
        initialPosition: state.game.initialPosition,
        steps: stepsAfter,
      );

      final positionAfterMove = state.currentPosition;
      final Completer<ClientEval?> evalCompleter = Completer();

      // Launch engine eval and tablebase lookup in parallel.
      // Fallback: if neither engine nor tablebase provide an eval in time, complete with null so
      // the await below always finishes.
      Timer(const Duration(seconds: 3), () {
        if (!evalCompleter.isCompleted) {
          evalCompleter.complete(null);
        }
      });
      _getEval(workAfter, minSearchTime: const Duration(milliseconds: 500)).then((eval) {
        if (!evalCompleter.isCompleted && eval != null) {
          evalCompleter.complete(eval);
        }
      });
      if (isTablebaseRelevant(positionAfterMove)) {
        _fetchTablebaseEval(positionAfterMove).then((tablebaseEval) {
          if (!evalCompleter.isCompleted && tablebaseEval != null) {
            evalCompleter.complete(tablebaseEval);
          }
        });
      }

      final evalAfter = await evalCompleter.future;

      if (!ref.mounted) return;

      if (evalAfter != null) {
        _logger.info('Move eval: depth=${evalAfter.depth}, score=${evalAfter.evalString}');

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

  /// Gets an evaluation by requesting at the same time the local engine and a cloud eval.
  Future<ClientEval?> _getEval(EvalWork work, {Duration? minSearchTime}) {
    final evaluationService = ref.read(evaluationServiceProvider);
    final Completer<ClientEval?> completer = Completer();
    // Fallback timer in case neither engine nor cloud eval return in time (should not happen for
    // engine).
    _getEvalTimer?.cancel();
    _getEvalTimer = Timer(work.searchTime + const Duration(seconds: 2), () {
      if (!completer.isCompleted) {
        completer.complete(null);
      }
    });
    evaluationService
        .findEval(work, depthThreshold: _kEvalMinDepth, minSearchTime: minSearchTime)
        .then((eval) {
          if (!completer.isCompleted && eval != null) {
            completer.complete(eval);
          }
        });

    if (state.game.meta.variant == Variant.standard && work.position.ply < _kOpeningPlyThreshold) {
      _getCloudEval(work, numEvalLines: work.multiPv).then((cloudEval) {
        if (!completer.isCompleted && cloudEval != null) {
          completer.complete(cloudEval);
        }
      });
    }

    return completer.future;
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
    } catch (e) {
      _logger.fine('Could not get cloud eval: $e');
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
    } catch (e) {
      _logger.fine('Failed to fetch master database: $e');
      return null;
    }
  }

  /// Fetches the tablebase eval for the given position.
  ///
  /// Returns null if the network request fails or the entry is not conclusive.
  Future<ClientEval?> _fetchTablebaseEval(Position position) async {
    try {
      final client = ref.read(defaultClientProvider);
      final entry = await TablebaseRepository(client).getTablebaseEntry(position.fen);
      return _tablebaseEntryToCloudEval(entry, position);
    } catch (e) {
      _logger.fine('Could not get tablebase eval: $e');
      return null;
    }
  }

  /// Converts a tablebase entry to a [CloudEval].
  ///
  /// Returns null for non-conclusive entries (unknown, maybeWin, maybeLoss).
  CloudEval? _tablebaseEntryToCloudEval(TablebaseEntry entry, Position position) {
    final turn = position.turn;
    final int? mate;
    final int? cp;

    switch (entry.category) {
      case .win || .syzygyWin:
        // Use dtm (distance to mate in half-moves) if available, fall back to 10.
        final mateN = entry.dtm != null ? (entry.dtm!.abs() + 1) ~/ 2 : 10;
        mate = turn == .white ? mateN : -mateN;
        cp = null;
      case .loss || .syzygyLoss:
        final mateN = entry.dtm != null ? (entry.dtm!.abs() + 1) ~/ 2 : 10;
        // Opponent wins.
        mate = turn == .white ? -mateN : mateN;
        cp = null;
      case .draw || .cursedWin || .blessedLoss:
        mate = null;
        cp = 0;
      default:
        return null;
    }

    // Include the best tablebase move as the first PV move if available.
    final bestMoveUci = entry.moves.firstOrNull?.uci;
    final pvMoves = bestMoveUci != null ? [bestMoveUci].lock : IList<UCIMove>();

    return CloudEval(
      position: position,
      depth: 99,
      nodes: 0,
      pvs: [PvData(moves: pvMoves, mate: mate, cp: cp)].lock,
    );
  }

  Future<void> _playEngineMove() async {
    if (!state.game.playable) return;

    state = state.copyWith(isEngineThinking: true);

    try {
      final evaluationService = ref.read(evaluationServiceProvider);

      final steps = state.game.steps
          .skip(1)
          .map((s) => Step(position: s.position, sanMove: s.sanMove!))
          .toIList();

      final work = MoveWork(
        id: state.game.id,
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

    ref.read(evaluationServiceProvider).stop();

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

    final hintStepCursor = state.stepCursor;
    state = state.copyWith(isLoadingHint: true, hintIndex: null);

    try {
      final evaluationService = ref.read(evaluationServiceProvider);

      final steps = state.game.steps
          .skip(1)
          .map((s) => Step(position: s.position, sanMove: s.sanMove!))
          .toIList();

      final work = EvalWork(
        id: state.game.id,
        stockfishFlavor: _kComputerStockfishFlavor,
        variant: Variant.standard,
        threads: numberOfCoresForEvaluation,
        hashSize: evaluationService.maxMemory,
        searchTime: _kHintsMaxSearchTime,
        // Good balance between fast search and more lines
        multiPv: 3,
        threatMode: false,
        initialPosition: state.game.initialPosition,
        steps: steps,
      );

      final finalEval = await _getEval(
        work,
        // Let's use a longer minimal search here because of the multipv and because it is computed
        // during player's turn
        minSearchTime: const Duration(milliseconds: 1500),
      );

      if (!ref.mounted) return;

      if (finalEval == null || !state.game.playable) {
        state = state.copyWith(isLoadingHint: false);
        return;
      }

      _logger.info('Hints computed: depth=${finalEval.depth}, score=${finalEval.evalString}');

      _setStepAnalysis(hintStepCursor, ComputerAnalysis(eval: finalEval));
      state = state.copyWith(isLoadingHint: false);
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

  /// Saves a practice comment on the game step at [stepIndex].
  void _setComment(int stepIndex, PracticeComment comment) {
    _setStepAnalysis(stepIndex, ComputerAnalysis(practiceComment: comment));
  }
}

@freezed
sealed class OfflineComputerGameState with _$OfflineComputerGameState {
  const OfflineComputerGameState._();

  const factory OfflineComputerGameState({
    required OfflineComputerGame game,
    @Default(0) int stepCursor,
    @Default(null) NormalMove? promotionMove,
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
        id: sessionId,
        steps: [GameStep(position: position)].lock,
        status: GameStatus.started,
        initialFen: initialFen,
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

  /// The cached evaluation string for the current position.
  String? get cachedEvalString => currentAnalysis?.evalString;

  /// The hint moves for the current position.
  IList<Move>? get hintMoves => currentAnalysis?.hintMoves;

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
