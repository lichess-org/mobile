import 'dart:convert';

import 'package:dynamic_system_colors/dynamic_system_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/db/secure_storage.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/notifications/notifications.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/utils/chessboard.dart';
import 'package:lichess_mobile/src/utils/color_palette.dart';
import 'package:lichess_mobile/src/utils/orientation_mode.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:logging/logging.dart';
import 'package:material_color_utilities/palettes/core_palette.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';

final _logger = Logger('Init');

/// Run initialization tasks only once on first app launch or after an update.
Future<void> setupFirstLaunch() async {
  final prefs = LichessBinding.instance.sharedPreferences;
  final pInfo = await PackageInfo.fromPlatform();

  final appVersion = Version.parse(pInfo.version);
  final installedVersion = prefs.getString('installed_version');

  if (installedVersion != null && Version.parse(installedVersion) < Version(0, 14, 0)) {
    // TODO remove this migration code after a few releases
    _migrateThemeSettings();
  }

  if (installedVersion == null || Version.parse(installedVersion) != appVersion) {
    prefs.setString('installed_version', appVersion.canonicalizedVersion);
  }

  if (prefs.getBool('first_run') ?? true) {
    // Clear secure storage on first run because it is not deleted on app uninstall
    await SecureStorage.instance.deleteAll();

    // Generate a socket random identifier and store it for the app lifetime
    final sri = genRandomString(12);
    _logger.info('Generated new SRI: $sri');
    await SecureStorage.instance.write(key: kSRIStorageKey, value: sri);

    // on android 12+ set board theme to system colors
    if (getCorePalette() != null) {
      final boardPrefs = BoardPrefs.defaults.copyWith(boardTheme: BoardTheme.system);
      await prefs.setString(PrefCategory.board.storageKey, jsonEncode(boardPrefs.toJson()));
    }

    await prefs.setBool('first_run', false);
  }
}

Future<void> _migrateThemeSettings() async {
  if (getCorePalette() == null) {
    return;
  }
  final prefs = LichessBinding.instance.sharedPreferences;
  try {
    final stored = LichessBinding.instance.sharedPreferences.getString(
      PrefCategory.general.storageKey,
    );
    if (stored == null) {
      return;
    }
    final generalPrefs = GeneralPrefs.fromJson(jsonDecode(stored) as Map<String, dynamic>);
    final migrated = generalPrefs.copyWith(
      systemColors:
          // ignore: deprecated_member_use_from_same_package
          generalPrefs.appThemeSeed == AppThemeSeed.system,
    );
    await prefs.setString(PrefCategory.general.storageKey, jsonEncode(migrated.toJson()));
  } catch (e) {
    _logger.warning('Failed to migrate theme settings: $e');
  }
}

Future<void> initializeLocalNotifications(Locale locale) async {
  final l10n = await AppLocalizations.delegate.load(locale);
  await FlutterLocalNotificationsPlugin().initialize(
    InitializationSettings(
      android: const AndroidInitializationSettings('logo_black'),
      iOS: DarwinInitializationSettings(
        requestBadgePermission: false,
        notificationCategories: <DarwinNotificationCategory>[
          ChallengeNotification.darwinPlayableVariantCategory(l10n),
          ChallengeNotification.darwinUnplayableVariantCategory(l10n),
        ],
      ),
    ),
    onDidReceiveNotificationResponse: NotificationService.onDidReceiveNotificationResponse,
    // onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );
}

Future<void> preloadPieceImages() async {
  final prefs = LichessBinding.instance.sharedPreferences;
  final storedPrefs = prefs.getString(PrefCategory.board.storageKey);
  BoardPrefs boardPrefs = BoardPrefs.defaults;
  if (storedPrefs != null) {
    try {
      boardPrefs = BoardPrefs.fromJson(jsonDecode(storedPrefs) as Map<String, dynamic>);
    } catch (e) {
      _logger.warning('Failed to decode board preferences: $e');
    }
  }

  await precachePieceImages(boardPrefs.pieceSet);
}

/// Display setup on Android.
///
/// This is meant to be called once during app initialization.
Future<void> androidDisplayInitialization(WidgetsBinding widgetsBinding) async {
  // On android 12+ set dynamic color schemes
  try {
    Future.wait([DynamicColorPlugin.getCorePalette(), DynamicColorPlugin.getColorSchemes()]).then((
      List<dynamic> value,
    ) {
      final CorePalette? palette = value[0] as CorePalette?;
      final schemes = value[1] as dynamic;
      final ColorSchemes? colorSchemes =
          schemes != null
              // ignore: avoid_dynamic_calls
              ? (light: schemes.light as ColorScheme, dark: schemes.dark as ColorScheme)
              : null;

      setSystemColors(palette, colorSchemes);
    });
  } catch (e) {
    _logger.fine('Device does not support core palette: $e');
  }

  // Sets edge-to-edge system UI mode on Android 12+
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarContrastEnforced: true,
    ),
  );

  /// Enables high refresh rate for devices where it was previously disabled
  final List<DisplayMode> supported = await FlutterDisplayMode.supported;
  final DisplayMode active = await FlutterDisplayMode.active;

  final List<DisplayMode> sameResolution =
      supported
          .where((DisplayMode m) => m.width == active.width && m.height == active.height)
          .toList()
        ..sort((DisplayMode a, DisplayMode b) => b.refreshRate.compareTo(a.refreshRate));

  final DisplayMode mostOptimalMode = sameResolution.isNotEmpty ? sameResolution.first : active;

  // This setting is per session.
  await FlutterDisplayMode.setPreferredMode(mostOptimalMode);
}

/// Sets the screen orientation based on the device form factor.
Future<void> setupOrientation(Size size) {
  if (size.shortestSide < FormFactor.tablet) {
    return OrientationMode.portraitUp.apply();
  }
  return OrientationMode.allOrientations.apply();
}
