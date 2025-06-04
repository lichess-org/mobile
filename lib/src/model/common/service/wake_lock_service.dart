import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class WakeLockService {
  Future<void> enable() async {
    await WakelockPlus.enable();
  }

  Future<void> disable() async {
    await WakelockPlus.disable();
  }

  Future<bool> isEnabled() async {
    return await WakelockPlus.enabled;
  }
}

/// Provider for the WakeLockService.
final wakeLockServiceProvider = Provider<WakeLockService>((ref) {
  return WakeLockService();
});
