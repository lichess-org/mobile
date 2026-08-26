import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/engine_budget.dart';
import 'package:lichess_mobile/src/model/engine/engine_providers.dart';
import 'package:lichess_mobile/src/model/engine/opponent_level.dart';
import 'package:lichess_mobile/src/model/engine/weights_service.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

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
/// It knows how to turn "level 4" or "Maia 1500" into UCI options and a search limit, and knows
/// nothing about evaluation, hints or practice comments — those belong to the evaluator, even when
/// both happen to be running on the same engine.
abstract class EngineOpponent {
  /// A short label for the UI: "Stockfish level 4", "Maia 1500".
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

/// What every opponent does around its search, which is everything except what to ask the engine.
///
/// Last caller wins: the search it replaces is failed rather than left waiting, because a search
/// the engine has already begun still answers, but that answer is for a position the game has
/// moved on from.
abstract class EngineOpponentBase<S extends OpponentSpec> implements EngineOpponent {
  EngineOpponentBase({required this.ref, required this.spec});

  @protected
  final Ref ref;

  final S spec;

  @override
  String get displayName => spec.displayName;

  Search? _search;
  Completer<UCIMove>? _pending;

  /// What to ask the engine for this position.
  ///
  /// Asynchronous because an opponent may have to get hold of something first — Maia has to find
  /// its network — and that has to happen while the caller is still waiting for a move.
  @protected
  Future<SearchRequest> buildRequest({
    required Position initialPosition,
    required IList<UCIMove> moves,
    required Variant variant,
  });

  @override
  Future<UCIMove> findMove({
    required Position initialPosition,
    required IList<UCIMove> moves,
    required Variant variant,
  }) {
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
      final request = await buildRequest(
        initialPosition: initialPosition,
        moves: moves,
        variant: variant,
      );
      if (!identical(_pending, completer)) return;

      final engine = await ref.read(engineProvider(spec.engineSpec).future);
      if (!identical(_pending, completer)) return;

      final search = engine.search(request);
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

/// Stockfish playing at one of its levels.
///
/// The whole of "how strong is the computer" lives here: the skill level, the number of candidate
/// moves it picks from, how long it thinks and how many cores it gets.
class StockfishOpponent extends EngineOpponentBase<StockfishOpponentSpec> {
  StockfishOpponent({required super.ref, required super.spec, required this.budget});

  /// How this device's engines share it.
  final EngineBudget budget;

  StockfishLevel get level => spec.level;

  @override
  Future<SearchRequest> buildRequest({
    required Position initialPosition,
    required IList<UCIMove> moves,
    required Variant variant,
  }) async {
    _logger.info(
      'Finding a move at ply ${initialPosition.ply + moves.length}: '
      'level=${level.level}, skill=${level.skill}, cores=${level.threads}, '
      'searchTime=${level.searchTime.inMilliseconds}ms',
    );

    return SearchRequest(
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
    );
  }
}

/// Maia: LC0 with a network trained on human games in one rating band.
///
/// There is no search to speak of. Maia is a policy network, and what makes it play like a human
/// of its rating is the move the network likes best, not the move a tree search rescues — so it
/// runs at one node, and none of the strength dials [StockfishOpponent] turns apply.
class MaiaOpponent extends EngineOpponentBase<MaiaOpponentSpec> {
  MaiaOpponent({required super.ref, required super.spec, required this.weights});

  @protected
  final MaiaWeightsService weights;

  MaiaRating get rating => spec.rating;

  @override
  Future<SearchRequest> buildRequest({
    required Position initialPosition,
    required IList<UCIMove> moves,
    required Variant variant,
  }) async {
    final (rating: playing, :path) = await weights.ensureWeights(rating);

    _logger.info(
      'Finding a move at ply ${initialPosition.ply + moves.length}: network=${playing.fileName}',
    );

    return SearchRequest(
      initialPosition: initialPosition,
      moves: moves,
      variant: variant,
      // One node is the whole point: the network's own move, with nothing searched on top of it.
      limit: const SearchLimit.nodes(1),
      threads: 1,
      multiPv: 1,
      // A minibatch is a set of positions evaluated together, and at one node there is only ever
      // the one, so the default of 256 would size buffers for work that never arrives.
      options: IMap({'WeightsFile': path, 'MinibatchSize': '1'}),
      newGame: moves.isEmpty,
    );
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
    final MaiaOpponentSpec maia => MaiaOpponent(
      ref: ref,
      spec: maia,
      weights: ref.read(maiaWeightsServiceProvider),
    ),
  };

  ref.onDispose(opponent.stop);

  return opponent;
}, name: 'EngineOpponentProvider');
