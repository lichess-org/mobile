import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:http/http.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/engine/engine_diagnostics.dart';
import 'package:lichess_mobile/src/model/engine/engine_failure.dart';
import 'package:lichess_mobile/src/model/engine/engine_spec.dart';
import 'package:lichess_mobile/src/model/engine/engine_transport.dart';
import 'package:logging/logging.dart';

final _spaceRegex = RegExp(r'\s+');

/// What the lichess website says when the broker finds no provider for the engine.
const _notConnectedMessage =
    'Your external engine does not appear to be connected. '
    'Please check the network and restart your provider if possible.';

/// The broker has no `go infinite`; this is what the lichess website sends instead.
const _infiniteSearchTime = Duration(hours: 24);

const _variantOptionDeclaration =
    'option name UCI_Variant type combo default chess var chess var crazyhouse var antichess '
    'var atomic var horde var kingofthehill var racingkings var 3check';

const _sessionIdAlphabet = 'abcdefghijklmnopqrstuvwxyz0123456789';

final _sessionIdRandom = Random.secure();

String _newSessionId() => List.generate(
  12,
  (_) => _sessionIdAlphabet[_sessionIdRandom.nextInt(_sessionIdAlphabet.length)],
).join();

/// An [EngineTransport] for an engine reached through the Lichess engine broker.
///
/// One search is one HTTP request. The position and options a UCI engine would keep between
/// commands are held here and sent with each search.
class ExternalEngineTransport._(@override final ExternalEngineSpec spec, final Client _client)
    implements EngineTransport {
  this {
    _controller.onListen = _replayStartupLines;
  }

  final _logger = Logger('ExternalEngineTransport');

  /// There is no handshake: the `uci` reply is built from the registration.
  static Future<ExternalEngineTransport> connect(ExternalEngineSpec spec, Client client) {
    final transport = ExternalEngineTransport._(spec, client);
    transport._startupLines.addAll([
      'id name ${spec.engine.name}',
      // The only options the broker takes. Threads and Hash always use the registration's maxima.
      'option name MultiPV type spin default 1 min 1 max 256',
      _variantOptionDeclaration,
      'uciok',
    ]);
    return Future.value(transport);
  }

  final _controller = StreamController<String>.broadcast();
  final _death = Completer<EngineFailure?>();

  /// The lines the engine "wrote" before anyone could listen, replayed to the first listener.
  final List<String> _startupLines = [];
  bool _replayed = false;

  bool _disposing = false;

  /// Names the run of searches the provider is filling a hash table for.
  String _sessionId = _newSessionId();

  int _multiPv = 1;
  String _variant = 'chess';
  String _initialFen = kInitialFEN;
  List<String> _moves = const [];
  Side _sideToMove = .white;

  StreamSubscription<String>? _subscription;

  /// Bumped by `stop` or a newer `go`, so the answers of an abandoned search are dropped.
  int _searchGeneration = 0;
  bool _searching = false;
  String? _bestMove;

  @override
  Stream<String> get lines => _controller.stream;

  @override
  Future<EngineFailure?> get death => _death.future;

  @override
  bool get isDead => _death.isCompleted;

  @override
  EngineDiagnostics? get diagnostics => null;

  @override
  void send(String command) {
    if (_disposing || isDead) {
      _logger.fine('Dropping "$command": the engine is gone or on its way out.');
      return;
    }
    final parts = command.trim().split(_spaceRegex);
    switch (parts.first) {
      // Providers clear their hash table when the session changes.
      case 'ucinewgame':
        _sessionId = _newSessionId();
      case 'isready':
        _receive('readyok');
      case 'setoption':
        _setOption(parts);
      case 'position':
        _setPosition(parts);
      case 'go':
        _startSearch(parts);
      case 'stop':
        _finishSearch();
    }
  }

  @override
  Future<void> dispose() {
    if (_disposing) return Future.value();
    _disposing = true;
    _abandonSearch();
    _die(null);
    return Future.value();
  }

  void _setOption(List<String> parts) {
    final valueIndex = parts.indexOf('value');
    if (parts.length < 5 || parts[1] != 'name' || valueIndex == -1) return;
    final name = parts.sublist(2, valueIndex).join(' ');
    final value = parts.sublist(valueIndex + 1).join(' ');
    switch (name) {
      case 'MultiPV':
        _multiPv = int.tryParse(value) ?? _multiPv;
      case 'UCI_Variant':
        _variant = value;
    }
  }

  /// Reads `position fen <fen> [moves …]`. [Engine] never sends the `startpos` form.
  void _setPosition(List<String> parts) {
    if (parts.length < 3 || parts[1] != 'fen') return;
    final movesIndex = parts.indexOf('moves');
    final fenFields = parts.sublist(2, movesIndex == -1 ? parts.length : movesIndex);

    _initialFen = fenFields.join(' ');
    _moves = movesIndex == -1 ? const [] : parts.sublist(movesIndex + 1);

    final Side start = fenFields.length > 1 && fenFields[1] == 'b' ? .black : .white;
    _sideToMove = _moves.length.isEven ? start : start.opposite;
  }

  void _startSearch(List<String> parts) {
    final limit = _limitOf(parts);
    if (limit == null) {
      _logger.fine('Dropping "${parts.join(' ')}": the broker takes no such limit.');
      return;
    }
    // [Engine] waits for a `bestmove` before the next `go`, so nothing should be running here.
    _abandonSearch();

    _searching = true;
    _bestMove = null;
    unawaited(_runSearch(limit, _searchGeneration));
  }

  Map<String, int>? _limitOf(List<String> parts) {
    if (parts.length == 2 && parts[1] == 'infinite') {
      return {'movetime': _infiniteSearchTime.inMilliseconds};
    }
    if (parts.length != 3) return null;
    final value = int.tryParse(parts[2]);
    if (value == null) return null;
    return switch (parts[1]) {
      'movetime' || 'depth' || 'nodes' => {parts[1]: value},
      _ => null,
    };
  }

  /// A failed request kills the transport: for a remote engine, the request is the engine.
  Future<void> _runSearch(Map<String, int> limit, int generation) async {
    final request =
        Request(
            'POST',
            Uri.parse(
              '$kLichessExternalEngineEndpoint/api/external-engine/${spec.engine.id}/analyse',
            ),
          )
          ..headers['Content-Type'] = 'application/json'
          ..body = jsonEncode({
            'clientSecret': spec.engine.clientSecret,
            'work': {
              'sessionId': _sessionId,
              'threads': spec.engine.maxThreads,
              'hash': spec.engine.maxHash,
              'multiPv': _multiPv,
              'variant': _variant,
              'initialFen': _initialFen,
              'moves': _moves,
              ...limit,
            },
          });

    final StreamedResponse response;
    try {
      response = await _client.send(request);
    } catch (e, st) {
      if (generation != _searchGeneration) return;
      _die(_failure('The engine broker could not be reached', error: e, stackTrace: st));
      return;
    }

    if (generation != _searchGeneration) {
      // Stopped or replaced in flight.
      _discard(response);
      return;
    }

    if (response.statusCode >= 400) {
      _discard(response);
      _die(
        _failure(
          response.statusCode == 503
              ? _notConnectedMessage
              : 'The engine broker answered ${response.statusCode}',
        ),
      );
      return;
    }

    _subscription = response.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(
          _onSearchLine,
          onDone: _finishSearch,
          onError: (Object e, StackTrace st) =>
              _die(_failure('The engine broker stopped answering', error: e, stackTrace: st)),
          cancelOnError: true,
        );
  }

  void _onSearchLine(String line) {
    if (line.trim().isEmpty) return;

    final Object? decoded;
    try {
      decoded = jsonDecode(line);
    } catch (e) {
      _logger.warning('Ignoring a line from the broker that is not JSON: $line', e);
      return;
    }
    if (decoded is! Map<String, dynamic>) return;

    final nodes = decoded['nodes'] as int? ?? 0;
    final time = decoded['time'] as int? ?? 0;
    final lineDepth = decoded['depth'] as int? ?? 0;

    if (decoded['pvs'] case final List<dynamic> pvs) {
      for (var i = 0; i < pvs.length; i++) {
        final pv = pvs[i];
        if (pv is! Map<String, dynamic>) continue;
        final score = _scoreOf(pv);
        if (score == null) continue;

        final depth = pv['depth'] as int? ?? lineDepth;
        final moves = (pv['moves'] as List<dynamic>?)?.cast<String>() ?? const <String>[];
        if (i == 0 && moves.isNotEmpty) _bestMove = moves.first;

        _receive(
          'info depth $depth multipv ${i + 1} score $score nodes $nodes time $time'
          '${moves.isEmpty ? '' : ' pv ${moves.join(' ')}'}',
        );
      }
    }

    if (decoded['bestmove'] case final String bestMove) _bestMove = bestMove;
  }

  /// The broker reports scores from White's point of view; UCI wants them from the side to move.
  String? _scoreOf(Map<String, dynamic> pv) {
    final sign = _sideToMove == .black ? -1 : 1;
    if (pv['mate'] case final int mate) return 'mate ${mate * sign}';
    if (pv['cp'] case final int cp) return 'cp ${cp * sign}';
    return null;
  }

  /// Sends `bestmove` on `stop` as well, since [Engine] waits for it before the next search.
  void _finishSearch() {
    if (!_searching) return;
    _abandonSearch();
    _receive('bestmove ${_bestMove ?? '(none)'}');
  }

  /// Lets go of a response nobody will read, so that its connection is not held open.
  void _discard(StreamedResponse response) => unawaited(response.stream.listen(null).cancel());

  void _abandonSearch() {
    _searchGeneration++;
    _searching = false;
    unawaited(_subscription?.cancel());
    _subscription = null;
  }

  void _replayStartupLines() {
    if (_replayed) return;
    _replayed = true;
    for (final line in _startupLines) {
      _receive(line);
    }
    _startupLines.clear();
  }

  void _receive(String line) {
    if (_controller.isClosed) return;
    if (_replayed) {
      _controller.add(line);
    } else {
      _startupLines.add(line);
    }
  }

  void _die(EngineFailure? failure) {
    if (_death.isCompleted) return;
    _death.complete(failure);
    if (!_controller.isClosed) _controller.close();
  }

  EngineFailure _failure(String message, {Object? error, StackTrace? stackTrace}) => EngineFailure(
    kind: .runtime,
    message: message,
    engine: spec.label,
    error: error,
    stackTrace: stackTrace,
  );
}
