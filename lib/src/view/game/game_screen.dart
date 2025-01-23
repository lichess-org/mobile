import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_history.dart';
import 'package:lichess_mobile/src/model/lobby/create_game_service.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup_preferences.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_body.dart';
import 'package:lichess_mobile/src/view/game/game_common_widgets.dart';
import 'package:lichess_mobile/src/view/game/game_loading_board.dart';
import 'package:lichess_mobile/src/view/game/game_screen_providers.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

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
    super.key,
  }) : assert(
         initialGameId != null || seek != null || challenge != null,
         'Either a seek, a challenge or an initial game id must be provided.',
       );

  // tweak
  final GameSeek? seek;

  final GameFullId? initialGameId;

  final ChallengeRequest? challenge;

  final String? loadingFen;
  final Move? loadingLastMove;
  final Side? loadingOrientation;

  /// The date of the last move played in the game. If null, the game is in progress.
  final DateTime? lastMoveAt;

  _GameSource get source {
    if (initialGameId != null) {
      return _GameSource.game;
    } else if (challenge != null) {
      return _GameSource.challenge;
    } else {
      return _GameSource.lobby;
    }
  }

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

enum _GameSource { lobby, challenge, game }

class _GameScreenState extends ConsumerState<GameScreen> with RouteAware {
  final _whiteClockKey = GlobalKey(debugLabel: 'whiteClockOnGameScreen');
  final _blackClockKey = GlobalKey(debugLabel: 'blackClockOnGameScreen');
  final _boardKey = GlobalKey(debugLabel: 'boardOnGameScreen');

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
    rootNavPageRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {
    if (mounted && (widget.source == _GameSource.lobby || widget.source == _GameSource.challenge)) {
      ref.invalidate(myRecentGamesProvider);
      ref.invalidate(accountProvider);
    }
    super.didPop();
  }

  @override
  Widget build(BuildContext context) {
    final provider = currentGameProvider(widget.seek, widget.challenge, widget.initialGameId);

    return ref
        .watch(provider)
        .when(
          data: (data) {
            final (gameFullId: gameId, challenge: challenge, declineReason: declineReason) = data;
            final body =
                gameId != null
                    ? GameBody(
                      id: gameId,
                      loadingBoardWidget: StandaloneGameLoadingBoard(
                        fen: widget.loadingFen,
                        lastMove: widget.loadingLastMove,
                        orientation: widget.loadingOrientation,
                      ),
                      whiteClockKey: _whiteClockKey,
                      blackClockKey: _blackClockKey,
                      boardKey: _boardKey,
                      onLoadGameCallback: (id) {
                        ref.read(provider.notifier).loadGame(id);
                      },
                      onNewOpponentCallback: (game) {
                        if (widget.source == _GameSource.lobby) {
                          ref.read(provider.notifier).newOpponent();
                        } else {
                          final savedSetup = ref.read(gameSetupPreferencesProvider);
                          pushReplacementPlatformRoute(
                            context,
                            rootNavigator: true,
                            builder:
                                (_) => GameScreen(
                                  seek: GameSeek.newOpponentFromGame(game, savedSetup),
                                ),
                          );
                        }
                      },
                    )
                    : widget.challenge != null && challenge != null
                    ? ChallengeDeclinedBoard(
                      challenge: challenge,
                      declineReason:
                          declineReason != null
                              ? declineReason.label(context.l10n)
                              : ChallengeDeclineReason.generic.label(context.l10n),
                    )
                    : const LoadGameError('Could not create the game.');
            return PlatformBoardThemeScaffold(
              resizeToAvoidBottomInset: false,
              appBar: GameAppBar(id: gameId, lastMoveAt: widget.lastMoveAt),
              body: body,
            );
          },
          loading: () {
            final loadingBoard =
                widget.seek != null
                    ? LobbyScreenLoadingContent(
                      widget.seek!,
                      () => ref.read(createGameServiceProvider).cancelSeek(),
                    )
                    : widget.challenge != null
                    ? ChallengeLoadingContent(
                      widget.challenge!,
                      () => ref.read(createGameServiceProvider).cancelChallenge(),
                    )
                    : const StandaloneGameLoadingBoard();

            return PlatformBoardThemeScaffold(
              resizeToAvoidBottomInset: false,
              appBar: GameAppBar(seek: widget.seek, lastMoveAt: widget.lastMoveAt),
              body: PopScope(canPop: false, child: loadingBoard),
            );
          },
          error: (e, s) {
            debugPrint('SEVERE: [GameScreen] could not create game; $e\n$s');

            // lichess sends a 400 response if user has disallowed challenges
            final message =
                e is ServerException && e.statusCode == 400
                    ? LoadGameError(
                      'Could not create the game: ${e.jsonError?['error'] as String?}',
                    )
                    : const LoadGameError(
                      'Sorry, we could not create the game. Please try again later.',
                    );

            final body = PopScope(child: message);

            return PlatformBoardThemeScaffold(
              appBar: GameAppBar(seek: widget.seek, lastMoveAt: widget.lastMoveAt),
              body: body,
            );
          },
        );
  }
}
