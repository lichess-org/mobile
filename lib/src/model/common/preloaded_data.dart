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
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart'
    show
        getApplicationCacheDirectory,
        getApplicationDocumentsDirectory,
        getApplicationSupportDirectory;

final _logger = Logger('PreloadedData');

typedef PreloadedData = ({
  PackageInfo packageInfo,
  BaseDeviceInfo deviceInfo,
  AuthUser? authUser,
  String sri,
  int engineMaxMemoryInMb,
  Directory? appDocumentsDirectory,
  Directory? appSupportDirectory,
  Directory? imageCacheDirectory,
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
    imageCacheDirectory,
  ) = await (
    PackageInfo.fromPlatform(),
    DeviceInfoPlugin().deviceInfo,
    _readOrCreateSri(),
    _readAuthUser(authStorage),
    System.instance.getTotalRam(),
    _getDirectoryOrNull(getApplicationDocumentsDirectory),
    _getDirectoryOrNull(getApplicationSupportDirectory),
    _getDirectoryOrNull(_createImageCacheDirectory),
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
            _logger.info('The stored token of ${authUser!.user.id} is invalid, deleting it');
            authStorage.delete();
          }
        })
        .catchError((Object e) {
          // in case of network error, assume the authUser is still valid
          _logger.fine('Could not test the stored token:', e);
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
    imageCacheDirectory: imageCacheDirectory,
  );
}, name: 'PreloadedDataProvider');

/// Reads the stored session, or returns `null` if secure storage can't be read.
///
/// The stored session is kept on a read error: the error may be temporary (e.g. the iOS keychain
/// can't be read while the device is locked), and the next launch then reads it.
Future<AuthUser?> _readAuthUser(AuthStorage authStorage) async {
  try {
    return await authStorage.read();
  } catch (e, st) {
    _logger.severe('Could not read the stored session:', e, st);
    return null;
  }
}

/// Reads the stored socket random identifier, generating and persisting a new one if none exists
/// yet.
///
/// If secure storage can't be read, a temporary identifier is used and nothing is written: the
/// error may be temporary, and deleting the storage would also delete the stored sessions.
Future<String> _readOrCreateSri() async {
  try {
    final storedSri = await SecureStorage.instance.read(key: kSRIStorageKey);
    if (storedSri != null) return storedSri;
    final newSri = genRandomString(12);
    await SecureStorage.instance.write(key: kSRIStorageKey, value: newSri);
    return newSri;
  } on PlatformException catch (e, st) {
    _logger.severe('Could not read or write the SRI, using a temporary one:', e, st);
    return genRandomString(12);
  }
}

/// Creates, if needed, the directory where [imageClientProvider] caches the images it downloads.
Future<Directory> _createImageCacheDirectory() async {
  final cacheDirectory = await getApplicationCacheDirectory();
  return await Directory('${cacheDirectory.path}/http_images').create(recursive: true);
}

/// Runs [getDirectory], returning `null` instead of throwing if it fails.
Future<Directory?> _getDirectoryOrNull(Future<Directory> Function() getDirectory) async {
  try {
    return await getDirectory();
  } catch (_) {
    return null;
  }
}
