import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/engine_budget.dart';
import 'package:lichess_mobile/src/model/engine/engine_providers.dart';
import 'package:lichess_mobile/src/model/engine/opponent_level.dart';
import 'package:lichess_mobile/src/model/engine/thinking_time.dart';
import 'package:lichess_mobile/src/model/engine/weights_service.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

final _logger = Logger('EngineOpponent');

/// The softmax temperature LC0 turns the network's policy logits into priors with.
///
/// Pinned to 1, which is the temperature Maia's policy head was trained at, so that the priors are
/// the distribution the network actually learned. LC0's own default is 1.359 — a value chosen to
/// widen a *search*, which is the opposite of what we want from a network whose output is already
/// the answer.
const _kMaiaPolicyTemperature = 1.0;

/// How much of Maia's policy to sample, rather than always playing the move it likes best.
///
/// Read against [_kMaiaPolicyTemperature], which fixes the scale: 1 samples the network's human
/// distribution exactly as trained, below 1 sharpens towards its favourite move, and above 1
/// flattens towards the tail — the range LC0 accepts runs to 100, which is very nearly a uniform
/// pick among legal moves. 0 turns sampling off and takes the top move every time.
const _kMaiaTemperature = 0.8;

/// How long the temperature holds before it starts falling, and over how many moves it reaches 0.
///
/// Variety is worth most in the opening, where there really are several reasonable human choices,
/// and worst in a sharp endgame, where sampling the 3% move throws the game away.
const _kMaiaTempDecayDelayMoves = 10;
const _kMaiaTempDecayMoves = 30;

