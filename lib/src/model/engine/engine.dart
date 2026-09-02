import 'dart:async';
import 'dart:math' as math;

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/engine/engine_diagnostics.dart';
import 'package:lichess_mobile/src/model/engine/engine_failure.dart';
import 'package:lichess_mobile/src/model/engine/engine_slot.dart';
import 'package:lichess_mobile/src/model/engine/engine_spec.dart';
import 'package:lichess_mobile/src/model/engine/engine_transport.dart';
import 'package:lichess_mobile/src/model/engine/engine_utils.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Engine');

final _spaceRegex = RegExp(r'\s+');

/// The keywords that end an option's `default` value in a UCI `option` declaration.
const _optionValueTerminators = {'min', 'max', 'var'};

/// Defaults for the options the app sets, used when the engine did not declare its own.
///
/// The declarations from the `uci` handshake are the real source (see [Engine._declaredDefaults]);
/// this is the fallback that keeps option hygiene working against an engine — or a fake — that
/// answers `uciok` without listing what it supports.
const _fallbackOptionDefaults = {
  'Threads': '1',
  'Hash': '16',
  'MultiPV': '1',
  'Skill Level': '20',
  'UCI_Chess960': 'false',
  'UCI_Variant': 'chess',
  'UCI_LimitStrength': 'false',
  // LC0's sampling options.
  'Temperature': '0',
  'TempDecayMoves': '0',
  'TempDecayDelayMoves': '0',
  'TempEndgame': '0',
};

/// How long a search may run.
sealed class SearchLimit {
  const SearchLimit();

  const factory SearchLimit.movetime(Duration duration) = MoveTimeLimit;
  const factory SearchLimit.nodes(int nodes) = NodesLimit;
  const factory SearchLimit.depth(int depth) = DepthLimit;
  const factory SearchLimit.infinite() = InfiniteLimit;
}

final class MoveTimeLimit extends SearchLimit {
  const MoveTimeLimit(this.duration);
  final Duration duration;
}

final class NodesLimit extends SearchLimit {
  const NodesLimit(this.nodes);
  final int nodes;
}

final class DepthLimit extends SearchLimit {
  const DepthLimit(this.depth);
  final int depth;
}

final class InfiniteLimit extends SearchLimit {
  const InfiniteLimit();
}

/// Everything a search needs, and nothing about why it was asked for.
@immutable
class SearchRequest {
  const SearchRequest({
    required this.initialPosition,
    required this.moves,
    required this.variant,
    required this.limit,
    this.fenOverride,
    this.threads = 1,
    this.multiPv = 1,
    this.options = const IMapConst({}),
    this.newGame = false,
  });

  /// The position the [moves] are played from.
  final Position initialPosition;

  /// The moves leading to the position to search, already normalised for [variant].
  final IList<UCIMove> moves;

  /// The variant being played. Sent as `UCI_Variant` to an engine that has the option.
  final Variant variant;

  final SearchLimit limit;

  /// A position to search instead of the one [moves] leads to — threat mode searches a doctored
  /// FEN that no sequence of moves can reach.
  final String? fenOverride;

  final int threads;
  final int multiPv;

  /// The complete option set for this search, beyond the ones named above.
  final IMap<String, String> options;

  /// Whether the engine should be told this is a new game before the search.
  final bool newGame;
}

/// One `info` line, in the engine's point of view.
@immutable
class UciInfo {
  const UciInfo({
    required this.depth,
    required this.nodes,
    required this.multiPv,
    required this.elapsed,
    required this.pv,
    this.cp,
    this.mate,
    this.isLowerBound = false,
    this.isUpperBound = false,
  });

  final int depth;
  final int nodes;
  final int multiPv;
  final Duration elapsed;
  final IList<UCIMove> pv;

  /// Centipawns, from the point of view of the side to move. Null for a mate score.
  final int? cp;

  /// Moves to mate, from the point of view of the side to move. Null for a centipawn score.
  final int? mate;

