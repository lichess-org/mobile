import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dartchess/dartchess.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/model/tv/tv_repository.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/view/watch/streamer_screen.dart';
import 'package:lichess_mobile/src/view/watch/tv_screen.dart';

class WatchTabScreen extends ConsumerStatefulWidget {
  const WatchTabScreen({super.key});

  @override
  _WatchScreenState createState() => _WatchScreenState();
}

class _WatchScreenState extends ConsumerState<WatchTabScreen> {
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

    return featuredGame.when(
      data: (game) {
        final whitePlayer = PlayerTitle(
          userName: game.white.asPlayer.displayName(context),
          title: game.white.title,
          rating: game.white.rating,
        );
        final blackPlayer = PlayerTitle(
          userName: game.black.asPlayer.displayName(context),
          title: game.black.title,
          rating: game.black.rating,
        );
        final firstPlayer =
            game.orientation == Side.white ? whitePlayer : blackPlayer;
        final secondPlayer =
            game.orientation == Side.white ? blackPlayer : whitePlayer;
        return BoardPreview(
          header: Text('Lichess TV', style: Styles.sectionTitle),
          onTap: () => pushPlatformRoute(
            context,
            builder: (context) => const TvScreen(),
          ),
          orientation: game.orientation.cg,
          fen: game.fen,
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              firstPlayer,
              const Text('vs'),
              secondPlayer,
            ],
          ),
        );
      },
      error: (err, stackTrace) {
        debugPrint(
          'SEVERE: [WatchTvWidget] could not load tv stream; $err\n$stackTrace',
        );
        return BoardPreview(
          header: Text('Lichess TV', style: Styles.sectionTitle),
          orientation: cg.Side.white,
          fen: kEmptyFen,
          errorMessage: 'Could not load Tv Stream',
        );
      },
      loading: () => BoardPreview(
        header: Text('Lichess TV', style: Styles.sectionTitle),
        orientation: cg.Side.white,
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
