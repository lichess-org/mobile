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
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  final lichessBinding = AppLichessBinding.ensureInitialized();

  // Show splash screen until app is ready
  // See src/app.dart for splash screen removal
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Old API.
  // TODO: Remove this once all SharedPreferences usage is migrated to SharedPreferencesAsync.
  SharedPreferences.setPrefix('lichess.');
  await migrateSharedPreferences();

  await lichessBinding.preloadSharedPreferences();

  if (defaultTargetPlatform == TargetPlatform.android) {
    await androidDisplayInitialization(widgetsBinding);
  }

  await preloadPieceImages();

  await setupFirstLaunch();

  await SoundService.initialize();

  final locale = await setupIntl(widgetsBinding);

  await initializeLocalNotifications(locale);

  await lichessBinding.initializeFirebase();

  runApp(ProviderScope(observers: [ProviderLogger()], child: const AppInitializationScreen()));
}

Future<void> migrateSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  final didMigrate = prefs.getBool('shared_preferences_did_migrate') ?? false;
  if (didMigrate) {
    return;
  }
  final newPrefs = SharedPreferencesAsync();
  for (final key in prefs.getKeys()) {
    final value = prefs.get(key);
    if (value is String) {
      await newPrefs.setString(key, value);
    } else if (value is int) {
      await newPrefs.setInt(key, value);
    } else if (value is double) {
      await newPrefs.setDouble(key, value);
    } else if (value is bool) {
      await newPrefs.setBool(key, value);
    } else if (value is List<String>) {
      await newPrefs.setStringList(key, value);
    }
  }
  await prefs.setBool('shared_preferences_did_migrate', true);
}
