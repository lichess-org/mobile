import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/game/online_game.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';

import 'game_body.dart';
import 'game_common_widgets.dart';

/// Screen for already created games loaded directly from the game id.
///
/// Such games are issued from challenges, tournaments, or any other source which
/// provides a game id.
/// There is no way to get a new opponent from this screen.
///
/// This screen watches the [onlineGameProvider] for the game id.
class StandaloneGameScreen extends ConsumerStatefulWidget {
  const StandaloneGameScreen({
    required this.initialId,
    required this.initialOrientation,
    this.initialFen,
    this.lastMove,
    super.key,
  });

  final GameFullId initialId;
  final Side initialOrientation;
  final String? initialFen;
  final Move? lastMove;

  @override
  ConsumerState<StandaloneGameScreen> createState() =>
      _StandaloneGameScreenState();
}

class _StandaloneGameScreenState extends ConsumerState<StandaloneGameScreen>
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
    ref.invalidate(accountProvider);
    ref.invalidate(accountRecentGamesProvider);
    ref.invalidate(accountActivityProvider);
  }

  @override
  Widget build(BuildContext context) {
    final gameId = ref.watch(onlineGameProvider(widget.initialId));
    return PlatformWidget(
      androidBuilder: (context) => _androidBuilder(
        context,
        gameId: gameId,
      ),
      iosBuilder: (context) => _iosBuilder(
        context,
        gameId: gameId,
      ),
    );
  }

  Widget _androidBuilder(
    BuildContext context, {
    required GameFullId gameId,
  }) {
    return Scaffold(
      appBar: GameAppBar(id: gameId),
      body: GameBody(
        initialStandAloneId: widget.initialId,
        id: gameId,
        whiteClockKey: _whiteClockKey,
        blackClockKey: _blackClockKey,
      ),
    );
  }

  Widget _iosBuilder(
    BuildContext context, {
    required GameFullId gameId,
  }) {
    return CupertinoPageScaffold(
      navigationBar: GameCupertinoNavBar(id: gameId),
      child: GameBody(
        initialStandAloneId: widget.initialId,
        id: gameId,
        whiteClockKey: _whiteClockKey,
        blackClockKey: _blackClockKey,
      ),
    );
  }
}