  final bool isLowerBound;
  final bool isUpperBound;
}

/// A search in progress.
abstract class Search {
  /// The request this search was started for.
  SearchRequest get request;

  /// The engine's `info` lines for this search. Closed when the search ends.
  Stream<UciInfo> get infos;

  /// The engine's `bestmove`, or null if the search was superseded, stopped before the engine
  /// answered, or cut short by the engine dying.
  Future<UCIMove?> get bestMove;

  /// Asks the engine to stop. It still emits results until its `bestmove`.
  void stop();
}

/// A UCI engine.
///
/// Owns the option state — so `setoption` is only sent when the value actually changes, and an
/// option one search set is returned to its default before the next one runs — the
/// `isready`/`readyok` handshake, and the arbitration of who gets to search: an engine runs one
/// search at a time, whoever is asking.
///
/// It has no idea whether it is being used to analyse or to play. Skill levels, evaluation
/// perspective and search-time policy all live above it.
class Engine {
  Engine(this._transport, {this.hashSizeInMb = 16}) {
    _linesSubscription = _transport.lines.listen(_onLine);
    unawaited(_transport.death.then(_onDeath));
  }

  final EngineTransport _transport;

  late final StreamSubscription<String> _linesSubscription;

  /// The option values currently set on the engine, seeded with the defaults it declared.
  final Map<String, String> _options = {};

  /// The defaults the engine declared in its `uci` handshake.
  final Map<String, String> _declaredDefaults = {};

  final _name = ValueNotifier<String?>(null);
  final _isSearching = ValueNotifier(false);

  _RunningSearch? _running;
  _RunningSearch? _next;
  bool _stopRequested = false;

  /// Whether `ucinewgame` is owed to the engine before the next search. True to begin with: a
  /// fresh engine has never been told what it is playing.
  bool _newGamePending = true;
  bool _disposed = false;

  /// The variant of the last search started, so that a failure can name what the engine was doing.
  Variant? _lastVariant;

  /// The transposition table this engine was created with, in MB.
  ///
  /// A creation parameter and not a search one, because **the table belongs to the engine**:
  /// `setoption name Hash` frees the old table and allocates and zeroes a new one, synchronously,
  /// on the thread running the UCI loop — so an engine two callers shared, each asking for a
  /// different size, would rebuild its table on every hand-off and be unable to read a command,
  /// `quit` included, while it did. That is not a hypothetical: on a variant offline game the
  /// opponent and the evaluator are literally the same engine.
  final int hashSizeInMb;

  EngineSpec get spec => _transport.spec;

  /// Whether [dispose] has been called. The engine may still be exiting; [death] says when it is
  /// actually gone.
  bool get isDisposed => _disposed;

  /// The engine's `id name`, e.g. "Stockfish 16.1", "Fairy-Stockfish 14".
  ValueListenable<String?> get name => _name;

  /// Whether a search is running.
  ValueListenable<bool> get isSearching => _isSearching;

  /// Completes when the engine is gone, with the failure if it died badly.
  ///
  /// The transport's own death, with what only this layer knows — the variant that was being
  /// searched, and the size of the table the engine was carrying — added to the failure.
  late final Future<EngineFailure?> death = _transport.death.then(
    (failure) => failure?.withContext(variant: _lastVariant, hashSizeInMb: hashSizeInMb),
  );

  /// Whether the engine is gone, which is [death] asked synchronously.
  bool get isDead => _transport.isDead;

  EngineDiagnostics? get diagnostics => _transport.diagnostics;

