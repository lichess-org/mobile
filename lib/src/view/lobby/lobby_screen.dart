import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/lobby/create_game_service.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
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
    ref.onDispose(() {
      _service.cancel();
    });
    return _service.newLobbyGame(seek).then((id) => (id, fromRematch: false));
  }

  void rematch(GameFullId id) {
    state = AsyncValue.data((id, fromRematch: true));
  }

  CreateGameService get _service => ref.read(createGameServiceProvider);
}

/// Screen for games created from the lobby.
class LobbyScreen extends ConsumerStatefulWidget {
  const LobbyScreen({
    required this.seek,
    super.key,
  });

  final GameSeek seek;

  @override
  ConsumerState<LobbyScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<LobbyScreen>
    with RouteAware, ImmersiveMode {
  final _whiteClockKey = GlobalKey(debugLabel: 'whiteClockOnGameScreen');
  final _blackClockKey = GlobalKey(debugLabel: 'blackClockOnGameScreen');

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
    ref.invalidate(accountRecentGamesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final gameIdAsync = ref.watch(_lobbyGameProvider(widget.seek));
    return gameIdAsync.when(
      data: (data) {
        final (gameId, fromRematch: isRematch) = data;
        final body = GameBody(
          seek: widget.seek,
          id: gameId,
          loadingBoardWidget: isRematch
              ? const StandaloneGameLoadingBoard()
              : LobbyGameLoadingBoard(widget.seek),
          whiteClockKey: _whiteClockKey,
          blackClockKey: _blackClockKey,
          loadGameCallback: (id) {
            ref.read(_lobbyGameProvider(widget.seek).notifier).rematch(id);
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
            child: LobbyGameLoadingBoard(widget.seek),
          ),
        ),
        iosBuilder: (context) => CupertinoPageScaffold(
          resizeToAvoidBottomInset: false,
          navigationBar: GameCupertinoNavBar(seek: widget.seek),
          child: PopScope(
            canPop: false,
            child: LobbyGameLoadingBoard(widget.seek),
          ),
        ),
      ),
      error: (e, s) {
        debugPrint(
          'SEVERE: [LobbyGameScreen] could not create game; $e\n$s',
        );
        const body = PopScope(
          child: LoadGameError(),
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
