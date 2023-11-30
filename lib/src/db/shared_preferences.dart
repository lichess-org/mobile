import 'package:lichess_mobile/src/app_dependencies.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  // requireValue is possible because appDependenciesProvider is loaded before
  // anything. See: lib/src/app.dart
  return ref.read(appDependenciesProvider).requireValue.sharedPreferences;
}
