import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_service.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_service.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/color_palette.dart' show getSystemScheme;
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
    final isTablet = isTabletOrLarger(context);
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final remainingHeight = estimateRemainingHeightLeftBoard(context);
    final systemScheme = getSystemScheme();
    final flexScheme =
        generalPrefs.systemColors == true && systemScheme != null
            ? systemScheme
            : FlexColor.espresso;
    final themeLight = FlexThemeData.light(
      colors: flexScheme.light,
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
      blendLevel: 10,
      cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
      appBarStyle: isIOS ? null : FlexAppBarStyle.scaffoldBackground,
    );

    // Defined in 2 steps to allow for a different scaffold background color.
    final darkFlexScheme = FlexColorScheme.dark(
      colors: flexScheme.dark,
      surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
      blendLevel: 20,
    );
    final themeDark = FlexThemeData.dark(
      colors: flexScheme.dark,
      surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
      blendLevel: 20,
      cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
      scaffoldBackground:
          darkFlexScheme.scaffoldBackground != null
              ? lighten(darkFlexScheme.scaffoldBackground!, 0.05)
              : null,
      appBarStyle: isIOS ? null : FlexAppBarStyle.scaffoldBackground,
    );

    final floatingActionButtonTheme =
        generalPrefs.systemColors
            ? null
            : FloatingActionButtonThemeData(
              backgroundColor: themeLight.colorScheme.primaryFixedDim,
              foregroundColor: themeLight.colorScheme.onPrimaryFixed,
            );

    const cupertinoTitleColor = CupertinoDynamicColor.withBrightness(
      color: Color(0xFF000000),
      darkColor: Color(0xFFF5F5F5),
    );

    final lightCupertino = CupertinoThemeData(
      primaryColor: themeLight.colorScheme.primary,
      primaryContrastingColor: themeLight.colorScheme.onPrimary,
      brightness: Brightness.light,
      scaffoldBackgroundColor: themeLight.scaffoldBackgroundColor,
      barBackgroundColor: themeLight.appBarTheme.backgroundColor?.withValues(
        alpha: isTablet ? 1.0 : 0.9,
      ),
      textTheme: const CupertinoThemeData().textTheme.copyWith(
        primaryColor: themeLight.colorScheme.primary,
        textStyle: const CupertinoThemeData().textTheme.textStyle.copyWith(
          color: themeLight.colorScheme.onSurface,
        ),
        navTitleTextStyle: const CupertinoThemeData().textTheme.navTitleTextStyle.copyWith(
          color: cupertinoTitleColor,
        ),
        navLargeTitleTextStyle: const CupertinoThemeData().textTheme.navLargeTitleTextStyle
            .copyWith(color: cupertinoTitleColor),
      ),
    );

    final darkCupertino = CupertinoThemeData(
      primaryColor: themeDark.colorScheme.primaryFixed,
      primaryContrastingColor: themeDark.colorScheme.onPrimaryFixed,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: themeDark.scaffoldBackgroundColor,
      barBackgroundColor: themeDark.appBarTheme.backgroundColor?.withValues(
        alpha: isTablet ? 1.0 : 0.9,
      ),
      textTheme: const CupertinoThemeData().textTheme.copyWith(
        primaryColor: themeDark.colorScheme.primaryFixed,
        textStyle: const CupertinoThemeData().textTheme.textStyle.copyWith(
          color: themeDark.colorScheme.onSurface,
        ),
        navTitleTextStyle: const CupertinoThemeData().textTheme.navTitleTextStyle.copyWith(
          color: cupertinoTitleColor,
        ),
        navLargeTitleTextStyle: const CupertinoThemeData().textTheme.navLargeTitleTextStyle
            .copyWith(color: cupertinoTitleColor),
      ),
    );

    // The high blend theme is used only for the navigation bar in light mode.
    final highBlendThemeLight = FlexThemeData.light(
      colors: flexScheme.light,
      surfaceMode: FlexSurfaceMode.highBackgroundLowScaffold,
      blendLevel: 20,
    );

    const iosMenuTheme = MenuThemeData(
      style: MenuStyle(
        elevation: WidgetStatePropertyAll(0),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: kCardBorderRadius)),
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: FlexColorScheme.themedSystemNavigationBar(
        context,
        systemNavBarStyle: FlexSystemNavBarStyle.transparent,
      ),
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: kSupportedLocales,
        onGenerateTitle: (BuildContext context) => 'lichess.org',
        locale: generalPrefs.locale,
        theme: themeLight.copyWith(
          cupertinoOverrideTheme: lightCupertino,
          splashFactory: isIOS ? NoSplash.splashFactory : null,
          textTheme: isIOS ? Typography.blackCupertino : null,
          listTileTheme: ListTileTheme.of(context).copyWith(
            titleTextStyle: isIOS ? lightCupertino.textTheme.textStyle : null,
            subtitleTextStyle: isIOS ? lightCupertino.textTheme.textStyle : null,
            leadingAndTrailingTextStyle: isIOS ? lightCupertino.textTheme.textStyle : null,
          ),
          menuTheme: isIOS ? iosMenuTheme : null,
          floatingActionButtonTheme: floatingActionButtonTheme,
          navigationBarTheme: NavigationBarTheme.of(context).copyWith(
            height: remainingHeight < kSmallRemainingHeightLeftBoardThreshold ? 60 : null,
            backgroundColor: highBlendThemeLight.colorScheme.surface,
            indicatorColor: darken(highBlendThemeLight.colorScheme.secondaryContainer, 0.05),
            elevation: 3,
          ),
          extensions: [lichessCustomColors.harmonized(themeLight.colorScheme)],
        ),
        darkTheme: themeDark.copyWith(
          cupertinoOverrideTheme: darkCupertino,
          splashFactory: isIOS ? NoSplash.splashFactory : null,
          textTheme: isIOS ? Typography.whiteCupertino : null,
          listTileTheme: ListTileTheme.of(context).copyWith(
            titleTextStyle: isIOS ? darkCupertino.textTheme.textStyle : null,
            subtitleTextStyle: isIOS ? darkCupertino.textTheme.textStyle : null,
            leadingAndTrailingTextStyle: isIOS ? darkCupertino.textTheme.textStyle : null,
          ),
          menuTheme: isIOS ? iosMenuTheme : null,
          floatingActionButtonTheme: floatingActionButtonTheme,
          navigationBarTheme: NavigationBarTheme.of(context).copyWith(
            height: remainingHeight < kSmallRemainingHeightLeftBoardThreshold ? 60 : null,
            backgroundColor: themeDark.colorScheme.surface,
          ),
          extensions: [lichessCustomColors.harmonized(themeDark.colorScheme)],
        ),
        themeMode: switch (generalPrefs.themeMode) {
          BackgroundThemeMode.light => ThemeMode.light,
          BackgroundThemeMode.dark => ThemeMode.dark,
          BackgroundThemeMode.system => ThemeMode.system,
        },
        builder:
            isIOS
                ? (context, child) => IconTheme.merge(
                  data: IconThemeData(color: CupertinoTheme.of(context).textTheme.textStyle.color),
                  child: DefaultTextStyle.merge(
                    style: CupertinoTheme.of(context).textTheme.textStyle,
                    child: Material(color: Colors.transparent, child: child),
                  ),
                )
                : null,
        home: const BottomNavScaffold(),
        navigatorObservers: [rootNavPageRouteObserver],
      ),
    );
  }
}
