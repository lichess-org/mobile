import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_game_storage.dart';

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
  });
}
