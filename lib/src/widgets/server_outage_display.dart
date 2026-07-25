import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/network/server_status.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:url_launcher/url_launcher.dart';

/// Message shown in place of the content that needs the lichess server, when
/// that server is unavailable.
///
/// Like the website, which serves a different page in each case, this
/// distinguishes planned maintenance from an outage.
///
/// This is laid out as a plain column so it can either be embedded among other
/// widgets, as on the home tab where offline content is kept around it, or fill
/// a whole screen.
class ServerOutageDisplay extends ConsumerWidget {
  const ServerOutageDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logo = isDark ? 'assets/images/logo-white.webp' : 'assets/images/logo-black.webp';
    final mastodonLogo = isDark
        ? 'assets/images/mastodon-logo-purple.webp'
        : 'assets/images/mastodon-logo-black.webp';
    final discordLogo = isDark
        ? 'assets/images/discord-logo-white.webp'
        : 'assets/images/discord-logo-black.webp';

    final isMaintenance = ref.watch(serverStatusProvider) == ServerStatus.maintenance;
    // The drawing is a solid picture that would sit awkwardly on top of a background image, so it
    // is only shown over a plain background.
    final hasBackgroundImage = ref.watch(
      generalPreferencesProvider.select((prefs) => prefs.backgroundImage != null),
    );
    final textStyle = Theme.of(context).textTheme.bodyLarge;

    return Padding(
      padding: Styles.bodyPadding,
      child: Column(
        mainAxisAlignment: .center,
        children: [
          if (isMaintenance || hasBackgroundImage)
            Image.asset(logo, width: 150)
          else ...[
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: switch (getScreenType(context)) {
                  ScreenType.tablet => 460.0,
                  ScreenType.desktop => 560.0,
                  _ => double.infinity,
                },
              ),
              child: Image.asset('assets/images/maintenance.webp'),
            ),
            TextButton(
              onPressed: () => launchUrl(Uri.parse(kMaintenanceDrawingAuthorUrl)),
              child: Text('Drawing by Gia', style: Theme.of(context).textTheme.bodySmall),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            isMaintenance
                ? 'Lichess is undergoing scheduled maintenance. We expect to be back very soon.'
                : 'Lichess is down. We expect to be back very soon. Thanks for your patience.',
            textAlign: TextAlign.center,
            style: textStyle,
          ),
          const SizedBox(height: 16),
          Text(
            'To get updates, follow us on social media.',
            textAlign: TextAlign.center,
            style: textStyle,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: .center,
            children: [
              IconButton(
                icon: Image.asset(mastodonLogo, width: 32),
                tooltip: 'Mastodon',
                onPressed: () => launchUrl(Uri.parse(kLichessMastodonUrl)),
              ),
              IconButton(
                icon: Image.asset('assets/images/bluesky-logo.webp', width: 32),
                tooltip: 'Bluesky',
                onPressed: () => launchUrl(Uri.parse(kLichessBlueskyUrl)),
              ),
              IconButton(
                icon: Image.asset(discordLogo, width: 32),
                tooltip: 'Discord',
                onPressed: () => launchUrl(Uri.parse(kLichessDiscordUrl)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
