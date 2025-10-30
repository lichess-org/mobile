import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/clock/chess_clock.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clock_tool_controller.freezed.dart';
part 'clock_tool_controller.g.dart';

enum ClockSide {
  top,
  bottom;

  ClockSide get opposite => this == ClockSide.top ? ClockSide.bottom : ClockSide.top;

  Side get chessClockSide => this == ClockSide.top ? Side.black : Side.white;
}

@riverpod
class ClockToolController extends _$ClockToolController {
  late ChessClock _clock;
  final Map<ClockSide, bool> _hasPlayedLowTimeSound = {
    ClockSide.top: false,
    ClockSide.bottom: false,
  };
  late Duration _emergencyThreshold;

  @override
  ClockState build() {
    const time = Duration(minutes: 10);
    const increment = Duration.zero;
    _emergencyThreshold = _calculateEmergencyThreshold(time);
    const options = ClockOptions(
      topTime: time,
      bottomTime: time,
      topIncrement: increment,
      bottomIncrement: increment,
    );

    _clock = ChessClock(blackTime: time, whiteTime: time, onFlag: _onFlagged);

    // Add listeners for both clocks
    _clock.whiteTime.addListener(onClockEmergency);
    _clock.blackTime.addListener(onClockEmergency);

    ref.onDispose(() {
      _clock.whiteTime.removeListener(onClockEmergency);
      _clock.blackTime.removeListener(onClockEmergency);
      _clock.dispose();
    });

    return ClockState(
      options: options,
      // we'll alway use blackTime for top and whiteTime for bottom
      topTime: _clock.blackTime,
      bottomTime: _clock.whiteTime,
      clockOrientation: ClockOrientation.portraitUp,
    );
  }

  // Emergency threshold is set to 10% of the total time
  Duration _calculateEmergencyThreshold(Duration initialTime) {
    return Duration(milliseconds: (initialTime.inMilliseconds * 0.1).round());
  }

  void onClockEmergency() {
    final activeSide = state.activeSide;
    if (activeSide == null) return;
    if (_hasPlayedLowTimeSound[activeSide]!) return;
    final activeSideTime = activeSide == ClockSide.top
        ? _clock.blackTime.value
        : _clock.whiteTime.value;
    if (activeSideTime <= _emergencyThreshold) {
      ref.read(soundServiceProvider).play(Sound.lowTime);
      _hasPlayedLowTimeSound[activeSide] = true;
    }
  }

  void _onFlagged() {
    _clock.stop();
    state = state.copyWith(
      flagged: _clock.activeSide == Side.white ? ClockSide.bottom : ClockSide.top,
    );
  }

  void onTap(ClockSide playerType) {
    final started = state.activeSide != null;
    state = state.copyWith(
      activeSide: playerType.opposite,
      topMoves: playerType == ClockSide.top && started ? state.topMoves + 1 : state.topMoves,
      bottomMoves: playerType == ClockSide.bottom && started
          ? state.bottomMoves + 1
          : state.bottomMoves,
    );
    ref.read(soundServiceProvider).play(Sound.clock);
    _clock.incTime(
      playerType.chessClockSide,
      playerType == ClockSide.top ? state.options.topIncrement : state.options.bottomIncrement,
    );
    // Start the countdown only if either this is not a zero-start clock
    // or the new active side has already made at least one move.
    final Duration initialOfNewActive = playerType.opposite == ClockSide.top
        ? state.options.topTime
        : state.options.bottomTime;
    final bool hasNewActiveMoved =
        (playerType.opposite == ClockSide.top ? state.topMoves : state.bottomMoves) > 0;
    if (initialOfNewActive.inMilliseconds != 0 || hasNewActiveMoved) {
      _clock.startSide(playerType.opposite.chessClockSide);
    } else {
      _clock.stop();
    }
  }

  void updateDuration(ClockSide playerType, Duration duration) {
    if (state.flagged != null || state.paused) {
      return;
    }

    _clock.setTimes(
      whiteTime: playerType == ClockSide.bottom ? duration + state.options.topIncrement : null,
      blackTime: playerType == ClockSide.top ? duration + state.options.bottomIncrement : null,
    );
  }

  void updateOptions(TimeIncrement timeIncrement) {
    final options = ClockOptions.fromTimeIncrement(timeIncrement);
    _emergencyThreshold = _calculateEmergencyThreshold(Duration(seconds: timeIncrement.time));
    _hasPlayedLowTimeSound[ClockSide.top] = false;
    _hasPlayedLowTimeSound[ClockSide.bottom] = false;
    _clock.setTimes(blackTime: options.topTime, whiteTime: options.bottomTime);
    state = state.copyWith(
      options: options,
      topTime: _clock.blackTime,
      bottomTime: _clock.whiteTime,
    );
  }

  void updateOptionsCustom(TimeIncrement clock, ClockSide player) {
    final options = ClockOptions(
      topTime: player == ClockSide.top ? Duration(seconds: clock.time) : state.options.topTime,
      bottomTime: player == ClockSide.bottom
          ? Duration(seconds: clock.time)
          : state.options.bottomTime,
      topIncrement: player == ClockSide.top
          ? Duration(seconds: clock.increment)
          : state.options.topIncrement,
      bottomIncrement: player == ClockSide.bottom
          ? Duration(seconds: clock.increment)
          : state.options.bottomIncrement,
    );
    _clock.setTimes(blackTime: options.topTime, whiteTime: options.bottomTime);
    state = ClockState(
      options: options,
      topTime: _clock.blackTime,
      bottomTime: _clock.whiteTime,
      activeSide: state.activeSide,
      clockOrientation: state.clockOrientation,
    );
  }

