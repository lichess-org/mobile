import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Various system utilities.
class System {
  const System._();

  static const _channel = MethodChannel('mobile.lichess.org/system');

  static const instance = System._();

  /// Returns the system total RAM in megabytes.
  Future<int?> getTotalRam() async {
    try {
      return await _channel.invokeMethod<int>('getTotalRam');
    } on PlatformException catch (e) {
      debugPrint('Failed to get total RAM: ${e.message}');
      return null;
    } on MissingPluginException catch (_) {
      return null;
    }
  }

  /// Clear all user data from the app.
  ///
  /// Only available on Android.
  Future<bool> clearUserData() async {
    if (Platform.isAndroid) {
      try {
        final result = await _channel.invokeMethod<bool>('clearApplicationUserData');
        return result ?? false;
      } on PlatformException catch (e) {
        debugPrint('Failed to clear user data: ${e.message}');
        return false;
      }
    }

    throw UnimplementedError('This method is only available on Android');
  }
}

/// A provider that returns OS version of an Android device.
final androidVersionProvider = FutureProvider<AndroidBuildVersion?>((ref) async {
  if (!Platform.isAndroid) {
    return null;
  }
  final info = await DeviceInfoPlugin().androidInfo;
  return info.version;
});
