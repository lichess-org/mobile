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

class GameFilter(final GameFilterState? filter) extends Notifier<GameFilterState> {
  @override
  GameFilterState build() {
    return filter ?? const GameFilterState();
  }

  void setFilter(GameFilterState filter) =>
      state = state.copyWith(perfs: filter.perfs, side: filter.side, result: filter.result);
}

/// The result of a game to filter by.
///
/// Only [won] is supported by the server for now (`wonBy` query parameter);
/// [lost] and [draw] are not rendered in the filter UI yet.
enum GameResultFilter() {
  won,
  lost,
  draw,
}

@freezed
sealed class const GameFilterState._() with _$GameFilterState {
  const factory({
    @Default(ISet<Perf>.empty()) ISet<Perf> perfs,
    Side? side,
    User? opponent,
    GameResultFilter? result,
  }) = _GameFilterState;

  /// Returns a translated label of the selected filters.
  String selectionLabel(AppLocalizations l10n) {
    final fields = [side, perfs, result];
    final labels = fields
        .map(
          (field) => field is ISet<Perf>
              ? field.map((e) => e.shortLabel(l10n)).join(', ')
              : field is Side
              ? field == Side.white
                    ? l10n.white
                    : l10n.black
              : field is GameResultFilter
              ? switch (field) {
                  // TODO: translate once a lila key exists for 'won'
                  GameResultFilter.won => 'Won',
                  GameResultFilter.lost => 'Lost',
                  GameResultFilter.draw => 'Draw',
                }
              : null,
        )
        .where((label) => label != null && label.isNotEmpty)
        .toList();
    return labels.isEmpty ? l10n.mobileAllGames : labels.join(', ');
  }

  int get count {
    final fields = [perfs, side, result];
    return fields.where((field) => field is Iterable ? field.isNotEmpty : field != null).length;
  }
}
