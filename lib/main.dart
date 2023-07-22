import 'dart:developer' as developer;
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';

import 'src/constants.dart';
import 'src/app.dart';

void main() async {
  if (kDebugMode) {
    Logger.root.onRecord.listen((record) {
      developer.log(
        record.message,
        time: record.time,
        name: record.loggerName,
        level: record.level.value,
        error: record.error,
        stackTrace: record.stackTrace,
      );

      if (record.loggerName == 'AuthClient' ||
          record.loggerName == 'LobbyAuthClient' ||
          record.loggerName == 'AuthSocket') {
        debugPrint(record.message);
      }
    });
  }

  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Crashlytics setup
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kReleaseMode) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  if (defaultTargetPlatform == TargetPlatform.android) {
    final view = widgetsBinding.platformDispatcher.views.first;
    final data = MediaQueryData.fromView(view);
    if (data.size.shortestSide < kTabletThreshold) {
      await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp],
      );
    }
  }

  runApp(
    ProviderScope(
      observers: [
        ProviderLogger(),
      ],
      child: const LoadApp(),
    ),
  );
}

class ProviderLogger extends ProviderObserver {
  final _logger = Logger('Provider');

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    _logger.info(
      '${provider.name ?? provider.runtimeType} initialized',
      value,
    );
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    _logger.info('${provider.name ?? provider.runtimeType} disposed');
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    _logger.severe(
      '${provider.name ?? provider.runtimeType} error',
      error,
      stackTrace,
    );
  }
}
