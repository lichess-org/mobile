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

  if (defaultTargetPlatform == TargetPlatform.android) {
    await androidDisplayInitialization(widgetsBinding);
  }

  final view = widgetsBinding.platformDispatcher.views.first;
  await setupOrientation(MediaQueryData.fromView(view).size);

  await preloadPieceImages();

  await setupFirstLaunch();

  await SoundService.initialize();

  final locale = await setupIntl(widgetsBinding);

  await initializeLocalNotifications(locale);

  await lichessBinding.initializeFirebase();

  runApp(ProviderScope(observers: [ProviderLogger()], child: const AppInitializationScreen()));
}
