import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/game/game_live_activity.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';

/// How long a finished game stays on the Lock Screen.
const _kDismissAfterGameOver = Duration(minutes: 15);

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
  bool? whiteOffersDraw,
  bool? blackOffersDraw,
  bool? whiteProposesTakeback,
  bool? blackProposesTakeback,
});

/// Keeps the iOS Live Activity of a game in sync with its [GameController].
///
/// Lives as long as the game screen watches it. Starts the activity once the game is loaded, if it
/// is eligible ([GameLiveActivityAttributes.isEligible]), updates it on moves, clock changes and
/// offers, and ends it when the game is over (left on the Lock Screen for a while with the result)
/// or when the game screen is left (removed at once).
class GameLiveActivityController(final GameFullId gameFullId) extends Notifier<void> {
  late GameLiveActivityChannel _channel;
  StreamSubscription<({String id, LiveActivityState state})>? _stateSubscription;

  String? _activityId;

  /// Set once there is nothing more to do: the activity ended or was dismissed, or could not be
  /// started (ineligible game, Live Activities unsupported or disabled).
  bool _done = false;

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
      _stateSubscription?.cancel();
      final id = _activityId;
      _activityId = null;
      if (id != null) _channel.end(id, dismissAfter: Duration.zero);
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
      whiteOffersDraw: game.white.offeringDraw,
      blackOffersDraw: game.black.offeringDraw,
      whiteProposesTakeback: game.white.proposingTakeback,
      blackProposesTakeback: game.black.proposingTakeback,
    );
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

    final content = GameLiveActivityState.fromGame(
      game,
      whiteClock: gameState.liveClock?.white.value ?? game.clock?.white ?? Duration.zero,
      blackClock: gameState.liveClock?.black.value ?? game.clock?.black ?? Duration.zero,
      now: DateTime.now(),
    );

    final id = _activityId;
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
        _channel.end(newId, dismissAfter: Duration.zero);
      } else {
        _activityId = newId;
      }
    } else if (content.isOver) {
      _activityId = null;
      _done = true;
      await _channel.end(id, state: content, dismissAfter: _kDismissAfterGameOver);
    } else {
      await _channel.update(id, content);
    }
  }
}
