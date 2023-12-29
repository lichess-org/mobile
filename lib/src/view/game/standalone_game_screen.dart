import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

import 'game_body.dart';
import 'game_common_widgets.dart';

/// Screen for already created games loaded directly from the game id.
///
/// Such games are issued from challenges, tournaments, or any other source which
/// provides a game id.
/// There is no way to get a new opponent from this screen.
class StandaloneGameScreen extends ConsumerStatefulWidget {
  const StandaloneGameScreen({
    required this.params,
    super.key,
  });

  final InitialStandaloneGameParams params;

  @override
  ConsumerState<StandaloneGameScreen> createState() =>
      _StandaloneGameScreenState();
}

class _StandaloneGameScreenState extends ConsumerState<StandaloneGameScreen>
    with RouteAware, ImmersiveMode {
  final _whiteClockKey = GlobalKey(debugLabel: 'whiteClockOnGameScreen');
  final _blackClockKey = GlobalKey(debugLabel: 'blackClockOnGameScreen');

  late GameFullId _gameId;

  @override
  void initState() {
    super.initState();
    _gameId = widget.params.id;
  }

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
    return PlatformWidget(
      androidBuilder: (context) => _androidBuilder(
        context,
        gameId: _gameId,
      ),
      iosBuilder: (context) => _iosBuilder(
        context,
        gameId: _gameId,
      ),
    );
  }

  Widget _androidBuilder(
    BuildContext context, {
    required GameFullId gameId,
  }) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: GameAppBar(id: gameId),
      body: GameBody(
        initialStandAloneParams: widget.params,
        id: gameId,
        whiteClockKey: _whiteClockKey,
        blackClockKey: _blackClockKey,
        loadGame: _loadGame,
      ),
    );
  }

  Widget _iosBuilder(
    BuildContext context, {
    required GameFullId gameId,
  }) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: GameCupertinoNavBar(id: gameId),
      child: GameBody(
        initialStandAloneParams: widget.params,
        id: gameId,
        whiteClockKey: _whiteClockKey,
        blackClockKey: _blackClockKey,
        loadGame: _loadGame,
      ),
    );
  }

  void _loadGame(GameFullId id) {
    setState(() {
      _gameId = id;
    });
  }
}
