import 'package:device_info_plus/device_info_plus.dart';
import 'package:lichess_mobile/src/app_initialization.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_info.g.dart';

@Riverpod(keepAlive: true)
BaseDeviceInfo deviceInfo(DeviceInfoRef ref) {
  // requireValue is possible because appInitializationProvider is loaded before
  // anything. See: lib/src/app.dart
  return ref.read(appInitializationProvider).requireValue.deviceInfo;
}
