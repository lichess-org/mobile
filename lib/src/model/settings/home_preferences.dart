import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_preferences.freezed.dart';
part 'home_preferences.g.dart';

const _prefKey = 'preferences.general';

@Riverpod(keepAlive: true)
class HomePreferences extends _$HomePreferences {
  static HomePrefState fetchFromStorage(SharedPreferences prefs) {
    final stored = prefs.getString(_prefKey);
    return stored != null
        ? HomePrefState.fromJson(
            jsonDecode(stored) as Map<String, dynamic>,
          )
        : HomePrefState.defaults;
  }

  @override
  HomePrefState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return fetchFromStorage(prefs);
  }

  Future<void> toggleWidget(EnabledWidget widget) {
    final newState = state.copyWith(
      enabledWidgets: state.enabledWidgets.contains(widget)
          ? state.enabledWidgets.difference({widget})
          : state.enabledWidgets.union({widget}),
    );
    return _save(newState);
  }

  Future<void> _save(HomePrefState newState) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(
      _prefKey,
      jsonEncode(newState.toJson()),
    );
    state = newState;
  }
}

enum EnabledWidget {
  hello,
  perfCards,
  quickPairing,
}

@Freezed(fromJson: true, toJson: true)
class HomePrefState with _$HomePrefState {
  const factory HomePrefState({
    required Set<EnabledWidget> enabledWidgets,
  }) = _HomePrefState;

  static const defaults = HomePrefState(
    enabledWidgets: {
      EnabledWidget.hello,
      EnabledWidget.perfCards,
      EnabledWidget.quickPairing,
    },
  );

  factory HomePrefState.fromJson(Map<String, dynamic> json) {
    try {
      return _$HomePrefStateFromJson(json);
    } catch (_) {
      return defaults;
    }
  }
}
