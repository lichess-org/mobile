import 'dart:convert';
import 'dart:math' as math;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/shared_preferences.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_setup.freezed.dart';
part 'game_setup.g.dart';

enum PlayableSide { random, white, black }

enum SeekMode { fast, custom }

@Freezed(fromJson: true, toJson: true)
class GameSetup with _$GameSetup {
  const GameSetup._();

  const factory GameSetup({
    // fast game
    required TimeIncrement timeIncrement,

    // custom game
    required int customTimeSeconds,
    required int customIncrementSeconds,
    required Variant customVariant,
    required bool customRated,
    required PlayableSide customSide,
    required (int, int) customRatingDelta,

    // correspondence game
    int? correspondenceDaysPerTurn,
    required Variant correspondenceVariant,
    required bool correspondenceRated,
    required PlayableSide correspondenceSide,
    required (int, int) correspondenceRatingDelta,

    // prefered seek mode, set after a seek is made
    required SeekMode seekMode,
  }) = _GameSetup;

  static const defaults = GameSetup(
    timeIncrement: TimeIncrement(600, 0),
    customTimeSeconds: 180,
    customIncrementSeconds: 0,
    customVariant: Variant.standard,
    customRated: false,
    customSide: PlayableSide.random,
    customRatingDelta: (-500, 500),
    correspondenceDaysPerTurn: 3,
    correspondenceVariant: Variant.standard,
    correspondenceRated: false,
    correspondenceSide: PlayableSide.random,
    correspondenceRatingDelta: (-500, 500),
    seekMode: SeekMode.fast,
  );

  Speed get speedFromCustom => Speed.fromTimeIncrement(
        TimeIncrement(
          customTimeSeconds,
          customIncrementSeconds,
        ),
      );

  Perf get perfFromCustom => Perf.fromVariantAndSpeed(
        customVariant,
        speedFromCustom,
      );

  /// Returns the rating range for the custom setup, or null if the user
  /// doesn't have a rating for the custom setup perf.
  (int, int)? ratingRangeFromCustom(User user) {
    final perf = user.perfs[perfFromCustom];
    if (perf == null) return null;
    if (perf.provisional == true) return null;
    final min = math.max(0, perf.rating + customRatingDelta.$1);
    final max = perf.rating + customRatingDelta.$2;
    return (min, max);
  }

  /// Returns the rating range for the correspondence setup, or null if the user
  /// doesn't have a rating for the correspondence setup perf.
  (int, int)? ratingRangeFromCorrespondence(User user) {
    final perf = user.perfs[Perf.correspondence];
    if (perf == null) return null;
    if (perf.provisional == true) return null;
    final min = math.max(0, perf.rating + correspondenceRatingDelta.$1);
    final max = perf.rating + correspondenceRatingDelta.$2;
    return (min, max);
  }

  factory GameSetup.fromJson(Map<String, dynamic> json) {
    try {
      return _$GameSetupFromJson(json);
    } catch (_) {
      return defaults;
    }
  }
}

@Riverpod(keepAlive: true)
class GameSetupPreferences extends _$GameSetupPreferences {
  static String _prefKey(AuthSessionState? session) =>
      'preferences.game_setup.${session?.user.id ?? '**anon**'}';

  @override
  GameSetup build() {
    final session = ref.watch(authSessionProvider);
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getString(_prefKey(session));
    return stored != null
        ? GameSetup.fromJson(
            jsonDecode(stored) as Map<String, dynamic>,
          )
        : GameSetup.defaults;
  }

  Future<void> setTimeControl(TimeIncrement timeInc) {
    return _save(state.copyWith(timeIncrement: timeInc));
  }

  Future<void> setCustomTimeSeconds(int seconds) {
    return _save(state.copyWith(customTimeSeconds: seconds));
  }

  Future<void> setCustomIncrementSeconds(int seconds) {
    return _save(state.copyWith(customIncrementSeconds: seconds));
  }

  Future<void> setCustomVariant(Variant variant) {
    return _save(state.copyWith(customVariant: variant));
  }

  Future<void> setCustomRated(bool rated) {
    return _save(state.copyWith(customRated: rated));
  }

  Future<void> setCustomSide(PlayableSide side) {
    return _save(state.copyWith(customSide: side));
  }

  Future<void> setSeekMode(SeekMode mode) {
    return _save(state.copyWith(seekMode: mode));
  }

  Future<void> setCustomRatingRange(int min, int max) {
    return _save(state.copyWith(customRatingDelta: (min, max)));
  }

  Future<void> setCorrespondenceDaysPerTurn(int? days) {
    return _save(state.copyWith(correspondenceDaysPerTurn: days));
  }

  Future<void> setCorrespondenceVariant(Variant variant) {
    return _save(state.copyWith(correspondenceVariant: variant));
  }

  Future<void> setCorrespondenceRated(bool rated) {
    return _save(state.copyWith(correspondenceRated: rated));
  }

  Future<void> setCorrespondenceSide(PlayableSide side) {
    return _save(state.copyWith(correspondenceSide: side));
  }

  Future<void> setCorrespondenceRatingRange(int min, int max) {
    return _save(state.copyWith(correspondenceRatingDelta: (min, max)));
  }

  Future<void> _save(GameSetup newState) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final session = ref.read(authSessionProvider);
    await prefs.setString(
      _prefKey(session),
      jsonEncode(newState.toJson()),
    );
    state = newState;
  }
}

const kSubtractingRatingRange = [
  -500,
  -450,
  -400,
  -350,
  -300,
  -250,
  -200,
  -150,
  -100,
  -50,
];

const kAddingRatingRange = [
  50,
  100,
  150,
  200,
  250,
  300,
  350,
  400,
  450,
  500,
];

const kAvailableTimesInSeconds = [
  0,
  15,
  30,
  45,
  60,
  90,
  2 * 60,
  3 * 60,
  4 * 60,
  5 * 60,
  6 * 60,
  7 * 60,
  8 * 60,
  9 * 60,
  10 * 60,
  11 * 60,
  12 * 60,
  13 * 60,
  14 * 60,
  15 * 60,
  16 * 60,
  17 * 60,
  18 * 60,
  19 * 60,
  20 * 60,
  25 * 60,
  30 * 60,
  35 * 60,
  40 * 60,
  45 * 60,
  60 * 60,
  75 * 60,
  90 * 60,
  105 * 60,
  120 * 60,
  135 * 60,
  150 * 60,
  165 * 60,
  180 * 60,
];

const kAvailableIncrementsInSeconds = [
  0,
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16,
  17,
  18,
  19,
  20,
  25,
  30,
  35,
  40,
  45,
  60,
  90,
  120,
  150,
  180,
];

const kAvailableDaysPerTurn = [1, 2, 3, 5, 7, 10, 14, -1];