  /// Starts a search, replacing whatever was running or pending.
  ///
  /// The running search is stopped, its `bestmove` is waited for, and the new one starts. Returns
  /// as soon as the request is accepted; results arrive on the returned [Search].
  Search search(SearchRequest request) {
    final search = _RunningSearch(request).._engine = this;

    if (_disposed || _transport.isDead) {
      _logger.warning('Refusing a search: the engine is gone.');
      search._finish(null);
      return search;
    }

    _next?._finish(null);
    _next = search;
    if (request.newGame) _newGamePending = true;
    _stopRunning();

    // Before the handshake, not after it: clearing the hash takes the engine a moment, and
    // `readyok` is how it says it is done. This is the order the protocol asks for, and the one
    // the app has always used.
    if (_newGamePending) {
      _newGamePending = false;
      search._newGameSent = true;
      _transport.send('ucinewgame');
    }

    _transport.send('isready');
    return search;
  }

  /// Stops the current search and drops any pending one.
  void stop() {
    _next?._finish(null);
    _next = null;
    _stopRunning();
  }

  /// Tells the engine the next search belongs to a different game.
  ///
  /// The `ucinewgame` command itself is deferred to the moment the next search starts, because the
  /// engine must not be searching when it arrives.
  void newGame() {
    _newGamePending = true;
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _next?._finish(null);
    _next = null;
    _running?._finish(null);
    _running = null;
    // Not awaited: cancelling a stream subscription takes an event-loop turn, and putting one in
    // front of the quit would delay every caller waiting on this engine to be gone — the next
    // create, most of all. [_onLine] ignores whatever arrives in the meantime.
    unawaited(_linesSubscription.cancel());
    await _transport.dispose();
    _name.dispose();
    _isSearching.dispose();
  }

  // ---------------------------------------------------------------------------
  // Engine output
  // ---------------------------------------------------------------------------

  void _onLine(String line) {
    if (_disposed) return;
    final parts = line.trim().split(_spaceRegex);
    switch (parts.first) {
      case 'id' when parts.length > 2 && parts[1] == 'name':
        _name.value = parts.sublist(2).join(' ');
      case 'option':
        _parseOptionDeclaration(parts);
      case 'uciok':
        // Every option is at its default until we change one, so the declarations are also the
        // engine's current state — which is what makes `setoption` deduplication correct from the
        // first search rather than from the first time we happen to set something.
        _options.addAll(_declaredDefaults);
      case 'readyok':
        _swapSearch();
      case 'bestmove':
        _onBestMove(parts);
      case 'info' when !_stopRequested:
        _onInfo(parts);
    }
  }

  void _onBestMove(List<String> parts) {
    final finished = _running;
    _running = null;
    final move = parts.length > 1 && parts[1] != '(none)' ? parts[1] : null;
    finished?._finish(move);
    // [_swapSearch] is what settles [isSearching]: a search that is immediately followed by
    // another must not look like a pause to whoever is watching.
    _swapSearch();
  }

  void _onInfo(List<String> parts) {
    final running = _running;
    if (running == null) return;
    final info = _parseInfo(parts);
    if (info != null) running._emit(info);
  }

  void _onDeath(EngineFailure? failure) {
    if (_disposed) return;
    // Nothing is going to answer the searches that were in flight, so their callers are released
    // rather than left waiting on an engine that no longer exists.
    _next?._finish(null);
    _next = null;
    _running?._finish(null);
    _running = null;
    _isSearching.value = false;
  }

  UciInfo? _parseInfo(List<String> parts) {
    int depth = 0;
    int nodes = 0;
    int multiPv = 1;
    int elapsedMs = 0;
    bool isMate = false;
    bool isLowerBound = false;
    bool isUpperBound = false;
    int? score;
    IList<UCIMove> pv = const IListConst([]);

    for (int i = 1; i < parts.length; i++) {
      if (i + 1 >= parts.length && parts[i] != 'pv') break;
      switch (parts[i]) {
        case 'depth':
          depth = int.tryParse(parts[++i]) ?? depth;
        case 'nodes':
          nodes = int.tryParse(parts[++i]) ?? nodes;
        case 'multipv':
          multiPv = int.tryParse(parts[++i]) ?? multiPv;
        case 'time':
          elapsedMs = int.tryParse(parts[++i]) ?? elapsedMs;
        case 'score':
          isMate = parts[++i] == 'mate';
          if (i + 1 >= parts.length) return null;
          score = int.tryParse(parts[++i]);
          if (score == null) return null;
          if (i + 1 < parts.length &&
              (parts[i + 1] == 'lowerbound' || parts[i + 1] == 'upperbound')) {
            isLowerBound = parts[++i] == 'lowerbound';
            isUpperBound = !isLowerBound;
          }
        case 'pv':
          pv = IList(parts.sublist(++i));
          i = parts.length;
      }
    }

    if (score == null) return null;

    return UciInfo(
      depth: depth,
      nodes: nodes,
      multiPv: multiPv,
      elapsed: Duration(milliseconds: elapsedMs),
      pv: pv,
      cp: isMate ? null : score,
      mate: isMate ? score : null,
      isLowerBound: isLowerBound,
      isUpperBound: isUpperBound,
    );
  }

