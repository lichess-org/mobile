import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:lichess_mobile/src/app_dependencies.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/lichess_colors.dart';
import 'package:lichess_mobile/src/model/settings/providers.dart';
import 'package:lichess_mobile/src/widgets/bottom_navigation.dart';

class LoadApp extends ConsumerWidget {
  const LoadApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appDependencies = ref.watch(appDependenciesProvider);
    return appDependencies.when(
      data: (_) => const App(),
      loading: () => const SizedBox.shrink(),
      error: (err, st) {
        debugPrint(
          'SEVERE: [App] could not load appInitProvider; $err\n$st',
        );
        return const SizedBox.shrink();
      },
    );
  }
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModePrefProvider);
    final brightness = ref.watch(currentBrightnessProvider);
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: kSupportedLocales,
      onGenerateTitle: (BuildContext context) => 'lichess.org',
      theme: ThemeData(
        colorSchemeSeed: LichessColors.primary,
        useMaterial3: true,
        brightness: brightness,
      ),
      themeMode: themeMode,
      builder: (context, child) {
        return CupertinoTheme(
          data: CupertinoThemeData(
            brightness: brightness,
            barBackgroundColor: const CupertinoDynamicColor.withBrightness(
              color: Color(0x96F9F9F9),
              darkColor: Color(0x961D1D1D),
            ),
            scaffoldBackgroundColor: brightness == Brightness.light
                ? CupertinoColors.systemGroupedBackground
                : null,
          ),
          child: Material(child: child),
        );
      },
      onGenerateRoute: (RouteSettings settings) {
        // we don't use named routes but we need this for iOS modal animation
        // see: https://pub.dev/packages/modal_bottom_sheet
        switch (settings.name) {
          case '/':
            return MaterialWithModalsPageRoute(
              builder: (_) => const BottomNavScaffold(),
              settings: settings,
            );
        }
        return null;
      },
    );
  }
}
