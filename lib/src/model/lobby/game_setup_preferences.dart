import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/settings/preferences.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_setup_preferences.g.dart';

@riverpod
class GameSetupPreferences extends _$GameSetupPreferences
    with SessionPreferencesStorage<GameSetup> {
  // ignore: avoid_public_notifier_properties
  @override
  Category<GameSetup> get prefCategory => Category.gameSetup;

  @override
  GameSetup build() {
    return fetch();
  }

  Future<void> setQuickPairingTimeIncrement(TimeIncrement timeInc) {
    return save(state.copyWith(quickPairingTimeIncrement: timeInc));
  }

  Future<void> setCustomTimeControl(TimeControl control) {
    return save(state.copyWith(customTimeControl: control));
  }

  Future<void> setCustomTimeSeconds(int seconds) {
    return save(state.copyWith(customTimeSeconds: seconds));
  }

  Future<void> setCustomIncrementSeconds(int seconds) {
    return save(state.copyWith(customIncrementSeconds: seconds));
  }

  Future<void> setCustomVariant(Variant variant) {
    return save(state.copyWith(customVariant: variant));
  }

  Future<void> setCustomRated(bool rated) {
    return save(state.copyWith(customRated: rated));
  }

  Future<void> setCustomSide(SideChoice side) {
    return save(state.copyWith(customSide: side));
  }

  Future<void> setCustomRatingRange(int min, int max) {
    return save(state.copyWith(customRatingDelta: (min, max)));
  }

  Future<void> setCustomDaysPerTurn(int days) {
    return save(state.copyWith(customDaysPerTurn: days));
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
  0,
];

const kAddingRatingRange = [
  0,
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

const kAvailableDaysPerTurn = [1, 2, 3, 5, 7, 10, 14];
