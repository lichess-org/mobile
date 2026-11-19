import 'package:lichess_mobile/src/binding/binding.dart';
import 'package:lichess_mobile/src/binding/crashlytics.dart';

/// Concrete implementation of [LichessBinding] for F-Droid.
class FdroidLichessBinding() extends LichessBindingBase {
  factory ensureInitialized() {
    return LichessBinding.ensureInitialized(() => FdroidLichessBinding());
  }

  @override
  Future<void> initializeFirebase() async {}

  @override
  Crashlytics get firebaseCrashlytics => const NoOpCrashlytics();
}
