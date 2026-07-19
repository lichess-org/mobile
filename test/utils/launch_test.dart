import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/utils/launch.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  test('launchPatronPage opens the patron page externally', () async {
    Uri? launchedUri;
    LaunchMode? launchMode;

    expect(
      await launchPatronPage(
        launcher: (uri, mode) async {
          launchedUri = uri;
          launchMode = mode;
          return true;
        },
      ),
      true,
    );
    expect(launchedUri, Uri.parse('https://lichess.org/patron'));
    expect(launchMode, LaunchMode.externalApplication);
  });
}
