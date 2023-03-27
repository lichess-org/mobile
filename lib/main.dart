import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'src/app.dart';

void main() {
  if (kDebugMode) {
    Logger.root.onRecord.listen((record) {
      if (record.level >= Level.INFO) {
        final time = DateFormat.Hms().format(record.time);
        debugPrint(
          '${record.level.name} at $time [${record.loggerName}] ${record.message}${record.error != null ? '\n${record.error}' : ''}',
        );
      }
    });
  }

  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

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
    _logger.fine(
      '${provider.name ?? provider.runtimeType} initialized with: $value.',
    );
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    _logger.fine('${provider.name ?? provider.runtimeType} disposed.');
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
