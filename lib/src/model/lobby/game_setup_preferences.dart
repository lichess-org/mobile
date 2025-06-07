import 'dart:math' as math;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_setup_preferences.freezed.dart';
part 'game_setup_preferences.g.dart';

@Riverpod(keepAlive: true)
class GameSetupPreferences extends _$GameSetupPreferences
    with SessionPreferencesStorage<GameSetupPrefs> {
  @override
  @protected
  final prefCategory = PrefCategory.gameSetup;

  @override
  GameSetupPrefs defaults({LightUser? user}) => GameSetupPrefs.defaults;

  @override
  GameSetupPrefs fromJson(Map<String, dynamic> json) => GameSetupPrefs.fromJson(json);

  @override
  GameSetupPrefs build() {
    return fetch();
  }

  Future<void> setTimeIncrement(TimeIncrement timeInc) {
    return save(state.copyWith(timeIncrement: timeInc));
  }

  Future<void> setCustomVariant(Variant variant) {
    return save(state.copyWith(customVariant: variant));
  }

  Future<void> setCustomRated(bool rated) {
    return save(state.copyWith(customRated: rated));
  }

  Future<void> setCustomRatingRange(int min, int max) {
    return save(state.copyWith(customRatingDelta: (min, max)));
  }

  Future<void> setCustomDaysPerTurn(int days) {
    return save(state.copyWith(customDaysPerTurn: days));
  }
}

@Freezed(fromJson: true, toJson: true)
sealed class GameSetupPrefs with _$GameSetupPrefs implements Serializable {
  const GameSetupPrefs._();

  const factory GameSetupPrefs({
    required TimeIncrement timeIncrement,
    required int customDaysPerTurn,
    required Variant customVariant,
    required bool customRated,
    required (int, int) customRatingDelta,
  }) = _GameSetupPrefs;

  static const defaults = GameSetupPrefs(
    timeIncrement: TimeIncrement(600, 0),
    customVariant: Variant.standard,
    customRated: false,
    customRatingDelta: (-500, 500),
    customDaysPerTurn: 3,
  );

  Perf get realTimePerf =>
      Perf.fromVariantAndSpeed(customVariant, Speed.fromTimeIncrement(timeIncrement));

  /// Returns the rating range for the custom setup, or null if the user
  /// doesn't have a rating for the custom setup perf.
  (int, int)? realTimeRatingRange(User user) {
    final perf = user.perfs[realTimePerf];
    if (perf == null) return null;
    if (perf.provisional == true) return null;
    final min = math.max(0, perf.rating + customRatingDelta.$1);
    final max = perf.rating + customRatingDelta.$2;
    return (min, max);
  }

  (int, int)? correspondenceRatingRange(User user) {
    final perf = user.perfs[Perf.correspondence];
    if (perf == null) return null;
    if (perf.provisional == true) return null;
    final min = math.max(0, perf.rating + customRatingDelta.$1);
    final max = perf.rating + customRatingDelta.$2;
    return (min, max);
  }

  factory GameSetupPrefs.fromJson(Map<String, dynamic> json) {
    try {
      return _$GameSetupPrefsFromJson(json);
    } catch (_) {
      return defaults;
    }
  }
}

const kSubtractingRatingRange = [-500, -450, -400, -350, -300, -250, -200, -150, -100, -50, 0];

const kAddingRatingRange = [0, 50, 100, 150, 200, 250, 300, 350, 400, 450, 500];

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

const kAvailableDaysPerTurn = [1, 2, 3, 5, 7, 10, 14];
