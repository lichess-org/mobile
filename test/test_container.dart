import 'package:device_info_plus/device_info_plus.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/app_dependencies.dart';
import 'package:lichess_mobile/src/crashlytics.dart';
import 'package:lichess_mobile/src/db/shared_preferences.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/auth/session_storage.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/notification_service.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';
import 'package:sqflite/sqflite.dart';

import './fake_crashlytics.dart';
import './model/auth/fake_session_storage.dart';
import './model/common/service/fake_sound_service.dart';
import 'fake_notification_service.dart';

class MockSoundPool extends Mock implements Soundpool {}

class MockDatabase extends Mock implements Database {}

class MockHttpClient extends Mock implements http.Client {}

const shouldLog = false;

class FakeClientFactory implements HttpClientFactory {
  @override
  http.Client call() {
    return MockHttpClient();
  }
}

Future<ProviderContainer> makeContainer({
  List<Override>? overrides,
  AuthSessionState? userSession,
}) async {
  SharedPreferences.setMockInitialValues({});
  final sharedPreferences = await SharedPreferences.getInstance();

  FlutterSecureStorage.setMockInitialValues({
    kSRIStorageKey: 'test',
  });

  Logger.root.onRecord.listen((record) {
    if (shouldLog && record.level >= Level.FINE) {
      final time = DateFormat.Hms().format(record.time);
      debugPrint(
        '${record.level.name} at $time [${record.loggerName}] ${record.message}${record.error != null ? '\n${record.error}' : ''}',
      );
    }
  });

  final container = ProviderContainer(
    overrides: [
      httpClientFactoryProvider.overrideWithValue(FakeClientFactory()),
      crashlyticsProvider.overrideWithValue(FakeCrashlytics()),
      notificationServiceProvider.overrideWithValue(FakeNotificationService()),
      soundServiceProvider.overrideWithValue(FakeSoundService()),
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      sessionStorageProvider.overrideWithValue(FakeSessionStorage()),
      appDependenciesProvider.overrideWith((ref) {
        return AppDependencies(
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
          soundPool: (MockSoundPool(), IMap<Sound, int>(const {})),
          userSession: userSession,
          database: MockDatabase(),
          sri: 'test',
          engineMaxMemoryInMb: 16,
        );
      }),
      ...overrides ?? [],
    ],
  );

  addTearDown(container.dispose);

  return container;
}
