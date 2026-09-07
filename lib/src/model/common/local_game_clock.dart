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

    return LocalGameClockState.fromTimeIncrement(defaultTimeIncrement);
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
