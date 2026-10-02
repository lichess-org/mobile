import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:logging/logging.dart';

part 'game_live_activity.freezed.dart';

/// A player shown on the game Live Activity.
@freezed
sealed class const GameLiveActivityPlayer._() with _$GameLiveActivityPlayer {
  const factory({required String name, String? title, int? rating}) = _GameLiveActivityPlayer;

  factory fromPlayer(Player player, {required bool showRatings}) => GameLiveActivityPlayer(
    name: player.user?.name ?? player.name ?? 'Anonymous',
    title: player.user?.title,
    rating: showRatings ? player.rating : null,
  );

  Map<String, Object?> toJson() => {'name': name, 'title': title, 'rating': rating};
}

/// The static part of the game Live Activity, set when it starts.
///
/// Must match `GameActivityAttributes` in `ios/LichessWidgets/Game Live Activity/`.
@freezed
sealed class const GameLiveActivityAttributes._() with _$GameLiveActivityAttributes {
  const factory({
    required GameFullId gameFullId,
    required Side myColor,
    required GameLiveActivityPlayer white,
    required GameLiveActivityPlayer black,
  }) = _GameLiveActivityAttributes;

  /// Whether [game] gets a Live Activity: a real-time game, with a clock, that the user plays
  /// against a human.
  static bool isEligible(PlayableGame game) =>
      game.youAre != null &&
      game.playable &&
      game.clock != null &&
      game.meta.speed != Speed.correspondence &&
      !game.hasAI;

  /// The attributes of [game], which must be [isEligible].
  factory fromGame(GameFullId gameFullId, PlayableGame game) {
    final showRatings = game.prefs?.showRatings ?? true;
    return GameLiveActivityAttributes(
      gameFullId: gameFullId,
      myColor: game.youAre!,
      white: .fromPlayer(game.white, showRatings: showRatings),
      black: .fromPlayer(game.black, showRatings: showRatings),
    );
  }

  Map<String, Object?> toJson() => {
    'gameFullId': gameFullId.value,
    'myColor': myColor.name,
    'white': white.toJson(),
    'black': black.toJson(),
  };
}

/// A pending offer from the opponent.
enum GameLiveActivityOffer() {
  draw,
  takeback,
}

/// The dynamic part of the game Live Activity.
///
/// Must match `GameActivityAttributes.ContentState` in `ios/LichessWidgets/Game Live Activity/`.
@freezed
sealed class const GameLiveActivityState._() with _$GameLiveActivityState {
  const factory({
    /// The board part of the FEN, see [boardFen].
    required String fen,
    String? lastMove,
    String? lastSan,
    required Side turn,

    /// Remaining time as of [clockAt].
    required Duration whiteClock,
    required Duration blackClock,
    required DateTime clockAt,

    /// Whether the clock of [turn] is running.
    required bool clockRunning,
    GameLiveActivityOffer? offer,
    required bool isOver,

    /// "1-0", "0-1", "½-½" or "Aborted" once the game is over.
    String? result,

    /// Whether lila's claim-victory rule can apply if the player leaves the game.
    required bool claimable,
  }) = _GameLiveActivityState;

  /// The state of [game], with the clock times read from the game's live clock at [now].
  factory fromGame(
    PlayableGame game, {
    required Duration whiteClock,
    required Duration blackClock,
    required DateTime now,
  }) {
    final lastPosition = game.lastPosition;
    final opponent = game.youAre == null ? null : game.playerOf(game.youAre!.opposite);
    return GameLiveActivityState(
      fen: boardFen(lastPosition),
      lastMove: game.lastMove?.uci,
      lastSan: game.steps.last.sanMove?.san,
      turn: lastPosition.turn,
      whiteClock: whiteClock,
      blackClock: blackClock,
      clockAt: now,
      // Same rule as the game clock: it starts once both players have moved.
      clockRunning: game.playable && game.clock != null && lastPosition.fullmoves > 1,
      offer: !game.playable
          ? null
          : opponent?.offeringDraw == true
          ? GameLiveActivityOffer.draw
          : opponent?.proposingTakeback == true
          ? GameLiveActivityOffer.takeback
          : null,
      isOver: !game.playable,
      result: game.playable
          ? null
          : game.aborted
          ? 'Aborted'
          : switch (game.winner) {
              Side.white => '1-0',
              Side.black => '0-1',
              null => '½-½',
            },
      claimable: isClaimable(game),
    );
  }

  /// Whether lila would let the opponent claim victory if the user left [game] now.
  ///
  /// Mirrors lila's `Game.forceResignableNow`: a clock game against a human, both players have
  /// moved, not in a Swiss tournament, and no `noClaimWin` rule.
  static bool isClaimable(PlayableGame game) =>
      game.playable &&
      game.clock != null &&
      !game.hasAI &&
      game.steps.length > 2 &&
      game.source != GameSource.swiss &&
      !(game.meta.rules?.contains(GameRule.noClaimWin) ?? false);

