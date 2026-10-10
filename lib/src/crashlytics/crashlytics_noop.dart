import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/src/crashlytics/crashlytics.dart';

/// A no-op implementation for F-Droid.
class const FdroidCrashlytics() implements Crashlytics {
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
