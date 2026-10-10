import 'package:lichess_mobile/src/binding/binding.dart';
import 'package:lichess_mobile/src/crashlytics/crashlytics.dart';
import 'package:lichess_mobile/src/crashlytics/crashlytics_noop.dart';

/// Concrete implementation of [LichessBinding] for F-Droid.
class FdroidLichessBinding() extends LichessBindingBase {
  static FdroidLichessBinding get instance => LichessBinding.checkInstance(_instance);
  static FdroidLichessBinding? _instance;

  factory ensureInitialized() {
    if (_instance == null) {
      FdroidLichessBinding();
    }
    return instance;
  }

  @override
  void initInstance() {
    super.initInstance();
    _instance = this;
  }

  @override
  Future<void> initializeFirebase() async {}

  @override
  Crashlytics get firebaseCrashlytics => const FdroidCrashlytics();
}
