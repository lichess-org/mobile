import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/chat/chat_mixin.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_board_params.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';
import 'package:lichess_mobile/src/model/tv/tv_controller.dart';
import 'package:lichess_mobile/src/model/tv/tv_game_controller.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/utils/chessboard.dart';
import 'package:lichess_mobile/src/utils/focus_detector.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/chat/chat_screen.dart';
import 'package:lichess_mobile/src/view/game/game_loading_board.dart';
import 'package:lichess_mobile/src/view/game/game_player.dart';
import 'package:lichess_mobile/src/view/settings/toggle_sound_button.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/clock.dart';
import 'package:lichess_mobile/src/widgets/game_layout.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/user.dart';

class TvScreen extends ConsumerStatefulWidget {
  const TvScreen({this.channel, this.initialGame, this.user, super.key})
    : assert(channel != null || user != null, 'Either channel or user must be provided');

  final TvChannel? channel;
  final (GameId id, Side orientation)? initialGame;
  final LightUser? user;

  static Route<dynamic> buildRoute({
    TvChannel? channel,
    GameId? gameId,
    LightUser? user,
    Side? orientation,
  }) {
    return buildScreenRoute(
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
  TvControllerParams get _tvControllerParams =>
      (channel: widget.channel, initialGame: widget.initialGame, userId: widget.user?.id);

  AsyncNotifierProvider<TvController, TvGameControllerParams> get _tvCtrl =>
      tvControllerProvider(_tvControllerParams);

  final _whiteClockKey = GlobalKey(debugLabel: 'whiteClockOnTvScreen');
  final _blackClockKey = GlobalKey(debugLabel: 'blackClockOnTvScreen');

  @override
  Widget build(BuildContext context) {
    final asyncGameParams = ref.watch(_tvCtrl);
    final gameParams = asyncGameParams.value;

    return FocusDetector(
      onFocusRegained: () {
        ref.read(_tvCtrl.notifier).onFocusRegained();
        if (gameParams != null) {
          ref.read(tvGameControllerProvider(gameParams).notifier).onFocusRegained();
        }
      },
      onForegroundLost: () {
        if (context.mounted && gameParams != null) {
          ref.read(tvGameControllerProvider(gameParams).notifier).onForegroundLost();
        }
      },
      child: WakelockWidget(
        child: Scaffold(
          appBar: AppBar(
            title: widget.channel != null
                ? Text('${widget.channel!.label(context.l10n)} TV')
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      UserFullNameWidget(user: widget.user),
                      const SizedBox(width: 4.0),
                      const Icon(Icons.live_tv),
                    ],
                  ),
            actions: [
              if (gameParams != null) _WatcherButton(gameParams: gameParams),
              const ToggleSoundButton(),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: asyncGameParams.when(
                    data: (gameParams) => _TvGameBody(
                      channel: widget.channel,
                      gameParams: gameParams,
                      whiteClockKey: _whiteClockKey,
                      blackClockKey: _blackClockKey,
                    ),
                    loading: () => const _TvLoadingBoard(),
                    error: (err, stackTrace) {
                      debugPrint('SEVERE: [TvScreen] could not load stream; $err\n$stackTrace');
                      return const _TvErrorBoard();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Displays the watched game once [TvController] has resolved which game to
/// watch.
class _TvGameBody extends ConsumerWidget {
  const _TvGameBody({
    required this.channel,
    required this.gameParams,
    required this.whiteClockKey,
    required this.blackClockKey,
  });

  final TvChannel? channel;
  final TvGameControllerParams gameParams;
  final GlobalKey whiteClockKey;
  final GlobalKey blackClockKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameCtrl = tvGameControllerProvider(gameParams);
    final asyncGame = ref.watch(gameCtrl);

    return asyncGame.when(
      data: (gameState) {
        final game = gameState.game;
        final position = gameState.game.positionAt(gameState.stepCursor);
        final clockTenths = ref.watch(
          accountPreferencesProvider.select((prefs) => prefs.value?.clockTenths),
        );

        final kidModeAsync = ref.watch(kidModeProvider);
        final canShowChat = channel == null && gameState.chatEnabled && kidModeAsync.value == false;

        final authUser = ref.watch(authControllerProvider);
        final chatOptions = TvChatOptions(gameParams, writeable: authUser != null);

        // If Stockfish is playing, user is null
        final crosstable = game.white.user != null && game.black.user != null
            ? ref.watch(
                crosstableProvider((
                  userId1: game.white.user!.id,
                  userId2: game.black.user!.id,
                  matchup: true,
                )),
              )
            : null;

        final crosstableData = crosstable?.value;
        final matchupData = crosstableData?.matchup;
        final blackPlayerWidget = GamePlayer(
          game: game.copyWith(black: game.black.setOnGame(true)),
          side: Side.black,
          matchupScore: matchupData?.users[game.black.user!.id],
          clock: gameState.game.clock != null
              ? CountdownClockBuilder(
                  key: blackClockKey,
                  timeLeft: gameState.game.clock!.black,
                  delay: gameState.game.clock!.lag ?? const Duration(milliseconds: 10),
                  clockUpdatedAt: gameState.game.clock!.at,
                  active: gameState.activeClockSide == Side.black,
                  builder: (context, timeLeft) {
                    return Clock(
                      timeLeft: timeLeft,
                      active: gameState.activeClockSide == Side.black,
                      clockTenths: clockTenths,
                    );
                  },
                )
              : null,
          materialDiff: game.materialDiffAt(gameState.stepCursor, Side.black),
        );
        final whitePlayerWidget = GamePlayer(
          game: game.copyWith(white: game.white.setOnGame(true)),
          side: Side.white,
          matchupScore: matchupData?.users[game.white.user!.id],
          clock: gameState.game.clock != null
              ? CountdownClockBuilder(
                  key: whiteClockKey,
                  timeLeft: gameState.game.clock!.white,
                  clockUpdatedAt: gameState.game.clock!.at,
                  delay: gameState.game.clock!.lag ?? const Duration(milliseconds: 10),
                  active: gameState.activeClockSide == Side.white,
                  builder: (context, timeLeft) {
                    return Clock(
                      timeLeft: timeLeft,
                      active: gameState.activeClockSide == Side.white,
                      clockTenths: clockTenths,
                    );
                  },
                )
              : null,
          materialDiff: game.materialDiffAt(gameState.stepCursor, Side.white),
        );

        return GameLayout(
          orientation: variantBoardOrientation(
            variant: gameState.game.meta.variant,
            youAre: gameState.orientation,
            isBoardTurned: false,
          ),
          boardParams: GameBoardParams.readonly(
            variant: gameState.game.meta.variant,
            position: position,
            lastMove: game.moveAt(gameState.stepCursor),
          ),
          boardSettingsOverrides: const BoardSettingsOverrides(animationDuration: Duration.zero),
          topTable: gameState.orientation == Side.white ? blackPlayerWidget : whitePlayerWidget,
          bottomTable: gameState.orientation == Side.white ? whitePlayerWidget : blackPlayerWidget,
          moves: game.steps.skip(1).map((e) => e.sanMove!.san).toList(growable: false),
          currentMoveIndex: gameState.stepCursor,
          onSelectMove: (index) {
            ref.read(gameCtrl.notifier).goToMove(index);
          },
          explosionSquares: gameState.stepCursor > 0
              ? atomicExplosionSquares(
                  game.positionAt(gameState.stepCursor - 1),
                  game.moveAt(gameState.stepCursor),
                )
              : null,
          userActionsBar: BottomBar(
            children: [
              BottomBarButton(
                label: context.l10n.flipBoard,
                onTap: () => ref.read(gameCtrl.notifier).toggleBoard(),
                icon: CupertinoIcons.arrow_2_squarepath,
              ),
              if (canShowChat) ChatBottomBarButton(options: chatOptions),
              RepeatButton(
                onLongPress: ref.read(gameCtrl.notifier).canGoBack()
                    ? () => ref.read(gameCtrl.notifier).cursorBackward()
                    : null,
                child: BottomBarButton(
                  key: const ValueKey('goto-previous'),
                  onTap: ref.read(gameCtrl.notifier).canGoBack()
                      ? () => ref.read(gameCtrl.notifier).cursorBackward()
                      : null,
                  label: 'Previous',
                  icon: CupertinoIcons.chevron_back,
                  showTooltip: false,
                ),
              ),
              RepeatButton(
                onLongPress: ref.read(gameCtrl.notifier).canGoForward()
                    ? () => ref.read(gameCtrl.notifier).cursorForward()
                    : null,
                child: BottomBarButton(
                  key: const ValueKey('goto-next'),
                  icon: CupertinoIcons.chevron_forward,
                  label: context.l10n.next,
                  onTap: ref.read(gameCtrl.notifier).canGoForward()
                      ? () => ref.read(gameCtrl.notifier).cursorForward()
                      : null,
                  showTooltip: false,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const _TvLoadingBoard(),
      error: (err, stackTrace) {
        debugPrint('SEVERE: [TvScreen] could not load stream; $err\n$stackTrace');
        return const _TvErrorBoard();
      },
    );
  }
}

class _TvLoadingBoard extends StatelessWidget {
  const _TvLoadingBoard();

  @override
  Widget build(BuildContext context) {
    return const Shimmer(
      child: GameLayout(
        topTable: LoadingPlayerWidget(),
        bottomTable: LoadingPlayerWidget(),
        orientation: Side.white,
        boardParams: GameBoardParams.emptyBoard,
        moves: [],
        userActionsBar: BottomBar.empty(),
      ),
    );
  }
}

class _TvErrorBoard extends StatelessWidget {
  const _TvErrorBoard();

  @override
  Widget build(BuildContext context) {
    return const GameLayout(
      orientation: Side.white,
      boardParams: GameBoardParams.emptyBoard,
      errorMessage: 'Could not load TV stream.',
      moves: [],
    );
  }
}

class _WatcherButton extends ConsumerWidget {
  const _WatcherButton({required this.gameParams});

  final TvGameControllerParams gameParams;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nb = ref.watch(
      tvGameControllerProvider(gameParams).select((s) => s.value?.nbWatchers ?? 0),
    );
    if (nb <= 0) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Badge(
        label: Text('$nb'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        textColor: Theme.of(context).colorScheme.onSurfaceVariant,
        child: const Icon(Icons.person_outlined),
      ),
    );
  }
}
