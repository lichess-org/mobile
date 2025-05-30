import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/game/game_filter.dart';
import 'package:lichess_mobile/src/model/lobby/create_game_service.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup_preferences.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/gestures_exclusion.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_body.dart';
import 'package:lichess_mobile/src/view/game/game_common_widgets.dart';
import 'package:lichess_mobile/src/view/game/game_loading_board.dart';
import 'package:lichess_mobile/src/view/game/game_screen_providers.dart';
import 'package:lichess_mobile/src/view/game/game_settings.dart';
import 'package:lichess_mobile/src/view/settings/toggle_sound_button.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/clock.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

/// Screen to play a game, or to show a challenge or to show current user's past games.
///
/// The screen can be created in three ways:
/// - From the lobby, to play a game with a random opponent: using a [GameSeek] as [seek].
/// - From a challenge, to accept or decline a challenge: using a [ChallengeRequest] as [challenge].
/// - From a game id, to show a game that is already in progress: using a [GameFullId] as [initialGameId].
///
/// The screen will show a loading board while the game is being created.
class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({
    this.seek,
    this.initialGameId,
    this.challenge,
    this.loadingFen,
    this.loadingLastMove,
    this.loadingOrientation,
    this.lastMoveAt,
    this.gameListContext,
    super.key,
  }) : assert(
         initialGameId != null || seek != null || challenge != null,
         'Either a seek, a challenge or an initial game id must be provided.',
       );

  final GameSeek? seek;
  final GameFullId? initialGameId;
  final ChallengeRequest? challenge;

  final String? loadingFen;
  final Move? loadingLastMove;
  final Side? loadingOrientation;

  /// The date of the last move played in the game. If null, the game is in progress.
  final DateTime? lastMoveAt;

  /// The context of the game list that opened this screen, if available.
  final (UserId?, GameFilterState)? gameListContext;

  _GameSource get source {
    if (initialGameId != null) {
      return _GameSource.game;
    } else if (challenge != null) {
      return _GameSource.challenge;
    } else {
      return _GameSource.lobby;
    }
  }

  static Route<dynamic> buildRoute(
    BuildContext context, {
    GameSeek? seek,
    GameFullId? initialGameId,
    ChallengeRequest? challenge,
    String? loadingFen,
    Move? loadingLastMove,
    Side? loadingOrientation,
    DateTime? lastMoveAt,
    (UserId?, GameFilterState)? gameListContext,
  }) {
    return buildScreenRoute(
      context,
      screen: GameScreen(
        seek: seek,
        initialGameId: initialGameId,
        challenge: challenge,
        loadingFen: loadingFen,
        loadingLastMove: loadingLastMove,
        loadingOrientation: loadingOrientation,
        lastMoveAt: lastMoveAt,
        gameListContext: gameListContext,
      ),
    );
  }

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

enum _GameSource { lobby, challenge, game }

class _GameScreenState extends ConsumerState<GameScreen> {
  final _whiteClockKey = GlobalKey(debugLabel: 'whiteClockOnGameScreen');
  final _blackClockKey = GlobalKey(debugLabel: 'blackClockOnGameScreen');
  final _boardKey = GlobalKey(debugLabel: 'boardOnGameScreen');