  void _parseOptionDeclaration(List<String> parts) {
    // option name <name…> type <type> [default <value…>] [min …] [max …] [var …]
    int i = 1;
    if (i >= parts.length || parts[i] != 'name') return;
    i++;
    final name = <String>[];
    while (i < parts.length && parts[i] != 'type') {
      name.add(parts[i++]);
    }
    if (name.isEmpty) return;
    // A `button` has no value to hold. Recording one would put it in [_options], where option
    // hygiene could later "reset" it — and setting a button is what presses it, so resetting
    // `Clear Hash` would wipe the transposition table.
    if (i + 1 < parts.length && parts[i + 1] == 'button') return;

    String? value;
    while (i < parts.length) {
      if (parts[i] == 'default') {
        final tokens = <String>[];
        i++;
        while (i < parts.length && !_optionValueTerminators.contains(parts[i])) {
          tokens.add(parts[i++]);
        }
        value = tokens.join(' ');
        break;
      }
      i++;
    }

    // A `string` option with no value declares `default <empty>`.
    _declaredDefaults[name.join(' ')] = value == null || value == '<empty>' ? '' : value;
  }

  // ---------------------------------------------------------------------------
  // Search scheduling
  // ---------------------------------------------------------------------------

  /// Stops [search], whether it is running or still waiting its turn.
  void _stopSearch(_RunningSearch search) {
    if (identical(_next, search)) {
      _next = null;
      search._finish(null);
      return;
    }
    if (identical(_running, search)) _stopRunning();
  }

  void _stopRunning() {
    if (_running != null && !_stopRequested) {
      _stopRequested = true;
      _transport.send('stop');
    }
  }

  /// Starts the pending search, if the engine is free to take it.
  ///
  /// Called from `readyok` and from `bestmove`, so a search requested while another one is running
  /// starts as soon as the engine has answered the one it replaces.
  void _swapSearch() {
    if (_disposed || _running != null) return;

    _stopRequested = false;
    final next = _next;
    _next = null;

    if (next == null) {
      _isSearching.value = false;
      return;
    }

    _running = next;
    _lastVariant = next.request.variant;

    // Fairy-Stockfish rebuilds its rules when the variant changes, and it must not still be
    // holding a position set up under the old ones. This one cannot go in front of the handshake
    // like the [newGame] above, because the option it answers is only sent here.
    final variantChanged = _applyOptions(next.request);
    if (variantChanged && !next._newGameSent) _transport.send('ucinewgame');

    _transport.send(_positionCommand(next.request));
    _transport.send('go ${_goArguments(next.request.limit)}');
    _isSearching.value = true;
  }

