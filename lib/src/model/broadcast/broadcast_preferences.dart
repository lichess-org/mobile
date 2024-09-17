import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/shared_preferences.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'broadcast_preferences.freezed.dart';
part 'broadcast_preferences.g.dart';

const _prefKey = 'broadcast.preferences';

@riverpod
class BroadcastPreferences extends _$BroadcastPreferences {
  @override
  BroadcastPrefState build() {
    final id = ref.watch(authSessionProvider)?.user.id;
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getString(_makeKey(id));
    return stored != null
        ? BroadcastPrefState.fromJson(
            jsonDecode(stored) as Map<String, dynamic>,
          )
        : BroadcastPrefState.defaults();
  }

  Future<void> toggleEvaluationBar() async {
    final id = ref.read(authSessionProvider)?.user.id;
    final prefs = ref.read(sharedPreferencesProvider);
    state = state.copyWith(showEvaluationBar: !state.showEvaluationBar);
    await prefs.setString(_makeKey(id), jsonEncode(state.toJson()));
  }

  String _makeKey(UserId? id) => '$_prefKey.${id ?? ''}';
}

@Freezed(fromJson: true, toJson: true)
class BroadcastPrefState with _$BroadcastPrefState {
  const factory BroadcastPrefState({
    required bool showEvaluationBar,
  }) = _BroadcastPrefState;

  factory BroadcastPrefState.defaults() => const BroadcastPrefState(
        showEvaluationBar: true,
      );

  factory BroadcastPrefState.fromJson(Map<String, dynamic> json) {
    try {
      return _$BroadcastPrefStateFromJson(json);
    } catch (e) {
      debugPrint(
        '[BroadcastPreferences] Error getting broadcast preferences: $e',
      );
      return BroadcastPrefState.defaults();
    }
  }
}
