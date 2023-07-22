import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lichess_mobile/src/db/shared_preferences.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';

part 'play_preferences.freezed.dart';
part 'play_preferences.g.dart';

const _prefKey = 'preferences.play';

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
        : const PlayPrefs(
            timeIncrement: TimeIncrement(180, 0),
          );
  }

  Future<void> setTimeControl(TimeIncrement timeInc) {
    return _save(state.copyWith(timeIncrement: timeInc));
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
    required TimeIncrement timeIncrement,
  }) = _PlayPrefs;

  factory PlayPrefs.fromJson(Map<String, dynamic> json) =>
      _$PlayPrefsFromJson(json);

  IconData get speedIcon => timeIncrement.speed.icon;
}
