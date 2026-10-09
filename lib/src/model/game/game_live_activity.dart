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
import 'package:lichess_mobile/src/network/socket.dart';
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

    /// Whether lila's claim-victory rule can apply if the player leaves the game.
    required bool claimable,

    /// How long after lila counts the player as gone to warn them that they left the game, see
    /// [leftWarningDelayOf].
    Duration? leftWarningDelay,
  }) = _GameLiveActivityState;

  /// The state of [game], which must be playable, with the clock times read from the game's live
  /// clock at [now].
  factory fromGame(
    PlayableGame game, {
    required Duration whiteClock,
    required Duration blackClock,
    required DateTime now,
  }) {
    final lastPosition = game.lastPosition;
    return GameLiveActivityState(
      fen: boardFen(lastPosition),
      lastMove: game.lastMove?.uci,
      lastSan: game.steps.last.sanMove?.san,
      turn: lastPosition.turn,
      whiteClock: whiteClock,
      blackClock: blackClock,
      clockAt: now,
      // Same rule as the game clock: it starts once both players have moved.
      clockRunning: game.clock != null && lastPosition.fullmoves > 1,
      claimable: isClaimable(game),
      leftWarningDelay: leftWarningDelayOf(game),
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

  /// How long after lila counts the user as gone from [game] to warn them that they left it: half
  /// the [claimGrace], so that the warning still comes before the claim if the grace is halved
  /// meanwhile (e.g. the opponent captures a piece).
  ///
  /// Null to warn as soon as the app stops running: when no claim is possible, and in bullet, where
  /// the grace is too short to wait for.
  static Duration? leftWarningDelayOf(PlayableGame game) {
    if (!isClaimable(game)) return null;
    return switch (game.meta.speed) {
      .blitz || .rapid || .classical => claimGrace(game) ~/ 2,
      _ => null,
    };
  }

  /// How long lila waits, once it counts the user as gone from [game], before letting the opponent
  /// claim victory.
  ///
  /// Mirrors lila's `RoundSocket.povDisconnectTimeout`: 30 s times a speed factor, halved if the
  /// user is down 4 points of material or more, halved again if they are anonymous, and at least
  /// 10 s. lila also weighs it by a `goneWeight` that is lower for rage-sitters and isn't exposed.
  static Duration claimGrace(PlayableGame game) {
    final speedFactor = switch (game.meta.speed) {
      .classical => 10,
      .rapid => 4,
      .blitz => 2,
      _ => 1,
    };
    final imbalance = materialImbalance(game.lastPosition.board);
    final isDownMaterial = switch (game.meta.variant) {
      .antichess || .crazyhouse || .horde => false,
      _ => game.youAre == Side.white ? imbalance <= -4 : imbalance >= 4,
    };
    final isAnonymous = game.me?.user == null;
    final divisor = (isDownMaterial ? 2 : 1) * (isAnonymous ? 2 : 1);
    final grace = const Duration(seconds: 30) * speedFactor ~/ divisor;
    return grace < const Duration(seconds: 10) ? const Duration(seconds: 10) : grace;
  }

  /// White's material minus black's, in pawns, as lila counts it: pawn 1, knight and bishop 3, rook
  /// 5, queen 9.
  static int materialImbalance(Board board) {
    int material(Side side) => board
        .materialCount(side)
        .entries
        .fold(
          0,
          (sum, entry) =>
              sum +
              entry.value *
                  switch (entry.key) {
                    .pawn => 1,
                    .knight || .bishop => 3,
                    .rook => 5,
                    .queen => 9,
                    .king => 0,
                  },
        );
    return material(.white) - material(.black);
  }

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
    'claimable': claimable,
    'leftWarningDelay': leftWarningDelay?.inMilliseconds,
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
        'socketBackgroundTimeout': kDisconnectOnBackgroundTimeout.inMilliseconds,
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

  /// Ends the activity and removes it at once.
  Future<void> end(String id) async {
    if (!_isIOS) return;
    try {
      await _channel.invokeMethod<void>('end', {'id': id});
    } on PlatformException catch (e, st) {
      _log.severe('end failed', e, st);
    }
  }

  /// Tells whether the game socket is connected: the activity shows "Reconnecting" while it isn't.
  /// Lost in the background, it also dates the "You left the game" notification, as lila counts the
  /// player as gone from then on.
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
