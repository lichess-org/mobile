import 'dart:async';
import 'dart:core';
import 'dart:math' as math;
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'puzzle.dart';

part 'puzzle_storm.g.dart';
part 'puzzle_storm.freezed.dart';

const malus = Duration(seconds: 10);
const moveDelay = Duration(milliseconds: 200);
const startTime = Duration(minutes: 3);

// TODO: Send Storm Result

@riverpod
class StormCtrl extends _$StormCtrl {
  int _nextPuzzleIndex = 0;
  int _moves = 0;
  int _errors = 0;
  final _history = <(LitePuzzle, bool, Duration)>[];
  Timer? _firstMoveTimer;

  @override
  StormCtrlState build(IList<LitePuzzle> puzzles) {
    ref.onDispose(() {
      _firstMoveTimer?.cancel();
      state.clock.dispose();
    });
    final pov = Chess.fromSetup(Setup.parseFen(puzzles.first.fen));
    final newState = StormCtrlState(
      puzzle: puzzles[_nextPuzzleIndex],
      position: pov,
      pov: pov.turn.opposite,
      moveIndex: -1,
      numSolved: 0,
      clock: StormClock(),
      combo: const StormCombo(current: 0, best: 0),
      stats: null,
      lastSolvedTime: null,
    );
    _nextPuzzleIndex += 1;
    _firstMoveTimer = Timer(
      const Duration(seconds: 1),
      () => _addMove(state.expectedMove!, ComboState.noChange),
    );
    return newState;
  }

  Future<void> onUserMove(Move move) async {
    if (state.clock.endAt != null) return;
    state.clock.start();
    final expected = state.expectedMove;
    final pos = state.position;
    _addMove(move, ComboState.noChange);
    _moves += 1;
    if (state.position.isGameOver || move == expected) {
      final bonus = state.combo.bonus(getNext: true);
      if (bonus != null) {
        state.clock.addTime(bonus);
      }
      if (state.position.isGameOver || state.isOver) {
        if (!_isNextPuzzleAvailable()) {
          state.clock.sendEnd();
          return;
        }
        ref.read(soundServiceProvider).play(Sound.confirmation);
        _pushToHistory(true);
        await _loadNextPuzzle(true, ComboState.increase);
        return;
      }

      if (pos.board.pieceAt(move.to) != null) {
        ref
            .read(moveFeedbackServiceProvider)
            .captureFeedback(check: state.position.isCheck);
      } else {
        ref
            .read(moveFeedbackServiceProvider)
            .moveFeedback(check: state.position.isCheck);
      }
      await Future<void>.delayed(moveDelay);
      _addMove(state.expectedMove!, ComboState.increase);
    } else {
      _errors += 1;
      ref.read(soundServiceProvider).play(Sound.error);
      state.clock.subtractTime(malus);
      if (state.clock.flag() || !_isNextPuzzleAvailable()) {
        state.clock.sendEnd();
        return;
      }
      _pushToHistory(false);
      await _loadNextPuzzle(false, ComboState.reset);
    }
  }

  void end() {
    state.clock.reset();
    _pushToHistory(false);
    state = state.copyWith(stats: _getStats());
  }

  Future<void> _loadNextPuzzle(bool result, ComboState comboChange) async {
    int newComboCurrent;
    switch (comboChange) {
      case ComboState.increase:
        newComboCurrent = state.combo.current + 1;
      case ComboState.reset:
        newComboCurrent = 0;
      case ComboState.noChange:
        newComboCurrent = state.combo.current;
    }

    state = state.copyWith(
      puzzle: puzzles[_nextPuzzleIndex],
      position: Chess.fromSetup(Setup.parseFen(puzzles[_nextPuzzleIndex].fen)),
      moveIndex: -1,
      numSolved: result ? state.numSolved + 1 : state.numSolved,
      lastSolvedTime: DateTime.now(),
      combo: StormCombo(
        current: newComboCurrent,
        best: math.max(state.combo.best, state.combo.current + 1),
      ),
    );
    _nextPuzzleIndex += 1;
    await Future<void>.delayed(moveDelay);
    _addMove(state.expectedMove!, ComboState.noChange);
  }

  void _addMove(Move move, ComboState comboChange) {
    int newComboCurrent;
    switch (comboChange) {
      case ComboState.increase:
        newComboCurrent = state.combo.current + 1;
      case ComboState.reset:
        newComboCurrent = 0;
      case ComboState.noChange:
        newComboCurrent = state.combo.current;
    }
    state = state.copyWith(
      position: state.position.play(move),
      moveIndex: state.moveIndex + 1,
      combo: StormCombo(
        current: newComboCurrent,
        best: math.max(state.combo.best, state.combo.current + 1),
      ),
    );
  }

