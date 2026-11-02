/// @docImport 'package:firebase_crashlytics/firebase_crashlytics.dart';
library;

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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

/// A no-op implementation of [Crashlytics] for F-Droid, which does not include Firebase Crashlytics.
class const NoOpCrashlytics() implements Crashlytics {
  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    Iterable<Object> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) async {}

  @override
  void recordFlutterFatalError(FlutterErrorDetails flutterErrorDetails) {}

  @override
  Future<void> setCustomKey(String key, Object value) async {}
}
