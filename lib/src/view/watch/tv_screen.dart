import 'package:chessground/chessground.dart' as cg;
import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';
import 'package:lichess_mobile/src/model/tv/tv_controller.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/game/game_player.dart';
import 'package:lichess_mobile/src/view/settings/toggle_sound_button.dart';
import 'package:lichess_mobile/src/widgets/board_table.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/countdown_clock.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class TvScreen extends ConsumerStatefulWidget {
  const TvScreen({required this.channel, this.initialGame, super.key});

  final TvChannel channel;
  final (GameId id, Side orientation)? initialGame;

  @override
  ConsumerState<TvScreen> createState() => _TvScreenState();
}

class _TvScreenState extends ConsumerState<TvScreen>
    with RouteAware, WidgetsBindingObserver {
  TvControllerProvider get _tvGameCtrl =>
      tvControllerProvider(widget.channel, widget.initialGame);

  final _whiteClockKey = GlobalKey(debugLabel: 'whiteClockOnTvScreen');
  final _blackClockKey = GlobalKey(debugLabel: 'blackClockOnTvScreen');

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
        title: Text('${widget.channel.label} TV'),
        actions: [
          ToggleSoundButton(),
        ],
      ),
      body: _Body(
        widget.channel,
        widget.initialGame,
        whiteClockKey: _whiteClockKey,
        blackClockKey: _blackClockKey,
      ),
    );
  }

  Widget _iosBuilder(
    BuildContext context,
  ) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        padding: Styles.cupertinoAppBarTrailingWidgetPadding,
        middle: Text('${widget.channel.label} TV'),
        trailing: ToggleSoundButton(),
      ),
      child: _Body(
        widget.channel,
        widget.initialGame,
        whiteClockKey: _whiteClockKey,
        blackClockKey: _blackClockKey,
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(_tvGameCtrl.notifier).startWatching();
    } else {
      ref.read(_tvGameCtrl.notifier).stopWatching();
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
      rootNavPageRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    rootNavPageRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPushNext() {
    ref.read(_tvGameCtrl.notifier).stopWatching();
    super.didPushNext();
  }

  @override
  void didPopNext() {
    ref.read(_tvGameCtrl.notifier).startWatching();
    super.didPopNext();
  }

  @override
  void didPop() {
    ref.read(_tvGameCtrl.notifier).stopWatching();
    super.didPop();
  }
}

class _Body extends ConsumerWidget {
  const _Body(
    this.channel,
    this.initialGame, {
    required this.whiteClockKey,
    required this.blackClockKey,
  });

  final TvChannel channel;
  final (GameId id, Side orientation)? initialGame;
  final GlobalKey whiteClockKey;
  final GlobalKey blackClockKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncGame = ref.watch(tvControllerProvider(channel, initialGame));

    return Column(
      children: [
        Expanded(
          child: SafeArea(
            child: asyncGame.when(
              data: (gameState) {
                final game = gameState.game;

                final boardData = cg.BoardData(
                  interactableSide: cg.InteractableSide.none,
                  orientation: gameState.orientation.cg,
                  fen: game.lastPosition.fen,
                  sideToMove: game.lastPosition.turn.cg,
                  lastMove: game.lastMove?.cg,
                  isCheck: game.lastPosition.isCheck,
                );
                final blackPlayerWidget = GamePlayer(
                  player: game.black.setOnGame(true),
                  clock: gameState.game.clock != null
                      ? CountdownClock(
                          key: blackClockKey,
                          duration: gameState.game.clock!.black,
                          active: gameState.activeClockSide == Side.black,
                        )
                      : null,
                  materialDiff: game.lastMaterialDiffAt(Side.black),
                );
                final whitePlayerWidget = GamePlayer(
                  player: game.white.setOnGame(true),
                  clock: gameState.game.clock != null
                      ? CountdownClock(
                          key: whiteClockKey,
                          duration: gameState.game.clock!.white,
                          active: gameState.activeClockSide == Side.white,
                        )
                      : null,
                  materialDiff: game.lastMaterialDiffAt(Side.white),
                );
                return BoardTable(
                  boardData: boardData,
                  boardSettingsOverrides: const BoardSettingsOverrides(
                    animationDuration: Duration.zero,
                  ),
                  topTable: gameState.orientation == Side.white
                      ? blackPlayerWidget
                      : whitePlayerWidget,
                  bottomTable: gameState.orientation == Side.white
                      ? whitePlayerWidget
                      : blackPlayerWidget,
                  moves: game.steps
                      .skip(1)
                      .map((e) => e.sanMove!.san)
                      .toList(growable: false),
                  currentMoveIndex: gameState.stepCursor,
                );
              },
              loading: () => const BoardTable(
                topTable: kEmptyWidget,
                bottomTable: kEmptyWidget,
                boardData: cg.BoardData(
                  interactableSide: cg.InteractableSide.none,
                  orientation: cg.Side.white,
                  fen: kEmptyFen,
                ),
                showMoveListPlaceholder: true,
              ),
              error: (err, stackTrace) {
                debugPrint(
                  'SEVERE: [TvScreen] could not load stream; $err\n$stackTrace',
                );
                return const BoardTable(
                  topTable: kEmptyWidget,
                  bottomTable: kEmptyWidget,
                  boardData: cg.BoardData(
                    fen: kEmptyFen,
                    interactableSide: cg.InteractableSide.none,
                    orientation: cg.Side.white,
                  ),
                  errorMessage: 'Could not load TV stream.',
                  showMoveListPlaceholder: true,
                );
              },
            ),
          ),
        ),
        _BottomBar(),
      ],
    );
  }
}

class _BottomBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Theme.of(context).platform == TargetPlatform.iOS
          ? CupertinoTheme.of(context).barBackgroundColor
          : Theme.of(context).bottomAppBarTheme.color,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: kBottomBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: BottomBarButton(
                  label: context.l10n.menu,
                  onTap: () {
                    //_showAnalysisMenu(context, ref);
                  },
                  icon: Icons.swap_vert,
                ),
              ),
              Expanded(
                child: RepeatButton(
                  onLongPress: () {},
                  // canGoBack ? () => _moveBackward(ref) : null,
                  child: BottomBarButton(
                    key: const ValueKey('goto-previous'),
                    onTap: () {
                      //canGoBack ? () => _moveBackward(ref) : null,
                    },
                    label: 'Previous',
                    icon: CupertinoIcons.chevron_back,
                    showTooltip: false,
                  ),
                ),
              ),
              Expanded(
                child: RepeatButton(
                  onLongPress: () {},
                  //canGoNext ? () => _moveForward(ref) : null,
                  child: BottomBarButton(
                    key: const ValueKey('goto-next'),
                    icon: CupertinoIcons.chevron_forward,
                    label: context.l10n.next,
                    onTap: () {},
                    //canGoNext ? () => _moveForward(ref) : null,
                    showTooltip: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
