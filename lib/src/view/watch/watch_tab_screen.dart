import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
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
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart';
import 'package:lichess_mobile/src/utils/image.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/account/account_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_carousel.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_list_screen.dart';
import 'package:lichess_mobile/src/view/play/play_bottom_sheet.dart';
import 'package:lichess_mobile/src/view/watch/live_tv_channels_screen.dart';
import 'package:lichess_mobile/src/view/watch/streamer_screen.dart';
import 'package:lichess_mobile/src/view/watch/tv_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

const kThumbnailImageSize = 40.0;

const _featuredChannelsSet = ISetConst({
  TvChannel.best,
  TvChannel.bullet,
  TvChannel.blitz,
  TvChannel.rapid,
  TvChannel.classical,
});

final featuredChannelsProvider = FutureProvider.autoDispose<IList<TvGameSnapshot>>((ref) {
  return ref.withClient((client) async {
    final channels = await TvRepository(client).channels();
    return _featuredChannelsSet
        .map((channel) => MapEntry(channel, channels[channel]))
        .where((entry) => entry.value != null)
        .map(
          (entry) => TvGameSnapshot(
            channel: entry.key,
            id: entry.value!.id,
            orientation: entry.value!.side ?? Side.white,
            player: FeaturedPlayer(
              name: entry.value!.user.name,
              title: entry.value!.user.title,
              side: entry.value!.side ?? Side.white,
              rating: entry.value!.rating,
            ),
          ),
        )
        .toIList();
  });
});

class WatchTabScreen extends ConsumerStatefulWidget {
  const WatchTabScreen({super.key});

  @override
  _WatchScreenState createState() => _WatchScreenState();
}

class _WatchScreenState extends ConsumerState<WatchTabScreen> {
  final _androidRefreshKey = GlobalKey<RefreshIndicatorState>();

  static const offlineWidget = Center(
    child: Text('No internet connection.', style: TextStyle(color: Colors.grey, fontSize: 20.0)),
  );

