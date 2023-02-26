import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/common/shared_preferences.dart';
import 'package:lichess_mobile/src/common/sound_service.dart';
import 'package:lichess_mobile/src/common/package_info.dart';
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';
import 'package:lichess_mobile/src/model/auth/session_storage.dart';
import './common/fake_sound_service.dart';
import './model/auth/fake_auth_repository.dart';
import './model/auth/fake_session_storage.dart';

Future<ProviderContainer> makeContainer({
  List<Override>? overrides,
}) async {
  SharedPreferences.setMockInitialValues({});
  final sharedPreferences = await SharedPreferences.getInstance();

  Logger.root.onRecord.listen((record) {
    if (record.level > Level.WARNING) {
      final time = DateFormat.Hms().format(record.time);
      debugPrint(
        '${record.level.name} at $time [${record.loggerName}] ${record.message}${record.error != null ? '\n${record.error}' : ''}',
      );
    }
  });

  final container = ProviderContainer(
    overrides: [
      soundServiceProvider.overrideWithValue(FakeSoundService()),
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
      sessionStorageProvider.overrideWithValue(FakeSessionStorage()),
      packageInfoProvider.overrideWith((ref) {
        return PackageInfo(
          appName: 'lichess_mobile_test',
          version: 'test',
          buildNumber: '0.0.0',
          packageName: 'lichess_mobile_test',
        );
      }),
      ...overrides ?? [],
    ],
  );
  addTearDown(container.dispose);
  return container;
}
