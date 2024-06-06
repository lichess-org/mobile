import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clock_controller.freezed.dart';
part 'clock_controller.g.dart';

@riverpod
class ClockController extends _$ClockController {
  @override
  ClockState build() {
    const time = Duration(minutes: 10);
    const increment = Duration.zero;
    return ClockState.fromOptions(
      const ClockOptions(
        timePlayerTop: time,
        timePlayerBottom: time,
        incrementPlayerTop: increment,
        incrementPlayerBottom: increment,
      ),
    );
  }

  void onTap(ClockPlayerType playerType) {
    final started = state.started;
    if (playerType == ClockPlayerType.top) {
      state = state.copyWith(
        started: true,
        currentPlayer: ClockPlayerType.bottom,
        playerTopMoves: started ? state.playerTopMoves + 1 : 0,
      );
    } else {
      state = state.copyWith(
        started: true,
        currentPlayer: ClockPlayerType.top,
        playerBottomMoves: started ? state.playerBottomMoves + 1 : 0,
      );
    }
    ref.read(soundServiceProvider).play(Sound.clock);
  }

  void updateDuration(ClockPlayerType playerType, Duration duration) {
    if (state.loser != null || state.currentPlayer == null || state.paused) {
      return;
    }

    if (playerType == ClockPlayerType.top) {
      state = state.copyWith(
        playerTopTime: duration + state.options.incrementPlayerTop,
      );
    } else {
      state = state.copyWith(
        playerBottomTime: duration + state.options.incrementPlayerBottom,
      );
    }
  }

  void updateOptions(TimeIncrement timeIncrement) =>
      state = ClockState.fromTimeIncrement(timeIncrement);

  void updateOptionsCustom(TimeIncrement playerTop, TimeIncrement playerBottom) =>
      state = ClockState.fromSeparateTimeIncrements(playerTop, playerBottom);

  void setLoser(ClockPlayerType playerType) =>
      state = state.copyWith(currentPlayer: null, loser: playerType);

  void reset() => state = ClockState.fromOptions(state.options);

  void pause() => state = state.copyWith(paused: true);

  void resume() => state = state.copyWith(paused: false);
}

enum ClockPlayerType { top, bottom }

@freezed
class ClockOptions with _$ClockOptions {
  const ClockOptions._();

  const factory ClockOptions({
    required Duration timePlayerTop,
    required Duration timePlayerBottom,
    required Duration incrementPlayerTop,
    required Duration incrementPlayerBottom,
  }) = _ClockOptions;
}

@freezed
class ClockState with _$ClockState {
  const ClockState._();

  const factory ClockState({
    required int id,
    required ClockOptions options,
    required Duration playerTopTime,
    required Duration playerBottomTime,
    ClockPlayerType? currentPlayer,
    ClockPlayerType? loser,
    @Default(false) bool started,
    @Default(false) bool paused,
    @Default(0) int playerTopMoves,
    @Default(0) int playerBottomMoves,
  }) = _ClockState;

  factory ClockState.fromTimeIncrement(TimeIncrement timeIncrement) {
    final options = ClockOptions(
      timePlayerTop: Duration(seconds: timeIncrement.time),
      timePlayerBottom: Duration(seconds: timeIncrement.time),
      incrementPlayerTop: Duration(seconds: timeIncrement.increment),
      incrementPlayerBottom: Duration(seconds: timeIncrement.increment),
    );

    return ClockState(
      id: DateTime.now().millisecondsSinceEpoch,
      options: options,
      playerTopTime: options.timePlayerTop,
      playerBottomTime: options.timePlayerBottom,
    );
  }

  factory ClockState.fromSeparateTimeIncrements(
      TimeIncrement playerTop, TimeIncrement playerBottom,) {
    final options = ClockOptions(
      timePlayerTop: Duration(seconds: playerTop.time),
      timePlayerBottom: Duration(seconds: playerBottom.time),
      incrementPlayerTop: Duration(seconds: playerTop.increment),
      incrementPlayerBottom: Duration(seconds: playerBottom.increment),
    );
    return ClockState(
      id: DateTime.now().millisecondsSinceEpoch,
      options: options,
      playerTopTime: options.timePlayerTop,
      playerBottomTime: options.timePlayerBottom,
    );
  }

  factory ClockState.fromOptions(ClockOptions options) {
    return ClockState(
      id: DateTime.now().millisecondsSinceEpoch,
      options: options,
      playerTopTime: options.timePlayerTop,
      playerBottomTime: options.timePlayerBottom,
    );
  }

  Duration getDuration(ClockPlayerType playerType) =>
      playerType == ClockPlayerType.top ? playerTopTime : playerBottomTime;

  int getMovesCount(ClockPlayerType playerType) =>
      playerType == ClockPlayerType.top ? playerTopMoves : playerBottomMoves;

  bool isPlayersTurn(ClockPlayerType playerType) =>
      currentPlayer == playerType || (currentPlayer == null && loser == null);

  bool isPlayersMoveAllowed(ClockPlayerType playerType) =>
      isPlayersTurn(playerType) && !paused;

  bool isActivePlayer(ClockPlayerType playerType) =>
      currentPlayer == playerType && !paused;

  bool isLoser(ClockPlayerType playerType) => loser == playerType;
}
