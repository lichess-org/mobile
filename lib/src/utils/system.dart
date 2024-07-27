import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

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
    }
  }
}
