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
      combo: StormCombo(),
      stats: null,
      lastSolvedTime: null,
    );
    _nextPuzzleIndex += 1;
    _firstMoveTimer =
        Timer(const Duration(seconds: 1), () => _addMove(state.expectedMove!));
    return newState;
  }

  Future<void> onUserMove(Move move) async {
    if (state.clock.endAt != null) return;
    state.clock.start();
    final expected = state.expectedMove;
    final pos = state.position;
    _addMove(move);
    _moves += 1;
    if (state.position.isGameOver || move == expected) {
      state.combo.inc();
      final bonus = state.combo.bonus();
      if (bonus != null) {
        state.clock.addTime(bonus);
      }
      if (state.position.isGameOver || state.isOver) {
        if (!_nextPuzzle()) {
          state.clock.sendEnd();
          return;
        }
        ref.read(soundServiceProvider).play(Sound.confirmation);
        _pushToHistory(true);
        await _loadNextPuzzle(true);
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
      _addMove(state.expectedMove!);
    } else {
      ref.read(soundServiceProvider).play(Sound.error);
      _errors += 1;
      state.clock.subtractTime(malus);
      state.combo.reset();
      if (state.clock.flag() || !_nextPuzzle()) {
        state.clock.sendEnd();
        return;
      }
      _pushToHistory(false);
      await _loadNextPuzzle(false);
    }
  }

  void end() {
    state.clock.reset();
    _pushToHistory(false);
    state = state.copyWith(stats: _getStats());
  }

  Future<void> _loadNextPuzzle(bool result) async {
    state = state.copyWith(
      puzzle: puzzles[_nextPuzzleIndex],
      position: Chess.fromSetup(Setup.parseFen(puzzles[_nextPuzzleIndex].fen)),
      moveIndex: -1,
      numSolved: result ? state.numSolved + 1 : state.numSolved,
      lastSolvedTime: DateTime.now(),
    );
    _nextPuzzleIndex += 1;
    await Future<void>.delayed(moveDelay);
    _addMove(state.expectedMove!);
  }

  void _addMove(Move move) {
    state = state.copyWith(
      position: state.position.play(move),
      moveIndex: state.moveIndex + 1,
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

  bool _nextPuzzle() {
    return _nextPuzzleIndex < puzzles.length;
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
    final lvl = levels.indexWhere((element) => element.first > current);
    return lvl >= 0 ? lvl - 1 : levels.length - 1;
  }

  double percent() {
    final lvl = level();
    final lastLevel = levels.last;
    if (lvl >= levels.length - 1) {
      final range = lastLevel.first - levels[levels.length - 2].first;
      return (((current - lastLevel.first) / range) * 100) % 100;
    }
    final bounds = [levels[lvl].first, levels[lvl + 1].first];
    return ((current - bounds.first) / (bounds[1] - bounds.first)) * 100;
  }

  Duration? bonus() {
    if (percent().floor() == 0) {
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
  final StreamController<(Duration, int?)> timeStreamController =
      StreamController<(Duration, int?)>.broadcast();
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
