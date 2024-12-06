import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/tv/featured_player.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';
import 'package:lichess_mobile/src/model/tv/tv_game.dart';
import 'package:lichess_mobile/src/model/tv/tv_repository.dart';
import 'package:lichess_mobile/src/model/user/streamer.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_list_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_round_screen.dart';
import 'package:lichess_mobile/src/view/watch/live_tv_channels_screen.dart';
import 'package:lichess_mobile/src/view/watch/streamer_screen.dart';
import 'package:lichess_mobile/src/view/watch/tv_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

const _featuredChannelsSet = ISetConst({
  TvChannel.best,
  TvChannel.bullet,
  TvChannel.blitz,
  TvChannel.rapid,
});

final featuredChannelsProvider =
    FutureProvider.autoDispose<IList<TvGameSnapshot>>((ref) async {
  return ref.withClientCacheFor(
    (client) async {
      final channels = await TvRepository(client).channels();
      return channels.entries
          .where((channel) => _featuredChannelsSet.contains(channel.key))
          .map(
            (entry) => TvGameSnapshot(
              channel: entry.key,
              id: entry.value.id,
              orientation: entry.value.side ?? Side.white,
              player: FeaturedPlayer(
                name: entry.value.user.name,
                title: entry.value.user.title,
                side: entry.value.side ?? Side.white,
                rating: entry.value.rating,
              ),
            ),
          )
          .toIList();
    },
    const Duration(minutes: 5),
  );
});

class WatchTabScreen extends ConsumerStatefulWidget {
  const WatchTabScreen({super.key});

  @override
  _WatchScreenState createState() => _WatchScreenState();
}

class _WatchScreenState extends ConsumerState<WatchTabScreen> {
  final _androidRefreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    ref.listen<BottomTab>(currentBottomTabProvider, (prev, current) {
      if (prev != BottomTab.watch && current == BottomTab.watch) {
        refreshData();
      }
    });