  @override
  Widget build(BuildContext context) {
    final provider = currentGameProvider(
      seek: widget.seek,
      challenge: widget.challenge,
      game: widget.initialGameId != null
          ? (
              gameId: widget.initialGameId!,
              lastFen: widget.loadingFen,
              lastMove: widget.loadingLastMove,
              side: widget.loadingOrientation,
            )
          : null,
    );
    final boardPreferences = ref.watch(boardPreferencesProvider);

    switch (ref.watch(provider)) {
      case AsyncData(:final value):
        final (game: loadedGame, challenge: challenge, declineReason: declineReason) = value;
        final isRealTimePlayingGame =
            (loadedGame != null
                    ? ref.watch(isRealTimePlayableGameProvider(loadedGame.gameId))
                    : const AsyncValue.data(true))
                .valueOrNull ??
            false;

        final socketUri = loadedGame != null ? GameController.socketUri(loadedGame.gameId) : null;

        final body = PopScope(
          canPop: isRealTimePlayingGame != true,
          child: SafeArea(
            // view padding can change on Android when immersive mode is enabled, so to prevent any
            // board vertical shift, we set `maintainBottomViewPadding` to true.
            maintainBottomViewPadding: true,
            child: loadedGame != null
                ? GameBody(
                    loadedGame: loadedGame,
                    whiteClockKey: _whiteClockKey,
                    blackClockKey: _blackClockKey,
                    boardKey: _boardKey,
                    onLoadGameCallback: (id) {
                      if (mounted) {
                        ref.read(provider.notifier).loadGame(id);
                      }
                    },
                    onNewOpponentCallback: (game) {
                      if (!mounted) return;

                      if (widget.source == _GameSource.lobby) {
                        ref.read(provider.notifier).newOpponent();
                      } else {
                        final savedSetup = ref.read(gameSetupPreferencesProvider);
                        Navigator.of(context, rootNavigator: true).pushReplacement(
                          GameScreen.buildRoute(
                            context,
                            seek: GameSeek.newOpponentFromGame(game, savedSetup),
                          ),
                        );
                      }
                    },
                  )
                : widget.challenge != null && challenge != null
                ? ChallengeDeclinedBoard(
                    challenge: challenge,
                    declineReason: declineReason != null
                        ? declineReason.label(context.l10n)
                        : ChallengeDeclineReason.generic.label(context.l10n),
                  )
                : const LoadGameError('Could not create the game.'),
          ),
        );

        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: isRealTimePlayingGame ? SocketPingRating(socketUri: socketUri) : null,
            title: loadedGame != null
                ? _StandaloneGameTitle(id: loadedGame.gameId, lastMoveAt: widget.lastMoveAt)
                : widget.seek != null
                ? _LobbyGameTitle(seek: widget.seek!)
                : widget.challenge != null
                ? _ChallengeGameTitle(challenge: widget.challenge!)
                : const SizedBox.shrink(),

            actions: [
              if (loadedGame != null)
                _GameMenu(gameId: loadedGame.gameId, gameListContext: widget.gameListContext),
            ],
          ),
          body: Theme.of(context).platform == TargetPlatform.android
              ? AndroidGesturesExclusionWidget(
                  boardKey: _boardKey,
                  shouldExcludeGesturesOnFocusGained: () => isRealTimePlayingGame,
                  shouldSetImmersiveMode: boardPreferences.immersiveModeWhilePlaying ?? false,
                  child: body,
                )
              : body,
        );
      case AsyncError(error: final e, stackTrace: final s):
        debugPrint('SEVERE: [GameScreen] could not create game; $e\n$s');

        // lichess sends a 400 response if user has not allowed challenges
        final message = e is ServerException && e.statusCode == 400
            ? LoadGameError('Could not create the game: ${e.jsonError?['error'] as String?}')
            : const LoadGameError('Sorry, we could not create the game. Please try again later.');

        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: const SocketPingRating(),
            title: widget.seek != null
                ? _LobbyGameTitle(seek: widget.seek!)
                : widget.challenge != null
                ? _ChallengeGameTitle(challenge: widget.challenge!)
                : const SizedBox.shrink(),
          ),
          body: PopScope(child: message),
        );
      case _:
        final loadingBoard = widget.seek != null
            ? LobbyScreenLoadingContent(
                widget.seek!,
                () => ref.read(createGameServiceProvider).cancelSeek(),
              )
            : widget.challenge != null
            ? ChallengeLoadingContent(
                widget.challenge!,
                () => ref.read(createGameServiceProvider).cancelChallenge(),
              )
            : const Column(
                children: [
                  Expanded(child: StandaloneGameLoadingBoard()),
                  BottomBar.empty(),
                ],
              );

        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: const SocketPingRating(),
            title: widget.seek != null
                ? _LobbyGameTitle(seek: widget.seek!)
                : widget.challenge != null
                ? _ChallengeGameTitle(challenge: widget.challenge!)
                : const SizedBox.shrink(),
          ),
          body: PopScope(canPop: false, child: loadingBoard),
        );
    }
  }
}

class _GameMenu extends ConsumerWidget {
  const _GameMenu({required this.gameId, this.gameListContext});

  final GameFullId gameId;
  final (UserId?, GameFilterState)? gameListContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBookmarkedAsync = ref.watch(isGameBookmarkedProvider(gameId));

