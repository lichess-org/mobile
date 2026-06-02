import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens a Lichess web page that relies on the signed-in browser session (e.g. account settings
/// pages such as password, two-factor, close account).
///
/// On iOS the in-app `SFSafariViewController` keeps a per-app cookie store that is *not* shared with
/// the `ASWebAuthenticationSession` used at sign-in, so these pages would render logged out. Opening
/// them in the external browser (Safari) — which shares the auth session's cookie store — keeps the
/// user logged in. Android Custom Tabs already share the browser cookie jar, so the default in-app
/// behaviour is kept there.
Future<bool> launchAuthenticatedLichessUrl(Uri url) {
  return launchUrl(
    url,
    mode: defaultTargetPlatform == TargetPlatform.iOS
        ? LaunchMode.externalApplication
        : LaunchMode.platformDefault,
  );
}
