import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import 'src/app.dart';
import 'src/features/authentication/data/auth_repository.dart';

void main() async {
  if (kDebugMode) {
    Logger.root.onRecord.listen((record) {
      debugPrint(
          '${record.level.name}: ${record.time}: ${record.message}; ${record.error != null ? record.error.toString() : ''}');
    });
  }

  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  final authRepo = container.read(authRepositoryProvider);
  await authRepo.init();
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}
