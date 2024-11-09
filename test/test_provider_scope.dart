import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/crashlytics.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/opening_service.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/auth/session_storage.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:visibility_detector/visibility_detector.dart';

import './fake_crashlytics.dart';
import './model/common/service/fake_sound_service.dart';
import 'binding.dart';
import 'model/analysis/fake_opening_service.dart';
import 'model/notifications/fake_notification_display.dart';
import 'network/fake_http_client_factory.dart';
import 'network/fake_websocket_channel.dart';
import 'test_helpers.dart';
import 'utils/fake_connectivity.dart';

final mockClient = MockClient((request) async {
  return http.Response('', 200);
});

final offlineClient = MockClient((request) async {
  throw const SocketException('No internet');
});

/// Returns a [MaterialApp] wrapped in a [ProviderScope] and default mocks, ready for testing.
///
/// The [home] widget is the widget we want to test. Typically a screen widget, to
/// perform end-to-end tests.
/// It will be wrapped in a [MaterialApp] to simulate a simple app.
///
/// The [overrides] parameter can be used to override any provider in the app.
/// The [userSession] parameter can be used to set the initial user session state.
/// The [defaultPreferences] parameter can be used to set the initial shared preferences.
Future<Widget> makeTestProviderScopeApp(
  WidgetTester tester, {
  required Widget home,
  List<Override>? overrides,
  AuthSessionState? userSession,
  Map<String, Object>? defaultPreferences,
}) async {
  return makeTestProviderScope(
    tester,
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: home,
      builder: (context, child) {
        return CupertinoTheme(
          data: const CupertinoThemeData(),
          child: Material(child: child),
        );
      },
    ),
    overrides: overrides,
    userSession: userSession,
    defaultPreferences: defaultPreferences,
  );
}

/// Wraps [makeTestProviderScope] with a [FakeHttpClientFactory] that returns an offline client.
///
/// This is useful to test the app in offline mode.
Future<Widget> makeOfflineTestProviderScope(
  WidgetTester tester, {
  required Widget child,
  List<Override>? overrides,
  AuthSessionState? userSession,
  Map<String, Object>? defaultPreferences,
}) =>
    makeTestProviderScope(
      tester,
      child: child,
      overrides: [
        httpClientFactoryProvider.overrideWith((ref) {
          return FakeHttpClientFactory(() => offlineClient);
        }),
        ...overrides ?? [],
      ],
      userSession: userSession,
      defaultPreferences: defaultPreferences,
    );

/// Returns a [ProviderScope] and default mocks, ready for testing.
///
/// The [child] widget is the widget we want to test. It will be wrapped in a
/// [MediaQuery.new] widget, to simulate a device with a specific size, controlled
/// by [kTestSurfaceSize].
///
/// The [overrides] parameter can be used to override any provider in the app.
/// The [userSession] parameter can be used to set the initial user session state.
/// The [defaultPreferences] parameter can be used to set the initial shared preferences.
Future<Widget> makeTestProviderScope(
  WidgetTester tester, {
  required Widget child,
  List<Override>? overrides,
  AuthSessionState? userSession,
  Map<String, Object>? defaultPreferences,
}) async {
  final binding = TestLichessBinding.ensureInitialized();

  addTearDown(binding.reset);

  await tester.binding.setSurfaceSize(kTestSurfaceSize);

  VisibilityDetectorController.instance.updateInterval = Duration.zero;

  // disable piece animation to simplify tests
  final defaultBoardPref = {
    'preferences.board': jsonEncode(
      BoardPrefs.defaults
          .copyWith(
            pieceAnimation: false,
          )
          .toJson(),
    ),
  };

  await binding.setInitialSharedPreferencesValues(
    defaultPreferences != null
        ? {
            ...defaultBoardPref,
            ...defaultPreferences,
          }
        : defaultBoardPref,
  );

  FlutterSecureStorage.setMockInitialValues({
    kSRIStorageKey: 'test',
    if (userSession != null)
      kSessionStorageKey: jsonEncode(userSession.toJson()),
  });

  // TODO consider loading true fonts as well
  FlutterError.onError = _ignoreOverflowErrors;

  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      notificationDisplayProvider.overrideWith((ref) {
        return FakeNotificationDisplay();
      }),
      // ignore: scoped_providers_should_specify_dependencies
      databaseProvider.overrideWith((ref) async {
        final testDb = await openAppDatabase(
          databaseFactoryFfiNoIsolate,
          inMemoryDatabasePath,
        );
        ref.onDispose(testDb.close);
        return testDb;
      }),
      // ignore: scoped_providers_should_specify_dependencies
      httpClientFactoryProvider.overrideWith((ref) {
        return FakeHttpClientFactory(() => mockClient);
      }),
      // ignore: scoped_providers_should_specify_dependencies
      webSocketChannelFactoryProvider.overrideWith((ref) {
        return FakeWebSocketChannelFactory(() => FakeWebSocketChannel());
      }),
      // ignore: scoped_providers_should_specify_dependencies
      socketPoolProvider.overrideWith((ref) {
        final pool = SocketPool(ref);
        ref.onDispose(pool.dispose);
        return pool;
      }),
      // ignore: scoped_providers_should_specify_dependencies
      connectivityPluginProvider.overrideWith((_) => FakeConnectivity()),
      // ignore: scoped_providers_should_specify_dependencies
      showRatingsPrefProvider.overrideWith((ref) => true),
      // ignore: scoped_providers_should_specify_dependencies
      crashlyticsProvider.overrideWithValue(FakeCrashlytics()),
      // ignore: scoped_providers_should_specify_dependencies
      soundServiceProvider.overrideWithValue(FakeSoundService()),
      // ignore: scoped_providers_should_specify_dependencies
      openingServiceProvider.overrideWithValue(FakeOpeningService()),
      // ignore: scoped_providers_should_specify_dependencies
      preloadedDataProvider.overrideWith((ref) {
        return (
          sri: 'test-sri',
          packageInfo: PackageInfo(
            appName: 'lichess_mobile_test',
            version: '0.0.0',
            buildNumber: '0',
            packageName: 'lichess_mobile_test',
          ),
          deviceInfo: BaseDeviceInfo({
            'name': 'test',
            'model': 'test',
            'manufacturer': 'test',
            'systemName': 'test',
            'systemVersion': 'test',
            'identifierForVendor': 'test',
            'isPhysicalDevice': true,
          }),
          userSession: userSession,
          engineMaxMemoryInMb: 256,
        );
      }),
      ...overrides ?? [],
    ],
    child: MediaQuery(
      data: const MediaQueryData(size: kTestSurfaceSize),
      child: Center(
        child: SizedBox(
          width: kTestSurfaceSize.width,
          height: kTestSurfaceSize.height,
          child: child,
        ),
      ),
    ),
  );
}

void _ignoreOverflowErrors(
  FlutterErrorDetails details, {
  bool forceReport = false,
}) {
  bool isOverflowError = false;
  final exception = details.exception;

  if (exception is FlutterError) {
    isOverflowError = exception.diagnostics
        .any((e) => e.value.toString().contains('A RenderFlex overflowed by'));
  }

  if (isOverflowError) {
    // debugPrint('Overflow error detected.');
  } else {
    FlutterError.dumpErrorToConsole(details, forceReport: forceReport);
    throw exception;
  }
}
