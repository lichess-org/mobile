import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'search_history.g.dart';
part 'search_history.freezed.dart';

@riverpod
class SearchHistory extends _$SearchHistory {
  static const maxHistory = 10;

  String _storageKey(AuthSessionState? session) =>
      'search.history.${session?.user.id ?? '**anon**'}';

  SharedPreferencesWithCache get _prefs => LichessBinding.instance.sharedPreferences;

  @override
  SearchHistoryState build() {
    final session = ref.watch(authSessionProvider);
    final stored = _prefs.getString(_storageKey(session));

    return stored != null
        ? SearchHistoryState.fromJson(jsonDecode(stored) as Map<String, dynamic>)
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
    final session = ref.read(authSessionProvider);
    await _prefs.setString(_storageKey(session), jsonEncode(newState.toJson()));
    state = newState;
  }

  Future<void> clear() async {
    final newState = state.copyWith(history: IList());
    final prefKey = _storageKey(ref.read(authSessionProvider));
    await _prefs.setString(prefKey, jsonEncode(newState.toJson()));
    state = newState;
  }
}

@Freezed(fromJson: true, toJson: true)
sealed class SearchHistoryState with _$SearchHistoryState {
  const factory SearchHistoryState({required IList<String> history}) = _SearchHistoryState;

  factory SearchHistoryState.fromJson(Map<String, dynamic> json) =>
      _$SearchHistoryStateFromJson(json);
}
