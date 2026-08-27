import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override, ProviderOrFamily;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/engine/engine_factory.dart';
import 'package:lichess_mobile/src/model/engine/nnue_service.dart';
import 'package:lichess_mobile/src/model/engine/thinking_time.dart';
import 'package:lichess_mobile/src/model/engine/weights_service.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import './model/common/service/fake_sound_service.dart';
import 'binding.dart';
import 'model/engine/fake_engine.dart';
import 'model/engine/fake_nnue_service.dart';
import 'model/engine/fake_weights_service.dart';
import 'model/notifications/fake_notification_display.dart';
import 'network/fake_http_client_factory.dart';
import 'network/fake_websocket_channel.dart';
import 'utils/fake_connectivity.dart';

/// A mock client that always returns a 200 empty response.
final testContainerMockClient = MockClient((request) async {
  return http.Response('', 200);
});

/// Returns a [ProviderContainer] with the [httpClientFactoryProvider] configured
/// with the given [mockClient].
Future<ProviderContainer> lichessClientContainer(MockClient mockClient) {
  return makeContainer(
    overrides: {
      httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
        return FakeHttpClientFactory(() => mockClient);
      }),
    },
  );
}

/// Returns a [ProviderContainer] with default mocks, ready for testing.
Future<ProviderContainer> makeContainer({
  Map<ProviderOrFamily, Override>? overrides,
  AuthUser? authUser,
}) async {
  final binding = TestLichessBinding.ensureInitialized();

  FlutterSecureStorage.setMockInitialValues({kSRIStorageKey: 'test'});

  final Map<ProviderOrFamily, Override> overrideMap = {
    nnueServiceProvider: nnueServiceProvider.overrideWithValue(FakeNnueService()),
    // Neither the disk nor the asset bundle is involved: a fake hands out paths for networks it
    // pretends to have, and a test that cares configures its own.
    maiaWeightsServiceProvider: maiaWeightsServiceProvider.overrideWithValue(
      FakeMaiaWeightsService(),
    ),
    // Otherwise every engine move in the suite would wait out a human-looking think.
    thinkingTimeProvider: thinkingTimeProvider.overrideWithValue(const ThinkingTime.instant()),
    // Every engine in tests is a [FakeEngine] over a fake transport: no plugin, no isolates, and
    // nothing process-wide to reset. Read lazily so a test can configure [fakeEngine] right up to
    // the moment it makes its container.
    engineFactoryProvider: engineFactoryProvider.overrideWith(
      (ref) => EngineFactory(connect: (spec) => fakeEngine.connect(spec)),
    ),
    connectivityPluginProvider: connectivityPluginProvider.overrideWith((_) {
      return FakeConnectivity();
    }),
    notificationDisplayProvider: notificationDisplayProvider.overrideWith((ref) {
      return FakeNotificationDisplay();
    }),
    databaseProvider: databaseProvider.overrideWith((ref) async {
      final db = await openAppDatabase(databaseFactoryFfi, inMemoryDatabasePath);
      ref.onDispose(db.close);
      return db;
    }),
    webSocketChannelFactoryProvider: webSocketChannelFactoryProvider.overrideWith((ref) {
      return defaultFakeWebSocketChannelFactory;
    }),
    socketPoolProvider: socketPoolProvider.overrideWith((ref) {
      final pool = SocketPool(ref);
      ref.onDispose(pool.dispose);
      return pool;
    }),
    httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
      return FakeHttpClientFactory(() => testContainerMockClient);
    }),
    soundServiceProvider: soundServiceProvider.overrideWithValue(FakeSoundService()),
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

  final container = ProviderContainer(
    // Use the same retry policy as the app, so tests see production behaviour.
    retry: lichessProviderRetry,
    overrides: overrideMap.values.toList(),
  );

  addTearDown(binding.reset);
  addTearDown(container.dispose);

  return container;
}
