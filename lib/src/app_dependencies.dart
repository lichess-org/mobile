import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/common/sound_service.dart';
import 'package:lichess_mobile/src/model/auth/session_storage.dart';
import 'package:lichess_mobile/src/model/auth/user_session.dart';


part 'app_dependencies.freezed.dart';
part 'app_dependencies.g.dart';

@Riverpod(keepAlive: true)
Future<AppDependencies> appDependencies(
  AppDependenciesRef ref,
) async {
  final sessionStorage = ref.watch(sessionStorageProvider);
  final prefs = await SharedPreferences.getInstance();
  //TODO: find out how to load soundTheme
  //final soundTheme = ref.watch(currentSelectedSoundThemeProvider);
  final pInfo = await PackageInfo.fromPlatform();
  final pool = Soundpool.fromOptions();
  final sounds = await loadSounds(pool);

  ref.onDispose(pool.release);

  final storedSession = await sessionStorage.read();
  final client = ref.read(httpClientProvider);
  if (storedSession != null) {
    try {
      final response = await client.get(
        Uri.parse('$kLichessHost/api/account'),
        headers: {
          'Authorization': 'Bearer ${storedSession.token}',
          'user-agent': ApiClient.userAgent(pInfo, storedSession.user),
        },
      );
      if (response.statusCode == 401) {
        await sessionStorage.delete();
      }
    } catch (e) {
      debugPrint('SEVERE: [AppDependencies] Error while checking session: $e');
    }
  }

  return AppDependencies(
    packageInfo: pInfo,
    sharedPreferences: prefs,
    soundPool: pool,
    sounds: sounds,
    userSession: await sessionStorage.read(),
  );
}

@freezed
class AppDependencies with _$AppDependencies {
  const factory AppDependencies({
    required PackageInfo packageInfo,
    required SharedPreferences sharedPreferences,
    required Soundpool soundPool,
    required IMap<Sound, int> sounds,
    required UserSession? userSession,
  }) = _AppDependencies;
}
