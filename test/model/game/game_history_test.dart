import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/game/game_filter.dart';
import 'package:lichess_mobile/src/model/game/game_history.dart';
import 'package:lichess_mobile/src/model/game/game_storage.dart';

import '../../example_data.dart';
import '../../test_container.dart';

void main() {
  group('UserGameHistoryNotifier paging from local storage', () {
    test('keeps the result filter on the next page', () async {
      final container = await makeContainer();
      final storage = await container.read(gameStorageProvider.future);

      // The next page is asked with the last game's createdAt, which the storage compares
      // against the lastModified column: date the seeds ahead of now so a next page exists.
      final createdAt = DateTime.now().add(const Duration(days: 1));
      final seeds = generateExportedGames(count: 25).mapIndexed((index, game) {
        final winner = index.isEven ? Side.white : Side.black;
        return game.copyWith(
          youAre: Side.white,
          winner: winner,
          data: game.data.copyWith(createdAt: createdAt, winner: winner),
        );
      });

      for (final seed in seeds) {
        await storage.save(seed);
        await Future<void>.delayed(const Duration(milliseconds: 1));
      }

      final provider = userGameHistoryProvider((
        userId: null,
        filter: const GameFilterState(result: GameResultFilter.won),
      ));
      container.listen(provider, (_, _) {});

      final firstPage = await container.read(provider.future);
      expect(firstPage.gameList, isNotEmpty);
      expect(firstPage.gameList.every((entry) => entry.game.winner == Side.white), isTrue);

      await container.read(provider.notifier).getNext();

      final state = container.read(provider).requireValue;
      expect(state.gameList.length, greaterThan(firstPage.gameList.length));
      expect(state.gameList.every((entry) => entry.game.winner == Side.white), isTrue);
    });
  });
}
