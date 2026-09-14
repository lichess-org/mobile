import 'dart:async';
import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';

part 'local_game_clock.freezed.dart';

/// Whether a locally played game is timed or has no time limit at all.
enum TimeControlType {
  clock,
  unlimited;

  String label(AppLocalizations l10n) => switch (this) {
    TimeControlType.clock => l10n.clock,
    TimeControlType.unlimited => l10n.unlimited,
  };
}

/// The chess clock of a game played locally on the device: over the board, or against the engine.
///
/// Only one side's time runs at a time, and only once [switchSide] has been called for the first
/// time — so the clock starts on the first move, not when the game is set up.
abstract class LocalGameClock extends Notifier<LocalGameClockState> {
  final Stopwatch _stopwatch = Stopwatch();

  Timer? _updateTimer;

  /// The time control the clock starts on, before any game has set it up.
  TimeIncrement get defaultTimeIncrement;

  @override
  LocalGameClockState build() {
    ref.onDispose(() {
      _updateTimer?.cancel();
    });

    _updateTimer = Timer.periodic(const Duration(milliseconds: 100), (_) => _flushElapsed());

    return LocalGameClockState.fromTimeIncrement(defaultTimeIncrement);
  }

  /// Charges the time run since the last reading to the side whose clock is running.
  ///
  /// Called on every tick, but also whenever the clock is about to stop or change hands, so that
  /// the fraction of a tick that has run since the last one is not silently given back.
  void _flushElapsed() {
    final activeClock = state.activeClock;
    if (!_stopwatch.isRunning || activeClock == null) return;

    final newTime = state.timeLeft(activeClock)! - _stopwatch.elapsed;
    _stopwatch.reset();

    state = activeClock == Side.white
        ? state.copyWith(whiteTimeLeft: newTime)
        : state.copyWith(blackTimeLeft: newTime);

    if (newTime <= Duration.zero) {
      state = state.copyWith(flagSide: activeClock);
    }
  }

  void setupClock(TimeIncrement timeIncrement, {Duration? whiteTimeLeft, Duration? blackTimeLeft}) {
    _stopwatch.stop();
    _stopwatch.reset();

    state = LocalGameClockState.fromTimeIncrement(
      timeIncrement,
      whiteTimeLeft: whiteTimeLeft,
      blackTimeLeft: blackTimeLeft,
    );
  }

  void restart() {
    setupClock(state.timeIncrement);
  }

  void switchSide({required Side newSideToMove, required bool addIncrement}) {
    if (state.timeIncrement.isInfinite || state.flagSide != null) return;

    _flushElapsed();
    // Flushing can be what reveals that the side to move has just run out of time.
    if (state.flagSide != null) return;

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
      _flushElapsed();
      _stopwatch.stop();
      state = state.copyWith(activeClock: null);
    }
  }

  void resume(Side newSideToMove) {
    _stopwatch.reset();
    _stopwatch.start();

    state = state.copyWith(activeClock: newSideToMove);
  }
}

@freezed
sealed class LocalGameClockState with _$LocalGameClockState {
  const LocalGameClockState._();

  const factory LocalGameClockState({
    required TimeIncrement timeIncrement,
    required Duration? whiteTimeLeft,
    required Duration? blackTimeLeft,
    required Side? activeClock,
    required Side? flagSide,
  }) = _LocalGameClockState;

  factory LocalGameClockState.fromTimeIncrement(
    TimeIncrement timeIncrement, {
    Duration? whiteTimeLeft,
    Duration? blackTimeLeft,
  }) {
    final initialTime = timeIncrement.isInfinite
        ? null
        : Duration(seconds: max(timeIncrement.time, timeIncrement.increment));

    return LocalGameClockState(
      timeIncrement: timeIncrement,
      whiteTimeLeft: whiteTimeLeft ?? initialTime,
      blackTimeLeft: blackTimeLeft ?? initialTime,
      activeClock: null,
      flagSide: null,
    );
  }

  bool get active => activeClock != null || flagSide != null;

  Duration? timeLeft(Side side) => side == Side.white ? whiteTimeLeft : blackTimeLeft;
}
