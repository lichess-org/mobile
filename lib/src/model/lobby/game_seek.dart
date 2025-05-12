import 'dart:math' as math;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup_preferences.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'game_seek.freezed.dart';

/// A seek is a request to play a game with a specific time control, variant,
/// and rating range.
///
/// See corresponding API docs:
/// https://lichess.org/api#tag/Board/operation/apiBoardSeek
@freezed
class GameSeek with _$GameSeek {
  const GameSeek._();

  @Assert(
    'ratingDelta == null || ratingRange == null',
    'Rating delta and rating range cannot be used together',
  )
  @Assert('clock != null || days != null', 'Either clock or days must be set')
  const factory GameSeek({
    (Duration time, Duration increment)? clock,
    int? days,
    required bool rated,
    Variant? variant,

    /// Rating range
    (int, int)? ratingRange,

    /// Rating delta to apply to the user's current rating.
    (int, int)? ratingDelta,
  }) = _GameSeek;

  /// Construct a game seek from a predefined time control.
  factory GameSeek.fastPairing(TimeIncrement setup, AuthSessionState? session) {
    return GameSeek(
      clock: (Duration(seconds: setup.time), Duration(seconds: setup.increment)),
      rated: session != null,
    );
  }

  /// Construct a game seek from saved [GameSetupPrefs], using all the custom params.
  factory GameSeek.custom(GameSetupPrefs setup, User? account) {
    return GameSeek(
      clock: (
        Duration(seconds: setup.timeIncrement.time),
        Duration(seconds: setup.timeIncrement.increment),
      ),
      rated: account != null && setup.customRated,
      variant: setup.customVariant,
      ratingRange: account != null ? setup.realTimeRatingRange(account) : null,
    );
  }

  /// Construct a correspondence seek from saved [GameSetupPrefs].
  factory GameSeek.correspondence(GameSetupPrefs setup, User? account) {
    return GameSeek(
      days: setup.customDaysPerTurn,
      rated: account != null && setup.customRated,
      variant: setup.customVariant,
      ratingRange: account != null ? setup.correspondenceRatingRange(account) : null,
    );
  }

  /// Construct a game seek from a playable game to find a new opponent, using
  /// the same time control, variant and rated status.
  factory GameSeek.newOpponentFromGame(PlayableGame game, GameSetupPrefs setup) {
    return GameSeek(
      clock:
          game.meta.clock != null ? (game.meta.clock!.initial, game.meta.clock!.increment) : null,
      rated: game.meta.rated,
      variant: game.meta.variant,
      ratingDelta: game.source == GameSource.lobby ? setup.customRatingDelta : null,
    );
  }

  /// Returns a copy of this seek with the rating range set to the user's
  /// current rating +/- the rating delta.
  GameSeek withRatingRangeOf(User user) {
    if (ratingDelta == null) return this;
    final userPerf = user.perfs[perf];
    if (userPerf == null) return this;
    if (userPerf.provisional == true) return this;
    final min = math.max(0, userPerf.rating + ratingDelta!.$1);
    final max = userPerf.rating + ratingDelta!.$2;
    final range = (min, max);
    return copyWith(ratingRange: range, ratingDelta: null);
  }

  TimeIncrement? get timeIncrement =>
      clock != null ? TimeIncrement(clock!.$1.inSeconds, clock!.$2.inSeconds) : null;

  Perf get perf => Perf.fromVariantAndSpeed(
    variant ?? Variant.standard,
    timeIncrement != null ? Speed.fromTimeIncrement(timeIncrement!) : Speed.correspondence,
  );

  Map<String, String> get requestBody => {
    if (clock != null) 'time': (clock!.$1.inSeconds / 60).toString(),
    if (clock != null) 'increment': clock!.$2.inSeconds.toString(),
    if (days != null) 'days': days.toString(),
    'rated': rated.toString(),
    if (variant != null) 'variant': variant!.name,
    if (ratingRange != null) 'ratingRange': '${ratingRange!.$1}-${ratingRange!.$2}',
  };
}
