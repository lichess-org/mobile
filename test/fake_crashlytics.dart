import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:mocktail/mocktail.dart';

// ignore_for_file: avoid_implementing_value_types
// ignore_for_file: type_annotate_public_apis
// ignore_for_file: strict_raw_type

class MockFirebaseApp extends Mock implements FirebaseApp {}

class FakeCrashlytics implements FirebaseCrashlytics {
  @override
  FirebaseApp app = MockFirebaseApp();

  @override
  Future<bool> checkForUnsentReports() async {
    return false;
  }

  @override
  void crash() {}

  @override
  Future<void> deleteUnsentReports() async {}

  @override
  Future<bool> didCrashOnPreviousExecution() async {
    return false;
  }

  @override
  // TODO: implement isCrashlyticsCollectionEnabled
  bool get isCrashlyticsCollectionEnabled => false;

  @override
  Future<void> log(String message) async {}

  @override
  // TODO: implement pluginConstants
  Map get pluginConstants => {};

  @override
  Future<void> recordError(
    exception,
    StackTrace? stack, {
    reason,
    Iterable<Object> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) async {}

  @override
  Future<void> recordFlutterError(
    FlutterErrorDetails flutterErrorDetails, {
    bool fatal = false,
  }) async {}

  @override
  Future<void> recordFlutterFatalError(FlutterErrorDetails flutterErrorDetails) async {}

  @override
  Future<void> sendUnsentReports() async {}

  @override
  Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {}

  @override
  Future<void> setCustomKey(String key, Object value) async {}

  @override
  Future<void> setUserIdentifier(String identifier) async {}
}
