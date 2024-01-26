import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_loading_board.dart';
import 'package:lichess_mobile/src/view/game/lobby_screen.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

import 'game_body.dart';
import 'game_common_widgets.dart';

part 'standalone_game_screen.freezed.dart';

@freezed
class InitialStandaloneGameParams with _$InitialStandaloneGameParams {
  const factory InitialStandaloneGameParams({
    required GameFullId id,
    String? fen,
    Move? lastMove,
    Side? orientation,
  }) = _InitialStandaloneGameParams;
}

/// Screen for already created games loaded directly from the game id.
///
/// Such games are issued from challenges, tournaments, or any other source which
/// provides a game id.
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
    with ImmersiveMode {
  final _whiteClockKey = GlobalKey(debugLabel: 'whiteClockOnGameScreen');
  final _blackClockKey = GlobalKey(debugLabel: 'blackClockOnGameScreen');

  late GameFullId _gameId;

  @override
  void initState() {
    super.initState();
    _gameId = widget.params.id;
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: GameAppBar(id: _gameId),
        body: GameBody(
          id: _gameId,
          loadingBoardWidget: widget.params.id == _gameId
              ? StandaloneGameLoadingBoard(
                  fen: widget.params.fen,
                  orientation: widget.params.orientation,
                  lastMove: widget.params.lastMove,
                )
              : const StandaloneGameLoadingBoard(),
          whiteClockKey: _whiteClockKey,
          blackClockKey: _blackClockKey,
          onLoadGameCallback: _loadGame,
          onNewOpponentCallback: _onNewOpponent,
        ),
      ),
      iosBuilder: (context) => CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        navigationBar: GameCupertinoNavBar(id: _gameId),
        child: GameBody(
          id: _gameId,
          loadingBoardWidget: widget.params.id == _gameId
              ? StandaloneGameLoadingBoard(
                  fen: widget.params.fen,
                  orientation: widget.params.orientation,
                  lastMove: widget.params.lastMove,
                )
              : const StandaloneGameLoadingBoard(),
          whiteClockKey: _whiteClockKey,
          blackClockKey: _blackClockKey,
          onLoadGameCallback: _loadGame,
          onNewOpponentCallback: _onNewOpponent,
        ),
      ),
    );
  }

  void _loadGame(GameFullId id) {
    setState(() {
      _gameId = id;
    });
  }

  void _onNewOpponent(PlayableGame game) {
    final savedSetup = ref.read(gameSetupPreferencesProvider);
    pushReplacementPlatformRoute(
      context,
      rootNavigator: true,
      builder: (_) => LobbyScreen(
        seek: GameSeek.newOpponentFromGame(game, savedSetup),
      ),
    );
  }
}
