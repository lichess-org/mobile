import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_history_preferences.freezed.dart';
part 'game_history_preferences.g.dart';

@Riverpod(keepAlive: true)
class GameHistoryPreferences extends _$GameHistoryPreferences
    with PreferencesStorage<GameHistoryPrefs> {
  @override
  @protected
  final prefCategory = PrefCategory.gameHistory;

  @override
  @protected
  GameHistoryPrefs get defaults => GameHistoryPrefs.defaults;

  @override
  GameHistoryPrefs fromJson(Map<String, dynamic> json) {
    return GameHistoryPrefs.fromJson(json);
  }

  @override
  GameHistoryPrefs build() {
    return fetch();
  }

  Future<void> setDisplayMode(GameHistoryDisplayMode displayMode) {
    return save(state.copyWith(displayMode: displayMode));
  }
}

enum GameHistoryDisplayMode { compact, detail }

@Freezed(fromJson: true, toJson: true)
sealed class GameHistoryPrefs with _$GameHistoryPrefs implements Serializable {
  const GameHistoryPrefs._();

  const factory GameHistoryPrefs({
    @JsonKey(defaultValue: GameHistoryDisplayMode.detail)
    required GameHistoryDisplayMode displayMode,
  }) = _GameHistoryPrefs;

  static const defaults = GameHistoryPrefs(displayMode: GameHistoryDisplayMode.detail);

  factory GameHistoryPrefs.fromJson(Map<String, dynamic> json) {
    return _$GameHistoryPrefsFromJson(json);
  }
}
