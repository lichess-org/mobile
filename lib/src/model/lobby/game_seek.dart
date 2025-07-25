import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup_preferences.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'game_seek.freezed.dart';

/// A seek is a request to play a game with a specific time control, variant,
/// and rating range.
///
/// See corresponding API docs:
/// https://lichess.org/api#tag/Board/operation/apiBoardSeek
@freezed
sealed class GameSeek with _$GameSeek {
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

  /// Construct a fast pairing game seek from a predefined time control.
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
      clock: game.meta.clock != null
          ? (game.meta.clock!.initial, game.meta.clock!.increment)
          : null,
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

  factory GameSeek.parseGameSeekFromRequestBody(Map<String, String> requestBody) {
    Duration? time;
    Duration? increment;
    int? days;
    bool rated = false;
    Variant? variant;
    (int, int)? ratingRange;

    if (requestBody.containsKey('time')) {
      final timeMinutes = double.tryParse(requestBody['time']!) ?? 0;
      time = Duration(seconds: (timeMinutes * 60).toInt());
    }

    if (requestBody.containsKey('increment')) {
      final incSeconds = int.tryParse(requestBody['increment']!) ?? 0;
      increment = Duration(seconds: incSeconds);
    }

    if (requestBody.containsKey('days')) {
      days = int.tryParse(requestBody['days']!);
    }

    if (requestBody.containsKey('rated')) {
      rated = requestBody['rated']!.toLowerCase() == 'true';
    }

    if (requestBody.containsKey('variant')) {
      final variantName = requestBody['variant']!;
      variant = Variant.values.firstWhere(
        (v) => v.name == variantName,
        orElse: () => Variant.standard,
      );
    }

    if (requestBody.containsKey('ratingRange')) {
      final parts = requestBody['ratingRange']!.split('-');
      if (parts.length == 2) {
        final min = int.tryParse(parts[0]);
        final max = int.tryParse(parts[1]);
        if (min != null && max != null) {
          ratingRange = (min, max);
        }
      }
    }

    return GameSeek(
      clock: (time!, increment!),
      days: days,
      rated: rated,
      variant: variant,
      ratingRange: ratingRange,
    );
  }
}

class RecentGameSeekPrefs implements Serializable {
  final List<Map<String, String>> requests;

  const RecentGameSeekPrefs({required this.requests});

  @override
  Map<String, dynamic> toJson() {
    return {
      'requests': requests,
    };
  }

  factory RecentGameSeekPrefs.fromJson(Map<String, dynamic> json) {
    final rawList = json['requests'] as List<dynamic>? ?? [];
    return RecentGameSeekPrefs(
      requests: rawList.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        return map.map((key, value) => MapEntry(key, value.toString()));
      }).toList(),
    );
  }

  RecentGameSeekPrefs copyWithAdded(Map<String, String> newRequest) {
    final existing = requests.where((r) => !_mapEquals(r, newRequest)).toList();
    final updated = [newRequest, ...existing];
    if (updated.length > 3) {
      updated.removeRange(3, updated.length);
    }
    return RecentGameSeekPrefs(requests: updated);
  }

  static bool _mapEquals(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (a[key] != b[key]) return false;
    }
    return true;
  }

  static const empty = RecentGameSeekPrefs(requests: []);
}

final recentGameSeekProvider =
    NotifierProvider<RecentGameSeekNotifier, RecentGameSeekPrefs>(
        RecentGameSeekNotifier.new);

class RecentGameSeekNotifier extends Notifier<RecentGameSeekPrefs>
    with PreferencesStorage<RecentGameSeekPrefs> {
  @override
  PrefCategory get prefCategory => PrefCategory.gameSeeks;

  @override
  RecentGameSeekPrefs fromJson(Map<String, dynamic> json) {
    return RecentGameSeekPrefs.fromJson(json);
  }

  @override
  RecentGameSeekPrefs get defaults => RecentGameSeekPrefs.empty;

  @override
  RecentGameSeekPrefs build() {
    return fetch();
  }

  Future<void> addRequest(Map<String, String> request) async {
    final updated = state.copyWithAdded(request);
    await save(updated);
  }

  Future<void> clearRequests() async {
    await LichessBinding.instance.sharedPreferences
        .remove(prefCategory.storageKey);
    state = RecentGameSeekPrefs.empty;
  }
}
