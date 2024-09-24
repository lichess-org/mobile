import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/init.dart';
import 'package:lichess_mobile/src/intl.dart';
import 'package:lichess_mobile/src/log.dart';
import 'package:lichess_mobile/src/model/notifications/local_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'src/app.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences.setPrefix('lichess.');

  // Show splash screen until app is ready
  // See src/app.dart for splash screen removal
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  setupLoggingAndCrashReporting();

  await setupFirstLaunch();

  final locale = await setupIntl(widgetsBinding);

  await LocalNotificationService.initialize(locale);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (defaultTargetPlatform == TargetPlatform.android) {
    await androidDisplayInitialization(widgetsBinding);
  }

  runApp(
    ProviderScope(
      observers: [
        ProviderLogger(),
      ],
      child: const AppInitializationScreen(),
    ),
  );
}