    return ConsumerPlatformWidget(
      ref: ref,
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  List<Widget> watchTabWidgets(WidgetRef ref) {
    final broadcastList = ref.watch(broadcastsPaginatorProvider);
    final featuredChannels = ref.watch(featuredChannelsProvider);
    final streamers = ref.watch(liveStreamersProvider);

    return [
      _BroadcastWidget(broadcastList),
      _WatchTvWidget(featuredChannels),
      _StreamerWidget(streamers),
    ];
  }

  Widget _buildAndroid(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) {
        if (!didPop) {
          ref.read(currentBottomTabProvider.notifier).state = BottomTab.home;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.watch),
        ),
        body: RefreshIndicator(
          key: _androidRefreshKey,
          onRefresh: refreshData,
          child: SafeArea(
            child: OrientationBuilder(
              builder: (context, orientation) {
                return orientation == Orientation.portrait
                    ? ListView(
                        controller: watchScrollController,
                        children: watchTabWidgets(ref),
                      )
                    : GridView(
                        controller: watchScrollController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.92,
                        ),
                        children: watchTabWidgets(ref),
                      );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIos(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      child: OrientationBuilder(
        builder: (context, orientation) {
          return CustomScrollView(
            controller: watchScrollController,
            slivers: [
              const CupertinoSliverNavigationBar(
                padding: EdgeInsetsDirectional.only(
                  start: 16.0,
                  end: 8.0,
                ),
              ),
              CupertinoSliverRefreshControl(
                onRefresh: refreshData,
              ),
              SliverSafeArea(
                top: false,
                sliver: orientation == Orientation.portrait
                    ? SliverList(
                        delegate: SliverChildListDelegate(
                          watchTabWidgets(ref),
                        ),
                      )
                    : SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.92,
                        ),
                        delegate: SliverChildListDelegate(watchTabWidgets(ref)),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> refreshData() => _refreshData(ref);
}

Future<void> _refreshData(WidgetRef ref) {
  return Future.wait([
    ref.refresh(broadcastsPaginatorProvider.future),
    ref.refresh(featuredChannelsProvider.future),
    ref.refresh(liveStreamersProvider.future),
  ]);
}

class _BroadcastWidget extends ConsumerWidget {
  final AsyncValue<BroadcastList> broadcastList;

  const _BroadcastWidget(this.broadcastList);

  static const int numberOfItems = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return broadcastList.when(
      data: (data) {
        return ListSection(
          header: Text(context.l10n.broadcastBroadcasts),
          headerTrailing: NoPaddingTextButton(
            onPressed: () {
              pushPlatformRoute(
                context,
                builder: (context) => const BroadcastListScreen(),
              );
            },
            child: Text(
              context.l10n.more,
            ),
          ),
          children: [
            ...CombinedIterableView([data.active, data.upcoming, data.past])
                .take(numberOfItems)
                .map((broadcast) => _BroadcastTile(broadcast: broadcast)),
          ],
        );
      },
      error: (error, stackTrace) {
        debugPrint(
          'SEVERE: [BroadcastWidget] could not load broadcast data; $error\n $stackTrace',
        );
        return const Padding(
          padding: Styles.bodySectionPadding,
          child: Text('Could not load broadcasts'),
        );
      },
      loading: () => Shimmer(
        child: ShimmerLoading(
          isLoading: true,
          child: ListSection.loading(
            itemsNumber: numberOfItems,
            header: true,
          ),
        ),
      ),
    );
  }
}

class _BroadcastTile extends ConsumerWidget {
  const _BroadcastTile({
    required this.broadcast,
  });

  final Broadcast broadcast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformListTile(
      onTap: () {
        pushPlatformRoute(
          context,
          title: context.l10n.broadcastBroadcasts,
          rootNavigator: true,
          builder: (context) => BroadcastRoundScreen(broadcast: broadcast),
        );
      },
      title: Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: Row(
          children: [
            Flexible(
              child: Text(
                broadcast.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      trailing: (broadcast.isLive)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.circle,
                  color: context.lichessColors.error,
                  size: 20,
                ),
                const SizedBox(height: 5),
                Text(
                  'LIVE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: context.lichessColors.error,
                  ),
                ),
              ],
            )
          : null,
    );
  }
}

class _WatchTvWidget extends ConsumerWidget {
  final AsyncValue<IList<TvGameSnapshot>> featuredChannels;

  const _WatchTvWidget(this.featuredChannels);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return featuredChannels.when(
      data: (data) {
        if (data.isEmpty) {
          return const SizedBox.shrink();
        }
        return ListSection(
          header: const Text('Lichess TV'),
          hasLeading: true,
          headerTrailing: NoPaddingTextButton(
            onPressed: () => pushPlatformRoute(
              context,
              builder: (context) => const LiveTvChannelsScreen(),
            ).then((_) => _refreshData(ref)),
            child: Text(
              context.l10n.more,
            ),
          ),
          children: data.map((snapshot) {
            return PlatformListTile(
              leading: Icon(snapshot.channel.icon),
              title: Text(snapshot.channel.label),
              subtitle: UserFullNameWidget.player(
                user: snapshot.player.asPlayer.user,
                aiLevel: snapshot.player.asPlayer.aiLevel,
                rating: snapshot.player.rating,
              ),
              onTap: () => pushPlatformRoute(
                context,
                rootNavigator: true,
                builder: (context) => TvScreen(channel: snapshot.channel),
              ).then((_) => _refreshData(ref)),
            );
          }).toList(growable: false),
        );
      },
      error: (error, stackTrace) {
        debugPrint(
          'SEVERE: [StreamerWidget] could not load channels data; $error\n $stackTrace',
        );
        return const Padding(
          padding: Styles.bodySectionPadding,
          child: Text('Could not load TV channels'),
        );
      },
      loading: () => Shimmer(
        child: ShimmerLoading(
          isLoading: true,
          child: ListSection.loading(
            itemsNumber: 4,
            header: true,
          ),
        ),
      ),
    );
  }
}

class _StreamerWidget extends ConsumerWidget {
  final AsyncValue<IList<Streamer>> streamers;

  const _StreamerWidget(this.streamers);

  static const int numberOfItems = 10;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return streamers.when(
      data: (data) {
        if (data.isEmpty) {
          return const SizedBox.shrink();
        }
        return ListSection(
          header: Text(context.l10n.streamerLichessStreamers),
          hasLeading: true,
          headerTrailing: NoPaddingTextButton(
            onPressed: () => pushPlatformRoute(
              context,
              builder: (context) => StreamerScreen(streamers: data),
            ),
            child: Text(
              context.l10n.more,
            ),
          ),
          children: [
            ...data
                .take(numberOfItems)
                .map((e) => StreamerListTile(streamer: e, showSubtitle: true)),
          ],
        );
      },
      error: (error, stackTrace) {
        debugPrint(
          'SEVERE: [StreamerWidget] could not load streamer data; $error\n $stackTrace',
        );
        return const Padding(
          padding: Styles.bodySectionPadding,
          child: Text('Could not load live streamers'),
        );
      },
      loading: () => Shimmer(
        child: ShimmerLoading(
          isLoading: true,
          child: ListSection.loading(
            itemsNumber: numberOfItems,
            header: true,
          ),
        ),
      ),
    );
  }
}
