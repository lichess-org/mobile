import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'game_filter.freezed.dart';

/// A provider for [GameFilter].
final gameFilterProvider = NotifierProvider.autoDispose
    .family<GameFilter, GameFilterState, GameFilterState?>(
      GameFilter.new,
      name: 'GameFilterProvider',
    );

class GameFilter extends Notifier<GameFilterState> {
  GameFilter(this.filter);

  final GameFilterState? filter;

  @override
  GameFilterState build() {
    return filter ?? const GameFilterState();
  }

  void setFilter(GameFilterState filter) =>
      state = state.copyWith(perfs: filter.perfs, side: filter.side);
}

@freezed
sealed class GameFilterState with _$GameFilterState {
  const GameFilterState._();

  const factory GameFilterState({
    @Default(ISet<Perf>.empty()) ISet<Perf> perfs,
    Side? side,
    User? opponent,
  }) = _GameFilterState;

  /// Returns a translated label of the selected filters.
  String selectionLabel(AppLocalizations l10n) {
    final fields = [side, perfs];
    final labels = fields
        .map(
          (field) => field is ISet<Perf>
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
