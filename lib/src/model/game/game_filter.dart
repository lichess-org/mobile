import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
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

  void setFilter(GameFilterState filter) =>
      state = state.copyWith(perfs: filter.perfs, side: filter.side);
}

@freezed
sealed class GameFilterState with _$GameFilterState {
  const GameFilterState._();

  const factory GameFilterState({@Default(ISet<Perf>.empty()) ISet<Perf> perfs, Side? side}) =
      _GameFilterState;

  /// Returns a translated label of the selected filters.
  String selectionLabel(AppLocalizations l10n) {
    final fields = [side, perfs];
    final labels =
        fields
            .map(
              (field) =>
                  field is ISet<Perf>
                      ? field.map((e) => e.shortTitle).join(', ')
                      : (field as Side?) != null
                      ? field == Side.white
                          ? l10n.white
                          : l10n.black
                      : null,
            )
            .where((label) => label != null && label.isNotEmpty)
            .toList();
    return labels.isEmpty ? 'All' : labels.join(', ');
  }

  int get count {
    final fields = [perfs, side];
    return fields.where((field) => field is Iterable ? field.isNotEmpty : field != null).length;
  }
}
