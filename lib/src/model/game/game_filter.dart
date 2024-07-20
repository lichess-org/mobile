import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_filter.freezed.dart';
part 'game_filter.g.dart';

@riverpod
class GameFilter extends _$GameFilter {

  @override
  GameFilterState build() {
    return const GameFilterState();
  }
}

@freezed
class GameFilterState with _$GameFilterState {
  const factory GameFilterState({
    Perf? perf,
  }) = _GameFilterState;
}
