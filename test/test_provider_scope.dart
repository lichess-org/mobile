import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override, ProviderOrFamily;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/opening_service.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_storage.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/network/aggregator.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:visibility_detector/visibility_detector.dart';

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

final offlineClient = MockClient((request) {
  throw const SocketException('No internet');
});

/// Returns a [MaterialApp] wrapped in a [ProviderScope] and default mocks, ready for testing.
///
/// The [home] widget is the widget we want to test. Typically a screen widget, to
/// perform end-to-end tests.
/// It will be wrapped in a [MaterialApp] to simulate a simple app.
///
/// The [overrides] parameter can be used to override any provider in the app.
/// The [authUser] parameter can be used to set the initial user authUser state.
/// The [defaultPreferences] parameter can be used to set the initial shared preferences.
Future<Widget> makeTestProviderScopeApp(
  WidgetTester tester, {
  required Widget home,
  Map<ProviderOrFamily, Override>? overrides,
  AuthUser? authUser,
  Map<String, Object>? defaultPreferences,
}) {
  return makeTestProviderScope(
    tester,
    child: _FakeApp(home: home),
    overrides: overrides,
    authUser: authUser,
    defaultPreferences: defaultPreferences,
  );
}

class _FakeApp extends ConsumerStatefulWidget {
  const _FakeApp({required this.home});

  final Widget home;

  @override
  ConsumerState<_FakeApp> createState() => _FakeAppState();
}

class _FakeAppState extends ConsumerState<_FakeApp> {
  @override
  void initState() {
    final socketClient = ref.read(socketPoolProvider).currentClient;
    socketClient.connect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: widget.home,
    );
  }
}

/// Wraps [makeTestProviderScope] with a [FakeHttpClientFactory] that returns an offline client.
///
/// This is useful to test the app in offline mode.
Future<Widget> makeOfflineTestProviderScope(
  WidgetTester tester, {
  required Widget child,
  Map<ProviderOrFamily, Override>? overrides,
  AuthUser? authUser,
  Map<String, Object>? defaultPreferences,
}) => makeTestProviderScope(
  tester,
  child: child,
  overrides: {
    httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
      return FakeHttpClientFactory(() => offlineClient);
    }),
    ...?overrides,
  },
  authUser: authUser,
  defaultPreferences: defaultPreferences,
);

/// Returns a [ProviderScope] and default mocks, ready for testing.
///
/// The [child] widget is the widget we want to test. It will be wrapped in a
/// [MediaQuery.new] widget, to simulate a device with a specific size, controlled
/// by [surfaceSize] (which default to [kTestSurfaceSize]).
///
/// The [overrides] parameter can be used to override any provider in the app.
/// The [authUser] parameter can be used to set the initial user authUser state.
/// The [defaultPreferences] parameter can be used to set the initial shared preferences.
Future<Widget> makeTestProviderScope(
  WidgetTester tester, {
  required Widget child,
  Map<ProviderOrFamily, Override>? overrides,
  AuthUser? authUser,
  Map<String, Object>? defaultPreferences,
  Size surfaceSize = kTestSurfaceSize,
  Key? key,
}) async {
  final binding = TestLichessBinding.ensureInitialized();

  addTearDown(binding.reset);

  await tester.binding.setSurfaceSize(surfaceSize);
  addTearDown(() {
    tester.binding.setSurfaceSize(null);
  });

  VisibilityDetectorController.instance.updateInterval = Duration.zero;

  final defaultTestPrefs = {
    // disable piece animation to simplify tests
    PrefCategory.board.storageKey: jsonEncode(
      BoardPrefs.defaults.copyWith(pieceAnimation: false).toJson(),
    ),
  };

  await binding.setInitialSharedPreferencesValues(
    defaultPreferences != null ? {...defaultTestPrefs, ...defaultPreferences} : defaultTestPrefs,
  );

  FlutterSecureStorage.setMockInitialValues({
    kSRIStorageKey: 'test',
    if (authUser != null) kAuthStorageKey: jsonEncode(authUser.toJson()),
  });

  final flutterTestOnError = FlutterError.onError!;

  void ignoreOverflowErrors(FlutterErrorDetails details) {
    bool isOverflowError = false;
    final exception = details.exception;

    if (exception is FlutterError) {
      isOverflowError = exception.diagnostics.any(
        (e) => e.value.toString().contains('A RenderFlex overflowed by'),
      );
    }

    if (isOverflowError) {
      // debugPrint('Overflow error detected.');
    } else {
      flutterTestOnError(details);
    }
  }

  // TODO consider loading true fonts as well
  FlutterError.onError = ignoreOverflowErrors;

  final Map<ProviderOrFamily, Override> overrideMap = {
    notificationDisplayProvider: notificationDisplayProvider.overrideWith((ref) {
      return FakeNotificationDisplay();
    }),
    databaseProvider: databaseProvider.overrideWith((ref) async {
      final testDb = await openAppDatabase(databaseFactoryFfiNoIsolate, inMemoryDatabasePath);
      ref.onDispose(testDb.close);
      return testDb;
    }),
    httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
      return FakeHttpClientFactory(() => mockClient);
    }),
    aggregatorProvider: aggregatorProvider.overrideWith((ref) {
      // Use a zero aggregation interval to disable aggregation for tests.
      return Aggregator(ref.watch(lichessClientProvider), aggregationInterval: Duration.zero);
    }),
    webSocketChannelFactoryProvider: webSocketChannelFactoryProvider.overrideWith((ref) {
      return defaultFakeWebSocketChannelFactory;
    }),
    socketPoolProvider: socketPoolProvider.overrideWith((ref) {
      final pool = SocketPool(ref);
      ref.onDispose(pool.dispose);
      return pool;
    }),
    connectivityPluginProvider: connectivityPluginProvider.overrideWith((_) => FakeConnectivity()),
    showRatingsPrefProvider: showRatingsPrefProvider.overrideWith((ref) => ShowRatings.yes),
    soundServiceProvider: soundServiceProvider.overrideWithValue(FakeSoundService()),
    openingServiceProvider: openingServiceProvider.overrideWithValue(FakeOpeningService()),
    preloadedDataProvider: preloadedDataProvider.overrideWith((ref) {
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
        authUser: authUser,
        engineMaxMemoryInMb: 256,
        appDocumentsDirectory: null,
        appSupportDirectory: null,
      );
    }),
    ...?overrides,
  };

  return ProviderScope(
    key: key,
    overrides: overrideMap.values.toList(),
    child: TestSurface(size: surfaceSize, child: child),
  );
}
