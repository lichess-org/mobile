import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final androidVersionProvider =
    FutureProvider<AndroidBuildVersion?>((ref) async {
  if (!Platform.isAndroid) {
    return null;
  }
  final info = await DeviceInfoPlugin().androidInfo;
  return info.version;
});

class AndroidStorage {
  static const _channel = MethodChannel('mobile.lichess.org/storage');

  const AndroidStorage._();

  static const instance = AndroidStorage._();

  /// Clear all user data from the app.
  Future<bool> clearUserData() async {
    if (Platform.isAndroid) {
      try {
        final result =
            await _channel.invokeMethod<bool>('clearApplicationUserData');
        return result ?? false;
      } on PlatformException catch (e) {
        debugPrint('Failed to clear user data: ${e.message}');
        return false;
      }
    }

    throw UnimplementedError('This method is only available on Android');
  }
}
