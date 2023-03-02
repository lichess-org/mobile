import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chessground/chessground.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/styles.dart';
import 'package:lichess_mobile/src/model/settings/providers.dart';
import 'package:lichess_mobile/src/model/tv/featured_game_notifier.dart';
import 'package:lichess_mobile/src/model/tv/featured_position.dart';
import 'package:lichess_mobile/src/model/tv/streamer_repository.dart';
import 'package:lichess_mobile/src/model/tv/tv_stream.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/widgets/bottom_navigation.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/ui/watch/streamer_widget.dart';
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
        onRefresh: () => ref.refresh(streamerListProvider.future),
        child: _WatchScaffold(
          child: ListView(
            padding: Styles.verticalBodyPadding,
            children: [const _WatchTvWidget(), StreamerWidget()],
          ),
        ),
      ),
    );
  }

  Widget _buildIos(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _WatchScaffold(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () => ref.refresh(streamerListProvider.future),
            ),
            SliverSafeArea(
              top: false,
              sliver: SliverPadding(
                padding: Styles.verticalBodyPadding,
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [const _WatchTvWidget(), StreamerWidget()],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _WatchTvWidget extends ConsumerWidget {
  const _WatchTvWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pieceSet = ref.watch(pieceSetPrefProvider);
    final boardColor = ref.watch(boardThemePrefProvider);
    final currentTab = ref.watch(currentBottomTabProvider);
    final tvStream = currentTab == BottomTab.watch
        ? ref.watch(tvStreamProvider(false))
        : const AsyncLoading<FeaturedPosition>();
    final featuredGame = ref.watch(featuredGameProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        final boardDim =
            constraints.maxWidth > kLargeScreenWidth ? 650.0 : 350.0;
        return ListSection(
          hasLeading: true,
          header: const Text('Lichess TV'),
          children: [
            tvStream.when(
              data: (position) {
                return GestureDetector(
                  onTap: () => Navigator.of(context).push<void>(
                    MaterialPageRoute(builder: (context) => const TvScreen()),
                  ),
                  child: Center(
                    child: SizedBox.square(
                      dimension: boardDim,
                      child: BoardPreview(
                        boardData: BoardData(
                          interactableSide: InteractableSide.none,
                          orientation:
                              featuredGame?.orientation.cg ?? Side.white,
                          fen: position.fen,
                          lastMove: position.lastMove?.cg,
                        ),
                        boardSettings: BoardSettings(
                          enableCoordinates: false,
                          animationDuration: Duration.zero,
                          pieceAssets: pieceSet.assets,
                          colorScheme: boardColor.colors,
                        ),
                      ),
                    ),
                  ),
                );
              },
              error: (err, stackTrace) {
                debugPrint(
                  'SEVERE: [WatchTvWidget] could not load tv stream; $err\n$stackTrace',
                );
                return Center(
                  child: SizedBox.square(
                    dimension: boardDim,
                    child: BoardPreview(
                      boardData: const BoardData(
                        interactableSide: InteractableSide.none,
                        orientation: Side.white,
                        fen: kEmptyFen,
                      ),
                      boardSettings: BoardSettings(
                        colorScheme: boardColor.colors,
                      ),
                      errorMessage: 'Could not load Tv Stream',
                    ),
                  ),
                );
              },
              loading: () => Center(
                child: SizedBox.square(
                  dimension: boardDim,
                  child: BoardPreview(
                    boardData: const BoardData(
                      interactableSide: InteractableSide.none,
                      orientation: Side.white,
                      fen: kEmptyFen,
                    ),
                    boardSettings: BoardSettings(
                      colorScheme: boardColor.colors,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WatchScaffold extends StatelessWidget {
  const _WatchScaffold({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: child,
          )
        ],
      ),
    );
  }
}
