import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/tv/streamer.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/common/lichess_colors.dart';

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth > kLargeScreenWidth
              ? GridView(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 644,
                    crossAxisCount: (constraints.maxWidth / 300).floor(),
                  ),
                  children: streamers
                      .map((e) => StreamerListTile(streamer: e))
                      .toList(growable: false),
                )
              : ListView(
                  children: streamers
                      .map((e) => StreamerListTile(streamer: e))
                      .toList(growable: false),
                );
        },
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: 'Lichess TV',
        middle: Text('Live Streamers'),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return CustomScrollView(
            slivers: [
              SliverSafeArea(
                sliver: constraints.maxWidth > kLargeScreenWidth
                    ? SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: 644,
                          crossAxisCount: (constraints.maxWidth / 300).floor(),
                        ),
                        delegate: SliverChildListDelegate(
                          streamers
                              .map((e) => StreamerListTile(streamer: e))
                              .toList(),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildListDelegate(
                          streamers
                              .map((e) => StreamerListTile(streamer: e))
                              .toList(),
                        ),
                      ),
              ),
            ],
          );
        },
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
            Flexible(
              child: Text(streamer.username, overflow: TextOverflow.ellipsis),
            )
          ],
        ),
      ),
      subtitle:
          Text(streamer.streamerHeadline, overflow: TextOverflow.ellipsis),
      trailing: Text(streamer.lang),
    );
  }
}
