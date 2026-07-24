import 'package:clock/clock.dart' as clock;
import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/clock/chess_clock.dart';
import 'package:lichess_mobile/src/model/clock/clock_tool_preferences.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';

part 'clock_tool_controller.freezed.dart';

enum ClockSide {
  top,
  bottom;

  ClockSide get opposite => this == ClockSide.top ? ClockSide.bottom : ClockSide.top;

  Side get chessClockSide => this == ClockSide.top ? Side.black : Side.white;
}

enum ClockTimeControlType { increment, simpleDelay, bronsteinDelay }

/// A provider for [ClockToolController].
final clockToolControllerProvider = NotifierProvider.autoDispose<ClockToolController, ClockState>(
  ClockToolController.new,
  name: 'ClockToolControllerProvider',
);

class ClockToolController extends Notifier<ClockState> {
  late ChessClock _clock;
  final Map<ClockSide, bool> _hasPlayedLowTimeSound = {
    ClockSide.top: false,
    ClockSide.bottom: false,
  };
  final Map<ClockSide, Duration> _emergencyThresholds = {
    ClockSide.top: Duration.zero,
    ClockSide.bottom: Duration.zero,
  };
  DateTime? _delayStartedAt;
  Duration? _delayDuration;
  Duration? _pausedDelayRemaining;
  Duration? _activeTurnStartedWithTime;

