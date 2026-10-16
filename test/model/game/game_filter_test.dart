import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/game/game_filter.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

import '../../test_container.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));

  group('GameFilterState.count', () {
    test('counts the analysis filter', () {
      expect(const GameFilterState().count, 0);
      expect(const GameFilterState(analysis: GameAnalysisFilter.analysed).count, 1);
      expect(
        const GameFilterState(side: Side.white, analysis: GameAnalysisFilter.notAnalysed).count,
        2,
      );
      expect(
        GameFilterState(
          perfs: {Perf.blitz}.lock,
          side: Side.white,
          analysis: GameAnalysisFilter.analysed,
        ).count,
        3,
      );
    });
  });

  group('GameFilterState.selectionLabel', () {
    test('shows Analysed when only the analysis filter is set', () {
      expect(
        const GameFilterState(analysis: GameAnalysisFilter.analysed).selectionLabel(l10n),
        'Analysed',
      );
    });

    test('shows a label for every analysis value', () {
      expect(
        const GameFilterState(analysis: GameAnalysisFilter.notAnalysed).selectionLabel(l10n),
        'Not analysed',
      );
    });

    test('combines with other filters', () {
      expect(
        const GameFilterState(
          side: Side.white,
          analysis: GameAnalysisFilter.analysed,
        ).selectionLabel(l10n),
        'White, Analysed',
      );
      expect(
        GameFilterState(
          perfs: {Perf.blitz}.lock,
          analysis: GameAnalysisFilter.notAnalysed,
        ).selectionLabel(l10n),
        '${Perf.blitz.shortLabel(l10n)}, Not analysed',
      );
    });

    test('falls back to the all games label when nothing is set', () {
      expect(const GameFilterState().selectionLabel(l10n), l10n.mobileAllGames);
    });
  });

  group('GameFilter.setFilter', () {
    test('applies the analysis filter and can clear it again', () async {
      final container = await makeContainer();
      final provider = gameFilterProvider(null);
      container.listen(provider, (_, _) {});
      final notifier = container.read(provider.notifier);

      notifier.setFilter(
        const GameFilterState(analysis: GameAnalysisFilter.analysed, side: Side.white),
      );
      expect(container.read(provider).analysis, GameAnalysisFilter.analysed);
      expect(container.read(provider).side, Side.white);

      notifier.setFilter(const GameFilterState());
      expect(container.read(provider).analysis, isNull);
      expect(container.read(provider).side, isNull);
    });

    test('keeps the opponent filter that is managed outside of the sheet', () async {
      const opponent = User(id: UserId('opponent'), username: 'Opponent', perfs: IMap.empty());
      final container = await makeContainer();
      final provider = gameFilterProvider(const GameFilterState(opponent: opponent));
      container.listen(provider, (_, _) {});
      final notifier = container.read(provider.notifier);

      notifier.setFilter(const GameFilterState(analysis: GameAnalysisFilter.notAnalysed));

      expect(container.read(provider).analysis, GameAnalysisFilter.notAnalysed);
      expect(container.read(provider).opponent, opponent);
    });
  });
}
