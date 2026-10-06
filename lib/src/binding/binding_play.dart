import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/firebase_options.dart';
import 'package:lichess_mobile/src/binding/binding.dart';
import 'package:lichess_mobile/src/crashlytics/crashlytics.dart';
import 'package:lichess_mobile/src/crashlytics/crashlytics_firebase.dart';

/// Concrete implementation of [LichessBinding] for the Play Store.
class PlayLichessBinding() extends LichessBindingBase {
  static PlayLichessBinding get instance => LichessBinding.checkInstance(_instance);
  static PlayLichessBinding? _instance;

  factory ensureInitialized() {
    if (_instance == null) {
      PlayLichessBinding();
    }
    return instance;
  }

  @override
  void initInstance() {
    super.initInstance();
    _instance = this;
  }

  @override
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    if (kReleaseMode) {
      FlutterError.onError = firebaseCrashlytics.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        if (kDebugMode) {
          return false;
        } else {
          firebaseCrashlytics.recordError(error, stack);
          return true;
        }
      };
    }
  }

  @override
  Crashlytics get firebaseCrashlytics => PlayCrashlytics(FirebaseCrashlytics.instance);
}
