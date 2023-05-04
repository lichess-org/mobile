import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chessground/chessground.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/model/tv/featured_game.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/bottom_navigation.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/ui/watch/streamer_screen.dart';
import 'package:lichess_mobile/src/ui/watch/tv_screen.dart';

final _featuredGameNoSoundProvider = featuredGameProvider(withSound: false);

class WatchScreen extends ConsumerStatefulWidget {
  const WatchScreen({super.key});

  @override
  _WatchScreenState createState() => _WatchScreenState();
}

class _WatchScreenState extends ConsumerState<WatchScreen>
    with RouteAware, WidgetsBindingObserver {
  final _androidRefreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
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
        onRefresh: () => ref.refresh(liveStreamersProvider.future),
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
                      children: const [
                        _WatchTvWidget(),
                        _StreamerWidget(numberOfItems: 8)
                      ],
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
                onRefresh: () => ref.refresh(liveStreamersProvider.future),
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
                            _StreamerWidget(numberOfItems: 8),
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(_featuredGameNoSoundProvider.notifier).connectStream();
    } else {
      ref.read(_featuredGameNoSoundProvider.notifier).disconnectStream();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null && route is PageRoute) {
      watchRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    watchRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPushNext() {
    ref.read(_featuredGameNoSoundProvider.notifier).disconnectStream();
    super.didPushNext();
  }

  @override
  void didPopNext() {
    ref.read(_featuredGameNoSoundProvider.notifier).connectStream();
    super.didPopNext();
  }
}

class _WatchTvWidget extends ConsumerWidget {
  const _WatchTvWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentBottomTabProvider);
    final featuredGame = currentTab == BottomTab.watch
        ? ref.watch(_featuredGameNoSoundProvider)
        : const AsyncLoading<FeaturedGameState>();
    return featuredGame.when(
      data: (game) {
        return BoardPreview(
          header: Text('Lichess TV', style: Styles.sectionTitle),
          onTap: () => pushPlatformRoute(
            context,
            builder: (context) => const TvScreen(),
          ),
          orientation: game.orientation.cg,
          fen: game.position.position.fen,
          lastMove: game.position.lastMove?.cg,
        );
      },
      error: (err, stackTrace) {
        debugPrint(
          'SEVERE: [WatchTvWidget] could not load tv stream; $err\n$stackTrace',
        );
        return BoardPreview(
          header: Text('Lichess TV', style: Styles.sectionTitle),
          orientation: Side.white,
          fen: kEmptyFen,
          errorMessage: 'Could not load Tv Stream',
        );
      },
      loading: () => BoardPreview(
        header: Text('Lichess TV', style: Styles.sectionTitle),
        orientation: Side.white,
        fen: kEmptyFen,
      ),
    );
  }
}

class _StreamerWidget extends ConsumerWidget {
  const _StreamerWidget({this.numberOfItems = 5});

  final int numberOfItems;

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
                .map((e) => StreamerListTile(streamer: e))
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
