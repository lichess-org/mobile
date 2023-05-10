import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart';

import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/table_board_layout.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/widgets/bottom_navigation.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/model/tv/featured_game.dart';
import 'package:lichess_mobile/src/ui/settings/toggle_sound_button.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';

import 'package:lichess_mobile/src/model/tv/tv_repository_providers.dart';
import 'package:result_extensions/result_extensions.dart';

final _featuredGameWithSoundProvider = featuredGameProvider(withSound: true);

final variantStateProvider = StateProvider.autoDispose<ChannelVariant>((ref) {
  return ChannelVariant.topRated;
});

class TvScreen extends ConsumerStatefulWidget {
  const TvScreen({super.key});

  @override
  ConsumerState<TvScreen> createState() => _TvScreenState();
}

class _TvScreenState extends ConsumerState<TvScreen>
    with RouteAware, WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return ConsumerPlatformWidget(
      ref: ref,
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  void showChoicesDialog(WidgetRef ref) {
    ChannelVariant selectedVariant = ref.watch(variantStateProvider);

    final repo = ref.read(tvRepositoryProvider);
    final FutureResult<TvChannels> channelResult = repo.getTvChannels();

    channelResult.then((res) {
      if (res.isValue) {
        final TvChannels data = res.asValue!.value;
        showChoicePicker(
          context,
          choices: ChannelVariant.values,
          selectedItem: selectedVariant,
          labelBuilder: (t) => Text(t.title),
          onSelectedItemChanged: (ChannelVariant? d) {
            if (d != null) {
              selectedVariant = d;
            }
          },
        ).then((_) {
          String? newGameId = data.channels.entries
              .where((element) => element.key == selectedVariant.title)
              .first
              .value
              .gameId;
          if (selectedVariant.title == "Top Rated") newGameId = null;

          ref.read(variantStateProvider.notifier).state = selectedVariant;
          ref
              .read(_featuredGameWithSoundProvider.notifier)
              .setGameId(newGameId);
        });
      }
    }); // End FR_data.then
  }

  Widget _androidBuilder(
    BuildContext context,
    WidgetRef ref,
  ) {
    final ChannelVariant selectedVariant = ref.watch(variantStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(selectedVariant.title),
              const Icon(
                Icons.arrow_drop_down,
                size: 34.0,
              ),
            ],
          ),
          onTap: () {
            showChoicesDialog(ref);
          },
        ),
        actions: [
          ToggleSoundButton(),
        ],
      ),
      body: const _Body(),
    );
  }

  Widget _iosBuilder(
    BuildContext context,
    WidgetRef ref,
  ) {
    final ChannelVariant selectedVariant = ref.watch(variantStateProvider);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(selectedVariant.title),
              const Icon(
                Icons.arrow_drop_down,
                size: 34.0,
              ),
            ],
          ),
          onTap: () {
            showChoicesDialog(ref);
          },
        ),
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
            final boardData = BoardData(
              interactableSide: InteractableSide.none,
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
            );
            final bottomPlayerWidget = BoardPlayer(
              player: bottomPlayer.asPlayer,
              clock: Duration(seconds: bottomPlayer.seconds ?? 0),
              active: !game.position.position.isGameOver &&
                  game.position.position.turn == bottomPlayer.side,
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
            boardData: BoardData(
              interactableSide: InteractableSide.none,
              orientation: Side.white,
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
              boardData: BoardData(
                fen: kEmptyFen,
                interactableSide: InteractableSide.none,
                orientation: Side.white,
              ),
              errorMessage: 'Could not load TV stream.',
            );
          },
        ),
      ),
    );
  }
}
