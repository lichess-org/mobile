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
      state = state.copyWith(perfs: filter.perfs, side: filter.side, analysis: filter.analysis);
}

/// Whether to only show games with or without a computer analysis.
///
/// Sent to the server as the `analysed` query parameter on
/// `GET /api/games/user/:username`.
enum GameAnalysisFilter() {
  analysed,
  notAnalysed,
}

@freezed
sealed class const GameFilterState._() with _$GameFilterState {
  const factory({
    @Default(ISet<Perf>.empty()) ISet<Perf> perfs,
    Side? side,
    User? opponent,
    GameAnalysisFilter? analysis,
  }) = _GameFilterState;

  /// Returns a translated label of the selected filters.
  String selectionLabel(AppLocalizations l10n) {
    final fields = [side, perfs, analysis];
    final labels = fields
        .map(
          (field) => field is ISet<Perf>
              ? field.map((e) => e.shortLabel(l10n)).join(', ')
              : field is Side
              ? field == Side.white
                    ? l10n.white
                    : l10n.black
              : field is GameAnalysisFilter
              ? switch (field) {
                  // TODO: translate once decided, same as the result filter labels
                  GameAnalysisFilter.analysed => 'Analysed',
                  GameAnalysisFilter.notAnalysed => 'Not analysed',
                }
              : null,
        )
        .where((label) => label != null && label.isNotEmpty)
        .toList();
    return labels.isEmpty ? l10n.mobileAllGames : labels.join(', ');
  }

  int get count {
    final fields = [perfs, side, analysis];
    return fields.where((field) => field is Iterable ? field.isNotEmpty : field != null).length;
  }
}
