import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/clock/chess_clock.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clock_tool_controller.freezed.dart';
part 'clock_tool_controller.g.dart';

@riverpod
class ClockToolController extends _$ClockToolController {
  late final ChessClock _clock;
  final Map<Side, bool> _hasPlayedLowTimeSound = {Side.white: false, Side.black: false};
  late Duration _emergencyThreshold;

  @override
  ClockState build() {
    const time = Duration(minutes: 10);
    const increment = Duration.zero;
    _emergencyThreshold = _calculateEmergencyThreshold(time);
    const options = ClockOptions(
      whiteTime: time,
      blackTime: time,
      whiteIncrement: increment,
      blackIncrement: increment,
    );

    _clock = ChessClock(whiteTime: time, blackTime: time, onFlag: _onFlagged);

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
      whiteTime: _clock.whiteTime,
      blackTime: _clock.blackTime,
      activeSide: Side.white,
      clockOrientation: ClockOrientation.portraitUp,
    );
  }

  // Emergency threshold is set to 10% of the total time
  Duration _calculateEmergencyThreshold(Duration initialTime) {
    return Duration(milliseconds: (initialTime.inMilliseconds * 0.1).round());
  }

  void onClockEmergency() {
    final activeSide = state.activeSide;
    if (_hasPlayedLowTimeSound[activeSide]!) return;
    final activeSideTime =
        activeSide == Side.white ? _clock.whiteTime.value : _clock.blackTime.value;
    if (activeSideTime <= _emergencyThreshold) {
      ref.read(soundServiceProvider).play(Sound.lowTime);
      _hasPlayedLowTimeSound[activeSide] = true;
    }
  }

  void _onFlagged() {
    _clock.stop();
    state = state.copyWith(flagged: _clock.activeSide);
  }

  void onTap(Side playerType) {
    final started = state.started;
    if (playerType == Side.white) {
      state = state.copyWith(
        started: true,
        activeSide: Side.black,
        whiteMoves: started ? state.whiteMoves + 1 : 0,
      );
    } else {
      state = state.copyWith(
        started: true,
        activeSide: Side.white,
        blackMoves: started ? state.blackMoves + 1 : 0,
      );
    }
    ref.read(soundServiceProvider).play(Sound.clock);
    _clock.startSide(playerType.opposite);
    _clock.incTime(
      playerType,
      playerType == Side.white ? state.options.whiteIncrement : state.options.blackIncrement,
    );
  }

  void updateDuration(Side playerType, Duration duration) {
    if (state.flagged != null || state.paused) {
      return;
    }

    _clock.setTimes(
      whiteTime: playerType == Side.white ? duration + state.options.whiteIncrement : null,
      blackTime: playerType == Side.black ? duration + state.options.blackIncrement : null,
    );
  }

  void updateOptions(TimeIncrement timeIncrement) {
    final options = ClockOptions.fromTimeIncrement(timeIncrement);
    _emergencyThreshold = _calculateEmergencyThreshold(Duration(seconds: timeIncrement.time));
    _hasPlayedLowTimeSound[Side.white] = false;
    _hasPlayedLowTimeSound[Side.black] = false;
    _clock.setTimes(whiteTime: options.whiteTime, blackTime: options.blackTime);
    state = state.copyWith(
      options: options,
      whiteTime: _clock.whiteTime,
      blackTime: _clock.blackTime,
    );
  }

  void updateOptionsCustom(TimeIncrement clock, Side player) {
    final options = ClockOptions(
      whiteTime: player == Side.white ? Duration(seconds: clock.time) : state.options.whiteTime,
      blackTime: player == Side.black ? Duration(seconds: clock.time) : state.options.blackTime,
      whiteIncrement:
          player == Side.white ? Duration(seconds: clock.increment) : state.options.whiteIncrement,
      blackIncrement:
          player == Side.black ? Duration(seconds: clock.increment) : state.options.blackIncrement,
    );
    _clock.setTimes(whiteTime: options.whiteTime, blackTime: options.blackTime);
    state = ClockState(
      options: options,
      whiteTime: _clock.whiteTime,
      blackTime: _clock.blackTime,
      activeSide: state.activeSide,
      clockOrientation: state.clockOrientation,
    );
  }

  void setBottomPlayer(Side playerType) => state = state.copyWith(bottomPlayer: playerType);

  void reset() {
    _clock.setTimes(whiteTime: state.options.whiteTime, blackTime: state.options.whiteTime);
    // Reset low time sound flags for both players
    _hasPlayedLowTimeSound[Side.white] = false;
    _hasPlayedLowTimeSound[Side.black] = false;
    state = state.copyWith(
      whiteTime: _clock.whiteTime,
      blackTime: _clock.blackTime,
      activeSide: Side.white,
      flagged: null,
      started: false,
      paused: false,
      whiteMoves: 0,
      blackMoves: 0,
    );
  }

  void start() {
    _clock.startSide(Side.white);
    state = state.copyWith(started: true);
  }

  void pause() {
    _clock.stop();
    state = state.copyWith(paused: true);
  }

  void resume() {
    _clock.start();
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
    required Duration whiteTime,
    required Duration blackTime,
    required Duration whiteIncrement,
    required Duration blackIncrement,
  }) = _ClockOptions;

  factory ClockOptions.fromTimeIncrement(TimeIncrement timeIncrement) => ClockOptions(
    whiteTime: Duration(seconds: timeIncrement.time),
    blackTime: Duration(seconds: timeIncrement.time),
    whiteIncrement: Duration(seconds: timeIncrement.increment),
    blackIncrement: Duration(seconds: timeIncrement.increment),
  );

  factory ClockOptions.fromSeparateTimeIncrements(
    TimeIncrement playerTop,
    TimeIncrement playerBottom,
  ) => ClockOptions(
    whiteTime: Duration(seconds: playerTop.time),
    blackTime: Duration(seconds: playerBottom.time),
    whiteIncrement: Duration(seconds: playerTop.increment),
    blackIncrement: Duration(seconds: playerBottom.increment),
  );
}

@freezed
sealed class ClockState with _$ClockState {
  const ClockState._();

  const factory ClockState({
    required ClockOptions options,
    required ValueListenable<Duration> whiteTime,
    required ValueListenable<Duration> blackTime,
    required Side activeSide,
    @Default(Side.white) Side bottomPlayer,
    Side? flagged,
    @Default(false) bool started,
    @Default(false) bool paused,
    @Default(0) int whiteMoves,
    @Default(0) int blackMoves,
    required ClockOrientation clockOrientation,
  }) = _ClockState;

  ValueListenable<Duration> getDuration(Side playerType) =>
      playerType == Side.white ? whiteTime : blackTime;

  int getMovesCount(Side playerType) => playerType == Side.white ? whiteMoves : blackMoves;

  bool isPlayersTurn(Side playerType) => started && activeSide == playerType && flagged == null;

  bool isPlayersMoveAllowed(Side playerType) => isPlayersTurn(playerType) && !paused;

  bool isActivePlayer(Side playerType) => isPlayersTurn(playerType) && !paused;

  bool isFlagged(Side playerType) => flagged == playerType;
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