  @override
  Widget build(BuildContext context) {
    ref.listen<BottomTab>(currentBottomTabProvider, (prev, current) {
      if (prev != BottomTab.watch && current == BottomTab.watch) {
        ref.invalidate(featuredChannelsProvider);
        ref.invalidate(liveStreamersProvider);
      }
    });

    final isOnline = ref.watch(connectivityChangesProvider).valueOrNull?.isOnline ?? true;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) {
        if (!didPop) {
          ref.read(currentBottomTabProvider.notifier).state = BottomTab.home;
        }
      },
      child: PlatformScaffold(
        appBar: PlatformAppBar(leading: const AccountIconButton(), title: Text(context.l10n.watch)),
        floatingActionButton: const FloatingPlayButton(),
        body:
            isOnline
                ? OrientationBuilder(
                  builder: (context, orientation) {
                    return RefreshIndicator.adaptive(
                      edgeOffset:
                          Theme.of(context).platform == TargetPlatform.iOS
                              ? MediaQuery.paddingOf(context).top + kToolbarHeight
                              : 0.0,
                      key: _androidRefreshKey,
                      onRefresh: _refreshData,
                      child: _Body(orientation),
                    );
                  },
                )
                : offlineWidget,
      ),
    );
  }

  Future<void> _refreshData() async {
    if (!mounted) return;
    return _doRefreshDataForRef(ref);
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body(this.orientation);

  final Orientation orientation;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  ImageColorWorker? _worker;
  bool _imageAreCached = false;

  @override
  void initState() {
    super.initState();
    _precacheImages();
  }

  @override
  void dispose() {
    _worker?.close();
    super.dispose();
  }

  Future<void> _precacheImages() async {
    final worker = await ref.read(broadcastImageWorkerFactoryProvider).spawn();
    if (mounted) {
      setState(() {
        _worker = worker;
      });
    }
    ref.listenManual(broadcastsPaginatorProvider, (_, current) async {
      if (current.hasValue && !_imageAreCached) {
        _imageAreCached = true;
        await preCacheBroadcastImages(context, broadcasts: current.value!.active, worker: worker);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final broadcastList = ref.watch(broadcastsPaginatorProvider);
    final featuredChannels = ref.watch(featuredChannelsProvider);
    final streamers = ref.watch(liveStreamersProvider);

    final content = [
      if (_worker != null) _BroadcastWidget(broadcastList, _worker!),
      _WatchTvWidget(featuredChannels),
      _StreamerWidget(streamers),
    ];

    return ListView(controller: watchScrollController, children: content);
  }
}

Future<void> _doRefreshDataForRef(WidgetRef ref) {
  return Future.wait([
    ref.refresh(broadcastsPaginatorProvider.future),
    ref.refresh(featuredChannelsProvider.future),
    ref.refresh(liveStreamersProvider.future),
  ]);
}

class _BroadcastWidget extends ConsumerWidget {
  const _BroadcastWidget(this.broadcastList, this.worker);

  final AsyncValue<BroadcastList> broadcastList;
  final ImageColorWorker worker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: Styles.verticalBodyPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: Styles.horizontalBodyPadding,
            child: ListSectionHeader(
              title: Text(context.l10n.broadcastBroadcasts),
              onTap: () {
                Navigator.of(context).push(BroadcastListScreen.buildRoute(context));
              },
            ),
          ),
          switch (broadcastList) {
            AsyncData(:final value) => BroadcastCarousel(broadcasts: value, worker: worker),
            AsyncError() => const Padding(
              padding: Styles.bodySectionPadding,
              child: Text('Could not load broadcasts'),
            ),
            _ => Shimmer(
              child: ShimmerLoading(
                isLoading: true,
                child: BroadcastCarousel.loading(worker: worker),
              ),
            ),
          },
        ],
      ),
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
          onHeaderTap:
              () => Navigator.of(context).push(LiveTvChannelsScreen.buildRoute(context)).then((_) {
                if (context.mounted) {
                  _doRefreshDataForRef(ref);
                }
              }),
          children: data
              .map((snapshot) {
                return ListTile(
                  leading: Icon(snapshot.channel.icon),
                  title: Text(snapshot.channel.label),
                  subtitle: UserFullNameWidget.player(
                    user: snapshot.player.asPlayer.user,
                    aiLevel: snapshot.player.asPlayer.aiLevel,
                    rating: snapshot.player.rating,
                  ),
                  onTap:
                      () => Navigator.of(context, rootNavigator: true)
                          .push(
                            TvScreen.buildRoute(
                              context,
                              channel: snapshot.channel,
                              gameId: snapshot.id,
                              orientation: snapshot.player.side,
                            ),
                          )
                          .then((_) {
                            if (context.mounted) {
                              _doRefreshDataForRef(ref);
                            }
                          }),
                );
              })
              .toList(growable: false),
        );
      },
      error: (error, stackTrace) {
        debugPrint('SEVERE: [StreamerWidget] could not load channels data; $error\n $stackTrace');
        return const Padding(
          padding: Styles.bodySectionPadding,
          child: Text('Could not load TV channels'),
        );
      },
      loading:
          () => Shimmer(
            child: ShimmerLoading(
              isLoading: true,
              child: ListSection.loading(itemsNumber: 4, header: true, hasLeading: true),
            ),
          ),
    );
  }
}

class _StreamerWidget extends ConsumerWidget {
  final AsyncValue<IList<Streamer>> streamers;

  const _StreamerWidget(this.streamers);

  static const int numberOfItems = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return streamers.when(
      data: (data) {
        if (data.isEmpty) {
          return const SizedBox.shrink();
        }
        return ListSection(
          header: Text(context.l10n.streamersMenu),
          hasLeading: true,
          leadingIndent: kThumbnailImageSize + 16,
          onHeaderTap: () => Navigator.of(context).push(StreamerScreen.buildRoute(context, data)),
          children: [
            ...data
                .take(numberOfItems)
                .map((e) => StreamerListTile(streamer: e, thumbnailSize: kThumbnailImageSize)),
          ],
        );
      },
      error: (error, stackTrace) {
        debugPrint('SEVERE: [StreamerWidget] could not load streamer data; $error\n $stackTrace');
        return const Padding(
          padding: Styles.bodySectionPadding,
          child: Text('Could not load live streamers'),
        );
      },
      loading:
          () => Shimmer(
            child: ShimmerLoading(
              isLoading: true,
              child: ListSection.loading(
                itemsNumber: numberOfItems,
                header: true,
                hasLeading: true,
              ),
            ),
          ),
    );
  }
}
