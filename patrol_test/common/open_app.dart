import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/app.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/init.dart';
import 'package:lichess_mobile/src/intl.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/log/app_log_service.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';
import 'package:patrol/patrol.dart';

/// Boots the app the same way `main` does, minus the steps the Patrol binding already owns:
/// the widgets binding is initialized by Patrol, the root widget is pumped through the tester
/// and the native splash screen is never preserved.
Future<void> openApp(PatrolIntegrationTester $) async {
  final widgetsBinding = WidgetsBinding.instance;
  final lichessBinding = AppLichessBinding.ensureInitialized();

  await Future.wait([
    lichessBinding.preloadSharedPreferences(),
    if (defaultTargetPlatform != TargetPlatform.linux) lichessBinding.initializeFirebase(),
  ]);

  if (defaultTargetPlatform == TargetPlatform.android) {
    await androidDisplayInitialization(widgetsBinding);
  }

  final locale = setupIntl(widgetsBinding);

  unawaited(preloadPieceImages());
  unawaited(initializeApp());
  unawaited(SoundService.initialize());
  unawaited(initializeLocalNotifications(locale));

  await $.pumpWidget(
    ProviderScope(
      observers: [ProviderLogger()],
      retry: lichessProviderRetry,
      child: const AppInitializationScreen(),
    ),
  );
}
