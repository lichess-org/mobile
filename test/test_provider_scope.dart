import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/crashlytics.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/init.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/auth/session_storage.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/utils/connectivity.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:visibility_detector/visibility_detector.dart';

import './fake_crashlytics.dart';
import './model/common/service/fake_sound_service.dart';
import 'binding.dart';
import 'model/common/fake_websocket_channel.dart';
import 'model/notifications/fake_notification_display.dart';
import 'test_helpers.dart';
import 'utils/fake_connectivity.dart';

final mockClient = MockClient((request) async {
  return http.Response('', 200);
});

/// Returns a [MaterialApp] wrapped with a [ProviderScope] and default mocks, ready for testing.
///
/// The [home] widget is the widget we want to test. It is wrapped in a [MediaQuery]
/// and [MaterialApp] widgets to simulate a simple app.
///
/// The [overrides] parameter can be used to override any provider in the app.
/// The [userSession] parameter can be used to set the initial user session state.
/// The [defaultPreferences] parameter can be used to set the initial shared preferences.
Future<Widget> makeProviderScopeApp(
  WidgetTester tester, {
  required Widget home,
  List<Override>? overrides,
  AuthSessionState? userSession,
  Map<String, Object>? defaultPreferences,
}) async {
  final binding = TestLichessBinding.ensureInitialized();

  addTearDown(binding.reset);

  await tester.binding.setSurfaceSize(kTestSurfaceSize);

  VisibilityDetectorController.instance.updateInterval = Duration.zero;

  SharedPreferences.setMockInitialValues(
    defaultPreferences ??
        {
          // disable piece animation to simplify tests
          'preferences.board': jsonEncode(
            BoardPrefs.defaults
                .copyWith(
                  pieceAnimation: false,
                )
                .toJson(),
          ),
        },
  );

  final sharedPreferences = await SharedPreferences.getInstance();

  FlutterSecureStorage.setMockInitialValues({
    kSRIStorageKey: 'test',
    if (userSession != null)
      kSessionStorageKey: jsonEncode(userSession.toJson()),
  });

  // TODO consider loading true fonts as well
  FlutterError.onError = _ignoreOverflowErrors;

  Logger.root.onRecord.listen((record) {
    if (record.level > Level.WARNING) {
      final time = DateFormat.Hms().format(record.time);
      debugPrint(
        '${record.level.name} at $time [${record.loggerName}] ${record.message}${record.error != null ? '\n${record.error}' : ''}',
      );
    }
  });

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
      lichessClientProvider.overrideWith((ref) {
        return LichessClient(mockClient, ref);
      }),
      // ignore: scoped_providers_should_specify_dependencies
      defaultClientProvider.overrideWith((_) => mockClient),
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
      cachedDataProvider.overrideWith((ref) {
        return CachedData(
          packageInfo: PackageInfo(
            appName: 'lichess_mobile_test',
            version: 'test',
            buildNumber: '0.0.0',
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
          sharedPreferences: sharedPreferences,
          initialUserSession: userSession,
          sri: 'test',
          engineMaxMemoryInMb: 16,
        );
      }),
      ...overrides ?? [],
    ],
    child: Consumer(
      builder: (context, ref, child) {
        return MediaQuery(
          data: const MediaQueryData(size: kTestSurfaceSize),
          child: Center(
            child: SizedBox(
              width: kTestSurfaceSize.width,
              height: kTestSurfaceSize.height,
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
            ),
          ),
        );
      },
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
