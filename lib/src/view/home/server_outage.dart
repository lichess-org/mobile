import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:url_launcher/url_launcher.dart';

class ServerOutage extends ConsumerWidget {
  const ServerOutage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;
    final logo = brightness == Brightness.dark
        ? 'assets/images/logo-white.png'
        : 'assets/images/logo-black.png';
    final mastodonLogo = brightness == Brightness.dark
        ? 'assets/images/mastodon-logo-purple.png'
        : 'assets/images/mastodon-logo-black.png';
    final discordLogo = brightness == Brightness.dark
        ? 'assets/images/discord-logo-white.png'
        : 'assets/images/discord-logo-black.png';

    return SizedBox.expand(
      child: ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: Styles.bodyPadding,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(logo, width: 150),
                const SizedBox(height: 16),
                Text(context.l10n.mobileServerOutageMessage, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                Text(context.l10n.mobileServerOutageKeepInformed, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Image.asset(mastodonLogo, width: 32),
                      onPressed: () => launchUrl(Uri.parse(kLichessMastodonUrl)),
                    ),
                    IconButton(
                      icon: Image.asset('assets/images/bluesky-logo.png', width: 32),
                      onPressed: () => launchUrl(Uri.parse(kLichessBlueskyUrl)),
                    ),
                    IconButton(
                      icon: Image.asset(discordLogo, width: 32),
                      onPressed: () => launchUrl(Uri.parse(kLichessDiscordUrl)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
