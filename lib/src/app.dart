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
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
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
    final boardTheme = ref.watch(boardPreferencesProvider.select((state) => state.boardTheme));
    final isTablet = isTabletOrLarger(context);
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final remainingHeight = estimateRemainingHeightLeftBoard(context);

    final flexScheme = generalPrefs.appTheme.getFlexScheme(boardTheme);
    final flexSchemeLightColors = flexScheme.light;
    final flexSchemeDarkColors = flexScheme.dark;

    final lightTheme = FlexThemeData.light(
      colors: flexSchemeLightColors,
      cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
      appBarStyle: isIOS ? null : FlexAppBarStyle.scaffoldBackground,
      blendLevel: 6,
    );
    final darkTheme = FlexThemeData.dark(
      colors: flexSchemeDarkColors,
      surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
      blendLevel: 12,
      cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
      appBarStyle: isIOS ? null : FlexAppBarStyle.scaffoldBackground,
    );

    final lightCupertinoTheme = CupertinoThemeData(
      primaryColor: lightTheme.colorScheme.primary,
      primaryContrastingColor: lightTheme.colorScheme.onPrimary,
      brightness: Brightness.light,
      textTheme: CupertinoTheme.of(context).textTheme.copyWith(
        primaryColor: lightTheme.colorScheme.primary,
        textStyle: CupertinoTheme.of(
          context,
        ).textTheme.textStyle.copyWith(color: lightTheme.colorScheme.onSurface),
        navTitleTextStyle: CupertinoTheme.of(
          context,
        ).textTheme.navTitleTextStyle.copyWith(color: Styles.cupertinoTitleColor),
        navLargeTitleTextStyle: CupertinoTheme.of(
          context,
        ).textTheme.navLargeTitleTextStyle.copyWith(color: Styles.cupertinoTitleColor),
      ),
      scaffoldBackgroundColor: lightTheme.scaffoldBackgroundColor,
      barBackgroundColor: lightTheme.appBarTheme.backgroundColor?.withValues(
        alpha: isTablet ? 1.0 : 0.9,
      ),
      applyThemeToAll: true,
    );

    final darkCupertinoTheme = CupertinoThemeData(
      primaryColor: darkTheme.colorScheme.primary,
      primaryContrastingColor: darkTheme.colorScheme.onPrimary,
      brightness: Brightness.dark,
      textTheme: CupertinoTheme.of(context).textTheme.copyWith(
        primaryColor: darkTheme.colorScheme.primary,
        textStyle: CupertinoTheme.of(
          context,
        ).textTheme.textStyle.copyWith(color: darkTheme.colorScheme.onSurface),
        navTitleTextStyle: CupertinoTheme.of(
          context,
        ).textTheme.navTitleTextStyle.copyWith(color: Styles.cupertinoTitleColor),
        navLargeTitleTextStyle: CupertinoTheme.of(
          context,
        ).textTheme.navLargeTitleTextStyle.copyWith(color: Styles.cupertinoTitleColor),
      ),
      scaffoldBackgroundColor: darkTheme.scaffoldBackgroundColor,
      barBackgroundColor: darkTheme.appBarTheme.backgroundColor?.withValues(
        alpha: isTablet ? 1.0 : 0.9,
      ),
      applyThemeToAll: true,
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
        theme: lightTheme.copyWith(
          cupertinoOverrideTheme: lightCupertinoTheme,
          splashFactory: isIOS ? NoSplash.splashFactory : null,
          textTheme: isIOS ? Typography.blackCupertino : null,
          listTileTheme: ListTileTheme.of(context).copyWith(
            titleTextStyle: isIOS ? lightCupertinoTheme.textTheme.textStyle : null,
            subtitleTextStyle: isIOS ? lightCupertinoTheme.textTheme.textStyle : null,
            leadingAndTrailingTextStyle: isIOS ? lightCupertinoTheme.textTheme.textStyle : null,
          ),
          navigationBarTheme: NavigationBarTheme.of(
            context,
          ).copyWith(height: remainingHeight < kSmallRemainingHeightLeftBoardThreshold ? 60 : null),
          extensions: [lichessCustomColors.harmonized(lightTheme.colorScheme)],
        ),
        darkTheme: darkTheme.copyWith(
          cupertinoOverrideTheme: darkCupertinoTheme,
          splashFactory: isIOS ? NoSplash.splashFactory : null,
          textTheme: isIOS ? Typography.whiteCupertino : null,
          listTileTheme: ListTileTheme.of(context).copyWith(
            titleTextStyle: isIOS ? darkCupertinoTheme.textTheme.textStyle : null,
            subtitleTextStyle: isIOS ? darkCupertinoTheme.textTheme.textStyle : null,
            leadingAndTrailingTextStyle: isIOS ? darkCupertinoTheme.textTheme.textStyle : null,
          ),
          navigationBarTheme: NavigationBarTheme.of(
            context,
          ).copyWith(height: remainingHeight < kSmallRemainingHeightLeftBoardThreshold ? 60 : null),
          extensions: [lichessCustomColors.harmonized(darkTheme.colorScheme)],
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
      ),
    );
  }
}
