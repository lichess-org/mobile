import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/model/auth/auth_socket.dart';
import 'package:lichess_mobile/src/model/tv/live_tv_channels.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/view/watch/tv_screen.dart';

class LiveTvChannelsScreen extends ConsumerStatefulWidget {
  const LiveTvChannelsScreen({super.key});

  @override
  ConsumerState<LiveTvChannelsScreen> createState() => _TvChannelsScreenState();
}

class _TvChannelsScreenState extends ConsumerState<LiveTvChannelsScreen>
    with RouteAware, WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lichess TV'),
      ),
      body: const _Body(),
    );
  }

  Widget _iosBuilder(
    BuildContext context,
  ) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Lichess TV'),
      ),
      child: _Body(),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(liveTvChannelsProvider.notifier).startWatching();
    } else {
      ref.read(liveTvChannelsProvider.notifier).stopWatching();
      ref.read(authSocketProvider).close();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null && route is PageRoute) {
      watchTabRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    watchTabRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPushNext() {
    ref.read(liveTvChannelsProvider.notifier).stopWatching();
    super.didPushNext();
  }

  @override
  void didPopNext() {
    ref.read(liveTvChannelsProvider.notifier).startWatching();
    super.didPopNext();
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentBottomTab = ref.watch(currentBottomTabProvider);
    final gamesAsync = currentBottomTab == BottomTab.watch
        ? ref.watch(liveTvChannelsProvider)
        : const AsyncLoading<LiveTvChannelsState>();
    return gamesAsync.when(
      data: (games) {
        final list = [
          for (final channel in TvChannel.values)
            if (games[channel] != null) games[channel]!,
        ];
        return ListView.builder(
          itemCount: games.length,
          itemBuilder: (context, index) {
            final game = list[index];
            return SmallBoardPreview(
              onTap: () {
                pushPlatformRoute(
                  context,
                  builder: (_) => TvScreen(
                    channel: game.channel,
                    initialGame: (game.id, game.orientation),
                  ),
                );
              },
              orientation: game.orientation.cg,
              fen: game.fen ?? kEmptyFen,
              lastMove: game.lastMove?.cg,
              description: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    game.channel.label,
                    style: Styles.boardPreviewTitle,
                  ),
                  Icon(
                    game.channel.icon,
                    color: LichessColors.brag,
                    size: 30,
                  ),
                  PlayerTitle(
                    userName: game.player.asPlayer.displayName(context),
                    title: game.player.title,
                    rating: game.player.rating,
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Text(error.toString()),
      ),
    );
  }
}
