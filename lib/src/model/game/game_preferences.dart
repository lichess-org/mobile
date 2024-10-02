import 'package:lichess_mobile/src/model/settings/preferences.dart' as pref;
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_preferences.g.dart';

/// Local game preferences, defined client-side only.
@riverpod
class GamePreferences extends _$GamePreferences
    with PreferencesStorage<pref.Game> {
  // ignore: avoid_public_notifier_properties
  @override
  pref.Category<pref.Game> get prefCategory => pref.Category.game;

  @override
  pref.Game build() {
    return fetch();
  }

  Future<void> toggleChat() {
    final newState = state.copyWith(enableChat: !(state.enableChat ?? false));
    return save(newState);
  }

  Future<void> toggleBlindfoldMode() {
    return save(
      state.copyWith(blindfoldMode: !(state.blindfoldMode ?? false)),
    );
  }
}
