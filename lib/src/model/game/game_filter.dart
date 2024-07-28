import 'package:chessground/chessground.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_filter.freezed.dart';
part 'game_filter.g.dart';

@riverpod
class GameFilter extends _$GameFilter {
  @override
  GameFilterState build({GameFilterState? filter}) {
    return filter ?? const GameFilterState();
  }

  void setFilter(GameFilterState filter) => state = state.copyWith(
        perfs: filter.perfs,
        side: filter.side,
      );

  int countFiltersInUse() {
    final fields = [state.perfs, state.side];
    return fields
        .where((field) => field is Iterable ? field.isNotEmpty : field != null)
        .length;
  }
}

@freezed
class GameFilterState with _$GameFilterState {
  const factory GameFilterState({
    @Default(ISet<Perf>.empty()) ISet<Perf> perfs,
    Side? side,
  }) = _GameFilterState;
}