  /// The board part of [position]'s FEN, without crazyhouse pockets or promoted-piece markers,
  /// which the widget's board view doesn't parse.
  static String boardFen(Position position) => position.board.fen.replaceAll('~', '');

  Map<String, Object?> toJson() => {
    'fen': fen,
    'lastMove': lastMove,
    'lastSan': lastSan,
    'turn': turn.name,
    'whiteClock': whiteClock.inMilliseconds,
    'blackClock': blackClock.inMilliseconds,
    'clockAt': clockAt.millisecondsSinceEpoch.toDouble(),
    'clockRunning': clockRunning,
    'offer': offer?.name,
    'status': isOver ? 'over' : 'started',
    'result': result,
    'claimable': claimable,
  };
}

/// State of a Live Activity, as reported by ActivityKit.
enum LiveActivityState() {
  active,
  ended,
  dismissed,
  stale,
  unknown,
}

/// The channel driving the game Live Activity, as a provider so tests can replace it.
final gameLiveActivityChannelProvider = Provider<GameLiveActivityChannel>(
  (ref) => GameLiveActivityChannel.instance,
  name: 'GameLiveActivityChannelProvider',
);

/// Drives the iOS game Live Activity through the `mobile.lichess.org/live_activity` channel.
///
/// Every method is a no-op returning `null`/`false` on other platforms.
class GameLiveActivityChannel._() {
  this {
    if (_isIOS) _channel.setMethodCallHandler(_handleCall);
  }

  static final instance = GameLiveActivityChannel._();

  static const _channel = MethodChannel('mobile.lichess.org/live_activity');

  static final _log = Logger('GameLiveActivity');

  static bool get _isIOS => defaultTargetPlatform == TargetPlatform.iOS;

  final _stateChanges = StreamController<({String id, LiveActivityState state})>.broadcast();

  /// Changes of an activity's state, e.g. [LiveActivityState.dismissed] when the user removes it.
  Stream<({String id, LiveActivityState state})> get stateChanges => _stateChanges.stream;

  /// Whether Live Activities are available (iOS 16.2+) and allowed by the user.
  Future<bool> isSupported() async {
    if (!_isIOS) return false;
    try {
      return await _channel.invokeMethod<bool>('isSupported') ?? false;
    } on PlatformException catch (e, st) {
      _log.severe('isSupported failed', e, st);
      return false;
    }
  }

  /// Starts a new activity and returns its id, or `null` if it could not be started.
  ///
  /// Must be called while the app is in the foreground.
  Future<String?> start(GameLiveActivityAttributes attributes, GameLiveActivityState state) async {
    if (!_isIOS) return null;
    try {
      return await _channel.invokeMethod<String>('start', {
        'attributes': attributes.toJson(),
        'state': state.toJson(),
      });
    } on PlatformException catch (e, st) {
      _log.severe('start failed', e, st);
      return null;
    }
  }

  Future<void> update(String id, GameLiveActivityState state) async {
    if (!_isIOS) return;
    try {
      await _channel.invokeMethod<void>('update', {'id': id, 'state': state.toJson()});
    } on PlatformException catch (e, st) {
      _log.severe('update failed', e, st);
    }
  }

  /// Ends the activity, optionally with a final [state], keeping it on the Lock Screen for
  /// [dismissAfter] (system default if null).
  Future<void> end(String id, {GameLiveActivityState? state, Duration? dismissAfter}) async {
    if (!_isIOS) return;
    try {
      await _channel.invokeMethod<void>('end', {
        'id': id,
        'state': state?.toJson(),
        'dismissAfterSeconds': dismissAfter == null ? null : dismissAfter.inMilliseconds / 1000,
      });
    } on PlatformException catch (e, st) {
      _log.severe('end failed', e, st);
    }
  }

  /// Tells whether the game socket is connected: losing it while the app is in the background
  /// shows "You left the game" at once.
  Future<void> setConnected(bool connected) async {
    if (!_isIOS) return;
    try {
      await _channel.invokeMethod<void>('setConnected', {'connected': connected});
    } on PlatformException catch (e, st) {
      _log.severe('setConnected failed', e, st);
    }
  }

  /// Ends all game activities immediately.
  Future<void> endAll() async {
    if (!_isIOS) return;
    try {
      await _channel.invokeMethod<void>('endAll');
    } on PlatformException catch (e, st) {
      _log.severe('endAll failed', e, st);
    }
  }

  Future<void> _handleCall(MethodCall call) async {
    if (call.method != 'onActivityState') return;
    final args = (call.arguments as Map<Object?, Object?>).cast<String, Object?>();
    final state = LiveActivityState.values.asNameMap()[args['state']] ?? LiveActivityState.unknown;
    _stateChanges.add((id: args['id']! as String, state: state));
  }
}