  void reset() {
    state = state.copyWith(
      activeSide: null,
      topTime: _clock.blackTime,
      bottomTime: _clock.whiteTime,
      flagged: null,
      paused: false,
      topMoves: 0,
      bottomMoves: 0,
    );
    _clock.stop();
    _clock.setTimes(blackTime: state.options.topTime, whiteTime: state.options.bottomTime);
    // Reset low time sound flags for both players
    _hasPlayedLowTimeSound[ClockSide.top] = false;
    _hasPlayedLowTimeSound[ClockSide.bottom] = false;
  }

  void start(ClockSide playerType) {
    final Duration initialOfStartingPlayer = playerType.opposite == ClockSide.top
        ? state.options.topTime
        : state.options.bottomTime;
    state = state.copyWith(activeSide: playerType.opposite);
    // If the new active side starts at zero time, do not start their countdown yet.
    // We only begin decreasing a side's clock after that side has completed at least one move.
    // This makes 0+increment modes usable.
    if (initialOfStartingPlayer.inMilliseconds == 0) {
      _clock.stop();
    } else {
      _clock.startSide(playerType.opposite.chessClockSide);
    }
  }

  void pause() {
    _clock.stop();
    state = state.copyWith(paused: true);
  }

  void resume() {
    final active = state.activeSide;
    // If the active side started at zero, only resume ticking after that side
    // has completed at least one move; otherwise behave normally.
    final Duration initialOfActive = active == ClockSide.top
        ? state.options.topTime
        : state.options.bottomTime;
    final bool hasActiveMoved = active == ClockSide.top
        ? state.topMoves > 0
        : state.bottomMoves > 0;

    if (active != null && (initialOfActive.inMilliseconds != 0 || hasActiveMoved)) {
      _clock.start();
    }
    state = state.copyWith(paused: false);
  }

  void toggleOrientation(ClockOrientation clockOrientation) {
    state = state.copyWith(clockOrientation: clockOrientation);
  }
}

@freezed
sealed class ClockOptions with _$ClockOptions {
  const ClockOptions._();

  const factory ClockOptions({
    required Duration topTime,
    required Duration bottomTime,
    required Duration topIncrement,
    required Duration bottomIncrement,
  }) = _ClockOptions;

  factory ClockOptions.fromTimeIncrement(TimeIncrement timeIncrement) => ClockOptions(
    topTime: Duration(seconds: timeIncrement.time),
    bottomTime: Duration(seconds: timeIncrement.time),
    topIncrement: Duration(seconds: timeIncrement.increment),
    bottomIncrement: Duration(seconds: timeIncrement.increment),
  );

  factory ClockOptions.fromSeparateTimeIncrements(
    TimeIncrement playerTop,
    TimeIncrement playerBottom,
  ) => ClockOptions(
    topTime: Duration(seconds: playerTop.time),
    bottomTime: Duration(seconds: playerBottom.time),
    topIncrement: Duration(seconds: playerTop.increment),
    bottomIncrement: Duration(seconds: playerBottom.increment),
  );

  int getIncrement(ClockSide playerType) {
    return playerType == ClockSide.top ? topIncrement.inSeconds : bottomIncrement.inSeconds;
  }

  bool hasIncrement(ClockSide playerType) {
    return getIncrement(playerType) > 0;
  }
}

@freezed
sealed class ClockState with _$ClockState {
  const ClockState._();

  const factory ClockState({
    required ClockOptions options,
    required ValueListenable<Duration> topTime,
    required ValueListenable<Duration> bottomTime,
    ClockSide? activeSide,
    ClockSide? flagged,
    @Default(false) bool paused,
    @Default(0) int topMoves,
    @Default(0) int bottomMoves,
    required ClockOrientation clockOrientation,
  }) = _ClockState;

  bool get started => activeSide != null;

  ValueListenable<Duration> getDuration(ClockSide playerType) =>
      playerType == ClockSide.top ? topTime : bottomTime;

  int getMovesCount(ClockSide playerType) => playerType == ClockSide.top ? topMoves : bottomMoves;

  bool isPlayersTurn(ClockSide playerType) => activeSide == playerType && flagged == null;

  bool isPlayersMoveAllowed(ClockSide playerType) => isPlayersTurn(playerType) && !paused;

  bool isActivePlayer(ClockSide playerType) => isPlayersTurn(playerType) && !paused;

  bool isFlagged(ClockSide playerType) => flagged == playerType;
}

enum ClockOrientation {
  portraitUp,
  landscapeLeft,
  landscapeRight;

  ClockOrientation get toggle => switch (this) {
    portraitUp => landscapeLeft,
    landscapeLeft => landscapeRight,
    landscapeRight => portraitUp,
  };

  int get quarterTurns => switch (this) {
    portraitUp => 0,
    landscapeLeft => 1,
    landscapeRight => 3,
  };

  int get oppositeQuarterTurns => switch (this) {
    portraitUp => 2,
    landscapeLeft => 3,
    landscapeRight => 1,
  };

  bool get isPortrait => this == portraitUp;
}
