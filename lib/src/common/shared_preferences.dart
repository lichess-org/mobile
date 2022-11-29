import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  // see lib/src/main.dart for initialization
  throw UnimplementedError();
});

/// Creates an AutoDisposeNotifier backed by SharedPreferences and of value `T`.
AutoDisposeNotifierProvider<PrefNotifier<T>, T> createPrefProvider<T>({
  required String prefKey,
  required T defaultValue,
  T Function(String?)? mapFrom,
  String Function(T)? mapTo,
}) {
  return AutoDisposeNotifierProvider<PrefNotifier<T>, T>(() {
    return PrefNotifier<T>(prefKey, defaultValue,
        mapFrom: mapFrom, mapTo: mapTo);
  });
}

class PrefNotifier<T> extends AutoDisposeNotifier<T> {
  PrefNotifier(this.prefKey, this.defaultValue, {this.mapFrom, this.mapTo})
      : assert(
            (mapFrom == null && mapTo == null) ||
                (mapFrom != null && mapTo != null),
            'You must pass both `mapFrom` and `mapTo`, or none.');

  @override
  T build() {
    final saved = prefs.get(prefKey);
    final mapped = mapFrom != null ? mapFrom!(saved as String?) : saved as T?;
    return mapped ?? defaultValue;
  }

  String prefKey;
  T defaultValue;
  T Function(String?)? mapFrom;
  String Function(T)? mapTo;

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
