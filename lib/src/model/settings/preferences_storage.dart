import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/settings/preferences.dart';

/// A mixin to provide a way to store and retrieve preferences.
///
/// This mixin is intended to be used with a [Notifier] that holds a
/// [SerializablePreferences] object. It provides a way to save and fetch the
/// preferences from the shared preferences.
mixin PreferencesStorage<T extends SerializablePreferences> {
  AutoDisposeNotifierProviderRef<T> get ref;
  abstract T state;

  Category<T> get categoryKey;

  Future<void> save(T value) async {
    await LichessBinding.instance.sharedPreferences
        .setString(categoryKey.storageKey, jsonEncode(value.toJson()));

    state = value;
  }

  T fetch() {
    final stored = LichessBinding.instance.sharedPreferences
        .getString(categoryKey.storageKey);
    if (stored == null) {
      return categoryKey.defaults;
    }
    try {
      return SerializablePreferences.fromJson(
        categoryKey,
        jsonDecode(stored) as Map<String, dynamic>,
      ) as T;
    } catch (e) {
      return categoryKey.defaults;
    }
  }
}

/// A mixin to provide a way to store and retrieve preferences per session.
///
/// This mixin is intended to be used with a [Notifier] that holds a
/// [SerializablePreferences] object. It provides a way to save and fetch the
/// preferences from the shared preferences, using the current session to
/// differentiate between different users.
mixin SessionPreferencesStorage<T extends SerializablePreferences> {
  AutoDisposeNotifierProviderRef<T> get ref;
  abstract T state;

  Category<T> get categoryKey;

  Future<void> save(T value) async {
    final session = ref.read(authSessionProvider);
    await LichessBinding.instance.sharedPreferences.setString(
      _prefKey(categoryKey.storageKey, session),
      jsonEncode(value.toJson()),
    );

    state = value;
  }

  T fetch() {
    final session = ref.watch(authSessionProvider);
    final stored = LichessBinding.instance.sharedPreferences
        .getString(_prefKey(categoryKey.storageKey, session));
    if (stored == null) {
      return categoryKey.defaults;
    }
    try {
      return SerializablePreferences.fromJson(
        categoryKey,
        jsonDecode(stored) as Map<String, dynamic>,
      ) as T;
    } catch (e) {
      return categoryKey.defaults;
    }
  }

  String _prefKey(String key, AuthSessionState? session) =>
      '$key.${session?.user.id ?? '**anon**'}';
}
