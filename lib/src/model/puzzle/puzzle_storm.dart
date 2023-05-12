import 'dart:async';
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
  Timer? _firstMoveTimer;

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
    );
    _currentPuzzleIndex += 1;
    _firstMoveTimer =
        Timer(const Duration(seconds: 1), () => _addMove(state.expectedMove!));
    return newState;
  }

  Future<void> onUserMove(Move move) async {
    final expected = state.expectedMove;
    state.clock.start();
    _addMove(move);
    if (state.position.isGameOver || move == expected) {
      if (state.position.isGameOver || state.isOver) {
        await _loadNextPuzzle();
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 500));
      _addMove(state.expectedMove!);
    }
  }

  Future<void> _loadNextPuzzle() async {
    final pov =
        Chess.fromSetup(Setup.parseFen(puzzles[_currentPuzzleIndex].fen));
    state = state.copyWith(
      puzzle: puzzles[_currentPuzzleIndex],
      position: pov,
      pov: pov.turn.opposite,
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
  }) = _StormCtrlState;

  Move? get expectedMove => Move.fromUci(puzzle.solution[moveIndex + 1]);

  Move? get lastMove =>
      moveIndex == -1 ? null : Move.fromUci(puzzle.solution[moveIndex]);

  bool get isOver => moveIndex >= puzzle.solution.length - 1;

  IMap<String, ISet<String>> get validMoves => algebraicLegalMoves(position);
}

class StormHistory {
  LitePuzzle puzzle;
  bool result;
  StormHistory(this.puzzle, this.result);
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
