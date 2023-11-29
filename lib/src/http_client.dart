import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart';
import 'package:cupertino_http/cupertino_http.dart';

import 'package:lichess_mobile/src/model/user/user.dart';

part 'http_client.g.dart';

@Riverpod(keepAlive: true)
Client httpClient(HttpClientRef ref) {
  final client = defaultTargetPlatform == TargetPlatform.iOS
      ? CupertinoClient.defaultSessionConfiguration()
      : Client();
  ref.onDispose(() {
    client.close();
  });
  return client;
}

String makeUserAgent(
  PackageInfo info,
  BaseDeviceInfo deviceInfo,
  String sri,
  LightUser? user,
) {
  final base =
      'Lichess Mobile/${info.version} (${info.buildNumber}) as:${user != null ? user.id : 'anon'} sri:$sri';

  if (deviceInfo is AndroidDeviceInfo) {
    return '$base os:Android/${deviceInfo.version.release} dev:${deviceInfo.model}';
  } else if (deviceInfo is IosDeviceInfo) {
    return '$base os:iOS/${deviceInfo.systemVersion} dev:${deviceInfo.model}';
  }

  return base;
}
