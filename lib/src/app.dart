import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/app_links.dart';
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
import 'package:lichess_mobile/src/theme.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
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
    final (light: themeLight, dark: themeDark) = ref.watch(applicationThemeProvider);

    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final remainingHeight = estimateRemainingHeightLeftBoard(context);

    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: kSupportedLocales,
      onGenerateTitle: (BuildContext context) => 'lichess.org',
      locale: generalPrefs.locale,
      theme: themeLight.copyWith(
        navigationBarTheme: NavigationBarTheme.of(
          context,
        ).copyWith(height: remainingHeight < kSmallRemainingHeightLeftBoardThreshold ? 60 : null),
      ),
      darkTheme: themeDark.copyWith(
        navigationBarTheme: NavigationBarTheme.of(
          context,
        ).copyWith(height: remainingHeight < kSmallRemainingHeightLeftBoardThreshold ? 60 : null),
        extensions: [lichessCustomColors.harmonized(themeDark.colorScheme)],
      ),
      themeMode:
          generalPrefs.isForcedDarkMode
              ? ThemeMode.dark
              : switch (generalPrefs.themeMode) {
                BackgroundThemeMode.light => ThemeMode.light,
                BackgroundThemeMode.dark => ThemeMode.dark,
                BackgroundThemeMode.system => ThemeMode.system,
              },
      builder:
          isIOS
              ? (context, child) => IconTheme.merge(
                data: IconThemeData(color: CupertinoTheme.of(context).textTheme.textStyle.color),
                child: Material(color: Colors.transparent, child: child),
              )
              : null,
      onGenerateRoute:
          (settings) =>
              settings.name != null ? resolveAppLinkUri(context, Uri.parse(settings.name!)) : null,
      onGenerateInitialRoutes: (initialRoute) {
        final homeRoute = buildScreenRoute<void>(context, screen: const BottomNavScaffold());
        return <Route<dynamic>?>[
          homeRoute,
          resolveAppLinkUri(context, Uri.parse(initialRoute)),
        ].nonNulls.toList(growable: false);
      },
      navigatorObservers: [rootNavPageRouteObserver],
    );
  }
}
