import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/user/streamer.dart';
import 'package:lichess_mobile/src/styles/social_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:url_launcher/url_launcher.dart';

class StreamerScreen extends StatelessWidget {
  const StreamerScreen({required this.streamers});

  final IList<Streamer> streamers;

  static Route<dynamic> buildRoute(BuildContext context, IList<Streamer> streamers) {
    return buildScreenRoute(
      context,
      title: context.l10n.mobileLiveStreamers,
      screen: StreamerScreen(streamers: streamers),
    );
  }

  @override
  Widget build(BuildContext build) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.listingsScreenBackgroundColor(context),
      appBar: AppBar(title: Text(context.l10n.mobileLiveStreamers)),
      body: ListView.builder(
        itemCount: streamers.length,
        itemBuilder:
            (context, index) => StreamerListTile(
              thumbnailSize: 75.0,
              streamer: streamers[index],
              isPreview: false,
              maxSubtitleLines: 4,
            ),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Styles.listingsScreenBackgroundColor(context),
      navigationBar: CupertinoNavigationBar(middle: Text(context.l10n.mobileLiveStreamers)),
      child: CustomScrollView(
        slivers: [
          SliverSafeArea(
            sliver: SliverList.separated(
              separatorBuilder:
                  (context, index) => const PlatformDivider(height: 1, indent: 75.0 + 16.0 + 10.0),
              itemCount: streamers.length,
              itemBuilder:
                  (context, index) => StreamerListTile(
                    thumbnailSize: 75.0,
                    streamer: streamers[index],
                    isPreview: false,
                    maxSubtitleLines: 4,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class StreamerListTile extends StatelessWidget {
  const StreamerListTile({
    required this.streamer,
    this.maxSubtitleLines = 1,
    this.thumbnailSize = 50.0,
    this.isPreview = true,
  });

  final Streamer streamer;
  final int maxSubtitleLines;
  final double thumbnailSize;

  /// Whether to return a more compact version of the tile.
  final bool isPreview;

  @override
  Widget build(BuildContext context) {
    final codes = streamer.lang.split('-');
    final locale = Locale(codes[0], codes.length > 1 ? codes[1] : null);

    Future<void> onTap() async {
      final url = streamer.platform == 'twitch' ? streamer.twitch : streamer.youTube;
      if (!await launchUrl(Uri.parse(url!), mode: LaunchMode.externalApplication)) {
        debugPrint('ERROR: [StreamerWidget] Could not launch $url');
      }
    }

    final leading = Image.network(
      streamer.image,
      width: thumbnailSize,
      height: thumbnailSize,
      fit: BoxFit.cover,
    );

    final title = Row(
      children: [
        if (streamer.title != null) ...[
          Text(
            streamer.title!,
            style: TextStyle(color: context.lichessColors.brag, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 5),
        ],
        Flexible(child: Text(streamer.username, overflow: TextOverflow.ellipsis)),
      ],
    );

    final subtitle = Text(streamer.status, maxLines: maxSubtitleLines);

    final trailing = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (streamer.platform == 'twitch') ...{
          const Icon(SocialIcons.twitch),
        } else ...{
          const Icon(SocialIcons.youtube),
        },
        if (streamer.lang.isNotEmpty) Text(locale.languageCode.toUpperCase()),
      ],
    );

    return isPreview
        ? PlatformListTile(
          padding:
              Theme.of(context).platform == TargetPlatform.iOS
                  ? const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0)
                  : null,
          onTap: onTap,
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
        )
        : AdaptiveInkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                leading,
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle.merge(
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        child: title,
                      ),
                      subtitle,
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                trailing,
              ],
            ),
          ),
        );
  }
}
