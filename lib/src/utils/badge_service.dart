import 'dart:async';

import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

final badgeService = BadgeService(Logger('BadgeService'));

class BadgeService {
  static const _channel = MethodChannel('mobile.lichess.org/badge');

  const BadgeService(this._log);

  final Logger _log;

  Future<void> setBadge(int value) async {
    try {
      await _channel.invokeMethod<int>('setBadge', <String, dynamic>{
        'badge': value,
      });
    } on PlatformException catch (e) {
      _log.severe(e);
    }
  }

  Future<void> clearBadge() async {
    try {
      await _channel.invokeMethod<int>('setBadge', 0);
    } on PlatformException catch (e) {
      _log.severe(e);
    }
  }
}
