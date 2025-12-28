import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/log_preferences.dart';
import 'package:lichess_mobile/src/utils/lru_list.dart';
import 'package:logging/logging.dart';

const _loggersToShowInTerminal = {'HttpClient', 'Socket', 'EvaluationService'};

/// Provides an instance of [AppLogStorageService] using Riverpod.
final appLogStorageServiceProvider = Provider<AppLogStorageService>(
  (Ref ref) => AppLogStorageService(ref),
  name: 'AppLogStorageServiceProvider',
);

/// Manages log entries created via [Logger] instances
///
/// Currently, simply saves the most recent log entries in memory, so they do not persists across app restarts.
class AppLogStorageService {
  AppLogStorageService(this.ref);

  final Ref ref;
  final _logs = LRUList<LogRecord>(capacity: 1024);

  /// Currently stored log entries, ordered from oldest to newest.
  Iterable<LogRecord> get logs => _logs.values;

  void start() {
    ref.listen(logPreferencesProvider.select((prefs) => prefs.level), (prev, next) {
      if (next != prev) {
        Logger.root.level = next;
      }
    }, fireImmediately: true);

    Logger.root.onRecord.listen((record) {
      if (kDebugMode) {
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
      }

      _logs.put(record);
    });
  }

  void clear() {
    _logs.clear();
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
