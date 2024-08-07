import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/db/secure_storage.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/auth/bearer.dart';
import 'package:lichess_mobile/src/model/auth/session_storage.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/utils/color_palette.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/utils/system.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

part 'app_initialization.freezed.dart';
part 'app_initialization.g.dart';

final _logger = Logger('AppInitialization');

@Riverpod(keepAlive: true)
Future<AppInitializationData> appInitialization(
  AppInitializationRef ref,
) async {
  final secureStorage = ref.watch(secureStorageProvider);
  final sessionStorage = ref.watch(sessionStorageProvider);
  final pInfo = await PackageInfo.fromPlatform();
  final deviceInfo = await DeviceInfoPlugin().deviceInfo;
  final prefs = await SharedPreferences.getInstance();

  final dbPath = p.join(await getDatabasesPath(), kLichessDatabaseName);

  final appVersion = Version.parse(pInfo.version);
  final installedVersion = prefs.getString('installed_version');

  if (installedVersion == null ||
      Version.parse(installedVersion) != appVersion) {
    prefs.setString('installed_version', appVersion.canonicalizedVersion);
  }

  // preload sounds
  final soundTheme = GeneralPreferences.fetchFromStorage(prefs).soundTheme;
  final soundService = ref.read(soundServiceProvider);
  try {
    await soundService.initialize(soundTheme);
  } catch (e) {
    _logger.warning('Cannot initialize SoundService: $e');
  }

  final db = await openDb(databaseFactory, dbPath);

  if (prefs.getBool('first_run') ?? true) {
    // Clear secure storage on first run because it is not deleted on app uninstall
    await secureStorage.deleteAll();

    // on android 12+ set the default board theme as system
    if (getCorePalette() != null) {
      prefs.setString(
        BoardPreferences.prefKey,
        jsonEncode(
          BoardPrefs.defaults.copyWith(
            boardTheme: BoardTheme.system,
          ),
        ),
      );
    }

    await prefs.setBool('first_run', false);
  }

  // Generate a socket random identifier and store it for the app lifetime
  String? storedSri;
  try {
    storedSri = await secureStorage.read(key: kSRIStorageKey);
    if (storedSri == null) {
      final sri = genRandomString(12);
      _logger.info('Generated new SRI: $sri');
      await secureStorage.write(key: kSRIStorageKey, value: sri);
    }
  } on PlatformException catch (e) {
    _logger.warning('[AppInitialization] Error while reading SRI: $e');
    // Clear all secure storage if an error occurs because it probably means the key has
    // been lost
    await secureStorage.deleteAll();
  }

  final sri = storedSri ??
      await secureStorage.read(key: kSRIStorageKey) ??
      genRandomString(12);

  final storedSession = await sessionStorage.read();
  if (storedSession != null) {
    try {
      final client = ref.read(defaultClientProvider);
      final response = await client.get(
        lichessUri('/api/account'),
        headers: {
          'Authorization': 'Bearer ${signBearerToken(storedSession.token)}',
          'User-Agent':
              makeUserAgent(pInfo, deviceInfo, sri, storedSession.user),
        },
      ).timeout(const Duration(seconds: 3));
      if (response.statusCode == 401) {
        await sessionStorage.delete();
      }
    } catch (e) {
      _logger.warning('Could not while checking session: $e');
    }
  }

  final physicalMemory = await System.instance.getTotalRam() ?? 256.0;
  final engineMaxMemory = (physicalMemory / 10).ceil();

  return AppInitializationData(
    packageInfo: pInfo,
    deviceInfo: deviceInfo,
    sharedPreferences: prefs,
    userSession: await sessionStorage.read(),
    database: db,
    sri: sri,
    engineMaxMemoryInMb: engineMaxMemory,
  );
}

@freezed
class AppInitializationData with _$AppInitializationData {
  const factory AppInitializationData({
    required PackageInfo packageInfo,
    required BaseDeviceInfo deviceInfo,
    required SharedPreferences sharedPreferences,
    required AuthSessionState? userSession,
    required Database database,
    required String sri,
    required int engineMaxMemoryInMb,
  }) = _AppInitializationData;
}
