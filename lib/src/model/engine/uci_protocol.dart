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
  final _engineNameCompleter = Completer<String>();
  final _isComputing = ValueNotifier(false);

  Stream<EvalResult> get evalStream => _evalController.stream;

  Future<String> get engineName => _engineNameCompleter.future;

  Future<String> get bestMove => _bestMoveCompleter.future;

  Completer<String> _bestMoveCompleter = Completer();
  Work? _work;
  Work? _nextWork;
  bool _stopRequested = false;
  void Function(String command)? _send;
  LocalEval? _currentEval;
  int _expectedPvs = 1;

  ValueListenable<bool> get isComputing => _isComputing;

  void connected(void Function(String command) send) {
    _send = send;

    _sendAndLog('uci');
  }

  void dispose() {
    // this local variable only exists to allow dart to correctly infer types
    final work = _work;
    if (work is AnalysisWork && _currentEval != null) {
      _evalController.sink.add((work, _currentEval!));
    }
    _work = null;
    _send = null;
    _evalController.close();
    _isComputing.dispose();
  }

  void _sendAndLog(String command) {
    _send?.call(command);
    if (_send != null) _log.info('<<< $command');
  }

  /// It will set the option only once even if you call it multiple times
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

  void newGame() {
    _stop();
    _sendAndLog('ucinewgame');
    _sendAndLog('isready');
  }

  final spaceRegex = RegExp(r'\s+');

  void received(String line) {
    // I prefer to log every output instead of only the ones we don't deal with
    _log.info('>>> $line');
    // this local variable only exists to allow dart to correctly infer types
    final work = _work;
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
      if (!_engineNameCompleter.isCompleted) {
        _engineNameCompleter.complete(parts.sublist(2).join(' '));
      }
    } else if (parts.first == 'bestmove') {
      if (work is AnalysisWork && _currentEval != null) {
        _evalController.sink.add((work, _currentEval!));
      }
      _bestMoveCompleter.complete(parts[1]);
      _bestMoveCompleter = Completer();
      _work = null;
      _swapWork();
      return;
    } else if (work is AnalysisWork && _stopRequested != true && parts.first == 'info') {
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

      final pivot = _work.threatMode ? Side.black : Side.white;
      final ev = _work.position.turn == pivot ? povEv : -povEv;

      // For now, ignore most upperbound/lowerbound messages.
      // However non-primary pvs may only have an upperbound.
      if (evalType != null && multiPv == 1) return;

      final pvData = PvData(moves: IList(moves), cp: isMate ? null : ev, mate: isMate ? ev : null);

      if (multiPv == 1) {
        _currentEval = LocalEval(
          position: work.threatMode ? work.threatModePosition : work.position,
          searchTime: Duration(milliseconds: elapsedMs),
          depth: depth,
          nodes: nodes,
          cp: isMate ? null : ev,
          mate: isMate ? ev : null,
          pvs: IList([pvData]),
          millis: elapsedMs,
          threatMode: work.threatMode,
        );
      } else if (_currentEval != null) {
        _currentEval = _currentEval!.copyWith(
          pvs: _currentEval!.pvs.add(pvData),
          depth: math.min(_currentEval!.depth, depth),
        );
      }

      if (multiPv == _expectedPvs && _currentEval != null) {
        _evalController.sink.add((work, _currentEval!));

        // why do we need this condition ?
        // if (elapsedMs > work.searchTime.inMilliseconds) {
        //  _stop();
        //}
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
      // this local variable only exists to allow dart to correctly infer types
      final work = _work!;
      _currentEval = null;
      _expectedPvs = 1;

      setOption('Threads', work.threads.toString());
      setOption('Hash', (work.hashSize ?? 16).toString());
      setOption('MultiPV', math.max(1, work.multiPv).toString());

      switch (work) {
        case AnalysisWork():
          _sendAndLog(
            work.threatMode
                ? 'position fen ${work.threatModePosition.fen}'
                : [
                    'position fen',
                    work.initialPosition.fen,
                    'moves',
                    ...work.steps.map(
                      (s) =>
                          work.variant == Variant.chess960 ? s.sanMove.move.uci : s.castleSafeUCI,
                    ),
                  ].join(' '),
          );
          _sendAndLog('go movetime ${work.searchTime.inMilliseconds}');
        case MoveWork():
          setOption('UCI_LimitStrength', 'true');
          setOption('UCI_Elo', work.level.elo.toString());
          _sendAndLog('position fen ${work.fen}');
          final goCommand = [
            'go',
            'movetime ${work.level.moveTime.inMilliseconds}',
            'depth ${work.level.depth}',
          ];
          if (work.clock != null) {
            final clock = work.clock!;
            goCommand.addAll([
              'wtime ${clock.whiteTime.inMilliseconds}',
              'btime ${clock.blackTime.inMilliseconds}',
              'winc ${clock.whiteIncrement.inMilliseconds}',
              'binc ${clock.blackIncrement.inMilliseconds}',
            ]);
          }
          _sendAndLog(goCommand.join(' '));
      }
      _isComputing.value = true;
    } else {
      _isComputing.value = false;
    }
  }
}
