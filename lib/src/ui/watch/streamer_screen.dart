import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/tv/streamer.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/common/lichess_colors.dart';
import 'package:lichess_mobile/src/common/social_icons.dart';

class StreamerScreen extends StatelessWidget {
  const StreamerScreen({required this.streamers});

  final IList<Streamer> streamers;

  @override
  Widget build(BuildContext build) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Streamers'),
      ),
      body: ListView(
        children: streamers
            .map((e) => StreamerListTile(streamer: e))
            .toList(growable: false),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: 'Lichess TV',
        middle: Text('Live Streamers'),
      ),
      child: CustomScrollView(
        slivers: [
          SliverSafeArea(
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                CupertinoListSection(
                  children: streamers
                      .map((e) => StreamerListTile(streamer: e))
                      .toList(),
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class StreamerListTile extends StatelessWidget {
  const StreamerListTile({required this.streamer});

  final Streamer streamer;

  @override
  Widget build(BuildContext context) {
    return PlatformListTile(
      leading: Image.network(streamer.image),
      title: Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: Row(
          children: [
            if (streamer.title != null) ...[
              Text(
                streamer.title!,
                style: const TextStyle(
                  color: LichessColors.brag,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 5)
            ],
            Text(streamer.username, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
      subtitle:
          Text(streamer.streamerHeadline, overflow: TextOverflow.ellipsis),
      trailing: Column(
        children: [
          if (streamer.streamService == 'twitch') ...{
            const Icon(SocialIcons.twitch)
          } else ...{
            const Icon(SocialIcons.youtube)
          },
          Text(streamer.lang),
        ],
      ),
    );
  }
}
