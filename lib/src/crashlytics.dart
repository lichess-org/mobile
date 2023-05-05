import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crashlytics.g.dart';

@Riverpod(keepAlive: true)
FirebaseCrashlytics crashlytics(CrashlyticsRef ref) {
  return FirebaseCrashlytics.instance;
}
