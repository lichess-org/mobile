import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_history.dart';
import 'package:lichess_mobile/src/model/lobby/create_game_service.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_loading_board.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'game_body.dart';
import 'game_common_widgets.dart';

part 'game_screen.g.dart';

@riverpod
class _LoadGame extends _$LoadGame {
  @override
  Future<(GameFullId?, DeclineReason?)> build(
    GameSeek? seek,
    ChallengeRequest? challenge,
    GameFullId? gameId,
  ) {
    assert(
      gameId != null || seek != null || challenge != null,
      'Either a seek, challenge or a game id must be provided.',
    );

    final service = ref.watch(createGameServiceProvider);

    if (seek != null) {
      return service.newLobbyGame(seek).then((id) => (id, null));
    } else if (challenge != null) {
      return service.newChallenge(challenge).then((c) => (c.$1, c.$2));
    }

    return Future.value((gameId!, null));
  }

  /// Search for a new opponent (lobby only).
  Future<void> newOpponent() async {
    if (seek != null) {
      final service = ref.read(createGameServiceProvider);
      state = const AsyncValue.loading();
      state = AsyncValue.data(
        await service.newLobbyGame(seek!).then((id) => (id, null)),
      );
    }
  }

  /// Load a game from its id.
  void loadGame(GameFullId id) {
    state = AsyncValue.data((id, null));
  }
}

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({
    this.seek,
    this.initialGameId,
    this.challenge,
    this.loadingFen,
    this.loadingLastMove,
    this.loadingOrientation,
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
    if (mounted &&
        (widget.source == _GameSource.lobby ||
            widget.source == _GameSource.challenge)) {
      ref.invalidate(myRecentGamesProvider);
      ref.invalidate(accountProvider);
    }
    super.didPop();
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider =
        _loadGameProvider(widget.seek, widget.challenge, widget.initialGameId);

    return ref.watch(gameProvider).when(
      data: (data) {
        final (gameId, declineReason) = data;
        final body = gameId != null
            ? GameBody(
                id: gameId,
                loadingBoardWidget: const StandaloneGameLoadingBoard(),
                whiteClockKey: _whiteClockKey,
                blackClockKey: _blackClockKey,
                boardKey: _boardKey,
                onLoadGameCallback: (id) {
                  ref.read(gameProvider.notifier).loadGame(id);
                },
                onNewOpponentCallback: (game) {
                  if (widget.source == _GameSource.lobby) {
                    ref.read(gameProvider.notifier).newOpponent();
                  } else {
                    final savedSetup = ref.read(gameSetupPreferencesProvider);
                    pushReplacementPlatformRoute(
                      context,
                      rootNavigator: true,
                      builder: (_) => GameScreen(
                        seek: GameSeek.newOpponentFromGame(game, savedSetup),
                      ),
                    );
                  }
                },
              )
            : widget.challenge != null
                ? ChallengeDeclinedBoard(
                    declineReason: declineReason != null
                        ? declineReasonMessage(context, declineReason)
                        : declineReasonMessage(context, DeclineReason.generic),
                    destUser: widget.challenge?.destUser,
                  )
                : const LoadGameError('Could not create the game.');
        return PlatformWidget(
          androidBuilder: (context) => Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: GameAppBar(id: gameId),
            body: body,
          ),
          iosBuilder: (context) => CupertinoPageScaffold(
            resizeToAvoidBottomInset: false,
            navigationBar: GameCupertinoNavBar(id: gameId),
            child: body,
          ),
        );
      },
      loading: () {
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
                : const StandaloneGameLoadingBoard();

        return PlatformWidget(
          androidBuilder: (context) => Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: GameAppBar(seek: widget.seek),
            body: PopScope(
              canPop: false,
              child: loadingBoard,
            ),
          ),
          iosBuilder: (context) => CupertinoPageScaffold(
            resizeToAvoidBottomInset: false,
            navigationBar: GameCupertinoNavBar(seek: widget.seek),
            child: PopScope(
              canPop: false,
              child: loadingBoard,
            ),
          ),
        );
      },
      error: (e, s) {
        debugPrint(
          'SEVERE: [GameScreen] could not create game; $e\n$s',
        );

        // lichess sends a 400 response if user has disallowed challenges
        final message = e is ServerException && e.statusCode == 400
            ? LoadGameError(
                'Could not create the game: ${e.jsonError?['error'] as String?}',
              )
            : const LoadGameError(
                'Sorry, we could not create the game. Please try again later.',
              );

        final body = PopScope(child: message);

        return PlatformWidget(
          androidBuilder: (context) => Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: GameAppBar(seek: widget.seek),
            body: body,
          ),
          iosBuilder: (context) => CupertinoPageScaffold(
            resizeToAvoidBottomInset: false,
            navigationBar: GameCupertinoNavBar(seek: widget.seek),
            child: body,
          ),
        );
      },
    );
  }
}
