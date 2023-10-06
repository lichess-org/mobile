import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/model/tv/tv_repository.dart';
import 'package:lichess_mobile/src/model/tv/tv_game.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';
import 'package:lichess_mobile/src/model/tv/featured_player.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/view/watch/streamer_screen.dart';
import 'package:lichess_mobile/src/view/watch/tv_screen.dart';
import 'package:lichess_mobile/src/view/watch/live_tv_channels_screen.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

part 'watch_tab_screen.g.dart';

const _featuredChannelsSet = ISetConst({
  TvChannel.best,
  TvChannel.bullet,
  TvChannel.blitz,
  TvChannel.rapid,
});

@riverpod
Future<IList<TvGameSnapshot>> featuredChannels(FeaturedChannelsRef ref) async {
  final link = ref.cacheFor(const Duration(seconds: 5));
  final repo = ref.watch(tvRepositoryProvider);
  final result = await repo.channels();
  if (result.isError) {
    link.close();
  }
  return result.fold(
    (value) => value.entries
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
        .toIList(),
    (Object error, _) => throw error,
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
    return Scaffold(
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
                      children: const [_WatchTvWidget(), _StreamerWidget()],
                    )
                  : GridView(
                      controller: watchScrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.92,
                      ),
                      children: const [_WatchTvWidget(), _StreamerWidget()],
                    );
            },
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
              const CupertinoSliverNavigationBar(),
              CupertinoSliverRefreshControl(
                onRefresh: refreshData,
              ),
              SliverSafeArea(
                top: false,
                sliver: orientation == Orientation.portrait
                    ? SliverList(
                        delegate: SliverChildListDelegate(
                          const [
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
    ref.refresh(featuredChannelsProvider.future),
    ref.refresh(liveStreamersProvider.future),
  ]);
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
              subtitle: PlayerTitle(
                userName: snapshot.player.name,
                title: snapshot.player.title,
                rating: snapshot.player.rating,
              ),
              onTap: () => pushPlatformRoute(
                context,
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
                .map((e) => StreamerListTile(streamer: e)),
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
