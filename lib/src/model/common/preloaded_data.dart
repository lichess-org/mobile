import 'dart:io' show Directory;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/db/secure_storage.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_storage.dart';
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

  final pInfo = await PackageInfo.fromPlatform();
  final deviceInfo = await DeviceInfoPlugin().deviceInfo;

  // Generate a socket random identifier and store it for the app lifetime
  String? storedSri;
  try {
    storedSri = await SecureStorage.instance.read(key: kSRIStorageKey);
    if (storedSri == null) {
      final sri = genRandomString(12);
      await SecureStorage.instance.write(key: kSRIStorageKey, value: sri);
      storedSri = sri;
    }
  } on PlatformException catch (_) {
    // Clear all secure storage if an error occurs because it probably means the key has
    // been lost
    await SecureStorage.instance.deleteAll();
  }

  final sri = storedSri ?? genRandomString(12);

  AuthUser? authUser = await authStorage.read();

  if (authUser != null) {
    try {
      final isValid = await ref
          .read(authRepositoryProvider)
          .checkToken(authUser)
          .timeout(const Duration(seconds: 1));
      if (!isValid) {
        await ref.read(authStorageProvider).delete();
        authUser = null;
      }
    } catch (_) {
      // in case of network error, assume the authUser is still valid
    }
  }

  final physicalMemory = await System.instance.getTotalRam() ?? 256.0;
  final engineMaxMemory = (physicalMemory / 10).ceil();

  Directory? appDocumentsDirectory;
  try {
    appDocumentsDirectory = await getApplicationDocumentsDirectory();
  } catch (_) {}

  Directory? appSupportDirectory;
  try {
    appSupportDirectory = await getApplicationSupportDirectory();
  } catch (_) {}

  return (
    packageInfo: pInfo,
    deviceInfo: deviceInfo,
    authUser: authUser,
    sri: sri,
    engineMaxMemoryInMb: engineMaxMemory,
    appDocumentsDirectory: appDocumentsDirectory,
    appSupportDirectory: appSupportDirectory,
  );
}, name: 'PreloadedDataProvider');
