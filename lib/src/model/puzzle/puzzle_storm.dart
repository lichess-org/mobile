import 'dart:async';
import 'dart:core';
import 'dart:math' as math;
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'puzzle.dart';

part 'puzzle_storm.g.dart';
part 'puzzle_storm.freezed.dart';

@riverpod
class StormCtrl extends _$StormCtrl {
  int _currentPuzzleIndex = 0;
  int _moves = 0;
  int _errors = 0;
  List<(LitePuzzle, bool)> _history = [];
  Timer? _firstMoveTimer;

  static const malus = Duration(seconds: 10);

  @override
  StormCtrlState build(IList<LitePuzzle> puzzles) {
    ref.onDispose(() {
      _firstMoveTimer?.cancel();
      state.clock.reset();
      state.clock.dispose();
    });
    final pov = Chess.fromSetup(Setup.parseFen(puzzles[0].fen));
    final newState = StormCtrlState(
      puzzle: puzzles[_currentPuzzleIndex],
      position: pov,
      pov: pov.turn.opposite,
      moveIndex: -1,
      moves: 0,
      clock: StormClock(),
      combo: StormCombo(),
    );
    _currentPuzzleIndex += 1;
    _firstMoveTimer =
        Timer(const Duration(seconds: 1), () => _addMove(state.expectedMove!));
    return newState;
  }

  Future<void> onUserMove(Move move) async {
    _addMove(move);
    state.clock.start();
    final expected = state.expectedMove;
    _moves += 1;
    if (state.position.isGameOver || move == expected) {
      state.combo.inc();
      final bonus = state.combo.bonus();
      if (bonus != null) {
        state.clock.addTime(bonus);
      }
      if (state.position.isGameOver || state.isOver) {
        _pushToHistory(true);
        await Future<void>.delayed(const Duration(milliseconds: 200));
        await _loadNextPuzzle();
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 500));
      _addMove(state.expectedMove!);
    } else {
      _errors += 1;
      state.combo.reset();
      state.clock.subtractTime(malus);
      _pushToHistory(false);
      await Future<void>.delayed(const Duration(milliseconds: 200));
      await _loadNextPuzzle();
    }
  }

  Future<void> _loadNextPuzzle() async {
    state = state.copyWith(
      puzzle: puzzles[_currentPuzzleIndex],
      position:
          Chess.fromSetup(Setup.parseFen(puzzles[_currentPuzzleIndex].fen)),
      moveIndex: -1,
    );
    _currentPuzzleIndex += 1;
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _addMove(state.expectedMove!);
  }

  void _addMove(Move move) {
    state = state.copyWith(
      position: state.position.play(move),
      moveIndex: state.moveIndex + 1,
    );
  }

  void _pushToHistory(bool result) {
    _history.add((state.puzzle, result));
  }
}

@freezed
class StormCtrlState with _$StormCtrlState {
  const StormCtrlState._();
  const factory StormCtrlState({
    required LitePuzzle puzzle,
    required Side pov,
    required Position<Chess> position,
    required int moveIndex,
    required int moves,
    required StormClock clock,
    required StormCombo combo,
  }) = _StormCtrlState;

  Move? get expectedMove => Move.fromUci(puzzle.solution[moveIndex + 1]);

  Move? get lastMove =>
      moveIndex == -1 ? null : Move.fromUci(puzzle.solution[moveIndex]);

  bool get isOver => moveIndex >= puzzle.solution.length - 1;

  IMap<String, ISet<String>> get validMoves => algebraicLegalMoves(position);
}

class StormCombo {
  int current = 0;
  int best = 0;

  static const levels = [
    [0, 0],
    [5, 3],
    [12, 5],
    [20, 7],
    [30, 10]
  ];

  void inc() {
    current += 1;
    best = math.max(current, best);
  }

  void reset() => current = 0;

  int level() {
    final lvl = levels.indexWhere((element) => element[0] > current);
    return lvl >= 0 ? lvl - 1 : levels.length - 1;
  }

  int percent() {
    final lvl = level();
    final lastLevel = levels[levels.length - 1];
    if (lvl >= levels.length - 1) {
      final range = lastLevel[0] - levels[levels.length - 2][0];
      return ((((current - lastLevel[0]) / range) * 100) % 100).toInt();
    }
    final bounds = [levels[lvl][0], levels[lvl + 1][0]];
    return (((current - bounds[0]) / (bounds[1] - bounds[0])) * 100).floor();
  }

  Duration? bonus() {
    if (percent() == 0) {
      final lvl = level();
      if (lvl > 0) {
        return Duration(seconds: levels[lvl][1]);
      }
    }
    return null;
  }
}

class StormClock {
  Timer? _timer;
  final StreamController<Duration> _timeStreamController =
      StreamController<Duration>.broadcast();
  Duration _currentDuration = const Duration(minutes: 3);
  bool isActive = false;

  Stream<Duration> get timeStream => _timeStreamController.stream;

  void addTime(Duration duration) {
    _currentDuration += duration;
    _timeStreamController.add(_currentDuration);
  }

  void subtractTime(Duration duration) {
    _currentDuration -= duration;
    if (_currentDuration.isNegative) {
      _currentDuration = Duration.zero;
    }
    _timeStreamController.add(_currentDuration);
  }

  void start() {
    if (_timer == null || !_timer!.isActive) {
      isActive = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_currentDuration.inSeconds > 0) {
          _currentDuration -= const Duration(seconds: 1);
          _timeStreamController.add(_currentDuration);
        } else {
          _timer!.cancel();
        }
      });
    }
  }

  void reset() {
    _timer?.cancel();
    _currentDuration = const Duration(minutes: 3);
    _timeStreamController.add(_currentDuration);
    isActive = false;
  }

  void stop() {
    _timer?.cancel();
    isActive = false;
  }

  Duration get timeLeft => _currentDuration;

  void dispose() {
    isActive = false;
    _timer?.cancel();
    _timeStreamController.close();
  }
}
