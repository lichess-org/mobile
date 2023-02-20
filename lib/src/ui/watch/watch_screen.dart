import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chessground/chessground.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/providers.dart';
import 'package:lichess_mobile/src/model/tv/featured_game_notifier.dart';
import 'package:lichess_mobile/src/model/tv/featured_position.dart';
import 'package:lichess_mobile/src/model/tv/streamer_repository.dart';
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

class WatchScreen extends ConsumerStatefulWidget {
  const WatchScreen({super.key});

  @override
  _WatchScreenState createState() => _WatchScreenState();
}

class _WatchScreenState extends ConsumerState<WatchScreen> {
  final _andoirdRefreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return ConsumerPlatformWidget(
      ref: ref,
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context, WidgetRef ref) {
    final isSoundMuted = ref.watch(muteSoundPrefProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lichess TV'),
        actions: [
          IconButton(
            icon: isSoundMuted
                ? const Icon(Icons.volume_off)
                : const Icon(Icons.volume_up),
            onPressed: () => ref.read(muteSoundPrefProvider.notifier).toggle(),
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _andoirdRefreshKey,
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
    final isSoundMuted = ref.watch(muteSoundPrefProvider);
    return CupertinoPageScaffold(
      child: _WatchScaffold(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                child: isSoundMuted
                    ? const Icon(CupertinoIcons.volume_off)
                    : const Icon(CupertinoIcons.volume_up),
                onPressed: () =>
                    ref.read(muteSoundPrefProvider.notifier).toggle(),
              ),
            ),
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
            return Center(
              child: ConstrainedBox(
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
              ),
            );
          },
          error: (err, stackTrace) {
            debugPrint(
              'SEVERE: [WatchTvWidget] could not load tv stream; $err\n$stackTrace',
            );
            return const EmptyBoard(errorMessage: 'Could not load TV Stream');
          },
          loading: () => const EmptyBoard(),
        ),
      ],
    );
  }
}

class EmptyBoard extends StatelessWidget {
  const EmptyBoard({this.errorMessage});

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints.tight(const Size.square(350)),
        child: GameBoardLayout(
          topPlayer: kEmptyWidget,
          bottomPlayer: kEmptyWidget,
          boardData: const BoardData(
            interactableSide: InteractableSide.none,
            orientation: Side.white,
            fen: kEmptyFen,
          ),
          errorMessage: errorMessage,
        ),
      ),
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
