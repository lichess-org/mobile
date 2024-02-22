import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final androidVersionProvider = FutureProvider<AndroidBuildVersion>((ref) async {
  final info = await DeviceInfoPlugin().androidInfo;
  return info.version;
});
