import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lichess_mobile/src/app.dart';

part 'shared_preferences.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  // requireValue is possible because appDependenciesProvider is loaded before
  // anything. See: lib/src/app.dart
  return ref
      .watch(appDependenciesProvider.select((data) => data.requireValue.item2));
}

/// Creates a pref provider backed by SharedPreferences and of value `T`.
NotifierProvider<PrefNotifier<T>, T> createPrefProvider<T>({
  required String prefKey,
  required T defaultValue,
  T Function(String?)? mapFrom,
  String Function(T)? mapTo,
}) {
  return NotifierProvider<PrefNotifier<T>, T>(
    () {
      return PrefNotifier<T>(
        prefKey,
        defaultValue,
        mapFrom: mapFrom,
        mapTo: mapTo,
      );
    },
    name: '${prefKey}PrefProvider',
  );
}

/// Creates a boolean pref provider that has a `toggle` method.
NotifierProvider<ToggleBoolPrefNotifier, bool> createBoolPrefProvider({
  required String prefKey,
  required bool defaultValue,
}) {
  return NotifierProvider<ToggleBoolPrefNotifier, bool>(
    () {
      return ToggleBoolPrefNotifier(
        prefKey: prefKey,
        defaultValue: defaultValue,
      );
    },
    name: '${prefKey}ToggleBoolPrefProvider',
  );
}

class PrefNotifier<T> extends Notifier<T> {
  PrefNotifier(this.prefKey, this.defaultValue, {this.mapFrom, this.mapTo})
      : assert(
          (mapFrom == null && mapTo == null) ||
              (mapFrom != null && mapTo != null),
          'You must pass both `mapFrom` and `mapTo`, or none.',
        );

  final String prefKey;
  final T defaultValue;
  final T Function(String?)? mapFrom;
  final String Function(T)? mapTo;

  @override
  T build() {
    final saved = prefs.get(prefKey);
    final mapped = mapFrom != null ? mapFrom!(saved as String?) : saved as T?;
    return mapped ?? defaultValue;
  }

  SharedPreferences get prefs => ref.read(sharedPreferencesProvider);

  Future<void> set(T value) async {
    bool success = false;
    if (mapTo != null) {
      success = await prefs.setString(prefKey, mapTo!(value));
    } else if (value is String) {
      success = await prefs.setString(prefKey, value);
    } else if (value is bool) {
      success = await prefs.setBool(prefKey, value);
    } else if (value is int) {
      success = await prefs.setInt(prefKey, value);
    } else if (value is double) {
      success = await prefs.setDouble(prefKey, value);
    } else if (value is List<String>) {
      success = await prefs.setStringList(prefKey, value);
    }
    if (success) {
      state = value;
    }
  }
}

class ToggleBoolPrefNotifier extends Notifier<bool> {
  ToggleBoolPrefNotifier({required this.prefKey, required this.defaultValue});

  final String prefKey;
  final bool defaultValue;

  @override
  bool build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return prefs.getBool(prefKey) ?? defaultValue;
  }

  Future<void> toggle() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final toggled = !(prefs.getBool(prefKey) ?? false);
    final ok = await prefs.setBool(prefKey, toggled);
    if (ok) {
      state = toggled;
    }
  }
}