    return ContextMenuIconButton(
      icon: const Icon(Icons.more_horiz),
      semanticsLabel: context.l10n.menu,
      actions: [
        ContextMenuAction(
          icon: Icons.settings,
          label: context.l10n.settingsSettings,
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            isDismissible: true,
            isScrollControlled: true,
            builder: (_) => GameSettings(id: gameId),
          ),
        ),
        const ToggleSoundContextMenuAction(),
        GameBookmarkContextMenuAction(
          id: gameId.gameId,
          bookmarked: isBookmarkedAsync.valueOrNull ?? false,
          onToggleBookmark: () =>
              ref.read(gameControllerProvider(gameId).notifier).toggleBookmark(),
          gameListContext: gameListContext,
        ),
        ...(switch (ref.watch(gameShareDataProvider(gameId))) {
          AsyncData(:final value) =>
            value.finished
                ? makeFinishedGameShareContextMenuActions(
                    context,
                    ref,
                    gameId: gameId.gameId,
                    orientation: value.pov ?? Side.white,
                  )
                : [],
          _ => [],
        }),
      ],
    );
  }
}

class _LobbyGameTitle extends ConsumerWidget {
  const _LobbyGameTitle({required this.seek});

  final GameSeek seek;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = seek.rated ? ' • ${context.l10n.rated}' : ' • ${context.l10n.casual}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(seek.perf.icon, color: DefaultTextStyle.of(context).style.color),
        const SizedBox(width: 4.0),
        Text('${seek.timeIncrement?.display}$mode'),
      ],
    );
  }
}

class _ChallengeGameTitle extends ConsumerWidget {
  const _ChallengeGameTitle({required this.challenge});

  final ChallengeRequest challenge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = challenge.rated ? ' • ${context.l10n.rated}' : ' • ${context.l10n.casual}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(challenge.perf.icon, color: DefaultTextStyle.of(context).style.color),
        const SizedBox(width: 4.0),
        if (challenge.timeIncrement != null)
          Text('${challenge.timeIncrement?.display}$mode')
        else if (challenge.days != null)
          Text('${context.l10n.nbDays(challenge.days!)}$mode'),
      ],
    );
  }
}

class _TournamentGameTitle extends ConsumerWidget {
  const _TournamentGameTitle(this.tournament);

  final TournamentMeta tournament;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: AppBarTitleText(tournament.name)),
        CountdownClockBuilder(
          timeLeft: tournament.clock.timeLeft,
          clockUpdatedAt: tournament.clock.at,
          active: true,
          tickInterval: const Duration(seconds: 1),
          builder: (BuildContext context, Duration timeLeft) => Center(
            child: Text(
              '${timeLeft.toHoursMinutesSeconds()} ',
              style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
            ),
          ),
        ),
      ],
    );
  }
}

class _StandaloneGameTitle extends ConsumerWidget {
  const _StandaloneGameTitle({required this.id, this.lastMoveAt});

  final GameFullId id;

  final DateTime? lastMoveAt;

  static final _gameTitledateFormat = DateFormat.yMMMd();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metaAsync = ref.watch(gameMetaProvider(id));
    return metaAsync.when(
      data: (meta) {
        if (meta.tournament?.isOngoing == true) {
          return _TournamentGameTitle(meta.tournament!);
        }

        final mode = meta.rated ? ' • ${context.l10n.rated}' : ' • ${context.l10n.casual}';

        final info = lastMoveAt != null ? ' • ${_gameTitledateFormat.format(lastMoveAt!)}' : mode;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(meta.perf.icon, color: DefaultTextStyle.of(context).style.color),
            const SizedBox(width: 4.0),
            if (meta.clock != null)
              Flexible(
                child: AppBarTitleText(
                  '${TimeIncrement(meta.clock!.initial.inSeconds, meta.clock!.increment.inSeconds).display}$info',
                ),
              )
            else if (meta.daysPerTurn != null)
              Flexible(child: AppBarTitleText('${context.l10n.nbDays(meta.daysPerTurn!)}$info'))
            else
              Flexible(child: AppBarTitleText('${meta.perf.title}$info')),
          ],
        );
      },
      loading: () => Shimmer(
        child: ShimmerLoading(
          isLoading: true,
          child: SizedBox(
            height: 24.0,
            width: 200.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
      ),
      error: (error, _) => const SizedBox.shrink(),
    );
  }
}
