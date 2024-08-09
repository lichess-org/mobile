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
import 'package:lichess_mobile/src/app_initialization.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/model/challenge/challenges.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_service.dart';
import 'package:lichess_mobile/src/model/notifications/challenge_notification.dart';
import 'package:lichess_mobile/src/model/notifications/local_notification_service.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/brightness.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/notification_service.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/connectivity.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/utils/system.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/user/challenge_requests_screen.dart';

/// Application initialization and main entry point.
class AppInitializationScreen extends ConsumerWidget {
  const AppInitializationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<AppInitializationData>>(
      appInitializationProvider,
      (_, state) {
        if (state.hasValue || state.hasError) {
          FlutterNativeSplash.remove();
        }
      },
    );

    return ref.watch(appInitializationProvider).when(
          data: (_) => const Application(),
          // loading screen is handled by the native splash screen
          loading: () => const SizedBox.shrink(),
          error: (err, st) {
            debugPrint(
              'SEVERE: [App] could not initialize app; $err\n$st',
            );
            // We should really do everything we can to avoid this screen
            // but in last resort, let's show an error message and invite the
            // user to clear app data.
            // TODO implement it on iOS
            return Theme.of(context).platform == TargetPlatform.android
                ? MaterialApp(
                    home: Scaffold(
                      body: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "Something went wrong :'(\n\nIf the problem persists, you can try to clear the storage and restart the application.\n\nSorry for the inconvenience.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              System.instance.clearUserData();
                            },
                            child: const Text('Clear storage'),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink();
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
  bool _correspondenceSynced = false;

  @override
  void initState() {
    if (Theme.of(context).platform == TargetPlatform.android) {
      setOptimalDisplayMode();
    }

    ref.read(localNotificationServiceProvider).init();

    ref.listenManual(challengesProvider, (prev, current) {
      if (prev == null || !prev.hasValue || !current.hasValue) return;
      final prevIds = prev.value!.inward.map((challenge) => challenge.id);
      final inward = current.value!.inward;
      final repo = ref.read(challengeRepositoryProvider);
      final l10n = ref.read(l10nProvider).strings;

      inward
          .where((challenge) => !prevIds.contains(challenge.id))
          .forEach((challenge) {
        ref.read(localNotificationServiceProvider).show(
              ChallengeNotification(
                challenge,
                l10n,
                onPressed: (action, id) async {
                  switch (action) {
                    case ChallengeNotificationAction
                          .accept: // accept the game and open board
                      await repo.accept(challenge.id);
                      final fullId = await repo.show(challenge.id).then(
                            (challenge) => challenge.gameFullId,
                          );
                      pushPlatformRoute(
                        ref.read(currentNavigatorKeyProvider).currentContext!,
                        rootNavigator: true,
                        builder: (BuildContext context) {
                          return GameScreen(
                            initialGameId: fullId,
                          );
                        },
                      );
                    case ChallengeNotificationAction
                          .pressed: // open the challenge screen
                      pushPlatformRoute(
                        ref.read(currentNavigatorKeyProvider).currentContext!,
                        builder: (BuildContext context) =>
                            const ChallengeRequestsScreen(),
                      );
                    case ChallengeNotificationAction.decline:
                      repo.decline(id);
                  }
                },
              ),
            );
      });
    });

    ref.listenManual(connectivityChangesProvider, (prev, current) async {
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
    final generalPrefs = ref.watch(generalPreferencesProvider);

    final brightness = ref.watch(currentBrightnessProvider);
    final boardTheme = ref.watch(
      boardPreferencesProvider.select((state) => state.boardTheme),
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

        final colorScheme =
            generalPrefs.systemColors && dynamicColorScheme != null
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
          locale: generalPrefs.locale,
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
            extensions: [
              lichessCustomColors.harmonized(colorScheme),
            ],
          ),
          themeMode: generalPrefs.themeMode,
          builder: Theme.of(context).platform == TargetPlatform.iOS
              ? (context, child) {
                  return CupertinoTheme(
                    data: cupertinoThemeData,
                    child: Material(child: child),
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

/// The entry point widget for the application.
///
/// This widget needs to be a desendant of [MaterialApp] to be able to handle
/// the [Navigator] properly.
///
/// This widget is responsible for setting up the bottom navigation scaffold and
/// the main navigation routes.
///
/// It also sets up the push notifications and handles incoming messages.
class _EntryPointWidget extends ConsumerStatefulWidget {
  const _EntryPointWidget();

  @override
  ConsumerState<_EntryPointWidget> createState() => _EntryPointState();
}

class _EntryPointState extends ConsumerState<_EntryPointWidget> {
  StreamSubscription<String>? _fcmTokenRefreshSubscription;
  ProviderSubscription<AsyncValue<ConnectivityStatus>>?
      _connectivitySubscription;

  bool _pushNotificationsSetup = false;

  @override
  Widget build(BuildContext context) {
    return const BottomNavScaffold();
  }

  @override
  void initState() {
    super.initState();

    _connectivitySubscription =
        ref.listenManual(connectivityChangesProvider, (prev, current) async {
      // setup push notifications once when the app comes online
      if (current.value?.isOnline == true && !_pushNotificationsSetup) {
        try {
          await _setupPushNotifications();
          _pushNotificationsSetup = true;
        } catch (e, st) {
          debugPrint('Could not sync correspondence games; $e\n$st');
        }
      }
    });
  }

  @override
  void dispose() {
    _fcmTokenRefreshSubscription?.cancel();
    _connectivitySubscription?.close();
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
    await ref.read(notificationServiceProvider).registerDevice();

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
            builder: (_) => GameScreen(
              initialGameId: GameFullId(gameFullId),
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
