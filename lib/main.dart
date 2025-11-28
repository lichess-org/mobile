import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/app.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/init.dart';
import 'package:lichess_mobile/src/intl.dart';
import 'package:lichess_mobile/src/log.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  final lichessBinding = AppLichessBinding.ensureInitialized();

  // Show splash screen until app is ready
  // See src/app.dart for splash screen removal
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await lichessBinding.preloadSharedPreferences();

  await preloadPieceImages();

  await initializeApp();

  await SoundService.initialize();

  final locale = await setupIntl(widgetsBinding);

  await initializeLocalNotifications(locale);

  if (defaultTargetPlatform != TargetPlatform.linux) {
    await lichessBinding.initializeFirebase();
  }

  if (defaultTargetPlatform == TargetPlatform.android) {
    final lifecycleState = WidgetsBinding.instance.lifecycleState;
    if (lifecycleState != AppLifecycleState.detached) {
      await androidDisplayInitialization(widgetsBinding);
    }
  }

  runApp(ProviderScope(observers: [ProviderLogger()], child: const AppInitializationScreen()));
}
