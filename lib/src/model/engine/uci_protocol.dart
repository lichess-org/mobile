import 'dart:async';
import 'dart:math' as math;

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:logging/logging.dart';

const minDepth = 6;
const maxPlies = 245;

class UCIProtocol {
  UCIProtocol() : _options = {'Threads': '1', 'Hash': '16', 'MultiPV': '1'};

  final _log = Logger('UCIProtocol');
  final Map<String, String> _options;
  final _evalController = StreamController<EvalResult>.broadcast();
  final _engineName = ValueNotifier<String?>(null);
  final _isComputing = ValueNotifier(false);

  /// Stream of evaluation results from the engine.
  Stream<EvalResult> get evalStream => _evalController.stream;

  /// The name of the connected engine, or null if not yet known.
  ValueListenable<String?> get engineName => _engineName;

  /// Whether the engine is currently computing.
  ValueListenable<bool> get isComputing => _isComputing;

  /// Resets the protocol state for a new engine session.
  ///
  /// This should be called when the engine is restarted to ensure
  /// the protocol can capture the new engine's name and state.
  void reset() {
    _work = null;
    _nextWork = null;
    _stopRequested = false;
    _send = null;
    _currentEval = null;
    _expectedPvs = 1;

    _options.clear();
    _options['Threads'] = '1';
    _options['Hash'] = '16';
    _options['MultiPV'] = '1';

    _engineName.value = null;
    _isComputing.value = false;
  }

  Work? _work;
  Work? _nextWork;
  bool _stopRequested = false;
  void Function(String command)? _send;
  LocalEval? _currentEval;
  int _expectedPvs = 1;

  void connected(void Function(String command) send) {
    _send = send;

    _sendAndLog('uci');
  }

  void dispose() {
    if (_work != null && _currentEval != null) {
      _evalController.sink.add((_work!, _currentEval!));
    }
    _work = null;
    _send = null;
    _evalController.close();
    _isComputing.dispose();
    _engineName.dispose();
  }

  void _sendAndLog(String command) {
    _send?.call(command);
    if (_send != null) _log.info('<<< $command');
  }

  void setOption(String name, String value) {
    if (_options[name] != value) {
      _sendAndLog('setoption name $name value $value');
      _options[name] = value;
    }
  }

  void compute(Work? nextWork, {bool newGame = false}) {
    _nextWork = nextWork;
    _stop();
    if (newGame) {
      _sendAndLog('ucinewgame');
    }
    _sendAndLog('isready');
  }

  final spaceRegex = RegExp(r'\s+');

  void received(String line) {
    _log.fine('>>> $line');
    final parts = line.trim().split(spaceRegex);
    if (parts.first == 'uciok') {
      // Affects notation only. Life would be easier if everyone would always
      // unconditionally use this mode.
      setOption('UCI_Chess960', 'true');

      _sendAndLog('ucinewgame');
      _sendAndLog('isready');
    } else if (parts.first == 'readyok') {
      _swapWork();
    } else if (parts.first == 'id' && parts[1] == 'name') {
      _engineName.value = parts.sublist(2).join(' ');
    } else if (parts.first == 'bestmove') {
      if (_work != null && _currentEval != null) {
        _evalController.sink.add((_work!, _currentEval!));
      }
      _work = null;
      _swapWork();
      return;
    } else if (_work != null && _stopRequested != true && parts.first == 'info') {
      int depth = 0;
      int nodes = 0;
      int multiPv = 1;
      int elapsedMs = 0;
      String? evalType;
      bool isMate = false;
      int? povEv;
      List<String> moves = [];
      for (int i = 1; i < parts.length; i++) {
        switch (parts[i]) {
          case 'depth':
            depth = int.parse(parts[++i]);
          case 'nodes':
            nodes = int.parse(parts[++i]);
          case 'multipv':
            multiPv = int.parse(parts[++i]);
          case 'time':
            elapsedMs = int.parse(parts[++i]);
          case 'score':
            isMate = parts[++i] == 'mate';
            povEv = int.parse(parts[++i]);
            if (i + 1 < parts.length &&
                (parts[i + 1] == 'lowerbound' || parts[i + 1] == 'upperbound')) {
              evalType = parts[++i];
            }
          case 'pv':
            moves = parts.sublist(++i);
            i = parts.length;
        }
      }

      // Track max pv index to determine when pv prints are done.
      if (_expectedPvs < multiPv) _expectedPvs = multiPv;

      if ((depth < minDepth && moves.isNotEmpty) || povEv == null) return;

      final pivot = _work!.threatMode ? Side.black : Side.white;
      final ev = _work!.position.turn == pivot ? povEv : -povEv;

      // For now, ignore most upperbound/lowerbound messages.
      // However non-primary pvs may only have an upperbound.
      if (evalType != null && multiPv == 1) return;

      final pvData = PvData(moves: IList(moves), cp: isMate ? null : ev, mate: isMate ? ev : null);

      if (multiPv == 1) {
        _currentEval = LocalEval(
          position: _work!.threatMode ? _work!.threatModePosition : _work!.position,
          searchTime: Duration(milliseconds: elapsedMs),
          depth: depth,
          nodes: nodes,
          cp: isMate ? null : ev,
          mate: isMate ? ev : null,
          pvs: IList([pvData]),
          millis: elapsedMs,
          threatMode: _work!.threatMode,
        );
      } else if (_currentEval != null) {
        _currentEval = _currentEval!.copyWith(
          pvs: _currentEval!.pvs.add(pvData),
          depth: math.min(_currentEval!.depth, depth),
        );
      }

      if (multiPv == _expectedPvs && _currentEval != null) {
        _evalController.sink.add((_work!, _currentEval!));

        if (elapsedMs > _work!.searchTime.inMilliseconds) {
          _stop();
        }
      }
    }
  }

  void _stop() {
    if (_work != null && _stopRequested != true) {
      _stopRequested = true;
      _sendAndLog('stop');
    }
  }

  void _swapWork() {
    if (_send == null || _work != null) return;

    _stopRequested = false;
    _work = _nextWork;
    _nextWork = null;

    if (_work != null) {
      _currentEval = null;
      _expectedPvs = 1;

      setOption('Threads', _work!.threads.toString());
      setOption('Hash', (_work!.hashSize ?? 16).toString());
      setOption('MultiPV', math.max(1, _work!.multiPv).toString());

      _sendAndLog(
        _work!.threatMode
            ? 'position fen ${_work!.threatModePosition.fen}'
            : [
                'position fen',
                _work!.initialPosition.fen,
                'moves',
                ..._work!.steps.map(
                  (s) => _work!.variant == Variant.chess960 ? s.sanMove.move.uci : s.castleSafeUCI,
                ),
              ].join(' '),
      );
      _sendAndLog('go movetime ${_work!.searchTime.inMilliseconds}');
      _isComputing.value = true;
    } else {
      _isComputing.value = false;
    }
  }
}
