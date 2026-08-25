import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/engine_budget.dart';
import 'package:lichess_mobile/src/model/engine/engine_providers.dart';
import 'package:lichess_mobile/src/model/engine/opponent_level.dart';
import 'package:logging/logging.dart';

final _logger = Logger('EngineOpponent');

/// Thrown when a [EngineOpponent.findMove] request does not produce a move.
///
/// Either it was superseded by another one, or the engine was stopped or died before answering.
class MoveSearchCancelled implements Exception {
  const MoveSearchCancelled();

  @override
  String toString() => 'MoveSearchCancelled: the move search was cancelled';
}

/// An opponent that plays moves.
///
/// It knows how to turn "level 4" into UCI options and a search limit, and knows nothing about
/// evaluation, hints or practice comments — those belong to the evaluator, even when both happen
/// to be running on the same engine.
abstract class EngineOpponent {
  /// A short label for the UI: "Stockfish level 4".
  String get displayName;

  /// The opponent's move for the position reached by [moves] from [initialPosition].
  ///
  /// Throws [MoveSearchCancelled] if the search is superseded or stopped.
  Future<UCIMove> findMove({
    required Position initialPosition,
    required IList<UCIMove> moves,
    required Variant variant,
  });

  /// Abandons the search in progress, if there is one.
  void stop();
}

/// Stockfish playing at one of its levels.
///
/// The whole of "how strong is the computer" lives here: the skill level, the number of candidate
/// moves it picks from, how long it thinks and how many cores it gets.
class StockfishOpponent implements EngineOpponent {
  StockfishOpponent({required this._ref, required this.spec, required this.budget});

  final Ref _ref;
  final StockfishOpponentSpec spec;

  /// How this device's engines share it.
  final EngineBudget budget;

  StockfishLevel get level => spec.level;

  @override
  String get displayName => spec.displayName;

  Search? _search;
  Completer<UCIMove>? _pending;

  @override
  Future<UCIMove> findMove({
    required Position initialPosition,
    required IList<UCIMove> moves,
    required Variant variant,
  }) {
    _logger.info(
      'Finding a move at ply ${initialPosition.ply + moves.length}: '
      'level=${level.level}, skill=${level.skill}, cores=${level.threads}, '
      'searchTime=${level.searchTime.inMilliseconds}ms',
    );

    // Last caller wins, and the one it replaces is failed rather than left waiting: a search the
    // engine has already begun still answers, but that answer is for a position the game has
    // moved on from.
    stop();

    final completer = Completer<UCIMove>();
    _pending = completer;
    unawaited(_runSearch(completer, initialPosition, moves, variant));
    return completer.future;
  }

  Future<void> _runSearch(
    Completer<UCIMove> completer,
    Position initialPosition,
    IList<UCIMove> moves,
    Variant variant,
  ) async {
    try {
      final engine = await _ref.read(engineProvider(spec.engineSpec).future);
      if (!identical(_pending, completer)) return;

      final search = engine.search(
        SearchRequest(
          initialPosition: initialPosition,
          moves: moves,
          variant: variant,
          limit: SearchLimit.movetime(level.searchTime),
          threads: budget.threadsFor(level.threads),
          hashSize: budget.opponentHash,
          multiPv: level.multiPv,
          // The complete option set for this search. Stockfish's strength limiting works by
          // biasing the scores of slightly worse moves among the candidates, so the MultiPV above
          // is part of how weak the opponent is, not a display setting.
          options: IMap({'Skill Level': level.skill.toString()}),
          // A search from the starting position is the first move of a game.
          newGame: moves.isEmpty,
        ),
      );
      _search = search;

      final move = await search.bestMove;
      if (!identical(_pending, completer)) return;
      _pending = null;
      if (identical(_search, search)) _search = null;

      if (move == null) {
        completer.completeError(const MoveSearchCancelled());
      } else {
        completer.complete(move);
      }
    } catch (error, stackTrace) {
      if (!identical(_pending, completer)) return;
      _pending = null;
      completer.completeError(error, stackTrace);
    }
  }

  @override
  void stop() {
    _search?.stop();
    _search = null;
    final pending = _pending;
    _pending = null;
    if (pending != null && !pending.isCompleted) {
      pending.completeError(const MoveSearchCancelled());
    }
  }
}

/// The opponent for [OpponentSpec], and the engine it plays on.
///
/// Watching this is what keeps that engine alive: an offline game holds its opponent for as long
/// as it is being played, and lets go of it — and of the engine — when it ends.
final engineOpponentProvider = Provider.autoDispose.family<EngineOpponent, OpponentSpec>((
  ref,
  spec,
) {
  // Listened to rather than watched: this gives the opponent's engine the same lifetime as the
  // opponent, so that [findMove] never has to start one, without rebuilding — and so disposing —
  // the opponent every time the engine's [AsyncValue] moves on.
  ref.listen(engineProvider(spec.engineSpec), (_, _) {});

  final opponent = switch (spec) {
    final StockfishOpponentSpec stockfish => StockfishOpponent(
      ref: ref,
      spec: stockfish,
      budget: ref.read(engineBudgetProvider),
    ),
  };

  ref.onDispose(opponent.stop);

  return opponent;
}, name: 'EngineOpponentProvider');
