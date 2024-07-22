import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_filter.freezed.dart';
part 'game_filter.g.dart';

@riverpod
class GameFilter extends _$GameFilter {
  @override
  GameFilterState build({ISet<Perf>? perfs}) {
    return GameFilterState(perfs: perfs ?? const ISet.empty());
  }

  void setPerfs(ISet<Perf> perfs) => state = state.copyWith(perfs: perfs);
}

@freezed
class GameFilterState with _$GameFilterState {
  const factory GameFilterState({
    @Default(ISet<Perf>.empty()) ISet<Perf> perfs,
  }) = _GameFilterState;
}
