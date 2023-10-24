import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/model/lobby/lobby_game.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/wakelock.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

import 'game_body.dart';
import 'ping_rating.dart';
import 'lobby_game_loading_board.dart';
import 'game_settings.dart';

final RouteObserver<PageRoute<void>> gameRouteObserver =
    RouteObserver<PageRoute<void>>();

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({
    required this.seek,
    super.key,
  });

  final GameSeek seek;

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen>
    with AndroidImmersiveMode, RouteAware, Wakelock {
  final _whiteClockKey = GlobalKey(debugLabel: 'whiteClockOnGameScreen');
  final _blackClockKey = GlobalKey(debugLabel: 'blackClockOnGameScreen');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null && route is PageRoute) {
      gameRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    gameRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {
    ref.invalidate(userRecentGamesProvider);
    ref.invalidate(accountProvider);
    ref.invalidate(userActivityProvider);
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = lobbyGameProvider(widget.seek);
    final gameId = ref.watch(gameProvider);

    return gameId.when(
      data: (id) {
        final ctrlProvider = gameControllerProvider(id);
        final gameState = ref.watch(ctrlProvider);
        return gameState.when(
          data: (state) {
            final body = GameBody(
              seek: widget.seek,
              id: id,
              gameState: state,
              whiteClockKey: _whiteClockKey,
              blackClockKey: _blackClockKey,
            );
            return PlatformWidget(
              androidBuilder: (context) => _androidBuilder(
                context: context,
                body: body,
                gameState: state,
                id: id,
              ),
              iosBuilder: (context) => _iosBuilder(
                context: context,
                body: body,
                gameState: state,
                id: id,
              ),
            );
          },
          loading: () => _loadingContent(),
          error: (e, s) {
            debugPrint(
              'SEVERE: [GameScreen] could not load game data; $e\n$s',
            );
            return _errorContent();
          },
        );
      },
      loading: () => _loadingContent(),
      error: (e, s) {
        debugPrint(
          'SEVERE: [GameScreen] could not create game; $e\n$s',
        );
        return _errorContent();
      },
    );
  }

  Widget _loadingContent() {
    return PlatformWidget(
      androidBuilder: (context) => _androidBuilder(
        context: context,
        body: LobbyGameLoadingBoard(widget.seek),
      ),
      iosBuilder: (context) => _iosBuilder(
        context: context,
        body: LobbyGameLoadingBoard(widget.seek),
      ),
    );
  }

  Widget _errorContent() {
    return PlatformWidget(
      androidBuilder: (context) => _androidBuilder(
        context: context,
        body: const CreateGameError(),
      ),
      iosBuilder: (context) => _iosBuilder(
        context: context,
        body: const CreateGameError(),
      ),
    );
  }

  Widget _androidBuilder({
    required BuildContext context,
    required Widget body,
    GameFullId? id,
    GameState? gameState,
  }) {
    return Scaffold(
      appBar: AppBar(
        leading: gameState == null || gameState.game.playable == true
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
                child: PingRating(size: 24.0),
              )
            : null,
        title: _GameTitle(seek: widget.seek),
        actions: [
          SettingsButton(
            onPressed: () => showAdaptiveBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (_) => GameSettings(id),
            ),
          ),
        ],
      ),
      body: body,
    );
  }

  Widget _iosBuilder({
    required BuildContext context,
    required Widget body,
    GameFullId? id,
    GameState? gameState,
  }) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        padding: const EdgeInsetsDirectional.only(end: 16.0),
        leading: gameState == null || gameState.game.playable == true
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: PingRating(size: 24.0),
              )
            : null,
        middle: _GameTitle(seek: widget.seek),
        trailing: SettingsButton(
          onPressed: () => showAdaptiveBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (_) => GameSettings(id),
          ),
        ),
      ),
      child: body,
    );
  }
}

class _GameTitle extends ConsumerWidget {
  const _GameTitle({
    required this.seek,
  });

  final GameSeek seek;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode =
        seek.rated ? ' • ${context.l10n.rated}' : ' • ${context.l10n.casual}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          seek.perf.icon,
          color: DefaultTextStyle.of(context).style.color,
        ),
        const SizedBox(width: 4.0),
        Text('${seek.timeIncrement.display}$mode'),
      ],
    );
  }
}
