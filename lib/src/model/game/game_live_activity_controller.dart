import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/game/game_live_activity.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/network/socket.dart';

/// A provider for [GameLiveActivityController].
final gameLiveActivityControllerProvider = NotifierProvider.autoDispose
    .family<GameLiveActivityController, void, GameFullId>(
      GameLiveActivityController.new,
      name: 'GameLiveActivityControllerProvider',
    );

/// The parts of a game shown on the Live Activity, apart from the live clock times: the activity
/// is only updated when one of them changes.
typedef _SyncKey = ({
  int nbSteps,
  GameStatus status,
  Side? winner,
  Duration? whiteClock,
  Duration? blackClock,
});

/// Keeps the iOS Live Activity of a game in sync with its [GameController].
///
/// Lives as long as the game screen watches it. Starts the activity once the game is loaded, if it
/// is eligible ([GameLiveActivityAttributes.isEligible]), updates it on moves and clock changes,
/// and removes it at once when the game is over or when the game screen is left. Also reports the
/// game socket's connection state, which the activity shows as "Reconnecting" while it is down.
class GameLiveActivityController(final GameFullId gameFullId) extends Notifier<void> {
  late GameLiveActivityChannel _channel;
  StreamSubscription<({String id, LiveActivityState state})>? _stateSubscription;

  String? _activityId;

  /// Set once there is nothing more to do: the activity ended or was dismissed, or could not be
  /// started (ineligible game, Live Activities unsupported or disabled).
  bool _done = false;

  /// The game's socket client, watched for its connection state.
  SocketClient? _socketClient;

  /// The connection state last sent with [GameLiveActivityChannel.setConnected].
  bool? _sentConnected;

  bool _syncing = false;
  bool _needsSync = false;

  @override
  void build() {
    _channel = ref.read(gameLiveActivityChannelProvider);

    _stateSubscription = _channel.stateChanges.listen((change) {
      if (change.id == _activityId &&
          (change.state == LiveActivityState.dismissed ||
              change.state == LiveActivityState.ended)) {
        _activityId = null;
        _done = true;
      }
    });

    ref.listen(
      gameControllerProvider(gameFullId).select(_syncKeyOf),
      (_, _) => _sync(),
      fireImmediately: true,
    );

    ref.onDispose(() {
      _socketClient?.averageLag.removeListener(_syncConnected);
      _stateSubscription?.cancel();
      final id = _activityId;
      _activityId = null;
      if (id != null) _channel.end(id);
    });
  }

  static _SyncKey? _syncKeyOf(AsyncValue<GameState> state) {
    final game = state.value?.game;
    if (game == null) return null;
    return (
      nbSteps: game.steps.length,
      status: game.status,
      winner: game.winner,
      whiteClock: game.clock?.white,
      blackClock: game.clock?.black,
    );
  }

  /// Watches the game's socket client, the pool's current one once the game is loaded.
  ///
  /// Checked on every sync, as the pool replaces the client if it was disposed meanwhile. The
  /// client is watched rather than the pool's lag, which only mirrors a client's lag once it
  /// changes, and so can miss the first change after switching route.
  void _watchSocket() {
    final client = ref.read(socketPoolProvider).currentClient;
    if (client == _socketClient || client.route != GameController.socketUri(gameFullId)) return;
    _socketClient?.averageLag.removeListener(_syncConnected);
    _socketClient = client;
    client.averageLag.addListener(_syncConnected);
  }

  /// Sends the game socket's connection state to the activity when it changes.
  void _syncConnected() {
    if (_activityId == null || !ref.mounted) return;
    final client = _socketClient;
    final connected =
        client != null &&
        client == ref.read(socketPoolProvider).currentClient &&
        client.isConnected;
    if (connected == _sentConnected) return;
    _sentConnected = connected;
    _channel.setConnected(connected);
  }

  /// Sends the current game state to the activity, one call at a time: a change arriving while a
  /// call is in flight is sent once it completes, with the state current at that point.
  Future<void> _sync() async {
    if (_syncing) {
      _needsSync = true;
      return;
    }
    _syncing = true;
    try {
      do {
        _needsSync = false;
        await _syncOnce();
      } while (_needsSync && ref.mounted);
    } finally {
      _syncing = false;
    }
  }

  Future<void> _syncOnce() async {
    if (_done || !ref.mounted) return;
    final gameState = ref.read(gameControllerProvider(gameFullId)).value;
    if (gameState == null) return;
    final game = gameState.game;
    _watchSocket();

    final id = _activityId;
    if (!game.playable) {
      _done = true;
      if (id != null) {
        _activityId = null;
        await _channel.end(id);
      }
      return;
    }

    final content = GameLiveActivityState.fromGame(
      game,
      whiteClock: gameState.liveClock?.white.value ?? game.clock?.white ?? Duration.zero,
      blackClock: gameState.liveClock?.black.value ?? game.clock?.black ?? Duration.zero,
      now: DateTime.now(),
    );

    if (id == null) {
      if (!GameLiveActivityAttributes.isEligible(game) || !await _channel.isSupported()) {
        _done = true;
        return;
      }
      if (!ref.mounted) return;
      final newId = await _channel.start(
        GameLiveActivityAttributes.fromGame(gameFullId, game),
        content,
      );
      if (newId == null) {
        _done = true;
      } else if (!ref.mounted) {
        // The game screen was left while the activity was starting.
        _channel.end(newId);
      } else {
        _activityId = newId;
        _syncConnected();
      }
    } else {
      await _channel.update(id, content);
    }
  }
}
