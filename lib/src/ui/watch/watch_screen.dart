import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chessground/chessground.dart';
import 'package:lichess_mobile/src/ui/watch/tv_screen.dart';
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

class _WatchTvWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListSection(
      hasLeading: true,
      header: const Text('Watch Top Games'),
      onHeaderTap: () => Navigator.of(context).push<void>(
        MaterialPageRoute(builder: (context) => const TvScreen()),
      ),
      children: [
        const GameBoardLayout(
          topPlayer: kEmptyWidget,
          bottomPlayer: kEmptyWidget,
          boardData: BoardData(
            interactableSide: InteractableSide.none,
            orientation: Side.white,
            fen: kEmptyFen,
          ),
        ),
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
