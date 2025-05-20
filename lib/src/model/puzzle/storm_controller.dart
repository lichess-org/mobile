import 'dart:async';
import 'dart:core';
import 'dart:math' as math;

import 'package:async/async.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/model/puzzle/storm.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storm_controller.freezed.dart';
part 'storm_controller.g.dart';

const malus = Duration(seconds: 10);
const moveDelay = Duration(milliseconds: 200);
const startTime = Duration(minutes: 3);

@riverpod
class StormController extends _$StormController {
  Timer? _firstMoveTimer;

  @override
  StormState build(IList<LitePuzzle> puzzles, DateTime timestamp) {
    final pov = Chess.fromSetup(Setup.parseFen(puzzles.first.fen));
    final clock = StormClock();

    ref.onDispose(() {
      _firstMoveTimer?.cancel();
      clock.dispose();
    });

    final newState = StormState(
      firstMovePlayed: false,
      mode: StormMode.initial,
      puzzleIndex: 0,
      puzzle: puzzles.first,
      moves: 0,
      errors: 0,
      history: const IList.empty(),
      position: pov,
      pov: pov.turn.opposite,
      moveIndex: -1,
      numSolved: 0,
      clock: clock,
      combo: const StormCombo(current: 0, best: 0),
      stats: null,
      lastSolvedTime: null,
    );

    _firstMoveTimer = Timer(
      const Duration(seconds: 1),
      () => _addMove(
        newState.expectedMove!,
        ComboState.noChange,
        runStarted: false,
        userMove: false,
        isFirstMove: true,
      ),
    );
    newState.clock.timeStream.listen((e) {
      if (e.$1 == Duration.zero && clock.endAt == null) {
        end();
      }
    });
    return newState;
  }

  Future<void> onUserMove(NormalMove move) async {
    if (state.clock.endAt != null) return;
    state.clock.start();

    if (isPromotionPawnMove(state.position, move)) {
      state = state.copyWith(promotionMove: move);
      return;
    }

    final expected = state.expectedMove;
    _addMove(move, ComboState.noChange, runStarted: true, userMove: true);
    state = state.copyWith(moves: state.moves + 1);
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
        _pushToHistory(success: true);
        await _loadNextPuzzle(true, ComboState.increase);
        return;
      }

      await Future<void>.delayed(moveDelay);
      _addMove(state.expectedMove!, ComboState.increase, runStarted: true, userMove: false);
    } else {
      state = state.copyWith(errors: state.errors + 1);
      ref.read(soundServiceProvider).play(Sound.error);
      HapticFeedback.heavyImpact();
      state.clock.subtractTime(malus);
      if (state.clock.flag() || !_isNextPuzzleAvailable()) {
        state.clock.sendEnd();
        return;
      }
      _pushToHistory(success: false);
      await _loadNextPuzzle(false, ComboState.reset);
    }
  }

  void onPromotionSelection(Role? role) {
    if (role == null) {
      state = state.copyWith(promotionMove: null);
      return;
    }
    final promotionMove = state.promotionMove;
    if (promotionMove != null) {
      final move = promotionMove.withPromotion(role);
      onUserMove(move);
    }
  }

  Future<void> end() async {
    ref.read(soundServiceProvider).play(Sound.puzzleStormEnd);

    state.clock.reset();
    _pushToHistory(success: false);

    final stats = _getStats();

    final session = ref.read(authSessionProvider);
    if (session != null) {
      final res = await ref.withClient(
        (client) => Result.capture(
          PuzzleRepository(client).postStormRun(stats).timeout(const Duration(seconds: 2)),
        ),
      );

      final newState = state.copyWith(stats: stats, mode: StormMode.ended);

      res.match(
        onSuccess: (newHigh) {
          if (newHigh != null) {
            state = newState.copyWith(stats: stats.copyWith(newHigh: newHigh));
          } else {
            state = newState;
          }
        },
        onError: (_, _) {
          state = newState;
        },
      );
    } else {
      state = state.copyWith(stats: stats, mode: StormMode.ended);
    }
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

    final int newPuzzleIndex = state.puzzleIndex + 1;

    state = state.copyWith(
      puzzleIndex: newPuzzleIndex,
      puzzle: puzzles[newPuzzleIndex],
      position: Chess.fromSetup(Setup.parseFen(puzzles[newPuzzleIndex].fen)),
      moveIndex: -1,
      numSolved: result ? state.numSolved + 1 : state.numSolved,
      lastSolvedTime: DateTime.now(),
      combo: StormCombo(
        current: newComboCurrent,
        best: math.max(state.combo.best, state.combo.current + 1),
      ),
    );
    await Future<void>.delayed(moveDelay);
    _addMove(state.expectedMove!, ComboState.noChange, runStarted: true, userMove: false);
  }

  void _addMove(
    Move move,
    ComboState comboChange, {
    required bool runStarted,
    required bool userMove,
    bool isFirstMove = false,
  }) {
    int newComboCurrent;
    switch (comboChange) {
      case ComboState.increase:
        newComboCurrent = state.combo.current + 1;
      case ComboState.reset:
        newComboCurrent = 0;
      case ComboState.noChange:
        newComboCurrent = state.combo.current;
    }
    final pos = state.position;
    state = state.copyWith(
      firstMovePlayed: isFirstMove || state.firstMovePlayed,
      mode: runStarted ? StormMode.running : state.mode,
      position: state.position.play(move),
      moveIndex: state.moveIndex + 1,
      combo: StormCombo(
        current: newComboCurrent,
        best: math.max(state.combo.best, state.combo.current + 1),
      ),
      promotionMove: null,
    );
    Future<void>.delayed(userMove ? Duration.zero : const Duration(milliseconds: 250), () {
      if (pos.board.pieceAt(move.to) != null) {
        ref.read(moveFeedbackServiceProvider).captureFeedback(check: state.position.isCheck);
      } else {
        ref.read(moveFeedbackServiceProvider).moveFeedback(check: state.position.isCheck);
      }
    });
  }

  StormRunStats _getStats() {
    final wins = state.history.where((e) => e.win == true).toList();
    final mean = state.history.sumBy((e) => e.solvingTime!.inSeconds) / state.history.length;
    final threshold = mean * 1.5;
    return StormRunStats(
      moves: state.moves,
      errors: state.errors,
      score: wins.length,
      comboBest: state.combo.best,
      time: state.clock.endAt!,
      timePerMove: mean,
      highest:
          wins.isNotEmpty
              ? wins
                  .map((e) => e.rating)
                  .reduce((maxRating, rating) => rating > maxRating ? rating : maxRating)
              : 0,
      history: state.history,
      slowPuzzleIds:
          state.history
              .where((e) => e.solvingTime!.inSeconds > threshold)
              .map((e) => e.id)
              .toIList(),
    );
  }

  void _pushToHistory({required bool success}) {
    final timeTaken =
        state.lastSolvedTime != null
            ? DateTime.now().difference(state.lastSolvedTime!)
            : DateTime.now().difference(state.clock.startAt!);
    state = state.copyWith(
      history: state.history.add(
        PuzzleHistoryEntry.fromLitePuzzle(state.puzzle, success, timeTaken),
      ),
    );
  }

  bool _isNextPuzzleAvailable() {
    return state.puzzleIndex + 1 < puzzles.length;
  }
}

