import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/utils/system.dart';

/// Records a sign-in failure as a non-fatal error in Crashlytics, enriched with the browser, OS and
/// device that produced it, so failure-prone OS/browser combos can be identified from the reports.
///
/// [cancelled] is `true` when AppAuth reported a user cancellation. The broken-redirect failure
/// modes (unverified App Links, "open links in apps = never", OEMs that drop the redirect) are
/// indistinguishable from a genuine cancellation at the API level, so cancellations are recorded
/// too — tagged with the `auth_cancelled` key so they can be filtered in/out in the console.
///
/// This never throws: telemetry must not interfere with the sign-in flow.
Future<void> reportSignInFailure(
  Ref ref,
  Object error,
  StackTrace stack, {
  required bool cancelled,
}) async {
  try {
    final crashlytics = LichessBinding.instance.firebaseCrashlytics;

    // AppAuth's own error classification (type/code/oauth-error). See FlutterAppAuthPlatformErrorDetails.
    final details = switch (error) {
      FlutterAppAuthUserCancelledException(:final platformErrorDetails) => platformErrorDetails,
      FlutterAppAuthPlatformException(:final platformErrorDetails) => platformErrorDetails,
      _ => null,
    };

    final browser = await System.instance.getDefaultBrowser();
    final preloadedData = ref.read(preloadedDataProvider).value;
    final deviceInfo = preloadedData?.deviceInfo;

    final (osName, osVersion, deviceModel) = switch (deviceInfo) {
      final AndroidDeviceInfo d => ('Android', d.version.release, d.model),
      final IosDeviceInfo d => ('iOS', d.systemVersion, d.utsname.machine),
      _ => (Platform.operatingSystem, null, null),
    };

    await crashlytics.setCustomKey('auth_cancelled', cancelled);
    await crashlytics.setCustomKey('auth_error_type', details?.type ?? 'unknown');
    await crashlytics.setCustomKey('auth_error_code', details?.code ?? 'unknown');
    await crashlytics.setCustomKey('auth_oauth_error', details?.error ?? 'none');
    await crashlytics.setCustomKey('browser_package', browser?.package ?? 'unknown');
    await crashlytics.setCustomKey('browser_version', browser?.version ?? 'unknown');
    await crashlytics.setCustomKey('os', osName);
    await crashlytics.setCustomKey('os_version', osVersion ?? 'unknown');
    await crashlytics.setCustomKey('device_model', deviceModel ?? 'unknown');
    await crashlytics.setCustomKey('app_version', preloadedData?.packageInfo.version ?? 'unknown');

    await crashlytics.recordError(
      error,
      stack,
      reason:
          'Sign-in failed '
          '(browser: ${browser?.package ?? 'unknown'}/${browser?.version ?? '?'}, '
          'os: $osName/${osVersion ?? '?'}, cancelled: $cancelled)',
      fatal: false,
    );
  } catch (e) {
    debugPrint('Failed to report sign-in failure: $e');
  }
}