  StormRunStats _getStats() {
    final wins = _history.where((e) => e.$2 == true).toList();
    return StormRunStats(
      moves: _moves,
      errors: _errors,
      score: wins.length,
      comboBest: state.combo.best,
      time: state.clock.endAt!,
      timePerMove: _history.sumBy((e) => e.$3.inSeconds) / _history.length,
      highest: wins.isNotEmpty
          ? wins.map((e) => e.$1.rating).reduce(
                (maxRating, rating) => rating > maxRating ? rating : maxRating,
              )
          : 0,
      history: _history,
    );
  }

  void _pushToHistory(bool result) {
    final timeTaken = state.lastSolvedTime != null
        ? DateTime.now().difference(state.lastSolvedTime!)
        : DateTime.now().difference(state.clock.startAt!);
    _history.add((state.puzzle, result, timeTaken));
  }

  bool _isNextPuzzleAvailable() {
    return _nextPuzzleIndex < puzzles.length;
  }
}

@freezed
class StormCtrlState with _$StormCtrlState {
  const StormCtrlState._();
  // moveIndex starts at -1 for new puzzles
  const factory StormCtrlState({
    required LitePuzzle puzzle,
    required Side pov,
    required Position<Chess> position,
    required int moveIndex,
    required int numSolved,
    required StormClock clock,
    required StormCombo combo,
    required StormRunStats? stats,
    required DateTime? lastSolvedTime,
  }) = _StormCtrlState;

  Move? get expectedMove => Move.fromUci(puzzle.solution[moveIndex + 1]);

  Move? get lastMove =>
      moveIndex == -1 ? null : Move.fromUci(puzzle.solution[moveIndex]);

  bool get isOver => moveIndex >= puzzle.solution.length - 1;

  IMap<String, ISet<String>> get validMoves => algebraicLegalMoves(position);
}

@freezed
class StormRunStats with _$StormRunStats {
  const factory StormRunStats({
    required int moves,
    required int errors,
    required int score,
    required int comboBest,
    required Duration time,
    required double timePerMove,
    required int highest,
    required List<(LitePuzzle, bool, Duration)> history,
  }) = _StormRunStats;
}

enum ComboState {
  increase,
  reset,
  noChange,
}

@freezed
class StormCombo with _$StormCombo {
  const StormCombo._();

  const factory StormCombo({
    required int current,
    required int best,
  }) = _StormCombo;

  static const levels = [
    [0, 0],
    [5, 3],
    [12, 5],
    [20, 7],
    [30, 10]
  ];

  int currentLevel() {
    final lvl = levels.indexWhere((element) => element.first > current);
    return lvl >= 0 ? lvl - 1 : levels.length - 1;
  }

  int nextLevel() {
    final lvl = levels.indexWhere((element) => element.first > current + 1);
    return lvl >= 0 ? lvl - 1 : levels.length - 1;
  }

  double percent({required bool getNext}) {
    final lvl = getNext ? nextLevel() : currentLevel();
    final lastLevel = levels.last;
    if (lvl >= levels.length - 1) {
      final range = lastLevel.first - levels[levels.length - 2].first;
      return (((current - lastLevel.first) / range) * 100) % 100;
    }
    final bounds = [levels[lvl].first, levels[lvl + 1].first];
    return ((current - bounds.first) / (bounds[1] - bounds.first)) * 100;
  }

  Duration? bonus({required bool getNext}) {
    if (percent(getNext: getNext).floor() == 0) {
      final lvl = getNext ? nextLevel() : currentLevel();
      if (lvl > 0) {
        return Duration(seconds: levels[lvl][1]);
      }
    }
    return null;
  }
}

class StormClock {
  final StreamController<(Duration, int?)> timeStreamController =
      StreamController<(Duration, int?)>.broadcast();

  Timer? _timer;
  Duration _currentDuration = startTime;
  DateTime? startAt;
  Duration? endAt;
  bool isActive = false;

  Stream<(Duration, int?)> get timeStream => timeStreamController.stream;

  void addTime(Duration duration) {
    _currentDuration += duration;
    timeStreamController.add((_currentDuration, duration.inSeconds));
  }

  void subtractTime(Duration duration) {
    _currentDuration -= duration;
    if (_currentDuration.isNegative) {
      _currentDuration = Duration.zero;
    }
    timeStreamController.add((_currentDuration, -duration.inSeconds));
  }

  void start() {
    if (_timer == null || !_timer!.isActive) {
      isActive = true;
      startAt = DateTime.now();
      endAt = null;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_currentDuration.inSeconds > 0) {
          _currentDuration -= const Duration(seconds: 1);
          timeStreamController.add((_currentDuration, null));
        } else {
          reset();
        }
      });
    }
  }

  void sendEnd() => timeStreamController.add((Duration.zero, null));

  bool flag() => _currentDuration.inSeconds == 0;

  void reset() {
    if (isActive) {
      _timer?.cancel();
      _currentDuration = startTime;
      timeStreamController.add((_currentDuration, null));
      endAt = DateTime.now().difference(startAt!);
      isActive = false;
      startAt = null;
    }
  }

  Duration get timeLeft => _currentDuration;

  void dispose() {
    isActive = false;
    _timer?.cancel();
    timeStreamController.close();
  }
}
