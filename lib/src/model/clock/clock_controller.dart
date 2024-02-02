import 'package:freezed_annotation/freezed_annotation.dart';
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
    required ClockOptions options,
    required Duration playerTopTime,
    required Duration playerBottomTime,
    ClockPlayerType? activePlayer,
  }) = _ClockState;

  factory ClockState.fromOptions(ClockOptions options) {
    return ClockState(
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
    final initial = ClockState.fromOptions(
      const ClockOptions(
        time: Duration(minutes: 5),
        increment: Duration(seconds: 5),
      ),
    );

    return initial;
  }

  void endTurn(ClockPlayerType playerType) {
    state =
        state.copyWith(activePlayer: playerType == ClockPlayerType.top ? ClockPlayerType.bottom : ClockPlayerType.top);
  }

  void updateDuration(ClockPlayerType playerType, Duration duration) {
    if (playerType == ClockPlayerType.top) {
      state = state.copyWith(playerTopTime: duration + state.options.increment);
    } else {
      state = state.copyWith(playerBottomTime: duration + state.options.increment);
    }
  }
}
