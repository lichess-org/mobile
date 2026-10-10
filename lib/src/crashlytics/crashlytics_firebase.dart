import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/src/crashlytics/crashlytics.dart';

/// The implementation for the Play Store, delegating to the real Firebase Crashlytics.
class PlayCrashlytics(final FirebaseCrashlytics _delegate) implements Crashlytics {
  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    Iterable<Object> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) {
    return _delegate.recordError(
      exception,
      stack,
      reason: reason,
      information: information,
      printDetails: printDetails,
      fatal: fatal,
    );
  }

  @override
  void recordFlutterFatalError(FlutterErrorDetails flutterErrorDetails) {
    _delegate.recordFlutterFatalError(flutterErrorDetails);
  }

  @override
  Future<void> setCustomKey(String key, Object value) {
    return _delegate.setCustomKey(key, value);
  }
}
