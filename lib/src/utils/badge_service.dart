import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

class BadgeService {
  static const _channel = MethodChannel('mobile.lichess.org/badge');

  const BadgeService._(this._log);

  static final instance = BadgeService._(Logger('BadgeService'));

  final Logger _log;

  Future<void> setBadge(int value) async {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      return;
    }

    try {
      await _channel.invokeMethod<int>('setBadge', <String, dynamic>{
        'badge': value,
      });
    } on PlatformException catch (e) {
      _log.severe(e);
    }
  }
}
