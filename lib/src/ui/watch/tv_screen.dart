import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/widgets/table_board_layout.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/widgets/bottom_navigation.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/model/tv/featured_game.dart';
import 'package:lichess_mobile/src/ui/settings/toggle_sound_button.dart';

final _featuredGameWithSoundProvider = featuredGameProvider(withSound: true);

final RouteObserver<PageRoute<void>> tvRouteObserver =
    RouteObserver<PageRoute<void>>();

class TvScreen extends ConsumerStatefulWidget {
  const TvScreen({super.key});

  @override
  ConsumerState<TvScreen> createState() => _TvScreenState();
}

class _TvScreenState extends ConsumerState<TvScreen>
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
        title: const Text('Top Rated'),
        actions: [
          ToggleSoundButton(),
        ],
      ),
      body: const _Body(),
    );
  }

  Widget _iosBuilder(
    BuildContext context,
  ) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Top Rated'),
        trailing: ToggleSoundButton(),
      ),
      child: const _Body(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(_featuredGameWithSoundProvider.notifier).connectStream();
    } else {
      ref.read(_featuredGameWithSoundProvider.notifier).disconnectStream();
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
      tvRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    tvRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPushNext() {
    ref.read(_featuredGameWithSoundProvider.notifier).disconnectStream();
    super.didPushNext();
  }

  @override
  void didPopNext() {
    ref.read(_featuredGameWithSoundProvider.notifier).connectStream();
    super.didPopNext();
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentBottomTabProvider);
    final featuredGame = currentTab == BottomTab.watch
        ? ref.watch(_featuredGameWithSoundProvider)
        : const AsyncLoading<FeaturedGameState>();

    return SafeArea(
      child: Center(
        child: featuredGame.when(
          data: (game) {
            final boardData = cg.BoardData(
              interactableSide: cg.InteractableSide.none,
              orientation: game.orientation.cg,
              fen: game.position.position.fen,
              lastMove: game.position.lastMove?.cg,
            );
            final topPlayer =
                game.orientation == Side.white ? game.black : game.white;

            final bottomPlayer =
                game.orientation == Side.white ? game.white : game.black;
            final topPlayerWidget = BoardPlayer(
              player: topPlayer.asPlayer,
              clock: Duration(seconds: topPlayer.seconds ?? 0),
              active: !game.position.position.isGameOver &&
                  game.position.position.turn == topPlayer.side,
              diff: game.position.diff.bySide(topPlayer.side),
            );
            final bottomPlayerWidget = BoardPlayer(
              player: bottomPlayer.asPlayer,
              clock: Duration(seconds: bottomPlayer.seconds ?? 0),
              active: !game.position.position.isGameOver &&
                  game.position.position.turn == bottomPlayer.side,
              diff: game.position.diff.bySide(bottomPlayer.side),
            );
            return TableBoardLayout(
              boardData: boardData,
              boardSettingsOverrides: const BoardSettingsOverrides(
                animationDuration: Duration.zero,
              ),
              topTable: topPlayerWidget,
              bottomTable: bottomPlayerWidget,
            );
          },
          loading: () => const TableBoardLayout(
            topTable: kEmptyWidget,
            bottomTable: kEmptyWidget,
            boardData: cg.BoardData(
              interactableSide: cg.InteractableSide.none,
              orientation: cg.Side.white,
              fen: kEmptyFen,
            ),
          ),
          error: (err, stackTrace) {
            debugPrint(
              'SEVERE: [TvScreen] could not load stream; $err\n$stackTrace',
            );
            return const TableBoardLayout(
              topTable: kEmptyWidget,
              bottomTable: kEmptyWidget,
              boardData: cg.BoardData(
                fen: kEmptyFen,
                interactableSide: cg.InteractableSide.none,
                orientation: cg.Side.white,
              ),
              errorMessage: 'Could not load TV stream.',
            );
          },
        ),
      ),
    );
  }
}
