import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lichess_mobile/src/common/shared_preferences.dart';
import 'package:lichess_mobile/src/common/sound_service.dart';
import 'package:lichess_mobile/src/common/package_info.dart';
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';
import 'package:lichess_mobile/src/model/auth/session_repository.dart';
import 'package:lichess_mobile/src/model/settings/providers.dart';
import './common/fake_sound_service.dart';
import './model/auth/fake_auth_repository.dart';
import './model/auth/fake_session_repository.dart';

// iPhone 14 screen size
const double _kTestScreenWidth = 390.0;
const double _kTestScreenHeight = 844.0;
const kTestSurfaceSize = Size(_kTestScreenWidth, _kTestScreenHeight);

Future<Widget> buildTestApp(
  WidgetTester tester, {
  required Widget home,
  List<Override>? overrides,
}) async {
  await tester.binding.setSurfaceSize(kTestSurfaceSize);
  SharedPreferences.setMockInitialValues({});
  final sharedPreferences = await SharedPreferences.getInstance();

  // TODO consider loading true fonts as well
  FlutterError.onError = _ignoreOverflowErrors;

  return ProviderScope(
    overrides: [
      soundServiceProvider.overrideWithValue(FakeSoundService()),
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
      sessionRepositoryProvider.overrideWithValue(FakeSessionRepository()),
      currentBrightnessProvider.overrideWithValue(Brightness.dark),
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
