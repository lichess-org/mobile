import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import 'src/app.dart';
import 'src/features/authentication/data/auth_repository.dart';

void main() async {
  if (kDebugMode) {
    Logger.root.onRecord.listen((record) {
      final time = DateFormat.Hms().format(record.time);
      debugPrint(
          '${record.level.name} at $time: [${record.loggerName}] ${record.message}${record.error != null ? '\n${record.error.toString()}' : ''}');
    });
  }

  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  final authRepo = container.read(authRepositoryProvider);
  await authRepo.init();
  runApp(UncontrolledProviderScope(container: container, child: const App()));
}