  /// Brings the engine's options in line with [request], and says whether the variant changed.
  bool _applyOptions(SearchRequest request) {
    // What [Engine] asks for on its own behalf. These names are Stockfish's vocabulary and are a
    // guess at any other engine's — LC0 has no `Hash`, and sending it one is an
    // `error Unknown option` on every search — so they are dropped when the engine did not declare
    // them. The caller's own options are not: it named them deliberately, and an engine may accept
    // an option it does not advertise (LC0's `Temperature` is declared "pro only" and never
    // listed).

    // `Threads` before `Hash`, and the order is load-bearing. Setting `Threads` reallocates and
    // zeroes the table at whatever `Hash` currently is, so on a new engine this way round costs one
    // zeroing of the 16MB default plus one of the real size; the other way round costs two of the
    // real size. See `EngineBudget`.
    final own = <String, String>{
      'Threads': math.min(request.threads, maxEngineCores).toString(),
      // Not from the request: see [hashSizeInMb]. Sent once, on the first search, and then held by
      // the deduplication in [_setOption] for the life of the engine.
      'Hash': hashSizeInMb.toString(),
      'MultiPV': math.max(1, request.multiPv).toString(),
      // Affects notation only. Life would be easier if everyone would always unconditionally use
      // this mode.
      'UCI_Chess960': 'true',
      if (spec.slot == EngineSlot.fairy) 'UCI_Variant': request.variant.fairy,
    }..removeWhere((name, _) => !_declaresOption(name));

    final wanted = {...own, ...request.options.unlock};

    final variantChanged =
        wanted.containsKey('UCI_Variant') && _options['UCI_Variant'] != wanted['UCI_Variant'];

    // Options this search does not name go back to their default first, so that it cannot inherit
    // anything from whoever ran last.
    for (final name in _options.keys.toList()) {
      if (wanted.containsKey(name)) continue;
      final fallback = _declaredDefaults[name] ?? _fallbackOptionDefaults[name];
      if (fallback == null) {
        _logger.warning('Cannot reset the option "$name": the engine never declared its default.');
        continue;
      }
      _setOption(name, fallback);
    }

    for (final MapEntry(key: name, value: value) in wanted.entries) {
      _setOption(name, value);
    }

    return variantChanged;
  }

  /// Whether the engine declared [name] in its handshake.
  ///
  /// An engine that declared nothing at all is taken at its word instead, because refusing every
  /// option would leave it running on its own defaults; that is the case
  /// [_fallbackOptionDefaults] exists for.
  bool _declaresOption(String name) =>
      _declaredDefaults.isEmpty || _declaredDefaults.containsKey(name);

  void _setOption(String name, String value) {
    if (_options[name] == value) return;
    _options[name] = value;
    _transport.send('setoption name $name value $value');
  }

  String _positionCommand(SearchRequest request) {
    if (request.fenOverride case final fen?) return 'position fen $fen';
    return [
      'position fen',
      request.initialPosition.fen,
      if (request.moves.isNotEmpty) ...['moves', ...request.moves],
    ].join(' ');
  }

  String _goArguments(SearchLimit limit) => switch (limit) {
    MoveTimeLimit(:final duration) => 'movetime ${duration.inMilliseconds}',
    NodesLimit(:final nodes) => 'nodes $nodes',
    DepthLimit(:final depth) => 'depth $depth',
    InfiniteLimit() => 'infinite',
  };
}

class _RunningSearch implements Search {
  _RunningSearch(this.request);

  @override
  final SearchRequest request;

  /// Whether `ucinewgame` was already sent on this search's behalf, so that a variant change does
  /// not send a second one.
  bool _newGameSent = false;

  final _infos = StreamController<UciInfo>.broadcast();
  final _bestMove = Completer<UCIMove?>();

  Engine? _engine;

  @override
  Stream<UciInfo> get infos => _infos.stream;

  @override
  Future<UCIMove?> get bestMove => _bestMove.future;

  @override
  void stop() {
    if (_bestMove.isCompleted) return;
    _engine?._stopSearch(this);
  }

  void _emit(UciInfo info) {
    if (!_infos.isClosed) _infos.add(info);
  }

  /// Ends the search, with the engine's answer or null if there will not be one.
  void _finish(UCIMove? move) {
    if (!_bestMove.isCompleted) _bestMove.complete(move);
    if (!_infos.isClosed) _infos.close();
  }
}