/// The floor the decay above never falls through, so that a long game does not become deterministic.
const _kMaiaTempEndgame = 0.2;

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
  /// [sharesEngineWithEvaluator] is the caller's answer to a question the opponent cannot see: on
  /// every variant it plays on the same engine as the evaluator computing the game's hints, and
  /// the two roles then have to ask that engine for the same `Threads`. Anything else tears the
  /// thread pool down and rebuilds it — clearing the transposition table with it — on every
  /// hand-off between them, several times a move. See [EngineBudget].
  ///
  /// Throws [MoveSearchCancelled] if the search is superseded or stopped.
  Future<UCIMove> findMove({
    required Position initialPosition,
    required IList<UCIMove> moves,
    required Variant variant,
    bool sharesEngineWithEvaluator = false,
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
    required bool sharesEngineWithEvaluator,
  });

  /// How long this opponent should appear to have taken, measured from the start of the search.
  ///
  /// A wait, not a search limit: [move] is already decided by the time this is asked, and nothing
  /// here changes it. The default is nothing, because an engine whose own search time already
  /// paces it — Stockfish thinks for half a second to two seconds — needs no wait on top.
  @protected
  Duration thinkingTimeFor({
    required Position initialPosition,
    required IList<UCIMove> moves,
    required UCIMove move,
  }) => Duration.zero;

  @override
  Future<UCIMove> findMove({
    required Position initialPosition,
    required IList<UCIMove> moves,
    required Variant variant,
    bool sharesEngineWithEvaluator = false,
  }) {
    stop();

    final completer = Completer<UCIMove>();
    _pending = completer;
    unawaited(_runSearch(completer, initialPosition, moves, variant, sharesEngineWithEvaluator));
    return completer.future;
  }

  Future<void> _runSearch(
    Completer<UCIMove> completer,
    Position initialPosition,
    IList<UCIMove> moves,
    Variant variant,
    bool sharesEngineWithEvaluator,
  ) async {
    // Started before anything else, so that the wait below covers the search rather than being
    // added to it: an opponent that takes two seconds takes two seconds whether its engine
    // answered instantly or after a second and a half.
    final elapsed = Stopwatch()..start();

    try {
      final request = await buildRequest(
        initialPosition: initialPosition,
        moves: moves,
        variant: variant,
        sharesEngineWithEvaluator: sharesEngineWithEvaluator,
      );
      if (!identical(_pending, completer)) return;

      final engine = await ref.read(engineProvider(spec.engineSpec).future);
      if (!identical(_pending, completer)) return;

      final search = engine.search(request);
      _search = search;

      final move = await search.bestMove;
      if (!identical(_pending, completer)) return;
      if (identical(_search, search)) _search = null;

      if (move == null) {
        _pending = null;
        completer.completeError(const MoveSearchCancelled());
        return;
      }

      // [_pending] deliberately still points at this search: a stop during the wait has to be able
      // to cancel it, and clearing it early would leave the caller waiting on a completer nobody
      // owns any more.
      final remaining =
          thinkingTimeFor(initialPosition: initialPosition, moves: moves, move: move) -
          elapsed.elapsed;
      if (remaining > Duration.zero) {
        await Future<void>.delayed(remaining);
        if (!identical(_pending, completer)) return;
      }

      _pending = null;
      completer.complete(move);
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
    required bool sharesEngineWithEvaluator,
  }) async {
    final threads = budget.opponentThreads(
      sharesEngineWithEvaluator: sharesEngineWithEvaluator,
      threads: level.threads,
    );

    _logger.info(
      'Finding a move at ply ${initialPosition.ply + moves.length}: '
      'level=${level.level}, skill=${level.skill}, cores=$threads, '
      'searchTime=${level.searchTime.inMilliseconds}ms'
      '${sharesEngineWithEvaluator ? ' (engine shared with the evaluator)' : ''}',
    );

    return SearchRequest(
      initialPosition: initialPosition,
      moves: moves,
      variant: variant,
      limit: SearchLimit.movetime(level.searchTime),
      threads: threads,
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
/// There is no search to speak of. Maia is a policy network, and what makes it play like a human of
/// its rating is which moves that network expects such a human to choose, not the move a tree
/// search rescues — so it runs at one node, samples the policy rather than taking its top move (see
/// [_kMaiaTemperature]), and none of the strength dials [StockfishOpponent] turns apply.
class MaiaOpponent extends EngineOpponentBase<MaiaOpponentSpec> {
  MaiaOpponent({
    required super.ref,
    required super.spec,
    required this.weights,
    required this.thinkingTime,
  });

  @protected
  final MaiaWeightsService weights;

  /// How long it sits on a move before playing it. Maia answers in a few tens of milliseconds, and
  /// a move that lands the instant you finish yours is the most obviously inhuman thing about it.
  @protected
  final ThinkingTime thinkingTime;

  MaiaRating get rating => spec.rating;

  @override
  Duration thinkingTimeFor({
    required Position initialPosition,
    required IList<UCIMove> moves,
    required UCIMove move,
  }) {
    final chosen = Move.parse(move);
    final position = _replay(initialPosition, moves);
    if (chosen == null || position == null) return Duration.zero;

    return thinkingTime.forMove(
      position: position,
      move: chosen,
      lastMove: moves.isEmpty ? null : Move.parse(moves.last),
    );
  }

  /// The position the opponent is moving from.
  ///
  /// Replayed rather than passed in, because [EngineOpponent.findMove] speaks UCI's language — a
  /// start position and the moves since. Null if the game cannot be replayed, which would be a bug
  /// elsewhere and is not worth failing a move over: the opponent just answers at once.
  Position? _replay(Position initialPosition, IList<UCIMove> moves) {
    try {
      var position = initialPosition;
      for (final uci in moves) {
        final move = Move.parse(uci);
        if (move == null) return null;
        position = position.play(move);
      }
      return position;
    } catch (e, st) {
      _logger.warning('Could not replay the game to time the opponent', e, st);
      return null;
    }
  }

  @override
  Future<SearchRequest> buildRequest({
    required Position initialPosition,
    required IList<UCIMove> moves,
    required Variant variant,
    // Maia is LC0 and the evaluator is always a Stockfish, so they never share an engine.
    required bool sharesEngineWithEvaluator,
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
      options: IMap({
        'WeightsFile': path,
        // A minibatch is a set of positions evaluated together, and at one node there is only ever
        // the one, so the default of 256 would size buffers for work that never arrives.
        'MinibatchSize': '1',
        'PolicyTemperature': '$_kMaiaPolicyTemperature',
        'Temperature': '$_kMaiaTemperature',
        'TempDecayDelayMoves': '$_kMaiaTempDecayDelayMoves',
        'TempDecayMoves': '$_kMaiaTempDecayMoves',
        'TempEndgame': '$_kMaiaTempEndgame',
      }),
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
      thinkingTime: ref.read(thinkingTimeProvider),
    ),
  };

  ref.onDispose(opponent.stop);

  return opponent;
}, name: 'EngineOpponentProvider');
