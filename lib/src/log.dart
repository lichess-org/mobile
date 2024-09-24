import 'dart:developer' as developer;

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

// to see http requests and websocket connections in terminal
const _loggersToShowInTerminal = {
  'HttpClient',
  'Socket',
};

/// Setup logging and crash reporting.
void setupLoggingAndCrashReporting() {
  if (kDebugMode) {
    Logger.root.level = Level.FINE;
    Logger.root.onRecord.listen((record) {
      developer.log(
        record.message,
        time: record.time,
        name: record.loggerName,
        level: record.level.value,
        error: record.error,
        stackTrace: record.stackTrace,
      );

      if (_loggersToShowInTerminal.contains(record.loggerName) &&
          record.level >= Level.INFO) {
        debugPrint('[${record.loggerName}] ${record.message}');
      }

      if (!_loggersToShowInTerminal.contains(record.loggerName) &&
          record.level >= Level.WARNING) {
        debugPrint('[${record.loggerName}] ${record.message}');
      }
    });
  }

  // Crashlytics
  if (kReleaseMode) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
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
