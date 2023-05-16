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

@riverpod
class StormCtrl extends _$StormCtrl {
  int _currentPuzzleIndex = 0;
  int _moves = 0;
  int _errors = 0;
  final _history = <(LitePuzzle, bool)>[];
  Timer? _firstMoveTimer;

  static const malus = Duration(seconds: 10);
  static const moveDelay = Duration(milliseconds: 200);
  @override
  StormCtrlState build(IList<LitePuzzle> puzzles) {
    ref.onDispose(() {
      _firstMoveTimer?.cancel();
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
      stats: null,
    );
    _currentPuzzleIndex += 1;
    _firstMoveTimer =
        Timer(const Duration(seconds: 1), () => _addMove(state.expectedMove!));
    return newState;
  }

  Future<void> onUserMove(Move move) async {
    if (state.clock.endAt == null) return;
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
        _pushToHistory(true);
        if (!_nextPuzzle()) {
          end();
          return;
        }
        ref.read(soundServiceProvider).play(Sound.confirmation);
        await _loadNextPuzzle();
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
      _errors += 1;
      state.combo.reset();
      state.clock.subtractTime(malus);
      if (state.clock.flag() || !_nextPuzzle()) {
        end();
        return;
      }
      _pushToHistory(false);
      ref.read(soundServiceProvider).play(Sound.error);
      await _loadNextPuzzle();
    }
  }

  void end() {
    state.clock.reset();
    state = state.copyWith(stats: _getStats());
  }

  void endNow() {
    state.clock.reset();
  }

  Future<void> _loadNextPuzzle() async {
    state = state.copyWith(
      puzzle: puzzles[_currentPuzzleIndex],
      position:
          Chess.fromSetup(Setup.parseFen(puzzles[_currentPuzzleIndex].fen)),
      moveIndex: -1,
    );
    _currentPuzzleIndex += 1;
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
    final wins = _history.where((e) => e.$2 == true);
    return StormRunStats(
      moves: _moves,
      errors: _errors,
      score: wins.length,
      comboBest: state.combo.best,
      time: state.clock.endAt!,
      highest: wins.map((e) => e.$1.rating).reduce(
            (maxRating, rating) => rating > maxRating ? rating : maxRating,
          ),
      history: _history,
    );
  }

  void _pushToHistory(bool result) {
    _history.add((state.puzzle, result));
  }

  bool _nextPuzzle() {
    return _currentPuzzleIndex < puzzles.length;
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
    required StormRunStats? stats,
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
    required int highest,
    required List<(LitePuzzle, bool)> history,
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
    final lvl = levels.indexWhere((element) => element[0] > current);
    return lvl >= 0 ? lvl - 1 : levels.length - 1;
  }

  double percent() {
    final lvl = level();
    final lastLevel = levels[levels.length - 1];
    if (lvl >= levels.length - 1) {
      final range = lastLevel[0] - levels[levels.length - 2][0];
      return (((current - lastLevel[0]) / range) * 100) % 100;
    }
    final bounds = [levels[lvl][0], levels[lvl + 1][0]];
    return ((current - bounds[0]) / (bounds[1] - bounds[0])) * 100;
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
  final StreamController<(Duration, int?)> _timeStreamController =
      StreamController<(Duration, int?)>.broadcast();
  Duration _currentDuration = const Duration(minutes: 3);
  DateTime? startAt;
  Duration? endAt;
  bool isActive = false;

  Stream<(Duration, int?)> get timeStream => _timeStreamController.stream;

  void addTime(Duration duration) {
    _currentDuration += duration;
    _timeStreamController.add((_currentDuration, duration.inSeconds));
  }

  void subtractTime(Duration duration) {
    _currentDuration -= duration;
    if (_currentDuration.isNegative) {
      _currentDuration = Duration.zero;
    }
    _timeStreamController.add((_currentDuration, -duration.inSeconds));
  }

  void start() {
    if (_timer == null || !_timer!.isActive) {
      isActive = true;
      startAt = DateTime.now();
      endAt = null;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_currentDuration.inSeconds > 0) {
          _currentDuration -= const Duration(seconds: 1);
          _timeStreamController.add((_currentDuration, null));
        } else {
          reset();
        }
      });
    }
  }

  bool flag() => _currentDuration.inSeconds == 0;

  void reset() {
    if (isActive) {
      _timer?.cancel();
      _currentDuration = const Duration(minutes: 3);
      _timeStreamController.add((_currentDuration, null));
      endAt = DateTime.now().difference(startAt!);
      isActive = false;
      startAt = null;
    }
  }

  Duration get timeLeft => _currentDuration;

  void dispose() {
    isActive = false;
    _timer?.cancel();
    _timeStreamController.close();
  }
}
