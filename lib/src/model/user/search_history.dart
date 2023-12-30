import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_history.g.dart';
part 'search_history.freezed.dart';

@riverpod
class SearchHistory extends _$SearchHistory {
  static const prefKey = 'search.history';
  static const maxHistory = 10;

  @override
  SearchHistoryState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getString(prefKey);

    return stored != null
        ? SearchHistoryState.fromJson(
            jsonDecode(stored) as Map<String, dynamic>,
          )
        : SearchHistoryState(history: IList());
  }

  Future<void> saveTerm(String term) async {
    if (state.history.contains(term)) {
      return;
    }
    final currentList = state.history.toList();
    if (currentList.length >= maxHistory) {
      currentList.removeLast();
    }
    currentList.insert(0, term);
    final newState = SearchHistoryState(history: currentList.toIList());
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(prefKey, jsonEncode(newState.toJson()));
    state = newState;
  }

  Future<void> removeTerm(String term) async {
    if (state.history.contains(term)) {
      final newList = state.history.remove(term);
      final newState = state.copyWith(history: newList);
      final prefs = ref.read(sharedPreferencesProvider);
      await prefs.setString(prefKey, jsonEncode(newState.toJson()));
      state = newState;
    }
  }
}

@Freezed(fromJson: true, toJson: true)
class SearchHistoryState with _$SearchHistoryState {
  const factory SearchHistoryState({
    required IList<String> history,
  }) = _SearchHistoryState;

  factory SearchHistoryState.fromJson(Map<String, dynamic> json) =>
      _$SearchHistoryStateFromJson(json);
}
