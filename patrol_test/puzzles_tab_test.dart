import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/app.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/init.dart';
import 'package:lichess_mobile/src/intl.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/log/app_log_service.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';
import 'package:lichess_mobile/src/view/home/home_tab_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_tab_screen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest('app starts and the puzzles tab opens', ($) async {
    await pumpLichessApp($);

    await $(HomeTabScreen).waitUntilVisible(timeout: const Duration(seconds: 60));

    await $(BottomTab.puzzles.icon).tap();

    await $(PuzzleTabScreen).waitUntilVisible();
  });
}

/// Initializes and pumps the real app, mirroring `main()` in `lib/main.dart`.
///
/// Differences from `main()`: the widgets binding is already set up by `patrolTest`, the native
/// splash screen is not preserved, and the root widget is pumped instead of passed to `runApp`.
/// Keep this in sync with `main()` when it changes.
Future<void> pumpLichessApp(PatrolIntegrationTester $) async {
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
