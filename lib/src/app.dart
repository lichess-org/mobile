import 'package:dynamic_color/dynamic_color.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_service.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_service.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/brightness.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/screen.dart';

/// Application initialization and main entry point.
class AppInitializationScreen extends ConsumerWidget {
  const AppInitializationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<PreloadedData>>(preloadedDataProvider, (_, state) {
      if (state.hasValue || state.hasError) {
        FlutterNativeSplash.remove();
      }
    });

    return ref
        .watch(preloadedDataProvider)
        .when(
          data: (_) => const Application(),
          // loading screen is handled by the native splash screen
          loading: () => const SizedBox.shrink(),
          error: (err, st) {
            debugPrint('SEVERE: [App] could not initialize app; $err\n$st');
            return const SizedBox.shrink();
          },
        );
  }
}

/// The main application widget.
///
/// This widget is the root of the application and is responsible for setting up
/// the theme, locale, and other global settings.
class Application extends ConsumerStatefulWidget {
  const Application({super.key});

  @override
  ConsumerState<Application> createState() => _AppState();
}

class _AppState extends ConsumerState<Application> {
  /// Whether the app has checked for online status for the first time.
  bool _firstTimeOnlineCheck = false;

  AppLifecycleListener? _appLifecycleListener;

  @override
  void initState() {
    _appLifecycleListener = AppLifecycleListener(
      onResume: () async {
        final online = await isOnline(ref.read(defaultClientProvider));
        if (online) {
          ref.invalidate(ongoingGamesProvider);
        }
      },
    );

    // Start services
    ref.read(notificationServiceProvider).start();
    ref.read(challengeServiceProvider).start();

    // Listen for connectivity changes and perform actions accordingly.
    ref.listenManual(connectivityChangesProvider, (prev, current) async {
      final prevWasOffline = prev?.value?.isOnline == false;
      final currentIsOnline = current.value?.isOnline == true;

      // Play registered moves whenever the app comes back online.
      if (prevWasOffline && currentIsOnline) {
        final nbMovesPlayed = await ref.read(correspondenceServiceProvider).playRegisteredMoves();
        if (nbMovesPlayed > 0) {
          ref.invalidate(ongoingGamesProvider);
        }
      }

      // Perform actions once when the app comes online.
      if (current.value?.isOnline == true && !_firstTimeOnlineCheck) {
        _firstTimeOnlineCheck = true;
        ref.read(correspondenceServiceProvider).syncGames();
      }

      final socketClient = ref.read(socketPoolProvider).currentClient;
      if (current.value?.isOnline == true &&
          current.value?.appState == AppLifecycleState.resumed &&
          !socketClient.isActive) {
        socketClient.connect();
      } else if (current.value?.isOnline == false) {
        socketClient.close();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _appLifecycleListener?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final generalPrefs = ref.watch(generalPreferencesProvider);

    final brightness = ref.watch(currentBrightnessProvider);

    final remainingHeight = estimateRemainingHeightLeftBoard(context);

    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        final isTablet = isTabletOrLarger(context);
        final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

        final colorScheme =
            brightness == Brightness.light ? AppTheme.light.colorScheme : AppTheme.dark.colorScheme;

        final appTheme = brightness == Brightness.light ? AppTheme.light : AppTheme.dark;

        final cupertinoThemeData = CupertinoThemeData(
          primaryColor: colorScheme.primary,
          primaryContrastingColor: colorScheme.onPrimary,
          brightness: brightness,
          textTheme: CupertinoTheme.of(context).textTheme.copyWith(
            primaryColor: colorScheme.primary,
            textStyle: CupertinoTheme.of(
              context,
            ).textTheme.textStyle.copyWith(color: colorScheme.onSurface),
            navTitleTextStyle: CupertinoTheme.of(
              context,
            ).textTheme.navTitleTextStyle.copyWith(color: Styles.cupertinoTitleColor),
            navLargeTitleTextStyle: CupertinoTheme.of(
              context,
            ).textTheme.navLargeTitleTextStyle.copyWith(color: Styles.cupertinoTitleColor),
          ),
          scaffoldBackgroundColor: colorScheme.surface,
          barBackgroundColor: appTheme.appBarTheme.backgroundColor?.withValues(
            alpha: isTablet ? 1.0 : 0.9,
          ),
          applyThemeToAll: true,
        );

        return MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: kSupportedLocales,
          onGenerateTitle: (BuildContext context) => 'lichess.org',
          locale: generalPrefs.locale,
          theme: AppTheme.light.copyWith(
            cupertinoOverrideTheme: cupertinoThemeData,
            textTheme:
                Theme.of(context).platform == TargetPlatform.iOS ? Typography.blackCupertino : null,
            navigationBarTheme: NavigationBarTheme.of(context).copyWith(
              height: remainingHeight < kSmallRemainingHeightLeftBoardThreshold ? 60 : null,
            ),
            extensions: [lichessCustomColors.harmonized(colorScheme)],
          ),
          darkTheme: AppTheme.dark
              .copyWith(
                textTheme:
                    isIOS
                        ? brightness == Brightness.light
                            ? Typography.blackCupertino
                            : Styles.whiteCupertinoTextTheme
                        : null,
              )
              .copyWith(
                splashFactory: isIOS ? NoSplash.splashFactory : null,
                cupertinoOverrideTheme: cupertinoThemeData,
                navigationBarTheme: NavigationBarTheme.of(context).copyWith(
                  height: remainingHeight < kSmallRemainingHeightLeftBoardThreshold ? 60 : null,
                ),
                extensions: [lichessCustomColors.harmonized(colorScheme)],
              ),
          themeMode: switch (generalPrefs.themeMode) {
            BackgroundThemeMode.light => ThemeMode.light,
            BackgroundThemeMode.dark => ThemeMode.dark,
            BackgroundThemeMode.system => ThemeMode.system,
          },
          builder:
              Theme.of(context).platform == TargetPlatform.iOS
                  ? (context, child) {
                    // return CupertinoTheme(
                    //   data: cupertinoThemeData,
                    //   child: IconTheme.merge(
                    //     data: IconThemeData(
                    //       color: CupertinoTheme.of(context).textTheme.textStyle.color,
                    //     ),
                    //     child: Material(child: child),
                    //   ),
                    // );
                    return Material(child: child);
                  }
                  : null,
          home: const BottomNavScaffold(),
          navigatorObservers: [rootNavPageRouteObserver],
        );
      },
    );
  }
}

