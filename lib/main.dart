import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/app.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/init.dart';
import 'package:lichess_mobile/src/intl.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/log/app_log_service.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';
import 'package:material_ui/material_ui.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  final lichessBinding = AppLichessBinding.ensureInitialized();

  // Show splash screen until app is ready
  // See src/app.dart for splash screen removal
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Future.wait([
    lichessBinding.preloadSharedPreferences(),
    if (defaultTargetPlatform != TargetPlatform.linux) lichessBinding.initializeFirebase(),
  ]);

  // Must run before [initializeApp], which uses the system colors to pick the default board theme
  // on first run.
  if (defaultTargetPlatform == TargetPlatform.android) {
    await androidDisplayInitialization(widgetsBinding);
  }

  final locale = setupIntl(widgetsBinding);

  // Background initialization tasks (non-blocking for first frame)
  unawaited(preloadPieceImages());
  unawaited(initializeApp());
  unawaited(SoundService.initialize());
  unawaited(initializeLocalNotifications(locale));

  runApp(
    ProviderScope(
      observers: [ProviderLogger()],
      retry: lichessProviderRetry,
      child: const AppInitializationScreen(),
    ),
  );
}
