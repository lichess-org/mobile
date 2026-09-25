import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_game_storage.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';

import '../../example_data.dart';
import '../../test_container.dart';

void main() {
  group('CorrespondenceGameStorage', () {
    test('save and fetch data', () async {
      final container = await makeContainer();

      final storage = await container.read(correspondenceGameStorageProvider.future);

      await storage.save(offlineCorrespondenceGame);
      expect(
        storage.fetch(gameId: offlineCorrespondenceGameId),
        completion(equals(offlineCorrespondenceGame)),
      );
    });

    test('fetchOngoingGames only returns started games of the given user', () async {
      final container = await makeContainer();

      final storage = await container.read(correspondenceGameStorageProvider.future);

      // the example game belongs to whiteId since [OfflineCorrespondenceGame.youAre] is white
      await storage.save(offlineCorrespondenceGame);
      await storage.save(
        offlineCorrespondenceGame.copyWith(id: const GameId('otherGme'), status: GameStatus.resign),
      );

      final ongoing = await storage.fetchOngoingGames(const UserId('whiteId'));
      expect(ongoing.length, 1);
      expect(ongoing.first.$2.id, offlineCorrespondenceGameId);

      expect(await storage.fetchOngoingGames(const UserId('blackId')), isEmpty);
      expect(await storage.fetchOngoingGames(null), isEmpty);
    });

    test(
      'fetchGamesWithRegisteredMove only returns games of the given user with a pending move',
      () async {
        final container = await makeContainer();

        final storage = await container.read(correspondenceGameStorageProvider.future);

        final registeredMove = ('e4 e5', NormalMove.fromUci('f1c4'));
        final gameWithMove = offlineCorrespondenceGame.copyWith(
          id: const GameId('otherGme'),
          registeredMoveAtPgn: registeredMove,
        );
        final otherUserGameWithMove = gameWithMove.copyWith(
          id: const GameId('thirdGme'),
          youAre: Side.black,
        );

        // no registered move
        await storage.save(offlineCorrespondenceGame);
        await storage.save(gameWithMove);
        await storage.save(otherUserGameWithMove);

        final whiteGames = await storage.fetchGamesWithRegisteredMove(const UserId('whiteId'));
        expect(whiteGames.length, 1);
        expect(whiteGames.first.$2.id, const GameId('otherGme'));

        final blackGames = await storage.fetchGamesWithRegisteredMove(const UserId('blackId'));
        expect(blackGames.length, 1);
        expect(blackGames.first.$2.id, const GameId('thirdGme'));

        expect(await storage.fetchGamesWithRegisteredMove(null), isEmpty);
      },
    );
  });
}