/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade package to version 8.0.2.
///
/// Use in [MaterialApp] like this:
///
/// MaterialApp(
///  theme: AppTheme.light,
///  darkTheme: AppTheme.dark,
///  :
/// );
sealed class AppTheme {
  // The defined light theme.
  static ThemeData light = FlexThemeData.light(
    scheme: FlexScheme.espresso,
    surfaceMode: FlexSurfaceMode.highBackgroundLowScaffold,
    blendLevel: 1,
    appBarStyle: FlexAppBarStyle.background,
    bottomAppBarElevation: 2.0,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
  // The defined dark theme.
  static ThemeData dark = FlexThemeData.dark(
    scheme: FlexScheme.espresso,
    surfaceMode: FlexSurfaceMode.highBackgroundLowScaffold,
    blendLevel: 16,
    appBarStyle: FlexAppBarStyle.background,
    bottomAppBarElevation: 2.0,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}

// --

(ColorScheme light, ColorScheme dark) _generateDynamicColourSchemes(
  ColorScheme lightDynamic,
  ColorScheme darkDynamic,
) {
  final lightBase = ColorScheme.fromSeed(seedColor: lightDynamic.primary);
  final darkBase = ColorScheme.fromSeed(
    seedColor: darkDynamic.primary,
    brightness: Brightness.dark,
  );

  final lightAdditionalColours = _extractAdditionalColours(lightBase);
  final darkAdditionalColours = _extractAdditionalColours(darkBase);

  final lightScheme = _insertAdditionalColours(lightBase, lightAdditionalColours);
  final darkScheme = _insertAdditionalColours(darkBase, darkAdditionalColours);

  return (lightScheme.harmonized(), darkScheme.harmonized());
}

List<Color> _extractAdditionalColours(ColorScheme scheme) => [
  scheme.surface,
  scheme.surfaceDim,
  scheme.surfaceBright,
  scheme.surfaceContainerLowest,
  scheme.surfaceContainerLow,
  scheme.surfaceContainer,
  scheme.surfaceContainerHigh,
  scheme.surfaceContainerHighest,
];

ColorScheme _insertAdditionalColours(ColorScheme scheme, List<Color> additionalColours) =>
    scheme.copyWith(
      surface: additionalColours[0],
      surfaceDim: additionalColours[1],
      surfaceBright: additionalColours[2],
      surfaceContainerLowest: additionalColours[3],
      surfaceContainerLow: additionalColours[4],
      surfaceContainer: additionalColours[5],
      surfaceContainerHigh: additionalColours[6],
      surfaceContainerHighest: additionalColours[7],
    );
