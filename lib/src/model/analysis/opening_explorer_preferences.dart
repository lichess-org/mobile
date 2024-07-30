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

  Future<void> setMasterDbSince(int year) =>
      _save(state.copyWith(masterDb: state.masterDb.copyWith(sinceYear: year)));

  Future<void> setMasterDbUntil(int year) =>
      _save(state.copyWith(masterDb: state.masterDb.copyWith(untilYear: year)));

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
    required MasterDbPrefState masterDb,
  }) = _OpeningExplorerPrefState;

  static final defaults = OpeningExplorerPrefState(
    db: OpeningDatabase.master,
    masterDb: MasterDbPrefState.defaults,
  );

  factory OpeningExplorerPrefState.fromJson(Map<String, dynamic> json) {
    try {
      return _$OpeningExplorerPrefStateFromJson(json);
    } catch (_) {
      return defaults;
    }
  }
}

@Freezed(fromJson: true, toJson: true)
class MasterDbPrefState with _$MasterDbPrefState {
  const MasterDbPrefState._();

  const factory MasterDbPrefState({
    required int sinceYear,
    required int untilYear,
  }) = _MasterDbPrefState;

  static final defaults = MasterDbPrefState(
    sinceYear: 1952,
    untilYear: DateTime.now().year,
  );

  factory MasterDbPrefState.fromJson(Map<String, dynamic> json) {
    try {
      return _$MasterDbPrefStateFromJson(json);
    } catch (_) {
      return defaults;
    }
  }
}
