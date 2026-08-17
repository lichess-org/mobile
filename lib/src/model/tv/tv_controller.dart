import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';
import 'package:lichess_mobile/src/model/tv/tv_game_controller.dart';
import 'package:lichess_mobile/src/model/tv/tv_repository.dart';
import 'package:lichess_mobile/src/model/user/user_repository.dart';

typedef TvControllerParams = ({
  TvChannel? channel,
  (GameId id, Side orientation)? initialGame,
  UserId? userId,
});

final tvControllerProvider = AsyncNotifierProvider.autoDispose
    .family<TvController, TvGameControllerParams, TvControllerParams>(
      TvController.new,
      name: 'TvControllerProvider',
    );

/// Resolves which game to watch on the TV screen and moves to the next game
/// when the watched channel switches.
///
/// The actual game (board, moves, chat) is handled by the [TvGameController]
/// identified by the [TvGameControllerParams] exposed as this controller's
/// state.
class TvController extends AsyncNotifier<TvGameControllerParams> {
  TvController(this.params);

  final TvControllerParams params;

  @override
  Future<TvGameControllerParams> build() {
    assert(
      params.channel != null || params.userId != null || params.initialGame != null,
      'Either a channel, a userId or an initial game must be provided',
    );

    return _resolveGame(params.initialGame);
  }

  /// Called when the watched channel selects a new game.
  void moveToNextGame((GameId id, Side orientation) game) {
    state = AsyncValue.data((gameId: game.$1, orientation: game.$2, source: params));
  }

  /// Looks up which game should be watched now and switches to it.
  ///
  /// For channel TV this re-fetches the channel's featured game; for user TV it
  /// fetches the user's current game from the API.
  Future<void> resolveCurrentGame() async {
    state = AsyncValue.data(await _resolveGame(null));
  }

  Future<TvGameControllerParams> _resolveGame((GameId id, Side orientation)? game) async {
    GameId id;
    Side orientation;

    if (game != null) {
      id = game.$1;
      orientation = game.$2;
    } else if (params.channel != null) {
      final channels = await ref.read(tvRepositoryProvider).channels();
      final channelGame = channels[params.channel!]!;
      id = channelGame.id;
      orientation = channelGame.side ?? Side.white;
    } else if (params.userId != null) {
      final userGame = await ref.read(userRepositoryProvider).getCurrentGame(params.userId!);
      id = userGame.id;
      orientation = userGame.playerSideOf(params.userId!) ?? Side.white;
    } else {
      id = state.value?.gameId ?? params.initialGame!.$1;
      orientation = state.value?.orientation ?? params.initialGame!.$2;
    }

    return (gameId: id, orientation: orientation, source: params);
  }
}
