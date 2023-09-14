import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';
import 'package:sqflite/sqflite.dart';
import 'package:soundpool/soundpool.dart';
import 'package:path/path.dart' as p;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:system_info_plus/system_info_plus.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/http_client.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/db/secure_storage.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/auth/bearer.dart';
import 'package:lichess_mobile/src/model/auth/auth_socket.dart';
import 'package:lichess_mobile/src/model/auth/session_storage.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/utils/string.dart';

part 'app_dependencies.freezed.dart';
part 'app_dependencies.g.dart';

final _logger = Logger('AppDependencies');

@Riverpod(keepAlive: true)
Future<AppDependencies> appDependencies(
  AppDependenciesRef ref,
) async {
  final secureStorage = ref.watch(secureStorageProvider);
  final sessionStorage = ref.watch(sessionStorageProvider);
  final pInfo = await PackageInfo.fromPlatform();
  final deviceInfo = await DeviceInfoPlugin().deviceInfo;
  final prefs = await SharedPreferences.getInstance();
  final soundTheme = GeneralPreferences.fetchFromStorage(prefs).soundTheme;
  final soundPool = await ref.watch(soundPoolProvider(soundTheme).future);
  final client = ref.read(httpClientProvider);

  // Clear secure storage on first run because it is not deleted on app uninstall
  if (prefs.getBool('first_run') ?? true) {
    await secureStorage.deleteAll();

    await prefs.setBool('first_run', false);
  }

  // Generate a socket random identifier and store it for the app lifetime
  final storedSri = await secureStorage.read(key: kSRIStorageKey);
  if (storedSri == null) {
    final sri = genRandomString(12);
    _logger.info('Generated new SRI: $sri');
    await secureStorage.write(key: kSRIStorageKey, value: sri);
  }

  final sri = storedSri ??
      await secureStorage.read(key: kSRIStorageKey) ??
      genRandomString(12);

  final storedSession = await sessionStorage.read();
  if (storedSession != null) {
    try {
      final response = await client.get(
        Uri.parse('$kLichessHost/api/account'),
        headers: {
          'Authorization': 'Bearer ${signBearerToken(storedSession.token)}',
          'user-agent': userAgent(pInfo, deviceInfo, sri, storedSession.user),
        },
      ).timeout(const Duration(seconds: 3));
      if (response.statusCode == 401) {
        await sessionStorage.delete();
      }
    } catch (e) {
      debugPrint('WARNING: [AppDependencies] Error while checking session: $e');
    }
  }

  final dbPath = p.join(await getDatabasesPath(), 'lichess_mobile.db');
  final db = await openDb(databaseFactory, dbPath);

  final physicalMemory = await SystemInfoPlus.physicalMemory ?? 256.0;
  final engineMaxMemory = (physicalMemory / 10).ceil();

  return AppDependencies(
    packageInfo: pInfo,
    deviceInfo: deviceInfo,
    sharedPreferences: prefs,
    soundPool: soundPool,
    userSession: await sessionStorage.read(),
    database: db,
    sri: sri,
    engineMaxMemoryInMb: engineMaxMemory,
  );
}

@freezed
class AppDependencies with _$AppDependencies {
  const factory AppDependencies({
    required PackageInfo packageInfo,
    required BaseDeviceInfo deviceInfo,
    required SharedPreferences sharedPreferences,
    required (Soundpool, IMap<Sound, int>) soundPool,
    required AuthSessionState? userSession,
    required Database database,
    required String sri,
    required int engineMaxMemoryInMb,
  }) = _AppDependencies;
}
