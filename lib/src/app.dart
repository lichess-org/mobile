import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:lichess_mobile/src/app_dependencies.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/settings/brightness.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/widgets/bottom_navigation.dart';

class LoadApp extends ConsumerWidget {
  const LoadApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<AppDependencies>>(
      appDependenciesProvider,
      (_, state) {
        if (state.hasValue) {
          FlutterNativeSplash.remove();
        }
      },
    );

    final appDependencies = ref.watch(appDependenciesProvider);
    return appDependencies.when(
      data: (_) => const App(),
      // loading screen is handled by the native splash screen
      loading: () => const SizedBox.shrink(),
      error: (err, st) {
        debugPrint(
          'SEVERE: [App] could not load app dependencies; $err\n$st',
        );
        return const SizedBox.shrink();
      },
    );
  }
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(
      generalPreferencesProvider.select(
        (state) => state.themeMode,
      ),
    );
    final brightness = ref.watch(currentBrightnessProvider);
    final boardTheme = ref.watch(
      boardPreferencesProvider.select(
        (state) => state.boardTheme,
      ),
    );
    final screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: kSupportedLocales,
      onGenerateTitle: (BuildContext context) => 'lichess.org',
      theme: ThemeData(
        navigationBarTheme: NavigationBarTheme.of(context).copyWith(
          height: screenHeight < kSmallHeightScreenThreshold ? 60 : null,
        ),
        textTheme: defaultTargetPlatform == TargetPlatform.iOS
            ? brightness == Brightness.light
                ? Typography.blackCupertino
                : Typography.whiteCupertino
            : null,
        colorSchemeSeed: boardTheme.colors.darkSquare,
        useMaterial3: true,
        brightness: brightness,
        cardTheme: CardTheme(
          surfaceTintColor:
              brightness == Brightness.light ? Colors.black : Colors.white,
        ),
      ),
      themeMode: themeMode,
      builder: (context, child) {
        return CupertinoTheme(
          data: CupertinoThemeData(
            brightness: brightness,
            barBackgroundColor: const CupertinoDynamicColor.withBrightness(
              color: Color(0xC8F9F9F9),
              darkColor: Color(0xC81D1D1D),
            ),
            scaffoldBackgroundColor: brightness == Brightness.light
                ? CupertinoColors.systemGroupedBackground
                : null,
          ),
          child: Material(child: child),
        );
      },
      home: const BottomNavScaffold(),
    );
  }

  @override
  void initState() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      setOptimalDisplayMode();
    }
    super.initState();
  }

  // Code taken from https://stackoverflow.com/questions/63631522/flutter-120fps-issue
  /// Enables high refresh rate for devices where it was previously disabled
  Future<void> setOptimalDisplayMode() async {
    final List<DisplayMode> supported = await FlutterDisplayMode.supported;
    final DisplayMode active = await FlutterDisplayMode.active;

    final List<DisplayMode> sameResolution = supported
        .where(
          (DisplayMode m) =>
              m.width == active.width && m.height == active.height,
        )
        .toList()
      ..sort(
        (DisplayMode a, DisplayMode b) =>
            b.refreshRate.compareTo(a.refreshRate),
      );

    final DisplayMode mostOptimalMode =
        sameResolution.isNotEmpty ? sameResolution.first : active;

    // This setting is per session.
    await FlutterDisplayMode.setPreferredMode(mostOptimalMode);
  }
}
