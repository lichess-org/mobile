import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/create_game_service.dart';

part 'game_screen_providers.g.dart';

// mounted property check logic from:
// https://github.com/rrousselGit/riverpod/issues/1879#issuecomment-1303189191
@riverpod
class LobbyGame extends _$LobbyGame {
  /// The key is used to check if the widget is still mounted.
  late Object? _key;

  @override
  Future<GameFullId> build() {
    _key = Object();
    ref.onDispose(() {
      _service.cancel();
      _key = null;
    });
    return _service.newOnlineGame();
  }

  Future<void> newOpponent() async {
    final key = _key;
    state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() async {
      return _service.newOnlineGame();
    });
    if (key == _key) {
      state = newState;
    }
  }

  CreateGameService get _service => ref.read(createGameServiceProvider);
}

@riverpod
class IsBoardTurned extends _$IsBoardTurned {
  @override
  bool build() {
    return false;
  }

  void toggle() {
    state = !state;
  }
}
