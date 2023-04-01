import 'package:flutter/foundation.dart';
import 'dart:math' as math;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stockfish/stockfish.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    hide Tuple2;
import 'package:logging/logging.dart';

part 'stockfish_engine.freezed.dart';

const minDepth = 6;
const maxStockfishPlies = 245;

class StockfishEngine {
  StockfishEngine() {
    _stockfish.state.addListener(() {
      if (_stockfish.state.value == StockfishState.ready) {
        send('uci');
      }
    });

    _stockfish.stdout.listen((String line) {
      _process(line);
    });
  }

  final _log = Logger('StockfishEngine');
  final Stockfish _stockfish = Stockfish();
  final Map<String, String> _options = {};

  String engineName = 'Stockfish';

  Work? _work;
  Work? _nextWork;
  ClientEval? _currentEval;
  int _expectedPvs = 1;

  ValueListenable<StockfishState> get state => _stockfish.state;

  void dispose() {
    _stockfish.dispose();
  }

  void send(String command) {
    if (_stockfish.state.value != StockfishState.ready) {
      _log.warning('Stockfish not ready, ignoring command: $command');
      return;
    }
    _stockfish.stdin = command;
  }

  void setOption(String name, String value) {
    if (_options[name] != value) {
      send('setoption name $name value $value');
      _options[name] = value;
    }
  }

  void _stop() {
    if (_work != null && _work!.stopRequested != true) {
      _work = _work!.copyWith(stopRequested: true);
      send('stop');
    }
  }

  void _swapWork() {
    if (_work != null) return;

    _work = _nextWork;
    _nextWork = null;

    if (_work != null) {
      _currentEval = null;
      _expectedPvs = 1;

      setOption('Threads', _work!.threads.toString());
      setOption('Hash', (_work!.hashSize ?? 16).toString());
      setOption('MultiPV', math.max(1, _work!.multiPv).toString());

      send(
        ['position fen', _work!.initialFen, 'moves', ..._work!.moves].join(' '),
      );
      send(
        _work!.maxDepth >= 99
            ? 'go depth $maxStockfishPlies' // 'go infinite' would not finish even if entire tree search completed
            : 'go movetime 90000',
      );
    }
  }

  void compute(Work? nextWork) {
    _nextWork = nextWork;
    _stop();
    _swapWork();
  }

  bool isComputing() {
    return _work != null && _work!.stopRequested == false;
  }

  void _process(String line) {
    final parts = line.trim().split(RegExp(r'\s+'));
    if (parts[0] == 'uciok') {
      // Analyse without contempt.
      setOption('UCI_AnalyseMode', 'true');
      setOption('Analysis Contempt', 'Off');

      // Affects notation only. Life would be easier if everyone would always
      // unconditionally use this mode.
      setOption('UCI_Chess960', 'true');

      send('ucinewgame');
      send('isready');
    } else if (parts[0] == 'readyok') {
      _swapWork();
    } else if (parts[0] == 'id' && parts[1] == 'name') {
      engineName = parts.sublist(2).join(' ');
    } else if (parts[0] == 'bestmove') {
      if (_work != null && _currentEval != null) {
        _work!.emit(_currentEval!);
      }
      _work = null;
      _swapWork();
      return;
    } else if (_work != null &&
        _work!.stopRequested != true &&
        parts[0] == 'info') {
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
            if (parts[i + 1] == 'lowerbound' || parts[i + 1] == 'upperbound') {
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
          knps: nodes / elapsedMs,
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
        _work!.emit(_currentEval!);

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
    } else if (!['Stockfish', 'id', 'option', 'info'].contains(parts[0])) {
      _log.fine('Stockfish: $line');
    }
  }
}

@freezed
class Work with _$Work {
  const factory Work({
    required int threads,
    int? hashSize,
    bool? stopRequested,
    required String path,
    required int maxDepth,
    required int multiPv,
    required int ply,
    bool? threatMode,
    required String initialFen,
    required String currentFen,
    required IList<String> moves,
    required void Function(ClientEval) emit,
  }) = _Work;
}

@freezed
class ClientEval with _$ClientEval {
  const factory ClientEval({
    required String fen,
    required int depth,
    required int nodes,
    required IList<PvData> pvs,
    required int millis,
    required int maxDepth,
    required double knps,
    int? cp,
    int? mate,
  }) = _ClientEval;
}

@freezed
class PvData with _$PvData {
  const factory PvData({
    required IList<String> moves,
    int? mate,
    int? cp,
  }) = _PvData;
}
