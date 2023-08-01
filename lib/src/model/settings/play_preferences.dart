import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lichess_mobile/src/db/shared_preferences.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';

part 'play_preferences.freezed.dart';
part 'play_preferences.g.dart';

const _prefKey = 'preferences.play';

enum PlayableSide { random, white, black }

enum SeekMode { fast, custom }

@Riverpod(keepAlive: true)
class PlayPreferences extends _$PlayPreferences {
  @override
  PlayPrefs build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getString(_prefKey);
    return stored != null
        ? PlayPrefs.fromJson(
            jsonDecode(stored) as Map<String, dynamic>,
          )
        : PlayPrefs.defaults;
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

  Future<void> _save(PlayPrefs newState) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(
      _prefKey,
      jsonEncode(newState.toJson()),
    );
    state = newState;
  }
}

@Freezed(fromJson: true, toJson: true)
class PlayPrefs with _$PlayPrefs {
  const PlayPrefs._();

  const factory PlayPrefs({
    // fast game pref
    required TimeIncrement timeIncrement,

    // custom game prefs
    required int customTimeSeconds,
    required int customIncrementSeconds,
    required Variant customVariant,
    required bool customRated,
    required PlayableSide customSide,

    // prefered seek mode, set after a seek is made
    required SeekMode seekMode,
  }) = _PlayPrefs;

  static const defaults = PlayPrefs(
    timeIncrement: TimeIncrement(180, 0),
    customTimeSeconds: 180,
    customIncrementSeconds: 0,
    customVariant: Variant.standard,
    customRated: false,
    customSide: PlayableSide.random,
    seekMode: SeekMode.fast,
  );

  factory PlayPrefs.fromJson(Map<String, dynamic> json) {
    try {
      return _$PlayPrefsFromJson(json);
    } catch (_) {
      return defaults;
    }
  }
}

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
