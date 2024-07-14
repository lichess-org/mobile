import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_preferences.freezed.dart';
part 'game_preferences.g.dart';

const _prefKey = 'game.preferences';

/// Local game preferences, defined client-side only.
@riverpod
class GamePreferences extends _$GamePreferences {
  @override
  GamePrefState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getString(_prefKey);
    return stored != null
        ? GamePrefState.fromJson(jsonDecode(stored) as Map<String, dynamic>)
        : GamePrefState.defaults;
  }

  Future<void> toggleChat() {
    final newState = state.copyWith(enableChat: !(state.enableChat ?? false));
    return _save(newState);
  }

  Future<void> toggleBlindfoldMode() {
    return _save(
      state.copyWith(blindfoldMode: !(state.blindfoldMode ?? false)),
    );
  }

  Future<void> _save(GamePrefState newState) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(
      _prefKey,
      jsonEncode(newState.toJson()),
    );
    state = newState;
  }
}

@Freezed(fromJson: true, toJson: true)
class GamePrefState with _$GamePrefState {
  const factory GamePrefState({
    bool? enableChat,
    bool? blindfoldMode,
  }) = _GamePrefState;

  static const defaults = GamePrefState(
    enableChat: true,
  );

  factory GamePrefState.fromJson(Map<String, dynamic> json) =>
      _$GamePrefStateFromJson(json);
}
