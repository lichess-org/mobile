import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
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
    ClockPlayerType? activePlayer,
    ClockPlayerType? loser,
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
}

@riverpod
class ClockController extends _$ClockController {
  @override
  ClockState build() {
    final initial = ClockState.fromTimeIncrement(
      const TimeIncrement(5, 2),
    );

    return initial;
  }

  void endTurn(ClockPlayerType playerType) {
    state =
        state.copyWith(activePlayer: playerType == ClockPlayerType.top ? ClockPlayerType.bottom : ClockPlayerType.top);
  }

  void updateDuration(ClockPlayerType playerType, Duration duration) {
    if (state.loser != null || state.activePlayer == null) return;

    if (playerType == ClockPlayerType.top) {
      state = state.copyWith(playerTopTime: duration + state.options.increment);
    } else {
      state = state.copyWith(playerBottomTime: duration + state.options.increment);
    }
  }

  void setLoser(ClockPlayerType playerType) {
    state = state.copyWith(activePlayer: null, loser: playerType);
  }

  void reset() {
    state = ClockState.fromOptions(state.options);
  }
}
