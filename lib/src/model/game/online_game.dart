import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lichess_mobile/src/model/common/id.dart';

part 'online_game.g.dart';

/// The [OnlineGame] provider is used by [StandAloneGameScreen] to provide the game
/// and optionally next games if there are rematches.
@riverpod
class OnlineGame extends _$OnlineGame {
  @override
  GameFullId build(GameFullId initialId) {
    return initialId;
  }

  // ignore: use_setters_to_change_properties
  void rematch(GameFullId id) {
    state = id;
  }
}
