import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';
import 'src/features/authentication/data/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  final authRepo = container.read(authRepositoryProvider);
  await authRepo.init();
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}
