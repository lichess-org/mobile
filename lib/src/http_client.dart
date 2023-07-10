import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart';

import 'package:lichess_mobile/src/model/user/user.dart';

part 'http_client.g.dart';

@Riverpod(keepAlive: true)
Client httpClient(HttpClientRef ref) {
  final client = Client();
  ref.onDispose(() {
    client.close();
  });
  return client;
}

String userAgent(PackageInfo info, BaseDeviceInfo deviceInfo, LightUser? user) {
  final base =
      'Lichess Mobile/${info.version} (${info.buildNumber}) as:${user != null ? user.id : 'anon'}';

  if (deviceInfo is AndroidDeviceInfo) {
    return '$base os:android/${deviceInfo.version.release} dev:${deviceInfo.model}';
  } else if (deviceInfo is IosDeviceInfo) {
    return '$base os:ios/${deviceInfo.systemVersion} dev:${deviceInfo.model}';
  }

  return base;
}
