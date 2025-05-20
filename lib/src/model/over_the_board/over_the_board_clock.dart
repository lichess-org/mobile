import 'dart:async';
import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'over_the_board_clock.freezed.dart';
part 'over_the_board_clock.g.dart';

@riverpod
class OverTheBoardClock extends _$OverTheBoardClock {
  final Stopwatch _stopwatch = Stopwatch();

  Timer? _updateTimer;

  @override
  OverTheBoardClockState build() {
    ref.onDispose(() {
      _updateTimer?.cancel();
    });

    _updateTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (_stopwatch.isRunning) {
        final newTime = state.timeLeft(state.activeClock!)! - _stopwatch.elapsed;

        if (state.activeClock == Side.white) {
          state = state.copyWith(whiteTimeLeft: newTime);
        } else {
          state = state.copyWith(blackTimeLeft: newTime);
        }

        if (newTime <= Duration.zero) {
          state = state.copyWith(flagSide: state.activeClock);
        }

        _stopwatch.reset();
      }
    });

    return OverTheBoardClockState.fromTimeIncrement(
      TimeIncrement(const Duration(minutes: 5).inSeconds, const Duration(seconds: 3).inSeconds),
    );
  }

  void setupClock(TimeIncrement timeIncrement) {
    _stopwatch.stop();
    _stopwatch.reset();

    state = OverTheBoardClockState.fromTimeIncrement(timeIncrement);
  }

  void restart() {
    setupClock(state.timeIncrement);
  }

  void switchSide({required Side newSideToMove, required bool addIncrement}) {
    if (state.timeIncrement.isInfinite || state.flagSide != null) return;

    final increment = Duration(seconds: addIncrement ? state.timeIncrement.increment : 0);
    if (newSideToMove == Side.black) {
      state = state.copyWith(
        whiteTimeLeft: state.whiteTimeLeft! + increment,
        activeClock: Side.black,
      );
    } else {
      state = state.copyWith(
        blackTimeLeft: state.blackTimeLeft! + increment,
        activeClock: Side.white,
      );
    }

    _stopwatch.reset();
    _stopwatch.start();
  }

  void onMove({required Side newSideToMove}) {
    switchSide(newSideToMove: newSideToMove, addIncrement: state.active);
  }

  void pause() {
    if (_stopwatch.isRunning) {
      state = state.copyWith(activeClock: null);
      _stopwatch.reset();
      _stopwatch.stop();
    }
  }

  void resume(Side newSideToMove) {
    _stopwatch.reset();
    _stopwatch.start();

    state = state.copyWith(activeClock: newSideToMove);
  }
}

@freezed
sealed class OverTheBoardClockState with _$OverTheBoardClockState {
  const OverTheBoardClockState._();

  const factory OverTheBoardClockState({
    required TimeIncrement timeIncrement,
    required Duration? whiteTimeLeft,
    required Duration? blackTimeLeft,
    required Side? activeClock,
    required Side? flagSide,
  }) = _OverTheBoardClockState;

  factory OverTheBoardClockState.fromTimeIncrement(TimeIncrement timeIncrement) {
    final initialTime =
        timeIncrement.isInfinite
            ? null
            : Duration(seconds: max(timeIncrement.time, timeIncrement.increment));

    return OverTheBoardClockState(
      timeIncrement: timeIncrement,
      whiteTimeLeft: initialTime,
      blackTimeLeft: initialTime,
      activeClock: null,
      flagSide: null,
    );
  }

  bool get active => activeClock != null || flagSide != null;

  Duration? timeLeft(Side side) => side == Side.white ? whiteTimeLeft : blackTimeLeft;
}
