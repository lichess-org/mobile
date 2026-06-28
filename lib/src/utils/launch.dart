import 'package:url_launcher/url_launcher.dart';

const _patronUri = 'https://lichess.org/patron';

typedef UrlLauncher = Future<bool> Function(Uri uri, LaunchMode mode);

Future<bool> launchPatronPage({UrlLauncher? launcher}) {
  return (launcher ?? _launchUrl)(Uri.parse(_patronUri), LaunchMode.externalApplication);
}

Future<bool> _launchUrl(Uri uri, LaunchMode mode) {
  return launchUrl(uri, mode: mode);
}
