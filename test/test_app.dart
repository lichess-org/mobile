import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tuple/tuple.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    hide Tuple2;
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:soundpool/soundpool.dart';
import 'package:sqflite/sqflite.dart';

import 'package:lichess_mobile/src/crashlytics.dart';
import 'package:lichess_mobile/src/app_dependencies.dart';
import 'package:lichess_mobile/src/db/shared_preferences.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';
import 'package:lichess_mobile/src/model/auth/session_storage.dart';
import 'package:lichess_mobile/src/model/auth/user_session.dart';
import './common/fake_sound_service.dart';
import './model/auth/fake_auth_repository.dart';
import './model/auth/fake_session_storage.dart';
import './fake_crashlytics.dart';

class MockSoundPool extends Mock implements Soundpool {}

class MockDatabase extends Mock implements Database {}

// iPhone 14 screen size
const double _kTestScreenWidth = 390.0;
const double _kTestScreenHeight = 844.0;
const kTestSurfaceSize = Size(_kTestScreenWidth, _kTestScreenHeight);

Future<Widget> buildTestApp(
  WidgetTester tester, {
  required Widget home,
  List<Override>? overrides,
  UserSession? userSession,
}) async {
  await tester.binding.setSurfaceSize(kTestSurfaceSize);
  SharedPreferences.setMockInitialValues({});
  final sharedPreferences = await SharedPreferences.getInstance();

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
      crashlyticsProvider.overrideWithValue(FakeCrashlytics()),
      // ignore: scoped_providers_should_specify_dependencies
      soundServiceProvider.overrideWithValue(FakeSoundService()),
      // ignore: scoped_providers_should_specify_dependencies
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      // ignore: scoped_providers_should_specify_dependencies
      authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
      // ignore: scoped_providers_should_specify_dependencies
      sessionStorageProvider.overrideWithValue(FakeSessionStorage(userSession)),
      // ignore: scoped_providers_should_specify_dependencies
      appDependenciesProvider.overrideWith((ref) {
        return AppDependencies(
          packageInfo: PackageInfo(
            appName: 'lichess_mobile_test',
            version: 'test',
            buildNumber: '0.0.0',
            packageName: 'lichess_mobile_test',
          ),
          sharedPreferences: sharedPreferences,
          soundPool: Tuple2(MockSoundPool(), IMap<Sound, int>(const {})),
          userSession: userSession,
          database: MockDatabase(),
        );
      }),
      ...overrides ?? [],
    ],
    // simplified version of class [App] in lib/src/app.dart
    child: Consumer(
      builder: (context, ref, child) {
        return MediaQuery(
          data: const MediaQueryData(size: kTestSurfaceSize),
          child: Center(
            child: SizedBox(
              width: _kTestScreenWidth,
              height: _kTestScreenHeight,
              child: MaterialApp(
                useInheritedMediaQuery: true,
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
