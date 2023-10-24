import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/wakelock.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

import 'game_body.dart';
import 'game_loading_board.dart';
import 'ping_rating.dart';
import 'game_settings.dart';

class StandaloneGameScreen extends ConsumerStatefulWidget {
  const StandaloneGameScreen({
    required this.id,
    required this.orientation,
    this.initialFen,
    this.lastMove,
    super.key,
  });

  final GameFullId id;
  final Side orientation;
  final String? initialFen;
  final Move? lastMove;

  @override
  ConsumerState<StandaloneGameScreen> createState() =>
      _StandaloneGameScreenState();
}

class _StandaloneGameScreenState extends ConsumerState<StandaloneGameScreen>
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
    final ctrlProvider = gameControllerProvider(widget.id);
    final gameState = ref.watch(ctrlProvider);

    return gameState.when(
      data: (state) {
        final body = GameBody(
          id: widget.id,
          gameState: state,
          whiteClockKey: _whiteClockKey,
          blackClockKey: _blackClockKey,
        );

        return PlatformWidget(
          androidBuilder: (context) => _androidBuilder(
            context: context,
            body: body,
            gameState: state,
          ),
          iosBuilder: (context) => _iosBuilder(
            context: context,
            body: body,
            gameState: state,
          ),
        );
      },
      loading: () {
        return PlatformWidget(
          androidBuilder: (context) => _androidBuilder(
            context: context,
            body: WillPopScope(
              onWillPop: () async => false,
              child: StandaloneGameLoadingBoard(
                orientation: widget.orientation,
                initialFen: widget.initialFen,
                lastMove: widget.lastMove,
              ),
            ),
          ),
          iosBuilder: (context) => _iosBuilder(
            context: context,
            body: WillPopScope(
              onWillPop: () async => false,
              child: StandaloneGameLoadingBoard(
                orientation: widget.orientation,
                initialFen: widget.initialFen,
                lastMove: widget.lastMove,
              ),
            ),
          ),
        );
      },
      error: (e, s) {
        debugPrint(
          'SEVERE: [StandaloneGameScreen] could not load game data; $e\n$s',
        );
        return WillPopScope(
          onWillPop: () async => true,
          child: LoadGameError(initialFen: widget.initialFen),
        );
      },
    );
  }

  Widget _androidBuilder({
    required BuildContext context,
    required Widget body,
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
        title: _GameTitle(gameState: gameState),
        actions: [
          SettingsButton(
            onPressed: () => showAdaptiveBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (_) => GameSettings(widget.id),
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
        middle: _GameTitle(gameState: gameState),
        trailing: SettingsButton(
          onPressed: () => showAdaptiveBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (_) => GameSettings(widget.id),
          ),
        ),
      ),
      child: body,
    );
  }
}

class _GameTitle extends ConsumerWidget {
  const _GameTitle({
    required this.gameState,
  });

  final GameState? gameState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meta = gameState?.game.meta;
    if (meta == null) {
      return const SizedBox.shrink();
    }
    final mode =
        meta.rated ? ' • ${context.l10n.rated}' : ' • ${context.l10n.casual}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          meta.perf.icon,
          color: DefaultTextStyle.of(context).style.color,
        ),
        const SizedBox(width: 4.0),
        if (gameState?.game.clock != null)
          Text(
            '${TimeIncrement(gameState!.game.clock!.initial.inSeconds, gameState!.game.clock!.increment.inSeconds).display}$mode',
          )
        else
          Text('${meta.perf.title}$mode'),
      ],
    );
  }
}