@freezed
sealed class StormState with _$StormState {
  const StormState._();

  const factory StormState({
    /// Index of the current puzzle being played
    required int puzzleIndex,

    /// Current puzzle being played
    required LitePuzzle puzzle,

    /// Side of the run. This stays the same throughout the run
    required Side pov,

    /// Index of the move based on [puzzle.solution]. For a new puzzle it is at -1
    required int moveIndex,

    /// Position of the current puzzle based on moveIndex
    required Position position,

    /// Number of puzzles solved
    required int numSolved,

    /// A clock object which stays the same throughout the run
    required StormClock clock,

    /// A combo object which has the current and best combo
    required StormCombo combo,

    /// Number of moves made in the run
    required int moves,

    /// Number of errors made in the run
    required int errors,

    /// The history of puzzles played in the run
    required IList<PuzzleHistoryEntry> history,

    /// Stats of the storm run. Only initialisd after the run ends
    required StormRunStats? stats,

    /// Last solved time for the puzzle
    required DateTime? lastSolvedTime,

    /// State mode of the storm run
    required StormMode mode,

    /// bool to indicate that the first move has been played
    required bool firstMovePlayed,

    /// Promotion move to be selected
    NormalMove? promotionMove,
  }) = _StormState;

  Move? get expectedMove => Move.parse(puzzle.solution[moveIndex + 1]);

  Move? get lastMove => moveIndex == -1 ? null : Move.parse(puzzle.solution[moveIndex]);

  bool get isOver => moveIndex >= puzzle.solution.length - 1;
}

enum StormMode { initial, running, ended }

enum ComboState { increase, reset, noChange }

/// A `StormCombo` object represents the current and best combo of a storm run
@freezed
sealed class StormCombo with _$StormCombo {
  const StormCombo._();

  const factory StormCombo({required int current, required int best}) = _StormCombo;

  /// List representing the bonus awared at each level
  static const levelBonus = [3, 5, 6, 10];

  /// List of pair of level and the bonus
  static const levelsAndBonus = [
    (level: 0, bonus: 0),
    (level: 5, bonus: 3),
    (level: 12, bonus: 5),
    (level: 20, bonus: 7),
    (level: 30, bonus: 10),
  ];

  int currentLevel() {
    final lvl = levelsAndBonus.indexWhere((element) => element.level > current);
    return lvl >= 0 ? lvl - 1 : levelsAndBonus.length - 1;
  }

  /// Returns the level of the `current + 1` combo count
  int nextLevel() {
    final lvl = levelsAndBonus.indexWhere((element) => element.level > current + 1);
    return lvl >= 0 ? lvl - 1 : levelsAndBonus.length - 1;
  }

  /// Returns the percentage completion of the `current` combo count.
  /// If [getNext] is true it returns the percentage of `current + 1` combo count.
  /// This is helpful for calculating the progress bar value.
  double percent({required bool getNext}) {
    final currentCombo = getNext ? current + 1 : current;
    final lvl = getNext ? nextLevel() : currentLevel();
    final lastLevel = levelsAndBonus.last;
    if (lvl >= levelsAndBonus.length - 1) {
      final range = lastLevel.level - levelsAndBonus[levelsAndBonus.length - 2].level;
      return (((currentCombo - lastLevel.level) / range) * 100) % 100;
    }
    final bounds = [levelsAndBonus[lvl].level, levelsAndBonus[lvl + 1].level];
    return ((currentCombo - bounds.first) / (bounds[1] - bounds.first)) * 100;
  }

  /// Returns the bonus time if a new level is reached.
  /// If [getNext] is true it indicates if the bonus will be reached on the next combo.
  Duration? bonus({required bool getNext}) {
    if (percent(getNext: getNext).floor() == 0) {
      final lvl = getNext ? nextLevel() : currentLevel();
      if (lvl > 0) {
        return Duration(seconds: levelsAndBonus[lvl].bonus);
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
