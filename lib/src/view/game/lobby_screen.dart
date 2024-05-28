import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_history.dart';
import 'package:lichess_mobile/src/model/lobby/create_game_service.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_body.dart';
import 'package:lichess_mobile/src/view/game/game_common_widgets.dart';
import 'package:lichess_mobile/src/view/game/game_loading_board.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lobby_screen.g.dart';

@riverpod
class _LobbyGame extends _$LobbyGame {
  @override
  Future<(GameFullId, {bool fromRematch})> build(GameSeek seek) {
    final service = ref.read(createGameServiceProvider);
    ref.onDispose(() {
      service.dispose();
    });
    return service.newLobbyGame(seek).then((id) => (id, fromRematch: false));
  }

  void rematch(GameFullId id) {
    state = AsyncValue.data((id, fromRematch: true));
  }
}

/// Screen for games created from the lobby.
class LobbyScreen extends ConsumerStatefulWidget {
  const LobbyScreen({
    required this.seek,
    super.key,
  });

  final GameSeek seek;

  @override
  ConsumerState<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends ConsumerState<LobbyScreen> with RouteAware {
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
    super.didPop();
    if (mounted) {
      ref.invalidate(myRecentGamesProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    // `.unwrapPrevious()` is mandatory here because we want to discard the
    // previous game and show the loading board while searching for a new
    // opponent.
    final gameIdAsync =
        ref.watch(_lobbyGameProvider(widget.seek)).unwrapPrevious();

    return gameIdAsync.when(
      data: (data) {
        final (gameId, fromRematch: _) = data;
        final body = GameBody(
          id: gameId,
          loadingBoardWidget: const StandaloneGameLoadingBoard(),
          whiteClockKey: _whiteClockKey,
          blackClockKey: _blackClockKey,
          boardKey: _boardKey,
          onLoadGameCallback: (id) {
            ref.read(_lobbyGameProvider(widget.seek).notifier).rematch(id);
          },
          onNewOpponentCallback: (_) {
            ref.invalidate(_lobbyGameProvider(widget.seek));
          },
        );
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
      loading: () => PlatformWidget(
        androidBuilder: (context) => Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: GameAppBar(seek: widget.seek),
          body: PopScope(
            canPop: false,
            child: LobbyScreenLoadingContent(
              widget.seek,
              () => ref.read(createGameServiceProvider).cancel(),
            ),
          ),
        ),
        iosBuilder: (context) => CupertinoPageScaffold(
          resizeToAvoidBottomInset: false,
          navigationBar: GameCupertinoNavBar(seek: widget.seek),
          child: PopScope(
            canPop: false,
            child: LobbyScreenLoadingContent(
              widget.seek,
              () => ref.read(createGameServiceProvider).cancel(),
            ),
          ),
        ),
      ),
      error: (e, s) {
        debugPrint(
          'SEVERE: [LobbyGameScreen] could not create game; $e\n$s',
        );
        const body = PopScope(
          child: LoadGameError(
            'Sorry, we could not create the game. Please try again later.',
          ),
        );
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
