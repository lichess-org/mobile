import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chessground/chessground.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/providers.dart';
import 'package:lichess_mobile/src/model/tv/featured_game_notifier.dart';
import 'package:lichess_mobile/src/model/tv/featured_position.dart';
import 'package:lichess_mobile/src/model/tv/tv_stream.dart';
import 'package:lichess_mobile/src/ui/watch/tv_screen.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/widgets/bottom_navigation.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/common/styles.dart';
import 'package:lichess_mobile/src/ui/watch/streamer_widget.dart';
import 'package:lichess_mobile/src/widgets/game_board_layout.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/widgets/list.dart';

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watch'),
      ),
      body: _WatchScaffold(
        child: ListView(
          padding: Styles.verticalBodyPadding,
          children: [StreamerWidget()],
        ),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      child: _WatchScaffold(
        child: CustomScrollView(
          slivers: [
            const CupertinoSliverNavigationBar(),
            SliverSafeArea(
              top: false,
              sliver: SliverPadding(
                padding: Styles.verticalBodyPadding,
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                      [_WatchTvWidget(), StreamerWidget()]),
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
    final currentTab = ref.watch(currentBottomTabProvider);
    final tvStream = currentTab == BottomTab.watch
        ? ref.watch(tvStreamProvider)
        : const AsyncLoading<FeaturedPosition>();
    final featuredGame = ref.watch(featuredGameProvider);
    return ListSection(
      hasLeading: true,
      header: const Text('Watch Top Games'),
      onHeaderTap: () => Navigator.of(context).push<void>(
        MaterialPageRoute(builder: (context) => const TvScreen()),
      ),
      children: [
        tvStream.when(
          data: (position) {
            final boardData = BoardData(
              interactableSide: InteractableSide.none,
              orientation: featuredGame?.orientation.cg ?? Side.white,
              fen: position.fen,
              lastMove: position.lastMove?.cg,
            );
            return ConstrainedBox(
              constraints: BoxConstraints.tight(const Size.square(350)),
              child: GameBoardLayout(
                topPlayer: kEmptyWidget,
                bottomPlayer: kEmptyWidget,
                boardData: boardData,
                boardSettings: BoardSettings(
                  animationDuration: Duration.zero,
                  pieceAssets: pieceSet.assets,
                ),
              ),
            );
          },
          error: (err, stackTrace) {
            debugPrint(
              'SEVERE: [WatchTvWidget] could not load tv stream; $err\n$stackTrace',
            );
            return ConstrainedBox(
              constraints: BoxConstraints.tight(const Size.square(350)),
              child: const GameBoardLayout(
                topPlayer: kEmptyWidget,
                bottomPlayer: kEmptyWidget,
                boardData: BoardData(
                  interactableSide: InteractableSide.none,
                  orientation: Side.white,
                  fen: kEmptyFen,
                ),
                errorMessage: 'Cound not load TV Stream.',
              ),
            );
          },
          loading: () => ConstrainedBox(
            constraints: BoxConstraints.tight(const Size.square(350)),
            child: const GameBoardLayout(
              topPlayer: kEmptyWidget,
              bottomPlayer: kEmptyWidget,
              boardData: BoardData(
                interactableSide: InteractableSide.none,
                orientation: Side.white,
                fen: kEmptyFen,
              ),
            ),
          ),
        )
      ],
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
