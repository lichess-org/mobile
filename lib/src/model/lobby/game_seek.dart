import 'dart:math' as math;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/settings/play_preferences.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'game_seek.freezed.dart';

@freezed
class GameSeek with _$GameSeek {
  const GameSeek._();

  const factory GameSeek({
    required Duration time,
    required Duration increment,
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
      time: Duration(seconds: playPref.timeIncrement.time),
      increment: Duration(seconds: playPref.timeIncrement.increment),
      rated: session != null,
    );
  }

  factory GameSeek.customFromPrefs(
    PlayPrefs playPref,
    AuthSessionState? session,
    UserPerf? userPerf,
  ) {
    return GameSeek(
      time: Duration(seconds: playPref.customTimeSeconds),
      increment: Duration(seconds: playPref.customIncrementSeconds),
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

  TimeIncrement get timeIncrement => TimeIncrement(
        time.inSeconds,
        increment.inSeconds,
      );

  Perf get perf => Perf.fromVariantAndSpeed(
        variant ?? Variant.standard,
        Speed.fromTimeIncrement(timeIncrement),
      );

  Map<String, String> get requestBody => {
        'time': (time.inSeconds / 60).toString(),
        'increment': increment.inSeconds.toString(),
        'rated': rated.toString(),
        if (variant != null) 'variant': variant!.name,
        if (side != null) 'color': side!.name,
        if (ratingRange != null)
          'ratingRange': '${ratingRange!.$1}-${ratingRange!.$2}',
      };
}
