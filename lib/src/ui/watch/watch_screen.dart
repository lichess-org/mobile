import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chessground/chessground.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/styles.dart';
import 'package:lichess_mobile/src/model/tv/featured_game_notifier.dart';
import 'package:lichess_mobile/src/model/tv/featured_position.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/model/tv/tv_stream.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/bottom_navigation.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/ui/watch/streamer_screen.dart';
import 'package:lichess_mobile/src/ui/watch/tv_screen.dart';

class WatchScreen extends ConsumerStatefulWidget {
  const WatchScreen({super.key});

  @override
  _WatchScreenState createState() => _WatchScreenState();
}

class _WatchScreenState extends ConsumerState<WatchScreen> {
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
                      children: const [_WatchTvWidget(), _StreamerWidget()],
                    )
                  : GridView(
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
      navigationBar: const CupertinoNavigationBar(),
      child: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return CustomScrollView(
              slivers: [
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
      ),
    );
  }
}

class _WatchTvWidget extends ConsumerWidget {
  const _WatchTvWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentBottomTabProvider);
    final tvStream = currentTab == BottomTab.watch
        ? ref.watch(tvStreamProvider(false))
        : const AsyncLoading<FeaturedPosition>();
    final featuredGame = ref.watch(featuredGameProvider);
    return tvStream.when(
      data: (position) {
        return BoardPreview(
          header: Text('Lichess TV', style: Styles.sectionTitle),
          onTap: () => pushPlatformRoute(
            context,
            builder: (context) => const TvScreen(),
          ),
          orientation: featuredGame?.orientation.cg ?? Side.white,
          fen: position.fen,
          lastMove: position.lastMove?.cg,
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
          header: Text(context.l10n.lichessStreamers),
          hasLeading: true,
          onHeaderTap: () {
            pushPlatformRoute(
              context,
              builder: (context) => StreamerScreen(streamers: data),
            );
          },
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
      loading: () => const CenterLoadingIndicator(),
    );
  }
}
