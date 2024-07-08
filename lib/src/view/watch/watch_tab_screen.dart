import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/tv/featured_player.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';
import 'package:lichess_mobile/src/model/tv/tv_game.dart';
import 'package:lichess_mobile/src/model/tv/tv_repository.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_tile.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_tournament_screen.dart';
import 'package:lichess_mobile/src/view/watch/live_tv_channels_screen.dart';
import 'package:lichess_mobile/src/view/watch/streamer_screen.dart';
import 'package:lichess_mobile/src/view/watch/tv_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'watch_tab_screen.g.dart';

const _featuredChannelsSet = ISetConst({
  TvChannel.best,
  TvChannel.bullet,
  TvChannel.blitz,
  TvChannel.rapid,
});

@riverpod
Future<IList<TvGameSnapshot>> featuredChannels(FeaturedChannelsRef ref) async {
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
}

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
                        children: const [
                          _BroadcastWidget(),
                          _WatchTvWidget(),
                          _StreamerWidget(),
                        ],
                      )
                    : GridView(
                        controller: watchScrollController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.92,
                        ),
                        children: const [
                          _BroadcastWidget(),
                          _WatchTvWidget(),
                          _StreamerWidget(),
                        ],
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
                          const [
                            _BroadcastWidget(),
                            _WatchTvWidget(),
                            _StreamerWidget(),
                          ],
                        ),
                      )
                    : SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.92,
                        ),
                        delegate: SliverChildListDelegate(
                          const [
                            _BroadcastWidget(),
                            _WatchTvWidget(),
                            _StreamerWidget(),
                          ],
                        ),
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
    ref.refresh(broadcastsListProvider.future),
    ref.refresh(featuredChannelsProvider.future),
    ref.refresh(liveStreamersProvider.future),
  ]);
}

class _BroadcastWidget extends ConsumerWidget {
  const _BroadcastWidget();

  static const int numberOfItems = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: show widget when broadcasts feature is ready
    return const SizedBox.shrink();

    // ignore: dead_code
    final broadcastList = ref.watch(broadcastsListProvider);

    return broadcastList.when(
      data: (data) {
        return ListSection(
          header: Text(context.l10n.broadcastBroadcasts),
          hasLeading: true,
          headerTrailing: NoPaddingTextButton(
            onPressed: () {
              pushPlatformRoute(
                context,
                builder: (context) => const BroadcastTournamentScreen(),
              );
            },
            child: Text(
              context.l10n.more,
            ),
          ),
          children: [
            ...CombinedIterableView([data.active, data.upcoming, data.past])
                .take(numberOfItems)
                .map((broadcast) => BroadcastTile(broadcast: broadcast)),
          ],
        );
      },
      error: (error, stackTrace) {
        debugPrint(
          'SEVERE: [BroadcastWidget] could not load broadcast data; $error\n $stackTrace',
        );
        return Padding(
          padding: Styles.bodySectionPadding,
          child: const Text('Could not load broadcasts'),
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

class _WatchTvWidget extends ConsumerWidget {
  const _WatchTvWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredChannels = ref.watch(featuredChannelsProvider);

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
        return Padding(
          padding: Styles.bodySectionPadding,
          child: const Text('Could not load TV channels'),
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
  const _StreamerWidget();

  static const int numberOfItems = 10;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamerState = ref.watch(liveStreamersProvider);

    return streamerState.when(
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
        return Padding(
          padding: Styles.bodySectionPadding,
          child: const Text('Could not load live streamers'),
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
