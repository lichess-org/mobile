import 'dart:async';
import 'dart:math' as math;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/model/common/eval.dart';

import 'work.dart';

const minDepth = 6;
const maxPlies = 245;

class UCIProtocol {
  UCIProtocol()
      : _options = {
          'Threads': '1',
          'Hash': '16',
          'MultiPV': '1',
        };

  final _log = Logger('UCIProtocol');
  final Map<String, String> _options;
  final _evalController = StreamController<EvalResult>.broadcast();

  Stream<EvalResult> get evalStream => _evalController.stream;

  String? engineName;

  Work? _work;
  Work? _nextWork;
  void Function(String command)? _send;
  ClientEval? _currentEval;
  int _expectedPvs = 1;

  void connected(void Function(String command) send) {
    _send = send;

    _sendAndLog('uci');
  }

  void disconnected() {
    if (_work != null && _currentEval != null) {
      _evalController.sink.add((_work!, _currentEval!));
    }
    _work = null;
    _send = null;
    _evalController.close();
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

  void compute(Work? nextWork) {
    _nextWork = nextWork;
    _stop();
    _sendAndLog('isready');
  }

  bool isComputing() {
    return _work != null && _work!.stopRequested == false;
  }

  void received(String line) {
    final parts = line.trim().split(RegExp(r'\s+'));
    if (parts.first == 'uciok') {
      setOption('UCI_AnalyseMode', 'true');
      // Affects notation only. Life would be easier if everyone would always
      // unconditionally use this mode.
      setOption('UCI_Chess960', 'true');

      _sendAndLog('ucinewgame');
      _sendAndLog('isready');
    } else if (parts.first == 'readyok') {
      _swapWork();
    } else if (parts.first == 'id' && parts[1] == 'name') {
      engineName = parts.sublist(2).join(' ');
    } else if (parts.first == 'bestmove') {
      if (_work != null && _currentEval != null) {
        _evalController.sink.add((_work!, _currentEval!));
      }
      _work = null;
      _swapWork();
      return;
    } else if (_work != null &&
        _work!.stopRequested != true &&
        parts.first == 'info') {
      int depth = 0;
      int? nodes;
      int multiPv = 1;
      int? elapsedMs;
      String? evalType;
      bool isMate = false;
      int? povEv;
      List<String> moves = [];
      for (int i = 1; i < parts.length; i++) {
        switch (parts[i]) {
          case 'depth':
            depth = int.parse(parts[++i]);
            break;
          case 'nodes':
            nodes = int.parse(parts[++i]);
            break;
          case 'multipv':
            multiPv = int.parse(parts[++i]);
            break;
          case 'time':
            elapsedMs = int.parse(parts[++i]);
            break;
          case 'score':
            isMate = parts[++i] == 'mate';
            povEv = int.parse(parts[++i]);
            if (i + 1 < parts.length &&
                (parts[i + 1] == 'lowerbound' ||
                    parts[i + 1] == 'upperbound')) {
              evalType = parts[++i];
            }
            break;
          case 'pv':
            moves = parts.sublist(++i);
            i = parts.length;
            break;
        }
      }

      // Sometimes we get #0. Let's just skip it.
      if (isMate && povEv == 0) return;

      // Track max pv index to determine when pv prints are done.
      if (_expectedPvs < multiPv) _expectedPvs = multiPv;

      if (depth < minDepth ||
          nodes == null ||
          elapsedMs == null ||
          povEv == null) return;

      final pivot = _work!.threatMode == true ? 0 : 1;
      final ev = _work!.ply % 2 == pivot ? -povEv : povEv;

      // For now, ignore most upperbound/lowerbound messages.
      // However non-primary pvs may only have an upperbound.
      if (evalType != null && multiPv == 1) return;

      final pvData = PvData(
        moves: IList(moves),
        cp: isMate ? null : ev,
        mate: isMate ? ev : null,
      );

      if (multiPv == 1) {
        _currentEval = ClientEval(
          fen: _work!.currentFen,
          maxDepth: _work!.maxDepth,
          depth: depth,
          nodes: nodes,
          cp: isMate ? null : ev,
          mate: isMate ? ev : null,
          pvs: IList([pvData]),
          millis: elapsedMs,
        );
      } else if (_currentEval != null) {
        _currentEval = _currentEval!.copyWith(
          pvs: _currentEval!.pvs.add(pvData),
          depth: math.min(_currentEval!.depth, depth),
        );
      }

      if (multiPv == _expectedPvs && _currentEval != null) {
        _evalController.sink.add((_work!, _currentEval!));

        // Depth limits are nice in the user interface, but in clearly decided
        // positions the usual depth limits are reached very quickly due to
        // pruning. Therefore not using `go depth ${_work.maxDepth}` and
        // manually ensuring Stockfish gets to spend a minimum amount of
        // time/nodes on each position.
        if (depth >= _work!.maxDepth &&
            elapsedMs > 8000 &&
            nodes > 4000 * math.exp(_work!.maxDepth * 0.3)) {
          _stop();
        }
      }
    } else if (!['Stockfish', 'id', 'option', 'info'].contains(parts.first)) {
      _log.info(line);
    }
  }

  void _stop() {
    if (_work != null && _work!.stopRequested != true) {
      _work = _work!.copyWith(stopRequested: true);
      _sendAndLog('stop');
    }
  }

  void _swapWork() {
    if (_send == null || _work != null) return;

    _work = _nextWork;
    _nextWork = null;

    if (_work != null) {
      _currentEval = null;
      _expectedPvs = 1;

      setOption('Threads', _work!.threads.toString());
      setOption('Hash', (_work!.hashSize ?? 16).toString());
      setOption('MultiPV', math.max(1, _work!.multiPv).toString());

      _sendAndLog(
        [
          'position fen',
          _work!.initialFen,
          'moves',
          ..._work!.moves,
        ].join(' '),
      );
      _sendAndLog(
        _work!.maxDepth >= 99
            ? 'go depth $maxPlies' // 'go infinite' would not finish even if entire tree search completed
            : 'go movetime 60000',
      );
    }
  }
}