  @override
  ClockState build() {
    // using read is good enough as config change updates in-memory state which re-renders the ui
    // and prefs are also saved
    final topTimeIncrement = ref.read(clockToolPreferencesProvider).topTimeIncrement;
    final topTime = Duration(seconds: topTimeIncrement.time);
    final topIncrement = Duration(seconds: topTimeIncrement.increment);
    final bottomTimeIncrement = ref.read(clockToolPreferencesProvider).bottomTimeIncrement;
    final bottomTime = Duration(seconds: bottomTimeIncrement.time);
    final bottomIncrement = Duration(seconds: bottomTimeIncrement.increment);
    _emergencyThresholds[ClockSide.top] = _calculateEmergencyThreshold(topTime);
    _emergencyThresholds[ClockSide.bottom] = _calculateEmergencyThreshold(bottomTime);
    final options = ClockOptions(
      type: ClockTimeControlType.increment,
      topTime: topTime,
      bottomTime: bottomTime,
      topIncrement: topIncrement,
      bottomIncrement: bottomIncrement,
    );

    _clock = ChessClock(blackTime: topTime, whiteTime: bottomTime, onFlag: _onFlagged);

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
    if (activeSideTime <= _emergencyThresholds[activeSide]!) {
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
    final wasRunning = _clock.isRunning;
    final thinkTime = wasRunning ? _clock.stop() : null;
    state = state.copyWith(
      activeSide: playerType.opposite,
      topMoves: playerType == ClockSide.top && started ? state.topMoves + 1 : state.topMoves,
      bottomMoves: playerType == ClockSide.bottom && started
          ? state.bottomMoves + 1
          : state.bottomMoves,
    );
    ref.read(soundServiceProvider).play(Sound.clock);
    _applyMoveBonus(playerType, wasRunning ? thinkTime : null, _activeTurnStartedWithTime);
    _startActiveSide(playerType.opposite);
  }

  void updateOptions(TimeIncrement timeIncrement) {
    final options = ClockOptions.fromTimeIncrement(timeIncrement, type: state.options.type);
    final threshold = _calculateEmergencyThreshold(Duration(seconds: timeIncrement.time));
    _emergencyThresholds[ClockSide.top] = threshold;
    _emergencyThresholds[ClockSide.bottom] = threshold;
    _hasPlayedLowTimeSound[ClockSide.top] = false;
    _hasPlayedLowTimeSound[ClockSide.bottom] = false;
    _clock.setTimes(blackTime: options.topTime, whiteTime: options.bottomTime);
    state = state.copyWith(
      options: options,
      topTime: _clock.blackTime,
      bottomTime: _clock.whiteTime,
    );
    ref.read(clockToolPreferencesProvider.notifier).setTimeIncrement(timeIncrement);
  }

  void updateOptionsCustom(TimeIncrement clock, ClockSide player) {
    final options = ClockOptions(
      type: state.options.type,
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
    _emergencyThresholds[player] = _calculateEmergencyThreshold(Duration(seconds: clock.time));
    _hasPlayedLowTimeSound[player] = false;
    _clock.setTimes(blackTime: options.topTime, whiteTime: options.bottomTime);
    state = ClockState(
      options: options,
      topTime: _clock.blackTime,
      bottomTime: _clock.whiteTime,
      activeSide: state.activeSide,
      clockOrientation: state.clockOrientation,
    );

    if (player == ClockSide.top) {
      ref.read(clockToolPreferencesProvider.notifier).setTopTimeIncrement(clock);
    } else {
      ref.read(clockToolPreferencesProvider.notifier).setBottomTimeIncrement(clock);
    }
  }

  void updateClockType(ClockTimeControlType type) {
    state = state.copyWith(options: state.options.copyWith(type: type));
    reset();
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
    _activeTurnStartedWithTime = null;
    // Reset low time sound flags for both players
    _hasPlayedLowTimeSound[ClockSide.top] = false;
    _hasPlayedLowTimeSound[ClockSide.bottom] = false;
  }

  void start(ClockSide playerType) {
    state = state.copyWith(activeSide: playerType.opposite);
    _startActiveSide(playerType.opposite);
  }

  void pause() {
    _pausedDelayRemaining = _remainingDelay();
    _clock.stop();
    state = state.copyWith(paused: true);
  }

  void resume() {
    final active = state.activeSide;
    // If the active side started at zero, only resume ticking after that side
    // has completed at least one move; otherwise behave normally.
    final bool hasActiveMoved = active != null && state.getMovesCount(active) > 0;

    if (active != null &&
        (state.options.getStartTime(active).inMilliseconds != 0 || hasActiveMoved)) {
      final delay = _pausedDelayRemaining;
      _markDelay(delay);
      _clock.start(delay: delay);
    }
    _pausedDelayRemaining = null;
    state = state.copyWith(paused: false);
  }

  void toggleOrientation(ClockOrientation clockOrientation) {
    state = state.copyWith(clockOrientation: clockOrientation);
  }

  Duration? _startActiveSide(ClockSide activeSide) {
    // Start the countdown only if either this is not a zero-start clock
    // or the active side has already made at least one move.
    // This makes 0+increment modes usable.
    final bool hasActiveMoved = state.getMovesCount(activeSide) > 0;
    if (state.options.getStartTime(activeSide).inMilliseconds != 0 || hasActiveMoved) {
      final delay = _delayFor(activeSide);
      _markDelay(delay);
      _activeTurnStartedWithTime = state.getDuration(activeSide).value;
      _clock.startSide(activeSide.chessClockSide, delay: delay);
      return null;
    } else {
      _markDelay(null);
      _activeTurnStartedWithTime = null;
      return _clock.stop();
    }
  }

  Duration? _delayFor(ClockSide activeSide) {
    return state.options.type == ClockTimeControlType.simpleDelay
        ? state.options.getIncrementDuration(activeSide)
        : null;
  }

  void _applyMoveBonus(ClockSide playerType, Duration? thinkTime, Duration? turnStartedWithTime) {
    final increment = state.options.getIncrementDuration(playerType);
    final bonus = switch (state.options.type) {
      ClockTimeControlType.increment => increment,
      ClockTimeControlType.simpleDelay => Duration.zero,
      ClockTimeControlType.bronsteinDelay =>
        thinkTime != null && thinkTime > Duration.zero
            ? _minDuration(thinkTime, increment)
            : Duration.zero,
    };
    if (bonus > Duration.zero) {
      _clock.incTime(playerType.chessClockSide, bonus);
      if (state.options.type == ClockTimeControlType.bronsteinDelay &&
          turnStartedWithTime != null &&
          state.getDuration(playerType).value > turnStartedWithTime) {
        _clock.setTime(playerType.chessClockSide, turnStartedWithTime);
      }
    }
  }

  void _markDelay(Duration? delay) {
    if (delay != null && delay > Duration.zero) {
      _delayStartedAt = clock.clock.now();
      _delayDuration = delay;
    } else {
      _delayStartedAt = null;
      _delayDuration = null;
    }
  }

  Duration? _remainingDelay() {
    final startedAt = _delayStartedAt;
    final duration = _delayDuration;
    if (startedAt == null || duration == null) return null;
    final remaining = duration - clock.clock.now().difference(startedAt);
    return remaining > Duration.zero ? remaining : null;
  }
}

Duration _minDuration(Duration a, Duration b) => a < b ? a : b;

@freezed
sealed class ClockOptions with _$ClockOptions {
  const ClockOptions._();

  const factory ClockOptions({
    required ClockTimeControlType type,
    required Duration topTime,
    required Duration bottomTime,
    required Duration topIncrement,
    required Duration bottomIncrement,
  }) = _ClockOptions;

  factory ClockOptions.fromTimeIncrement(
    TimeIncrement timeIncrement, {
    ClockTimeControlType type = ClockTimeControlType.increment,
  }) => ClockOptions(
    type: type,
    topTime: Duration(seconds: timeIncrement.time),
    bottomTime: Duration(seconds: timeIncrement.time),
    topIncrement: Duration(seconds: timeIncrement.increment),
    bottomIncrement: Duration(seconds: timeIncrement.increment),
  );

  factory ClockOptions.fromSeparateTimeIncrements(
    TimeIncrement playerTop,
    TimeIncrement playerBottom,
  ) => ClockOptions(
    type: ClockTimeControlType.increment,
    topTime: Duration(seconds: playerTop.time),
    bottomTime: Duration(seconds: playerBottom.time),
    topIncrement: Duration(seconds: playerTop.increment),
    bottomIncrement: Duration(seconds: playerBottom.increment),
  );

  int getIncrement(ClockSide playerType) {
    return playerType == ClockSide.top ? topIncrement.inSeconds : bottomIncrement.inSeconds;
  }

  Duration getIncrementDuration(ClockSide playerType) {
    return playerType == ClockSide.top ? topIncrement : bottomIncrement;
  }

  bool hasIncrement(ClockSide playerType) {
    return getIncrement(playerType) > 0;
  }

  Duration getStartTime(ClockSide playerType) {
    return playerType == ClockSide.top ? topTime : bottomTime;
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
