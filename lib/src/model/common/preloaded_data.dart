import 'dart:io' show Directory;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/db/secure_storage.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/auth/session_storage.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/utils/system.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'preloaded_data.g.dart';

typedef PreloadedData =
    ({
      PackageInfo packageInfo,
      BaseDeviceInfo deviceInfo,
      AuthSessionState? userSession,
      String sri,
      int engineMaxMemoryInMb,
      Directory? appDocumentsDirectory,
    });

@Riverpod(keepAlive: true)
Future<PreloadedData> preloadedData(Ref ref) async {
  final sessionStorage = ref.watch(sessionStorageProvider);

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

  final userSession = await sessionStorage.read();

  final physicalMemory = await System.instance.getTotalRam() ?? 256.0;
  final engineMaxMemory = (physicalMemory / 10).ceil();

  Directory? appDocumentsDirectory;
  try {
    appDocumentsDirectory = await getApplicationDocumentsDirectory();
  } catch (_) {}

  return (
    packageInfo: pInfo,
    deviceInfo: deviceInfo,
    userSession: userSession,
    sri: sri,
    engineMaxMemoryInMb: engineMaxMemory,
    appDocumentsDirectory: appDocumentsDirectory,
  );
}
