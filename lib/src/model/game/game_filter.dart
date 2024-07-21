import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_filter.freezed.dart';
part 'game_filter.g.dart';

@riverpod
class GameFilter extends _$GameFilter {
  @override
  GameFilterState build({Set<Perf>? perfs}) {
    return GameFilterState(perfs: perfs ?? {});
  }

  void setPerfs(Set<Perf>? perfs) => state = state.copyWith(perfs: perfs ?? {});
}

@freezed
class GameFilterState with _$GameFilterState {
  const factory GameFilterState({
    @Default(<Perf>{}) Set<Perf> perfs,
  }) = _GameFilterState;
}
