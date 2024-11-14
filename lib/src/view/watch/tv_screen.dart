import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';
import 'package:lichess_mobile/src/model/tv/tv_controller.dart';
import 'package:lichess_mobile/src/utils/focus_detector.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/game/game_player.dart';
import 'package:lichess_mobile/src/view/settings/toggle_sound_button.dart';
import 'package:lichess_mobile/src/widgets/board_table.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/countdown_clock.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

class TvScreen extends ConsumerStatefulWidget {
  const TvScreen({required this.channel, this.initialGame, super.key});

  final TvChannel channel;
  final (GameId id, Side orientation)? initialGame;

  @override
  ConsumerState<TvScreen> createState() => _TvScreenState();
}

class _TvScreenState extends ConsumerState<TvScreen> {
  TvControllerProvider get _tvGameCtrl =>
      tvControllerProvider(widget.channel, widget.initialGame);

  final _whiteClockKey = GlobalKey(debugLabel: 'whiteClockOnTvScreen');
  final _blackClockKey = GlobalKey(debugLabel: 'blackClockOnTvScreen');

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusRegained: () {
        ref.read(_tvGameCtrl.notifier).startWatching();
      },
      onFocusLost: () {
        if (context.mounted) {
          ref.read(_tvGameCtrl.notifier).stopWatching();
        }
      },
      child: PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text('${widget.channel.label} TV'),
          actions: const [
            ToggleSoundButton(),
          ],
        ),
        body: _Body(
          widget.channel,
          widget.initialGame,
          whiteClockKey: _whiteClockKey,
          blackClockKey: _blackClockKey,
        ),
      ),
    );
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
                final position =
                    gameState.game.positionAt(gameState.stepCursor);

                final blackPlayerWidget = GamePlayer(
                  player: game.black.setOnGame(true),
                  clock: gameState.game.clock != null
                      ? CountdownClock(
                          key: blackClockKey,
                          timeLeft: gameState.game.clock!.black,
                          delay: gameState.game.clock!.lag ??
                              const Duration(milliseconds: 10),
                          clockUpdatedAt: gameState.game.clock!.at,
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
                          timeLeft: gameState.game.clock!.white,
                          clockUpdatedAt: gameState.game.clock!.at,
                          delay: gameState.game.clock!.lag ??
                              const Duration(milliseconds: 10),
                          active: gameState.activeClockSide == Side.white,
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
                  moves: game.steps
                      .skip(1)
                      .map((e) => e.sanMove!.san)
                      .toList(growable: false),
                  currentMoveIndex: gameState.stepCursor,
                  lastMove: game.moveAt(gameState.stepCursor),
                );
              },
              loading: () => const BoardTable(
                topTable: kEmptyWidget,
                bottomTable: kEmptyWidget,
                orientation: Side.white,
                fen: kEmptyFEN,
                showMoveListPlaceholder: true,
              ),
              error: (err, stackTrace) {
                debugPrint(
                  'SEVERE: [TvScreen] could not load stream; $err\n$stackTrace',
                );
                return const BoardTable(
                  topTable: kEmptyWidget,
                  bottomTable: kEmptyWidget,
                  orientation: Side.white,
                  fen: kEmptyFEN,
                  errorMessage: 'Could not load TV stream.',
                  showMoveListPlaceholder: true,
                );
              },
            ),
          ),
        ),
        _BottomBar(
          tvChannel: channel,
          game: initialGame,
        ),
      ],
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({
    required this.tvChannel,
    required this.game,
  });
  final TvChannel tvChannel;
  final (GameId id, Side orientation)? game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomBar(
      children: [
        BottomBarButton(
          label: context.l10n.flipBoard,
          onTap: () => _flipBoard(ref),
          icon: CupertinoIcons.arrow_2_squarepath,
        ),
        RepeatButton(
          onLongPress: ref
                  .read(tvControllerProvider(tvChannel, game).notifier)
                  .canGoBack()
              ? () => _moveBackward(ref)
              : null,
          child: BottomBarButton(
            key: const ValueKey('goto-previous'),
            onTap: ref
                    .read(
                      tvControllerProvider(tvChannel, game).notifier,
                    )
                    .canGoBack()
                ? () => _moveBackward(ref)
                : null,
            label: 'Previous',
            icon: CupertinoIcons.chevron_back,
            showTooltip: false,
          ),
        ),
        RepeatButton(
          onLongPress: ref
                  .read(tvControllerProvider(tvChannel, game).notifier)
                  .canGoForward()
              ? () => _moveForward(ref)
              : null,
          child: BottomBarButton(
            key: const ValueKey('goto-next'),
            icon: CupertinoIcons.chevron_forward,
            label: context.l10n.next,
            onTap: ref
                    .read(
                      tvControllerProvider(tvChannel, game).notifier,
                    )
                    .canGoForward()
                ? () => _moveForward(ref)
                : null,
            showTooltip: false,
          ),
        ),
      ],
    );
  }

  void _flipBoard(WidgetRef ref) {
    ref.read(tvControllerProvider(tvChannel, game).notifier).toggleBoard();
  }

  void _moveBackward(WidgetRef ref) {
    ref.read(tvControllerProvider(tvChannel, game).notifier).cursorBackward();
  }

  void _moveForward(WidgetRef ref) {
    ref.read(tvControllerProvider(tvChannel, game).notifier).cursorForward();
  }
}
