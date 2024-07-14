import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:lichess_mobile/src/model/game/game_storage.dart';

class MockGameStorage implements GameStorage {
  @override
  Future<void> delete(GameId gameId) {
    return Future.value();
  }

  @override
  Future<ArchivedGame?> fetch({required GameId gameId}) {
    return Future.value(null);
  }

  @override
  Future<IList<StoredGame>> page({
    UserId? userId,
    DateTime? until,
    int max = 10,
  }) {
    return Future.value(IList());
  }

  @override
  Future<void> save(ArchivedGame game) {
    return Future.value();
  }

  @override
  Future<int> count({UserId? userId}) {
    return Future.value(0);
  }
}
