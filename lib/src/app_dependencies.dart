import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'common/sound_service.dart';

part 'app_dependencies.freezed.dart';
part 'app_dependencies.g.dart';

@Riverpod(keepAlive: true)
Future<AppDependencies> appDependencies(
  AppDependenciesRef ref,
) async {
  final pInfo = await PackageInfo.fromPlatform();
  final prefs = await SharedPreferences.getInstance();
  final pool = Soundpool.fromOptions();
  final sounds = await loadSounds(pool);

  ref.onDispose(pool.release);

  return AppDependencies(
    packageInfo: pInfo,
    sharedPreferences: prefs,
    soundPool: pool,
    sounds: sounds,
  );
}

@freezed
class AppDependencies with _$AppDependencies {
  const factory AppDependencies({
    required PackageInfo packageInfo,
    required SharedPreferences sharedPreferences,
    required Soundpool soundPool,
    required IMap<Sound, int> sounds,
  }) = _AppDependencies;
}
