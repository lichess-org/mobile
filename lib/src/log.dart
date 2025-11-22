import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

const _loggersToShowInTerminal = {'HttpClient', 'Socket', 'EvaluationService'};

/// Setup logging
void setupLogging() {
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

      if (_loggersToShowInTerminal.contains(record.loggerName) && record.level >= Level.FINE) {
        debugPrint('[${record.loggerName}] ${record.message}');
      }
    });
  }
}

final class ProviderLogger extends ProviderObserver {
  final _logger = Logger('Provider');

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    _logger.info('${context.provider.name ?? context.provider.runtimeType} initialized', value);
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    _logger.info('${context.provider.name ?? context.provider.runtimeType} disposed');
  }

  @override
  void providerDidFail(ProviderObserverContext context, Object error, StackTrace stackTrace) {
    _logger.severe(
      '${context.provider.name ?? context.provider.runtimeType} error',
      error,
      stackTrace,
    );
  }
}
