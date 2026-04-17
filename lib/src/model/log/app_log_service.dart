import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/log/app_log_storage.dart';
import 'package:lichess_mobile/src/model/settings/log_preferences.dart';
import 'package:lichess_mobile/src/utils/lru_list.dart';
import 'package:logging/logging.dart';

const _loggersToShowInTerminal = {'HttpClient', 'Socket', 'EvaluationService'};

/// Provides an instance of [AppLogService] using Riverpod.
final appLogServiceProvider = Provider<AppLogService>(
  (Ref ref) => AppLogService(ref),
  name: 'AppLogServiceProvider',
);

/// Manages log entries created via [Logger] instances.
///
/// Log entries are stored in memory for the current session and persisted to the
/// SQLite database so they survive app restarts.
class AppLogService {
  AppLogService(this.ref);

  final Ref ref;
  final _logs = LRUList<LogRecord>(capacity: 1024);

  /// Currently stored log entries, ordered from oldest to newest.
  Iterable<LogRecord> get logs => _logs.values;

  void start() {
    if (kDebugMode) {
      Logger.root.level = Level.ALL;
    } else {
      ref.listen(logPreferencesProvider.select((prefs) => prefs.level), (prev, next) {
        if (next != prev) {
          Logger.root.level = next;
        }
      }, fireImmediately: true);
    }

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

        if (_loggersToShowInTerminal.contains(record.loggerName) &&
            record.level >= Level.FINE &&
            !Platform.environment.containsKey('FLUTTER_TEST')) {
          debugPrint('[${record.loggerName}] ${record.message}');
        }
      } else {
        if (record.loggerName == 'Stockfish' && record.level >= Level.SEVERE) {
          // help debugging engine in error state issues in production
          LichessBinding.instance.firebaseCrashlytics.recordError(
            record.message,
            record.stackTrace,
          );
        }
      }

      _logs.put(record);

      // Persist to database asynchronously (fire-and-forget).
      // The try-catch guards against ref being invalid (e.g. disposed ProviderScope in tests).
      scheduleMicrotask(() {
        try {
          ref
              .read(appLogStorageProvider.future)
              .then((storage) => storage.save(AppLogEntry.fromLogRecord(record)), onError: (_) {});
        } catch (_) {}
      });
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
    _logger.fine('${context.provider.name ?? context.provider.runtimeType} initialized', value);
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    _logger.fine('${context.provider.name ?? context.provider.runtimeType} disposed');
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
