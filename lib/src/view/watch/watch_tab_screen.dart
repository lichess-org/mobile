import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dartchess/dartchess.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/model/tv/tv_repository.dart';
import 'package:lichess_mobile/src/model/tv/tv_game.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/view/watch/streamer_screen.dart';
import 'package:lichess_mobile/src/view/watch/tv_screen.dart';

part 'watch_tab_screen.g.dart';

@riverpod
Future<TvGameSnapshot> tvBestSnapshot(TvBestSnapshotRef ref) async {
  final link = ref.cacheFor(const Duration(minutes: 5));
  final repo = ref.watch(tvRepositoryProvider);
  try {
    return repo.currentBestSnapshot();
  } catch (e) {
    link.close();
    rethrow;
  }
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
        _refreshData();
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
        onRefresh: _refreshData,
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
                onRefresh: _refreshData,
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

  Future<void> _refreshData() {
    return Future.wait([
      ref.refresh(tvBestSnapshotProvider.future),
      ref.refresh(liveStreamersProvider.future),
    ]);
  }
}

class _WatchTvWidget extends ConsumerWidget {
  const _WatchTvWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredGame = ref.watch(tvBestSnapshotProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: Styles.horizontalBodyPadding.add(Styles.sectionTopPadding),
          child: Text('Lichess TV', style: Styles.sectionTitle),
        ),
        featuredGame.when(
          data: (game) {
            final player = game.orientation == Side.white
                ? game.white.asPlayer
                : game.black.asPlayer;
            return SmallBoardPreview(
              onTap: () {
                pushPlatformRoute(
                  context,
                  builder: (context) => const TvScreen(),
                ).then((_) {
                  ref.invalidate(tvBestSnapshotProvider);
                });
              },
              orientation: game.orientation.cg,
              fen: game.fen,
              description: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    'Top Rated',
                    style: Styles.boardPreviewTitle,
                  ),
                  const Icon(
                    LichessIcons.crown,
                    color: LichessColors.brag,
                    size: 30,
                  ),
                  PlayerTitle(
                    userName: player.displayName(context),
                    title: player.title,
                    rating: player.rating,
                  ),
                ],
              ),
            );
          },
          error: (err, stackTrace) {
            debugPrint(
              'SEVERE: [WatchTvWidget] could not load tv stream; $err\n$stackTrace',
            );
            return const SmallBoardPreview(
              orientation: cg.Side.white,
              fen: kEmptyFen,
              description: Center(
                child: Text('Could not load tv stream.'),
              ),
            );
          },
          loading: () => const SmallBoardPreview(
            orientation: cg.Side.white,
            fen: kEmptyFen,
            description: SizedBox.shrink(),
          ),
        ),
      ],
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
