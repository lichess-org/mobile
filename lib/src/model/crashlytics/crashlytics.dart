/// @docImport 'package:firebase_crashlytics/firebase_crashlytics.dart';
library;

import 'package:flutter/foundation.dart';

/// An abstraction over Firebase Crashlytics.
///
/// This allows to build the app without including the Firebase Crashlytics dependencies.
abstract class Crashlytics() {
  /// See [FirebaseCrashlytics.recordError].
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    Iterable<Object> information = const [],
    bool? printDetails,
    bool fatal = false,
  });

  /// See [FirebaseCrashlytics.recordFlutterFatalError].
  void recordFlutterFatalError(FlutterErrorDetails flutterErrorDetails);

  /// See [FirebaseCrashlytics.setCustomKey].
  Future<void> setCustomKey(String key, Object value);
}
