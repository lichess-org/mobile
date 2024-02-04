import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clock_controller.freezed.dart';
part 'clock_controller.g.dart';

enum ClockPlayerType { top, bottom }

@freezed
class ClockOptions with _$ClockOptions {
  const ClockOptions._();

  const factory ClockOptions({
    required Duration time,
    required Duration increment,
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
    @Default(false) bool paused,
    @Default(0) int turns,
  }) = _ClockState;

  factory ClockState.fromTimeIncrement(TimeIncrement timeIncrement) {
    final options = ClockOptions(
      time: Duration(seconds: timeIncrement.time),
      increment: Duration(seconds: timeIncrement.increment),
    );

    return ClockState(
      id: DateTime.now().millisecondsSinceEpoch,
      options: options,
      playerTopTime: options.time,
      playerBottomTime: options.time,
    );
  }

  factory ClockState.fromOptions(ClockOptions options) {
    return ClockState(
      id: DateTime.now().millisecondsSinceEpoch,
      options: options,
      playerTopTime: options.time,
      playerBottomTime: options.time,
    );
  }

  Duration getDuration(ClockPlayerType playerType) =>
      playerType == ClockPlayerType.top ? playerTopTime : playerBottomTime;

  bool isPlayersTurn(ClockPlayerType playerType) =>
      currentPlayer == playerType || (currentPlayer == null && loser == null);

  bool isPlayersTurnAllowed(ClockPlayerType playerType) =>
      isPlayersTurn(playerType) && !paused;

  bool isActivePlayer(ClockPlayerType playerType) =>
      currentPlayer == playerType && !paused;

  bool isLoser(ClockPlayerType playerType) => loser == playerType;

  int get moveCount => (turns / 2).floor();
}

@riverpod
class ClockController extends _$ClockController {
  @override
  ClockState build() {
    final timeControlPref = ref.watch(
      gameSetupPreferencesProvider.select((prefs) => prefs.timeIncrement),
    );
    return ClockState.fromTimeIncrement(timeControlPref);
  }

  void endTurn(ClockPlayerType playerType) {
    state = state.copyWith(
      currentPlayer: playerType == ClockPlayerType.top
          ? ClockPlayerType.bottom
          : ClockPlayerType.top,
      turns: state.turns + 1,
    );
  }

  void updateDuration(ClockPlayerType playerType, Duration duration) {
    if (state.loser != null || state.currentPlayer == null || state.paused) {
      return;
    }

    if (playerType == ClockPlayerType.top) {
      state = state.copyWith(playerTopTime: duration + state.options.increment);
    } else {
      state =
          state.copyWith(playerBottomTime: duration + state.options.increment);
    }
  }

  void setLoser(ClockPlayerType playerType) =>
      state = state.copyWith(currentPlayer: null, loser: playerType);

  void reset() => state = ClockState.fromOptions(state.options);

  void pause() => state = state.copyWith(paused: true);

  void resume() => state = state.copyWith(paused: false);
}
