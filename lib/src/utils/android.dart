import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final androidVersionProvider =
    FutureProvider<AndroidBuildVersion?>((ref) async {
  if (!Platform.isAndroid) {
    return null;
  }
  final info = await DeviceInfoPlugin().androidInfo;
  return info.version;
});
