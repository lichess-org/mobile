import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
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
import 'game_loading_board.dart';
import 'game_settings.dart';
import 'game_screen_providers.dart';

/// Screen for games created from the lobby.
///
/// This screen watches the [lobbyGameProvider] for the game id. A new game is
/// created upon entering the screen, and each time the "new opponent" button
/// is pressed.
class LobbyGameScreen extends ConsumerStatefulWidget {
  const LobbyGameScreen({
    required this.seek,
    super.key,
  });

  final GameSeek seek;

  @override
  ConsumerState<LobbyGameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<LobbyGameScreen>
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
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    final isPlayableAsync = ref.watch(lobbyGameIsPlayableProvider(widget.seek));
    const pingRating = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
      child: PingRating(size: 24.0),
    );
    return Scaffold(
      appBar: AppBar(
        leading: isPlayableAsync.maybeWhen<Widget?>(
          data: (isPlayable) => isPlayable ? pingRating : null,
          orElse: () => pingRating,
        ),
        title: _GameTitle(seek: widget.seek),
        actions: [
          SettingsButton(
            onPressed: () => showAdaptiveBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (_) => GameSettings(seek: widget.seek),
            ),
          ),
        ],
      ),
      body: _LoadLobbyGame(
        seek: widget.seek,
        whiteClockKey: _whiteClockKey,
        blackClockKey: _blackClockKey,
      ),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    final isPlayableAsync = ref.watch(lobbyGameIsPlayableProvider(widget.seek));
    const pingRating = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: PingRating(size: 24.0),
    );

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        padding: const EdgeInsetsDirectional.only(end: 16.0),
        leading: isPlayableAsync.maybeWhen<Widget?>(
          data: (isPlayable) => isPlayable ? pingRating : null,
          orElse: () => pingRating,
        ),
        middle: _GameTitle(seek: widget.seek),
        trailing: SettingsButton(
          onPressed: () => showAdaptiveBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (_) => GameSettings(seek: widget.seek),
          ),
        ),
      ),
      child: _LoadLobbyGame(
        seek: widget.seek,
        whiteClockKey: _whiteClockKey,
        blackClockKey: _blackClockKey,
      ),
    );
  }
}

class _LoadLobbyGame extends ConsumerWidget {
  const _LoadLobbyGame({
    required this.seek,
    required this.whiteClockKey,
    required this.blackClockKey,
  });

  final GameSeek seek;
  final GlobalKey whiteClockKey;
  final GlobalKey blackClockKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameIdAsync = ref.watch(lobbyGameProvider(seek));
    return gameIdAsync.when(
      data: (data) {
        final (gameId, fromRematch: isRematch) = data;
        return GameBody(
          seek: seek,
          id: gameId,
          whiteClockKey: whiteClockKey,
          blackClockKey: blackClockKey,
          isRematch: isRematch,
        );
      },
      loading: () => WillPopScope(
        onWillPop: () async => false,
        child: LobbyGameLoadingBoard(seek),
      ),
      error: (e, s) {
        debugPrint(
          'SEVERE: [GameBody] could not load game data; $e\n$s',
        );
        return const WillPopScope(
          onWillPop: null,
          child: LoadGameError(),
        );
      },
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
