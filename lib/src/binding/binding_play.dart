import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:lichess_mobile/firebase_options.dart';
import 'package:lichess_mobile/firebase_options_preview.dart' as firebase_preview;
import 'package:lichess_mobile/src/binding/binding.dart';
import 'package:lichess_mobile/src/binding/binding_fcm.dart';
import 'package:lichess_mobile/src/model/crashlytics/crashlytics.dart';
import 'package:lichess_mobile/src/model/crashlytics/crashlytics_firebase.dart';

/// Concrete implementation of [LichessBinding] for the Play Store.
class PlayLichessBinding() extends LichessBindingBase with FcmBinding {
  factory ensureInitialized() {
    return LichessBinding.ensureInitialized(() => PlayLichessBinding());
  }

  @override
  Future<void> initializeFirebase() async {
    final firebaseOptions = switch (appFlavor) {
      'prod' => DefaultFirebaseOptions.currentPlatform,
      'preview' => firebase_preview.DefaultFirebaseOptions.currentPlatform,
      _ => throw StateError('Unexpected or missing flavor'),
    };

    await Firebase.initializeApp(options: firebaseOptions);

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
