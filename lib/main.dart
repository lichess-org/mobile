import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';

import 'src/app.dart';
import 'src/common/sound.dart';
import 'src/common/shared_preferences.dart';
import 'src/features/auth/data/auth_repository.dart';

void main() async {
  if (kDebugMode) {
    Logger.root.onRecord.listen((record) {
      final time = DateFormat.Hms().format(record.time);
      debugPrint(
          '${record.level.name} at $time [${record.loggerName}] ${record.message}${record.error != null ? '\n${record.error}' : ''}');
    });
  }

  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ],
    observers: [
      ProviderLogger(),
    ],
  );

  await container.read(authRepositoryProvider).init();
  await container.read(soundServiceProvider).init();

  runApp(UncontrolledProviderScope(
    container: container,
    child: const App(),
  ));
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
        '${provider.name ?? provider.runtimeType} initialized with: $value.');
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    _logger.info('${provider.name ?? provider.runtimeType} disposed.');
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    _logger.severe(
        '${provider.name ?? provider.runtimeType} error', error, stackTrace);
  }
}
