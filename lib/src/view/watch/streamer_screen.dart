import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/user/streamer.dart';
import 'package:lichess_mobile/src/styles/social_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:url_launcher/url_launcher.dart';

class StreamerScreen extends StatelessWidget {
  const StreamerScreen({super.key, required this.streamers});

  final IList<Streamer> streamers;

  @override
  Widget build(BuildContext build) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.mobileLiveStreamers)),
      body: ListView.builder(
        itemCount: streamers.length,
        itemBuilder:
            (context, index) => StreamerListTile(
              streamer: streamers[index],
              showSubtitle: true,
              maxSubtitleLines: 4,
            ),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(context.l10n.mobileLiveStreamers)),
      child: CustomScrollView(
        slivers: [
          SliverSafeArea(
            sliver: SliverList.separated(
              separatorBuilder:
                  (context, index) => const PlatformDivider(height: 1, cupertinoHasLeading: true),
              itemCount: streamers.length,
              itemBuilder:
                  (context, index) => StreamerListTile(
                    streamer: streamers[index],
                    showSubtitle: true,
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
  const StreamerListTile({super.key, 
    required this.streamer,
    this.showSubtitle = false,
    this.maxSubtitleLines = 1,
  });

  final Streamer streamer;
  final bool showSubtitle;
  final int maxSubtitleLines;

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);

    return PlatformListTile(
      padding:
          Theme.of(context).platform == TargetPlatform.iOS
              ? const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0)
              : null,
      onTap: () async {
        final url = streamer.platform == 'twitch' ? streamer.twitch : streamer.youTube;
        if (!await launchUrl(Uri.parse(url!), mode: LaunchMode.externalApplication)) {
          debugPrint('ERROR: [StreamerWidget] Could not launch $url');
        }
      },
      leading: Padding(
        padding:
            Theme.of(context).platform == TargetPlatform.android
                ? const EdgeInsets.all(5.0)
                : EdgeInsets.zero,
        child: Image.network(
          streamer.image,
          width: 50,
          height: 50,
          cacheWidth: (50.0 * devicePixelRatio).toInt(),
          cacheHeight: (50.0 * devicePixelRatio).toInt(),
          fit: BoxFit.cover,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: Row(
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
        ),
      ),
      subtitle: showSubtitle ? Text(streamer.status, maxLines: maxSubtitleLines) : null,
      isThreeLine: showSubtitle && maxSubtitleLines >= 2,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          if (streamer.platform == 'twitch') ...{
            const Icon(SocialIcons.twitch),
          } else ...{
            const Icon(SocialIcons.youtube),
          },
          if (streamer.lang.isNotEmpty) Text(streamer.lang),
        ],
      ),
    );
  }
}
