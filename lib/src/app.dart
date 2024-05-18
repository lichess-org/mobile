import 'dart:async';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/main.dart';
import 'package:lichess_mobile/src/app_dependencies.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_service.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/brightness.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/notification_service.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/connectivity.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/game/standalone_game_screen.dart';

class LoadingAppScreen extends ConsumerWidget {
  const LoadingAppScreen({super.key});

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
      data: (_) => const Application(),
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

class Application extends ConsumerStatefulWidget {
  const Application({super.key});

  @override
  ConsumerState<Application> createState() => _AppState();
}

class _AppState extends ConsumerState<Application> {
  bool _correspondenceSynced = false;

  @override
  void initState() {
    if (Theme.of(context).platform == TargetPlatform.android) {
      setOptimalDisplayMode();
    }

    ref.listenManual(connectivityProvider, (prev, current) async {
      // Play registered moves whenever the app comes back online.
      if (prev?.hasValue == true &&
          !prev!.value!.isOnline &&
          !current.isRefreshing &&
          current.hasValue &&
          current.value!.isOnline) {
        final nbMovesPlayed =
            await ref.read(correspondenceServiceProvider).playRegisteredMoves();
        if (nbMovesPlayed > 0) {
          ref.invalidate(ongoingGamesProvider);
        }
      }

      if (current.value?.isOnline == true && !_correspondenceSynced) {
        _correspondenceSynced = true;
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
  Widget build(BuildContext context) {
    final themeMode = ref.watch(
      generalPreferencesProvider.select(
        (state) => state.themeMode,
      ),
    );
    final brightness = ref.watch(currentBrightnessProvider);
    final boardTheme = ref.watch(
      boardPreferencesProvider.select((state) => state.boardTheme),
    );
    final hasSystemColors = ref.watch(
      generalPreferencesProvider.select((state) => state.systemColors),
    );

    final remainingHeight = estimateRemainingHeightLeftBoard(context);

    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        // TODO remove this workaround when the dynamic_color colorScheme bug is fixed
        // See: https://github.com/material-foundation/flutter-packages/issues/574
        final (
          fixedLightScheme,
          fixedDarkScheme
        ) = lightColorScheme != null && darkColorScheme != null
            ? _generateDynamicColourSchemes(lightColorScheme, darkColorScheme)
            : (null, null);

        final dynamicColorScheme =
            brightness == Brightness.light ? fixedLightScheme : fixedDarkScheme;

        final colorScheme = hasSystemColors && dynamicColorScheme != null
            ? dynamicColorScheme
            : ColorScheme.fromSeed(
                seedColor: boardTheme.colors.darkSquare,
                brightness: brightness,
              );

        final cupertinoThemeData = CupertinoThemeData(
          primaryColor: colorScheme.primary,
          primaryContrastingColor: colorScheme.onPrimary,
          brightness: brightness,
          textTheme: CupertinoTheme.of(context).textTheme.copyWith(
                primaryColor: colorScheme.primary,
                textStyle: CupertinoTheme.of(context)
                    .textTheme
                    .textStyle
                    .copyWith(color: Styles.cupertinoLabelColor),
                navTitleTextStyle: CupertinoTheme.of(context)
                    .textTheme
                    .navTitleTextStyle
                    .copyWith(color: Styles.cupertinoTitleColor),
                navLargeTitleTextStyle: CupertinoTheme.of(context)
                    .textTheme
                    .navLargeTitleTextStyle
                    .copyWith(color: Styles.cupertinoTitleColor),
              ),
          scaffoldBackgroundColor: Styles.cupertinoScaffoldColor,
          barBackgroundColor: Styles.cupertinoAppBarColor,
        );

        return MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: kSupportedLocales,
          onGenerateTitle: (BuildContext context) => 'lichess.org',
          theme: ThemeData.from(
            colorScheme: colorScheme,
            textTheme: Theme.of(context).platform == TargetPlatform.iOS
                ? brightness == Brightness.light
                    ? Typography.blackCupertino
                    : Styles.whiteCupertinoTextTheme
                : null,
          ).copyWith(
            cupertinoOverrideTheme: cupertinoThemeData,
            navigationBarTheme: NavigationBarTheme.of(context).copyWith(
              height: remainingHeight < kSmallRemainingHeightLeftBoardThreshold
                  ? 60
                  : null,
            ),
            extensions: [lichessCustomColors.harmonized(colorScheme)],
          ),
          themeMode: themeMode,
          builder: Theme.of(context).platform == TargetPlatform.iOS
              ? (context, child) {
                  return CupertinoTheme(
                    data: cupertinoThemeData,
                    child: IconTheme(
                      // This is needed to avoid the icon color being overridden by the cupertino theme
                      data: IconTheme.of(context),
                      child: Material(child: child),
                    ),
                  );
                }
              : null,
          home: const _EntryPointWidget(),
          navigatorObservers: [
            rootNavPageRouteObserver,
          ],
        );
      },
    );
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

class _EntryPointWidget extends ConsumerStatefulWidget {
  const _EntryPointWidget();

  @override
  ConsumerState<_EntryPointWidget> createState() => _EntryPointState();
}

class _EntryPointState extends ConsumerState<_EntryPointWidget> {
  StreamSubscription<String>? _fcmTokenRefreshSubscription;

  @override
  Widget build(BuildContext context) {
    return const BottomNavScaffold();
  }

  @override
  void initState() {
    super.initState();

    _setupPushNotifications();
  }

  @override
  void dispose() {
    _fcmTokenRefreshSubscription?.cancel();
    super.dispose();
  }

  Future<void> _setupPushNotifications() async {
    // Listen for incoming messages while the app is in the foreground.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      ref.read(notificationServiceProvider).processDataMessage(message);
    });

    // Listen for incoming messages while the app is in the background.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Request permission to receive notifications. Pop-up will appear only
    // once.
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    // Listen for token refresh and update the token on the server accordingly.
    _fcmTokenRefreshSubscription =
        FirebaseMessaging.instance.onTokenRefresh.listen((String token) {
      ref.read(notificationServiceProvider).registerToken(token);
    });

    // Register the device with the server.
    ref.read(notificationServiceProvider).registerDevice();

    // Get any messages which caused the application to open from
    // a terminated state.
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  /// Handle a message that caused the application to open
  ///
  /// This method must be part of a State object which is a child of [MaterialApp]
  /// otherwise the [Navigator] will not be accessible.
  void _handleMessage(RemoteMessage message) {
    switch (message.data['lichess.type']) {
      // correspondence game message types
      case 'corresAlarm':
      case 'gameTakebackOffer':
      case 'gameDrawOffer':
      case 'gameMove':
      case 'gameFinish':
        final gameFullId = message.data['lichess.fullId'] as String?;
        if (gameFullId != null) {
          // remove any existing routes before navigating to the game
          // screen to avoid stacking multiple game screens
          final navState = Navigator.of(context);
          if (navState.canPop()) {
            navState.popUntil((route) => route.isFirst);
          }
          pushPlatformRoute(
            context,
            rootNavigator: true,
            builder: (_) => StandaloneGameScreen(
              params: InitialStandaloneGameParams(
                id: GameFullId(gameFullId),
              ),
            ),
          );
        }
    }
  }
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

  final lightScheme =
      _insertAdditionalColours(lightBase, lightAdditionalColours);
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

ColorScheme _insertAdditionalColours(
  ColorScheme scheme,
  List<Color> additionalColours,
) =>
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
