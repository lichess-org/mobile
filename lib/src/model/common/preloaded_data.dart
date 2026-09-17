import 'dart:async';
import 'dart:io' show Directory;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/db/secure_storage.dart';
import 'package:lichess_mobile/src/model/auth/auth_storage.dart';
import 'package:lichess_mobile/src/model/auth/auth_user.dart';
import 'package:lichess_mobile/src/model/engine/engine_utils.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/utils/system.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory, getApplicationSupportDirectory;

typedef PreloadedData = ({
  PackageInfo packageInfo,
  BaseDeviceInfo deviceInfo,
  AuthUser? authUser,
  String sri,
  int engineMaxMemoryInMb,
  Directory? appDocumentsDirectory,
  Directory? appSupportDirectory,
});

/// A provider that preloads various data needed throughout the app.
final preloadedDataProvider = FutureProvider<PreloadedData>((Ref ref) async {
  final authStorage = ref.read(authStorageProvider);

  final (
    pInfo,
    deviceInfo,
    sri,
    authUser,
    physicalMemory,
    appDocumentsDirectory,
    appSupportDirectory,
  ) = await (
    PackageInfo.fromPlatform(),
    DeviceInfoPlugin().deviceInfo,
    _readOrCreateSri(),
    authStorage.read(),
    System.instance.getTotalRam(),
    _getDirectoryOrNull(getApplicationDocumentsDirectory),
    _getDirectoryOrNull(getApplicationSupportDirectory),
  ).wait;

  final token = authUser?.token;
  if (token != null) {
    final userAgent = makeUserAgent(pInfo, deviceInfo, sri, null);
    final client = DefaultClient(ref.read(httpClientFactoryProvider)(), userAgent: userAgent);
    client
        .postReadJson(lichessUri('/api/token/test'), mapper: (json) => json, body: token)
        .timeout(const Duration(seconds: 5))
        .then((data) {
          final isValid = data[token] != null;
          if (!isValid) {
            authStorage.delete();
          }
        })
        .catchError((_) {
          // in case of network error, assume the authUser is still valid
        })
        .whenComplete(() {
          client.close();
        });
  }

  return (
    packageInfo: pInfo,
    deviceInfo: deviceInfo,
    authUser: authUser,
    sri: sri,
    engineMaxMemoryInMb: engineMaxMemoryFor(physicalMemory ?? 256),
    appDocumentsDirectory: appDocumentsDirectory,
    appSupportDirectory: appSupportDirectory,
  );
}, name: 'PreloadedDataProvider');

/// Reads the stored socket random identifier, generating and persisting a
/// new one if none exists yet or if secure storage turns out to be
/// unreadable.
Future<String> _readOrCreateSri() async {
  try {
    final storedSri = await SecureStorage.instance.read(key: kSRIStorageKey);
    if (storedSri != null) return storedSri;
    final newSri = genRandomString(12);
    await SecureStorage.instance.write(key: kSRIStorageKey, value: newSri);
    return newSri;
  } on PlatformException catch (_) {
    // Clear all secure storage if an error occurs because it probably means
    // the key has been lost.
    await SecureStorage.instance.deleteAll();
    return genRandomString(12);
  }
}

/// Runs [getDirectory], returning `null` instead of throwing if it fails.
Future<Directory?> _getDirectoryOrNull(Future<Directory> Function() getDirectory) async {
  try {
    return await getDirectory();
  } catch (_) {
    return null;
  }
}
