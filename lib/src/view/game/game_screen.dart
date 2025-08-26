import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/lobby/create_game_service.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup_preferences.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
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
/// The screen can be opened in three ways:
/// - From the lobby, to play a game with a random opponent: using [LobbySource].
/// - From a challenge, to accept or decline a challenge: using a [UserChallengeSource].
/// - From an existing game: using [ExistingGameSource].
///
/// The screen will show a loading board while the game is being created.
class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({required this.source, this.loadingPosition, this.lastMoveAt, super.key});

  final GameScreenSource source;

  final LoadingPosition? loadingPosition;

  /// The date of the last move played in the game. If null, the game is in progress.
  final DateTime? lastMoveAt;

  static Route<dynamic> buildRoute(
    BuildContext context, {
    required GameScreenSource source,
    LoadingPosition? loadingPosition,
    DateTime? lastMoveAt,
  }) {
    return buildScreenRoute(
      context,
      screen: GameScreen(source: source, loadingPosition: loadingPosition, lastMoveAt: lastMoveAt),
    );
  }

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  final _whiteClockKey = GlobalKey(debugLabel: 'whiteClockOnGameScreen');
  final _blackClockKey = GlobalKey(debugLabel: 'blackClockOnGameScreen');
  final _boardKey = GlobalKey(debugLabel: 'boardOnGameScreen');

  @override
  Widget build(BuildContext context) {
    final boardPreferences = ref.watch(boardPreferencesProvider);

    switch (ref.watch(gameScreenLoaderProvider(widget.source))) {
      case AsyncData(
        value: ChallengeDeclinedState(
          response: ChallengeDeclinedResponse(:final challenge, :final declineReason),
        ),
      ):
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: _ChallengeGameTitle(
              challenge: (widget.source as UserChallengeSource).challengeRequest,
            ),
          ),
          body: ChallengeDeclinedBoard(
            challenge: challenge,
            declineReason: declineReason != null
                ? declineReason.label(context.l10n)
                : ChallengeDeclineReason.generic.label(context.l10n),
          ),
        );
      case AsyncData(value: GameCreatedState(:final createdGameId)):
        final isRealTimePlayingGame =
            ref.watch(isRealTimePlayableGameProvider(createdGameId)).valueOrNull ?? false;

        final socketUri = GameController.socketUri(createdGameId);

        final body = PopScope(
          canPop: isRealTimePlayingGame != true,
          child: SafeArea(
            // view padding can change on Android when immersive mode is enabled, so to prevent any
            // board vertical shift, we set `maintainBottomViewPadding` to true.
            maintainBottomViewPadding: true,
            child: GameBody(
              gameId: createdGameId,
              // Only show the initial loading position if this is still the game that the GameScreen
              // was created for. This will not be the case when searching for a new opponent after the game.
              loadingPosition: switch (widget.source) {
                ExistingGameSource(:final id) when id == createdGameId => widget.loadingPosition,
                _ => null,
              },
              whiteClockKey: _whiteClockKey,
              blackClockKey: _blackClockKey,
              boardKey: _boardKey,
              onLoadGameCallback: (id) {
                if (mounted) {
                  ref.read(gameScreenLoaderProvider(widget.source).notifier).loadGame(id);
                }
              },
              onNewOpponentCallback: (game) {
                if (!mounted) return;

                if (widget.source is LobbySource) {
                  ref.read(gameScreenLoaderProvider(widget.source).notifier).newOpponent();
                } else {
                  final savedSetup = ref.read(gameSetupPreferencesProvider);
                  Navigator.of(context, rootNavigator: true).pushReplacement(
                    GameScreen.buildRoute(
                      context,
                      source: LobbySource(GameSeek.newOpponentFromGame(game, savedSetup)),
                    ),
                  );
                }
              },
            ),
          ),
        );

        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: isRealTimePlayingGame ? SocketPingRatingIcon(socketUri: socketUri) : null,
            title: _StandaloneGameTitle(id: createdGameId, lastMoveAt: widget.lastMoveAt),
            actions: [_GameMenu(gameId: createdGameId)],
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
            leading: const SocketPingRatingIcon(),
            title: switch (widget.source) {
              LobbySource(:final seek) => _LobbyGameTitle(seek: seek),
              UserChallengeSource(:final challengeRequest) => _ChallengeGameTitle(
                challenge: challengeRequest,
              ),
              _ => const SizedBox.shrink(),
            },
          ),
          body: PopScope(child: message),
        );
      case _:
        final loadingBoard = switch (widget.source) {
          LobbySource(:final seek) => LobbyScreenLoadingContent(
            seek,
            () => ref.read(createGameServiceProvider).cancelSeek(),
          ),
          UserChallengeSource(:final challengeRequest) => ChallengeLoadingContent(
            challengeRequest,
            () => ref.read(createGameServiceProvider).cancelChallenge(),
          ),
          ExistingGameSource() => StandaloneGameLoadingContent(
            position: widget.loadingPosition,
            userActionsBar: const BottomBar.empty(),
          ),
        };

        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: const SocketPingRatingIcon(),
            title: switch (widget.source) {
              LobbySource(:final seek) => _LobbyGameTitle(seek: seek),
              UserChallengeSource(:final challengeRequest) => _ChallengeGameTitle(
                challenge: challengeRequest,
              ),
              _ => const SizedBox.shrink(),
            },
          ),
          body: PopScope(canPop: false, child: loadingBoard),
        );
    }
  }
}

class _GameMenu extends ConsumerWidget {
  const _GameMenu({required this.gameId});

  final GameFullId gameId;

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
        ToggleSoundContextMenuAction(
          isEnabled: ref.watch(generalPreferencesProvider.select((prefs) => prefs.isSoundEnabled)),
          onPressed: () => ref.read(generalPreferencesProvider.notifier).toggleSoundEnabled(),
        ),
        GameBookmarkContextMenuAction(
          id: gameId.gameId,
          bookmarked: isBookmarkedAsync.valueOrNull ?? false,
          onToggleBookmark: () =>
              ref.read(gameControllerProvider(gameId).notifier).toggleBookmark(),
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
