import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/service/wake_lock_service.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';
import 'package:lichess_mobile/src/model/tv/tv_controller.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/focus_detector.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_loading_board.dart';
import 'package:lichess_mobile/src/view/game/game_player.dart';
import 'package:lichess_mobile/src/view/settings/toggle_sound_button.dart';
import 'package:lichess_mobile/src/widgets/board_table.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/clock.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

class TvScreen extends ConsumerStatefulWidget {
  const TvScreen({this.channel, this.initialGame, this.user, super.key})
    : assert(channel != null || user != null, 'Either channel or user must be provided');

  final TvChannel? channel;
  final (GameId id, Side orientation)? initialGame;
  final LightUser? user;

  static Route<dynamic> buildRoute(
    BuildContext context, {
    TvChannel? channel,
    GameId? gameId,
    LightUser? user,
    Side? orientation,
  }) {
    return buildScreenRoute(
      context,
      screen: TvScreen(
        channel: channel,
        initialGame: gameId != null ? (gameId, orientation ?? Side.white) : null,
        user: user,
      ),
    );
  }

  @override
  ConsumerState<TvScreen> createState() => _TvScreenState();
}

class _TvScreenState extends ConsumerState<TvScreen> {
  TvControllerProvider get _tvGameCtrl => tvControllerProvider(
    widget.channel,
    initialGame: widget.initialGame,
    userId: widget.user?.id,
  );

  final _whiteClockKey = GlobalKey(debugLabel: 'whiteClockOnTvScreen');
  final _blackClockKey = GlobalKey(debugLabel: 'blackClockOnTvScreen');
  WakeLockService? _wakeLockService;

  @override
  void initState() {
    super.initState();
    _enableWakeLock();
  }

  @override
  void dispose() {
    _disableWakeLock();
    super.dispose();
  }

  Future<void> _enableWakeLock() async {
    _wakeLockService = ref.read(wakeLockServiceProvider);
    await _wakeLockService?.enable();
  }

  Future<void> _disableWakeLock() async {
    await _wakeLockService?.disable();
  }

  @override
  Widget build(BuildContext context) {
    final asyncGame = ref.watch(_tvGameCtrl);

    return FocusDetector(
      onFocusRegained: () {
        ref.read(_tvGameCtrl.notifier).startWatching();
      },
      onFocusLost: () {
        if (context.mounted) {
          ref.read(_tvGameCtrl.notifier).stopWatching();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: widget.channel?.label != null
              ? Text('${widget.channel!.label} TV')
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    UserFullNameWidget(user: widget.user),
                    const SizedBox(width: 4.0),
                    const Icon(Icons.live_tv),
                  ],
                ),
          actions: const [ToggleSoundButton()],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: asyncGame.when(
                  data: (gameState) {
                    final game = gameState.game;
                    final position = gameState.game.positionAt(gameState.stepCursor);

                    final blackPlayerWidget = GamePlayer(
                      game: game.copyWith(black: game.black.setOnGame(true)),
                      side: Side.black,
                      clock: gameState.game.clock != null
                          ? CountdownClockBuilder(
                              key: _blackClockKey,
                              timeLeft: gameState.game.clock!.black,
                              delay: gameState.game.clock!.lag ?? const Duration(milliseconds: 10),
                              clockUpdatedAt: gameState.game.clock!.at,
                              active: gameState.activeClockSide == Side.black,
                              builder: (context, timeLeft) {
                                return Clock(
                                  timeLeft: timeLeft,
                                  active: gameState.activeClockSide == Side.black,
                                );
                              },
                            )
                          : null,
                      materialDiff: game.lastMaterialDiffAt(Side.black),
                    );
                    final whitePlayerWidget = GamePlayer(
                      game: game.copyWith(white: game.white.setOnGame(true)),
                      side: Side.white,
                      clock: gameState.game.clock != null
                          ? CountdownClockBuilder(
                              key: _whiteClockKey,
                              timeLeft: gameState.game.clock!.white,
                              clockUpdatedAt: gameState.game.clock!.at,
                              delay: gameState.game.clock!.lag ?? const Duration(milliseconds: 10),
                              active: gameState.activeClockSide == Side.white,
                              builder: (context, timeLeft) {
                                return Clock(
                                  timeLeft: timeLeft,
                                  active: gameState.activeClockSide == Side.white,
                                );
                              },
                            )
                          : null,
                      materialDiff: game.lastMaterialDiffAt(Side.white),
                    );

                    return BoardTable(
                      orientation: gameState.orientation,
                      fen: position.fen,
                      boardSettingsOverrides: const BoardSettingsOverrides(
                        animationDuration: Duration.zero,
                      ),
                      topTable: gameState.orientation == Side.white
                          ? blackPlayerWidget
                          : whitePlayerWidget,
                      bottomTable: gameState.orientation == Side.white
                          ? whitePlayerWidget
                          : blackPlayerWidget,
                      moves: game.steps.skip(1).map((e) => e.sanMove!.san).toList(growable: false),
                      currentMoveIndex: gameState.stepCursor,
                      lastMove: game.moveAt(gameState.stepCursor),
                    );
                  },
                  loading: () => const Shimmer(
                    child: BoardTable(
                      topTable: LoadingPlayerWidget(),
                      bottomTable: LoadingPlayerWidget(),
                      orientation: Side.white,
                      fen: kEmptyFEN,
                      moves: [],
                    ),
                  ),
                  error: (err, stackTrace) {
                    debugPrint('SEVERE: [TvScreen] could not load stream; $err\n$stackTrace');
                    return const BoardTable(
                      topTable: kEmptyWidget,
                      bottomTable: kEmptyWidget,
                      orientation: Side.white,
                      fen: kEmptyFEN,
                      errorMessage: 'Could not load TV stream.',
                      moves: [],
                    );
                  },
                ),
              ),
              BottomBar(
                children: [
                  BottomBarButton(
                    label: context.l10n.flipBoard,
                    onTap: () => _flipBoard(ref),
                    icon: CupertinoIcons.arrow_2_squarepath,
                  ),
                  RepeatButton(
                    onLongPress: ref.read(_tvGameCtrl.notifier).canGoBack()
                        ? () => _moveBackward(ref)
                        : null,
                    child: BottomBarButton(
                      key: const ValueKey('goto-previous'),
                      onTap: ref.read(_tvGameCtrl.notifier).canGoBack()
                          ? () => _moveBackward(ref)
                          : null,
                      label: 'Previous',
                      icon: CupertinoIcons.chevron_back,
                      showTooltip: false,
                    ),
                  ),
                  RepeatButton(
                    onLongPress: ref.read(_tvGameCtrl.notifier).canGoForward()
                        ? () => _moveForward(ref)
                        : null,
                    child: BottomBarButton(
                      key: const ValueKey('goto-next'),
                      icon: CupertinoIcons.chevron_forward,
                      label: context.l10n.next,
                      onTap: ref.read(_tvGameCtrl.notifier).canGoForward()
                          ? () => _moveForward(ref)
                          : null,
                      showTooltip: false,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _flipBoard(WidgetRef ref) {
    ref.read(_tvGameCtrl.notifier).toggleBoard();
  }

  void _moveBackward(WidgetRef ref) {
    ref.read(_tvGameCtrl.notifier).cursorBackward();
  }

  void _moveForward(WidgetRef ref) {
    ref.read(_tvGameCtrl.notifier).cursorForward();
  }
}
