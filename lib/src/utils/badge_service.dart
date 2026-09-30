import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

class const BadgeService._(final Logger _log) {
  static const _channel = MethodChannel('mobile.lichess.org/badge');

  static final instance = BadgeService._(Logger('BadgeService'));

  Future<void> setBadge(int value) async {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      return;
    }

    try {
      await _channel.invokeMethod<int>('setBadge', <String, dynamic>{'badge': value});
    } on PlatformException catch (e, st) {
      _log.severe(e, st);
    }
  }
}
