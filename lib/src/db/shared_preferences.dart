import 'package:lichess_mobile/src/init.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  // requireValue is possible because cachedDataProvider is loaded before
  // anything. See: lib/src/app.dart
  return ref.read(cachedDataProvider).requireValue.sharedPreferences;
}
