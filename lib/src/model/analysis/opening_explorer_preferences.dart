import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'opening_explorer_preferences.freezed.dart';
part 'opening_explorer_preferences.g.dart';

@Riverpod(keepAlive: true)
class OpeningExplorerPreferences extends _$OpeningExplorerPreferences {
  static const prefKey = 'preferences.opening_explorer';

  @override
  OpeningExplorerPrefState build() {
    final prefs = ref.watch(sharedPreferencesProvider);

    final stored = prefs.getString(prefKey);
    return stored != null
        ? OpeningExplorerPrefState.fromJson(
            jsonDecode(stored) as Map<String, dynamic>,
          )
        : OpeningExplorerPrefState.defaults;
  }

  Future<void> setDatabase(OpeningDatabase db) => _save(
        state.copyWith(db: db),
      );

  Future<void> _save(OpeningExplorerPrefState newState) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(
      prefKey,
      jsonEncode(newState.toJson()),
    );
    state = newState;
  }
}

enum OpeningDatabase {
  master,
  lichess,
  player,
}

@Freezed(fromJson: true, toJson: true)
class OpeningExplorerPrefState with _$OpeningExplorerPrefState {
  const OpeningExplorerPrefState._();

  const factory OpeningExplorerPrefState({
    required OpeningDatabase db,
  }) = _OpeningExplorerPrefState;

  static const defaults = OpeningExplorerPrefState(
    db: OpeningDatabase.master,
  );

  factory OpeningExplorerPrefState.fromJson(Map<String, dynamic> json) {
    try {
      return _$OpeningExplorerPrefStateFromJson(json);
    } catch (_) {
      return defaults;
    }
  }
}
