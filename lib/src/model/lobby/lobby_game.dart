import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/create_game_service.dart';

import 'game_seek.dart';

part 'lobby_game.g.dart';

/// The [LobbyGame] provider is used to create a new online game from the lobby
/// or pool sources.
///
/// It handles rematch requests and new opponent requests.
/// Game creation logic is delegated to [CreateGameService].
@riverpod
class LobbyGame extends _$LobbyGame {
  /// The key is used to check if the widget is still mounted.
  late Object? _key;

  @override
  Future<GameFullId> build(GameSeek seek) {
    _key = Object();
    ref.onDispose(() {
      _service.cancel();
      _key = null;
    });
    return _service.newLobbyGame(seek);
  }

  Future<void> newOpponent() async {
    final key = _key;
    state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() {
      return _service.newLobbyGame(seek);
    });
    // mounted property check logic from:
    // https://github.com/rrousselGit/riverpod/issues/1879#issuecomment-1303189191
    if (key == _key) {
      state = newState;
    }
  }

  void rematch(GameFullId id) {
    state = AsyncValue.data(id);
  }

  CreateGameService get _service => ref.read(createGameServiceProvider);
}
