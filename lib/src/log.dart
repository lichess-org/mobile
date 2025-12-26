import 'dart:developer' as developer;

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/log_preferences.dart';
import 'package:logging/logging.dart';

const _loggersToShowInTerminal = {'HttpClient', 'Socket', 'EvaluationService'};

typedef LogState = ({IList<LogRecord> logs});

/// Provides an instance of [AppLogStorage] using Riverpod.
final appLogStorageProvider = NotifierProvider<AppLogStorage, LogState>(
  AppLogStorage.new,
  name: 'AppLogStorageProvider',
);

/// Manages log entries created via [Logger] instances
///
/// Currently, simply saves log entries in memory, so they do not persists across app restarts.
class AppLogStorage extends Notifier<LogState> {
  @override
  LogState build() => (logs: const IList.empty());

  void setup() {
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

      _save(record);
    });
  }

  void clear() {
    state = (logs: const IList.empty());
  }

  void _save(LogRecord record) {
    // Avoid the "Tried to modify a provider while the widget tree was building" error
    Future.microtask(() {
      state = (logs: state.logs.add(record));
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
