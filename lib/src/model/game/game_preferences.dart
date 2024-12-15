import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_preferences.freezed.dart';
part 'game_preferences.g.dart';

/// Local game preferences, defined client-side only.
@riverpod
class GamePreferences extends _$GamePreferences with PreferencesStorage<GamePrefs> {
  // ignore: avoid_public_notifier_properties
  @override
  final prefCategory = PrefCategory.game;

  // ignore: avoid_public_notifier_properties
  @override
  GamePrefs get defaults => GamePrefs.defaults;

  @override
  GamePrefs fromJson(Map<String, dynamic> json) => GamePrefs.fromJson(json);

  @override
  GamePrefs build() {
    return fetch();
  }

  Future<void> toggleChat() {
    final newState = state.copyWith(enableChat: !(state.enableChat ?? false));
    return save(newState);
  }

  Future<void> toggleBlindfoldMode() {
    return save(state.copyWith(blindfoldMode: !(state.blindfoldMode ?? false)));
  }
}

@Freezed(fromJson: true, toJson: true)
class GamePrefs with _$GamePrefs implements Serializable {
  const factory GamePrefs({bool? enableChat, bool? blindfoldMode}) = _GamePrefs;

  static const defaults = GamePrefs(enableChat: true);

  factory GamePrefs.fromJson(Map<String, dynamic> json) => _$GamePrefsFromJson(json);
}
