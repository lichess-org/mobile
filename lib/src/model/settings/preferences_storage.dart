import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/settings/preferences.dart';
import 'package:logging/logging.dart';

final _logger = Logger('PreferencesStorage');

/// A [Notifier] mixin to provide a way to store and retrieve preferences.
///
/// This mixin is intended to be used with a [Notifier] that holds a
/// [SerializablePreferences] object.
mixin PreferencesStorage<T extends SerializablePreferences> {
  AutoDisposeNotifierProviderRef<T> get ref;
  abstract T state;

  PrefCategory<T> get prefCategory;

  Future<void> save(T value) async {
    await LichessBinding.instance.sharedPreferences
        .setString(prefCategory.storageKey, jsonEncode(value.toJson()));

    state = value;
  }

  T fetch() {
    final stored = LichessBinding.instance.sharedPreferences
        .getString(prefCategory.storageKey);
    if (stored == null) {
      return prefCategory.defaults();
    }
    try {
      return SerializablePreferences.fromJson(
        prefCategory,
        jsonDecode(stored) as Map<String, dynamic>,
      ) as T;
    } catch (e) {
      _logger.warning('Failed to decode $prefCategory preferences: $e');
      return prefCategory.defaults();
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

  PrefCategory<T> get prefCategory;

  Future<void> save(T value) async {
    final session = ref.read(authSessionProvider);
    await LichessBinding.instance.sharedPreferences.setString(
      key(prefCategory.storageKey, session),
      jsonEncode(value.toJson()),
    );

    state = value;
  }

  T fetch() {
    final session = ref.watch(authSessionProvider);
    final stored = LichessBinding.instance.sharedPreferences
        .getString(key(prefCategory.storageKey, session));
    if (stored == null) {
      return prefCategory.defaults(user: session?.user);
    }
    try {
      return SerializablePreferences.fromJson(
        prefCategory,
        jsonDecode(stored) as Map<String, dynamic>,
      ) as T;
    } catch (e) {
      _logger.warning('Failed to decode $prefCategory preferences: $e');
      return prefCategory.defaults(user: session?.user);
    }
  }

  static String key(String key, AuthSessionState? session) =>
      '$key.${session?.user.id ?? '**anon**'}';
}
