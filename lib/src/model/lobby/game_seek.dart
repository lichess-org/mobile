import 'dart:math' as math;

import 'package:dartchess/dartchess.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/settings/play_preferences.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'game_seek.freezed.dart';

@freezed
class GameSeek with _$GameSeek {
  const GameSeek._();

  @Assert('clock != null || days != null')
  const factory GameSeek({
    (Duration time, Duration increment)? clock,
    int? days,
    required bool rated,
    Variant? variant,
    Side? side,
    (int, int)? ratingRange,
  }) = _GameSeek;

  factory GameSeek.fastPairingFromPrefs(
    PlayPrefs playPref,
    AuthSessionState? session,
  ) {
    return GameSeek(
      clock: (
        Duration(seconds: playPref.timeIncrement.time),
        Duration(seconds: playPref.timeIncrement.increment),
      ),
      rated: session != null,
    );
  }

  factory GameSeek.customFromPrefs(
    PlayPrefs playPref,
    AuthSessionState? session,
    UserPerf? userPerf,
  ) {
    return GameSeek(
      clock: (
        Duration(seconds: playPref.customTimeSeconds),
        Duration(seconds: playPref.customIncrementSeconds),
      ),
      rated: session != null && playPref.customRated,
      variant: playPref.customVariant,
      side: playPref.customRated == true ||
              playPref.customSide == PlayableSide.random
          ? null
          : playPref.customSide == PlayableSide.white
              ? Side.white
              : Side.black,
      ratingRange: userPerf != null && userPerf.provisional != true
          ? (
              math.max(0, userPerf.rating + playPref.customRatingRange.$1),
              userPerf.rating + playPref.customRatingRange.$2
            )
          : null,
    );
  }

  factory GameSeek.correspondenceFromPrefs(
    PlayPrefs playPref,
    AuthSessionState? session,
    UserPerf? userPerf,
  ) {
    return GameSeek(
      days: playPref.correspondenceDaysPerTurn,
      rated: session != null && playPref.correspondenceRated,
      variant: playPref.correspondenceVariant,
      side: playPref.correspondenceRated == true ||
              playPref.correspondenceSide == PlayableSide.random
          ? null
          : playPref.correspondenceSide == PlayableSide.white
              ? Side.white
              : Side.black,
      ratingRange: userPerf != null && userPerf.provisional != true
          ? (
              math.max(
                0,
                userPerf.rating + playPref.correspondenceRatingRange.$1,
              ),
              userPerf.rating + playPref.correspondenceRatingRange.$2
            )
          : null,
    );
  }

  TimeIncrement? get timeIncrement => clock != null
      ? TimeIncrement(
          clock!.$1.inSeconds,
          clock!.$2.inSeconds,
        )
      : null;

  Perf get perf => Perf.fromVariantAndSpeed(
        variant ?? Variant.standard,
        timeIncrement != null
            ? Speed.fromTimeIncrement(timeIncrement!)
            : Speed.correspondence,
      );

  Map<String, String> get requestBody => {
        if (clock != null) 'time': (clock!.$1.inSeconds / 60).toString(),
        if (clock != null) 'increment': clock!.$2.inSeconds.toString(),
        if (days != null) 'days': days.toString(),
        'rated': rated.toString(),
        if (variant != null) 'variant': variant!.name,
        if (side != null) 'color': side!.name,
        if (ratingRange != null)
          'ratingRange': '${ratingRange!.$1}-${ratingRange!.$2}',
      };
}
